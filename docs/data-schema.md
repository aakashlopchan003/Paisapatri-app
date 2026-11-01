# Data schema

## data/samples.csv (local, gitignored)
One row per real message, already redacted. 9 columns:

| Column | Meaning |
| --- | --- |
| id | Running number |
| bank | Bank or wallet name (`eSewa` for wallet notifications) |
| redacted_text | The message as sent, with account numbers masked (`...4508`), names as `[name]` / `[person]`, OTP codes as `[code]` |
| source | self / volunteer / public |
| consent | self / yes |
| date_collected | YYYY-MM-DD |
| expected_type | CREDIT / DEBIT / TRANSFER / NOT_TXN (answer key for parser tests) |
| expected_amount | Number (answer key). Blank for NOT_TXN |
| label_category | A category from the taxonomy below; blank if unsure |

Planned additions (one update, together): `channel` (sms / notification), `my_note`, `remark_truncated` (yes/no), `split` (train/test).

Rules: save the real wording (do not "fix" truncated text); never keep real account numbers, names or OTPs.

## Category taxonomy (frozen, 27, see DEC-18)
Names are exact strings: use them character for character in `label_category`, parser tests, the database and the UI.
- **Spending (17):** Food & Dining, Groceries, Transport, Travel & Tickets, Entertainment & Leisure, Shopping, Utilities & Bills, Mobile & Internet, Rent/Housing, Insurance, Loan/EMI/Credit Card, Education, Healthcare, Government & Taxes, Bank Charges & Fees, Cash Withdrawal, Other Spending
- **Savings (1):** Savings & Investment (money out, but counted as saving, not spending)
- **Income (5):** Salary, Bonus, Reward/Cashback, Interest, Other Income
- **Neutral (3):** Transfer, Wallet Load, Refund/Reversal
- **Fallback (1):** Uncategorised

Neutral categories are excluded from income and spending totals. `Savings & Investment` is excluded from spending and counted toward savings. `Refund/Reversal` nets against the original debit.
The dashboard shows the four groups first (Spending, Savings, Income, Neutral), then the categories inside each.
Older labels to fix in samples: `Reward / Cashback` becomes `Reward/Cashback`; `Loan/EMI` becomes `Loan/EMI/Credit Card`; `Mobile/Recharge` becomes `Mobile & Internet`.

## On-device database (draft, Phase 1)
- `transactions`: id, ts, amount, direction, bank, account_mask, remark, my_note, category, confidence, source, channel, needs_review, review_reason
- `categories`: id, name, kind (spending / savings / income / neutral)
- `corrections`: normalised_remark, category
- `payees`: payee_key (name or account suffix), category
- `recurring`: label, amount, day_of_month
- `budgets`: category, monthly_limit
- `settings`: key, value

No column ever holds the raw message.
