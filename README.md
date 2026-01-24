# 🚗 Automotive Inventory & Holding Cost Analytics
### *Turning raw inventory data into actionable financial insights*

## 🌟 Executive Summary
This project addresses a critical business challenge: **inventory stagnation**. By analyzing a dataset of vehicle listings, I identified a total potential loss of **$301M** in holding costs. Using a combination of **Python**, **SQL**, and **Tableau**, I built an end-to-end pipeline to segment inventory by risk and identify the specific brands and models driving financial "traps".

---

## 🛠️ The Multi-Stage Pipeline

### 1. Data Engineering & Logic (SQL)
Instead of simple queries, I implemented advanced business logic directly in the database:
* **Dynamic Segmentation:** Created a `CASE` statement to categorize vehicles into 4 groups: *Fresh, Standard, Slow,* and *TRAP* based on days on market.
* **Window Functions:** Used `RANK()` and `SUM() OVER(PARTITION BY...)` to calculate exactly how much each specific model contributes to its brand's total loss.
* **View Orchestration:** Built reusable SQL Views (`brand_model_loss_analysis`) to ensure the dashboard always has access to pre-calculated, high-performance data.

### 2. Exploratory Data Analysis (Python)
Before visualizing, I dived deep into the data using **VS Code**:
* **Holding Cost Algorithm:** Developed a script to calculate daily financial impact ($40/day per unit).
* **Statistical Correlation:** Used Heatmaps to find relationships between price, vehicle age, and market duration.

### 3. Professional Visualization (Tableau)
The final dashboard is designed for **Executive Decision Making**:
* **High-Contrast UI:** Dark mode theme for better readability and "Premium" feel.
* **Actionable KPIs:** Clear focus on the $301M Total Loss and immediate filtering by the "TRAP" segment.

---

## 📈 Deep Dive: Key Findings
* **The 90-Day Threshold:** Vehicles in the "TRAP" category (90+ days) represent the vast majority of the $301M loss.
* **Brand Liability:** **Ford** and **Chevrolet** were identified as the highest-risk brands in terms of cumulative holding costs.
* **Optimization Opportunity:** Reducing the average "days on market" by just 10% could save the company millions in liquidity.

---

## 📂 Repository Structure
* `📂 sql/` - Advanced SQL scripts with ranking logic.
* `📂 scripts/` - Python cleaning & EDA scripts.
* `📂 tableau/` - Final .twbx file (Packaged Workbook).
* `📂 data/` - Cleaned datasets.
* `📂 images/` - High-resolution dashboard previews.

---

## 💡 Skills Demonstrated
`Data Transformation` • `SQL Window Functions` • `Python Automation` • `Business Intelligence` • `Financial Modeling` • `Tableau Dashboarding`