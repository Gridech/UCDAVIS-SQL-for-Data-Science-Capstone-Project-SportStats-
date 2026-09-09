# UCDAVIS-SQL-for-Data-Science-Capstone-Project-SportStats-

This repository contains my **UC Davis SQL for Data Science Capstone Project**, which performs a deep-dive analysis on the **SportStats Olympics Dataset** spanning over 120 years of historical data. 

Moving beyond traditional medal counts, this project leverages relational database optimization and advanced SQL analytics to uncover the narratives behind Olympic performance—investigating how geography, shifting demographics, physical attributes, and historical dynamics drive global athletic achievement.

## 📖 Project Objectives & Core Narrative
* **Beyond the Medal Table:** Analyze the true drivers of Olympic success by shifting focus toward athlete demographics (Age, Height, Weight) and spatial-temporal historical growth.
* **Database Optimization:** Transform flat tables into an optimized, modular schema for faster and more scalable analytics.
* **Statistical Modeling & Growth Metrics:** Measure demographic variance across sports and isolate growth momentum across different eras and seasons.

## 🛠️ Data Engineering & Schema Optimization
To eliminate redundancy and build an efficient environment for analytical queries, the original data was checked for duplicate records and normalization anomalies. The data was then refactored into modular relational tables:
* `game_info`: Stores operational game contexts (Year, Season, Hosted City, Sport, and Event boundaries).
* `athlete_info`: Captures specific athlete metrics (Demographics, Height, Weight, and Medal achievements).
* `event_table`: Acts as a core bridge linking athletes to specific games and country representations (`NOC`).

## 🔑 Key Analytics & Insights Addressed

### 1. Demographic & Anthropometric Deep Dives
* **Gender Distributions:** Computes biometric metrics (averages of height/weight) broken down by gender.
* **Advanced Attribute Dispersions:** Utilizes dispersion functions (`MIN`, `MAX`, `AVG`, `STDDEV`) across individual sports to isolate which physical profiles naturally align with specific athletic disciplines.

### 2. Historical & Macro Growth Frameworks
* **Timeline Evolution:** Evaluates the expanding global presence of the Olympics by measuring changes in participant volume and country representation over time.
* **Partitioned Growth (Window Functions):** Uses `LAG()` and `PARTITION BY Season` to calculate structural growth differentials in athlete count and country representation from one Olympic cycle to the next.

### 3. Geographical Performance & Season Dynamics
* **Relative Success Shares:** Employs windowed aggregates to see exactly what percentage of the total historical medal pool belongs to individual nations.
* **Climate & Seasonal Bias:** Isolates seasonal strengths by comparing Summer vs. Winter medal yields per country to expose regional geographic dominance (e.g., separating winter-sports-heavy nations from summer ones).
* **Competitive Density Index (CDI):** Normalizes sports metrics by creating a custom metric calculating the ratio of unique competitors to the historical frequency of an event being held.


For more details go to : https://medium.com/@agridech/ucdavis-sql-for-data-science-capstone-project-sportsstats-f7e5a9fdbba9?sharedUserId=agridech
