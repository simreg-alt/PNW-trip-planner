/**
 * Regal Family Trip Command Center — Cloudflare Worker
 *
 * Serves the static app (public/) and provides:
 *   GET  /api/state           -> full itinerary + bookings + open items
 *   POST /api/booking         -> upsert a booking
 *   POST /api/open-item       -> add / resolve an open item
 *   POST /api/chat            -> Claude-powered assistant (web search + itinerary edit tools)
 *   GET  /api/chat/history    -> persisted chat history
 *
 * Secrets (set with `wrangler secret put`):
 *   ANTHROPIC_API_KEY   (required — the assistant)
 * Bindings (wrangler.jsonc):
 *   DB      D1 database
 *   ASSETS  static assets (public/)
 */

const MODEL = "claude-opus-4-8"; // assistant model; swap as needed

export default {
  async fetch(request, env) {
    const url = new URL(request.url);
    const { pathname } = url;

    // ---- API routes ----
    if (pathname.startsWith("/api/")) {
      try {
        if (pathname === "/api/state" && request.method === "GET")
          return json(await getState(env));
        if (pathname === "/api/booking" && request.method === "POST")
          return json(await upsertBooking(env, await request.json()));
        if (pathname === "/api/booking/delete" && request.method === "POST")
          return json(await deleteBooking(env, await request.json()));
        if (pathname === "/api/open-item" && request.method === "POST")
          return json(await openItem(env, await request.json()));
        if (pathname === "/api/chat/history" && request.method === "GET")
          return json(await chatHistory(env));
        if (pathname === "/api/chat" && request.method === "POST")
          return await chat(env, await request.json());
        return json({ error: "not found" }, 404);
      } catch (err) {
        return json({ error: String(err && err.message || err) }, 500);
      }
    }

    // ---- Static assets ----
    return env.ASSETS.fetch(request);
  },
};

const json = (obj, status = 200) =>
  new Response(JSON.stringify(obj), {
    status,
    headers: { "content-type": "application/json" },
  });

// ---------- Data access ----------
async function getState(env) {
  const [days, events, bookings, items, changes] = await Promise.all([
    env.DB.prepare("SELECT * FROM itinerary_days ORDER BY sort_order").all(),
    env.DB.prepare("SELECT * FROM events ORDER BY day_id, sort_order").all(),
    env.DB.prepare("SELECT * FROM bookings ORDER BY id").all(),
    env.DB.prepare("SELECT * FROM open_items WHERE resolved = 0 ORDER BY id").all(),
    env.DB.prepare("SELECT * FROM change_log ORDER BY id DESC LIMIT 25").all(),
  ]);
  return {
    days: days.results,
    events: events.results,
    bookings: bookings.results,
    openItems: items.results,
    changeLog: changes.results,
  };
}

async function upsertBooking(env, b) {
  // D1 rejects `undefined` bindings, so coerce any missing field to null.
  const v = (x) => (x === undefined ? null : x);
  if (b.id) {
    // COALESCE so a partial edit (e.g. the assistant changing only `notes`)
    // never wipes fields it didn't mention — that's how addresses got lost.
    await env.DB.prepare(
      `UPDATE bookings SET
         name=COALESCE(?,name), site=COALESCE(?,site), confirmation=COALESCE(?,confirmation),
         status=COALESCE(?,status), hookups=COALESCE(?,hookups),
         check_in=COALESCE(?,check_in), check_out=COALESCE(?,check_out),
         address=COALESCE(?,address), phone=COALESCE(?,phone), notes=COALESCE(?,notes),
         updated_at=datetime('now')
       WHERE id=?`
    ).bind(v(b.name), v(b.site), v(b.confirmation), v(b.status), v(b.hookups),
           v(b.check_in), v(b.check_out), v(b.address), v(b.phone), v(b.notes), b.id).run();
  } else {
    await env.DB.prepare(
      `INSERT INTO bookings (day_id, date_label, name, site, confirmation, status,
         hookups, check_in, check_out, address, phone, notes)
       VALUES (?,?,?,?,?,?,?,?,?,?,?,?)`
      // date_label is NOT NULL — fall back to the day_id if the model omits it.
    ).bind(v(b.day_id), b.date_label || b.day_id || "", v(b.name), v(b.site), v(b.confirmation),
           b.status || "booked", v(b.hookups), v(b.check_in), v(b.check_out),
           v(b.address), v(b.phone), v(b.notes)).run();
  }
  await logChange(env, `Booking updated: ${b.name}`, JSON.stringify(b));
  return { ok: true };
}

