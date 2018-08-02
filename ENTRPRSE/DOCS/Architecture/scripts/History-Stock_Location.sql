-- History, Stock Location
SELECT CHAR([hiExCLass]) AS Class
	  ,Stock.stCode
      ,CAST(SUBSTRING(hiCode, 2, 1)  AS VARCHAR) As Code
	  ,CAST(CONVERT(VARBINARY(4), REVERSE(SUBSTRING(CONVERT(VARBINARY(4), hiCode), 3, 4))) AS INTEGER) AS StockFolio
      ,CAST(SUBSTRING(hiCode, 7, 3)  AS VARCHAR) As Location
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
FROM ZZZZ01.[HISTORY]
INNER JOIN ZZZZ01.STOCK ON CAST(CONVERT(VARBINARY(4), REVERSE(SUBSTRING(CONVERT(VARBINARY(4), hiCode), 3, 4))) AS INTEGER) = Stock.stFolioNum
WHERE hiExCLass = ASCII('D')
      AND CAST(SUBSTRING(hiCode, 2, 1)  AS VARCHAR) = 'L'