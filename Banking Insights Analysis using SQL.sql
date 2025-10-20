--------------------1. Customer Segmentation Analysis --------------
--------------------customers by age brackets-------------------
SELECT Age_bracket, COUNT(*) Total_Customers,AVG(Balance) Avg_Balance
FROM
	(SELECT Balance,
	CASE 
		WHEN DATEDIFF(YEAR,a.dateofbirth,GETDATE()) BETWEEN 18 AND 29 THEN 'Young'
		WHEN DATEDIFF(YEAR,a.dateofbirth,GETDATE()) BETWEEN 30 AND 44 THEN 'ADULT'
		ELSE 'OLD'
	END AS Age_bracket
	FROM Customers a
	LEFT JOIN accounts b ON a.CustomerID = b.CustomerID
	)t
GROUP BY Age_bracket
ORDER BY Total_Customers DESC

---------------------------------Transaction summary by gender & Transaction Status .--------------------------------------------------------
WITH TransactionTable AS (
		SELECT a.*,b.Gender
		FROM TransactionHistory a
		LEFT JOIN Customers b ON a.CustomerID = b.CustomerID
		) 
SELECT Gender,
CASE
	WHEN TransactionStatus = 'Completed' THEN 'Successfull'
	ELSE 'Failed' 
END AS Transaction_Status,COUNT(transactionID) Tran_Count,SUM(TransactionAmount) Tran_Amount,AVG(Transactionamount) Avg_Amount
FROM TransactionTable
GROUP BY Gender,CASE
	WHEN TransactionStatus = 'Completed' THEN 'Successfull'
	ELSE 'Failed' 
END

-------------------------------Active customers — customers who haven’t transacted in More than 12 Months------------------------------
SELECT a.Customerid,Concat(firstname, ' ', LastName)Customer_Name,Email,PhoneNumber, Max(Transactiondate) Last_Tran_Date
FROM TransactionHistory a
LEFT JOIN customers b ON a.CustomerID = b.CustomerID
WHERE AccountStatus = 'Active'
GROUP BY a.customerid,Concat(firstname, ' ', LastName),Email,PhoneNumber
HAVING Max(Transactiondate) < DATEADD(MONTH, -12,GETDATE())  OR MAX(TransactionDate) IS NULL

------------------------------------------
 -------------------------------------2. Transaction Trend Analysis------------------------------
 -------------------------------------monthly revenue trends year-over-year  ------------
