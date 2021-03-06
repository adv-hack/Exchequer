-- History, Control Codes
SELECT CHAR([hiExCLass]) AS Class
	  ,CAST(CONVERT(VARBINARY(4), REVERSE(SUBSTRING(CONVERT(VARBINARY(4), hiCode),2,4))) AS INTEGER) AS NomCode
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
WHERE hiExCLass = ASCII('C')
	  AND CAST(SUBSTRING(hiCode, 2, 3) AS VARCHAR) <> 'CMT'
