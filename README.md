
# 🚚 UPS Logistics: Cracking the Code on Delivery Optimization

**Data-Driven Route & Performance Analytics** *Developed by Praveen Sai Lingala* 



<img width="829" height="475" alt="image" src="https://github.com/user-attachments/assets/683bdf76-4dfa-4108-9783-0e1985a427e1" />


---

## 🎯 The Mission

In the world of logistics, minutes equal millions. This project dives deep into a complex dataset to identify why deliveries fail to meet their marks. I engineered a series of SQL-driven solutions to clean messy logistics data, rank performance across 10+ warehouses, and pinpoint exactly which routes are bleeding efficiency.

## 🛠️ The Toolkit

* 
**The Engine:** MySQL / SQL Server 


* 
**Techniques:** Window Functions (`RANK`), CTEs, Subqueries, Data Imputation, and Efficiency Ratio Modeling.



---

## 🔍 Deep Dive: The Data Engineering Process

### 🧼 Phase 1: Data Fortification

Before analysis, the data had to be bulletproof:

* 
**Zero-Loss Integrity:** Identified and eliminated duplicate orders to maintain a clean source of truth.


* 
**Smart Imputation:** Developed a fallback logic to handle missing traffic delay data by calculating route-specific averages.


* 
**Temporal Logic:** Standardized all dates to `YYYY-MM-DD` and enforced business rules ensuring deliveries never occurred before the order was placed.



### 📈 Phase 2: Performance Intelligence

I didn't just look at delays; I looked at **why** they happened:

* 
**Efficiency Ratios:** Modeled the "Distance-to-Time" ratio to identify the 3 worst-performing routes.



$$\text{Efficiency} = \frac{\text{Distance KM}}{\text{Avg Travel Time Min}}$$


* 
**Warehouse Bottlenecks:** Used CTEs to flag warehouses like **W010** and **W009** that exceeded the global average processing time.


* 
**Human Capital:** Ranked agents by on-time delivery percentages, discovering that top agents maintain an average speed of **68 KM/H** compared to **56.8 KM/H** for the bottom tier.



---

## 💡 Strategic Insights & Recommendations

I translated raw numbers into a boardroom-ready optimization plan:

* 
**The "20% Rule":** Prioritize optimization for routes where more than 20% of shipments are consistently late.


* 
**Addressing the "Big Three":** Sorting delays, Weather, and Traffic were identified as the primary friction points.


* 
**The Action Plan:** Implement dynamic routing, traffic-aware dispatching, and veteran driver assignments for high-risk zones.



---

## 📊 Results at a Glance

* 
**Global On-Time Percentage:** 56%.


* 
**Primary Bottleneck:** Sorting Delays (272 incidents).


* 
**Worst Route Efficiency:** Found in Routes R001, R002, and R003.



---


**Would you like me to create some custom "Shields" or "Badges" (like the ones you see on professional GitHub profiles) to highlight your Machine Learning and SQL skills?**
