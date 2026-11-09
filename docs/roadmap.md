# PaisaPatri — End-to-End Build Roadmap

Oct 6, 2026 · @AK

## How to use this roadmap

Build MVP-first: one working path (capture → parse → categorise → dashboard) by about week 15, then add the risky extras only if the data supports them. This replaces a strict waterfall because your plan has 24 weeks, contingent items (wallet capture, ML, prediction), and a viva that must demo something working even if the extras slip.

**Why overlapping phases.** Phases follow the agreed Gantt (W1–24). Privacy (Phase 6) runs beside everything, not after it, because encrypting storage late means rewriting the database layer.

**Rules of the road**

- Every phase ends with a checklist; do not start a dependent phase until the "done" boxes are ticked.
- Features marked **(C)** are contingent: build them only if the stated gate is met, otherwise they move to Future Work in the report.
- Never store raw SMS text. Store only the extracted fields.
- Accuracy claims come only from a held-out test set, never from the samples used to write the rules.
- IDs like F-14 are used everywhere below; keep them in your commits and logbook.

**Phase map**

| Phase | Name | Weeks | Contingent? |
| --- | --- | --- | --- |
| 0 | Foundations and decisions | W1–5 | No |
| 1 | Capture and parsing core | W5–10 | No |
| 2 | Wallet capture and iOS path | W8–11 | Yes |
| 3 | Categorisation, income logic, review inbox | W9–12 | No |
| 4 | Dashboard, budgets, bilingual UI | W11–15 | No |
| 5 | Safe-to-spend forecast and ML | W13–18 | Partly |
| 6 | Privacy and security hardening | W8–19 | No |
| 7 | Integration, testing, UAT | W18–22 | No |
| 8 | Release, viva, post-launch | W21–24+ | No |

Time estimates are for one person working roughly 15–20 hours a week; adjust to your real availability.

## Master feature list

Every feature agreed or built so far, 75 in total, with its phase. (C) = contingent, (D) = decided-deferred to post-launch. Items not yet agreed are in Open decisions, not here.

