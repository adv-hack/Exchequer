-- History, Bill of Materials
SELECT CHAR([hiExCLass]) AS ExClass
	  ,Stock.stCode
	  ,CAST(CONVERT(VARBINARY(4), REVERSE(SUBSTRING(hiCode,2,4))) AS INTEGER) AS StockFolio
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
  INNER JOIN ZZZZ01.STOCK ON CAST(CONVERT(VARBINARY(4), REVERSE(SUBSTRING(hiCode,2,4))) AS INTEGER) = Stock.stFolioNum
  WHERE hiExCLass = ASCII('M')