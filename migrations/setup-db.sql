-- Regal Trip — full database setup (schema + seed). Paste into the D1 console.
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

-- Seed the current state of the trip (as of this build).
-- Bookings (the confirmed lodging chain)
INSERT INTO bookings (day_id, date_label, name, site, confirmation, status, hookups, check_in, check_out, address, phone, notes) VALUES
 ('jul27','Mon · Jul 27','Bainbridge Island host site',NULL,NULL,'booked','unknown',NULL,NULL,'7686 High School Rd NE, Bainbridge Island, WA',NULL,'Night 1 after landing. Confirm 29-ft access + hookups.'),
 ('jul28','Tue · Jul 28','RV@Olympic','back-in (assigned at check-in)','#2825','booked','unknown','1:00 PM','11:00 AM','191 Old Deer Park Rd, Port Angeles, WA','360-209-8172','Walmart minutes away; resupply + water top-off.'),
 ('jul29','Wed · Jul 29','Hard Rain Cafe',NULL,NULL,'booked','electric','1:00 PM','12:00 PM','5763 Upper Hoh Rd, Forks, WA','360-374-9288','Electric, no sewer. Add 4 kids to booking. Dawn access to Hoh.'),
 ('jul30','Thu · Jul 30','Rain Forest Resort Village',NULL,NULL,'booked','full','1:00 PM','11:00 AM','516 S Shore Rd, Quinault, WA','360-288-2535','Lakeside, on-site laundry, world''s largest Sitka spruce nearby.'),
 ('jul31','Fri · Jul 31','Portland — Shabbat 1 (private residence)',NULL,NULL,'shabbat','n/a',NULL,NULL,'7047 SW 15th Ave, Portland, OR','503-515-8138','Host: Frumie Diskind. RV parked Fri eve–Sat night.'),
 ('aug2','Sun · Aug 2','Tillicum Campground','55, Loop 3','0811830581-1','booked','electric-water','2:00 PM','11:00 AM','Siuslaw National Forest, Yachats, OR',NULL,'~1/10 mi to shore. Guided surfperch. No dump/showers.'),
 ('aug3','Mon · Aug 3','Bullards Beach State Park','B61, Loop B','#2-38261538','booked','full','4:00 PM','1:00 PM','Bandon, OR',NULL,'Dump/flush/showers night. Lighthouse path.'),
 ('aug4','Tue · Aug 4','Harris Beach State Park','B36, Loop B','#2-38267002','booked','full','4:00 PM','1:00 PM','Brookings, OR',NULL,'Won cancellation hunt. Sea stacks + Bird Island. Cancel Turtle Rock #694434.'),
 ('aug5','Wed · Aug 5','Giant Redwoods RV & Cabin','9 (Full Hookup Pull-thru 68'')','#359312','booked','full','1:00 PM','11:00 AM','400 Myers Ave, Myers Flat, CA','707-943-9999','On the Avenue of the Giants. Gates close 9 PM. NO cell service. Eel River swim hole. Paid 2 nights, using 1.'),
 ('aug6','Thu · Aug 6','Doran Regional Park','Jetty 118','154260705-434830','booked','dry','2:00 PM','12:00 PM','Bodega Bay, CA',NULL,'Dry — on-site dump + potable. Dump/fill Fri AM before drop-off. Bay views.'),
 ('aug7','Fri · Aug 7','Palo Alto — Shabbat 2 (Airbnb)',NULL,NULL,'shabbat','n/a',NULL,NULL,'3759 Redwood Cir, Palo Alto, CA',NULL,'After San Leandro RV drop-off. 2nd frozen shipment Fri AM.');

-- Open logistics items
INSERT INTO open_items (text, category) VALUES
 ('Cancel Turtle Rock #694434 (redundant after Harris Beach win) — save the credit','logistics'),
 ('Cancel duplicate Quileute Oceanside booking (Jul 29)','logistics'),
 ('Call Hard Rain 360-374-9288 to add 4 kids to booking','logistics'),
 ('Friday Aug 7 drop-off transport: two UberXL, own car seats, San Leandro → Palo Alto','transport'),
 ('Confirm exact Road Bear latest Friday drop time (depot closes 5 PM)','transport'),
 ('Sunday Aug 9 SFO run + JFK→Staten Island late-night pickup','transport'),
 ('Pull Aug 2 Yachats tide chart to time guided surfperch','logistics'),
 ('Confirm both Shabbat candle-lighting times (Portland Jul 31, Palo Alto Aug 7)','logistics'),
 ('Two LA frozen-food shipments (Portland Fri Jul 31, Palo Alto Fri Aug 7)','food'),
 ('Car seats for RV + airport transfers (bringing own 2 from home)','transport');

