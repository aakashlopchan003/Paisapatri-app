# Project context

## The project
PaisaPatri: automated SMS/notification-based expense tracker and budget helper for Nepali bank account holders.
Student: Aakash Lopchan (no. 2548875). Supervisor: Sujeen Rajak. BSc (Hons) Computer Science final-year project (BCS-accredited).

## What the university expects (from the project handbook)
- An **artefact** (the app), a development cycle with **testing**, and **justification of tools and techniques**.
- A demonstration / viva that must be passed.
- Milestones M1 to M6: Proposal Report; Literature Review; Artefact Design and Test Plan; Professionalism section + early prototype; Draft report + advanced artefact; Final report (about 10,000 words) + final artefact.
- Project management (Gantt, logbook, regular supervisor meetings) carries marks.
- Ethics registration (Project Registration Form) before collecting data from people.

## Plan
24 weeks; phases in `docs/roadmap.md` follow the agreed Gantt. Contingent items: wallet capture (Phase 2), ML categorisation, budget prediction.

## Supervisor's required AI framework (Method / Data / Measurement)
- **Method:** rules first; a lightweight text classifier (e.g. multinomial Naive Bayes) only for items the rules leave unknown. Input: remark text; output: one category.
- **Data:** real redacted bank/wallet messages from the student and consenting volunteers; target 150 to 300; 80/20 train/test split; test set never used for tuning.
- **Measurement:** compare rules-only vs ML-only vs rules+ML on the same held-out set (accuracy, per-category precision/recall, false positives/negatives). ML is kept only if it beats the rules-only baseline.

## Supervisor's questions and where they are handled
| Question | Handled in |
| --- | --- |
| How is credit vs debit told apart? | Parser direction rules (`docs/parser-spec.md`), F-07 |
| Does an EMI (e.g. 10,000) show against salary? | F-29, F-30, F-36 EMI card |
| Dashain bonus vs salary | F-27, F-28; bonus excluded from income and forecast |
| Random or missing remarks | F-25 review inbox, F-26/F-67 memory, F-63 my note, F-68 truncation |
| What does the dashboard show? | F-33 to F-37, roadmap Phase 4 |
| Will parse → categorise → predict really work? | Research brief; honest limits in the roadmap and DEC-16 |

## Other deliverables (outside the repo)
- Defense deck: 26 slides (slide 1 still has the "[Your Name]" placeholder to replace).
- Proposal Report (.docx), filled Project Registration Form (print for the defence).
- FDD and Gantt, as draw.io files and images.
- Study guide and research brief (Claude Docs), literature review tracker, and the roadmap doc (Claude Docs, mirrored in `docs/roadmap.md`).

## Honest limits to state in the report
- Only a small number of labelled real messages so far (13 at time of writing); ML is contingent.
- Bank alert formats vary and change; banks truncate remarks; eSewa notifications are minimal.
- Keyword lexicon is unvalidated until tested on volunteer data.
- Labour Act s.37 (festival expense) not verified from the primary text.
- Android live capture not built yet.
