# Progress (update at the end of every work session)

Last updated: 9 Nov 2026 (end of session: Home, 4-tab shell, Transactions, Review, Splash).

## Done
- Research, decisions and design: see `docs/decisions.md`, `docs/design-system.md`, `docs/parser-spec.md`.
- Python parser prototype (`parser_v3`) and data tools exist in the student's separate research folder (not in this repo).
- Structure decided: feature-first (DEC-27). Folders created under `lib/features/`.
- First screen built: green app bar, summary card and three fake transactions, using `AppColors`. Split out of `main.dart` (9 Nov 2026): theme in `lib/app/theme/`, `PaisaPatriApp` in `lib/app/app.dart`, `HomeScreen` and `SummaryCard` under `features/dashboard/presentation/`, `TransactionTile` in `lib/shared/widgets/`. `main.dart` only calls `runApp`. `flutter analyze` and `flutter test` passed.
- Bottom bar (9 Nov 2026): `AppShell` in `lib/app/app_shell.dart` remembers the tab. Home is the existing screen. Transactions, Review and Settings are placeholders in their feature folders. `surface` added to `AppColors` from the design system. Tests passed.
- Transactions tab (9 Nov 2026): `Transaction` entity and `TransactionRepository` interface in `features/transactions/domain/`; `SampleTransactionRepository` (8 made-up items, valid category names) in `features/transactions/data/`; `TransactionsScreen` lists them with `TransactionTile`.
- Review tab (9 Nov 2026, Task 2D): 3 made-up items in `ReviewScreen`, each a `ReviewItemCard` (title, signed amount, reason, "Pick category" and "Skip" buttons that do nothing yet). A plain list, no pop-ups (rule 9). `divider` and `review` added to `AppColors`. Tests passed.
- Onboarding screen 1 of 6, Splash (9 Nov 2026, Task 2E): `SplashScreen` in `features/onboarding/presentation/screens/`. Mint background, name and tagline, moves to the next screen after 2 seconds. `PaisaPatriApp` now starts at the splash (then the tab shell until the other onboarding screens exist); it has a `home` parameter used only by tests. Uses text, not the logo image yet. `brandWordmark` added to `AppColors`.

- Repo fix (9 Nov 2026): `.gitignore` rule `data/` also hid `lib/features/transactions/data/`. Changed to `/data/` (repo root only), so `data/samples.csv` is still ignored.
- Status at end of session: `flutter analyze` clean, 6 tests pass. All screens use fake data; nothing is stored, no capture or parsing yet.

## Setup facts
- Flutter 3.47.6 (Dart 3.13) on Windows. Test phone: Samsung SM S948B, Android 17. Samsung Auto Blocker had to be turned off to allow USB debugging.
- First Android build needed NDK `28.2.13676358` (Android Studio, SDK Manager, SDK Tools, "Show Package Details"). Installed on 9 Nov 2026; the app builds and runs on the phone.
- Package name `paisa_patri`, application ID `com.paisapatri.paisa_patri`.

## Next steps
1. (Done) The app runs on the phone.
2. (Done) Split `main.dart` into theme, app, dashboard Home, and the shared transaction row.
3. (Bottom bar and Splash done.) Onboarding screens 2 to 6 from `docs/design-system.md` are still to build, one at a time: Welcome and consent (F-54), Notification access, Choose banks, Pay day, Done. Nothing is saved yet. Currently Splash leads straight to the tab shell.
4. Local database and the transaction model (ask before adding packages).
5. Port the parser and categoriser to Dart with tests.
6. Kotlin notification capture and the permission screen.

## Open questions
- State-management package (not chosen).
- Parser: add a rule for the eSewa merchant payment wording ("Your transaction of Rs. X for <merchant> has been successfully completed")? Needs more samples first (DEC-26).
- Sender IDs of banks and the eSewa Android package name are still unverified (DEC-25).
- Ask the supervisor whether building on a friend's base skeleton is acceptable, and keep a note of what is the base and what is the student's own work.

## Starting a Cursor session
"Read AGENTS.md, docs/architecture.md and docs/progress.md, then help me with <one small task>."
