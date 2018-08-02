--/////////////////////////////////////////////////////////////////////////////
--// Filename    : isp_UpdateCategoryLevel_PeriodBudgets.sql
--// Author    : 
--// Date    : 
--// Copyright Notice  : (c) 2015 Advanced Business Software & Solutions Ltd. All rights reserved.
--// Description  : SQL Script to add isp_UpdateCategoryLevel_PeriodBudgets stored procedure
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//  1  : File Creation
--//  2  : Modified for 5 revised budgets - 5th May 2016
--//
--/////////////////////////////////////////////////////////////////////////////

-- Remove the existing script
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[isp_UpdateCategoryLevel_PeriodBudgets]') AND type in (N'P', N'PC'))
  DROP PROCEDURE [!ActiveSchema!].[isp_UpdateCategoryLevel_PeriodBudgets]
GO
--
-- Updates History Job Total Budgets based on the History Analysis Code Budgets
-- 
-- Parameter: @iv_JobCode - 10 character Job/Contract Code
--          : @iv_HistoryYear = Exchequer History Year, e.g. 110 (2010)
-- Usage: EXEC [!ActiveSchema!].isp_UpdateCategoryLevel_PeriodBudgets 'OLY-STAGE1', 110
--

CREATE PROCEDURE [!ActiveSchema!].isp_UpdateCategoryLevel_PeriodBudgets
               (@iv_JobCode     VARCHAR(10) 
              , @iv_HistoryYear INT)
AS 
BEGIN

SET NOCOUNT ON;

/* Add any parent rows that may be missing from History */

INSERT INTO [!ActiveSchema!].HISTORY
          ( hiCode
          , hiExClass
          , hiCurrency
          , hiYear
          , hiPeriod
          , hiPurchases
          , hiSales
          , hiBudget
          , hiCleared
          , hiRevisedBudget1
          , hiValue1
          , hiValue2
          , hiValue3
          , hiRevisedBudget2
          , hiRevisedBudget3
          , hiRevisedBudget4
          , hiRevisedBudget5
          , hiSpareV
          )

SELECT ParentHistoryCode
     , HiExClass
     , hiCurrency
     , hiYear
     , hiPeriod
     , 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ,0
FROM (  
      SELECT DISTINCT
             JobCode           = ACB1.JobCode 
           , HiExClass         = H1.hiExClass
           , HistFolio         = JTB1.HistFolio
           , hiCurrency        = ISNULL(H1.hiCurrency,0)
           , hiYear            = ISNULL(H1.hiYear,0)
           , hiPeriod          = ISNULL(H1.hiPeriod,0)
           , ParentHistoryCode = 0x14
                               + CAST(RTRIM(ACB1.JobCode) + SPACE(10 - LEN(ACB1.JobCode)) as BINARY(10)) 
                               + SUBSTRING(CAST((JTB1.HistFolio) AS BINARY(4)), 4,1) 
                               + SUBSTRING(CAST((JTB1.HistFolio) AS BINARY(4)), 3,1) 
                               + SUBSTRING(CAST((JTB1.HistFolio) AS BINARY(4)), 2,1) 
                               + SUBSTRING(CAST((JTB1.HistFolio) AS BINARY(4)), 1,1) + 0x202020202020
           , HistoryPositionId = [!ActiveSchema!].ifn_GetHistoryPositionId((H1.hiExClass)
                                                               , 0x14 + CAST(RTRIM(ACB1.JobCode) + SPACE(10 - LEN(ACB1.JobCode)) as BINARY(10)) 
                                                               + SUBSTRING(CAST((JTB1.HistFolio) AS BINARY(4)), 4,1) 
                                                               + SUBSTRING(CAST((JTB1.HistFolio) AS BINARY(4)), 3,1) 
                                                               + SUBSTRING(CAST((JTB1.HistFolio) AS BINARY(4)), 2,1) 
                                                               + SUBSTRING(CAST((JTB1.HistFolio) AS BINARY(4)), 1,1) + 0x202020202020
                                                               , ISNULL(H1.hiCurrency,0)
                                                               , ISNULL(H1.hiYear,0)
                                                               , ISNULL(H1.hiPeriod,0) )
      FROM  [!ActiveSchema!].AnalysisCodeBudget ACB1 
      JOIN  [!ActiveSchema!].JobTotalsBudget    JTB1 ON JTB1.JobCode = ACB1.JobCode
                                          AND JTB1.AnalHed = ACB1.AnalHed
      LEFT JOIN [!ActiveSchema!].HISTORY H1 (NOLOCK) ON ACB1.JobCode   = CAST(SUBSTRING(hiCode, 2, 10) AS VARCHAR(10))
                                          AND ACB1.HistFolio = CAST(CONVERT(VARBINARY(4), REVERSE(SUBSTRING(hiCode,12,4))) AS INTEGER)
                                          AND CHAR(H1.hiExCLass) IN ( 'J', 'K')
                                          AND   H1.hiYear = @iv_HistoryYear
      WHERE ACB1.JobCode = @iv_JobCode) AS InsertData