| ID | Feature | What it does | Phase |
| --- | --- | --- | --- |
| F-01 | Notification capture (Android) | `NotificationListenerService` reads bank/wallet notifications (Play-compliant, avoids `READ_SMS`) | 1 |
| F-02 | Direct SMS read fallback | Sideload/demo-only path using `READ_SMS` if notifications are missing | 1 |
| F-03 | Sender allowlist | Only listed bank/wallet sender IDs and package names are processed | 1 |
| F-04 | OTP / promo exclusion | OTP, login codes and promotions are dropped before parsing | 1 |
| F-05 | No raw-text persistence | Raw message held in memory only; only extracted fields saved | 1 |
| F-06 | Amount extraction (balance-aware) | Takes the transaction amount, skips amounts after avl/bal/limit | 1 |
| F-07 | Direction detection + confidence | Credit / debit / transfer by earliest keyword; both present = low confidence | 1 |
| F-08 | Multi-format date parsing | Length-anchored patterns (DD/MM/YYYY, DD-Mon-YYYY, ISO, DD/MM/YY) | 1 |
| F-09 | Account mask extraction | Keeps masked account only (e.g. ...4508) | 1 |
| F-10 | Bank / sender identification | Signature, sender ID, email domain, masking convention | 1 |
| F-11 | Remarks extraction | Pulls the free-text remark field for categorisation | 1 |
| F-12 | Incomplete-message handling | Missing amount/type/date → flagged, never guessed | 1 |
| F-13 | Bank pattern library | Per-bank regex set, extended as samples arrive | 1 |
| F-14 | Parser accuracy panel | Per-field and per-bank accuracy from the held-out set (dev/viva screen) | 1, 7 |
| F-15 | Sample collection + redaction tool | Script that masks account numbers/names before a sample is saved | 0 |
| F-16 | Wallet capture (eSewa, Khalti) (C) | Same capture path for wallet notifications | 2 |
| F-17 | iOS path (C) | Share-sheet / paste-message import, since iOS cannot read SMS | 2 |
| F-18 | Manual entry (cash) | Add a transaction by hand with amount, category, note, date | 2 |
| F-19 | Voice entry in Nepali (D) | Spoken cash entry; deferred | Post |
| F-20 | Category taxonomy (frozen, 27, DEC-18) | Spending (17): Food & Dining, Groceries, Transport, Travel & Tickets, Entertainment & Leisure, Shopping, Utilities & Bills, Mobile & Internet, Rent/Housing, Insurance, Loan/EMI/Credit Card, Education, Healthcare, Government & Taxes, Bank Charges & Fees, Cash Withdrawal, Other Spending. Savings (1): Savings & Investment. Income (5): Salary, Bonus, Reward/Cashback, Interest, Other Income. Neutral (3): Transfer, Wallet Load, Refund/Reversal. Plus Uncategorised | 3 |
| F-21 | Rule categoriser | Ordered rules: channel (eSewa, IBFT, FT/), then keyword lexicon | 3 |
| F-22 | Roman-Nepali + Devanagari lexicon | khaja, khana, bhat, momo, chiya, kista, bhada, talab, bhatta, bijuli and Devanagari equivalents | 3 |
| F-23 | Fuzzy matching | difflib, cutoff 0.84, tokens of 5+ characters, for typos | 3 |
| F-24 | Collision guard | Longer / more specific phrase first ("Bhat Bhateni" is Groceries, not rice) | 3 |
| F-25 | Review inbox | Low-confidence or unknown items queue for one-tap confirmation | 3 |
| F-26 | Correction memory | A user fix saves remark → category and is reused next time | 3 |
| F-27 | Income classifier | Remark keyword, then recurrence (same amount ±15%, 25–35 days), then ask once | 3 |
| F-28 | Bonus separation | Dashain/festival bonus labelled Bonus, excluded from monthly income and run-rate | 3 |
| F-29 | Loan / EMI detection | Keyword + monthly recurrence marks a recurring obligation | 3 |
| F-30 | Recurring-obligation list | EMI, rent and similar fixed items tracked for forecast | 3, 5 |
| F-31 | Lightweight ML classifier (C) | Naive Bayes / small embedding model for unknown merchants only | 5 |
| F-32 | Evaluation harness | 80/20 split, baseline vs ML, per-category precision/recall | 5, 7 |
| F-33 | Home dashboard | Income, spending, savings rate, left-after-EMI, safe-to-spend | 4 |
| F-34 | Income card | Salary and bonus shown separately | 4 |
| F-35 | Spending card + category breakdown | Month total and chart by category | 4 |
| F-36 | EMI share card | EMI as % of salary and amount left after EMI | 4 |
| F-37 | Savings rate | (Salary − spending) / salary; bonus excluded | 4 |
| F-38 | Transaction history | Chronological list, grouped by day | 4 |
| F-39 | Search and filter | By date, category, amount, free text | 4 |
| F-40 | Transaction detail + edit | View parsed fields, change category/type, delete | 4 |
| F-41 | Per-category budgets | Monthly limit per category with target allocation | 4 |
| F-42 | Budget vs actual + alerts | Progress bars; alert at 80% and 100% | 4 |
| F-43 | Trends view | Month-on-month charts; appears after 2–3 months of data | 4 |
| F-44 | Spending summary and insights | Plain-language monthly summary (top category, biggest change) | 4 |
| F-45 | Bilingual UI | English and Nepali strings, switchable | 4 |
| F-46 | Onboarding + salary day setup | Choose banks, enter salary date and expected salary | 4 |
| F-47 | Safe-to-spend forecast (tier 1) | Balance + expected salary − run-rate × days − known obligations | 5 |
| F-48 | Low-balance warning | Warns when forecast shows shortfall before next salary | 5 |
| F-49 | Pay-cycle / weekday shape (tier 2) | Adjusts run-rate after \~3 months of data | 5 |
| F-50 | Prophet / regression forecast (C) | Kept only if it beats tier 1 on held-out weeks | 5 |
| F-51 | Encrypted local database | SQLite + SQLCipher; key in Android Keystore | 6 |
| F-52 | App lock | PIN / biometric on open | 6 |
| F-53 | Screen-capture block | `FLAG_SECURE` on sensitive screens | 6 |
| F-54 | Consent flow | Plain-language consent before capture starts (Individual Privacy Act 2018) | 6 |
| F-55 | Minimal permissions | Notification access only; no contacts, location | 6 |
| F-56 | Data wipe and export of own data | "Delete everything" and own-data download | 6 |
| F-57 | Parser test suite | Real, edge-case and adversarial messages, run on every change | 1, 7 |
| F-58 | UAT and usability study | 5–10 users, task list, SUS-style questionnaire | 7 |
| F-59 | Debug APK + release build | Signed APK for demo; Play Store only if decided | 8 |
| F-60 | Documentation set | Final report, user guide, README, test report | 8 |
| F-61 | Freemium tier (D) | Free core; paid insights/export | Post |
| F-62 | Bank referral and insights API (D) | Revenue ideas from the proposal; not built in the FYP | Post |
| F-63 | My note (agreed) | Optional free-text note on any transaction (full remark when the bank cuts it off); stored on-device, feeds category suggestions and correction memory | 3, 4 |
| F-64 | Batched review (agreed default) | Unclear items collect in the review inbox and are cleared in a minute or two every few days; no interrupting prompt after each payment | 3 |
| F-65 | Notification time fallback | eSewa/Khalti notifications have no date in the text; use the notification post time (Android StatusBarNotification post time) | 1, 2 |
| F-66 | Internal-transfer detection | "Received from \<own bank>" in eSewa = Wallet Load, not income; match it to the bank's ESEWA LOAD debit so it is not double-counted; person-to-person credits are Transfer and confirmed once | 3 |
| F-67 | Payee memory | After one confirmation, a payee (person name or account suffix) is filed to the same category automatically next time; extends the correction memory (F-26) | 3 |
| F-68 | Truncated-remark detection | Banks cut remarks short; a remark that ends mid-word or at the bank's length limit is flagged, never fuzzy-matched, and goes to the review inbox | 1, 3 |
| F-69 | Cross-source dedupe | Same alert as SMS and notification, or a wallet payment and its bank debit, saved once (bank + amount + time within 60 s + account mask) | 1, 2 |
| F-70 | Dataset tooling v3 | add\_sample script: redaction, name masking, type/amount guess, 9-column samples.csv; planned extra columns channel, my\_note, remark\_truncated, split | 0 |
| F-71 | Service-name lookup | Messages naming a service (Electricity, Bus Ticket, School Fee, Mero Share) are categorised from a lookup table first; works with no remark. Table in `docs/parser-spec.md`, built from the Nabil, Fonepay and eSewa menus | 3 |
| F-72 | Money-flow rules | Credit-card payment counted once as Loan/EMI/Credit Card (card purchases not re-counted); Savings & Investment counted toward savings, not spending; Refund/Reversal nets against the original debit; Wallet Load and Transfer neutral (DEC-20) | 3, 4 |
| F-73 | Bank charges and interest | SMS/annual-card/ATM fees go to Bank Charges & Fees; interest credited goes to Interest and is not treated as salary | 3 |
| F-74 | Brand theme and design tokens | Colour tokens from the logo and onboarding reference (`docs/design-system.md`): one theme in code, contrast-checked, local-only onboarding (no login) | 0, 4 |
| F-75 | Parser v3 and evaluation harness | `parser_v3.py` (reference for the Dart port, 42 synthetic tests) and `tools/evaluate_parser.py` (scores type, amount, date, bank, category; shows review rate); training vs new-message scores kept apart | 1, 3 |

## Phase 0: Foundations and decisions (W1–5, about 60 hours)

