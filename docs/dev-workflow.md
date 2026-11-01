# Development workflow

## Tools
- **Cursor agent:** writes and edits code, runs tests, refactors.
- **Claude (chat):** research, data work, decisions, evaluation design, report writing.
- Decisions made in chat go into `docs/decisions.md`; do that after each session.

## Working with the agent
- Small, specific prompts, one feature ID at a time, tests first.
- Commit before a big change so you can undo it (`docs/git-workflow.md`).
- Read and be able to explain every file the agent writes. Log AI use in `docs/ai-use-log.md` and check the university's AI rules.
- Give the agent exact failing output (test result or `adb logcat`) instead of "it doesn't work".

## Prompt template
```
Feature: F-06 amount extraction (docs/roadmap.md, Phase 1)
Rules: follow AGENTS.md and docs/parser-spec.md.
Task: write failing tests first for these messages (copy the redacted text from data/samples.csv, one at a time),
then implement the function so the tests pass.
Constraints: no new dependencies, small functions, comment why.
Report: what changed and how I can check it.
```

## Testing on a real phone
- Parser, categoriser, forecast: unit tests on the computer.
- Notification capture: needs a real Android phone (battery savers and OEM settings change behaviour).
  1. Enable Developer options and USB debugging.
  2. `adb devices` shows the phone.
  3. Run the app, grant Notification Access.
  4. Trigger a real notification (small eSewa transfer from a friend).
  5. `adb logcat` to see what the listener received. Check no raw text or OTP is logged in release builds.
- Do this early in Phase 1, before building on top of capture.

## Try the parser yourself
- `python tools/try_parser.py` (or double-click `tools/try_parser.bat`): paste a message, press Enter on an empty line, see the fields, category and whether it goes to the review inbox. Nothing is saved.
- `python tools/evaluate_parser.py --verbose`: score all samples.
- `python -m unittest test_parser_v3` (inside `parser_prototype/`): run the 43 tests.
