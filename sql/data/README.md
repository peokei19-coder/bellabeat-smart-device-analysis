# Data Source

## Fitbit Fitness Tracker Data
This project uses the **Fitbit Fitness Tracker Data** dataset made available by Mobius on Kaggle under a CC0 Public Domain license. The dataset contains personal fitness tracker data from approximately 30 Fitbit users who consented to the collection of their activity data. Available files include information about:
- Daily activity
- Daily steps
- Calories burned
- Activity intensity
- Sedentary behavior
- Sleep
- Heart rate
- Weight records
- Hourly and minute-level activity

## Files Selected for Analysis
The initial analysis will focus on:
- `dailyActivity_merged.csv`
- `sleepDay_merged.csv`
- `hourlySteps_merged.csv`
Additional files may be included if they provide relevant insights into smart-device usage.

## Data Organization
The dataset is provided as multiple CSV files. Each file represents a different type or level of fitness-tracker information, including daily, hourly, and minute-level observations.
Most tables use the participant's `Id` as an identifier. Date or time fields will be used with `Id` when combining related tables.

## Data Credibility and Limitations
The dataset is useful for exploring activity and sleep patterns, but it has several limitations:
- The sample contains only approximately 30 users.
- The data covers a limited period.
- Demographic information is not provided.
- The participants are Fitbit users rather than Bellabeat customers.
- Participation may differ across the individual data files.
- The sample may not represent Bellabeat’s broader target market.
- The analysis can identify patterns and relationships, but it cannot establish causation.
Because of these limitations, the findings will be presented as directional insights rather than conclusions that represent all smart-device users.

## Data Storage
The original CSV files will be stored separately from cleaned and processed data. BigQuery will be used to import, clean, transform, and analyze the selected files.
