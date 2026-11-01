-- Letzdutch MVP schema. Money is stored in minor units (fils) as bigint.

create extension if not exists "pgcrypto";

-- Users -------------------------------------------------------------------

create table public.profiles (
  id uuid primary key references auth.users on delete cascade,
  full_name text not null default '',
  phone text,
  avatar_url text,
  locale text not null default 'en' check (locale in ('en', 'ar')),
  membership text not null default 'normal'
    check (membership in ('normal', 'premium', 'elite')),
  preferences jsonb not null default '{}',
  created_at timestamptz not null default now()
);

-- Venues and menus --------------------------------------------------------

create type venue_type as enum ('restaurant', 'cafe', 'bar', 'club', 'nightclub');

create table public.venues (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  type venue_type not null,
  area text not null,
  cuisine text[] not null default '{}',
  image_url text,
  rating numeric(2, 1) not null default 0,
  is_open boolean not null default true,
  wait_minutes int not null default 0,
  has_valet boolean not null default false,
  happy_hour text,
  currency char(3) not null default 'AED',
  lat double precision,
  lng double precision,
  created_at timestamptz not null default now()
);

-- Staff accounts that manage a venue (restaurant interface).
create table public.venue_staff (
  venue_id uuid references public.venues on delete cascade,
  user_id uuid references auth.users on delete cascade,
  role text not null default 'staff' check (role in ('owner', 'manager', 'staff')),
  primary key (venue_id, user_id)
);

create table public.menu_items (
  id uuid primary key default gen_random_uuid(),
  venue_id uuid not null references public.venues on delete cascade,
  name text not null,
  description text not null default '',
  category text not null,
  price_minor bigint not null check (price_minor >= 0),
  currency char(3) not null default 'AED',
  prep_minutes int not null default 15,
  is_special boolean not null default false,
  is_available boolean not null default true
);
create index on public.menu_items (venue_id);

-- Table orders and bill splitting ----------------------------------------

create type order_status as enum ('draft', 'placed', 'preparing', 'served', 'paid', 'cancelled');

create table public.table_orders (
  id uuid primary key default gen_random_uuid(),
  venue_id uuid not null references public.venues,
  table_label text not null,
  host_id uuid not null references auth.users,
  status order_status not null default 'draft',
  tip_minor bigint not null default 0,
  created_at timestamptz not null default now()
);

create table public.table_participants (
  order_id uuid references public.table_orders on delete cascade,
  user_id uuid references auth.users on delete cascade,
  primary key (order_id, user_id)
);

create table public.order_lines (
  id uuid primary key default gen_random_uuid(),
  order_id uuid not null references public.table_orders on delete cascade,
  menu_item_id uuid not null references public.menu_items,
  ordered_by uuid not null references auth.users,
  quantity int not null default 1 check (quantity > 0),
  unit_price_minor bigint not null,
  shared_by uuid[] not null default '{}',
  note text
);

-- What each person owes for an order or event (the MVP "wallet" ledger).
create table public.shares (
  id uuid primary key default gen_random_uuid(),
  order_id uuid references public.table_orders on delete cascade,
  event_id uuid,
  user_id uuid not null references auth.users,
  amount_minor bigint not null,
  currency char(3) not null default 'AED',
  paid_at timestamptz,
  payment_ref text, -- Stripe PaymentIntent id
  check (order_id is not null or event_id is not null)
);

-- Events ------------------------------------------------------------------

create table public.events (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  host_id uuid not null references auth.users,
  venue_id uuid references public.venues,
  starts_at timestamptz not null,
  budget_minor bigint not null default 0,
  currency char(3) not null default 'AED',
  pay_deadline text not null default 'before' check (pay_deadline in ('before', 'after')),
  is_private boolean not null default true,
  created_at timestamptz not null default now()
);

alter table public.shares
  add constraint shares_event_fk foreign key (event_id) references public.events on delete cascade;

create table public.event_guests (
  event_id uuid references public.events on delete cascade,
  user_id uuid references auth.users on delete cascade,
  status text not null default 'invited'
    check (status in ('invited', 'going', 'maybe', 'declined')),
  primary key (event_id, user_id)
);

-- Row level security -----------------------------------------------------

alter table public.profiles enable row level security;
alter table public.venues enable row level security;
alter table public.venue_staff enable row level security;
alter table public.menu_items enable row level security;
alter table public.table_orders enable row level security;
alter table public.table_participants enable row level security;
alter table public.order_lines enable row level security;
alter table public.shares enable row level security;
alter table public.events enable row level security;
alter table public.event_guests enable row level security;

create policy "own profile" on public.profiles
  for all using (auth.uid() = id) with check (auth.uid() = id);

create policy "venues are public" on public.venues for select using (true);
create policy "menus are public" on public.menu_items for select using (true);

create policy "staff manage their menu" on public.menu_items for all using (
  exists (select 1 from public.venue_staff s
          where s.venue_id = menu_items.venue_id and s.user_id = auth.uid())
);

create policy "staff see own rows" on public.venue_staff
  for select using (user_id = auth.uid());

create or replace function public.is_table_member(o uuid) returns boolean
language sql security definer stable set search_path = public as $$
  select exists (select 1 from table_participants
                 where order_id = o and user_id = auth.uid())
      or exists (select 1 from table_orders
                 where id = o and host_id = auth.uid());
$$;

create policy "members see the order" on public.table_orders
  for select using (public.is_table_member(id));
create policy "host creates order" on public.table_orders
  for insert with check (host_id = auth.uid());
create policy "host updates order" on public.table_orders
  for update using (host_id = auth.uid());

create policy "members see participants" on public.table_participants
  for select using (public.is_table_member(order_id));
create policy "host adds participants" on public.table_participants
  for insert with check (
    exists (select 1 from public.table_orders o
            where o.id = order_id and o.host_id = auth.uid())
  );

create policy "members see lines" on public.order_lines
  for select using (public.is_table_member(order_id));
create policy "members add lines" on public.order_lines
  for insert with check (public.is_table_member(order_id) and ordered_by = auth.uid());

create policy "see own shares" on public.shares
  for select using (user_id = auth.uid());

create or replace function public.is_event_member(e uuid) returns boolean
language sql security definer stable set search_path = public as $$
  select exists (select 1 from event_guests where event_id = e and user_id = auth.uid())
      or exists (select 1 from events where id = e and host_id = auth.uid());
$$;

create policy "guests see event" on public.events
  for select using (public.is_event_member(id));
create policy "host manages event" on public.events
  for all using (host_id = auth.uid()) with check (host_id = auth.uid());

create policy "guests see guest list" on public.event_guests
  for select using (public.is_event_member(event_id));
create policy "host invites" on public.event_guests
  for insert with check (
    exists (select 1 from public.events e where e.id = event_id and e.host_id = auth.uid())
  );
create policy "guest updates own rsvp" on public.event_guests
  for update using (user_id = auth.uid());

-- Live updates for the table screen.
alter publication supabase_realtime add table public.order_lines, public.table_orders;
