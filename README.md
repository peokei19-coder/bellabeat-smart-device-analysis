# Bellabeat Smart Device Usage Analysis
## Project Overview
Bellabeat is a wellness technology company that develops health-focused smart products for women. The company wants to better understand how consumers use smart fitness devices and apply those insights to its own products and marketing strategy. In this project, I analyze Fitbit fitness tracker data to identify patterns in users’ daily activity, sedentary behavior, calorie expenditure, and sleep habits. The findings will be used to develop data-driven marketing recommendations for the Bellabeat app.

## Business Problem
Bellabeat has the opportunity to expand its presence in the global smart-device market. However, the company needs a clearer understanding of how consumers currently use fitness-tracking devices and which wellness behaviors could be supported through the Bellabeat app. The objective of this analysis is to identify meaningful trends in smart-device usage and determine how Bellabeat can use those insights to improve customer engagement and guide its marketing strategy.

## Business Questions
1. What trends can be identified in users’ activity and sleep habits?
2. How could these trends apply to Bellabeat app users?
3. How could these insights influence Bellabeat’s marketing strategy?

## Key Stakeholders
- Urška Sršen, Bellabeat cofounder and Chief Creative Officer
- Sando Mur, Bellabeat cofounder and executive team member
- Bellabeat marketing analytics team
- Bellabeat marketing and executive leadership teams

## Tools Used

- Google BigQuery: Data storage, validation, cleaning, transformation, and SQL analysis
- Tableau Public: Interactive dashboard development and data visualization
- GitHub: Project documentation and SQL portfolio presentation

## Interactive Dashboard

The interactive Tableau dashboard presents the key activity and sleep trends identified in the analysis.
[View the Bellabeat Wellness Dashboard](https://public.tableau.com/app/profile/peace.okei/viz/BellabeatSmartDeviceUsageAnalysis_17853771619350/BellabeatWellnessDashboard?publish=yes)

### Dashboard Preview

[![Bellabeat Wellness Dashboard](image/Bellabeat%20Wellness%20Dashboard.png)](https://public.tableau.com/app/profile/peace.okei/viz/BellabeatSmartDeviceUsageAnalysis_17853771619350/BellabeatWellnessDashboard?publish=yes)

*Click the dashboard image to explore the interactive visualization on Tableau Public.*

## Key Findings

### 1. Users averaged fewer than 10,000 daily steps

Across 396 valid activity records, users averaged approximately **7,555 steps per day**, while the median was **6,847 steps**. The 10,000-step benchmark was reached on only **32.07% of valid days**.

This suggests that personalized and progressive activity goals may be more realistic and motivating than applying the same 10,000-step target to every user.

### 2. Activity peaked during lunch and evening hours

Hourly activity was highest at approximately:

- **7:00 p.m.** — 529 average steps per user-hour
- **12:00 p.m.** — 521 average steps per user-hour
- **6:00 p.m.** — 506 average steps per user-hour

Evening was the most active overall time period, followed closely by the afternoon. These periods may be effective windows for movement reminders, wellness challenges, and personalized app notifications.

### 3. Monday and Saturday were the most active days

Monday recorded the highest average daily steps at approximately **8,204**, followed closely by Saturday at approximately **8,181**.

Tuesday recorded the lowest average at approximately **5,980 steps**, suggesting a possible opportunity for targeted motivation earlier in the workweek.

### 4. Users averaged slightly more than seven hours of sleep

Across 403 valid sleep nights, users averaged **7.33 hours of sleep**, with a median of **7.32 hours**. Average sleep efficiency was **92.52%**.

Weekend sleep duration was generally longer, with Saturday and Sunday averaging approximately **7.78 hours**, compared with Thursday’s average of approximately **6.93 hours**.

### 5. Sleep duration was not strongly associated with daily activity

Within 179 valid matched activity-and-sleep records, sleep duration had only a weak negative correlation with daily steps:

```text
r = -0.203

