-- History, Balance Sheet, by Cost Centre/Department
SELECT CHAR([hiExClass]) AS Class
	  ,CAST(SUBSTRING(hiCode, 2, 1) AS VARCHAR) AS CCDep
	  ,CAST(SUBSTRING(hiCode, 7, 3) AS VARCHAR) AS CCDep1
	  ,CAST(SUBSTRING(hiCode, 11, 3) AS VARCHAR) AS CCDep2
	  ,CAST(CONVERT(VARBINARY(4), REVERSE(SUBSTRING(CONVERT(VARBINARY(4), hiCode),3,4))) AS INTEGER) AS NomCode
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
FROM [EXCH67].[ZZZZ01].[HISTORY]
WHERE hiExClass = ASCII('B')
	  AND ((CAST(SUBSTRING(hiCode, 2, 1) AS VARCHAR) = 'C')
	       OR (CAST(SUBSTRING(hiCode, 2, 1) AS VARCHAR) = 'D'))