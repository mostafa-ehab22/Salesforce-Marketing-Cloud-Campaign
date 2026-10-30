-- ============================================================================
-- Engagement Score: Calculated Insight (reference design)
-- Badya Second Release | Marketing Cloud Next + Data Cloud
--
-- STATUS: Reference design, not deployed in the org. The weights are a starting
-- hypothesis and should be calibrated against historical bookings.
--
-- Calculated Insights in Data Cloud are defined in SQL. Dimensions and measures
-- carry the __c suffix. Field names below are illustrative and follow the
-- attribute names used in the segments (UnifiedIndividual PHD).
-- ============================================================================

SELECT
    ui.ssot__Id__c                                   AS individual_id__c,

    SUM(
          (COALESCE(ui.Email_Clicks_30d__c, 0)      * 5)    -- strongest intent signal
        + (COALESCE(ui.Email_Opens_30d__c, 0)       * 1)    -- weak signal, opens are noisy
        + (COALESCE(ui.Portal_Enquiries_90d__c, 0)  * 4)    -- direct enquiry
        + (CASE WHEN ui.Lead_Status__c = 'Site Visit Booked' THEN 10 ELSE 0 END)
        + (COALESCE(ui.App_Sessions_30d__c, 0)      * 2)    -- owners only in practice
        - (COALESCE(ui.Days_Since_Last_Activity__c, 0) * 0.1) -- recency decay
    )                                                AS engagement_score__c

FROM UnifiedssotIndividualPhd__dlm ui
GROUP BY ui.ssot__Id__c;

-- ----------------------------------------------------------------------------
-- Score bands (applied in segments or Flow decision splits, not in the insight)
--   Hot  : engagement_score__c >= 15   -> priority routing to sales
--   Warm : engagement_score__c 6 - 14  -> standard nurture
--   Cold : engagement_score__c <= 5    -> reactivation only
--
-- Caveat: a high score means the contact is warm. It does not mean they will book.
-- ----------------------------------------------------------------------------
