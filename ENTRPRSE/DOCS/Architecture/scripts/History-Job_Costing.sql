-- History, Job Costing Analysis
SELECT CHAR([hiExCLass]) AS Class
      ,CAST(SUBSTRING(hiCode, 2, 10)  AS VARCHAR) As JobCode
	  ,CAST(CONVERT(VARBINARY(4), REVERSE(SUBSTRING(hiCode, 12, 4))) AS INTEGER) AS Folio
      ,[hiYear]
      ,[hiPeriod]
      ,[hiCurrency]
      ,[hiSales]
      ,[hiPurchases]
      ,[hiBudget]
      ,[hiCleared]
      ,[hiBudget2]
      ,[hiValue1]
      ,[hiValue2]
      ,[hiValue3]
FROM [ZZZZ01].[HISTORY]
WHERE hiExCLass = ASCII('[')