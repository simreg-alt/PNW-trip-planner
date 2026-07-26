# Backing up live trip data into this repo

**Live trip data lives in D1, not in git.** The chat assistant and the in-app
edit buttons write to D1 immediately — that is the source of truth, and it is
correct that those edits do *not* create git commits (git holds the app's
**code**; D1 holds the **data**).

The one time git *is* relevant to data is **disaster recovery**: if the D1
database were deleted or corrupted, `migrations/setup-db.sql` would only
restore the original seed, not everything changed since. So we keep a periodic
snapshot of the live data here.

## Refresh the snapshot

Ask Claude: *"snapshot the trip data to the repo."* It reads the live D1 tables
and rewrites `migrations/data-snapshot.sql`, then commits it.

Or do it yourself with wrangler:

```bash
wrangler d1 export regal-trip --remote --output migrations/data-snapshot.sql
git add migrations/data-snapshot.sql && git commit -m "Snapshot trip data" && git push
```

## Restore from a snapshot

Paste the contents of `migrations/data-snapshot.sql` into the D1 console
(Cloudflare dashboard → Storage & Databases → D1 → regal-trip → Console),
or:

```bash
wrangler d1 execute regal-trip --remote --file migrations/data-snapshot.sql
```

The snapshot drops and recreates rows, so restoring returns the trip to exactly
the state it was in when the snapshot was taken.