WHERE HistoryPositionId = 0

/* -- For Debug Purposes 
SELECT JobCode   = CAST(SUBSTRING(hiCode, 2, 10) AS VARCHAR(10))
     , HistFolio = CAST(CONVERT(VARBINARY(4), REVERSE(SUBSTRING(hiCode,12,4))) AS INTEGER) 
     , hiCurrency
     , hiYear
     , hiPeriod
     , hiBudget
     , hiRevisedBudget1
     , hiRevisedBudget2
     , hiRevisedBudget3
     , hiRevisedBudget4
     , hiRevisedBudget5
     , hiValue1
     , hiValue2
*/

-- Reset Headers to Zero

UPDATE H
   SET hiBudget         = 0
     , hiRevisedBudget1 = 0
     , hiRevisedBudget2 = 0
     , hiRevisedBudget3 = 0
     , hiRevisedBudget4 = 0
     , hiRevisedBudget5 = 0
     , hiValue1         = 0
     , hiValue2         = 0
     
FROM  [!ActiveSchema!].HISTORY H
JOIN  [!ActiveSchema!].JobTotalsBudget    JTB ON JTB.JobCode   = CAST(SUBSTRING(hiCode, 2, 10) AS VARCHAR(10))
                                   AND JTB.HistFolio = CAST(CONVERT(VARBINARY(4), REVERSE(SUBSTRING(hiCode,12,4))) AS INTEGER)
WHERE CHAR(hiExCLass) in ( 'J', 'K')
AND   CAST(SUBSTRING(hiCode, 2, 10) AS VARCHAR(10)) = @iv_JobCode
AND   hiYear = @iv_HistoryYear
AND   EXISTS (SELECT TOP 1 1
              FROM  [!ActiveSchema!].AnalysisCodeBudget ACB
              WHERE JTB.JobCode = ACB.JobCode
                AND JTB.AnalHed = ACB.AnalHed)

-- Reset Headers to Sum of Analysis children
UPDATE H
   SET hiBudget         = UpdateData.NewBudget
     , hiRevisedBudget1 = UpdateData.NewRevisedBudget1
     , hiRevisedBudget2 = UpdateData.NewRevisedBudget2
     , hiRevisedBudget3 = UpdateData.NewRevisedBudget3
     , hiRevisedBudget4 = UpdateData.NewRevisedBudget4
     , hiRevisedBudget5 = UpdateData.NewRevisedBudget5
     , hiValue1         = UpdateData.NewValue1
     , hiValue2         = UpdateData.NewValue2

