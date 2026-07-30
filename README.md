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
Across 396 valid activity records, users averaged approximately **7,555 steps per day**, while the median was **6,847 steps**. The 10,000-step benchmark was reached on only **32.07% of valid days**. This suggests that personalized and progressive activity goals may be more realistic and motivating than applying the same 10,000-step target to every user.

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
Across 403 valid sleep nights, users averaged **7.33 hours of sleep**, with a median of **7.32 hours**. Average sleep efficiency was **92.52%**. Weekend sleep duration was generally longer, with Saturday and Sunday averaging approximately **7.78 hours**, compared with Thursday’s average of approximately **6.93 hours**.

### 5. Sleep duration was not strongly associated with daily activity
Within 179 valid matched activity-and-sleep records, sleep duration had only a weak negative correlation with daily steps:

```text
r = -0.203
```

## Business Recommendations
### 1. Promote personalized and progressive activity goals
Users averaged approximately 7,555 daily steps and reached the 10,000-step benchmark on only 32.07% of valid days. Rather than presenting 10,000 steps as the only measure of success, the Bellabeat app could recommend goals based on each user’s current activity level. For example, Bellabeat could:
- Establish a personal activity baseline during onboarding
- Recommend gradual weekly step increases
- Celebrate improvements and consistency, not only goal completion
- Offer adaptive challenges based on the user’s recent performance
Marketing messages could position Bellabeat as a supportive wellness companion that helps users make sustainable progress without relying on unrealistic, one-size-fits-all expectations.

### 2. Deliver activity prompts during high-opportunity periods
Activity was highest around lunchtime and during the evening, with the strongest hourly peaks occurring at approximately 12:00 p.m., 6:00 p.m., and 7:00 p.m. Bellabeat could use these behavioral windows to deliver personalized movement prompts, such as:
- Midday walking reminders
- Short lunch-break movement challenges
- After-work activity suggestions
- Evening progress updates and step-goal reminders
Notifications should remain customizable so users can select preferred times and avoid receiving excessive or irrelevant messages.

### 3. Create targeted campaigns for lower-activity days
Tuesday recorded the lowest average daily step count, while Monday and Saturday had the highest averages.Bellabeat could introduce a Tuesday-focused engagement campaign, such as:
- “Tuesday Momentum” step challenges
- Short guided movement sessions
- Midweek accountability reminders
- Bonus rewards for completing personalized activity goals
Rather than treating the lower activity level as a weakness, Bellabeat could position Tuesday as an opportunity to rebuild momentum early in the week.

### 4. Combine sleep duration with sleep-continuity insights
Users averaged 7.33 hours of sleep, but approximately one-quarter of valid nights were classified as fragmented sleep.
The Bellabeat app could help users look beyond total sleep duration by highlighting:
- Sleep consistency
- Restless minutes
- Time spent in bed compared with time asleep
- Single-session versus fragmented sleep patterns
- Weekly changes in sleep behavior
Marketing content could emphasize that healthy sleep is not only about the number of hours recorded, but also about understanding personal patterns and building consistent routines.

### 5. Position Bellabeat as an integrated wellness platform
The analysis found only weak relationships between daily sleep duration and activity measures. This suggests that sleep and activity should not be presented as having a simple cause-and-effect relationship. Instead, Bellabeat could position its app and membership as tools for understanding several connected dimensions of wellness, including:
- Activity
- Sleep
- Stress
- Mindfulness
- Nutrition
- Hydration
This broader positioning would allow Bellabeat to market personalized wellness guidance without making unsupported claims that improving one behavior will automatically improve another.

## Limitations
This analysis provides useful directional insights, but several limitations should be considered when interpreting the findings:
- The dataset contains records from a relatively small sample of approximately 35 Fitbit users.
- Activity and sleep participation varied across the individual data tables.
- Only 23 users contributed sleep records, and the combined activity-and-sleep analysis included 20 users.
- Participants contributed data for different lengths of time, with an average activity participation window of approximately 13 days.
- The dataset covers only March 12 through April 12, 2016, so it may not reflect seasonal or long-term behavioral patterns.
- The data comes from Fitbit users rather than Bellabeat customers.
- Demographic information, including age, gender, occupation, health status, and location, was not available.
- Because Bellabeat primarily markets wellness products to women, the absence of gender information limits how confidently the results can be applied to its target audience.
- Zero-step and unusual sleep records required quality rules based on observable patterns. These classifications are analytical judgments rather than confirmed explanations of user behavior.
- The dataset is observational. Relationships identified through correlation do not establish causation.
- Weight data was excluded from the primary analysis because it contained only 33 records from 11 users and had substantial missing body-fat information.
The findings should therefore be treated as directional evidence that can guide future research and marketing experiments rather than as conclusions representing all smart-device users.

## Conclusion
This analysis examined Fitbit activity and sleep data to understand how consumers use smart wellness devices and how those behaviors could inform Bellabeat’s marketing strategy.
Users averaged approximately 7,555 daily steps and reached the 10,000-step benchmark on about one-third of valid days. Activity was strongest around lunchtime and during the evening, while Tuesday recorded the lowest average activity level. Users averaged 7.33 hours of sleep, although approximately one-quarter of valid nights contained multiple sleep sessions.
The analysis found only weak relationships between sleep duration and daily activity, reinforcing the importance of avoiding simplified cause-and-effect wellness claims.
Bellabeat can use these findings to promote personalized activity goals, deliver timely and customizable movement prompts, create campaigns for lower-activity periods, and provide users with a more complete view of sleep quality and wellness patterns. These strategies could help position the Bellabeat app as a supportive, personalized platform for sustainable lifestyle improvement.
