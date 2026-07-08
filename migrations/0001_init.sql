-- Regal Family PNW RV Trip — D1 schema
-- Everything the site reads/writes lives here so it persists live.

CREATE TABLE IF NOT EXISTS bookings (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  day_id TEXT NOT NULL,              -- e.g. 'aug4'
  date_label TEXT NOT NULL,          -- e.g. 'Tue · Aug 4'
  name TEXT NOT NULL,                -- campground / lodging name
  site TEXT,                         -- site number
  confirmation TEXT,                 -- conf / reservation number
  status TEXT NOT NULL DEFAULT 'booked', -- booked | backup | shabbat | planned
  hookups TEXT,                      -- full | electric-water | dry | none
  check_in TEXT,
  check_out TEXT,
  address TEXT,
  phone TEXT,
  notes TEXT,
  updated_at TEXT DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS itinerary_days (
  day_id TEXT PRIMARY KEY,           -- 'jul27' ... 'aug9'
  date_label TEXT NOT NULL,
  title TEXT NOT NULL,
  status TEXT NOT NULL,              -- planned | partial | missing | shabbat
  sort_order INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS events (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  day_id TEXT NOT NULL,
  time_label TEXT,
  label TEXT NOT NULL,
  note TEXT,
  link TEXT,
  link_label TEXT,
  verify INTEGER DEFAULT 0,          -- 1 = drive time / detail needs live check
  sort_order INTEGER NOT NULL,
  FOREIGN KEY (day_id) REFERENCES itinerary_days(day_id)
);

CREATE TABLE IF NOT EXISTS open_items (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  text TEXT NOT NULL,
  category TEXT,                     -- logistics | tank | food | transport
  resolved INTEGER DEFAULT 0,
  updated_at TEXT DEFAULT (datetime('now'))
);

-- Chat assistant history, so conversations persist across sessions/devices.
CREATE TABLE IF NOT EXISTS chat_messages (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  role TEXT NOT NULL,                -- user | assistant
  content TEXT NOT NULL,
  created_at TEXT DEFAULT (datetime('now'))
);

-- An audit log of edits the assistant makes to the itinerary, so nothing changes silently.
CREATE TABLE IF NOT EXISTS change_log (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  summary TEXT NOT NULL,
  detail TEXT,
  created_at TEXT DEFAULT (datetime('now'))
);
