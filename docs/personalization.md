# ✉️ Dynamic Content & Personalization

Three emails, **one master template each**, assembled at send time from three tools: **dynamic variations** (conditional blocks), **merge fields** (scalar tokens), and **repeaters** (loops over lists).

| Email | Audience | Goal | Tone |
|:---|:---|:---|:---|
| `PHD-E1` | High-Intent | Personalised Badya shortlist, book a private visit | Direct, personal follow-up |
| `PHD-E2` | Owners | Owner-only allocation before public launch | Exclusive, early access |
| `PHD-E3` | Dormant / last chance | One question, one link, no brochure | Low pressure |

## Swap Rules
| Element | Data source | Rule |
|:---|:---|:---|
| **Language** | `Preferred_Language` | Arabic → Arabic variant (RTL), else English |
| **Imagery** | `Project_Interest` / `Project_Region` | Show the matching Badya hero image; default to flagship if blank |
| **Region copy** | `Project_Region` | Region-specific line (e.g. West Cairo) |
| **CTA** | Lifecycle stage + `Lead_Status` | Lead: "Book your private visit"; Owner: "Reserve your allocation" |
| **Greeting** | `FirstName` | Fallback to a neutral greeting if empty |
| **Footer** | `{!$organization.Address}` | Resolved at send for compliance |

## Merge Field Syntax
| Platform | Syntax |
|:---|:---|
| Marketing Cloud Next / Flow | `{!Recipient.FirstName}` |
| Classic SFMC (AMPscript) | `%%FirstName%%` |

## AMPscript Equivalent (Classic SFMC Principle)
```ampscript
%%[
VAR @firstName, @region, @cta, @greeting
SET @firstName = AttributeValue("FirstName")
SET @region    = AttributeValue("Project_Region")

IF EMPTY(@firstName) THEN
  SET @greeting = "Hello"
ELSE
  SET @greeting = ProperCase(@firstName)
ENDIF

IF AttributeValue("Lifecycle_Stage") == "Owner" THEN
  SET @cta = "Reserve your allocation"
ELSE
  SET @cta = "Book your private visit"
ENDIF
]%%
<h2>%%=v(@greeting)=%%, your %%=v(@region)=%% shortlist is ready</h2>
<a href="%%=RedirectTo(@bookingUrl)=%%">%%=v(@cta)=%%</a>
```

> [!NOTE]
> In Marketing Cloud Next the same logic is expressed with **Dynamic Content Variations** and **merge fields** bound to a Data Graph, not AMPscript. The AMPscript above documents the equivalent logic for classic SFMC.
