/*
Bellabeat Smart Device Usage Analysis
File: 02_data_cleaning.sql

Purpose:
Clean and transform the raw Fitbit tables into analysis-ready datasets.

Key transformations:
- Remove exact duplicate sleep records
- Convert text timestamps into DATETIME values
- Add activity-data quality flags
- Combine hourly steps, intensity, and calorie tables
- Aggregate minute-level sleep data into sessions and daily summaries
- Join valid daily activity and sleep records
*/


-- ============================================================
-- 1. Clean minute-level sleep data
-- ============================================================

CREATE OR REPLACE TABLE
  `learning-sql-498907.bellabeat_analysis.minute_sleep_clean` AS

SELECT DISTINCT
  Id AS user_id,

  SAFE.PARSE_DATETIME(
    '%m/%d/%Y %I:%M:%S %p',
    date
  ) AS sleep_datetime,

  value AS sleep_value,
  logId AS log_id

FROM
  `learning-sql-498907.bellabeat_analysis.minute_sleep`;


-- ============================================================
-- 2. Clean and label daily activity records
-- ============================================================

CREATE OR REPLACE TABLE
  `learning-sql-498907.bellabeat_analysis.daily_activity_clean` AS

SELECT
  Id AS user_id,
  ActivityDate AS activity_date,

  FORMAT_DATE(
    '%A',
    ActivityDate
  ) AS day_of_week,

  CASE
    WHEN EXTRACT(DAYOFWEEK FROM ActivityDate) IN (1, 7)
      THEN 'Weekend'
    ELSE 'Weekday'
  END AS day_type,

  TotalSteps AS total_steps,
  TotalDistance AS total_distance,
  TrackerDistance AS tracker_distance,
  LoggedActivitiesDistance AS logged_activities_distance,
  VeryActiveDistance AS very_active_distance,
  ModeratelyActiveDistance AS moderately_active_distance,
  LightActiveDistance AS light_active_distance,
  SedentaryActiveDistance AS sedentary_active_distance,

  VeryActiveMinutes AS very_active_minutes,
  FairlyActiveMinutes AS fairly_active_minutes,
  LightlyActiveMinutes AS lightly_active_minutes,
  SedentaryMinutes AS sedentary_minutes,

  VeryActiveMinutes
    + FairlyActiveMinutes
    + LightlyActiveMinutes AS total_active_minutes,

  VeryActiveMinutes
    + FairlyActiveMinutes
    + LightlyActiveMinutes
    + SedentaryMinutes AS total_tracked_minutes,

  Calories AS calories,

  CASE
    WHEN Calories = 0
      THEN 'Incomplete record'

    WHEN TotalSteps = 0
      AND SedentaryMinutes = 1440
      THEN 'Probable non-wear day'

    WHEN TotalSteps = 0
      AND (
        VeryActiveMinutes
        + FairlyActiveMinutes
        + LightlyActiveMinutes
      ) > 0
      THEN 'Inconsistent zero-step record'

    WHEN TotalSteps = 0
      THEN 'Partial tracking day'

    ELSE 'Valid activity day'
  END AS record_quality,

  TotalSteps > 0 AS valid_for_step_analysis,

  CASE
    WHEN TotalSteps = 0
      THEN NULL
    WHEN TotalSteps >= 10000
      THEN TRUE
    ELSE FALSE
  END AS met_10000_step_goal

FROM
  `learning-sql-498907.bellabeat_analysis.daily_activity`;


-- ============================================================
-- 3. Combine and clean hourly activity tables
-- ============================================================

CREATE OR REPLACE TABLE
  `learning-sql-498907.bellabeat_analysis.hourly_activity_clean` AS

WITH steps AS (
  SELECT
    Id AS user_id,

    SAFE.PARSE_DATETIME(
      '%m/%d/%Y %I:%M:%S %p',
      ActivityHour
    ) AS activity_datetime,

    StepTotal AS total_steps

  FROM
    `learning-sql-498907.bellabeat_analysis.hourly_steps`
),

