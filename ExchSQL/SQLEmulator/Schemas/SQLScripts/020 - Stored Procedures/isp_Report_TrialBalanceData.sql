--/////////////////////////////////////////////////////////////////////////////
--// Filename    : isp_Report_TrialBalanceData.sql
--// Author    : 
--// Date    : 
--// Copyright Notice  : (c) 2015 Advanced Business Software & Solutions Ltd. All rights reserved.
--// Description  : SQL Script to add isp_Report_TrialBalanceData stored procedure
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//  1  : File Creation
--//  2  : Modiifed for 5 Revised Budgets - 5th May 2016
--//
--/////////////////////////////////////////////////////////////////////////////

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[isp_Report_TrialBalanceData]') AND type in (N'P', N'PC'))
  drop procedure [!ActiveSchema!].[isp_Report_TrialBalanceData]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [!ActiveSchema!].[isp_Report_TrialBalanceData]
               ( @intExchYear           INT
               , @intPeriod             INT
               , @bitIncludeActuals     BIT           = 1
               , @bitIncludeCommitted   BIT           = 1
               , @bitIncludeComparative BIT           = 0
               , @intCurrency           INT           = 0
               , @strCostCentre         VARCHAR(max)  = ''
               , @strDepartment         VARCHAR(max)  = ''
  )
AS
BEGIN

SET NOCOUNT ON;

--
-- Temporary table
-----------------------------------------------------------------------------------
-- Creating a temp table as going to build the data up in a number of passes for
-- several reasons. 
--
-- Firstly, the performance of the hiComputed = where clause increases from subsecond 
-- to 13 + seconds when wrapped in an OR which need to do to get either Actuals or Comitteds
-- or both. Doing in two passes is much much quicker.
--
-- Secondly, may need the YTD from a prior year. This isn't required for all report
-- variants and the extra logic to only provide it when required is very involved and
-- again drags performance down. Whilst doing as a seperate piece of SQL is less elegant
-- it does perform better
--
-- Thirdly, may need to loop around up to 4 times. Once for Actuals, once for Committed and 
-- then repeat for each to get prior year if Comparative. Needs to be done seperately to pull
-- through a null record for that year including a PreviousYear value specific to that year.

DECLARE @tblTemp TABLE
      ( glCode             INT
      , glName             VARCHAR(max)
      , glType             VARCHAR(1)
      , glCarryFwd         INT
      , glPage             BIT
      , glHierarchy        VARCHAR(max)
      , glHierarchyPadded  VARCHAR(max)
      , hiYear             INT
      , hiPeriod           INT
      , hiSales            FLOAT
      , hiPurchases        FLOAT
      , hiBudget           FLOAT
      , hiRevisedBudget1   FLOAT
      , hiRevisedBudget2   FLOAT
      , hiRevisedBudget3   FLOAT
      , hiRevisedBudget4   FLOAT
      , hiRevisedBudget5   FLOAT
      , hiYearPrevious     INT
      , IsCommitted        BIT          -- If Committed = 1, if Actual = 0
  )

--
-- Flow control variables and initialisation
--------------------------------------------

-- If we're doing Comparitive then do that in first pass
-- Comparative will always need a second pass for each of Committed and Actual
-- If we're getting Committed get them first, otherwise get Actuals

DECLARE @bitIsCommitted    AS BIT
      , @bitIsComparative  AS BIT
      , @bitContinue       AS BIT

IF @bitIncludeComparative = 1
  SET @bitIsComparative = 1
ELSE
  SET @bitIsComparative = 0
  
IF @bitIncludeCommitted = 0 
  SET @bitIsCommitted = 0
ELSE
  SET @bitIsCommitted = 1

