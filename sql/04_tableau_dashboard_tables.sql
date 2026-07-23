/*
Bellabeat Smart Device Usage Analysis
File: 04_tableau_dashboard_tables.sql

Purpose:
Create a compact KPI table for the Tableau dashboard.
The table combines headline activity and sleep metrics
into a single visualization-ready structure.
*/
CREATE OR REPLACE TABLE
  `learning-sql-498907.bellabeat_analysis.analysis_dashboard_kpis` AS
SELECT
  'Activity' AS metric_category,
  'Average Daily Steps' AS metric_name,
  average_daily_steps AS metric_value,
  'steps' AS metric_unit,
  1 AS display_order
FROM
  `learning-sql-498907.bellabeat_analysis.analysis_overall_activity_summary`
UNION ALL
SELECT
  'Activity',
  'Median Daily Steps',
  CAST(median_daily_steps AS FLOAT64),
  'steps',
  2
FROM
  `learning-sql-498907.bellabeat_analysis.analysis_overall_activity_summary`
UNION ALL
SELECT
  'Activity',
  '10,000-Step Goal Achievement',
  step_goal_achievement_rate,
  'percent',
  3
FROM
  `learning-sql-498907.bellabeat_analysis.analysis_overall_activity_summary`
UNION ALL
SELECT
  'Sleep',
  'Average Sleep Duration',
  average_hours_asleep,
  'hours',
  4
FROM
  `learning-sql-498907.bellabeat_analysis.analysis_overall_sleep_summary`
UNION ALL
SELECT
  'Sleep',
  'Average Sleep Efficiency',
  average_sleep_efficiency,
  'percent',
  5FROM
  `learning-sql-498907.bellabeat_analysis.analysis_overall_sleep_summary`
UNION ALL
SELECT
  'Sleep',
  'Fragmented Sleep Rate',
  fragmented_sleep_rate,
  'percent',
  6
FROM
  `learning-sql-498907.bellabeat_analysis.analysis_overall_sleep_summary`;
