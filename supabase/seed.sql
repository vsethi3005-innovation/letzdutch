-- Sample Dubai venues and menus, so the live app has something to show.
-- Run once in the Supabase SQL editor after the migration.

insert into public.venues (id, name, type, area, cuisine, rating, wait_minutes, has_valet, happy_hour, is_open) values
  ('00000000-0000-0000-0000-000000000001', 'Saffron Terrace', 'restaurant', 'Dubai Marina', '{Indian,Grill}', 4.6, 15, true, '5 to 8 pm, 30% off mocktails', true),
  ('00000000-0000-0000-0000-000000000002', 'Bean & Dune', 'cafe', 'Jumeirah', '{Coffee,Brunch}', 4.4, 5, false, null, true),
  ('00000000-0000-0000-0000-000000000003', 'Skyline Lounge', 'bar', 'Downtown', '{Tapas}', 4.7, 25, true, '6 to 9 pm, two for one', true),
  ('00000000-0000-0000-0000-000000000004', 'Neon Desert', 'nightclub', 'Business Bay', '{}', 4.2, 0, true, null, false)
on conflict (id) do nothing;

insert into public.menu_items (venue_id, name, description, category, price_minor, prep_minutes, is_special) values
  ('00000000-0000-0000-0000-000000000001', 'Butter chicken', '', 'Mains', 6800, 20, false),
  ('00000000-0000-0000-0000-000000000001', 'Paneer tikka', '', 'Starters', 5200, 15, false),
  ('00000000-0000-0000-0000-000000000001', 'Lamb biryani', 'Slow cooked, served with raita', 'Mains', 7900, 25, true),
  ('00000000-0000-0000-0000-000000000001', 'Garlic naan', '', 'Sides', 1200, 8, false),
  ('00000000-0000-0000-0000-000000000001', 'Mango lassi', '', 'Drinks', 2200, 5, false),
  ('00000000-0000-0000-0000-000000000002', 'Flat white', '', 'Coffee', 2100, 4, false),
  ('00000000-0000-0000-0000-000000000002', 'Shakshuka', '', 'Brunch', 4800, 15, true),
  ('00000000-0000-0000-0000-000000000002', 'Avocado toast', '', 'Brunch', 4200, 10, false),
  ('00000000-0000-0000-0000-000000000003', 'Patatas bravas', '', 'Tapas', 3800, 12, false),
  ('00000000-0000-0000-0000-000000000003', 'Gambas al ajillo', '', 'Tapas', 6400, 15, true),
  ('00000000-0000-0000-0000-000000000003', 'Virgin mojito', '', 'Drinks', 3400, 4, false);
