# Progress (update at the end of every work session)

Last updated: 9 Nov 2026.

## Done
- Research, decisions and design: see `docs/decisions.md`, `docs/design-system.md`, `docs/parser-spec.md`.
- Python parser prototype (`parser_v3`) and data tools exist in the student's separate research folder (not in this repo).
- Structure decided: feature-first (DEC-27). Folders created under `lib/features/`.
- First screen built in `lib/main.dart`: green app bar, summary card and three fake transactions, using `AppColors`. Everything is still in one file; next step is to split it into the feature folders.

## Setup facts
- Flutter 3.47.6 (Dart 3.13) on Windows. Test phone: Samsung SM S948B, Android 17. Samsung Auto Blocker had to be turned off to allow USB debugging.
- First Android build needed NDK `28.2.13676358` (Android Studio, SDK Manager, SDK Tools, "Show Package Details"). Installed on 9 Nov 2026; the app builds and runs on the phone.
- Package name `paisa_patri`, application ID `com.paisapatri.paisa_patri`.

## Next steps
1. (Done) The app runs on the phone.
2. Split `main.dart`: theme into `app/theme/`, `TransactionTile` and the summary card into `features/transactions/presentation/widgets/`, the home screen into `.../screens/`.
3. Bottom navigation (Home, Transactions, Review, Settings) and the onboarding screens from `docs/design-system.md`.
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
