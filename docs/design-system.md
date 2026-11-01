# PaisaPatri design system: colours

Decided 17 Oct 2026 (DEC-22). The student chose this palette from two images: the PaisaPatri logo and a set of onboarding screens used as a colour and layout reference. Hex values were measured from the image pixels (about ±2 per channel). The logo file is `docs/brand/paisapatri-logo.png`.

**Rule for agents:** every colour in the app comes from a token below. No hex codes typed inside widgets. If a colour is missing, ask.

## Brand colours (from the images)
| Token | Hex | Where it came from | Use |
| --- | --- | --- | --- |
| `brandDeep` | `#0C4C3C` | Darkest part of the logo gradient | Status bar, headings on mint, pressed state |
| `brandPrimary` | `#1A6C56` | Main logo green | App bar, primary buttons (white text), active tab, links |
| `brandWordmark` | `#105745` | "Paisapatri" lettering | Wordmark, large titles |
| `accent` | `#02B152` | Onboarding reference buttons | Non-text highlights: progress bars, chart fills, icons, success check, switches |
| `mint` | `#EEFFED` | Onboarding splash background | Splash screen, selected rows, soft cards, banners |
| `cream` | `#FCFBF7` | Logo background | Logo canvas, optional app background |

## Neutrals
| Token | Hex | Source | Use |
| --- | --- | --- | --- |
| `surface` | `#FFFFFF` | Onboarding screens | Cards, sheets, input fields |
| `textPrimary` | `#121212` | Onboarding titles (near black) | Body and titles |
| `textSecondary` | `#5F6B66` | Proposed | Captions, helper text |
| `placeholder` | `#9C9C9C` | Onboarding input hints | Placeholders and disabled text only (see contrast) |
| `divider` | `#E4E4E4` | Onboarding screens | Lines, borders |

## Meaning colours (proposed, not from the images; confirm or change)
| Token | Hex | Use |
| --- | --- | --- |
| `income` | `#0B7A3B` | Income amounts and the "+" sign |
| `expense` | `#C62828` | Spending amounts and the "−" sign |
| `neutralFlow` | `#5F6B66` | Transfer, Wallet Load, Refund/Reversal (not income or spending) |
| `savings` | `#1A6C56` | Savings & Investment |
| `review` | `#B26A00` | Review-inbox badge and "needs review" |

Never show meaning by colour alone. Always add a sign (+ / −) or an icon, so colour-blind users can read it.

## Contrast check (WCAG 2.1, measured)
| Pair | Ratio | Result |
| --- | --- | --- |
| White on `brandPrimary` `#1A6C56` | 6.3 : 1 | Pass (use for button labels) |
| White on `brandDeep` `#0C4C3C` | 9.9 : 1 | Pass |
| `brandPrimary` on `mint` | 6.1 : 1 | Pass |
| `income` `#0B7A3B` on white | 5.4 : 1 | Pass |
| `expense` `#C62828` on white | 5.6 : 1 | Pass |
| `textSecondary` on white | 5.6 : 1 | Pass |
| White on `accent` `#02B152` | **2.8 : 1** | **Fail** for text (needs 4.5, or 3 for large text) |
| `accent` on white | **2.8 : 1** | **Fail** for text |
| `placeholder` `#9C9C9C` on white | **2.8 : 1** | **Fail**; hints and disabled only, never real content |

So the bright green `accent` is for shapes and icons only. Do not put white text on it and do not use it for text. The reference screens use that combination; we do not copy it.

## Component rules
- Primary button: fill `brandPrimary`, label white, corner radius about 12, full width on forms.
- Secondary button: white fill, 1 px `brandPrimary` border, label `brandPrimary`.
- Input: white fill, `divider` border, `brandPrimary` border when focused, `placeholder` hint.
- Success dialog: white card, large `accent` check circle, one `brandPrimary` button.
- Splash: `mint` background with the logo centred.
- Light theme only for the FYP. Dark mode is out of scope unless added as a new decision.

## Flutter reference (for `app/lib/theme/app_colors.dart`)
```dart
import 'package:flutter/material.dart';

class AppColors {
  static const brandDeep = Color(0xFF0C4C3C);
  static const brandPrimary = Color(0xFF1A6C56);
  static const brandWordmark = Color(0xFF105745);
  static const accent = Color(0xFF02B152);
  static const mint = Color(0xFFEEFFED);
  static const cream = Color(0xFFFCFBF7);
  static const surface = Color(0xFFFFFFFF);
  static const textPrimary = Color(0xFF121212);
  static const textSecondary = Color(0xFF5F6B66);
  static const placeholder = Color(0xFF9C9C9C);
  static const divider = Color(0xFFE4E4E4);
  static const income = Color(0xFF0B7A3B);
  static const expense = Color(0xFFC62828);
  static const review = Color(0xFFB26A00);
}
```
Build `ThemeData` from one `ColorScheme` (`primary: brandPrimary`, `onPrimary: white`, `secondary: accent`, `surface`, `error: expense`) so widgets read the theme, not these constants directly.

## Onboarding reference: what we use and what we do not
The onboarding image (a sample app called AgriPlant) is used for **colours and general look only**. Do not reuse its name, logo or illustrations.

Use: rounded inputs, one full-width green button, the mint splash, a success dialog with a check mark.

Do **not** build: login, sign-up, Google/Facebook sign-in, OTP verification, forgot/reset password, or a personal-details form (name, address, post code). PaisaPatri has no accounts and no backend (DEC-17), and it avoids collecting personal data. See DEC-23.

PaisaPatri's own onboarding is local setup only:
1. Splash (logo on mint).
2. Welcome and plain-language consent: what is read, what is stored, what is never stored (F-54).
3. Notification access: why it is needed, then the system settings screen.
4. Choose banks and wallets to watch.
5. Pay day / salary day (and a monthly budget, optional).
6. Optional app lock (a local PIN or fingerprint; there is no password account).
7. Done: success card, then Home.

## Logo notes
- File: `docs/brand/paisapatri-logo.png`, 1254 × 1254 PNG on a cream background. A "P" shaped like a message with a leaf: SMS in, money tracked.
- Before the Play Store or a polished demo, make a square app icon (1024 px) and an Android adaptive-icon foreground from the P symbol alone. The current file has the wordmark and a cream background, so it cannot be used as the launcher icon as it is.
- Ask for an SVG or high-resolution export of the logo when possible.
