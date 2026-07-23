/*
Bellabeat Smart Device Usage Analysis
File: 01_data_validation.sql

Purpose:
Validate the imported Fitbit tables by checking row counts,
participant coverage, duplicate records, date formats, missing values,
invalid values, and data availability.
*/


-- ============================================================
-- 1. Confirm row counts for all imported raw tables
-- ============================================================

SELECT
  'daily_activity' AS table_name,
  COUNT(*) AS row_count
FROM
  `learning-sql-498907.bellabeat_analysis.daily_activity`

UNION ALL

SELECT
  'hourly_steps',
  COUNT(*)
FROM
  `learning-sql-498907.bellabeat_analysis.hourly_steps`

UNION ALL

SELECT
  'hourly_intensities',
  COUNT(*)
FROM
  `learning-sql-498907.bellabeat_analysis.hourly_intensities`

UNION ALL

SELECT
  'hourly_calories',
  COUNT(*)
FROM
  `learning-sql-498907.bellabeat_analysis.hourly_calories`

UNION ALL

SELECT
  'minute_sleep',
  COUNT(*)
FROM
  `learning-sql-498907.bellabeat_analysis.minute_sleep`

UNION ALL

SELECT
  'weight_log',
  COUNT(*)
FROM
  `learning-sql-498907.bellabeat_analysis.weight_log`;


-- ============================================================
-- 2. Inspect column names and data types
-- ============================================================

SELECT
  table_name,
  column_name,
  data_type
FROM
  `learning-sql-498907.bellabeat_analysis.INFORMATION_SCHEMA.COLUMNS`
ORDER BY
  table_name,
  ordinal_position;


-- ============================================================
-- 3. Validate text-based date and time fields
-- ============================================================

SELECT
  'hourly_steps' AS table_name,
  COUNT(*) AS total_rows,
  COUNTIF(
    SAFE.PARSE_DATETIME(
      '%m/%d/%Y %I:%M:%S %p',
      ActivityHour
    ) IS NULL
  ) AS failed_parses
FROM
  `learning-sql-498907.bellabeat_analysis.hourly_steps`

UNION ALL

SELECT
  'hourly_intensities',
  COUNT(*),
  COUNTIF(
    SAFE.PARSE_DATETIME(
      '%m/%d/%Y %I:%M:%S %p',
      ActivityHour
    ) IS NULL
  )
FROM
  `learning-sql-498907.bellabeat_analysis.hourly_intensities`

UNION ALL

SELECT
  'hourly_calories',
  COUNT(*),
  COUNTIF(
    SAFE.PARSE_DATETIME(
      '%m/%d/%Y %I:%M:%S %p',
      ActivityHour
    ) IS NULL
  )
FROM
  `learning-sql-498907.bellabeat_analysis.hourly_calories`

UNION ALL

SELECT
  'minute_sleep',
  COUNT(*),
  COUNTIF(
    SAFE.PARSE_DATETIME(
      '%m/%d/%Y %I:%M:%S %p',
      date
    ) IS NULL
  )
FROM
  `learning-sql-498907.bellabeat_analysis.minute_sleep`

UNION ALL

SELECT
  'weight_log',
  COUNT(*),
  COUNTIF(
    SAFE.PARSE_DATETIME(
      '%m/%d/%Y %I:%M:%S %p',
      Date
    ) IS NULL
  )
FROM
  `learning-sql-498907.bellabeat_analysis.weight_log`;


-- ============================================================
-- 4. Check participant coverage and duplicate record keys
-- ============================================================

SELECT
  'daily_activity' AS table_name,
  COUNT(*) AS total_rows,
  COUNT(DISTINCT Id) AS distinct_users,
  COUNT(*) - COUNT(
    DISTINCT CONCAT(
      CAST(Id AS STRING),
      '|',
      CAST(ActivityDate AS STRING)
    )
  ) AS duplicate_rows
FROM
  `learning-sql-498907.bellabeat_analysis.daily_activity`

UNION ALL

SELECT
  'hourly_steps',
  COUNT(*),
  COUNT(DISTINCT Id),
  COUNT(*) - COUNT(
    DISTINCT CONCAT(
      CAST(Id AS STRING),
      '|',
      ActivityHour
    )
  )
FROM
  `learning-sql-498907.bellabeat_analysis.hourly_steps`

UNION ALL

