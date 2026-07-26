-- Live trip data snapshot (restore file).
-- Generated from the regal-trip D1 database via SQLite quote(), so all
-- literals are escaped exactly as D1 stored them.
-- Regenerate/restore: see scripts/snapshot-d1.md
-- Requires the schema from migrations/0001_init.sql to exist first.

DELETE FROM events;
DELETE FROM bookings;
DELETE FROM open_items;
DELETE FROM itinerary_days;

INSERT INTO itinerary_days (day_id,date_label,title,status,sort_order) VALUES ('jul27','Mon · Jul 27','Land Seattle → RV pickup → Bainbridge','partial',1);
INSERT INTO itinerary_days (day_id,date_label,title,status,sort_order) VALUES ('jul28','Tue · Jul 28','Hurricane Ridge + Madison Falls → RV@Olympic','planned',2);
INSERT INTO itinerary_days (day_id,date_label,title,status,sort_order) VALUES ('jul29','Wed · Jul 29','Lake Crescent → Sol Duc → Hard Rain','partial',3);
INSERT INTO itinerary_days (day_id,date_label,title,status,sort_order) VALUES ('jul30','Thu · Jul 30','Dawn at the Hoh → coast → Lake Quinault','planned',4);
INSERT INTO itinerary_days (day_id,date_label,title,status,sort_order) VALUES ('jul31','Fri · Jul 31','Drive to Portland — arrive before Shabbat','partial',5);
INSERT INTO itinerary_days (day_id,date_label,title,status,sort_order) VALUES ('aug1','Sat · Aug 1','Shabbat in Portland — RV parked','shabbat',6);
INSERT INTO itinerary_days (day_id,date_label,title,status,sort_order) VALUES ('aug2','Sun · Aug 2','Portland → surfperch + Cape Perpetua → Tillicum','partial',7);
INSERT INTO itinerary_days (day_id,date_label,title,status,sort_order) VALUES ('aug3','Mon · Aug 3','Tidepools → Sea Lion Caves → dunes → Bullards Beach','planned',8);
INSERT INTO itinerary_days (day_id,date_label,title,status,sort_order) VALUES ('aug4','Tue · Aug 4','Sand dollars → Boardman → Harris Beach','planned',9);
INSERT INTO itinerary_days (day_id,date_label,title,status,sort_order) VALUES ('aug5','Wed · Aug 5','Smith River edge → canopy → Avenue → Giant Redwoods','planned',10);
INSERT INTO itinerary_days (day_id,date_label,title,status,sort_order) VALUES ('aug6','Thu · Aug 6','101 south → Goat Rock seals → Doran','planned',11);
INSERT INTO itinerary_days (day_id,date_label,title,status,sort_order) VALUES ('aug7','Fri · Aug 7','Doran → RV drop-off → Palo Alto before Shabbat','partial',12);
INSERT INTO itinerary_days (day_id,date_label,title,status,sort_order) VALUES ('aug8','Sat · Aug 8','Shabbat in Palo Alto','shabbat',13);
INSERT INTO itinerary_days (day_id,date_label,title,status,sort_order) VALUES ('aug9','Sun · Aug 9','Fly home: SFO → JFK','partial',14);

