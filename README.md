# Banking-Insights-Analysis-using-SQL

1. Project Overview 
This project simulates a real-world banking analytics scenario where I performed data analysis using SQL Server Management Studio (SSMS) on a relational database containing customer, transaction, branch, and account data. 
The goal was to extract actionable insights to help business teams understand customer behavior, branch performance, transaction patterns, and channel utilization.

![image](https://plus.unsplash.com/premium_photo-1755627771833-f6999781bb00?fm=jpg&ixid=M3wxMjA3fDB8MHxwaG90by1yZWxhdGVkfDE4fHx8ZW58MHx8fHx8&ixlib=rb-4.1.0&q=60&w=3000)
 

3. Problem Statement 

Financial institutions often struggle to identify patterns in customer transactions and branch operations due to large data volumes and disconnected data sources. 

The task was to: 
Build a structured database for banking operations. 
Write optimized SQL queries to uncover key business insights. 
Simulate dashboards and reports used by business analysts and risk teams. 


3. Database Design 

Tables Created: 

Customers: Customer demographics and contact information. 
Accounts: Account details, business segment, and account type. 
TransactionHistory: Records of all transactions, including date, amount, and status. 
Branch: Contains branch information, region, and branch head. 
AlternateChannels: Captures channel usage such as POS, Mobile, ATM, and Web. 
Transaction Archives: Historical transaction tables. 

 

4. SQL Objectives 

Customer segmentation and profiling. 
Transaction trend and revenue analysis. 
Branch and regional performance monitoring. 
Transaction channel utilization. 
Account type and business segment performance.  

 
5. Analytical Queries & Insights  

A. Customer Segmentation Analysis 

Classified customers into Young (18 - 29), Adult (30 - 44), and Old (45+) categories. 
Found that Adult customers (30 - 44) represented the majority, with the highest average account balance. 
Insight: Marketing campaigns should focus on adults in the 30 - 44 range as they maintain stronger balances and frequent transactions. 


B. Transaction Summary by Gender & Status 

Segmented transactions by gender and success status. 
Identified that female customers performed slightly higher successful transaction volumes. 
 Insight: Enhance mobile app experience targeting female users to maintain engagement. 


C. Active Customer Check 

Detected customers who haven’t transacted in over 12 months despite active accounts. 
Insight: The inactive segment could be reactivated through loyalty programs or account engagement campaigns. 


D. Transaction Trend Analysis 

Combined monthly transaction archives (January - November) to track monthly revenue and transaction volume. 

Calculated:  	
Month-over-month (MoM) growth rate. 
3-month moving average for revenue and transaction volume. 
Rank by total transaction value. 

 Insight: 
October recorded the highest transaction volumes. 
Early-year months showed lower activity due to reduced spending behavior. 
 

E. Branch & Regional Performance 
Ranked branches by total transaction amount. 
Calculated branch contribution percentage to total performance. 
Aggregated performance by region. 

 Insight: 
North Region contributed the highest share of total transactions (~35%). 
Top 3 Branches accounted for nearly 90% of the bank’s transaction value. 

 

F. Transaction Channel Analysis 

Compared usage frequency across USSD, MobileApp, ATM, and Online banking. 
Insight: 
Online banking showed the highest usage frequency, followed by Mobile banking. 
 

G. Account Type & Business Segment Performance 

Aggregated data by AccountType (Savings, Current, Corporate) and BusinessSegment (Retail Banking vs Business Banking). 

 Insight: 
Savings Accounts generated the highest transaction account. 

 
6. Tools & Techniques Used 

SQL Server Management Studio (SSMS) 
SQL Window Functions (RANK, LAG, DENSE_RANK) 
Aggregations (SUM, COUNT, AVG) 
Joins, CTEs, and Subqueries 
CASE Expressions and Date Functions 
 


7. Impact 

These SQL analyses replicate how data analysts in the banking industry monitor performance and customer engagement. 

 Insights derived from these queries could guide: 
Customer retention initiatives. 
Regional performance tracking. 
Channel optimization strategies. 
Product profitability analysis. 