SELECT
  'hourly_intensities',
  COUNT(*),
  COUNT(DISTINCT Id),
  COUNT(*) - COUNT(
    DISTINCT CONCAT(
      CAST(Id AS STRING),
      '|',
      ActivityHour
    )
  )
FROM
  `learning-sql-498907.bellabeat_analysis.hourly_intensities`

UNION ALL

SELECT
  'hourly_calories',
  COUNT(*),
  COUNT(DISTINCT Id),
  COUNT(*) - COUNT(
    DISTINCT CONCAT(
      CAST(Id AS STRING),
      '|',
      ActivityHour
    )
  )
FROM
  `learning-sql-498907.bellabeat_analysis.hourly_calories`

UNION ALL

SELECT
  'minute_sleep',
  COUNT(*),
  COUNT(DISTINCT Id),
  COUNT(*) - COUNT(
    DISTINCT CONCAT(
      CAST(Id AS STRING),
      '|',
      date,
      '|',
      CAST(logId AS STRING)
    )
  )
FROM
  `learning-sql-498907.bellabeat_analysis.minute_sleep`

UNION ALL

SELECT
  'weight_log',
  COUNT(*),
  COUNT(DISTINCT Id),
  COUNT(*) - COUNT(
    DISTINCT CONCAT(
      CAST(Id AS STRING),
      '|',
      Date,
      '|',
      CAST(LogId AS STRING)
    )
  )
FROM
  `learning-sql-498907.bellabeat_analysis.weight_log`;


-- ============================================================
-- 5. Validate the daily activity table
-- ============================================================

SELECT
  COUNT(*) AS total_rows,
  COUNT(DISTINCT Id) AS distinct_users,
  MIN(ActivityDate) AS first_date,
  MAX(ActivityDate) AS last_date,

  COUNTIF(Id IS NULL) AS missing_ids,
  COUNTIF(ActivityDate IS NULL) AS missing_dates,
  COUNTIF(TotalSteps IS NULL) AS missing_steps,
  COUNTIF(Calories IS NULL) AS missing_calories,

  COUNTIF(TotalSteps < 0) AS negative_steps,
  COUNTIF(TotalDistance < 0) AS negative_distance,
  COUNTIF(Calories < 0) AS negative_calories,

  COUNTIF(
    VeryActiveMinutes
    + FairlyActiveMinutes
    + LightlyActiveMinutes
    + SedentaryMinutes > 1440
  ) AS days_over_24_hours,

  COUNTIF(TotalSteps = 0) AS zero_step_days,

  MIN(TotalSteps) AS minimum_steps,
  MAX(TotalSteps) AS maximum_steps,
  ROUND(AVG(TotalSteps), 2) AS average_steps,

  MIN(Calories) AS minimum_calories,
  MAX(Calories) AS maximum_calories,
  ROUND(AVG(Calories), 2) AS average_calories

FROM
  `learning-sql-498907.bellabeat_analysis.daily_activity`;


-- ============================================================
-- 6. Evaluate zero-step records
-- ============================================================

SELECT
  COUNTIF(TotalSteps = 0) AS zero_step_days,

  COUNTIF(
    TotalSteps = 0
    AND Calories = 0
  ) AS zero_steps_zero_calories,

  COUNTIF(
    TotalSteps = 0
    AND Calories > 0
  ) AS zero_steps_with_calories,

  COUNTIF(
    TotalSteps = 0
    AND SedentaryMinutes = 1440
  ) AS zero_steps_full_sedentary_day

FROM
  `learning-sql-498907.bellabeat_analysis.daily_activity`;


-- ============================================================
-- 7. Evaluate weight-data coverage
-- ============================================================

SELECT
  COUNT(*) AS total_records,
  COUNT(DISTINCT Id) AS distinct_users,

  MIN(
    DATE(
      SAFE.PARSE_DATETIME(
        '%m/%d/%Y %I:%M:%S %p',
        Date
      )
    )
  ) AS first_record_date,

  MAX(
    DATE(
      SAFE.PARSE_DATETIME(
        '%m/%d/%Y %I:%M:%S %p',
        Date
      )
    )
  ) AS last_record_date,

  COUNTIF(IsManualReport = TRUE) AS manually_entered_records,
  COUNTIF(WeightKg IS NULL) AS missing_weight_values,
  COUNTIF(BMI IS NULL) AS missing_bmi_values,
  COUNTIF(Fat IS NULL) AS missing_fat_values

FROM
  `learning-sql-498907.bellabeat_analysis.weight_log`;
