# PaisaPatri — instructions for AI coding agents

PaisaPatri is a final-year university project: an Android app that automatically
captures Nepali bank SMS / wallet notifications, turns them into structured
transactions, categorises them, and shows a budget dashboard. It is built by one
student who must **understand and defend every line in a viva**.

Read `docs/project-context.md` for the university requirements and `docs/roadmap.md`
for phases and features (F-01…F-75). Follow `docs/decisions.md`.

## Hard rules (never break these)
1. **Never store raw SMS or notification text.** Keep it in memory for one parse
   call, then store only extracted fields (amount, direction, date, bank, account
   mask, remark, category, confidence, source).
2. **Never store or log OTPs, full account numbers, phone numbers or names.**
3. **Android capture uses `NotificationListenerService`** with a sender/package
   **allowlist**. Do not request `READ_SMS` in the normal build.
4. **Offline-first, on-device.** No backend, no cloud, no analytics, no Firebase.
   The **release** build must not declare the `INTERNET` permission (Flutter's debug
   manifest may include it for hot reload; leave that alone, never add it to the main manifest).
5. **Local database is encrypted (SQLCipher)**; key in Android Keystore. All DB access
   goes through one repository class.
6. **Never guess.** If amount, direction or date cannot be extracted, save the item with
   `needs_review = true` and a reason. Unknown category stays `Uncategorised`.
7. **Bonus is not salary.** Dashain/festival bonus is kept out of monthly income,
   savings rate and forecast run-rate. A transfer from the user's own bank into
   eSewa ("received from <bank>") is a **Wallet Load**, an internal transfer, not income,
   and must not be double-counted with the bank's debit.
8. **Truncated remarks:** banks cut remarks short. Never fuzzy-match a partial word;
   send it to the review inbox.
9. **Batched review is the default** (F-64): unclear items wait in an inbox; do not
   pop up a prompt after every payment. **"My note"** (F-63) is an optional free-text
   field on each transaction.
10. **UI colours come from `docs/design-system.md` tokens only.** No hex codes in widgets.
    Primary buttons use `brandPrimary` with white text (the bright `accent` green fails contrast for text).
    There are **no accounts**: do not build login, sign-up, OTP, social sign-in or personal-details screens (DEC-23).

## Data handling (read carefully)
- `data/samples.csv` holds real, **redacted** messages shared by consenting people. It is
  gitignored. **Never commit it, paste it into chat, or print the whole file.**
- You may read it locally **only** to write tests: copy one redacted message at a time
  into a test. Do not summarise or upload the file elsewhere.
- Do not invent bank message formats. If a format is missing, ask for a real sample.
- Do not add real names, account numbers or OTP codes to any file, test or log.

## Stack
- App: Flutter (Dart), Android only.
- Capture: small Kotlin `NotificationListenerService`, exposed to Flutter by a platform channel.
- Storage: SQLite + SQLCipher.
- Parser and categoriser: Dart, on-device (`lib/features/parsing/`). The Python prototype is reference only and lives outside this repo.
- ML is **contingent**: a lightweight text classifier, only if it beats the rule-based
  baseline on a held-out test set.

## Repository layout
- `docs/project-context.md` — university requirements, deliverables, supervisor questions.
- `docs/roadmap.md` — phases, master feature list, open decisions. **Find the current phase here.**
- `docs/decisions.md` — decisions made; follow them.
- `docs/parser-spec.md` — parsing rules learned from real messages.
- `docs/data-schema.md` — CSV and database schema, the frozen 27-category taxonomy (use the exact names; do not invent or rename categories).
- `docs/data-collection.md` — how samples are collected and redacted.
- `docs/design-system.md` — colour tokens, contrast results, onboarding flow, logo notes (`docs/brand/`).
- `docs/dev-workflow.md` — how to work with the agent, test on a real phone.
- `docs/git-workflow.md`, `docs/ai-use-log.md`.
- `docs/architecture.md` — the folder structure and the rules for it (DEC-27). **Read before adding any file.**
- `docs/progress.md` — done so far, next step, open questions. **Read at the start of every session.**
- This repository root *is* the Flutter app (`lib/`, `android/`, `test/`).
- The Python parser prototype (`parser_v3.py`, the one to port to Dart) and the data tools are **not in this repo**; they live in a separate private research folder with the real samples. If the student wants to port `parser_v3.py`, they will copy it into a `reference/` folder here. Never ask for `samples.csv`.

## Code structure (DEC-27: feature-first)
Full detail and a "where does it go" table are in `docs/architecture.md`. In short:
- `lib/app/` wiring (`di`), routes (`router`), theme (`theme`, colour tokens from `docs/design-system.md`).
- `lib/core/` plumbing used by every feature: `constants`, `errors`, `storage` (encrypted database and key), `services`, `utils`. There is **no network and no session code** (no backend, no accounts: DEC-17, DEC-23). Do not create `auth`, `network` or `session` folders.
- `lib/features/<name>/` one folder per feature, with up to three layers: `data/` (models, data sources, repository implementations), `domain/` (entities, repository interfaces, optional use cases), `presentation/` (providers, screens, widgets).
- `lib/shared/` things used by several features (for example the 27-category model, common widgets).
- Features: `onboarding`, `capture`, `parsing`, `transactions`, `review_inbox`, `dashboard`, `budgets`, `settings`.

Rules:
1. Widgets only show data and call providers. No parsing, no SQL, no business rules in widgets.
2. Presentation calls repositories or use cases, never the database directly.
3. `domain/` and `features/parsing/` import no Flutter package, so they run in plain `dart test`.
4. A feature may import another feature's `domain/` or `shared/`, never its `data/` or `presentation/`.
5. Add a use case only when a screen needs several repositories or more than one call; otherwise call the repository.
6. One class per file, about 200 lines at most. Files in `snake_case`, classes in `PascalCase`.
7. `test/` mirrors `lib/`.
8. The state-management package is **not chosen yet**. Ask before adding it or any other dependency.

## Current phase
**Phase 0–1: foundations and capture/parsing core.** Do not start dashboard, ML or
forecast work until Phase 1's done checklist in `docs/roadmap.md` is ticked.
Current status and next step: `docs/progress.md`.

## How to work
- One feature at a time, using the feature ID (e.g. "F-06 amount extraction").
- **Write the test first**, run it, then write the code.
- Keep functions small. Add a short comment explaining *why*, in plain English.
- Ask before adding a dependency or changing the schema.
- Never delete or weaken a failing test to make it pass.
- Tests and docs use **synthetic** messages only (real format, fake numbers and names). Real messages stay in `data/samples.csv`, which is in a separate folder and never in this repo.
- Before finishing a task run `flutter analyze` and `flutter test`; both must pass.
- After each change, state what you changed and how to check it.
- Do not add features that are not in `docs/roadmap.md`. If something seems missing, ask.
- Explain code in simple terms; the student must be able to explain it.

## Out of scope for now
Cloud backup/sync, iOS app, OCR, voice entry, goal-based savings, monetisation.
