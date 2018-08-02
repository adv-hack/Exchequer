-- History, Customer Stock, by Cost Centre/Department
SELECT CHAR([hiExCLass]) AS Class
	  ,hiCode
	  ,CAST(SUBSTRING(hiCode, 3, 6) AS VARCHAR) AS CustCode
      ,CCDep = CASE CAST(SUBSTRING(hiCode, 18, 1) AS VARCHAR(1))
					  WHEN 'C' THEN 'Cost Centre:'
					  WHEN 'D' THEN 'Department:'
					  ELSE ''
				    END
      ,Code = CAST(SUBSTRING(hiCode, 19, 3) AS VARCHAR)
	  ,STOCK.stCode
      ,CAST(CONVERT(VARBINARY(4), REVERSE(SUBSTRING(hiCode, 13, 4))) AS INTEGER) AS StockFolio
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
INNER JOIN ZZZZ01.STOCK ON CAST(CONVERT(VARBINARY(4), REVERSE(SUBSTRING(hiCode, 13, 4))) AS INTEGER) = Stock.stFolioNum 
INNER JOIN ZZZZ01.CUSTSUPP ON CAST(SUBSTRING(hiCode, 3, 6) AS VARCHAR) = CustSupp.acCode
WHERE hiExCLass = ASCII('E')
      AND CAST(SUBSTRING(hiCode, 2, 1) AS INTEGER) = 1
--    AND ((hiPeriod = 254) OR (hiPeriod = 255))
ORDER BY CustSupp.acCode, hiYear, hiPeriod, hiCurrency, Stock.stCode
