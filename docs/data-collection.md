# Data collection guide

Goal: 30 messages across 5+ banks/wallets for Phase 1; 150 to 300 for categorisation.

## What to collect (variety, not volume)
- Many banks and wallets: Nabil, NMB, Laxmi Sunrise, Citizens, eSewa, Khalti and others. Several per bank.
- Every type per bank: debit/withdrawal, credit/deposit, fund transfer, ATM, QR/merchant, wallet load, salary, EMI/loan, reward/cashback, bonus.
- Non-transactions (label `NOT_TXN`): bank OTPs, bank promos, balance or login alerts. Aim for about 5 to 10 per 30 messages. A non-bank OTP (e.g. Google) is allowed, one is enough.
- Messy remarks: Roman-Nepali, Devanagari, typos, empty, random, truncated.
- Balance-first wording and messages with both credit and debit words.
- Keep messages that confuse the parser; they are the most valuable.

## One sample per payment type (Phase 1 checklist)
Variety beats volume. Collect one redacted real message for each type below; tick them off.
- Nabil quick payments: Mobile Cash, Load Wallet, Bill Payments, Mobile Topup, Data Package, Credit Card Payment.
- Fonepay: Electricity, Domestic Flight, International Flight, Internet, Toll, TV, Government Revenue, Insurance, Water, School, EMI, Cable Car, Bus, Park, Pension Fund, Food, Mero Test, QR merchant.
- eSewa: Topup, Electricity, Khanepani, Bus Ticket, Movie, Hotel, Insurance, School/College Fee, Mero Share/SIP, Credit Card, EMI, ATM Withdraw, Lenden/Request Money, Merchant payment.
- Bank-originated: SMS charge, annual card fee, interest credited, refund of a failed payment, salary, EMI debit.
Record, for each, whether the message names the service (that decides whether the lookup in `docs/parser-spec.md` works) and whether any remark is shown.

## Do not
- Collect near-duplicates from one bank to inflate numbers.
- Edit the wording to make it parse (truncated text stays truncated).
- Save real account numbers, phone numbers, names or OTP codes.

## Redaction and consent
- Mask long numbers to the last 4 digits; names become `[name]` / `[person]`; OTP codes `[code]`.
- Volunteers give a written yes. Their consent wording should say redacted messages may be processed by AI tools (DEC-19).
- `data/samples.csv` is private and gitignored; keep a second copy outside Git.

## Labels
- `expected_type` and `expected_amount` come from the message text.
- `label_category` only when the message says what it is or the owner confirms. Blank is better than a guess. Use the taxonomy in `docs/data-schema.md`.

## Keep the file clean
- Do not open `data/samples.csv` in Excel and save it: Excel rewrites dates (`10/11/2026`) and can break columns. Edit it with the script or Notepad. Dates stay `YYYY-MM-DD`.
- Tests and docs in Git must use made-up messages only (real format, fake numbers and names). Real messages stay in `data/samples.csv`.
- Rows still without a `label_category` (ask the owner): the `MPAY ...`, `IME-...` and `MB/.../CLW/...` messages.

## Tool
`tools/add_sample.bat` (double-click) or `python tools/add_sample_v3.py`. Paste the message, then press Enter on an empty line. Close Excel first.

## Test split
Before writing parser rules, set aside about 30% at random as a test set (add a `split` column). Never tune on it.