**Goal.** Lock the tech stack, repo, data plan and ethics so Phase 1 starts with no open questions.

**Features and functions**

- F-15 Sample collection + redaction tool: a small Python script that replaces account numbers and personal names with masks, then appends the message to `samples.csv` (columns: id, bank, redacted\_text, source, consent, date\_collected). Behaviour: keeps only the last 4 digits of long numbers, masks the name after "Dear", and refuses to save a row if a 7+ digit number is left.
- Volunteer collection drive: target 150–300 redacted messages across 8–10 banks and wallets, with a written consent line for each volunteer.
- Repo, branching and logbook: Git repo, weekly supervisor-meeting notes, logbook entries (counts toward the 20% project-management marks).
- Architecture note: Flutter app, on-device parser, SQLite/SQLCipher, no server in the MVP.

**Screens / UI.** None built. Produce low-fidelity wireframes (paper or draw.io) for: onboarding, home dashboard, history, review inbox, budgets, settings. Do these now so Phase 4 is not designing from scratch.

**Backend, database, API.** Design the schema on paper: `transactions` (id, ts, amount, direction, bank, account\_mask, remark, category, confidence, source, needs\_review), `categories`, `budgets`, `corrections` (normalised\_remark, category), `recurring` (label, amount, day), `settings`. No API yet.

**Dependencies.** Approved proposal (M1) and signed ethics registration form.

**Testing.** Run the redaction script on 10 messages and check by eye that no full account number or name survives.

**Done checklist**

- [ ] Ethics form submitted and approved
- [ ] Stack decided and written in one page (see Open decisions for what is still undecided)
- [ ] Repo created, Flutter hello-world runs on a real Android phone
- [ ] Redaction script works; 8 real messages already in `samples.csv`
- [ ] At least 6 volunteers asked, consent wording agreed
- [ ] Wireframes for six screens drawn
- [ ] Schema drawn and reviewed with supervisor
- [ ] Lit review (M2) draft started, tracker updated with forecasting sources

## Phase 1: Capture and parsing core (W5–10, about 100 hours)

**Goal.** A real Android phone receives a bank notification and the app saves a correct, structured transaction with no raw text kept.

**Features and functions**

- F-01 Notification capture: `NotificationListenerService` in Kotlin, exposed to Flutter through a platform channel. Behaviour: runs in the background, survives reboot, user grants Notification Access once.
- F-02 SMS fallback: `READ_SMS` path behind a build flag, for the demo APK only (Play policy restricts this permission).
- F-03 Sender allowlist: a config file of bank sender IDs and wallet package names; anything else is ignored.
- F-04 OTP / promo exclusion: drop messages matching OTP, code, PIN, offer, cashback-promo patterns before the parser sees them.
- F-05 No raw-text persistence: the raw string lives in memory for one parse call, then is discarded; a unit test asserts the database holds no raw column.
- F-06 to F-11 Parser: port `parser.py` logic and v2 fixes to Dart (or call it through a Python-free Dart port). Amount skips balance figures; direction uses earliest keyword (debit: debited, dr, withdrawn, paid, sent, deducted, purchase; credit: credited, cr, deposited, received); both present = low confidence; date patterns length-anchored.
- F-12 Incomplete handling: any message missing amount, direction or date is saved with `needs_review = true` and a reason, never guessed.
- F-13 Bank pattern library: one pattern file per bank; changing a bank's pattern requires re-running the full test suite.
- F-14 Parser accuracy panel (dev screen): per-field and per-bank accuracy from the test set.
- F-57 Parser test suite: real messages, edge cases, OTP, promos, balance-first messages, "credited" inside remarks.

**Screens / UI.** Permission onboarding (explain why Notification Access is needed), a raw-feed debug list (extracted fields only), and the accuracy panel. No polish.

**Backend, database, API.** Create the SQLite tables from the Phase 0 schema. Insert path: `capture → allowlist → OTP filter → parse → dedupe → insert`. Dedupe key: bank + amount + timestamp within 60 seconds + account mask (the same alert often arrives as both SMS and notification). Database is plain SQLite for now; Phase 6 encrypts it, but write all access through one repository class so the swap is a single change.

**Dependencies.** Phase 0 complete; at least 30 redacted messages; a physical Android phone.

**Testing**

- Split samples before writing patterns: about 70% used to write rules, 30% held out and never looked at while coding.
- Report per-field accuracy (amount, direction, date, bank) on the held-out set and per bank.
- Real-device test: send yourself a bank transfer and confirm the row appears within 5 seconds with the screen off.
- Confirm a phone reboot does not stop capture.

**Done checklist**

- [ ] Notification arrives → transaction row saved on a real phone
- [ ] Raw text is not in the database or logs (checked by query and `adb logcat`)
- [ ] OTP and promo messages produce no row
- [ ] Amount, direction and date accuracy ≥ 95% on held-out messages, with the number reported per bank
- [ ] Incomplete messages flagged, not guessed
- [ ] Duplicate SMS + notification produces one row
- [ ] Banks covered: at least 5, with the rest listed as unsupported
- [ ] Early prototype demoed to supervisor (M4 evidence)

## Phase 2: Wallet capture and iOS path (W8–11, about 40 hours, contingent)

**Goal.** Cover eSewa/Khalti wallet notifications and give non-Android users a way in, without delaying the core MVP.

**Gate.** Start only if Phase 1 meets its done checklist. If W11 arrives and it is not working, move F-16 and F-17 to Future Work (already declared in the proposal as contingent).

**Features and functions**

- F-16 Wallet capture: add eSewa and Khalti package names to the allowlist and write their patterns (wallet messages differ from bank SMS: the eSewa notifications collected so far carry only the amount and the sender (a bank or a person), with no date, balance, remark or transaction ID).
- F-17 iOS path: iOS cannot read SMS or other apps' notifications, so offer "paste or share a message into PaisaPatri". The same parser runs on the pasted text. Treat as a demo-level path, not a full iOS app.
- F-18 Manual entry: a form for cash spending (amount, category, date, note). Saved with `source = manual`, confidence 100%, and counted in all totals. This is also the escape hatch when a bank is unsupported.

