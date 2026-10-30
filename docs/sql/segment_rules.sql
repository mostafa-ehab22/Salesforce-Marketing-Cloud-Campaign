-- ============================================================================
-- Segment rules written as SQL (reference design)
-- Badya Second Release | Marketing Cloud Next + Data Cloud
--
-- STATUS: Reference. The segments were built in the Segment canvas (visual
-- builder) on UnifiedIndividual PHD. This file documents the same rules as SQL
-- so they can be read, reviewed, and tested. Field names are illustrative.
-- ============================================================================


-- ----------------------------------------------------------------------------
-- 1. High-Intent Leads  (built size: 37)
-- ----------------------------------------------------------------------------
SELECT ui.ssot__Id__c
FROM UnifiedssotIndividualPhd__dlm ui
WHERE ui.Lifecycle_Stage__c = 'Lead'
  AND ui.Lead_Status__c IN ('Qualified', 'Site Visit Booked', 'Site Visit Done', 'Negotiation')
  AND ui.Days_Since_Last_Activity__c <= 90
  AND ui.Budget_Band__c IN ('8M - 15M EGP', '15M - 30M EGP', '30M+ EGP')
  AND ui.Consent_Email__c = 'Opt In'
  AND ui.Subscribed_Topics__c LIKE '%Palm Hills Project Launches%';


-- ----------------------------------------------------------------------------
-- 2. Owners Worth a Second Unit  (built size: 24)
-- ----------------------------------------------------------------------------
SELECT ui.ssot__Id__c
FROM UnifiedssotIndividualPhd__dlm ui
WHERE ui.Lifecycle_Stage__c = 'Owner'
  AND ui.App_Sessions_30d__c >= 3
  AND ui.Instalment_Status__c = 'Current'
  AND ui.Consent_Email__c = 'Opt In'
  AND ui.Subscribed_Topics__c LIKE '%Palm Hills Resale & Investment%';


-- ----------------------------------------------------------------------------
-- 3. Dormant Enquiries  (built size: 27)
-- ----------------------------------------------------------------------------
SELECT ui.ssot__Id__c
FROM UnifiedssotIndividualPhd__dlm ui
WHERE ui.Lifecycle_Stage__c = 'Lead'
  AND ui.Days_Since_Last_Activity__c BETWEEN 91 AND 365
  AND ui.Consent_Email__c = 'Opt In'
  AND ui.Subscribed_Topics__c LIKE '%Palm Hills Project Launches%';


-- ----------------------------------------------------------------------------
-- Mutual exclusivity check: must return zero rows
-- The segments cannot overlap by construction:
--   * Owners need Lifecycle_Stage = Owner, the other two need Lead
--   * High-Intent needs recency <= 90 days, Dormant needs 91 to 365 days
-- This query proves it by counting how many segments each person falls into.
-- ----------------------------------------------------------------------------
SELECT individual_id, COUNT(*) AS segments_matched
FROM (
    SELECT ui.ssot__Id__c AS individual_id
    FROM UnifiedssotIndividualPhd__dlm ui
    WHERE ui.Lifecycle_Stage__c = 'Lead'
      AND ui.Lead_Status__c IN ('Qualified', 'Site Visit Booked', 'Site Visit Done', 'Negotiation')
      AND ui.Days_Since_Last_Activity__c <= 90
      AND ui.Budget_Band__c IN ('8M - 15M EGP', '15M - 30M EGP', '30M+ EGP')
      AND ui.Consent_Email__c = 'Opt In'
      AND ui.Subscribed_Topics__c LIKE '%Palm Hills Project Launches%'

    UNION ALL

    SELECT ui.ssot__Id__c
    FROM UnifiedssotIndividualPhd__dlm ui
    WHERE ui.Lifecycle_Stage__c = 'Owner'
      AND ui.App_Sessions_30d__c >= 3
      AND ui.Instalment_Status__c = 'Current'
      AND ui.Consent_Email__c = 'Opt In'
      AND ui.Subscribed_Topics__c LIKE '%Palm Hills Resale & Investment%'

    UNION ALL

    SELECT ui.ssot__Id__c
    FROM UnifiedssotIndividualPhd__dlm ui
    WHERE ui.Lifecycle_Stage__c = 'Lead'
      AND ui.Days_Since_Last_Activity__c BETWEEN 91 AND 365
      AND ui.Consent_Email__c = 'Opt In'
      AND ui.Subscribed_Topics__c LIKE '%Palm Hills Project Launches%'
) all_segments
GROUP BY individual_id
HAVING COUNT(*) > 1;