async function deleteBooking(env, b) {
  if (b.id) {
    await env.DB.prepare("DELETE FROM bookings WHERE id=?").bind(b.id).run();
    await logChange(env, `Booking deleted (id ${b.id})`, null);
  }
  return { ok: true };
}

async function openItem(env, it) {
  if (it.deleteId) {
    await env.DB.prepare("DELETE FROM open_items WHERE id=?").bind(it.deleteId).run();
  } else if (it.resolveId) {
    await env.DB.prepare("UPDATE open_items SET resolved=1, updated_at=datetime('now') WHERE id=?")
      .bind(it.resolveId).run();
  } else if (it.reopenId) {
    await env.DB.prepare("UPDATE open_items SET resolved=0, updated_at=datetime('now') WHERE id=?")
      .bind(it.reopenId).run();
  } else if (it.editId) {
    await env.DB.prepare("UPDATE open_items SET text=?, category=?, updated_at=datetime('now') WHERE id=?")
      .bind(it.text || "", it.category || "logistics", it.editId).run();
  } else if (it.text) {
    await env.DB.prepare("INSERT INTO open_items (text, category) VALUES (?,?)")
      .bind(it.text, it.category || "logistics").run();
  }
  return { ok: true };
}

async function chatHistory(env) {
  const rows = await env.DB.prepare(
    "SELECT role, content, created_at FROM chat_messages ORDER BY id DESC LIMIT 100"
  ).all();
  return { messages: rows.results.reverse() };
}

async function logChange(env, summary, detail) {
  await env.DB.prepare("INSERT INTO change_log (summary, detail) VALUES (?,?)")
    .bind(summary, detail || null).run();
}

// ---------- The Claude assistant ----------
// Tools: web_search (Anthropic server tool) + custom itinerary-edit tools the model can call.
const TOOLS = [
  { type: "web_search_20250305", name: "web_search" },
  {
    name: "update_booking",
    description: "Edit an existing lodging/campground booking (pass its id) or add a new one (omit id).",
    input_schema: {
      type: "object",
      properties: {
        id: { type: "integer", description: "id of an existing booking to edit; omit to add a new booking" },
        day_id: { type: "string", description: "e.g. aug4" },
        date_label: { type: "string" },
        name: { type: "string" },
        site: { type: "string" },
        confirmation: { type: "string" },
        status: { type: "string", enum: ["booked", "backup", "shabbat", "planned"] },
        hookups: { type: "string" },
        check_in: { type: "string" },
        check_out: { type: "string" },
        address: { type: "string", description: "full street address incl. city, state, ZIP" },
        phone: { type: "string" },
        notes: { type: "string" },
      },
      required: ["name"],
    },
  },
  {
    name: "delete_booking",
    description: "Permanently delete a booking by its id.",
    input_schema: {
      type: "object",
      properties: { id: { type: "integer" } },
      required: ["id"],
    },
  },
  {
    name: "add_open_item",
    description: "Add an open logistics item / to-do for the trip.",
    input_schema: {
      type: "object",
      properties: {
        text: { type: "string" },
        category: { type: "string", enum: ["logistics", "tank", "food", "transport"] },
      },
      required: ["text"],
    },
  },
  {
    name: "resolve_open_item",
    description: "Mark an open item / to-do as done by its id (removes it from the open list).",
    input_schema: {
      type: "object",
      properties: { id: { type: "integer" } },
      required: ["id"],
    },
  },
  {
    name: "update_open_item",
    description: "Reword or recategorize an existing open item by its id.",
    input_schema: {
      type: "object",
      properties: {
        id: { type: "integer" },
        text: { type: "string" },
        category: { type: "string", enum: ["logistics", "tank", "food", "transport"] },
      },
      required: ["id", "text"],
    },
  },
  {
    name: "delete_open_item",
    description: "Permanently delete an open item by its id. Prefer resolve_open_item unless it was a mistake.",
    input_schema: {
      type: "object",
      properties: { id: { type: "integer" } },
      required: ["id"],
    },
  },
];

const CUSTOM_TOOL_NAMES = [
  "update_booking", "delete_booking", "add_open_item",
  "resolve_open_item", "update_open_item", "delete_open_item",
];