**Screens / UI.** Add-transaction sheet (floating button on home); paste-message screen; source badge on history rows (SMS, wallet, manual).

**Backend, database, API.** Add `source` column values: `notification`, `sms`, `wallet`, `manual`, `paste`. No server work.

**Dependencies.** Phase 1 parser and database; at least 10 real wallet messages collected.

**Testing.** Wallet accuracy measured separately from banks; paste a message on a second device and check the same row appears; manual entry validation (empty or zero amount rejected, future dates warned).

**Done checklist**

- [ ] eSewa and Khalti notifications parse with ≥ 90% on held-out wallet messages
- [ ] Paste/share import works from the share sheet
- [ ] Manual entry saves, edits and deletes
- [ ] A wallet payment and its matching bank debit do not double-count (dedupe rule written and tested)
- [ ] If gate failed: Future Work paragraph written instead

## Phase 3: Categorisation, income logic, review inbox (W9–12, about 70 hours)

**Goal.** Every transaction gets a category and an income/obligation label, and anything uncertain goes to the user instead of being guessed. This phase answers your supervisor's questions on credit vs debit, EMI, Dashain bonus and random remarks.

**Features and functions**

- F-20 Taxonomy: the frozen 27 categories in the master list (DEC-18). Use the exact names. Change only through a new decision.
- F-71 Service-name lookup: runs before every other rule; see the table in `docs/parser-spec.md`.
- F-72 Money-flow rules and F-73 bank charges/interest: see DEC-20.
- F-21 Rule categoriser: order is service-name lookup (F-71), then channel rules (eSewa, Khalti, IBFT, FT/, MB/), payee and correction memory, then keywords: Loan/EMI/Credit Card, Rent/Housing, Groceries, Food & Dining, Utilities, Mobile & Internet, Transport, Travel, Entertainment, Insurance, Education, Healthcare. First match wins.
- F-22 Lexicon: Roman-Nepali and Devanagari keywords (khaja, khana, bhat, momo, chiya, kista, bhada, talab, bhatta, bijuli and more). Treat the v2 list as unvalidated guesses; validate against volunteer data.
- F-23 Fuzzy matching: exact match first, then `difflib` at cutoff 0.84 on tokens of 5+ characters, so "restaurent" and "khajaa" still match.
- F-24 Collision guard: Groceries before Food, so "Bhat Bhateni" is not read as rice. Add each new collision found as a test.
- F-25 Review inbox: items with unknown remark, low direction confidence, or ambiguous income go here. Behaviour: one tap to confirm a suggested category or pick another; inbox count shown as a badge.
- F-26 Correction memory: when the user fixes a category, store normalised remark → category and apply it first next time. Answers "what if I write a random remark?": random text becomes Uncategorised and is asked once, never silently filed under Food & Dining.
- F-27 Income classifier, in this order: remark keyword (salary, talab, payroll), then recurrence (same amount ±15% about 25–35 days after the last salary), then ask the user once.
- F-28 Bonus separation: Dashain/festival bonus is labelled Bonus, shown separately, and excluded from monthly income, savings rate and forecast run-rate. Nepal context: the Labour Act 2074 s.37 festival expense is about one month's basic pay, paid around Dashain, and is taxable (verify against the primary text before citing).
- F-29 EMI detection: Loan/EMI keywords plus the same debit recurring monthly; add to the recurring list.
- F-30 Recurring-obligation list: label, amount, day of month; editable by the user. Feeds the dashboard EMI cards and the forecast.

**Screens / UI.** Review inbox (list + confirm/change sheet); category picker; recurring-obligations editor under Settings; "Why this category?" line on the transaction detail (rule matched, correction used, or fuzzy match).

**Backend, database, API.** Tables `categories`, `corrections`, `recurring`; indexes on `ts` and `category`. Lexicon stored as versioned JSON assets, not hard-coded, so it can be updated without touching code.

**Dependencies.** Phase 1 parser; 100+ labelled messages ideally (minimum 50); taxonomy frozen.

**Testing**

- Scenario suite: the 17 v2 cases plus new ones: bonus inside a salary credit, EMI with no remark, Devanagari remark, random remark, "Bhat Bhateni", two transactions same amount same day.
- Categorisation accuracy and per-category precision/recall on held-out labelled data, compared with the channel-only baseline.
- Correction loop: fix once, same remark auto-categorised on the next import.

**Done checklist**

- [ ] Overall category accuracy reported on held-out data (target ≥ 80%; report the real figure whatever it is)
- [ ] Random or unknown remarks reach the review inbox, never a guessed category
- [ ] A salary credit and a bonus credit land in different income types
- [ ] A 10,000 EMI is detected on its second month and shown as a recurring obligation
- [ ] Correction memory proven by test
- [ ] Lexicon keywords validated against volunteer messages and the unvalidated ones removed or marked
- [ ] Known gap written down: bonus paid inside the salary credit is not separable from the SMS alone

## Phase 4: Dashboard, budgets, bilingual UI (W11–15, about 90 hours)

**Goal.** The user opens the app and understands their month in five seconds. This is the dashboard your supervisor asked to see.

**Features and functions**