intensities AS (
  SELECT
    Id AS user_id,

    SAFE.PARSE_DATETIME(
      '%m/%d/%Y %I:%M:%S %p',
      ActivityHour
    ) AS activity_datetime,

    TotalIntensity AS total_intensity,
    AverageIntensity AS average_intensity

  FROM
    `learning-sql-498907.bellabeat_analysis.hourly_intensities`
),

calories AS (
  SELECT
    Id AS user_id,

    SAFE.PARSE_DATETIME(
      '%m/%d/%Y %I:%M:%S %p',
      ActivityHour
    ) AS activity_datetime,

    Calories AS calories

  FROM
    `learning-sql-498907.bellabeat_analysis.hourly_calories`
)

SELECT
  s.user_id,
  s.activity_datetime,
  DATE(s.activity_datetime) AS activity_date,

  EXTRACT(
    HOUR FROM s.activity_datetime
  ) AS hour_of_day,

  FORMAT_DATETIME(
    '%A',
    s.activity_datetime
  ) AS day_of_week,

  CASE
    WHEN EXTRACT(
      DAYOFWEEK FROM DATE(s.activity_datetime)
    ) IN (1, 7)
      THEN 'Weekend'
    ELSE 'Weekday'
  END AS day_type,

  CASE
    WHEN EXTRACT(HOUR FROM s.activity_datetime)
      BETWEEN 5 AND 11
      THEN 'Morning'

    WHEN EXTRACT(HOUR FROM s.activity_datetime)
      BETWEEN 12 AND 16
      THEN 'Afternoon'

    WHEN EXTRACT(HOUR FROM s.activity_datetime)
      BETWEEN 17 AND 20
      THEN 'Evening'

    ELSE 'Night'
  END AS time_of_day,

  s.total_steps,
  i.total_intensity,
  i.average_intensity,
  c.calories

FROM
  steps AS s

INNER JOIN
  intensities AS i
USING
  (user_id, activity_datetime)

INNER JOIN
  calories AS c
USING
  (user_id, activity_datetime);


-- ============================================================
-- 4. Aggregate sleep records into individual sleep sessions
-- ============================================================

CREATE OR REPLACE TABLE
  `learning-sql-498907.bellabeat_analysis.sleep_session_summary` AS

SELECT
  user_id,
  log_id,

  MIN(sleep_datetime) AS sleep_start,
  MAX(sleep_datetime) AS sleep_end,

  DATE(
    MIN(sleep_datetime)
  ) AS sleep_start_date,

  DATE(
    MAX(sleep_datetime)
  ) AS wake_date,

  COUNT(*) AS time_in_bed_minutes,

  COUNTIF(
    sleep_value = 1
  ) AS minutes_asleep,

  COUNTIF(
    sleep_value = 2
  ) AS restless_minutes,

  COUNTIF(
    sleep_value = 3
  ) AS awake_minutes,

  DATETIME_DIFF(
    MAX(sleep_datetime),
    MIN(sleep_datetime),
    MINUTE
  ) + 1 AS session_span_minutes,

  ROUND(
    SAFE_DIVIDE(
      COUNTIF(sleep_value = 1),
      COUNT(*)
    ) * 100,
    2
  ) AS sleep_efficiency_percent

FROM
  `learning-sql-498907.bellabeat_analysis.minute_sleep_clean`

GROUP BY
  user_id,
  log_id;


-- ============================================================
-- 5. Aggregate sleep sessions into daily sleep summaries
-- ============================================================

CREATE OR REPLACE TABLE
  `learning-sql-498907.bellabeat_analysis.daily_sleep_summary` AS

