/****** Object:  View [!ActiveSchema!].[evw_HISTORY]    Script Date: 12/12/2014 11:10:13 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[evw_HISTORY]'))
DROP VIEW [!ActiveSchema!].[evw_HISTORY]
GO

CREATE VIEW [!ActiveSchema!].[evw_History]
AS
SELECT HistoryPositionId         = PositionId
     , HistoryClassificationId   = hiExCLass
     , HistoryClassificationCode
     , HistoryCode               = HiCode
     , CurrencyId                = H.hiCurrency
     , CurrencyCode              = CONVERT(VARCHAR(50), hiCurrency)
     , ExchequerYear             = H.hiYear
     , ExchequerPeriod           = H.hiPeriod
     , HistoryYear               = H.hiYear + 1900
     , HistoryPeriod             = H.hiPeriod                                 
     , HistoryPeriodKey          = (((H.hiYear + 1900) * 1000) +  H.hiPeriod)
     , IsCommitment
     , IsTotal                   = CONVERT(BIT, 0)
     , CostCentreDepartmentFlag  = CASE
                                   WHEN HistoryClassificationCode IN ('A','B','C','E','H','M')
                                   THEN CASE
                                        WHEN HistoryClassificationCode = 'E' AND ASCII(HistoryCode_2_1) = 1 THEN HistoryCode_18_1
                                        WHEN HistoryClassificationCode <> 'E' AND IsCommitment = 1 AND HistoryCode_13_3 <> '' THEN HistoryCode_8_1
                                        WHEN HistoryClassificationCode NOT IN ('E','M') AND IsCommitment = 0 AND HistoryCode_7_3 <> '' THEN HistoryCode_2_1
                                        ELSE NULL
                                        END
                                   ELSE NULL
                                   END
     , VATRateCode               = CONVERT(VARCHAR(50), CASE 
			                                WHEN HistoryClassificationCode IN ('I','O') THEN HistoryCode_2_1
							ELSE NULL
                                                        END)
     , NominalCode               = CASE
                                   WHEN HistoryClassificationCode IN ('U','V','W') THEN CASE
                                                                                        WHEN HistoryCode_8_4 = 538976288 THEN NULL
                                                                                        ELSE HistoryCode_8_4
                                                                                        END
                                   WHEN HistoryClassificationCode IN ('A','B','C','H','F')
                                   THEN CASE
                                        WHEN IsCommitment = 1 AND HistoryCode_13_3 <> '' THEN HistoryCode_9_4
                                        WHEN IsCommitment = 1 THEN HistoryCode_8_4
                                        WHEN HistoryCode_7_3 <> '' THEN HistoryCode_3_4
                                        ELSE HistoryCode_2_4
                                        END
                                   WHEN HistoryClassificationCode = 'M' 
                                   THEN CASE
                                        WHEN IsCommitment = 1 AND HistoryCode_13_3 <> '' THEN HistoryCode_9_4
                                        WHEN IsCommitment = 1 THEN HistoryCode_8_4
                                        ELSE NULL
                                        END
                                   ELSE NULL
                                   END

     , CostCentreCode            = CONVERT(VARCHAR(50), CASE
                                                        WHEN HistoryClassificationCode IN ('A','B','C','H','M')
                                                        THEN CASE
                                                             WHEN IsCommitment = 1
                                                              AND HistoryCode_17_3 <> '' 
                                                              AND HistoryCode_8_1 =  'D' THEN HistoryCode_17_3
                                                             WHEN IsCommitment = 1
                                                              AND HistoryCode_13_3 <> ''
                                                              AND HistoryCode_8_1 = 'C' THEN HistoryCode_13_3
                                                             WHEN IsCommitment = 0
                                                              AND HistoryCode_11_3 <> '' 
                                                              AND HistoryCode_2_1 =  'D' THEN HistoryCode_11_3
                                                             WHEN IsCommitment = 0
                                                              AND HistoryCode_7_3 <> ''
                                                              AND HistoryCode_2_1 =  'C' THEN HistoryCode_7_3
                                                             ELSE NULL
                                                             END
                                                        WHEN HistoryClassificationCode = 'E' AND ASCII(HistoryCode_2_1) = 1 AND HistoryCode_18_1 = 'C' THEN HistoryCode_19_3
                                                        ELSE NULL
                                                        END)
                                 
     , DepartmentCode            = CONVERT(VARCHAR(50), CASE
                                                        WHEN HistoryClassificationCode IN ('A','B','C','H','M')
                                                        THEN CASE
                                                             WHEN IsCommitment = 1
                                                              AND HistoryCode_17_3 <> '' 
                                                              AND HistoryCode_8_1 =  'C' THEN HistoryCode_17_3
                                                             WHEN IsCommitment = 1 
                                                              AND HistoryCode_13_3 <> ''
                                                              AND HistoryCode_8_1 =  'D' THEN HistoryCode_13_3
                                                             WHEN IsCommitment = 0
                                                              AND HistoryCode_11_3 <> '' 
                                                              AND HistoryCode_2_1 =  'C' THEN HistoryCode_11_3
                                                             WHEN IsCommitment = 0
                                                              AND HistoryCode_7_3 <> ''
                                                              AND HistoryCode_2_1 =  'D' THEN HistoryCode_7_3
                                                             ELSE NULL
                                                             END
                                                         WHEN HistoryClassificationCode = 'E' AND ASCII(HistoryCode_2_1) = 1 AND HistoryCode_18_1 = 'D' THEN HistoryCode_19_3
                                                         ELSE NULL
                                                         END)
     , TraderCode                 = CONVERT(VARCHAR(50), CASE
                                                         WHEN HistoryClassificationCode IN ('E','U','V','W')
                                                         THEN CASE
                                                              WHEN HistoryCode_18_1 <> '' THEN HistoryCode_3_6
                                                              ELSE HistoryCode_2_6
                                                              END
                                                         ELSE NULL
                                                         END)
     , JobCode                   = CASE
                                   WHEN HistoryClassificationCode IN ('J', 'K', '[') THEN HistoryCode_2_10
                                   ELSE NULL
                                   END
     , AnalysisHistoryId         = CASE
                                   WHEN HistoryClassificationCode IN ('J', 'K', '[') THEN HistoryCode_12_4
                                   ELSE NULL
                                   END
     , EmployeeCode              = CASE
                                   WHEN HistoryClassificationCode = '\' THEN HistoryCode_2_6
								   ELSE NULL
                                   END
     , StockFolioNumber          = CONVERT(INT, CASE
                                                WHEN HistoryClassificationCode IN ('D', 'G', 'P', 'X', '236', '239', '247') AND HistoryCode_2_1 = 'L' THEN HistoryCode_3_4
                                                WHEN HistoryClassificationCode = 'M' AND IsCommitment = 0 AND HistoryCode_2_1 = 'L' THEN HistoryCode_3_4
                                                WHEN HistoryClassificationCode IN ('D', 'G', 'P', 'X', '236', '239', '247') THEN HistoryCode_2_4
                                                WHEN HistoryClassificationCode = 'M' AND IsCommitment = 0 THEN HistoryCode_2_4
                                                WHEN HistoryClassificationCode = 'E' THEN CASE
                                                                                          WHEN HistoryCode_18_1 <> '' THEN HistoryCode_13_4
                                                                                          ELSE HistoryCode_12_4
                                                                                          END
                                                ELSE NULL
                                                END)
     , LocationCode              = CONVERT(VARCHAR(50), CASE
                                                        WHEN HistoryClassificationCode IN ('D', 'G', 'P', 'X', '236', '239', '247') AND HistoryCode_2_1 = 'L' THEN HistoryCode_7_3
                                                        WHEN HistoryClassificationCode = 'M' AND IsCommitment = 0 AND HistoryCode_2_1 = 'L' THEN HistoryCode_7_3
                                                        WHEN HistoryClassificationCode = 'E' AND ASCII(HistoryCode_2_1) = 2 THEN HistoryCode_18_3
                                                        ELSE NULL
                                                        END)
     , SalesAmount               = H.hiSales
     , PurchaseAmount            = H.hiPurchases
     , OriginalBudgetAmount      = H.hiBudget
     , ClearedBalance            = H.hiCleared
     , RevisedBudgetAmount1      = H.hiRevisedBudget1
     , RevisedBudgetAmount2      = H.hiRevisedBudget2
     , RevisedBudgetAmount3      = H.hiRevisedBudget3
     , RevisedBudgetAmount4      = H.hiRevisedBudget4
     , RevisedBudgetAmount5      = H.hiRevisedBudget5
     , Value1Amount              = H.hiValue1
     , Value2Amount              = H.hiValue2
     , Value3Amount              = H.hiValue3
     , BalanceAmount             = H.hiPurchases - H.hiSales
                                                         
FROM !ActiveSchema!.HISTORY H

CROSS APPLY ( VALUES ( ( CASE 
                         WHEN hiExclass < 200 THEN CONVERT(VARCHAR(3), CHAR(hiExClass))
                         ELSE CONVERT(VARCHAR(3), hiExClass)
                         END )
                     , ( CAST(SUBSTRING(hiCode, 2, 1) AS VARCHAR(1)))
                     , ( CAST(CONVERT(VARBINARY(max), REVERSE(SUBSTRING(CONVERT(VARBINARY(max), hiCode),2,4))) AS INTEGER))
                     , ( CAST(SUBSTRING(hiCode, 2, 6) AS VARCHAR(6)) )
                     , ( CAST(SUBSTRING(hiCode, 2, 10) AS VARCHAR(10)) )
                     , ( CAST(CONVERT(VARBINARY(max), REVERSE(SUBSTRING(CONVERT(VARBINARY(max), hiCode),3,4))) AS INTEGER) )
                     , ( CAST(SUBSTRING(hiCode, 3, 6) AS VARCHAR(6)) )
                     , ( CAST(SUBSTRING(hiCode, 7, 3) AS VARCHAR(3)) )
                     , ( CAST(SUBSTRING(hiCode, 8, 1) AS VARCHAR(1)) )
                     , ( CAST(CONVERT(VARBINARY(max), REVERSE(SUBSTRING(CONVERT(VARBINARY(max), hiCode),8,4))) AS INTEGER) )
                     , ( CAST(CONVERT(VARBINARY(max), REVERSE(SUBSTRING(CONVERT(VARBINARY(max), hiCode),9,4))) AS INTEGER) )
                     , ( CAST(SUBSTRING(hiCode, 10, 1) AS VARCHAR(1)) )
                     , ( CAST(SUBSTRING(hiCode, 11, 3) AS VARCHAR(3)) )
                     , ( CAST(CONVERT(VARBINARY(max), REVERSE(SUBSTRING(CONVERT(VARBINARY(max), hiCode),12,4))) AS INTEGER) )
                     , ( CAST(SUBSTRING(hiCode, 13, 3) AS VARCHAR(3)) )
                     , ( CAST(CONVERT(VARBINARY(max), REVERSE(SUBSTRING(CONVERT(VARBINARY(max), hiCode),13,4))) AS INTEGER) )
                     , ( CAST(SUBSTRING(hiCode, 17, 3) AS VARCHAR(3)) )
                     , ( CAST(SUBSTRING(hiCode, 18, 1) AS VARCHAR(1)) )
                     , ( CAST(SUBSTRING(hiCode, 18, 3) AS VARCHAR(3)) )
                     , ( CAST(SUBSTRING(hiCode, 19, 3) AS VARCHAR(3)) )
                     , ( CASE
                         WHEN CHAR(hiExClass) IN ('A','B','C','H','M') AND CAST(SUBSTRING(hiCode, 2, 6) AS VARCHAR(6)) = ('CMT' + CHAR(2) + CHAR(2) + '!') THEN 1
                         ELSE 0
                         END )
                     )
            ) HCode ( HistoryClassificationCode
                    , HistoryCode_2_1
                    , HistoryCode_2_4
                    , HistoryCode_2_6
                    , HistoryCode_2_10
                    , HistoryCode_3_4
                    , HistoryCode_3_6
                    , HistoryCode_7_3
                    , HistoryCode_8_1
                    , HistoryCode_8_4
                    , HistoryCode_9_4
                    , HistoryCode_10_1
                    , HistoryCode_11_3
                    , HistoryCode_12_4
                    , HistoryCode_13_3
                    , HistoryCode_13_4
                    , HistoryCode_17_3
                    , HistoryCode_18_1
                    , HistoryCode_18_3
                    , HistoryCode_19_3
                    , IsCommitment
                    )

GO


