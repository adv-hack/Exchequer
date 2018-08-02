-- History
SELECT CHAR([hiExCLass]) + ' (' + CAST(hiExCLass AS VARCHAR) + ')' AS Class
--      ,hiCode
      ,[Category] = CASE hiExCLass
									WHEN 49 THEN '?'
									WHEN 50 THEN '?'
									WHEN 51 THEN '?'
									WHEN 52 THEN '?'
									WHEN 53 THEN '?'
									WHEN 54 THEN '?'
									WHEN 56 THEN 'G/L Views - Balance'
									WHEN 57 THEN 'G/L Views - Heading'
									WHEN 65 THEN 'Profit/Loss'	
									WHEN 66 THEN 'Balance Sheet'	
									WHEN 67 THEN 'Control'	
									WHEN 68 THEN 'Stock Location'	
									WHEN 69 THEN 'Customer Stock History'	
									WHEN 70 THEN 'Carry Flag'	
									WHEN 71 THEN 'Stock Item Group'	
									WHEN 72 THEN 'G/L Header'	
									WHEN 73 THEN 'VAT Input'
									WHEN 74 THEN 'Job Code (Job)'	
									WHEN 75 THEN 'Job Code (Contract)'
									WHEN 77 THEN 'Commitment or BoM'	
									WHEN 79 THEN 'VAT Output'
									WHEN 80 THEN 'Stock Item'
									WHEN 83 THEN '?'	
									WHEN 84 THEN '?'
									WHEN 85 THEN 'Customer History'
									WHEN 86 THEN 'Customer History (Posting)'
									WHEN 87 THEN 'Customer Gross Profit History'	
									WHEN 88 THEN 'Delisted Stock Item'	
									WHEN 90 THEN 'Job Code (Phase)'
									WHEN 91 THEN 'Job Costing Analysis'
									WHEN 92 THEN 'Employee History'	
									WHEN 227 THEN 'Stock Quantity (Location)'
									WHEN 230 THEN 'Stock Quantity (Group)'
									WHEN 236 THEN 'Stock Quantity (BoM)'
									WHEN 239 THEN 'Stock Quantity (Product)'
									WHEN 247 THEN 'Stock Quantity (Delisted)'
									ELSE 'Unknown'
							 END
      ,[hiCurrency] AS Curr
      ,[hiYear] + 1900 AS Yr
      ,[hiPeriod] AS Pr
      ,[hiSales] AS Sales
      ,[hiPurchases] AS Purchases
      ,[hiCleared] AS Cleared
      ,[hiBudget] AS Budget
      ,[hiRevisedBudget1] AS [RevisedBudget1]
      ,[hiRevisedBudget2] AS [RevisedBudget2]
      --,[hiRevisedBudget3] AS [RevisedBudget3]
      --,[hiRevisedBudget4] AS [RevisedBudget4]
      --,[hiRevisedBudget5] AS [RevisedBudget5]
      --,[hiValue1] AS [Value 1]
      --,[hiValue2] AS [Value 2]
      --,[hiValue3] AS [Value 3]
      ,[G/L] = CASE hiExCLass
						WHEN ASCII('A') THEN
							-- Check for Commitment record
							CASE CAST(SUBSTRING(hiCode, 2, 3) AS VARCHAR)
								WHEN 'CMT' THEN
									-- Check for Cost Centre/Department
									CASE CAST(SUBSTRING(hiCode, 8, 1) AS VARCHAR)
										WHEN 'C' THEN CAST(CONVERT(VARBINARY(4), REVERSE(SUBSTRING(hiCode,9,4))) AS INTEGER)
										WHEN 'D' THEN CAST(CONVERT(VARBINARY(4), REVERSE(SUBSTRING(hiCode,9,4))) AS INTEGER)
										ELSE CAST(CONVERT(VARBINARY(4), REVERSE(SUBSTRING(hiCode,8,4))) AS INTEGER)
									END
								ELSE 
									-- Check for Cost Centre/Department
									CASE CAST(SUBSTRING(hiCode, 2, 1) AS VARCHAR)
										WHEN 'C' THEN CAST(CONVERT(VARBINARY(4), REVERSE(SUBSTRING(hiCode,3,4))) AS INTEGER)
										WHEN 'D' THEN CAST(CONVERT(VARBINARY(4), REVERSE(SUBSTRING(hiCode,3,4))) AS INTEGER)
										ELSE CAST(CONVERT(VARBINARY(4), REVERSE(SUBSTRING(hiCode,2,4))) AS INTEGER)
									END
								END
						WHEN ASCII('B') THEN
								-- Check for Cost Centre/Department
								CASE CAST(SUBSTRING(hiCode, 2, 1) AS VARCHAR)
									WHEN 'C' THEN CAST(CONVERT(VARBINARY(4), REVERSE(SUBSTRING(hiCode,3,4))) AS INTEGER)
									WHEN 'D' THEN CAST(CONVERT(VARBINARY(4), REVERSE(SUBSTRING(hiCode,3,4))) AS INTEGER)
									ELSE CAST(CONVERT(VARBINARY(4), REVERSE(SUBSTRING(hiCode,2,4))) AS INTEGER)
								END
						WHEN ASCII('C') THEN
							-- Check for Commitment record
							CASE CAST(SUBSTRING(hiCode, 2, 3) AS VARCHAR)
								WHEN 'CMT' THEN CAST(CONVERT(VARBINARY(4), REVERSE(SUBSTRING(hiCode,9,4))) AS INTEGER)
								ELSE CAST(CONVERT(VARBINARY(4), REVERSE(SUBSTRING(hiCode,2,4))) AS INTEGER)
							END
						WHEN ASCII('F') THEN CAST(CONVERT(VARBINARY(4), REVERSE(SUBSTRING(hiCode,2,4))) AS INTEGER)
						WHEN ASCII('H') THEN 
							CASE CAST(SUBSTRING(hiCode, 2, 1) AS VARCHAR)
								-- Check for Cost Centre/Department
								WHEN 'C' THEN CAST(CONVERT(VARBINARY(4), REVERSE(SUBSTRING(hiCode,3,4))) AS INTEGER)
								WHEN 'D' THEN CAST(CONVERT(VARBINARY(4), REVERSE(SUBSTRING(CONVERT(VARBINARY(4), hiCode),3,4))) AS INTEGER)
								ELSE CAST(CONVERT(VARBINARY(4), REVERSE(SUBSTRING(hiCode,2,4))) AS INTEGER)
							END
						WHEN ASCII('M') THEN
							CASE
								WHEN CAST(SUBSTRING(hiCode, 2, 3) AS VARCHAR) = 'CMT' AND NOT (CAST(SUBSTRING(hiCode, 8, 1) AS INTEGER) IN (67, 68)) THEN
									CAST(CONVERT(VARBINARY(4), REVERSE(SUBSTRING(hiCode, 8, 4))) AS INTEGER)
								ELSE NULL
							END
						ELSE NULL
					END
      ,[Cost Ctr] = CASE hiExCLass
						WHEN ASCII('A') THEN
							-- Check for Commitment record
							CASE CAST(SUBSTRING(hiCode, 2, 3) AS VARCHAR)
								WHEN 'CMT' THEN
									CASE CAST(SUBSTRING(hiCode, 8, 1) AS VARCHAR)
										WHEN 'C' THEN
											CASE CAST(SUBSTRING(hiCode, 16, 1) AS INTEGER)
												WHEN 1 THEN CAST(SUBSTRING(hiCode, 17, 3) AS VARCHAR)
												ELSE CAST(SUBSTRING(hiCode, 13, 3) AS VARCHAR)
											END
										ELSE NULL
									END
								ELSE
									CASE CAST(SUBSTRING(hiCode, 2, 1) AS VARCHAR)
										WHEN 'C' THEN
											CASE CAST(SUBSTRING(hiCode, 10, 1) AS INTEGER)
												WHEN 1 THEN CAST(SUBSTRING(hiCode, 11, 3) AS VARCHAR)
												ELSE CAST(SUBSTRING(hiCode, 7, 3) AS VARCHAR)
											END
										ELSE NULL
									END
							END
						WHEN ASCII('B') THEN
							CASE CAST(SUBSTRING(hiCode, 2, 1) AS VARCHAR)
								WHEN 'C' THEN CAST(SUBSTRING(hiCode, 7, 3) AS VARCHAR)
								WHEN 'D' THEN
									CASE CAST(SUBSTRING(hiCode, 10, 1) AS INTEGER)
										WHEN 1 THEN CAST(SUBSTRING(hiCode, 11, 3) AS VARCHAR)
										WHEN 2 THEN CAST(SUBSTRING(hiCode, 7, 3) AS VARCHAR)
										ELSE NULL
									END
								ELSE NULL
							END
						WHEN ASCII('C') THEN
							-- Check for Commitment record
							CASE CAST(SUBSTRING(hiCode, 2, 3) AS VARCHAR)
								WHEN 'CMT' THEN
									CASE CAST(SUBSTRING(hiCode, 8, 1) AS VARCHAR)
										WHEN 'C' THEN
											CASE CAST(SUBSTRING(hiCode, 16, 1) AS INTEGER)
												WHEN 1 THEN CAST(SUBSTRING(hiCode, 17, 3) AS VARCHAR)
												ELSE CAST(SUBSTRING(hiCode, 13, 3) AS VARCHAR)
											END
										ELSE NULL
									END
								ELSE NULL
							END
						WHEN ASCII('E') THEN
							CASE CAST(SUBSTRING(hiCode, 2, 1) AS INTEGER)
								WHEN 1 THEN 
									CASE CAST(SUBSTRING(hiCode, 18, 1) AS VARCHAR)
										WHEN 'C' THEN CAST(SUBSTRING(hiCode, 19, 3) AS VARCHAR)
										ELSE NULL
									END
								ELSE NULL
							END
						WHEN ASCII('H') THEN 
							CASE CAST(SUBSTRING(hiCode, 2, 1) AS VARCHAR)
								WHEN 'C' THEN CAST(SUBSTRING(hiCode, 7, 3) AS VARCHAR)
								WHEN 'D' THEN
									CASE CAST(SUBSTRING(hiCode, 10, 1) AS INTEGER)
										WHEN 1 THEN CAST(SUBSTRING(hiCode, 11, 3) AS VARCHAR)
										WHEN 2 THEN CAST(SUBSTRING(hiCode, 7, 3) AS VARCHAR)
										ELSE NULL
									END
								ELSE NULL
							END
						WHEN ASCII('M') THEN
							CASE
								WHEN CAST(SUBSTRING(hiCode, 2, 3) AS VARCHAR) = 'CMT' THEN
									CASE CAST(SUBSTRING(hiCode, 8, 1) AS VARCHAR)
										WHEN 'C' THEN CAST(SUBSTRING(hiCode, 13, 3) AS VARCHAR)
										WHEN 'D' THEN
											CASE CAST(SUBSTRING(hiCode, 16, 1) AS INTEGER)
												WHEN 1 THEN CAST(SUBSTRING(hiCode, 17, 3) AS VARCHAR)
												WHEN 2 THEN CAST(SUBSTRING(hiCode, 13, 3) AS VARCHAR)
												ELSE NULL
											END
										ELSE NULL
									END
								ELSE NULL
							END								
						ELSE NULL
					END
      ,[Dept] = CASE hiExCLass
						WHEN ASCII('A') THEN
							-- Check for Commitment record
							CASE CAST(SUBSTRING(hiCode, 2, 3) AS VARCHAR)
								WHEN 'CMT' THEN
									CASE CAST(SUBSTRING(hiCode, 8, 1) AS VARCHAR)
										WHEN 'D' THEN
											CASE CAST(SUBSTRING(hiCode, 16, 1) AS INTEGER)
												WHEN 1 THEN CAST(SUBSTRING(hiCode, 17, 3) AS VARCHAR)
												ELSE CAST(SUBSTRING(hiCode, 13, 3) AS VARCHAR)
											END
										ELSE NULL
									END
								ELSE
									CASE CAST(SUBSTRING(hiCode, 2, 1) AS VARCHAR)
										WHEN 'D' THEN
											CASE CAST(SUBSTRING(hiCode, 10, 1) AS INTEGER)
												WHEN 1 THEN CAST(SUBSTRING(hiCode, 11, 3) AS VARCHAR)
												ELSE CAST(SUBSTRING(hiCode, 7, 3) AS VARCHAR)
											END
										ELSE NULL
									END
							END
						WHEN ASCII('B') THEN
							CASE CAST(SUBSTRING(hiCode, 2, 1) AS VARCHAR)
								WHEN 'D' THEN CAST(SUBSTRING(hiCode, 7, 3) AS VARCHAR)
								WHEN 'C' THEN
									CASE CAST(SUBSTRING(hiCode, 10, 1) AS INTEGER)
										WHEN 1 THEN CAST(SUBSTRING(hiCode, 7, 3) AS VARCHAR)
										WHEN 2 THEN CAST(SUBSTRING(hiCode, 11, 3) AS VARCHAR)
										ELSE NULL
									END
								ELSE NULL
							END
						WHEN ASCII('C') THEN
							-- Check for Commitment record
							CASE CAST(SUBSTRING(hiCode, 2, 3) AS VARCHAR)
								WHEN 'CMT' THEN
									CASE CAST(SUBSTRING(hiCode, 8, 1) AS VARCHAR)
										WHEN 'D' THEN
											CASE CAST(SUBSTRING(hiCode, 16, 1) AS INTEGER)
												WHEN 1 THEN CAST(SUBSTRING(hiCode, 17, 3) AS VARCHAR)
												ELSE CAST(SUBSTRING(hiCode, 13, 3) AS VARCHAR)
											END
										ELSE NULL
									END
								ELSE NULL
							END
						WHEN ASCII('E') THEN
							CASE CAST(SUBSTRING(hiCode, 2, 1) AS INTEGER)
								WHEN 1 THEN 
									CASE CAST(SUBSTRING(hiCode, 18, 1) AS VARCHAR)
										WHEN 'D' THEN CAST(SUBSTRING(hiCode, 19, 3) AS VARCHAR)
										ELSE NULL
									END
								ELSE NULL
							END
						WHEN ASCII('H') THEN 
							CASE CAST(SUBSTRING(hiCode, 2, 1) AS VARCHAR)
								WHEN 'D' THEN
									CAST(SUBSTRING(hiCode, 7, 3) AS VARCHAR)
								WHEN 'C' THEN
									CASE CAST(SUBSTRING(hiCode, 10, 1) AS INTEGER)
										WHEN 2 THEN CAST(SUBSTRING(hiCode, 11, 3) AS VARCHAR)
										ELSE NULL
									END
								ELSE NULL
							END
						WHEN ASCII('M') THEN
							CASE
								WHEN CAST(SUBSTRING(hiCode, 2, 3) AS VARCHAR) = 'CMT' THEN
									CASE CAST(SUBSTRING(hiCode, 8, 1) AS VARCHAR)
										WHEN 'D' THEN CAST(SUBSTRING(hiCode, 13, 3) AS VARCHAR)
										WHEN 'C' THEN
											CASE CAST(SUBSTRING(hiCode, 16, 1) AS INTEGER)
												WHEN 2 THEN CAST(SUBSTRING(hiCode, 17, 3) AS VARCHAR)
												WHEN 1 THEN CAST(SUBSTRING(hiCode, 13, 3) AS VARCHAR)
												ELSE NULL
											END
										ELSE NULL
									END
								ELSE NULL
							END								
						ELSE NULL
					END
	  ,[VAT Code] = CASE
						WHEN hiExClass IN (ASCII('I'), ASCII('O')) THEN
							CAST(SUBSTRING(hiCode, 2, 1)  AS VARCHAR)
						ELSE NULL
					END
	  ,[Stock Folio] =	CASE
							WHEN CAST(SUBSTRING(hiCode, 2, 3) AS VARCHAR) != 'CMT' THEN
								CASE  
									WHEN hiExCLass = ASCII('D') THEN
										CASE CAST(SUBSTRING(hiCode, 2, 1) AS VARCHAR)
											WHEN 'L' THEN CAST(CONVERT(VARBINARY(4), REVERSE(SUBSTRING(hiCode, 3, 4))) AS INTEGER)
											ELSE NULL
										END
									WHEN hiExCLass = ASCII('E') THEN
										CASE CAST(SUBSTRING(hiCode, 2, 1) AS INTEGER)
											WHEN 1 THEN CAST(CONVERT(VARBINARY(4), REVERSE(SUBSTRING(hiCode, 13, 4))) AS INTEGER)
											WHEN 2 THEN CAST(CONVERT(VARBINARY(4), REVERSE(SUBSTRING(hiCode, 13, 4))) AS INTEGER)
											ELSE NULL
										END
									WHEN hiExCLass IN (ASCII('G'), ASCII('M'), ASCII('P'), ASCII('X'), 239, 247, 236) THEN
										CASE CAST(SUBSTRING(hiCode, 2, 1) AS VARCHAR)
											WHEN 'L' THEN CAST(CONVERT(VARBINARY(4), REVERSE(SUBSTRING(hiCode, 3, 4))) AS INTEGER)
											ELSE CAST(CONVERT(VARBINARY(4), REVERSE(SUBSTRING(hiCode, 2, 4))) AS INTEGER)
										END
									ELSE NULL
								END
							ELSE NULL
						END
	  ,[Cust/Supp] = CASE 
						WHEN hiExClass = ASCII('E') THEN
							CASE CAST(SUBSTRING(hiCode, 2, 1) AS INTEGER)
								WHEN 1 THEN CAST(SUBSTRING(hiCode, 3, 6) AS VARCHAR)
								WHEN 2 THEN CAST(SUBSTRING(hiCode, 3, 6) AS VARCHAR)
								ELSE  CAST(SUBSTRING(hiCode, 2, 6) AS VARCHAR)
							END
						WHEN hiExClass IN (ASCII('U'), ASCII('V'), ASCII('W')) THEN 
							CAST(SUBSTRING(hiCode, 2, 6) AS VARCHAR)						
						ELSE NULL
					END
      ,[Location] = CASE
						WHEN CAST(SUBSTRING(hiCode, 2, 3) AS VARCHAR) != 'CMT' THEN
							CASE 
								WHEN hiExCLass IN (ASCII('D'), ASCII('G'), ASCII('M'), ASCII('P'), ASCII('X'), 239, 247, 236) THEN
									CAST(SUBSTRING(hiCode, 7, 3) AS VARCHAR)
								WHEN hiExClass = ASCII('E') THEN
									CASE CAST(SUBSTRING(hiCode, 2, 1) AS INTEGER)
										WHEN 2 THEN CAST(SUBSTRING(hiCode, 18, 3) AS VARCHAR)
										ELSE NULL
									END
								ELSE NULL
							END
						ELSE NULL
					END
      ,[Job Code] = CASE
						WHEN hiExCLass IN (ASCII('J'), ASCII('K'), ASCII('[')) THEN CAST(SUBSTRING(hiCode, 2, 10) AS VARCHAR)
						ELSE NULL
					END	
      ,[Analysis Code] = CASE
							WHEN hiExCLass IN (ASCII('J'), ASCII('K'), ASCII('[')) THEN CAST(CONVERT(VARBINARY(4), REVERSE(SUBSTRING(hiCode, 12, 4))) AS INTEGER)
							ELSE NULL
						 END
	  ,[Analysis] = CASE
						WHEN hiExCLass IN (ASCII('J'), ASCII('K'), ASCII('[')) THEN
							CASE CAST(CONVERT(VARBINARY(4), REVERSE(SUBSTRING(hiCode, 12, 4))) AS INTEGER)
								WHEN   5 THEN 'Sales Applications'
								WHEN  10 THEN 'Revenue'
								WHEN  14 THEN 'Sales Deductions'
								WHEN  20 THEN 'Labour (hours) or Overhead'
								WHEN  23 THEN 'Sub Labour'
								WHEN  30 THEN 'Direct Expenses 1 or Materials'
								WHEN  40 THEN 'Direct Expenses 2 or Labour'
								WHEN  50 THEN 'Stock Issues'
								WHEN  53 THEN 'Sub Materials'
								WHEN  60 THEN 'Overheads'
								WHEN  63 THEN 'Overheads 2'
								WHEN  67 THEN 'Purchase Deductions'
								WHEN  99 THEN 'Profit'
								WHEN 160 THEN 'Receipts'
								WHEN 170 THEN 'Work in Progress'
								WHEN 173 THEN 'Purchase Applications'
								WHEN 180 THEN 'Sales Retentions'
								WHEN 190 THEN 'Purchase Retentions'
								ELSE 'Link to Analysis Code Budget'
							END
						ELSE NULL
					END
	  
      ,[Employee Code] = CASE hiExCLass
							WHEN ASCII('\') THEN CAST(SUBSTRING(hiCode, 2, 6) AS VARCHAR)						 																
							ELSE NULL
  						 END
FROM [ZZZZ01].[HISTORY]
--WHERE hiExCLass = ASCII('M')