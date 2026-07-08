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
