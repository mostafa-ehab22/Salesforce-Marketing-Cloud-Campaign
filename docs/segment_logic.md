# 🧱 Segment Logic

All segments are built **on `UnifiedIndividual`** (Data 360), refresh **daily at 09:00 Africa/Cairo**, and are **mutually exclusive** by construction (priority order: Owners → High-Intent → Dormant).

## 🎯 Segment 1: High-Intent Leads (37)
| Attribute | Rule |
|:---|:---|
| `Lifecycle_Stage` | = Lead |
| `Lead_Status` | in Qualified, Site Visit Booked, Site Visit Done, Negotiation |
| `Days_Since_Last_Activity` | ≤ 90 |
| `Budget_Band` | in 8M-15M, 15M-30M, 30M+ EGP |
| `Consent_Email` | = Opt In |
| `Subscribed_Topics` | contains Palm Hills Project Launches |
| Lookback | 90 days |

## 🏠 Segment 2: Owners Worth a Second Unit (24)
| Attribute | Rule |
|:---|:---|
| `Lifecycle_Stage` | = Owner (purchased in Badya) |
| `Instalment_Status` | strictly current |
| `App_Sessions_30d` | ≥ 3 |
| `Subscribed_Topics` | contains Palm Hills Resale & Investment |
| Lookback | 30 days |

## 💤 Segment 3: Dormant Enquiries (27)
| Attribute | Rule |
|:---|:---|
| `Lifecycle_Stage` | = Lead (uncontracted) |
| `Days_Since_Last_Activity` | between 91 and 365 |
| `Subscribed_Topics` | contains Palm Hills Project Launches |
| Lookback | 1 year |
| Exclusion | Nested exclude of Segment 1 |

## 📈 Engagement Score (Calculated Insight): Design Proposal

A reusable, multi-source metric computed in Data 360 and referenced by segments and decision splits.

```text
Engagement_Score =
    (Email_Clicks_30d      × 5)
  + (Email_Opens_30d       × 1)
  + (Portal_Enquiries_90d  × 4)
  + (Site_Visit_Booked     × 10)
  + (App_Sessions_30d      × 2)
  - (Days_Since_Last_Activity × 0.1)
```

| Band | Score | Use |
|:---|:---:|:---|
| 🔥 Hot | ≥ 15 | Priority routing to sales |
| 🌤️ Warm | 6-14 | Standard nurture |
| ❄️ Cold | ≤ 5 | Reactivation or suppress from sales tasks |

> [!NOTE]
> Weights are a **starting hypothesis** and should be calibrated against historical bookings. A high score means the contact is warm; it does not mean they will book.
