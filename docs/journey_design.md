# 🗺️ Journey Design

## Entry
- **Type:** Segment-triggered Flow on *High-Intent Leads*
- **Schedule:** daily, 09:00 Africa/Cairo (GMT+2), runs 14 days from first entry
- **First node:** `Stamp Entry Timestamp` (Assignment). Every wait is relative to this value.

## Node Reference
| # | Node | Type | Logic |
|:-:|:---|:---|:---|
| 1 | Stamp Entry Timestamp | Assignment | Store entry time for relative waits |
| 2 | Global Suppression Check | Decision | Exit if Owner, open complaint, ≥ 3 emails in 7 days, or missing/hard-bounced email |
| 3 | PHD-E1 | Send Email | Locale = `Preferred_Language` (Arabic / English default) |
| 4 | Wait 3 Days or Clicked Book | Wait Until Event | Event → sub-flow; Timeout → engagement check |
| 5 | Evaluate Open Engagement | Decision | Opened but no click / No open |
| 6a | PHD-E1 Variant B | Send Email | For openers who did not click, then wait 4 days |
| 6b | SMS Consent Check | Decision | Consented / Not consented |
| 7a | Send SMS with Short Link | Send SMS | Only where SMS consent is active, then wait 2 days |
| 7b | PHD-E1 Alternate Subject | Send Email | Wait 4 days first |
| 8 | Second Engagement Check | Decision | Clicked booking link / Remaining audience |
| 9 | Assign & Notify Sales | Sub-flow | Same sub-flow as the early click path |
| 10 | PHD-E3 Last Chance | Send Email | Remaining audience |
| 11 | Wait Until Campaign End | Wait Until Date | Anchors to the end of the 14-day window |
| 12 | Update Lead Status: Cold Nurture | Update Records | Closes the loop for non-responders |

## Sub-Flow: Assign & Notify Sales (Autolaunched)
1. **Get Lead Info** from Salesforce CRM
2. **Update Lead Status** → Site Visit Booked (and Campaign Member status)
3. **Create Sales Task** on the owning team
4. **Notify Sales Agent** (internal notification)
5. End

**Why a sub-flow:** called from two places, built once, maintained once, identical behaviour every time.

## Owner Service Flow (Data Cloud-Triggered)
- **Object:** `UnifiedIndividual`, trigger = *record is updated*
- **Entry condition:** `Instalment_Status` equals `Due Soon`, run only when the record is updated to meet the condition
- **Decision:** promotional (needs active consent) vs transactional (can proceed without it)

## Best Practices Applied
- Re-check consent and suppression **before every send**, not only at entry
- Use **live Contact data** (not entry snapshot) for post-wait decisions
- Explicit **exit conditions** so converted contacts drop out immediately