- F-33 Home dashboard, top to bottom: safe-to-spend banner (filled in Phase 5), income card, spending card, savings rate, EMI card, category chart, budget progress, needs-review badge.
- F-34 Income card: Salary and Bonus as two separate lines. Example from the v2 simulation: salary 85,000, bonus 85,000 shown apart.
- F-35 Spending card + category chart: month total and a donut or bar by category (example month: 29,270).
- F-36 EMI share: EMI as % of salary and "left after EMI" (example: 10,000 = 11.8%, left 75,000).
- F-37 Savings rate: (salary − spending) ÷ salary, bonus excluded (example: 65.6%, not the misleading 82.8% when the bonus is wrongly counted).
- F-38 History: transactions grouped by day, newest first, with source badge and category chip.
- F-39 Search and filter: by date range, category, amount range, direction and text.
- F-40 Transaction detail: parsed fields, "why this category", edit category/direction, delete.
- F-41 Per-category budgets: monthly limit per category, with a target-allocation view (percent of salary).
- F-42 Budget vs actual: progress bars; alerts at 80% and 100% as local notifications.
- F-43 Trends: month-on-month income, spending and savings rate. Hidden with a "needs 2–3 months of data" message until then.
- F-44 Spending summary: a plain sentence per month ("Food & Dining was your biggest category at 8,200, up 12%").
- F-45 Bilingual UI: all strings in English and Nepali ARB files; language switch in Settings; numbers formatted with thousands separators.
- F-46 Onboarding: pick banks, enter salary day and expected salary, set consent (Phase 6), grant notification access.

**Screens / UI.** Onboarding (4 steps), Home, History, Transaction detail, Review inbox (from Phase 3), Budgets, Trends, Settings (language, salary day, recurring list, lock, wipe data), Accuracy panel (dev).

**Backend, database, API.** Query layer with monthly aggregates (SQL `GROUP BY` month, category). Cache the month's totals in a `monthly_summary` table, refreshed when a transaction changes. Use `fl_chart` or similar for charts. Pay-cycle month (salary day to salary day) should be an option, not only calendar month.

**Dependencies.** Phases 1 and 3; wireframes from Phase 0.

**Testing**

- Golden-data test: load a fixed month of transactions and assert every dashboard number.
- Edge states: empty app, one transaction, no salary yet, only bonus, negative savings.
- Usability pass with 2–3 friends before the formal UAT.
- Check Nepali strings do not overflow on a small phone.

**Done checklist**

- [ ] All dashboard cards match hand-calculated numbers on the golden month
- [ ] Bonus never inflates income, savings rate or run-rate
- [ ] History search returns correct rows for each filter
- [ ] Budget alert fires once at 80% and once at 100%
- [ ] Trends hidden when there is under 2 months of data
- [ ] Language switch changes every visible string
- [ ] Dashboard loads in under 1 second with 2,000 transactions

## Phase 5: Safe-to-spend forecast and contingent ML (W13–18, about 80 hours)

**Goal.** Give a forecast that is honest and simple first, and add machine learning only where it measurably beats the simple version.

**Features and functions**

- F-47 Safe-to-spend (tier 1, always built): `safe_to_spend = balance + expected_salary_before_payday − daily_run_rate × days_left − known_obligations (EMI, rent)`. Run-rate uses salary-excluded, bonus-excluded spending of the last 30 days. Balance comes from the most recent bank message that states it; if none, ask the user.
- F-48 Low-balance warning: a notification when the forecast goes below zero before the next salary date.
- F-49 Pay-cycle / weekday shape (tier 2): after about 3 months, weight the run-rate by weekday and days since payday.
- F-50 Prophet or regression (C): only attempted if tier 2 is done and there are 3+ months of data. Prophet underperformed on volatile financial data in the guides, so expect a regression or moving-average to be the realistic candidate.
- F-31 Lightweight ML categoriser (C): multinomial Naive Bayes on remark text, used only for items the rules left Uncategorised. Gate: at least 150 labelled messages.
- F-32 Evaluation harness: fixed 80/20 split, same test set for rules-only and rules+ML, per-category precision/recall, a one-page comparison table for the report.

**Decision rules (write these in the report before running anything)**

- ML is kept only if it beats the rules-only baseline on the held-out set; otherwise it is reported as a negative result and removed from the app.
- Forecast tier 2/3 is kept only if it beats tier 1 on held-out weeks (mean absolute error).

**Screens / UI.** Safe-to-spend banner on Home with a plain explanation ("about 1,200/day until payday"); forecast detail with the assumptions listed (balance used, salary date, obligations counted); settings toggle to include/exclude an obligation.

**Backend, database, API.** On-device only. If ML is kept, train offline in Python (scikit-learn), export model weights (Naive Bayes needs only word counts) and load them in Dart. No server unless the cloud-backup decision changes (see Open decisions).

**Dependencies.** Phase 3 (income and recurring logic) and Phase 4 dashboard. ML also needs the labelled dataset to reach the gate.

**Testing**

- Backtest tier 1 on at least 8 historical weeks: forecast the end-of-week balance from data before that week and compare.
- Seeded scenarios: salary late by 3 days, bonus arrives, EMI due tomorrow, balance unknown.
- ML: compare accuracy, and also check that ML never overrides a user correction.

**Done checklist**

- [ ] Tier 1 forecast implemented and explained on screen
- [ ] Backtest result recorded (even if poor)
- [ ] Low-balance warning tested on a seeded scenario
- [ ] ML decision recorded: kept or dropped, with the numbers
- [ ] Forecast ignores bonus and counts EMI
- [ ] Report paragraph written for whichever result happened

## Phase 6: Privacy and security hardening (W8–19, parallel, about 50 hours)

**Goal.** Make the "on-device, encrypted, privacy-preserving" claim true and provable, since it is Objective 6 and a viva question.

**Features and functions**

