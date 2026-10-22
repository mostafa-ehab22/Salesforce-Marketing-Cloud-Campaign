# ✅ Consent & Suppression Model

## Core Rules
- **Explicit opt-in only.** Not Set / blank / null is treated as **no consent**.
- Consent is stored as **individual records** (status + timestamp), not a single boolean.
- Consent is **read live at dispatch**, never at segment build time.
- Consent attaches to a **Contact Point**; a new address needs a new consent record.

## Subscriptions & Channels
| Subscription | Email | SMS | WhatsApp | Type |
|:---|:---:|:---:|:---:|:---|
| Palm Hills Project Launches | ✅ | ✅ | ✅ | Promotional |
| Palm Hills Owner Services | ✅ | ✅ | ❌ | Transactional |
| Palm Hills Resale & Investment | ✅ | ❌ | ❌ | Promotional |
| Palm Hills Events & Community | ✅ | ❌ | ✅ | Promotional |

## Channel Policy
| Channel | Role | Condition |
|:---|:---|:---|
| Email | Primary for all segments | Active email consent for the subscription |
| SMS | Fallback | Explicit SMS consent recorded |
| WhatsApp | Community segment only | Owner active in community app + WhatsApp consent |

## Promotional vs Transactional
| | Promotional | Transactional |
|:---|:---|:---|
| Active consent required | Yes | No |
| Honours "Unsubscribe from all" | Yes | Service messages only |
| Example | Second-unit offer | Instalment due reminder |

## Preference Centre Logic
- Four toggles, each mapped to a subscription
- Every toggle **writes back to the live consent record in real time**
- Mid-journey opt-out is honoured at the **next node**
- No free-text fields, plain category names, one clearly labelled **Unsubscribe All**

## Cautions
- **Never delete** a Communication Subscription: it wipes child consent records and the audit trail.
- Use native consent actions in Flow rather than legacy messaging-consent actions.