FROM [!ActiveSchema!].History H
JOIN (SELECT JobCode = CAST(SUBSTRING(hiCode, 2, 10) AS VARCHAR(10))
     , HistFolio = CAST(CONVERT(VARBINARY(4), REVERSE(SUBSTRING(hiCode,12,4))) AS INTEGER)
     , H.hiCurrency
     , H.hiYear
     , H.hiPeriod
     , OldBudget         = SUM(hiBudget)
     , NewBudget         = SUM(NewData.Budget)
     , OldRevisedBudget1 = SUM(hiRevisedBudget1)
     , NewRevisedBudget1 = SUM(NewData.RevisedBudget1)
     , OldRevisedBudget2 = SUM(hiRevisedBudget2)
     , NewRevisedBudget2 = SUM(NewData.RevisedBudget2)
     , OldRevisedBudget3 = SUM(hiRevisedBudget3)
     , NewRevisedBudget3 = SUM(NewData.RevisedBudget3)
     , OldRevisedBudget4 = SUM(hiRevisedBudget4)
     , NewRevisedBudget4 = SUM(NewData.RevisedBudget4)
     , OldRevisedBudget5 = SUM(hiRevisedBudget5)
     , NewRevisedBudget5 = SUM(NewData.RevisedBudget5)
     , OldValue1         = SUM(hiValue1)
     , NewValue1         = SUM(NewData.Value1)
     , OldValue2         = SUM(hiValue2)
     , NewValue2         = SUM(NewData.Value2)
FROM [!ActiveSchema!].History H
JOIN  [!ActiveSchema!].JobTotalsBudget    JTB ON JTB.JobCode   = CAST(SUBSTRING(hiCode, 2, 10) AS VARCHAR(10))
                                   AND JTB.HistFolio = CAST(CONVERT(VARBINARY(4), REVERSE(SUBSTRING(hiCode,12,4))) AS INTEGER)
JOIN [!ActiveSchema!].AnalysisCodeBudget  ACB ON  JTB.JobCode = ACB.JobCode
                                   AND JTB.AnalHed  = ACB.AnalHed
JOIN (SELECT JobCode   = CAST(SUBSTRING(H1.hiCode, 2, 10) AS VARCHAR(10))
           , HistFolio = CAST(CONVERT(VARBINARY(4), REVERSE(SUBSTRING(H1.hiCode,12,4))) AS INTEGER) 
           , H1.hiCurrency
           , H1.hiYear
           , H1.hiPeriod
           , Budget         = SUM(H1.hiBudget)
           , RevisedBudget1 = SUM(H1.hiRevisedBudget1)
           , RevisedBudget2 = SUM(H1.hiRevisedBudget2)
           , RevisedBudget3 = SUM(H1.hiRevisedBudget3)
           , RevisedBudget4 = SUM(H1.hiRevisedBudget4)
           , RevisedBudget5 = SUM(H1.hiRevisedBudget5)
           , Value1         = SUM(H1.hiValue1)
           , Value2         = SUM(H1.hiValue2)
     
      FROM  [!ActiveSchema!].HISTORY H1
      JOIN  [!ActiveSchema!].AnalysisCodeBudget ACB1 ON ACB1.JobCode = CAST(SUBSTRING(hiCode, 2, 10) AS VARCHAR(10))
                                         AND ACB1.HistFolio = CAST(CONVERT(VARBINARY(4), REVERSE(SUBSTRING(hiCode,12,4))) AS INTEGER)
      JOIN  [!ActiveSchema!].JobTotalsBudget    JTB1 ON JTB1.JobCode   = ACB1.JobCode
                                         AND JTB1.AnalHed = ACB1.AnalHed
      WHERE CHAR(H1.hiExCLass) in ( 'J', 'K')
      AND   CAST(SUBSTRING(H1.hiCode, 2, 10) AS VARCHAR(10)) = @iv_JobCode
      AND   H1.hiYear = @iv_HistoryYear

      GROUP BY CAST(SUBSTRING(H1.hiCode, 2, 10) AS VARCHAR(10))
             , CAST(CONVERT(VARBINARY(4), REVERSE(SUBSTRING(H1.hiCode,12,4))) AS INTEGER) 
             , H1.hiCurrency
             , H1.hiYear
             , H1.hiPeriod) AS NewData ON NewData.JobCode   = CAST(SUBSTRING(hiCode, 2, 10) AS VARCHAR(10))
                                   AND NewData.HistFolio = ACB.HistFolio
                                   AND JTB.HistFolio     = CAST(CONVERT(VARBINARY(4), REVERSE(SUBSTRING(hiCode,12,4))) AS INTEGER) 
                                   AND NewData.hiYear    = H.hiYear
                                   AND NewData.hiPeriod  = H.hiPeriod
                                   AND NewData.hiCurrency = H.hiCurrency
                                   
WHERE CHAR(hiExCLass) in ( 'J', 'K')
AND   CAST(SUBSTRING(hiCode, 2, 10) AS VARCHAR(10)) = @iv_JobCode
AND   H.hiYear = @iv_HistoryYear

GROUP BY CAST(SUBSTRING(hiCode, 2, 10) AS VARCHAR(10))
     , CAST(CONVERT(VARBINARY(4), REVERSE(SUBSTRING(hiCode,12,4))) AS INTEGER)
     , H.hiCurrency
     , H.hiYear
     , H.hiPeriod) AS UpdateData ON CAST(SUBSTRING(H.hiCode, 2, 10) AS VARCHAR(10)) = UpdateData.JobCode
                                AND CAST(CONVERT(VARBINARY(4), REVERSE(SUBSTRING(H.hiCode,12,4))) AS INTEGER) = UpdateData.HistFolio
                                AND H.hiYear     = UpdateData.hiYear
                                AND H.hiPeriod   = UpdateData.hiPeriod
                                AND H.hiCurrency = UpdateData.hiCurrency

SET NOCOUNT ON;

END

GO


