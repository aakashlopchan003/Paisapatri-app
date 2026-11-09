# Code structure (decision DEC-27: feature-first)

Decided 9 Nov 2026. The other options that were considered are in `docs/architecture-options.md`.

The idea: one folder per **feature** (what the user sees and does), and inside each feature up to three **layers**. The base skeleton came from a friend's Flutter project; `auth`, `network` and `session` were dropped because PaisaPatri has no accounts and no backend (DEC-17, DEC-23).

## Folder tree
```
lib/
  main.dart
  app/
    di/            # creates the objects and hands them to the features
    router/        # screen routes
    theme/         # AppColors and ThemeData (tokens from docs/design-system.md)
  core/            # plumbing used by every feature
    constants/
    errors/
    storage/       # encrypted database (SQLCipher) and the key
    services/
    providers/
    utils/extensions/
  features/
    onboarding/    presentation/                       # local setup only, no login
    capture/       data/ domain/                       # notification listener bridge (platform channel)
    parsing/       domain/{entities,parser,categoriser}  # pure Dart, port of parser_v3
    transactions/  data/ domain/ presentation/
    review_inbox/  presentation/                       # items that need a human answer
    dashboard/     domain/usecases presentation/
    budgets/       data/ domain/ presentation/
    settings/      presentation/
  shared/
    models/        # for example the 27-category model
    providers/  screens/  widgets/
android/app/src/main/kotlin/.../capture/   # Kotlin NotificationListenerService, allowlist, channel
test/                                        # mirrors lib/
```

## The three layers inside a feature
| Layer | Holds | Rule |
| --- | --- | --- |
| `data/` | models (database rows), data sources (database, platform channel), repository implementations | The only place that talks to storage or Android. |
| `domain/` | entities, repository interfaces, optional use cases | Plain Dart, no Flutter imports. |
| `presentation/` | providers (screen state), screens, widgets | Shows data and calls providers. No parsing, no SQL. |

Small features do not need all three. `onboarding`, `review_inbox` and `settings` only have `presentation/`; `parsing` only has `domain/`.

## Flow of one transaction
1. `capture` (Kotlin listener, then `capture/data`) hands over text, sender and post time.
2. `parsing/domain/parser` extracts amount, direction, date, bank, remark. `parsing/domain/categoriser` picks a category. The raw text is dropped after this step (AGENTS.md rule 1).
3. `transactions/data` saves the extracted fields through `TransactionRepository` into `core/storage`.
4. Items marked `needs_review` show up in `review_inbox`; the rest in `transactions` and `dashboard`.

## Where does it go?
| I am adding... | Put it in |
| --- | --- |
| A new screen | `features/<feature>/presentation/screens/` |
| A reusable widget used in one feature | `features/<feature>/presentation/widgets/` |
| A widget used in several features | `shared/widgets/` |
| A colour | `app/theme/app_colors.dart` (and `docs/design-system.md`) |
| The 27 categories | `shared/models/category.dart` |
| A parser or categoriser rule (with its test) | `features/parsing/domain/` and `test/features/parsing/` |
| A database table or query | `features/<feature>/data/` and `core/storage/` (ask first: schema change) |
| A Kotlin class | `android/app/src/main/kotlin/.../capture/` |

## Rules
1. Widgets only show data and call providers.
2. Presentation calls repositories or use cases, never the database directly.
3. `domain/` and `features/parsing/` import no Flutter package, so they run in plain `dart test`.
4. A feature may import another feature's `domain/` or `shared/`, never its `data/` or `presentation/`.
5. Add a use case only when a screen needs several repositories or more than one call.
6. One class per file, about 200 lines at most. Files in `snake_case`, classes in `PascalCase`.
7. `test/` mirrors `lib/`. Parser and categoriser tests use synthetic messages only (DEC-24).
8. Colours come from the theme tokens. No hex codes in widgets.
9. `flutter analyze` and `flutter test` must pass before every commit.
10. New dependency (including the state-management package) or schema change: ask first and record it in `docs/decisions.md`.

## Not used on purpose
`auth`, `network` and `session` folders (no accounts, no backend). If the skeleton still has `lib/core/network/`, `lib/core/session/` or `lib/core/data/`, they are empty placeholders and can be deleted.

## Open
The state-management package (the `providers/` folders imply one) is not chosen yet.
