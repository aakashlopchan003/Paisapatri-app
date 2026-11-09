# PaisaPatri — decisions

Update this file whenever a decision changes. AI agents must follow it.
IDs here are `DEC-n`. The roadmap's open decisions use `Dn` (listed under "Cross-reference").

## Decided
| ID | Decision | Why | Date |
| --- | --- | --- | --- |
| DEC-1 | Capture with Android `NotificationListenerService` + sender allowlist (not `READ_SMS`) | Play-policy friendly and narrower access | 2026 |
| DEC-2 | Never store raw SMS/notification text; store extracted fields only | Privacy, Individual Privacy Act 2018 | 2026 |
| DEC-3 | On-device, offline-first, SQLCipher-encrypted database | Privacy claim (Objective 6) | 2026 |
| DEC-4 | Flutter UI + small Kotlin capture service (roadmap D17) | One codebase for UI, native access where needed | 2026 |
| DEC-5 | Hybrid categoriser: rules first, lightweight ML only if it beats the baseline on held-out data | Small dataset; explainable | 2026 |
| DEC-6 | Bonus excluded from income, savings rate and forecast run-rate | Avoids misleading numbers | 2026 |
| DEC-7 | Forecast in tiers: safe-to-spend arithmetic first; Prophet/regression only if it beats tier 1 | Honest, simple first | 2026 |
| DEC-8 | **Batched review inbox** is the default for unclear items (F-64, roadmap D18) | Does not interrupt the user | 13 Oct 2026 |
| DEC-9 | **"My note"** optional field on every transaction (F-63) | Remarks can be cut off by banks | 13 Oct 2026 |
| DEC-10 | eSewa "received from <own bank>" = Wallet Load (internal transfer), not income; no double-count with the bank debit (F-66, F-69) | Found in real eSewa samples | 13 Oct 2026 |
| DEC-11 | eSewa/Khalti notifications carry no date; use the notification post time (F-65) | Real samples | 13 Oct 2026 |
| DEC-12 | Unclear or truncated remark goes to the review inbox, never a guessed category (F-68) | Safe degradation | 13 Oct 2026 |
| DEC-13 | Android only for the FYP; iOS is paste/share only and contingent | Scope | 2026 |
| DEC-14 | Coding with Cursor's agent; research, data and decisions discussed in Claude; roadmap and docs in this repo are the shared source of truth | Workflow | 13 Oct 2026 |
| DEC-15 | Real samples are gitignored; repo is private; a second copy is kept outside Git | Consent covers the project, not publishing | 13 Oct 2026 |
| DEC-16 | Do not promise "zero manual input": claim automatic capture and categorisation where the message supports it, one-tap review for the rest | About half of the first 13 samples are categorisable from text alone | 13 Oct 2026 |
| DEC-17 | **No backend for the FYP** (roadmap D19). Node.js is not needed. | On-device by design. A server adds `INTERNET`, hosting, security and consent work with no marks, and weakens the privacy claim. Python for offline data/evaluation scripts only. Optional encrypted backup later: small Node.js (Fastify/Express + TypeScript) service. | 13 Oct 2026 |
| DEC-18 | **Category taxonomy frozen at 27** (roadmap D20), listed below. Changing it needs a new decision here plus an update to samples, parser tests, DB seed and UI together. Category names are exact strings. | Labels drift if the list is not fixed. Built from the Nabil quick-payment, Fonepay and eSewa service menus. | 13 Oct 2026 |
| DEC-19 | **Consent wording covers AI tools** (roadmap D21). Volunteers are told redacted messages may be processed by AI tools such as Claude and Cursor. Check Cursor Privacy Mode before it reads any sample. Inform the ethics contact. | Coding agents send file contents to cloud AI services. | 13 Oct 2026 (user to add the wording and check Cursor) |
| DEC-20 | **Money-flow rules.** (a) Credit-card payment counts as `Loan/EMI/Credit Card`; card purchases are not counted again. (b) `Savings & Investment` (Mero Share, SIP, broker, pension fund, sahakari/micro-finance deposit) is money out but counts toward savings, not spending. (c) `Refund/Reversal` is neutral: it nets against the original debit, not income. (d) `Wallet Load` and `Transfer` are neutral. (e) `Bank Charges & Fees` is its own category; interest credited is `Interest`. | Avoids double counting and keeps the savings rate honest. | 13 Oct 2026 |
| DEC-21 | **Service-name lookup comes first.** eSewa/Fonepay/bank messages that name a service (Electricity, Bus Ticket, School Fee) are categorised from a lookup table (`docs/parser-spec.md`), before keywords or ML. Works even with no remark. | Service names are exact, so this is the most reliable rule. Needs checking against real samples. | 13 Oct 2026 |
| DEC-22 | **Colour theme chosen** (17 Oct 2026): deep logo green `#1A6C56` (with `#0C4C3C`) for buttons and app bar, bright green `#02B152` for non-text accents only, mint `#EEFFED` for splash and soft surfaces, cream `#FCFBF7` for the logo. All tokens and contrast results are in `docs/design-system.md`. No hex codes inside widgets. | White text on `#02B152` measures 2.8:1, below WCAG, so buttons use the deeper green. | 17 Oct 2026 |
| DEC-23 | **No accounts.** PaisaPatri has no login, sign-up, Google/Facebook sign-in, OTP, password reset or personal-details form. Onboarding is local setup only (consent, notification access, banks, pay day, optional local app lock). The onboarding image supplied is a colour/layout reference, not a feature list. | Follows DEC-3 and DEC-17 (on-device, no backend) and avoids collecting personal data. | 17 Oct 2026 |
| DEC-24 | **Tests and docs in Git contain only synthetic messages** (real format, fake numbers and names). Real messages live only in the gitignored `data/samples.csv`. | An older test file held a full account number, a phone number and a name; cleaned on 17 Oct 2026. Old values remain in Git history (private repo). | 17 Oct 2026 |
| DEC-25 | **Bank identity comes from the SMS sender ID or notification package first;** text signals are a fallback. `SENDER_BANKS` stays empty until filled from a real phone. | Many messages carry no bank name (plain fund-transfer text, `Rem:/Nar:` format). | 17 Oct 2026 |
| DEC-26 | **Parser v3 (`parser_v3.py`) is the reference for the Dart port.** Score new messages with `tools/evaluate_parser.py` before changing any rule; report training and new-message scores separately. | Avoids overstating accuracy from a small, already-seen set. | 17 Oct 2026 |
| DEC-27 | **Codebase structure is feature-first** (roadmap D22). Each feature folder has `data/`, `domain/` and `presentation/` layers, following the base skeleton the student chose, trimmed for PaisaPatri: `auth`, `network` and `session` are not used (no accounts, no backend), and use cases are added only where needed. The state-management package is not chosen yet (ask before adding). Layout and rules: `docs/architecture.md`. | Keeps each feature's files together, matches the skeleton the student is building on, and scales to the planned features. Option A (layered MVVM) was the alternative; see `docs/architecture-options.md`. | 9 Nov 2026 |