INSERT INTO bookings (id,day_id,date_label,name,site,confirmation,status,hookups,check_in,check_out,address,phone,notes) VALUES (1,'jul27','Mon · Jul 27','Fay Bainbridge Park Campground','RV Site 03',NULL,'booked',NULL,NULL,NULL,'15446 Sunrise Dr NE, Bainbridge Island, WA 98110','206-842-3931','15446 Sunrise Drive NE, Bainbridge Island, WA 98110');
INSERT INTO bookings (id,day_id,date_label,name,site,confirmation,status,hookups,check_in,check_out,address,phone,notes) VALUES (2,'jul28','Tue · Jul 28','RV@Olympic','back-in (assigned at check-in)','2825','booked',NULL,NULL,NULL,'191 Old Deer Park Rd, Port Angeles, WA 98362','360-209-8172',NULL);
INSERT INTO bookings (id,day_id,date_label,name,site,confirmation,status,hookups,check_in,check_out,address,phone,notes) VALUES (3,'jul29','Wed · Jul 29','Hard Rain Cafe',NULL,NULL,'booked','electric','1:00 PM','12:00 PM','5763 Upper Hoh Rd, Forks, WA','360-374-9288','Electric, no sewer. Add 4 kids to booking. Dawn access to Hoh.');
INSERT INTO bookings (id,day_id,date_label,name,site,confirmation,status,hookups,check_in,check_out,address,phone,notes) VALUES (4,'jul30','Thu · Jul 30','Rain Forest Resort Village',NULL,NULL,'booked','full','1:00 PM','11:00 AM','516 S Shore Rd, Quinault, WA','360-288-2535','Lakeside, on-site laundry, world''s largest Sitka spruce nearby.');
INSERT INTO bookings (id,day_id,date_label,name,site,confirmation,status,hookups,check_in,check_out,address,phone,notes) VALUES (5,'jul31','Fri · Jul 31','Portland — Shabbat 1 (private residence)',NULL,NULL,'shabbat','n/a',NULL,NULL,'7047 SW 15th Ave, Portland, OR','503-515-8138','Host: Frumie Diskind. RV parked Fri eve–Sat night.');
INSERT INTO bookings (id,day_id,date_label,name,site,confirmation,status,hookups,check_in,check_out,address,phone,notes) VALUES (6,'aug2','Sun · Aug 2','Tillicum Campground','55, Loop 3','0811830581-1','booked','electric-water','2:00 PM','11:00 AM','8199 Hwy 101 N, Yachats, OR 97498','541-547-3679','~1/10 mi to shore. Guided surfperch. No dump/showers.');
INSERT INTO bookings (id,day_id,date_label,name,site,confirmation,status,hookups,check_in,check_out,address,phone,notes) VALUES (7,'aug3','Mon · Aug 3','Bullards Beach State Park','B61, Loop B','#2-38261538','booked','full','4:00 PM','1:00 PM','56487 Bullards Beach Rd, Bandon, OR 97411','541-347-2209','Dump/flush/showers night. Lighthouse path.');
INSERT INTO bookings (id,day_id,date_label,name,site,confirmation,status,hookups,check_in,check_out,address,phone,notes) VALUES (8,'aug4','Tue · Aug 4','Harris Beach State Park','B36, Loop B','#2-38267002','booked','full','4:00 PM','1:00 PM','1655 Hwy 101 N, Brookings, OR 97415','541-469-2021','Won cancellation hunt. Sea stacks + Bird Island. Cancel Turtle Rock #694434.');
INSERT INTO bookings (id,day_id,date_label,name,site,confirmation,status,hookups,check_in,check_out,address,phone,notes) VALUES (9,'aug5','Wed · Aug 5','Giant Redwoods RV & Cabin','9 (Full Hookup Pull-thru 68'')','#359312','booked','full','1:00 PM','11:00 AM','400 Myers Ave, Myers Flat, CA','707-943-9999','On the Avenue of the Giants. Gates close 9 PM. NO cell service. Eel River swim hole. Paid 2 nights, using 1.');
INSERT INTO bookings (id,day_id,date_label,name,site,confirmation,status,hookups,check_in,check_out,address,phone,notes) VALUES (10,'aug6','Thu · Aug 6','Doran Regional Park','Jetty 118','154260705-434830','booked','dry','2:00 PM','12:00 PM','201 Doran Beach Rd, Bodega Bay, CA 94923','707-875-3540','Dry — on-site dump + potable. Dump/fill Fri AM before drop-off. Bay views.');
INSERT INTO bookings (id,day_id,date_label,name,site,confirmation,status,hookups,check_in,check_out,address,phone,notes) VALUES (11,'aug7','Fri · Aug 7','Palo Alto — Shabbat 2 (Airbnb)',NULL,NULL,'shabbat','n/a',NULL,NULL,'3759 Redwood Cir, Palo Alto, CA',NULL,'After San Leandro RV drop-off. 2nd frozen shipment Fri AM.');
INSERT INTO bookings (id,day_id,date_label,name,site,confirmation,status,hookups,check_in,check_out,address,phone,notes) VALUES (12,'jul30','Thu · Jul 30','Kalaloch — Olympic National Park (site A052)','A052, Loop A-F','0866633673-1','booked','none (dry)','2026-07-30','2026-07-31','156651 US-101, Forks, WA 98331 (Kalaloch, ~34 mi S of Forks)','360-962-2283','FIRST of two Kalaloch sites for this night (other: D003 / 0834117653-1). Primary: Simcha Regal, 6 occupants, RV, 1 car. Site 29 ft TOTAL max — your RV is 29 ft, so it is a tight/exact fit. Near Hwy 101, expect traffic noise. Slide-outs: concrete picnic table + vegetation may obstruct; tight turns/trees make maneuvering difficult. Check-in 12PM, check-out 11AM. Free cancel by Jul 28 ($14 refund); $0 refund on/after Jul 29.');
INSERT INTO bookings (id,day_id,date_label,name,site,confirmation,status,hookups,check_in,check_out,address,phone,notes) VALUES (13,'jul30','Thu · Jul 30','Kalaloch — Olympic National Park (site D003)','D003, A-F','0834117653-1','booked','none (dry)','2026-07-30 12:00 PM','2026-07-31 11:00 AM','156651 US-101, Forks, WA 98331 (Kalaloch, ~34 mi S of Forks)','360-962-2283','SECOND Kalaloch site for the same night (separate reservation from A052 / 0866633673-1). Primary: Simcha Regal, 6 occupants, RV, 1 vehicle. Check-in 12:00 PM, check-out 11:00 AM. Free cancel by Tue Jul 28 ($14 refund); $0 refund on/after Wed Jul 29.');