-- Itinerary days (status matches current plan)
INSERT INTO itinerary_days (day_id, date_label, title, status, sort_order) VALUES
 ('jul27','Mon · Jul 27','Land Seattle → RV pickup → Bainbridge','partial',1),
 ('jul28','Tue · Jul 28','Hurricane Ridge + Madison Falls → RV@Olympic','planned',2),
 ('jul29','Wed · Jul 29','Lake Crescent → Sol Duc → Hard Rain','partial',3),
 ('jul30','Thu · Jul 30','Dawn at the Hoh → coast → Lake Quinault','planned',4),
 ('jul31','Fri · Jul 31','Drive to Portland — arrive before Shabbat','partial',5),
 ('aug1','Sat · Aug 1','Shabbat in Portland — RV parked','shabbat',6),
 ('aug2','Sun · Aug 2','Portland → surfperch + Cape Perpetua → Tillicum','partial',7),
 ('aug3','Mon · Aug 3','Tidepools → Sea Lion Caves → dunes → Bullards Beach','planned',8),
 ('aug4','Tue · Aug 4','Sand dollars → Boardman → Harris Beach','planned',9),
 ('aug5','Wed · Aug 5','Smith River edge → canopy → Avenue → Giant Redwoods','planned',10),
 ('aug6','Thu · Aug 6','101 south → Goat Rock seals → Doran','planned',11),
 ('aug7','Fri · Aug 7','Doran → RV drop-off → Palo Alto before Shabbat','partial',12),
 ('aug8','Sat · Aug 8','Shabbat in Palo Alto','shabbat',13),
 ('aug9','Sun · Aug 9','Fly home: SFO → JFK','partial',14);

-- A compact set of key events per day (the assistant + web can fill more later).
INSERT INTO events (day_id, time_label, label, note, sort_order) VALUES
 ('jul27','12:43 PM','AS 230 lands SEA','6 people + bags + car seats; out ~1:30 PM. Road Bear ~10 min away.',1),
 ('jul27','~2:15 PM','Road Bear RV pickup','~1 hr walkthrough; fill fresh tank before leaving.',2),
 ('jul27','Evening','Bainbridge Island overnight','Lean: drive around via Tacoma vs. rush-hour ferry.',3),
 ('jul28','Night','RV@Olympic #2825','Back-in site at check-in; Walmart nearby for resupply + water.',1),
 ('jul29','PM','Hard Rain Cafe (booked)','Electric, no sewer; dawn access to Hoh. Add 4 kids; cancel Quileute.',1),
 ('jul30','8 AM','Hall of Mosses','Minutes from Hard Rain — beat the gate queue.',1),
 ('jul30','Night','Rain Forest Resort Village (booked)','Lakeside, laundry, dump/fill here. Shortens Friday.',2),
 ('jul31','Early AM','Depart Quinault → Portland','~3.5–4.5 hr RV (verify). Backward-schedule from candle lighting.',1),
 ('jul31','PM','Receive LA frozen shipment','Confirm Frumie can receive + freeze.',2),
 ('aug2','PM','Guided surfperch (kosher, whole family)','Gear provided; tide-timed. Cape Perpetua fallback.',1),
 ('aug2','Night','Tillicum site 55 (booked)','E/W hookup, ~1/10 mi to shore.',2),
 ('aug3','Day','Bob Creek tidepools · Sea Lion Caves · Florence dunes','Sandboarding — the big kid hour.',1),
 ('aug3','Night','Bullards Beach B61 (booked)','Full hookup; dump/showers night.',2),
 ('aug4','7:30 AM','Face Rock sand dollars','Low tide, before crowds.',1),
 ('aug4','Night','Harris Beach B36 (booked!)','Sea stacks + Bird Island. Cancel Turtle Rock #694434.',2),
 ('aug5','AM','Smith River edge-wade (not a swim)','Cold moving water — big kids ankle-deep only.',1),
 ('aug5','Night','Giant Redwoods #359312','On the Avenue; gates 9 PM; no cell service; Eel River swim hole.',2),
 ('aug6','PM','Goat Rock harbor seals (Jenner)','Cold, foggy, wild — the wildlife closer.',1),
 ('aug6','Night','Doran Jetty 118 (booked)','Dry — dump/fill Fri AM before drop-off.',2),
 ('aug7','AM','Doran → San Leandro drop-off','~2–2.5 hr. Dump+fuel first. Then 2 UberXL → Palo Alto (own car seats).',1),
 ('aug7','~7:50 PM','Candle lighting, Palo Alto (verify)','2nd frozen shipment arrives AM.',2),
 ('aug9','1:38 PM','AS 42 SFO T1 → JFK T8 10:26 PM','Leave Airbnb ~10:30 AM. Pre-arrange JFK→Staten Island pickup.',1);
