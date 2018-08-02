--/////////////////////////////////////////////////////////////////////////////
--// Filename		: isp_UpdateCategoryLevel.sql
--// Author		: 
--// Date		: 
--// Copyright Notice	: (c) 2015 Advanced Business Software & Solutions Ltd. All rights reserved.
--// Description	: SQL Script to add isp_UpdateCategoryLevel stored procedure
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	: File Creation
--//
--/////////////////////////////////////////////////////////////////////////////

-- Remove the existing script
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[isp_UpdateCategoryLevel]') AND type in (N'P', N'PC'))
  DROP PROCEDURE [!ActiveSchema!].[isp_UpdateCategoryLevel]
go
--
-- Updates Job Total Budgets based on the Analysis Code Budgets
-- 
-- Parameter: @iv_JobCode - 10 character Job/Contract Code
-- Usage: EXEC [!ActiveSchema!].isp_UpdateCategoryLevel 'OLY-STAGE1'
--

CREATE PROCEDURE [!ActiveSchema!].isp_UpdateCategoryLevel
               ( @iv_JobCode VARCHAR(10) = NULL )
AS
BEGIN

SET NOCOUNT ON;

-- Clear down existing budgets only if they have Analysis Code Budgets
UPDATE OrigData
   SET BRQty   = 0
     , BoQty   = 0
     , BRValue = 0
     , BoValue = 0
FROM   [!ActiveSchema!].JobTotalsBudget OrigData
WHERE (JobCode = @iv_JobCode
OR     @iv_JobCode IS NULL)
AND   EXISTS (SELECT TOP 1 1
              FROM   [!ActiveSchema!].AnalysisCodebudget ACB
			  WHERE  ACB.JobCode = OrigData.JobCode
			  AND    ACB.AnalHed = OrigData.Analhed)

-- Now update with the data from the Analysis Budgets
UPDATE OrigData
   SET BRQty   = NewData.NewBRQty
     , BoQty   = NewData.NewBoQty
     , BRValue = NewData.NewBrValue
     , BoValue = NewData.NewBoValue
     
FROM   [!ActiveSchema!].JobTotalsBudget OrigData
JOIN (SELECT ACB.JobCode
           , ACB.AnalHed
           , NewBoQty   = SUM(ACB.BoQty)
           , NewBRQty   = SUM(ACB.BRQty)
           , NewBoValue = SUM([!ActiveSchema!].ifn_CurrencyConversion(ACB.BoValue, ACB.JBudgetCurr, JTB.JBudgetCurr))
           , NewBrValue = SUM([!ActiveSchema!].ifn_CurrencyConversion(ACB.BrValue, ACB.JBudgetCurr, JTB.JBudgetCurr))
      FROM   [!ActiveSchema!].AnalysisCodeBudget ACB
      JOIN   [!ActiveSchema!].JobTotalsBudget    JTB ON ACB.JobCode = JTB.JobCode
                                    AND ACB.AnalHed = JTB.AnalHed
      GROUP BY ACB.JobCode
             , ACB.AnalHed) as NewData ON NewData.JobCode = OrigData.JobCode
                                      AND NewData.AnalHed = OrigData.AnalHed

WHERE  OrigData.JobCode = @iv_JobCode
OR    @iv_JobCode IS NULL
END

