-- History, Commitment Accounting
SELECT [hiCode]
      ,CAST(SUBSTRING(hiCode, 2, 3) AS VARCHAR) AS Commitment
      ,CAST(SUBSTRING(hiCode, 8, 1) AS VARCHAR) AS CCDepOrder
      ,CAST(SUBSTRING(hiCode, 13, 3) AS VARCHAR) AS CCDep1
      ,CAST(SUBSTRING(hiCode, 17, 3) AS VARCHAR) AS CCDep2
	  ,CAST(CONVERT(VARBINARY(4), REVERSE(SUBSTRING(hiCode, 9, 4))) AS INTEGER) AS GLCode
      ,CHAR([hiExCLass]) AS ExClass
      ,[hiCurrency]
      ,[hiYear]
      ,[hiPeriod]
      ,[hiSales]
      ,[hiPurchases]
      ,[hiBudget]
      ,[hiCleared]
      ,[hiBudget2]
      ,[hiValue1]
      ,[hiValue2]
      ,[hiValue3]
FROM [ZZZZ01].[HISTORY]
WHERE hiExCLass = ASCII('A') 
		AND CAST(SUBSTRING(hiCode, 2, 3) AS VARCHAR) = 'CMT'
		AND CAST(SUBSTRING(hiCode, 8, 1) AS VARCHAR) <> 'C'
		AND CAST(SUBSTRING(hiCode, 8, 1) AS VARCHAR) <> 'D'
  