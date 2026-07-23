/*
Bellabeat Smart Device Usage Analysis
File: 03_analysis_queries.sql

Purpose:
Analyze activity, sleep, participation, and tracking-quality trends.
The resulting tables are structured for Tableau visualization.
*/


-- ============================================================
-- 1. Activity by weekday
-- ============================================================

CREATE OR REPLACE TABLE
  `learning-sql-498907.bellabeat_analysis.analysis_activity_by_weekday` AS

SELECT
  EXTRACT(DAYOFWEEK FROM activity_date) AS day_number,
  day_of_week,
  day_type,

  COUNT(*) AS user_days,
  COUNT(DISTINCT user_id) AS distinct_users,

  ROUND(AVG(total_steps), 2) AS average_steps,
  ROUND(AVG(total_active_minutes), 2) AS average_active_minutes,
  ROUND(AVG(very_active_minutes), 2) AS average_very_active_minutes,
  ROUND(AVG(fairly_active_minutes), 2) AS average_fairly_active_minutes,
  ROUND(AVG(lightly_active_minutes), 2) AS average_lightly_active_minutes,
  ROUND(AVG(sedentary_minutes), 2) AS average_sedentary_minutes,
  ROUND(AVG(calories), 2) AS average_calories,

  ROUND(
    SAFE_DIVIDE(
      COUNTIF(met_10000_step_goal = TRUE),
      COUNT(*)
    ) * 100,
    2
  ) AS step_goal_achievement_rate

FROM
  `learning-sql-498907.bellabeat_analysis.daily_activity_clean`

WHERE
  valid_for_step_analysis = TRUE

GROUP BY
  day_number,
  day_of_week,
  day_type;


-- ============================================================
-- 2. Activity by hour
-- ============================================================

CREATE OR REPLACE TABLE
  `learning-sql-498907.bellabeat_analysis.analysis_activity_by_hour` AS

SELECT
  hour_of_day,
  time_of_day,

  COUNT(*) AS user_hours,
  COUNT(DISTINCT user_id) AS distinct_users,

  ROUND(AVG(total_steps), 2) AS average_steps,
  ROUND(AVG(total_intensity), 2) AS average_total_intensity,
  ROUND(AVG(average_intensity), 4) AS average_intensity,
  ROUND(AVG(calories), 2) AS average_calories,

  SUM(total_steps) AS total_steps

FROM
  `learning-sql-498907.bellabeat_analysis.hourly_activity_clean`

GROUP BY
  hour_of_day,
  time_of_day;


-- ============================================================
-- 3. Activity by broad time period
-- ============================================================

CREATE OR REPLACE TABLE
  `learning-sql-498907.bellabeat_analysis.analysis_activity_by_time_of_day` AS

SELECT
  time_of_day,

  CASE
    WHEN time_of_day = 'Morning' THEN 1
    WHEN time_of_day = 'Afternoon' THEN 2
    WHEN time_of_day = 'Evening' THEN 3
    WHEN time_of_day = 'Night' THEN 4
  END AS time_period_order,

  COUNT(*) AS user_hours,
  COUNT(DISTINCT user_id) AS distinct_users,

  ROUND(AVG(total_steps), 2) AS average_steps_per_hour,
  ROUND(AVG(total_intensity), 2) AS average_total_intensity,
  ROUND(AVG(calories), 2) AS average_calories_per_hour,

  SUM(total_steps) AS total_steps

FROM
  `learning-sql-498907.bellabeat_analysis.hourly_activity_clean`

GROUP BY
  time_of_day;


-- ============================================================
-- 4. Sleep by weekday
-- ============================================================

CREATE OR REPLACE TABLE
  `learning-sql-498907.bellabeat_analysis.analysis_sleep_by_weekday` AS

