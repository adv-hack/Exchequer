-- History, Customer Stock
SELECT CHAR([hiExCLass]) AS Class
	  ,CAST(SUBSTRING(hiCode, 2, 6) AS VARCHAR) AS CustCode
	  ,STOCK.stCode
      ,CAST(CONVERT(VARBINARY(4), REVERSE(SUBSTRING(hiCode, 12, 4))) AS INTEGER) AS StockFolio
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
INNER JOIN ZZZZ01.STOCK ON CAST(CONVERT(VARBINARY(4), REVERSE(SUBSTRING(hiCode, 12, 4))) AS INTEGER) = Stock.stFolioNum 
INNER JOIN ZZZZ01.CUSTSUPP ON CAST(SUBSTRING(hiCode, 2, 6) AS VARCHAR) = CustSupp.acCode
WHERE hiExCLass = ASCII('E')
--    AND ((hiPeriod = 254) OR (hiPeriod = 255))
ORDER BY CustSupp.acCode, hiYear, hiPeriod, hiCurrency, Stock.stCode
