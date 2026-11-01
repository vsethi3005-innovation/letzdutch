# Letzdutch

Social dining for Dubai: order at the table, split the bill, and plan events with friends.

## Repository layout

```
apps/consumer        Flutter app for diners (iOS, Android, web)
packages/letz_core   Shared Dart models and business logic (money, bill splitting)
supabase/migrations  Postgres schema with row level security
```

Planned next: `apps/venue` (restaurant tablet app) and `apps/corporate` (Flutter web portal).

## Getting started

Requires Flutter 3.47+ (Dart 3.13+). This is a [pub workspace](https://dart.dev/tools/pub/workspaces), so one `pub get` at the root resolves every package.

```sh
flutter pub get
cd apps/consumer
flutter run                 # runs on demo data
```

To run against the live Supabase project (sign-in required):

```sh
flutter run --dart-define-from-file=env/dev.json
```

`env/dev.json` holds the project URL and the publishable key, which are safe to ship in the app. Never put the secret/service_role key in this repo.

### Supabase setup (one time)

1. In the Supabase dashboard, open **SQL Editor**, paste `supabase/migrations/20261101000000_init.sql` and run it. Then do the same with `supabase/seed.sql` for sample venues.
2. Turn on phone sign-in under **Authentication → Sign In / Providers → Phone**, and connect an SMS provider (Twilio, MessageBird or Vonage).
3. While testing, add test numbers with fixed codes in the same Phone settings, so no SMS is sent.

## Tests

```sh
(cd packages/letz_core && dart test)
(cd apps/consumer && flutter test)
```

## Decisions

- **Market:** Dubai first. Currency AED, 5% VAT, English and Arabic (RTL).
- **Money:** always integer minor units (fils). Splits use the largest remainder method, so shares always add up to the bill exactly.
- **Wallet:** the MVP wallet is a ledger of who owes whom, settled by card through Stripe. Holding user funds needs a UAE stored-value licence, so that comes later with a licensed partner.
- **Payments:** Stripe (UAE). Razorpay to be added for India.