async function chat(env, body) {
  const userMsg = (body.message || "").slice(0, 4000);
  if (!userMsg) return json({ error: "empty message" }, 400);

  // Persist the user's message
  await env.DB.prepare("INSERT INTO chat_messages (role, content) VALUES ('user', ?)")
    .bind(userMsg).run();

  // Build context: current trip state + recent history
  const state = await getState(env);
  const history = (await chatHistory(env)).messages.slice(-20);

  const system = buildSystemPrompt(state);
  const messages = history.map((m) => ({ role: m.role, content: m.content }));

  // Agent loop: allow tool use (web search + itinerary edits) up to a few rounds.
  let finalText = "";
  let convo = [...messages];
  for (let round = 0; round < 5; round++) {
    const resp = await fetch("https://api.anthropic.com/v1/messages", {
      method: "POST",
      headers: {
        "content-type": "application/json",
        "x-api-key": env.ANTHROPIC_API_KEY,
        "anthropic-version": "2023-06-01",
      },
      body: JSON.stringify({
        model: MODEL,
        max_tokens: 1500,
        system,
        tools: TOOLS,
        messages: convo,
      }),
    });
    const data = await resp.json();
    if (data.error) return json({ error: data.error.message || "model error" }, 502);

    // Collect any text
    const textBlocks = (data.content || []).filter((c) => c.type === "text");
    if (textBlocks.length) finalText = textBlocks.map((t) => t.text).join("\n");

    // Handle custom tool calls (web_search is executed server-side by Anthropic automatically)
    const toolUses = (data.content || []).filter((c) => c.type === "tool_use");
    const customTools = toolUses.filter((t) => CUSTOM_TOOL_NAMES.includes(t.name));

    if (data.stop_reason !== "tool_use" || customTools.length === 0) {
      break; // done (or only web_search happened, which resolves internally)
    }

    // Execute custom tools, feed results back
    convo.push({ role: "assistant", content: data.content });
    const results = [];
    for (const t of customTools) {
      let out = "ok";
      try {
        if (t.name === "update_booking") { await upsertBooking(env, t.input); out = "Booking saved."; }
        if (t.name === "delete_booking") { await deleteBooking(env, { id: t.input.id }); out = "Booking deleted."; }
        if (t.name === "add_open_item") { await openItem(env, { text: t.input.text, category: t.input.category }); out = "Item added."; }
        if (t.name === "resolve_open_item") { await openItem(env, { resolveId: t.input.id }); out = "Item marked done."; }
        if (t.name === "update_open_item") { await openItem(env, { editId: t.input.id, text: t.input.text, category: t.input.category }); out = "Item updated."; }
        if (t.name === "delete_open_item") { await openItem(env, { deleteId: t.input.id }); out = "Item deleted."; }
      } catch (e) { out = "Error: " + e.message; }
      results.push({ type: "tool_result", tool_use_id: t.id, content: out });
    }
    convo.push({ role: "user", content: results });
  }

  await env.DB.prepare("INSERT INTO chat_messages (role, content) VALUES ('assistant', ?)")
    .bind(finalText).run();

  return json({ reply: finalText });
}

function buildSystemPrompt(state) {
  const bookings = state.bookings.map((b) =>
    `- [#${b.id}] ${b.date_label}: ${b.name}${b.site ? " (site " + b.site + ")" : ""}${b.confirmation ? " conf " + b.confirmation : ""} [${b.status}, ${b.hookups || "?"} hookups]`
  ).join("\n");
  const items = state.openItems.map((i) => `- [#${i.id}] ${i.text}`).join("\n");
  return `You are the trip assistant for the Regal family's Pacific Northwest RV trip (Jul 27–Aug 9, 2026).
Family of 6 (2 adults + kids 9, 7, 3, 1), Orthodox Jewish (kosher food; no RV travel Fri eve–Sat night; modest/quiet beaches).
29-ft Class C RV, paved roads only (rental rule). Route: Seattle → Olympic NP → Portland (Shabbat 1) → Oregon coast → Redwoods → Bodega Bay → San Leandro drop-off → Palo Alto (Shabbat 2).

CURRENT BOOKINGS:
${bookings}

OPEN ITEMS:
${items}

The [#id] shown before each booking and open item is its database id — pass it to the edit tools.
You can: answer questions about the itinerary, use web_search for live info (weather, road/tide conditions, hours, prices), and edit the plan with these tools:
- update_booking — edit an existing booking (pass its [#id]) or add a new one (omit id)
- delete_booking — remove a booking by [#id]
- add_open_item — add a to-do
- resolve_open_item — mark a to-do done by [#id]
- update_open_item — reword/recategorize a to-do by [#id]
- delete_open_item — delete a to-do by [#id] (prefer resolve unless it was a mistake)
When you change something, state clearly what you changed. Never give drive times from memory — search or tell the user it needs live verification. Keep answers concise and practical. Respect the family's constraints (kosher, Shabbat timing, modesty, paved roads, kid pacing) in every suggestion.`;
}