### Frozen taxonomy (27, DEC-18)
- **Spending (17):** Food & Dining, Groceries, Transport, Travel & Tickets, Entertainment & Leisure, Shopping, Utilities & Bills, Mobile & Internet, Rent/Housing, Insurance, Loan/EMI/Credit Card, Education, Healthcare, Government & Taxes, Bank Charges & Fees, Cash Withdrawal, Other Spending
- **Savings (1):** Savings & Investment (money out, but counted as saving, not spending)
- **Income (5):** Salary, Bonus, Reward/Cashback, Interest, Other Income
- **Neutral (3):** Transfer, Wallet Load, Refund/Reversal
- **Fallback (1):** Uncategorised

## Cross-reference to the roadmap's open decisions
D1 savings pots, D2 FCM vs offline-first, D3 cloud backup, D4 voice entry, D5 Bikram Sambat, D6 export, D7 calendar view, D8 OCR, D9 iOS scope, D10 wallet timing, D11 forecast model, D12 dataset location, D13 Play Store vs APK, D14 monetisation timing, D15 pay-cycle month, D16 bonus inside the salary credit, D17 Flutter vs native, D18 batched review (decided), D19 backend (decided), D20 taxonomy freeze (decided), D21 consent and AI tools (decided). D22 codebase architecture (decided: feature-first, DEC-27, see `docs/architecture.md`). See `docs/roadmap.md`.
