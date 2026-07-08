# Deploy the Trip Command Center to Cloudflare

Hand this whole folder to Claude Code (or run it yourself). ~10 minutes.

## Prerequisites
- Node 18+ and npm
- A Cloudflare account (you have one — Workers already deployed)
- Your Anthropic API key (from console.anthropic.com)

## Steps

### 1. Install tooling
```bash
cd trip-site
npm install -g wrangler
npm install
wrangler login          # opens browser, authorize
```

### 2. Create the D1 database
```bash
wrangler d1 create regal-trip
```
Copy the `database_id` it prints into **wrangler.jsonc** (replace `PASTE_DATABASE_ID_AFTER_CREATE`).

### 3. Create the schema + seed the current trip data
```bash
wrangler d1 migrations apply regal-trip --remote
```
This runs `migrations/0001_init.sql` and `0002_seed.sql` against the live DB.

### 4. Store the Anthropic key as a secret (never in code)
```bash
wrangler secret put ANTHROPIC_API_KEY
# paste your key when prompted
```

### 5. Deploy
```bash
wrangler deploy
```
You'll get a URL like `https://regal-trip-command-center.<your-subdomain>.workers.dev`.
That URL is accessible from anywhere — phone, laptop, share with Shaindy.

### 6. (Optional) Custom domain
In the Cloudflare dashboard → Workers & Pages → your worker → Settings → Domains & Routes,
add a route like `trip.yourdomain.com`.

## How updates work (important — read this)
- **Live data** (bookings, chat, open items) is stored in D1 and updates in real time as
  you or the in-site assistant change things. No redeploy needed for data changes.
- **The app code/design** only changes when you redeploy (`wrangler deploy`). When we
  revise the plan *in the Claude chat*, that chat can't push to your site automatically —
  ask for an updated build and re-run `wrangler deploy`, OR just make the change through
  the in-site AI assistant, which writes straight to D1.

## The AI assistant
- Chat panel is built into the site (bottom-right).
- It can: answer itinerary questions, search the web live (weather/tides/hours/prices),
  and edit bookings + add to-dos (writes to D1, logged in change_log).
- It's powered by your Anthropic key via the Worker — the key stays server-side, safe.

## Cost sanity
- Workers + D1 free tier easily covers personal use.
- The only metered cost is Anthropic API usage from the assistant (a few cents per chat).
