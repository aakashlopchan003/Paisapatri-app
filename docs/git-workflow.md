# Git routine

**Commit often (local, free), push at the end of each work session.**

## Every work session
1. `git status`  — see what changed. Check `data/` files are NOT listed.
2. `git add .`
3. `git commit -m "F-06: parse NPR. amounts"`  — one working step per commit; use the feature ID.
4. `git push`  — back it up to GitHub.

## When to commit
- A test goes from failing to passing.
- A feature or a clear piece of one works.
- Before asking an AI agent for a big change (so you can undo it).

## When to push
- End of every session, and before you close the laptop.
- After each phase is done: `git tag phase-1-done` then `git push --tags`.

## Never
- Commit `data/*.csv`, keystores, `.env`, or real messages.
- Make the repo public.
- Use `git push --force`.

## Undo
- Throw away uncommitted changes to one file: `git restore path/to/file`
- See history: `git log --oneline`
