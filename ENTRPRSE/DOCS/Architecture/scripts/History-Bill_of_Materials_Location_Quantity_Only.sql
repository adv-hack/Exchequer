-- History, Bill of Materials, Quantity Only, by Location
SELECT CHAR([hiExCLass]) AS ExClass
	  ,CAST(SUBSTRING(hiCode, 2, 1) AS VARCHAR) AS Code
	  ,CAST(CONVERT(VARBINARY(4), REVERSE(SUBSTRING(hiCode, 3, 4))) AS INTEGER) AS StockFolio
	  ,CAST(SUBSTRING(hiCode, 7, 20) AS VARCHAR) AS Location
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
  WHERE hiExCLass = 236
		AND NOT EXISTS(
			SELECT stCode FROM ZZZZ01.STOCK
			WHERE CAST(CONVERT(VARBINARY(4), REVERSE(SUBSTRING(hiCode, 2, 4))) AS INTEGER) = stFolioNum
		)