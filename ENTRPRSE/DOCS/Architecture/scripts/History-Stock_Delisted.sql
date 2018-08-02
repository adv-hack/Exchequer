-- History, Delisted Stock 
SELECT CHAR([hiExCLass]) AS Class
	  ,Stock.stCode
      ,CAST(CONVERT(VARBINARY(4), REVERSE(SUBSTRING(hiCode, 2, 4))) AS INTEGER) AS StockFolio
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
INNER JOIN ZZZZ01.STOCK ON CAST(CONVERT(VARBINARY(4), REVERSE(SUBSTRING(hiCode, 2, 4))) AS INTEGER) = Stock.stFolioNum
WHERE hiExCLass = ASCII('X')
--    AND ((hiPeriod = 254) OR (hiPeriod = 255))
ORDER BY CAST(CONVERT(VARBINARY(4), REVERSE(SUBSTRING(hiCode, 2, 4))) AS INTEGER), hiYear, hiPeriod, hiCurrency
