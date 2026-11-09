# Codebase architecture options (decision D22: decided, feature-first)

Status: **decided on 9 Nov 2026: feature-first (DEC-27). The layout to follow is in `docs/architecture.md`.** This file is kept as the record of the options that were considered.

Source note: the official Flutter and Android pages could not be opened when this was written, so the descriptions of those guides come from memory. Read the pages linked under "References" and correct this file if anything differs.

## What is the same in every option
- **Native capture, small:** a Kotlin `NotificationListenerService` with a sender allowlist. It sends only the text, sender and post time to Dart over a platform channel (an `EventChannel`). It does no parsing.
- **Pure-Dart brain:** the parser and categoriser are plain Dart classes with no Flutter imports (port `parser_prototype/parser_v3.py`). They are the easiest code to unit-test and the part examiners will ask about.
- **One door to the database:** all reads and writes go through repository classes (AGENTS.md rule 5). The database is SQLCipher.
- **Dependency rule:** screens depend on logic; logic does not depend on screens; nothing imports "downwards and sideways" (no screen importing another screen's internals, no database code inside a widget).
- **Flow of one transaction:** capture service -> parser -> categoriser -> repository -> database -> screen.

## Option A: Layered MVVM (the Flutter team's recommended shape)
Three layers: **UI** (views + view models), **domain** (models, parser, categoriser, optional use cases), **data** (repositories + services).

```
app/
  lib/
    main.dart
    config/                  # wiring of objects, constants
    routing/                 # routes
    ui/
      core/                  # theme (colour tokens), shared widgets
      onboarding/            # one folder per screen group
        view_models/
        widgets/
      home/  transactions/  review_inbox/  dashboard/  budgets/  settings/
    domain/
      models/                # Transaction, Category, Payee ...
      parser/                # amount, date, bank, remark rules (port of parser_v3)
      categoriser/           # service lookup, rules, payee + correction memory
      use_cases/             # only when a screen needs several repositories together
    data/
      repositories/          # TransactionRepository, BudgetRepository ...
      services/              # CaptureService (platform channel), DatabaseService (SQLCipher), KeyService
    utils/
  android/app/src/main/kotlin/.../capture/   # NotificationListener, allowlist, channel
  test/                      # mirrors lib/
```
- **Add one feature:** about 3 to 4 files (view, view model, repository method, model).
- **Strong points:** least ceremony; follows an official, documented pattern ("I followed Flutter's own architecture guide" is easy to defend); easy to explain on a whiteboard.
- **Weak points:** folders are grouped by layer, so a big feature is spread over `ui/`, `domain/` and `data/`; fine at this app's size.
- **Pairs with:** `ChangeNotifier` view models (+ the `provider` package) and a router such as `go_router` (to be confirmed per AGENTS.md: ask before adding a dependency).

## Option B: Feature-first, four layers
Each feature owns its layers: **presentation, application, domain, data**. Shared code lives in `core/`.

```
app/
  lib/
    main.dart
    src/
      core/                  # theme, router, database, errors
      shared/                # widgets used by many features
      features/
        capture/       { data/ domain/ application/ presentation/ }
        transactions/  { data/ domain/ application/ presentation/ }
        review/        { ... }
        dashboard/     { ... }
        budgets/       { ... }
        onboarding/    { ... }
        settings/      { ... }
  android/.../kotlin/.../capture/
  test/                      # mirrors lib/src
```
- **Add one feature:** about 5 to 6 files.
- **Strong points:** everything about one feature is in one folder; scales well; popular in the Flutter community (Riverpod-based).
- **Weak points:** more folders to learn; the "application" layer is hard to justify for a small app; needs Riverpod (a larger idea to defend in a viva).
- **Pairs with:** Riverpod.

## Option C: Clean Architecture (use cases, entities, interfaces)
Each feature has **data / domain / presentation**, and the domain layer has abstract repositories and one class per use case.

```
app/
  lib/
    core/                    # errors, base use case, theme
    features/
      transactions/
        data/         { datasources/ models/ repositories/ }   # models = DTOs, repos = implementations
        domain/       { entities/ repositories/ usecases/ }    # repositories = abstract interfaces
        presentation/ { bloc/ pages/ widgets/ }
      review/ dashboard/ budgets/ settings/ ...
```
- **Add one feature:** about 8 to 10 files (DTO, entity, mapper, data source, repository interface, repository implementation, use case, bloc with events/states, page).
- **Strong points:** most formal, very testable, common in larger teams and in many open-source templates.
- **Weak points:** the most boilerplate by far; easy to get lost; risky for one student in 18 weeks; an AI agent will happily generate many files you must still explain.
- **Pairs with:** Bloc.

## Side by side
| | A: Layered MVVM | B: Feature-first | C: Clean Architecture |
| --- | --- | --- | --- |
| Complexity | Low | Medium | High |
| Files per new feature | 3 to 4 | 5 to 6 | 8 to 10 |
| Explain in a viva | Easy | Medium | Hard |
| Testing the parser | Easy | Easy | Easy |
| Grows to a bigger app | Fine | Very good | Very good |
| Boilerplate | Little | Some | A lot |
| Fits one student, about 18 weeks | **Best** | Good | Risky |

## Real-world references (public, for learning)
- **Flutter team, "Architecting Flutter apps" and the Compass sample app:** the official layered MVVM guidance (Option A). docs.flutter.dev/app-architecture
- **Android "Guide to app architecture" and the Now in Android sample (Google):** UI, data and optional domain layers with one-way data flow. The same ideas apply to Flutter. developer.android.com/topic/architecture
- **Andrea Bizzotto, Flutter app architecture with Riverpod, and "A comparison of popular Flutter app architectures":** feature-first four layers (Option B). codewithandrea.com
- **Clean Architecture (Robert C. Martin) in Flutter:** Reso Coder's TDD Clean Architecture course and many GitHub templates (Option C).
- **Large open-source Flutter apps to browse the folder structure of:** Immich (photo backup, `mobile/` folder) and AppFlowy. Large companies rarely publish their internal architecture, so these public projects are the best real examples. I did not verify their internals; open `lib/` and compare it with the options above.

## Recommendation: Option A
It is the simplest that is still properly layered, it is the officially documented pattern, and it keeps the parser and categoriser in a clean pure-Dart domain layer. It can grow into B or C later because all three obey the same dependency rule.

## Rules that keep any option clean
1. Widgets only show data and call view-model methods. No parsing, no SQL, no business rules in widgets.
2. View models never touch the database directly; they call repositories.
3. The domain layer imports no Flutter package (so it runs in plain `dart test`).
4. One class per file, about 200 lines at most; split when longer.
5. File names in `snake_case`, classes in `PascalCase`; one folder per screen group.
6. `test/` mirrors `lib/`; every parser and categoriser rule has a test (synthetic messages only).
7. Colours come from the theme tokens in `docs/design-system.md`; no hex codes in widgets.
8. `flutter analyze` must be clean before every commit (use the standard `flutter_lints`).
9. New dependency or schema change: ask first and record it in `docs/decisions.md`.

## Where today's files go (Option A)
| Today | Becomes |
| --- | --- |
| `parser_prototype/parser_v3.py` | `lib/domain/parser/` and `lib/domain/categoriser/` (Dart) |
| `test_parser_v3.py` | `test/domain/parser/` |
| Category list (27) | `lib/domain/models/category.dart` |
| Colour tokens | `lib/ui/core/theme/app_colors.dart` |
| Kotlin listener (new) | `android/app/src/main/kotlin/.../capture/` |

## Next step after you choose
1. Record the choice as a decision and update `AGENTS.md` (layers and rules above).
2. Generate the `app/` skeleton: folders, a README per layer, an empty theme, and the first ported parser rule with its test.
3. Cursor then adds one feature at a time (F-xx) inside that structure.