SELECT
  EXTRACT(DAYOFWEEK FROM sleep_date) AS day_number,
  day_of_week,
  day_type,

  COUNT(*) AS user_nights,
  COUNT(DISTINCT user_id) AS distinct_users,

  ROUND(AVG(total_hours_asleep), 2) AS average_hours_asleep,

  ROUND(
    AVG(total_time_in_bed_minutes) / 60.0,
    2
  ) AS average_hours_in_bed,

  ROUND(
    AVG(sleep_efficiency_percent),
    2
  ) AS average_sleep_efficiency,

  ROUND(
    AVG(total_restless_minutes),
    2
  ) AS average_restless_minutes,

  ROUND(
    AVG(total_awake_minutes),
    2
  ) AS average_awake_minutes,

  ROUND(
    SAFE_DIVIDE(
      COUNTIF(sleep_pattern = 'Fragmented sleep'),
      COUNT(*)
    ) * 100,
    2
  ) AS fragmented_sleep_rate

FROM
  `learning-sql-498907.bellabeat_analysis.daily_sleep_clean`

WHERE
  valid_for_nightly_sleep_analysis = TRUE

GROUP BY
  day_number,
  day_of_week,
  day_type;


-- ============================================================
-- 5. Activity-and-sleep relationship dataset
-- ============================================================

CREATE OR REPLACE TABLE
  `learning-sql-498907.bellabeat_analysis.analysis_sleep_activity_relationship` AS

SELECT
  user_id,
  activity_date,
  day_of_week,
  day_type,

  total_steps,
  total_active_minutes,
  sedentary_minutes,
  calories,

  total_hours_asleep,
  sleep_efficiency_percent,
  sleep_pattern,
  met_10000_step_goal

FROM
  `learning-sql-498907.bellabeat_analysis.daily_activity_sleep_clean`

WHERE
  valid_for_combined_analysis = TRUE;


-- ============================================================
-- 6. Correlation checks
-- ============================================================

SELECT
  COUNT(*) AS valid_user_days,

  ROUND(
    CORR(total_hours_asleep, total_steps),
    3
  ) AS sleep_steps_correlation,

  ROUND(
    CORR(total_hours_asleep, total_active_minutes),
    3
  ) AS sleep_active_minutes_correlation,

  ROUND(
    CORR(total_hours_asleep, sedentary_minutes),
    3
  ) AS sleep_sedentary_correlation,

  ROUND(
    CORR(total_hours_asleep, calories),
    3
  ) AS sleep_calories_correlation,

  ROUND(
    CORR(sleep_efficiency_percent, total_steps),
    3
  ) AS efficiency_steps_correlation

FROM
  `learning-sql-498907.bellabeat_analysis.analysis_sleep_activity_relationship`;


-- ============================================================
-- 7. User participation and engagement
-- ============================================================

CREATE OR REPLACE TABLE
  `learning-sql-498907.bellabeat_analysis.analysis_user_engagement` AS

WITH user_summary AS (
  SELECT
    user_id,

    MIN(activity_date) AS first_activity_date,
    MAX(activity_date) AS last_activity_date,

    DATE_DIFF(
      MAX(activity_date),
      MIN(activity_date),
      DAY
    ) + 1 AS observed_span_days,

    COUNT(DISTINCT activity_date) AS total_logged_days,

    COUNT(
      DISTINCT IF(
        valid_for_step_analysis,
        activity_date,
        NULL
      )
    ) AS valid_activity_days,

    ROUND(
      AVG(
        IF(
          valid_for_step_analysis,
          total_steps,
          NULL
        )
      ),
      2
    ) AS average_daily_steps,

    ROUND(
      AVG(
        IF(
          valid_for_step_analysis,
          total_active_minutes,
          NULL
        )
      ),
      2
    ) AS average_active_minutes,

    ROUND(
      SAFE_DIVIDE(
        COUNTIF(
          valid_for_step_analysis
          AND met_10000_step_goal = TRUE
        ),
        COUNTIF(valid_for_step_analysis)
      ) * 100,
      2
    ) AS step_goal_achievement_rate

  FROM
    `learning-sql-498907.bellabeat_analysis.daily_activity_clean`

  GROUP BY
    user_id
)

