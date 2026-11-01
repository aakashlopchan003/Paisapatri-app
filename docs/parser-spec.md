# Parser specification (from real samples)

Reference code: `parser_prototype/parser.py` (v1) and `v2_scenarios/improvements.py` (v2 spike).
Test against the real, redacted messages in `data/samples.csv`.

## Inputs
- **Bank SMS** and **wallet push notifications** (eSewa). For notifications, read the full text
  (`EXTRA_BIG_TEXT` if present, else `EXTRA_TEXT`), the post time and the package name; do not
  rely on the preview. A copy pasted from the notification shade may include artifacts such as "now" and
  wrapped bank names.
- Allowlisted senders/packages only. eSewa's Android package name is **not yet verified**: check it on the phone
  (`adb shell pm list packages`) before adding it.

## Fields to extract
| Field | Rule |
| --- | --- |
| Amount | `NPR`, `NPR.`, `Rs`, `Rs.` followed by a number with optional commas/decimals. v1 misses `NPR.`. Skip amounts after avl/avbl/available/bal/balance/limit. |
| Direction | Earliest keyword wins. Debit: debited, dr, withdrawn, withdrawal, paid, sent, deducted, purchase. Credit: credited, cr, deposited, deposit, **received**. Transfer: "fund transfer", "transfer of". Both debit and credit words present → low confidence. |
| Date | Length-anchored patterns: `DD/MM/YYYY HH:MM:SS`, `DD-Mon-YYYY HH:MM:SS`, `YYYY-MM-DD`, `DD/MM/YYYY`, `DD/MM/YY`. If none (eSewa notifications) → use the notification post time. |
| Account | Masked only, e.g. `...4508`, `080##06522`, `###3041`. |
| Bank | Signature (`-Laxmi Sunrise`), sender ID/package, support email domain, masking style. |
| Remark | After `Remarks:` or in brackets. May be **truncated**; never fuzzy-match partial words. Bank codes such as `MB/…/CLW` or `FT/…` are channel hints, not free text. |

## Real formats seen so far
- Nabil: `Dear Customer, Your 080##… has been deposited/withdrawn by NPR …, Remarks: …` with trailing `Download App: …`.
- Citizens: `Dear <name>, ###… is debited by NPR … on YYYY-MM-DD, Remarks: MB/…/CLW/…`.
- Laxmi Sunrise: `… has been credited/debited by NPR … on DD/MM/YY. Remarks:FT/…` or `ESEWA LOAD/…` ending `-Laxmi Sunrise`.
- NMB: `A/C 1#15 deposited/withdrawn NPR … (FBS:IBFT:…)` or `(DLA_ESEWA_…)`; also `Fund transfer of NPR … to A/C … was successful on …`.
- eSewa notification: `Dear <name>, You have received NPR. 180.0 from <BANK or person> in your eSewa account.` No date, remark, balance or ID.
- Core-banking style (Agricultural Development Bank, as reported by a volunteer; the same layout is sent to iPhone users; sender ID not yet checked): `Dear <name> A/C 041##010, NPR 8,000.00 deposited|withdrawn on DD/MM/YYYY HH:MM. Rem:Chg:0.00 Chq:N/A Nar:<text> Bal:<n>.` The real remark is the `Nar:` value; `Nar:credit` means no remark; the time has no seconds.

## Must not become transactions
OTPs, verification codes, login alerts, promotions, balance-only messages. Label `NOT_TXN` in samples.

## Behaviour
- Missing amount/direction/date → save with `needs_review = true` and a reason.
- Duplicates: same alert as SMS and notification → one row (bank + amount + time within 60 s + account mask).
- eSewa "from <bank name>" = Wallet Load (internal transfer), not income; match it with the bank's ESEWA LOAD / DLA_ESEWA debit.
- eSewa "from <person>" = Transfer; ask the user to confirm once, then remember the payee.
- No remark: use the channel (ATM, eSewa load, reward, IBFT), the payee memory and recurrence; otherwise review inbox.

