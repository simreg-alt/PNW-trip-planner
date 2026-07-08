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

## Auto-deploy on push (GitHub Actions)
`.github/workflows/deploy.yml` redeploys the Worker automatically on every push to
the active branch (currently `claude/new-session-tqvlk0`; `main` is also wired up
for when the project moves there) and can be run manually from the Actions tab.
One-time setup (all done in websites — no terminal needed):

1. Create the D1 database in the Cloudflare dashboard (Storage & Databases → D1 →
   Create database, name it exactly `regal-trip`) and copy its **Database ID**.
   Paste that ID into **wrangler.jsonc** (replace `PASTE_DATABASE_ID_AFTER_CREATE`),
   editing the file directly on GitHub.
2. Add three GitHub repo secrets (Settings → Secrets and variables → Actions →
   New repository secret):
   - `CLOUDFLARE_API_TOKEN` — from dashboard → My Profile → API Tokens → "Edit
     Cloudflare Workers" template.
   - `CLOUDFLARE_ACCOUNT_ID` — from Workers & Pages → right sidebar.
   - `ANTHROPIC_API_KEY` — from console.anthropic.com → API Keys.

Once the secrets exist and the Database ID is in place, every push (or a manual
run from the Actions tab) applies migrations, deploys the Worker, and uploads the
Anthropic key as a Worker secret — no local wrangler needed.

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