SELECT
  *,

  ROUND(
    SAFE_DIVIDE(
      total_logged_days,
      observed_span_days
    ) * 100,
    2
  ) AS within_span_tracking_percent,

  ROUND(
    SAFE_DIVIDE(
      valid_activity_days,
      total_logged_days
    ) * 100,
    2
  ) AS valid_activity_day_percent,

  CASE
    WHEN observed_span_days >= 28
      THEN 'Long participation window'

    WHEN observed_span_days >= 14
      THEN 'Medium participation window'

    ELSE 'Short participation window'
  END AS participation_window,

  CASE
    WHEN SAFE_DIVIDE(
      total_logged_days,
      observed_span_days
    ) >= 0.90
      THEN 'High tracking consistency'

    WHEN SAFE_DIVIDE(
      total_logged_days,
      observed_span_days
    ) >= 0.75
      THEN 'Moderate tracking consistency'

    ELSE 'Low tracking consistency'
  END AS tracking_consistency

FROM
  user_summary;


-- ============================================================
-- 8. User tracking-quality segmentation
-- ============================================================

CREATE OR REPLACE TABLE
  `learning-sql-498907.bellabeat_analysis.analysis_user_tracking_quality` AS

SELECT
  user_id,
  first_activity_date,
  last_activity_date,
  observed_span_days,
  total_logged_days,
  valid_activity_days,
  within_span_tracking_percent,
  valid_activity_day_percent,
  average_daily_steps,
  average_active_minutes,
  step_goal_achievement_rate,
  participation_window,

  CASE
    WHEN valid_activity_day_percent >= 90
      THEN 'High valid-day coverage'

    WHEN valid_activity_day_percent >= 75
      THEN 'Moderate valid-day coverage'

    ELSE 'Low valid-day coverage'
  END AS valid_day_coverage

FROM
  `learning-sql-498907.bellabeat_analysis.analysis_user_engagement`;


-- ============================================================
-- 9. Overall activity KPIs
-- ============================================================

CREATE OR REPLACE TABLE
  `learning-sql-498907.bellabeat_analysis.analysis_overall_activity_summary` AS

SELECT
  COUNT(*) AS valid_user_days,
  COUNT(DISTINCT user_id) AS distinct_users,

  ROUND(
    AVG(total_steps),
    2
  ) AS average_daily_steps,

  APPROX_QUANTILES(
    total_steps,
    2
  )[OFFSET(1)] AS median_daily_steps,

  ROUND(
    AVG(total_active_minutes),
    2
  ) AS average_active_minutes,

  ROUND(
    AVG(sedentary_minutes),
    2
  ) AS average_sedentary_minutes,

  ROUND(
    AVG(calories),
    2
  ) AS average_daily_calories,

  ROUND(
    SAFE_DIVIDE(
      COUNTIF(met_10000_step_goal = TRUE),
      COUNT(*)
    ) * 100,
    2
  ) AS step_goal_achievement_rate

FROM
  `learning-sql-498907.bellabeat_analysis.daily_activity_clean`

WHERE
  valid_for_step_analysis = TRUE;


-- ============================================================
-- 10. Overall sleep KPIs
-- ============================================================

CREATE OR REPLACE TABLE
  `learning-sql-498907.bellabeat_analysis.analysis_overall_sleep_summary` AS

SELECT
  COUNT(*) AS valid_sleep_nights,
  COUNT(DISTINCT user_id) AS distinct_users,

  ROUND(
    AVG(total_hours_asleep),
    2
  ) AS average_hours_asleep,

  ROUND(
    APPROX_QUANTILES(
      total_minutes_asleep,
      2
    )[OFFSET(1)] / 60.0,
    2
  ) AS median_hours_asleep,

  ROUND(
    AVG(total_time_in_bed_minutes) / 60.0,
    2
  ) AS average_hours_in_bed,

  ROUND(
    AVG(sleep_efficiency_percent),
    2
  ) AS average_sleep_efficiency,

  ROUND(
    AVG(total_restless_minutes),
    2
  ) AS average_restless_minutes,

  ROUND(
    AVG(total_awake_minutes),
    2
  ) AS average_awake_minutes,

  ROUND(
    SAFE_DIVIDE(
      COUNTIF(sleep_pattern = 'Fragmented sleep'),
      COUNT(*)
    ) * 100,
    2
  ) AS fragmented_sleep_rate

FROM
  `learning-sql-498907.bellabeat_analysis.daily_sleep_clean`

WHERE
  valid_for_nightly_sleep_analysis = TRUE;