INSERT INTO events (id,day_id,time_label,label,note,link,link_label,verify,sort_order) VALUES (1,'jul27','12:43 PM','AS 230 lands SEA','6 people + bags + car seats; out ~1:30 PM. Road Bear ~10 min away.',NULL,NULL,0,1);
INSERT INTO events (id,day_id,time_label,label,note,link,link_label,verify,sort_order) VALUES (2,'jul27','~2:15 PM','Road Bear RV pickup','~1 hr walkthrough; fill fresh tank before leaving.',NULL,NULL,0,2);
INSERT INTO events (id,day_id,time_label,label,note,link,link_label,verify,sort_order) VALUES (3,'jul27','Evening','Bainbridge Island overnight','Lean: drive around via Tacoma vs. rush-hour ferry.',NULL,NULL,0,5);
INSERT INTO events (id,day_id,time_label,label,note,link,link_label,verify,sort_order) VALUES (4,'jul28','Night','RV@Olympic #2825','Back-in site at check-in; Walmart nearby for resupply + water.',NULL,NULL,0,1);
INSERT INTO events (id,day_id,time_label,label,note,link,link_label,verify,sort_order) VALUES (5,'jul29','PM','Hard Rain Cafe (booked)','Electric, no sewer; dawn access to Hoh. Add 4 kids; cancel Quileute.',NULL,NULL,0,1);
INSERT INTO events (id,day_id,time_label,label,note,link,link_label,verify,sort_order) VALUES (6,'jul30','8 AM','Hall of Mosses','Minutes from Hard Rain — beat the gate queue.',NULL,NULL,0,1);
INSERT INTO events (id,day_id,time_label,label,note,link,link_label,verify,sort_order) VALUES (7,'jul30','Night','Rain Forest Resort Village (booked)','Lakeside, laundry, dump/fill here. Shortens Friday.',NULL,NULL,0,2);
INSERT INTO events (id,day_id,time_label,label,note,link,link_label,verify,sort_order) VALUES (8,'jul31','Early AM','Depart Quinault → Portland','~3.5–4.5 hr RV (verify). Backward-schedule from candle lighting.',NULL,NULL,0,1);
INSERT INTO events (id,day_id,time_label,label,note,link,link_label,verify,sort_order) VALUES (9,'jul31','PM','Receive LA frozen shipment','Confirm Frumie can receive + freeze.',NULL,NULL,0,2);
INSERT INTO events (id,day_id,time_label,label,note,link,link_label,verify,sort_order) VALUES (10,'aug2','PM','Guided surfperch (kosher, whole family)','Gear provided; tide-timed. Cape Perpetua fallback.',NULL,NULL,0,1);
INSERT INTO events (id,day_id,time_label,label,note,link,link_label,verify,sort_order) VALUES (11,'aug2','Night','Tillicum site 55 (booked)','E/W hookup, ~1/10 mi to shore.',NULL,NULL,0,2);
INSERT INTO events (id,day_id,time_label,label,note,link,link_label,verify,sort_order) VALUES (12,'aug3','Day','Bob Creek tidepools · Sea Lion Caves · Florence dunes','Sandboarding — the big kid hour.',NULL,NULL,0,1);
INSERT INTO events (id,day_id,time_label,label,note,link,link_label,verify,sort_order) VALUES (13,'aug3','Night','Bullards Beach B61 (booked)','Full hookup; dump/showers night.',NULL,NULL,0,2);
INSERT INTO events (id,day_id,time_label,label,note,link,link_label,verify,sort_order) VALUES (14,'aug4','7:30 AM','Face Rock sand dollars','Low tide, before crowds.',NULL,NULL,0,1);
INSERT INTO events (id,day_id,time_label,label,note,link,link_label,verify,sort_order) VALUES (15,'aug4','Night','Harris Beach B36 (booked!)','Sea stacks + Bird Island. Cancel Turtle Rock #694434.',NULL,NULL,0,2);
INSERT INTO events (id,day_id,time_label,label,note,link,link_label,verify,sort_order) VALUES (16,'aug5','AM','Smith River edge-wade (not a swim)','Cold moving water — big kids ankle-deep only.',NULL,NULL,0,1);
INSERT INTO events (id,day_id,time_label,label,note,link,link_label,verify,sort_order) VALUES (17,'aug5','Night','Giant Redwoods #359312','On the Avenue; gates 9 PM; no cell service; Eel River swim hole.',NULL,NULL,0,2);
INSERT INTO events (id,day_id,time_label,label,note,link,link_label,verify,sort_order) VALUES (18,'aug6','PM','Goat Rock harbor seals (Jenner)','Cold, foggy, wild — the wildlife closer.',NULL,NULL,0,1);
INSERT INTO events (id,day_id,time_label,label,note,link,link_label,verify,sort_order) VALUES (19,'aug6','Night','Doran Jetty 118 (booked)','Dry — dump/fill Fri AM before drop-off.',NULL,NULL,0,2);
INSERT INTO events (id,day_id,time_label,label,note,link,link_label,verify,sort_order) VALUES (20,'aug7','AM','Doran → San Leandro drop-off','~2–2.5 hr. Dump+fuel first. Then 2 UberXL → Palo Alto (own car seats).',NULL,NULL,0,1);
INSERT INTO events (id,day_id,time_label,label,note,link,link_label,verify,sort_order) VALUES (21,'aug7','~7:50 PM','Candle lighting, Palo Alto (verify)','2nd frozen shipment arrives AM.',NULL,NULL,0,2);
INSERT INTO events (id,day_id,time_label,label,note,link,link_label,verify,sort_order) VALUES (22,'aug9','1:38 PM','AS 42 SFO T1 → JFK T8 10:26 PM','Leave Airbnb ~10:30 AM. Pre-arrange JFK→Staten Island pickup.',NULL,NULL,0,1);
INSERT INTO events (id,day_id,time_label,label,note,link,link_label,verify,sort_order) VALUES (23,'jul27','~4:30 PM','Walmart grocery pickup','Schedule the slot for ~5:00 PM. Realistically ready 4:30-4:45 PM (bags ~1:40, depot orientation 1-2 hr), and 3-6 PM traffic. Nearest Supercenters: Renton (~15 min, inland) or Federal Way/Tacoma (on the drive-around route). Slot is editable same-day in the Walmart app.',NULL,NULL,1,3);
INSERT INTO events (id,day_id,time_label,label,note,link,link_label,verify,sort_order) VALUES (24,'jul27','~5:30 PM','Ferry vs. drive-around to Bainbridge','FERRY: no reservation - first-come, first-served. RV pays oversize (22 ft+) fare at the booth; doubles if over 8ft6 wide. ~35-min crossing from Colman Dock (Pier 52), runs ~every 50-70 min. RVs load in a separate lane and are NOT guaranteed the next sailing at peak - arrive 45-60 min early. DRIVE-AROUND via Tacoma Narrows: ~1.5-2 hr (verify live) but fully predictable. Lean drive-around on day 1 with tired kids.',NULL,NULL,1,4);

