-- History, Control Codes, Commitment Accounting
SELECT CHAR([hiExCLass]) AS Class
	  ,CAST(SUBSTRING(hiCode, 2, 3) AS VARCHAR) AS Code
	  ,CAST(CONVERT(VARBINARY(4), REVERSE(SUBSTRING(hiCode, 8, 4))) AS INTEGER) AS NomCode
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
	  AND CAST(SUBSTRING(hiCode, 2, 3) AS VARCHAR) = 'CMT'