## Service-name lookup (first rule, DEC-21)
If the message or remark names a service, map it directly. Based on the Nabil quick-payment and Fonepay menus and the eSewa service pages. Check each row against real samples before trusting it.

| Service name contains | Category |
| --- | --- |
| topup, top-up, data pack, data/voice, internet | Mobile & Internet |
| electricity, khanepani, water, waste, TV | Utilities & Bills |
| flight, airlines, bus, hotel | Travel & Tickets |
| toll, bluebook | Transport |
| cable car, park, zoo, movie, event, voting | Entertainment & Leisure |
| insurance, policy, term life, endowment | Insurance |
| credit card, EMI, policy loan | Loan/EMI/Credit Card |
| school, college, montessori, IELTS, language test, Mero Test, e-learning | Education |
| health, hospital, diagnostic | Healthcare |
| revenue, govt, traffic fine | Government & Taxes |
| Mero Share, SIP, broker, NEPSE, securities, pension, sahakari, micro finance | Savings & Investment |
| mobile cash, ATM | Cash Withdrawal |
| load wallet, ESEWA LOAD, DLA_ESEWA | Wallet Load |
| request money, Lenden, FT/, IBFT, person-to-person | Transfer |
| food | Food & Dining |
| charge, fee, SMS charge, annual fee | Bank Charges & Fees |
| interest | Interest |
| refund, reversal, reversed | Refund/Reversal |

Not in any menu yet: Salary, Bonus, Rent, Groceries, Shopping. These come from remark keywords, recurrence and the user.

## Rule order
1. Service-name lookup. 2. Channel rules (eSewa, Khalti, IBFT, FT/, MB/). 3. Payee and correction memory. 4. Remark keywords (lexicon). 5. Recurrence. 6. Uncategorised, review inbox.

## Parser versions and results (17 Oct 2026)
- `parser_prototype/parser.py` (v1) and `v2_scenarios/improvements.py` (v2) are kept unchanged for comparison.
- **`parser_prototype/parser_v3.py` is the reference to port to Dart.** Tests: `python -m unittest test_parser_v3` (42 tests, synthetic messages only). Scoring: `python tools/evaluate_parser.py --verbose` (reads the private samples file locally).
- Score on the 15 samples: type 100% (v1 80%), amount 100% (v1 87%), bank named 80% (v1 47%), category 10/10 on labelled rows (v1 50%, v2 10%). **These are training scores**: the rules were written after seeing these messages. The real test is new messages, scored before any rule is changed.

Fixed in v3: `NPR.` amounts; "received" as credit; direction read only from the part before the remark; date with time but no seconds; `Rem:` / `Nar:` remarks (the `Nar:` value is the remark); remarks no longer cut at the "..." used in masked numbers; trailing bank signature removed from remarks; eSewa notifications detected from "in your eSewa account", with the post time used for the date; category rules for the frozen 27 categories.

Still open:
1. Bank from text alone is weak. The app must use the SMS sender ID or notification package (`SENDER_BANKS` is empty on purpose; fill it from a real phone). The `Rem:Chg:… Chq:` layout is read as Agricultural Development Bank with `bank_source = format` (a guess from the layout; the sender ID overrides it). A plain "Fund transfer ..." message has no signal and stays bank = unknown.
2. Remarks with no rule yet: `MPAY ...`, `IME-...` (looks like a remittance credit), `MB/.../CLW/...`, `Nar:credit`. The two debits are labelled Other Spending by the owner. The three credits are unlabelled. All go to the review inbox until a rule is agreed.
3. Truncation is only a weak flag (a final single letter). No fuzzy matching on remarks.
4. Dates are read as DD/MM. Bikram Sambat dates are not handled.
5. Wallet notification text from Khalti and others is not seen yet.
6. Duplicate matching (SMS + notification) and the recurrence rules are not built.

## Measuring
Split samples before writing rules (~70/30). Report per-field and per-bank accuracy on the held-out part only.