INSERT INTO open_items (id,text,category,resolved) VALUES (2,'Cancel duplicate Quileute Oceanside booking (Jul 29)','logistics',1);
INSERT INTO open_items (id,text,category,resolved) VALUES (3,'Call Hard Rain 360-374-9288 to add 4 kids to booking','logistics',0);
INSERT INTO open_items (id,text,category,resolved) VALUES (4,'Friday Aug 7 drop-off transport: two UberXL, own car seats, San Leandro → Palo Alto','transport',0);
INSERT INTO open_items (id,text,category,resolved) VALUES (5,'Confirm exact Road Bear latest Friday drop time (depot closes 5 PM)','transport',0);
INSERT INTO open_items (id,text,category,resolved) VALUES (6,'Sunday Aug 9 SFO run + JFK→Staten Island late-night pickup','transport',0);
INSERT INTO open_items (id,text,category,resolved) VALUES (7,'Pull Aug 2 Yachats tide chart to time guided surfperch','logistics',0);
INSERT INTO open_items (id,text,category,resolved) VALUES (8,'Confirm both Shabbat candle-lighting times (Portland Jul 31, Palo Alto Aug 7)','logistics',0);
INSERT INTO open_items (id,text,category,resolved) VALUES (9,'Two LA frozen-food shipments (Portland Fri Jul 31, Palo Alto Fri Aug 7)','food',0);
INSERT INTO open_items (id,text,category,resolved) VALUES (10,'Car seats for RV + airport transfers (bringing own 2 from home)','transport',0);
INSERT INTO open_items (id,text,category,resolved) VALUES (11,'Print eruv maps for both Shabbatot — Portland (Fri Jul 31) and Palo Alto (Fri Aug 7)','logistics',0);
INSERT INTO open_items (id,text,category,resolved) VALUES (12,'Make Walmart shopping list for after RV pickup','food',1);
INSERT INTO open_items (id,text,category,resolved) VALUES (13,'Buy kids entertainment — toys and activities (ages 9, 7, 3, 1) for RV','logistics',1);
INSERT INTO open_items (id,text,category,resolved) VALUES (14,'Arrange transfer to and from airport','transport',0);
INSERT INTO open_items (id,text,category,resolved) VALUES (15,'Order family merch','logistics',1);
INSERT INTO open_items (id,text,category,resolved) VALUES (16,'Make decision whether to do a fishing trip on Sunday (Aug 2) in Oregon','logistics',1);
INSERT INTO open_items (id,text,category,resolved) VALUES (17,'Confirm Road Bear free airport shuttle for Jul 27 arrival (needs online check-in done 30+ days prior) - solves car seats in an Uber','transport',0);
