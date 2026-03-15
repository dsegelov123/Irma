# Irma App: Styling Comparison Guide

This document is the **Zero-Trust Source of Truth** for ensuring the Irma application implementation matches the Figma prototype with 100% fidelity.

---

## 🎯 Audit Objective
To systematically verify every UI element, component, and widget in the application against its corresponding design in Figma.

## 🛠️ Comparison Protocol
For every page and element, we will cross-reference:
1.  **Figma Spec**: Literal properties (Hex, Font, Size, Padding) from the prototype.
2.  **Implementation**: The current state of the code and visually rendered app.
3.  **Remediation**: Required changes to achieve pixel-perfection.

---

## 📋 Audit Progress - Comprehensive Component List

### 1. Global Design Tokens (`irma_theme.dart`)

| figma | components guide | variation | app | variation |
| :--- | :--- | :--- | :--- | :--- |
| [PENDING] | **Palette**: Menstrual/Follicular/Ovulation/Luteal<br>**Radius**: 16/20/24/32/40 px<br>**Typography**: Outfit (Titles), Inter (Body) | N/A | [PENDING] | N/A |

---

### 2. Standalone Widgets (`lib/v3/widgets/`)

#### 💠 IrmaPrimaryButton
| figma | components guide | variation | app | variation |
| :--- | :--- | :--- | :--- | :--- |
| [PENDING] | **Size=48, Type=Primary, Shape=Button, State=Default**<br>- Sz: 143px x 48px<br>- Rad: 24px<br>- Gap: 4px<br>- Pad: [12, 24, 12, 24]<br>---<br>**Size=48, Type=Primary, Shape=Icon**<br>- Sz: 48px x 48px<br>- Rad: 200px (Circle) | BTNS | [PENDING] | [PENDING] |

#### 💠 IrmaTextField
| figma | components guide | variation | app | variation |
| :--- | :--- | :--- | :--- | :--- |
| [PENDING] | **Size=56 (Default)**<br>- Sz: 345px x 112px<br>- Gap: 8px<br>---<br>**Size=48 (Compact)**<br>- Sz: 345px x 104px<br>- Gap: 8px | Inputs | [PENDING] | [PENDING] |

#### 💠 IrmaChatInput
| figma | components guide | variation | app | variation |
| :--- | :--- | :--- | :--- | :--- |
| [PENDING] | **Standard Chat Input**<br>- Sz: 345px x 112px<br>- Gap: 8px<br>- Pad: [16, 16, 16, 16] | Inputs | [PENDING] | [PENDING] |

#### 💠 IrmaFaqChip
| figma | components guide | variation | app | variation |
| :--- | :--- | :--- | :--- | :--- |
| [PENDING] | **Default FAQ Chip**<br>- Sz: 345px x 52px<br>- Gap: 8px<br>- Pad: [0, 16, 0, 16] | FAQ | [PENDING] | [PENDING] |

#### 💠 IrmaBottomNav
| figma | components guide | variation | app | variation |
| :--- | :--- | :--- | :--- | :--- |
| [PENDING] | **Smart AI / Cycle / Insight Variants**<br>- Sz: 248px x 64px<br>- Rad: 40px (Pill)<br>- Gap: 8-14px | Bottom Nav | [PENDING] | [PENDING] |

#### 💠 IrmaNavigationBar
| figma | components guide | variation | app | variation |
| :--- | :--- | :--- | :--- | :--- |
| [PENDING] | **Title Section**<br>- Sz: 345px x 40px (Inner)<br>- Gap: 124px<br>---<br>**Chat Navbar**<br>- Sz: 393px x 80px<br>- Pad: [24, 24, 16, 24] | Title Section | [PENDING] | [PENDING] |

#### 💠 IrmaStatusBox
| figma | components guide | variation | app | variation |
| :--- | :--- | :--- | :--- | :--- |
| [PENDING] | **Pending / Connect States**<br>- Sz: 345px x 74px<br>- Rad: 16px<br>- Pad: [16, 24, 16, 24] | Status Box | [PENDING] | [PENDING] |

#### 💠 IrmaCycleRing
| figma | components guide | variation | app | variation |
| :--- | :--- | :--- | :--- | :--- |
| [PENDING] | **Ovulation / Period / PMS**<br>- Sz: 240px x 240px<br>- Rad: 360px (Circle) | Cycle | [PENDING] | [PENDING] |

#### 💠 IrmaMonthCalendar
| figma | components guide | variation | app | variation |
| :--- | :--- | :--- | :--- | :--- |
| [PENDING] | **Edit Period / Default / Selected**<br>- Sz: 313px x 290px (Grid)<br>- Gap: 16px | Calender | [PENDING] | [PENDING] |

#### 💠 IrmaMessageBubble
| figma | components guide | variation | app | variation |
| :--- | :--- | :--- | :--- | :--- |
| [PENDING] | **Bot (Typed)**<br>- Sz: 293px x 76px<br>- Rad: 16px<br>- Pad: [8, 16, 8, 16]<br>---<br>**User**<br>- Sz: 113px x 36px | Message | [PENDING] | [PENDING] |

#### 💠 IrmaSymptomCard
| figma | components guide | variation | app | variation |
| :--- | :--- | :--- | :--- | :--- |
| [PENDING] | **Weight / Water / Note (List)**<br>- Sz: 345px x 124px<br>- Rad: 20px<br>- Gap: 32px | Symptoms Card | [PENDING] | [PENDING] |

#### 💠 IrmaInsightCard
| figma | components guide | variation | app | variation |
| :--- | :--- | :--- | :--- | :--- |
| [PENDING] | **Diet / Sleep / Move / Tea**<br>- Sz: 168px x 196px<br>- Variant: Front/Back | Insight Card | [PENDING] | [PENDING] |

#### 💠 IrmaDashboardCard
| figma | components guide | variation | app | variation |
| :--- | :--- | :--- | :--- | :--- |
| [PENDING] | **Log Symptoms Card**<br>- Sz: 345px x 124px<br>- Rad: 20px<br>- Gap: 32px | Symptoms Card | [PENDING] | [PENDING] |

#### 💠 IrmaProfileTile
| figma | components guide | variation | app | variation |
| :--- | :--- | :--- | :--- | :--- |
| [PENDING] | **Toggle / Default (Sz 36, 44, 52)**<br>- Sz: 345px x [H]<br>- Gap: 154px<br>- Pad: [4-12, 12, 4-12, 12] | Profile Items | [PENDING] | [PENDING] |

#### 💠 IrmaProgramTile
| figma | components guide | variation | app | variation |
| :--- | :--- | :--- | :--- | :--- |
| [PENDING] | **Pink / Purple Variants**<br>- Sz: 264px x 164px (Large)<br>- Rad: 18px | Selfcare Cards | [PENDING] | [PENDING] |

#### 💠 IrmaExercisePlayer
| figma | components guide | variation | app | variation |
| :--- | :--- | :--- | :--- | :--- |
| [PENDING] | **Controls (Play/Pause/Skip)**<br>- Sz: 48px/60px (Btns)<br>- Rad: 200px (Circle) | Music Btns | [PENDING] | [PENDING] |

---

## ✅ Audit Log & Notes
*   **2026-03-15**: Restoration of formal artifact. Gospel mapping synced via Rosetta Stone.
*   **Gap Note**: `IrmaInsightCard` size in code (143x145) is a priority fix vs Gospel (168x196).