SELECT
  user_id,
  wake_date AS sleep_date,

  COUNT(*) AS total_sleep_sessions,

  COUNTIF(
    minutes_asleep >= 180
  ) AS main_sleep_sessions,

  COUNTIF(
    minutes_asleep < 180
  ) AS short_sleep_sessions,

  SUM(
    minutes_asleep
  ) AS total_minutes_asleep,

  ROUND(
    SUM(minutes_asleep) / 60.0,
    2
  ) AS total_hours_asleep,

  SUM(
    time_in_bed_minutes
  ) AS total_time_in_bed_minutes,

  SUM(
    restless_minutes
  ) AS total_restless_minutes,

  SUM(
    awake_minutes
  ) AS total_awake_minutes,

  ROUND(
    SAFE_DIVIDE(
      SUM(minutes_asleep),
      SUM(time_in_bed_minutes)
    ) * 100,
    2
  ) AS sleep_efficiency_percent,

  MIN(sleep_start) AS first_sleep_start,
  MAX(sleep_end) AS final_wake_time,

  COUNTIF(
    time_in_bed_minutes != session_span_minutes
  ) AS sessions_with_time_gaps

FROM
  `learning-sql-498907.bellabeat_analysis.sleep_session_summary`

GROUP BY
  user_id,
  sleep_date;


-- ============================================================
-- 6. Add sleep-quality and analysis flags
-- ============================================================

CREATE OR REPLACE TABLE
  `learning-sql-498907.bellabeat_analysis.daily_sleep_clean` AS

SELECT
  *,

  FORMAT_DATE(
    '%A',
    sleep_date
  ) AS day_of_week,

  CASE
    WHEN EXTRACT(DAYOFWEEK FROM sleep_date) IN (1, 7)
      THEN 'Weekend'
    ELSE 'Weekday'
  END AS day_type,

  CASE
    WHEN total_minutes_asleep < 180
      THEN 'Short sleep only'

    WHEN total_minutes_asleep > 720
      THEN 'Unusually long sleep'

    ELSE 'Typical sleep duration'
  END AS sleep_duration_category,

  CASE
    WHEN total_sleep_sessions = 1
      THEN 'Single sleep session'
    ELSE 'Fragmented sleep'
  END AS sleep_pattern,

  total_minutes_asleep BETWEEN 180 AND 720
    AS valid_for_nightly_sleep_analysis

FROM
  `learning-sql-498907.bellabeat_analysis.daily_sleep_summary`;


-- ============================================================
-- 7. Join daily activity and sleep data
-- ============================================================

CREATE OR REPLACE TABLE
  `learning-sql-498907.bellabeat_analysis.daily_activity_sleep_clean` AS

SELECT
  a.user_id,
  a.activity_date,
  a.day_of_week,
  a.day_type,

  a.total_steps,
  a.total_distance,
  a.very_active_minutes,
  a.fairly_active_minutes,
  a.lightly_active_minutes,
  a.sedentary_minutes,
  a.total_active_minutes,
  a.total_tracked_minutes,
  a.calories,
  a.met_10000_step_goal,

  a.record_quality AS activity_record_quality,
  a.valid_for_step_analysis,

  s.total_sleep_sessions,
  s.total_minutes_asleep,
  s.total_hours_asleep,
  s.total_time_in_bed_minutes,
  s.total_restless_minutes,
  s.total_awake_minutes,
  s.sleep_efficiency_percent,
  s.first_sleep_start,
  s.final_wake_time,
  s.sleep_duration_category,
  s.sleep_pattern,
  s.valid_for_nightly_sleep_analysis,

  a.valid_for_step_analysis
    AND s.valid_for_nightly_sleep_analysis
    AS valid_for_combined_analysis

FROM
  `learning-sql-498907.bellabeat_analysis.daily_activity_clean` AS a

INNER JOIN
  `learning-sql-498907.bellabeat_analysis.daily_sleep_clean` AS s

ON
  a.user_id = s.user_id
  AND a.activity_date = s.sleep_date;