- F-51 Encrypted database: replace plain SQLite with SQLCipher. The key is generated on first run and stored in the Android Keystore, never in code or preferences. Migration test: existing plain data is copied into the encrypted file, then the plain file is deleted.
- F-52 App lock: PIN or biometric on launch and after 60 seconds in the background; 5 wrong PINs adds a delay.
- F-53 Screen-capture block: `FLAG_SECURE` on dashboard, history and detail; also hides the app preview in the recents screen.
- F-54 Consent flow: before capture starts, a plain English/Nepali screen says what is read, what is stored, what is never stored (raw SMS, OTPs) and how to delete it. Consent timestamp saved. Basis: Individual Privacy Act 2018 (consent) — confirm exact wording with a legal source.
- F-55 Minimal permissions: Notification Access only in the release build; no contacts, location or storage. If the cloud/FCM decision (Open decisions) adds INTERNET, say so in the consent screen.
- F-56 Data wipe and own-data export: one button deletes the database and the key; export gives the user their own data.
- Log hygiene: no transaction fields in logs in release builds.
- Allowlist integrity: the capture service ignores every app and sender not on the list, and a test proves it.

**Screens / UI.** Consent screen, lock screen, Settings → Privacy (lock timeout, wipe, what is stored), a short "what this app stores" page.

**Backend, database, API.** Repository-class swap to SQLCipher; Keystore wrapper; a `privacy_audit.md` listing every data field, where it is stored and why.

**Dependencies.** Repository class from Phase 1. Do the SQLCipher swap before Phase 4 data grows, ideally by W10.

**Testing**

- Pull the database file with `adb` and confirm it cannot be opened without the key.
- Search the whole app storage for an account number or raw message string; expect none.
- Screenshot attempt on a locked screen returns blank.
- Wipe test: after wipe, a fresh launch shows onboarding and no old rows.
- Run MobSF or a similar static scan and record the findings.

**Done checklist**

- [ ] Database file unreadable without the key
- [ ] No raw SMS, OTP or full account number anywhere on the device
- [ ] Lock and `FLAG_SECURE` work on a real phone
- [ ] Consent text approved by supervisor and stored with a timestamp
- [ ] Declared permissions match the audit file
- [ ] Wipe and export tested
- [ ] Privacy section of the report written from the audit

## Phase 7: Integration, testing, UAT (W18–22, about 70 hours)

**Goal.** Prove the whole chain works on real data and with real users, and record honest numbers for the report.

**Features and functions**