WITH MonthlyData AS (
 	    SELECT 
        DATENAME(MONTH, TransactionDate) AS MonthName,
        DATEPART(MONTH, TransactionDate) AS MonthNumber,
        COUNT(TransactionID) AS Total_Transactions,
        SUM(TransactionAmount) AS Total_Amount
    FROM TransactionHistory
    GROUP BY DATENAME(MONTH, TransactionDate), DATEPART(MONTH, TransactionDate)
    UNION ALL
    SELECT 
        DATENAME(MONTH, TransactionDate) AS MonthName,
        DATEPART(MONTH, TransactionDate) AS MonthNumber,
        COUNT(TransactionID) AS Total_Transactions,
        SUM(Amount) AS Total_Amount
    FROM Transactions_January
    GROUP BY DATENAME(MONTH, TransactionDate), DATEPART(MONTH, TransactionDate)
    UNION ALL
    SELECT 
        DATENAME(MONTH, TransactionDate) AS MonthName,
        DATEPART(MONTH, TransactionDate) AS MonthNumber,
        COUNT(TransactionID) AS Total_Transactions,
        SUM(Amount) AS Total_Amount
    FROM Transactions_February
    GROUP BY DATENAME(MONTH, TransactionDate), DATEPART(MONTH, TransactionDate)
    UNION ALL
    SELECT 
        DATENAME(MONTH, TransactionDate) AS MonthName,
        DATEPART(MONTH, TransactionDate) AS MonthNumber,
        COUNT(TransactionID) AS Total_Transactions,
        SUM(Amount) AS Total_Amount
    FROM Transactions_March
    GROUP BY DATENAME(MONTH, TransactionDate), DATEPART(MONTH, TransactionDate)
    UNION ALL
    SELECT 
        DATENAME(MONTH, TransactionDate) AS MonthName,
        DATEPART(MONTH, TransactionDate) AS MonthNumber,
        COUNT(TransactionID) AS Total_Transactions,
        SUM(Amount) AS Total_Amount
    FROM Transactions_April
    GROUP BY DATENAME(MONTH, TransactionDate), DATEPART(MONTH, TransactionDate)
    UNION ALL
    SELECT 
        DATENAME(MONTH, TransactionDate) AS MonthName,
        DATEPART(MONTH, TransactionDate) AS MonthNumber,
        COUNT(TransactionID) AS Total_Transactions,
        SUM(Amount) AS Total_Amount
    FROM Transactions_May
    GROUP BY DATENAME(MONTH, TransactionDate), DATEPART(MONTH, TransactionDate)
    UNION ALL
    SELECT 
        DATENAME(MONTH, TransactionDate) AS MonthName,
        DATEPART(MONTH, TransactionDate) AS MonthNumber,
        COUNT(TransactionID) AS Total_Transactions,
        SUM(Amount) AS Total_Amount
    FROM Transactions_June
    GROUP BY DATENAME(MONTH, TransactionDate), DATEPART(MONTH, TransactionDate)
    UNION ALL
    SELECT 
        DATENAME(MONTH, TransactionDate) AS MonthName,
        DATEPART(MONTH, TransactionDate) AS MonthNumber,
        COUNT(TransactionID) AS Total_Transactions,
        SUM(Amount) AS Total_Amount
    FROM Transactions_July
    GROUP BY DATENAME(MONTH, TransactionDate), DATEPART(MONTH, TransactionDate)
    UNION ALL
    SELECT 
        DATENAME(MONTH, TransactionDate) AS MonthName,
        DATEPART(MONTH, TransactionDate) AS MonthNumber,
        COUNT(TransactionID) AS Total_Transactions,
        SUM(Amount) AS Total_Amount
    FROM Transactions_August
    GROUP BY DATENAME(MONTH, TransactionDate), DATEPART(MONTH, TransactionDate)
    UNION ALL
    SELECT 
        DATENAME(MONTH, TransactionDate) AS MonthName,
        DATEPART(MONTH, TransactionDate) AS MonthNumber,
        COUNT(TransactionID) AS Total_Transactions,
        SUM(Amount) AS Total_Amount
    FROM Transactions_September
    GROUP BY DATENAME(MONTH, TransactionDate), DATEPART(MONTH, TransactionDate)
    UNION ALL
    SELECT 
        DATENAME(MONTH, TransactionDate) AS MonthName,
        DATEPART(MONTH, TransactionDate) AS MonthNumber,
        COUNT(TransactionID) AS Total_Transactions,
        SUM(Amount) AS Total_Amount
    FROM Transactions_November
    GROUP BY DATENAME(MONTH, TransactionDate), DATEPART(MONTH, TransactionDate)
),
 MonthlyTotals AS (
    SELECT
        MonthName,
        MonthNumber,
        SUM(Total_Transactions) AS Total_Transactions,
        SUM(Total_Amount) AS Total_Amount
    FROM MonthlyData
    GROUP BY MonthName, MonthNumber
)
, MonthlyAnalysis AS (
    SELECT
        MonthName,
        MonthNumber,
        Total_Transactions,
        Total_Amount,

        -- MoM Growth in Transactions
        LAG(Total_Transactions) OVER (ORDER BY MonthNumber) AS Prev_Transactions,
        LAG(Total_Amount) OVER (ORDER BY MonthNumber) AS Prev_Amount,

        -- 3-month moving averages
        AVG(Total_Transactions) OVER (ORDER BY MonthNumber ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS MovingAvg_Transactions,
        AVG(Total_Amount) OVER (ORDER BY MonthNumber ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS MovingAvg_Amount
    FROM MonthlyTotals
)

SELECT
    MonthName,
    Total_Transactions,
    Total_Amount,

    -- MoM Growth (%)
    CASE 
        WHEN Prev_Transactions IS NULL THEN NULL
        WHEN Prev_Transactions = 0 THEN NULL
        ELSE ROUND(((Total_Transactions - Prev_Transactions) * 100.0 / Prev_Transactions), 2)
    END AS Transaction_GrowthRate,

    CASE 
        WHEN Prev_Amount IS NULL THEN NULL
        WHEN Prev_Amount = 0 THEN NULL
        ELSE ROUND(((Total_Amount - Prev_Amount) * 100.0 / Prev_Amount), 2)
    END AS Amount_GrowthRate,

    -- 3-Month Moving Average
    ROUND(MovingAvg_Transactions, 2) AS MovingAvg_Transactions,
    ROUND(MovingAvg_Amount, 2) AS MovingAvg_Amount,

    -- Detect decline flag (current < moving average)
    CASE 
        WHEN Total_Transactions < MovingAvg_Transactions THEN 'Decline'
        ELSE 'Stable/Increase'
    END AS TransactionTrend,
	RANK() OVER (ORDER BY Total_Amount DESC) AS Rank_By_Amount,
    DENSE_RANK() OVER (ORDER BY Total_Amount DESC) AS DenseRank_By_Amount
FROM MonthlyAnalysis
ORDER BY MonthNumber;

--------------------------------------------peak months of the year-----------
SELECT TOP 1
    DATENAME(MONTH, TransactionDate) AS PeakMonth,
    COUNT(TransactionID) AS Total_Transactions
FROM TransactionHistory
GROUP BY DATENAME(MONTH, TransactionDate)
ORDER BY COUNT(TransactionID) DESC;

-----------------------------------------Branch Performance-------------
SELECT a.BranchID,BranchName,Branchhead,Region,
COUNT(Transactionid) Total_Transaction,
SUM(TransactionAmount) Total_Tran_Amount
FROM Branch a
LEFT JOIN Accounts b ON a.BranchID =b.BranchID
LEFT JOIN TransactionHistory c ON b.CustomerID = c.CustomerID
GROUP BY a.BranchID,BranchName,Branchhead,Region
ORDER BY Total_Tran_Amount DESC

---------------------------------------Regional Performance----------------------------

SELECT 
    a.Region,
    COUNT(c.TransactionID) AS Total_Transaction,
    SUM(c.TransactionAmount) AS Total_Tran_Amount,
    ROUND(100.0 * SUM(c.TransactionAmount) / SUM(SUM(c.TransactionAmount)) OVER(), 2) AS Regional_Contribution_Percent
FROM Branch a
LEFT JOIN Accounts b ON a.BranchID = b.BranchID
LEFT JOIN TransactionHistory c ON b.CustomerID = c.CustomerID
GROUP BY a.Region
ORDER BY Total_Tran_Amount DESC;


-----------------------------------Branch Ranking by total customer Transaction amount-----------------------------------------------------------

SELECT *,
       RANK() OVER(ORDER BY Total_Tran_Amount DESC) AS Branch_Rank
FROM (
    SELECT a.BranchID,a.BranchName,a.Branchhead,a.Region,
        COUNT(c.TransactionID) AS Total_Transaction,
        SUM(c.TransactionAmount) AS Total_Tran_Amount
    FROM Branch a
    LEFT JOIN Accounts b ON a.BranchID = b.BranchID
    LEFT JOIN TransactionHistory c ON b.CustomerID = c.CustomerID
    GROUP BY a.BranchID, a.BranchName, a.Branchhead, a.Region
) t
-----------------------------------branch contribution % to overall performance----------------------------
WITH BranchSummary AS (
    SELECT 
        a.BranchID,
        a.BranchName,
        a.Branchhead,
        a.Region,
        COUNT(c.TransactionID) AS Total_Transactions,
        SUM(c.TransactionAmount) AS Total_Tran_Amount
    FROM Branch a
    LEFT JOIN Accounts b ON a.BranchID = b.BranchID
    LEFT JOIN TransactionHistory c ON b.CustomerID = c.CustomerID
    GROUP BY a.BranchID, a.BranchName, a.Branchhead, a.Region
)
SELECT BranchID,BranchName,Branchhead,Region,Total_Transactions,Total_Tran_Amount,
    ROUND( 100.0 * Total_Tran_Amount / SUM(Total_Tran_Amount) OVER(),2) AS Branch_Contribution_Percent
FROM BranchSummary
ORDER BY Branch_Contribution_Percent DESC;


-------------------------------------------Transaction Channel analysis--------------------

SELECT Channelname,COUNT(DISTINCT Customerid) AS Customer_Count,
    SUM(UsageFrequency) AS Usage_Frequency
FROM AlternateChannels
GROUP BY Channelname
ORDER BY Usage_Frequency DESC



----------------------------------------Account Type and Segment Performance----------------------------
SELECT BusinessSegment,
    COUNT(DISTINCT a.CustomerID) AS ActiveCustomers,
    SUM(TransactionAmount) AS TotalAmount,
    AVG(TransactionAmount) AS AvgAmount
FROM TransactionHistory a
JOIN Accounts b ON a.CustomerID = b.CustomerID
GROUP BY BusinessSegment
ORDER BY TotalAmount DESC