--
-- Loop starts here
-------------------
-- Need to loop before the CTE again as no statements can appear between the CTE and its use in the select after it
SET @bitContinue = 1
WHILE @bitContinue = 1
BEGIN
;  
  --
  -- CTE to extract hierarchy and level value
  -------------------------------------------
  -- Note leading comma. All GL codes will have, and need, leading and trailing commas in GLHierarchy column
  -- for client side identification of a specific GL code to start and stop P&L section in report
  WITH GLCodes
     ( GLCode
     , GLParent
     , GLCarryFwd
     , GLHierarchy
     , GLHierarchyPadded
     )
  AS
     ( SELECT glCode
            , glParent
            , glCarryFwd      
            , GLHierarchy       = CAST(',' AS VARCHAR(max))
            , GLHierarchyPadded = CAST('' AS VARCHAR(max))
       FROM [!ActiveSchema!].NOMINAL n
       WHERE glParent = 0
       UNION ALL
       SELECT n1.glCode
            , n1.glParent
            , n1.glCarryFwd      
            , cast(GLHierarchy + cast(n1.glParent as VARCHAR) as VARCHAR(max)) + ','
            , cast(GLHierarchyPadded + right(replicate('0',11) + cast(n1.glParent as VARCHAR),11) as VARCHAR(max))
       FROM [!ActiveSchema!].NOMINAL n1
       INNER JOIN [!ActiveSchema!].NOMINAL n2 ON n1.glParent = n2.glCode
       INNER JOIN GLcodes gl ON n1.glParent = gl.GLCode
    )

  -- Get the appropriate records into temporary table
  INSERT INTO @tblTemp
  SELECT DISTINCT
         g.glCode
       , n.glName
       , n.glType
       , g.glCarryFwd
       , n.glPage
       , g.GLHierarchy
       , g.GLHierarchyPadded 
       , h.hiYear
       , h.hiPeriod
       , h.hiSales
       , h.hiPurchases
       , h.hiBudget
       , h.hiRevisedBudget1
       , h.hiRevisedBudget2
       , h.hiRevisedBudget3
       , h.hiRevisedBudget4
       , h.hiRevisedBudget5
       , hiYearPrevious = PreviousYear.hiYear
       , @bitIsCommitted  
  FROM   GLCodes g
  INNER JOIN [!ActiveSchema!].NOMINAL n ON g.GLCode = n.glCode
  LEFT JOIN [!ActiveSchema!].HISTORY_All h WITH (noexpand) ON h.hiExCLass      = ascii(n.glType)
                                                          AND h.hiCodeComputed = common.ifn_Report_TrialBalance_GetHiCodeComputedValue
                                                                                       ( g.GLCode
                                                                                       , @strCostCentre
                                                                                       , @strDepartment
                                                                                       , @bitIsCommitted       
                                                                                       )
                                                          AND h.hiCurrency  = @intCurrency 
                                                          AND h.hiYear      = @intExchYear - @bitIsComparative
                                                          AND h.hiPeriod   <= @intPeriod
  OUTER APPLY ( SELECT hiYear = max(h1.hiYear)
                FROM   [!ActiveSchema!].HISTORY_All h1 with (noexpand)
                WHERE  h1.hiExCLass      = ASCII(n.glType)
                AND    h1.hiCodeComputed = common.ifn_Report_TrialBalance_GetHiCodeComputedValue
                                                 ( g.GLCode
                                                 , @strCostCentre
                                                 , @strDepartment
                                                 , @bitIsCommitted
                                                 )      
                AND    h1.hiCurrency     = @intCurrency
                AND    h1.hiYear         < ISNULL(h.hiYear, @intExchYear - @bitIsComparative)
                AND    h1.hiPeriod       = 255
              ) AS PreviousYear

  --
  -- Flow control stuff, again
  -----------------------------
  -- Do we need to go around again?
  -- 
  -- If doing Comparative then do again for current year
  -- If not doing Comparative and just done Actuals then No as this is always done second
  -- If just done Committed then loop again if getting Actuals as well
  -- otherwise don't

  IF @bitIsComparative = 1
  BEGIN
    -- Loop around again for current year
    SET @bitIsComparative = 0
    SET @bitContinue = 1
  END
  ELSE
    IF @bitIsCommitted = 0
      SET @bitContinue = 0
    ELSE
      IF @bitIncludeActuals = 0
        SET @bitContinue = 0
      ELSE
      BEGIN
        SET @bitIsCommitted   = 0
        SET @bitIsComparative = @bitIncludeComparative  
      END

--
-- End of While Loop
--------------------
END

--
-- Now put the carry forwards in  
--------------------------------
INSERT INTO @tblTemp
SELECT DISTINCT 
       t.glCode
     , t.glName
     , t.glType
     , t.glCarryFwd
     , t.glPage
     , t.GLHierarchy
     , t.GLHierarchyPadded 
     , hst.hiYear
     , hst.hiPeriod
     , hst.hiSales
     , hst.hiPurchases
     , hst.hiBudget
     , hst.hiRevisedBudget1
     , hst.hiRevisedBudget2
     , hst.hiRevisedBudget3
     , hst.hiRevisedBudget4
     , hst.hiRevisedBudget5
     , null
     , t.IsCommitted 
FROM @tblTemp t
INNER JOIN [!ActiveSchema!].HISTORY_All hst WITH (NOEXPAND) ON hst.hiExCLass = ASCII(t.glType)
                                                           AND t.glType <> 'A'
                                                           AND hst.hiCodeComputed = common.ifn_Report_TrialBalance_GetHiCodeComputedValue
                                                                                          ( t.GLCode
                                                                                          , @strCostCentre
                                                                                          , @strDepartment
                                                                                          , t.IsCommitted 
                                                                                          )
                                                           AND hst.hiCurrency  = @intCurrency 
                                                           AND hst.hiYear    = t.hiYearPrevious
                                                           AND hst.hiPeriod  = 255  

--
-- All done. Return the data to the client
------------------------------------------
SELECT t.glCode
     , t.glName
     , t.glType
     , t.glCarryFwd
     , t.glPage
     , t.glHierarchy
     , t.hiYear
     , t.hiPeriod
     , t.hiSales
     , t.hiPurchases
     , t.hiBudget
     , t.hiRevisedBudget1
     , t.hiRevisedBudget2
     , t.hiRevisedBudget3
     , t.hiRevisedBudget4
     , t.hiRevisedBudget5
     , t.IsCommitted
FROM  @tblTemp t

ORDER BY t.GLHierarchyPadded + right(replicate('0',11) + cast(t.glCode as VARCHAR),11)
       , t.hiYear
       , t.hiPeriod
       , t.IsCommitted 

END
GO