- End-to-end run: 30 days of real use by you plus 2–3 volunteers, with consent.
- F-14 / F-57 Final parser and categoriser evaluation on the held-out set, per bank, per field, per category.
- F-32 Final baseline vs ML comparison table.
- F-58 User acceptance test: 5–10 users each complete a task list (add salary day, find last week's food spending, correct a category, read the safe-to-spend line, set a budget) and answer a short questionnaire (SUS-style, plus "would you trust it with your bank messages?").
- Non-functional checks: battery drain over 24 hours, startup time, database size at 5,000 transactions, behaviour with the phone offline.
- Compatibility: at least 3 Android versions or devices, including one low-end phone.
- Regression suite: all earlier tests re-run and recorded.

**Screens / UI.** Fix-list from UAT only; no new screens. Freeze features at W19.

**Backend, database, API.** Bug fixes, performance indexes, migration safety (the app upgrades without losing data).

**Dependencies.** Phases 1, 3, 4 and 6 done; Phase 5 and 2 finished or formally dropped.

**Testing.** The activity itself. Keep a defect log (ID, severity, found, fixed) for the report's testing chapter.

**Done checklist**

- [ ] Per-bank and per-field accuracy table final
- [ ] Categorisation baseline vs ML table final
- [ ] UAT completed with at least 5 users; results tabulated
- [ ] All severity-1 defects fixed; the rest listed as known issues
- [ ] Battery and performance figures recorded
- [ ] Feature freeze held from W19
- [ ] Evaluation chapter data ready (objective 7 and 8 evidence)

## Phase 8: Release, viva, post-launch (W21–24 and beyond, about 60 hours for W21–24)

**Goal.** Hand in the artefact and report, pass the demonstration, and decide what happens after.

**Features and functions**

- F-59 Release build: signed release APK with version number, release notes and a clean install tested on a fresh phone. Play Store publishing only if decided (see Open decisions); closed testing needs a developer account and a privacy policy page.
- F-60 Documentation: final report (\~10,000 words; M6), README with run steps, user guide (2 pages), test report, privacy audit, ethics evidence, Gantt and logbook.
- Viva preparation: a 10-minute demo script with a fallback video, a seeded demo database (so the demo does not depend on live SMS arriving), and answers to the likely questions (why not READ\_SMS, why rules before ML, how you handled bonus and EMI, what failed).
- Professionalism section: legal, ethical, social and professional issues (BCS requirement; M4).
- Slide 1 fix: replace "\[Your Name\]" on the title slide of the deck.

**Post-launch (after the viva, not required for the degree)**

- Crash and feedback loop: collect volunteer feedback; add banks one at a time by adding samples, a pattern file and tests.
- F-19 Nepali voice entry.
- F-61 Freemium tier and F-62 referral/insights ideas from the proposal, only after a privacy and legal review.
- Parser updates: banks change SMS wording without notice, so schedule a monthly re-test on fresh samples.

**Screens / UI.** About screen with version, privacy summary and feedback link; demo mode toggle (loads seeded data).

**Backend, database, API.** None for the FYP. A static privacy-policy page (GitHub Pages is enough) if the Play Store is used.

**Dependencies.** Phase 7 done; supervisor draft feedback (M5) incorporated.

**Testing.** Dry-run the demo twice on the exact device with Wi-Fi off; clean-install test; word count and referencing check; plagiarism check on the report.

**Done checklist**

- [ ] Signed APK installs and runs on a clean phone
- [ ] Demo works with seeded data and with one live notification
- [ ] Final report submitted with all appendices (consent forms, test logs, Gantt)
- [ ] Deck updated, name placeholder filled, rehearsed to time
- [ ] Viva Q&A sheet written and rehearsed with a friend
- [ ] Repository tagged `v1.0` and backed up outside your laptop
- [ ] Post-launch list agreed with supervisor

## Addendum: findings from real data (13 Oct 2026)

These came from real eSewa notifications and bank SMS collected after the first draft. They add to the phases above and are tracked as F-65 to F-73 (F-71 to F-73 come from the Nabil/Fonepay/eSewa service menus).

- **Phase 1 (parser).** Accept `NPR`, `NPR.`, `Rs` and `Rs.` before an amount (`NPR. 180.0` failed in v1). Treat "received" as a credit word. eSewa notifications have no date, so use the notification post time (F-65). Read the full notification text, because wrapped lines and preview text such as "now" can appear in a pasted copy. Flag a remark that looks cut short (F-68). Unfinished: confirm eSewa's Android package name on the device, since it is not yet verified.
- **Phase 2 (wallets).** eSewa notifications carry only the amount and the sender, which is a bank or a person. They have no remark, balance, date or transaction ID.
- **Phase 3 (categorising).** "Received from \<own bank>" is an internal wallet load, not income (F-66), and must not be double-counted with the bank's ESEWA LOAD debit (F-69). Payee memory (F-67) lets one confirmation cover all later payments to that payee. About half of the first 13 samples have enough information to categorise automatically; the rest need one tap. Do not promise zero manual input.
- **Phase 3-4 (review).** Unclear items go to the batched review inbox (F-64). "My note" (F-63) lets the user add the full remark.
- **Data (Phase 0).** Samples use the 9-column `samples.csv`. Collect OTPs, promos and other non-transactions (label `NOT_TXN`) at roughly 5 to 10 per 30 messages, set aside about 30% as a test set before writing rules, and never save real names, numbers or OTP codes.
- **Service menus (13 Oct).** The Nabil quick-payment list, the Fonepay list and the eSewa service pages showed payment types the first taxonomy lacked (Insurance, Travel & Tickets, Entertainment, Shopping, Government, Savings & Investment) and message types banks send themselves (charges, interest, refunds). The taxonomy grew from 18 to 27. Collect one sample per payment type (`docs/data-collection.md`).
- **Privacy.** AI coding tools send file contents to cloud services, so volunteer consent wording should cover that (D21).

- **Branding (17 Oct).** Palette chosen from the logo and an onboarding reference (F-74, DEC-22). Login, OTP and personal-details screens in the reference are not built (DEC-23).
- **Parser v3 (17 Oct).** First scoring of v1/v2 on 15 samples, then v3 built and re-scored (type 100%, amount 100%, bank 80%, category 10/10 labelled; training scores). Open: bank from sender ID, unlabelled MPAY/IME/CLW messages, Bikram Sambat dates, new-message test (F-75, DEC-24 to DEC-26).

## Open decisions

These were discussed but never finalised. Each has a recommended default so you are not blocked; tick one when you decide.

| # | Decision | Options | Recommended default | Decide by |
| --- | --- | --- | --- | --- |
| D1 | Goal-based savings pots | Keep, or leave out (removed from the FDD; status unclear) | Leave out; list as Future Work | Phase 0 |
| D2 | Offline-first vs Firebase push | No INTERNET permission (stronger privacy claim) or FCM (adds INTERNET) | Local notifications only; no FCM | Phase 0 |
| D3 | Cloud backup / sync | None, or optional encrypted backup via a small FastAPI server | None in the FYP; Future Work | Phase 0 |
| D4 | Voice entry in Nepali | Build, or defer | Defer (F-19) | Phase 4 |
| D5 | Bikram Sambat (BS) dates | Show BS alongside AD, or AD only | AD stored, BS display toggle if time allows | Phase 4 |
| D6 | CSV / PDF export | Own-data export only, or reports | CSV of own data only (F-56) | Phase 6 |
| D7 | Calendar history view (from eExpense) | Add, or list only | List only | Phase 4 |
| D8 | OCR of receipts (from eExpense) | Add, or skip | Skip; never agreed | Phase 0 |
| D9 | iOS scope | Paste/share path only, or a full iOS build | Paste/share only, and only if the Phase 2 gate passes | Phase 2 |
| D10 | Wallet capture timing | Phase 2, or after launch | Phase 2 as contingent | W8 |
| D11 | Forecast model | Tier 1 only, or Prophet / regression | Tier 1, then compare | Phase 5 |
| D12 | Where the test dataset lives | Private repo, encrypted drive | Private encrypted storage; only redacted rows in the repo | Phase 0 |
| D13 | Play Store vs demo APK | Closed testing on Play, or sideloaded APK | Signed APK; Play only after the viva | Phase 8 |
| D14 | Monetisation timing | During the FYP, or after | After; not graded | Phase 8 |
| D15 | Pay-cycle month vs calendar month | One or both | Both, with a setting | Phase 4 |
| D16 | Bonus paid inside the salary credit | Ask the user, or ignore | Ask once when the credit exceeds the usual salary by over 15% | Phase 3 |
| D17 | Flutter vs native Kotlin | Flutter + Kotlin channel, or full native | Flutter UI with a small Kotlin capture service | Phase 0 |
| D18 | How the user is asked to categorise (DECIDED) | Batched inbox, or an immediate notification after each payment | Batched inbox is the default (F-64). An optional immediate-prompt setting is Future Work, only if time allows | Decided 13 Oct 2026 |
| D19 | Backend (Node.js considered) | None; or Node.js/Fastify; or Python/FastAPI | **DECIDED 13 Oct 2026: no backend for the FYP.** Node.js only if optional encrypted backup is added later | Decided |
| D20 | Freeze the category taxonomy | Original 14, proposed 18, or 27 | **DECIDED 13 Oct 2026: 27 categories** (adds Insurance, Travel & Tickets, Entertainment & Leisure, Shopping, Government & Taxes, Savings & Investment, Bank Charges & Fees, Interest, Refund/Reversal; renames Mobile/Recharge and Loan/EMI) | Decided |
| D21 | Consent wording and AI tools | Agents like Cursor send file contents to cloud AI services | **DECIDED 13 Oct 2026: yes.** Add AI-tools wording to the consent line; check Cursor Privacy Mode; tell the ethics contact; keep names, numbers and codes redacted | Decided (user actions pending) |
| D22 | Codebase architecture | A: layered MVVM; B: feature-first; C: Clean Architecture | **Decided 9 Nov 2026: feature-first** (DEC-27), based on the base skeleton, trimmed. See `docs/architecture.md` | Decided |

If you pick differently from a default, change the affected phase text and the master list so they stay in sync.

## Research and learning list

| Topic | Why it matters | Needed in |
| --- | --- | --- |
| Flutter + platform channels | Your UI is Flutter; capture is native, so you must pass data between the two | 0, 1 |
| Kotlin basics | The notification listener must be written in Kotlin | 1 |
| `NotificationListenerService` limits | Some phones kill background services; need battery-optimisation guidance | 1 |
| Google Play SMS/Call Log permission policy | Explains why `READ_SMS` is avoided and what a Play release would need | 1, 8 |
| Regex in Dart and test-driven parsing | Your parser is the core; every bug is a regex or ordering bug | 1 |
| SQLite, `sqflite` / Drift | Local storage and the monthly aggregates | 1, 4 |
| SQLCipher + Android Keystore | Makes the encryption claim real | 6 |
| Individual Privacy Act 2018 (Nepal) | Consent and handling of personal data | 0, 6 |
| Bank and Financial Institution Act 2073 s.109 | Bank secrecy angle for reading bank messages | 0, 6 |
| Labour Act 2074 s.37 (festival expense) | Backs the salary/bonus split; read the primary text, not a summary | 3 |
| NRB / bank SMS format rules | None found; ask 2 banks, otherwise state "no standard" in the report | 1 |
| Nepali text handling (Unicode, Devanagari normalisation) | Remarks may be in Devanagari; matching needs normalisation | 3 |
| Fuzzy matching (`difflib`, edit distance) | Typos like "restaurent" | 3 |
| Text classification for short text (Naive Bayes, TF-IDF) | Needed to defend the ML layer | 5 |
| Train/test split, precision/recall, baselines | Needed for the Method/Data/Measurement framework | 1, 5, 7 |
| Time-series forecasting basics, MAE backtesting | To judge tier 1 against Prophet or regression honestly | 5 |
| Chart library (`fl_chart`) | Dashboard charts | 4 |
| Flutter localisation (ARB files) | English/Nepali UI | 4 |
| Local notifications (`flutter_local_notifications`) | Budget and low-balance alerts without a server | 4, 5 |
| UAT design and SUS questionnaire | Part of the testing marks | 7 |
| Static security scan (MobSF) | Evidence for the security section | 6, 7 |
| BCS project criteria and professionalism section | Marking scheme; legal, ethical, social issues | 0, 8 |
| Ethics registration and consent forms | Required before collecting data from people | 0 |
| APK signing, versioning, Play Console (if used) | Release step; developer account and privacy policy | 8 |
| Open-source reference apps (PennyWise AI) | Study SMS patterns; do not copy code; check the licence | 1 |

## Risks and likely problem areas

| Risk | Why it is likely | What to do |
| --- | --- | --- |
| Too little labelled data | Only 8 real labelled messages today; ML needs 150–300 | Start collecting in W1; keep ML contingent; report rules-only if the gate fails |
| Bank wording changes or unseen formats | Five different structures appeared in the first seven messages | Per-bank pattern files, "unsupported bank" state, manual entry fallback |
| Phones kill the background listener | Many Android makers stop background services | Foreground notification, battery-optimisation instructions, test on 3 devices |
| Balance picked as amount, or wrong direction | First-match logic failed on balance-first messages | Balance-aware parsing, confidence flag, review inbox |
| Bonus counted as income | Distorts savings rate and forecast | Separate Bonus type; test the 85,000 + 85,000 case; ask when salary credit is unusually high |
| Roman-Nepali remark ambiguity | "bhat" vs "Bhat Bhateni", random remarks | Specific-before-generic ordering, review inbox, correction memory |
| Duplicate transactions | Same alert arrives as SMS and notification; wallet and bank both show a payment | Dedupe key and a test |
| Forecast is inaccurate | Spending is volatile; Prophet underperformed in your sources | Tier 1 arithmetic first; backtest; state accuracy honestly |
| Privacy or legal challenge | Reading bank messages is sensitive | Allowlist, no raw text, consent, audit file, minimal permissions |
| Play Store rejection | `READ_SMS` is restricted | Notification listener path; demo APK if Play is not needed |
| Scope creep | Many agreed and unagreed ideas (voice, OCR, cloud, iOS) | Feature freeze at W19; every extra goes through Open decisions |
| Time overrun | Phases overlap and total effort is near 620 hours | Weekly check against the Gantt; drop contingent items first, never testing or the report |
| Evaluation looks overfitted | Rules were written from the same samples they are tested on | Hold out a test set before writing patterns and never tune on it |
| Losing work or data | Single laptop, sensitive samples | Git remote, encrypted backup, redaction before saving |
| Report starts too late | Final report is about 10,000 words | Write a section after each phase, not at the end |

## First three steps to start now

1. **Set up the data pipeline this week.** Write the redaction script (F-15), move your 8 real messages into `samples.csv`, and message 10 people (family, classmates) for consented samples across different banks and wallets. Data is the slowest part of the project, so it starts first.
2. **Get a real capture running.** Install Flutter and Android Studio, create the repo, and build a hello-world app on your own phone. Then add a minimal Kotlin `NotificationListenerService` that logs the sender and amount of one test notification (no storage yet). If this works, the riskiest technical piece is proven.
3. **Port the parser with tests first.** Move `parser.py` and the v2 fixes into Dart, bring the 17 scenario cases and 8 real messages across as unit tests, and split the samples into write-set and held-out set before adding any new rules.

Also this week: submit the ethics form if not already done, and replace "\[Your Name\]" on slide 1 of the deck.
