# Irma App: Naming Rosetta Stone

This document is the **Authoritative Mapping** between the Flutter Codebase and the Design Gospel (Figma/Components Guide). It ensures that every widget knows exactly which styling rules it must follow, despite the naming drift.

---

## 🛠️ Global Core Mappings

| Code Location (`irma_theme.dart`) | Gospel Terminology | Description |
| :--- | :--- | :--- |
| `IrmaTheme.menstrual` | `Menstrual` | Primary Cycle Color |
| `IrmaTheme.follicular` | `Follicular` | Secondary Cycle Color |
| `IrmaTheme.ovulation` | `Ovulation` | Tertiary Cycle Color |
| `IrmaTheme.luteal` | `Luteal` | Quaternary Cycle Color |
| `IrmaTheme.radiusCard` | `RadiusCard (32)` | Standard Card Corner Radius |
| `IrmaTheme.radiusAction` | `RadiusAction (24)` | Button Corner Radius |

---

## 🧩 Component Mappings (Dashboard & Shell)

| Flutter Widget | Code File | Gospel Category | Justification |
| :--- | :--- | :--- | :--- |
| `IrmaNavigationBar` | `irma_nav_bar.dart` | `Title Section` / `Chat Navbar` | Matches header height, logo alignment, and title styling. |
| `IrmaBottomNav` | `irma_bottom_nav.dart` | `Bottom Nav` | Direct match for the floating pill navigation. |
| `IrmaCycleRing` | `irma_cycle_ring.dart` | `Cycle` | Matches 240x240 dimensions and phase visualization segments. |
| `IrmaPrimaryButton` | `irma_buttons.dart` | `BTNS` | Gospel `Size=48, Type=Primary` variant. |
| `IrmaInsightCard` | `irma_cards.dart` | `Insight Card` | Direct name match; mandates 168x196 size correction. |
| `IrmaDashboardCard` | `irma_cards.dart` | `Symptoms Card` | When used in Dashboard for "Log Symptoms". |
| `OnboardingSlide` | `onboarding_screen.dart` | `Nodes` | Matches property nodes used in carousel layouts. |
| `IrmaTextField` | `irma_text_field.dart` | `Inputs` / `Password` | Standard text entries and password variants. |
| `IrmaChatInput` | `irma_chat_input.dart` | `Inputs` | Specifically the bottom-fixed chat bar. |
| `IrmaFAQChip` | `irma_faq_chip.dart` | `FAQ` | Chips used for quick-questions and suggestions. |
| `IrmaMessageBubble` | `irma_message_bubble.dart` | `Message` | Bot/User bubble variants. |
| `IrmaSymptomCard` | `irma_symptom_card.dart` | `Symptoms Card` | List items in the Daily Log / Symptoms screen. |
| `IrmaMonthCalendar` | `irma_month_calendar.dart` | `Calender` | Main grid calendar in Cycle screen. |
| `IrmaProfileTile` | `irma_cards.dart` | `Profile Items` | Used in Profile Hub, Support, and Security screens. |
| `IrmaProgramTile` | `irma_self_care_screen.dart`| `Selfcare Cards` | The horizontal/vertical program list items. |
| `IrmaStatusBox` | `irma_status_box.dart` | `Status Box` | Partner connection status indicators. |
| `IrmaExercisePlayer`| `irma_exercise_player.dart`| `Music Btns` | Controls for playback (Play, Pause, Skip). |
| `IrmaChip` | `irma_chip.dart` | `Chips` | Selectable goal/symptom chips. |

---

## 📅 Under Review (Visual Refinements)

*The following are currently being fine-tuned for pixel-perfection:*

| Flutter Widget | Code File | Potential Gospel Match |
| :--- | :--- | :--- |
| `IrmaLockScreen` | `irma_lock_screen.dart` | `OTP` / `Password` |
| `IrmaChatRichContent` | `irma_chat_rich_content.dart` | `Message` (Enhanced) |
| `Dot Indicators` | `onboarding_screen.dart` | `Stepper` |


