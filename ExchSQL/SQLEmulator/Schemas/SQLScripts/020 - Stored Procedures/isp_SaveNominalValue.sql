--/////////////////////////////////////////////////////////////////////////////
--// Filename         : isp_SaveNominalValue.sql
--// Author           : James Waygood, Chris Sandow
--// Date             : 12 February 2013
--// Copyright Notice : (c) 2015 Advanced Business Software & Solutions Ltd. All rights reserved.
--// Description      : SQL Script to add isp_SaveNominalValue stored procedure.
--//                    Used to save a GL Codes History Budget Value for a specified Period
--// Execute : EXEC [!ActiveSchema!].[isp_SaveNominalValue] (1, 0, 2010, 2011, 1, 1, '', 5000)
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//  1 : 12 February 2013 : File Creation
--//  2 : 19 June 2013 : Amended
--//  3 : 04 May 2016 : Amend for 5 Revised Budgets - Glen Jones
--//
--/////////////////////////////////////////////////////////////////////////////

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[isp_SaveNominalValue]') AND type in (N'P', N'PC'))
DROP PROCEDURE [!ActiveSchema!].[isp_SaveNominalValue]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [!ActiveSchema!].[isp_SaveNominalValue]
               ( @SaveValue      int           -- 1=Budget, 2=RevisedBudget1, 2=RevisedBudget3, 4=RevisedBudget3, 5=RevisedBudget4, 6=RevisedBudget5
               , @SubType        varchar(1)    -- 0=GL, 1=GL/Cost Centre, 2=GL/Department, 3=GL/CC/Department
               , @GLCode         int
               , @Year           int
               , @Period         int
               , @Currency       int   
               , @CCDep          varchar(6)   
               , @NewBudget      float
               )
AS

BEGIN

  SET NOCOUNT ON

  -- Declare and initialise variables
  DECLARE @ReturnCode          int
        , @SetValue            int
        , @TheYear             int
        , @ThePeriod           int
        , @TheCcy              int
        , @NomCode             int
        , @NomCC               varchar(3)
        , @NomDept             varchar(3)
        , @NomCDType           varchar(1)
        , @NewValue            float
        , @ChkNomCode          int
        , @ChkCCDept           char(3)
        , @CCDept_BOff         char(3)
        , @CCDept_BOn          char(3)
        , @CalcCCDepKey        char(7)
        , @CalcDepCCKey        char(7)
        , @Key                 binary(21)
        , @DepCCKey            binary(21)
        , @CalcCCKeyHistP      binary(13)
        , @CalcDepKeyHistP     binary(13)
        , @NomBIN              binary(4)
        , @NomBINRev           binary(4)
        , @CDFlag              char(1)
        , @NomType             char(1)
        , @YTDPer              int
        , @YTDPosId            int
        , @YTDDepPosId         int
        , @YTDCreated          bit
        , @BudPosId            int
        , @BudDepPosId         int
        , @LastSales           float
        , @LastPurchase        float
        , @LastCleared         float
    
  SELECT @ReturnCode          = 0
       , @SetValue            = @SaveValue
       , @TheYear             = @Year
       , @ThePeriod           = @Period
       , @TheCcy              = @Currency
       , @NomCode             = @GLCode
       , @NomCC               = ''
       , @NomDept             = ''
       , @NomCDType           = ''
       , @NewValue            = @NewBudget
       , @ChkCCDept           = '   '
       , @ChkNOMCode          = 0
       , @CCDept_BOff         = '   '
       , @CCDept_BOn          = '   '
       , @CalcCCDepKey        = '       '
       , @CalcDepCCKey        = '       '
       , @Key                 = 0x2020202020202020202020202020202020202020
       , @DepCCKey            = 0x2020202020202020202020202020202020202020
       , @CalcCCKeyHistP      = 0x00
       , @CalcDepKeyHistP     = 0x00
       , @NOMBin              = 0x00000000
       , @NOMBinRev           = 0x00000000
       , @CDFlag              = ' '
       , @NomType             = ''
       , @YTDPer              = 0
       , @YTDPosId            = 0
       , @YTDDepPosId         = 0
       , @YTDCreated          = 0
       , @BudPosId            = 0
       , @BudDepPosId         = 0
       , @LastSales           = 0
       , @LastPurchase        = 0
       , @LastCleared         = 0
    
  -- Check if valid GL Code
  SELECT @ChkNomCode = glCode
       , @NomType    = glType 
  FROM [!ActiveSchema!].[NOMINAL]
  WHERE @NomCode = glCode
    
  IF @ChkNomCode <> @NomCode
  BEGIN
    SET @ReturnCode = 100000511        -- Invalid Nominal Code
  END

  SET @NomCDType = CASE @SubType
                   WHEN 1 THEN 'C'
                   WHEN 2 THEN 'D'
                   WHEN 3 THEN 'K'
                   ELSE 'N'
                   END
    
  IF @NomCDType = 'C'
    SET @NomCC = SUBSTRING(@CCDep,1,3) 
  ELSE 
    IF @NomCDType = 'D'
      SET @NomDept = SUBSTRING(@CCDep,1,3) 
    ELSE 
      IF @NomCDType = 'K'
      BEGIN
         SET @NomCC   = SUBSTRING(@CCDep, 1, 3)
         SET @NomDept = SUBSTRING(@CCDep, 4, 3)
      END            
    
  IF @ReturnCode = 0
  BEGIN
    
    -- Check if valid Cost Centre
    IF @NomCDType IN ('C','K')
    BEGIN
      SELECT @ChkCCDept = EXCHQCHKcode1Trans1
      FROM [!ActiveSchema!].[EXCHQCHK]
      WHERE RecPfix             = 'C' 
      AND   SubType             = 67 
      AND   EXCHQCHKcode1Trans1 = @NomCC

      IF @ChkCCDept <> @NomCC
      BEGIN
        SET @ReturnCode    =    100000519        -- Invalid Cost Centre
      END
    END
        
    -- Check if valid Department
    IF @NomCDType IN ('D','K') AND @ReturnCode = 0
    BEGIN
      SELECT @ChkCCDept = EXCHQCHKcode1Trans1
      FROM [!ActiveSchema!].[EXCHQCHK]
      WHERE RecPfix = 'C' 
      AND   SubType = 68 
      AND   EXCHQCHKcode1Trans1 = @NomDept

      IF @ChkCCDept <> @NomDept
      BEGIN
        SET @ReturnCode    =    100000520        -- Invalid Department
      END
    END
  END

  IF (@ThePeriod <= 0 OR @ThePeriod > 99) AND @ReturnCode = 0
    SET @ReturnCode    =    100000513        -- Invalid Period

  IF (@TheYear <= 1900 OR @TheYear > 2100) AND @ReturnCode = 0
    SET @ReturnCode    =    100000512        -- Invalid Year
  ELSE IF @TheYear > 1900 AND @TheYear < 2100
       BEGIN
         SELECT @TheYear = @TheYear - 1900
       END
    
  -- Build Search Key
  IF @ReturnCode = 0
  BEGIN
    -- CalcCCDepKey
    IF @NOMCDType = 'D' AND LEN(RTRIM(@NomDept )) <> 0
    BEGIN
      SET @CalcCCDepKey = @NomDept
      SET @CDFlag = 'D'
    END
    ELSE IF @NOMCDType = 'C' AND LEN(RTRIM(@NomCC)) <> 0
         BEGIN
           SET @CalcCCDepKey = @NomCC
           SET @CDFlag = 'C'
         END
    ELSE IF @NOMCDType = 'K' AND LEN(RTRIM(@NomCC)) <> 0 AND LEN(RTRIM(@NomDept)) <> 0
         BEGIN
           SET @CalcCCDepKey = (@NomCC) + CHAR(2) + (@NomDept)
           SET @CalcDepCCKey = (@NomDept) + CHAR(1) + (@NomCC)
           SET @CDFlag = 'C'
         END
    ELSE
    BEGIN
      SET @CalcCCDepKey = '       '
    END
        
    -- Build @CalcCCKeyHistP -- NomCode, IsCC, NomCCDep
    SET @NOMBin = CAST(@NomCode AS BINARY(4))
        
    SET @NomBinRev = CAST(REVERSE(CAST(@NOMBin AS CHAR(4))) as BINARY(4))
        
    IF @CDFlag = ' '
    BEGIN
      SET @CalcCCKeyHistP = 0x14 + @NomBinRev +
                            CAST(@CalcCCDepKey AS BINARY(7)) + 
                            CAST(' ' AS BINARY(1))
    END
    ELSE
    BEGIN
      SET @CalcCCKeyHistP = 0x14 + CAST(@CDFlag AS BINARY(1)) + @NomBinRev +
                                   CAST(@CalcCCDepKey AS BINARY(7))
      IF @NomCDType = 'K'
        SET @CalcDepKeyHistP = 0x1444 + @NomBinRev +
                               CAST(@CalcDepCCKey AS BINARY(7))
    END
        
    SET @Key = @CalcCCKeyHistP + 
               CAST(SPACE(21 - LEN(RTRIM(@CalcCCKeyHistP))) AS VARBINARY(10))
        
    IF @NomCDType = 'K'
      SET @DepCCKey = @CalcDepKeyHistP + 
                      CAST(SPACE(21 - LEN(RTRIM(@CalcDepKeyHistP))) AS VARBINARY(10))
        
    IF @NomType IN ('B','C')
      SET @YTDPer = 255
    ELSE
      SET @YTDPer = 254
         
    SELECT @YTDPosID = ISNULL(PositionId,0) 
    FROM [!ActiveSchema!].[HISTORY]
    WHERE hiExCLass  = ASCII(@NomType) 
    AND   hiCode     = @Key 
    AND   hiCurrency = @TheCcy
    AND   hiYear     = @TheYear 
    AND   hiPeriod   = @YTDPer
    
    -- Add YTD Record if it doesn't exist
        
    IF @YTDPosID = 0
    BEGIN
      IF @YTDPer = 255
      BEGIN
        SELECT @LastSales = [!ActiveSchema!].[ifn_GetNominalValue] (1,(@TheYear + 1900) - 1,0,@TheCcy,@NomCode,@NomCC,@NomDept,@CDFlag,0)
                
        SELECT @LastPurchase = [!ActiveSchema!].[ifn_GetNominalValue] (2,(@TheYear + 1900) - 1,0,@TheCcy,@NomCode,@NomCC,@NomDept,@CDFlag,0)
                
        SELECT @LastCleared = [!ActiveSchema!].[ifn_GetNominalValue] (6,(@TheYear + 1900) - 1,0,@TheCcy,@NomCode,@NomCC,@NomDept,@CDFlag,0)
      END
            
      INSERT INTO [!ActiveSchema!].[HISTORY]
                ( [hiCode]
                , [hiExCLass]
                , [hiCurrency]
                , [hiYear]
                , [hiPeriod]
                , [hiSales]
                , [hiPurchases]
                , [hiBudget]
                , [hiCleared]
                , [hiRevisedBudget1]
                , [hiValue1]
                , [hiValue2]
                , [hiValue3]
                , [hiRevisedBudget2]
                , [hiRevisedBudget3]
                , [hiRevisedBudget4]
                , [hiRevisedBudget5]
                , [hiSpareV]
                )
      VALUES    ( @Key
                , ASCII(@NomType)
                , @TheCcy
                , @TheYear
                , @YTDPer
                , @LastSales
                , @LastPurchase
                , 0
                , @LastCleared
                , 0
                , 0
                , 0
                , 0
                , 0
                , 0
                , 0
                , 0
                , 0
                )    -- Debug

      SELECT @YTDPosID = PositionId
           , @YTDCreated = 1
      FROM [!ActiveSchema!].[HISTORY]
      WHERE hiExCLass  = ASCII(@NomType)
      AND   hiCode     = @Key 
      AND   hiCurrency = @TheCcy
      AND   hiYear     = @TheYear 
      AND   hiPeriod   = @YTDPer
            
    END

    IF @NomCDType = 'K'
    BEGIN
      SELECT @YTDDepPosId = ISNULL(PositionId,0)
      FROM [!ActiveSchema!].[HISTORY]
      WHERE hiExCLass  = ASCII(@NomType) 
      AND   hiCode     = @DepCCKey 
      AND   hiCurrency = @TheCcy
      AND   hiYear     = @TheYear 
      AND   hiPeriod   = @YTDPer
        
      SET @LastSales = 0
      SET @LastPurchase = 0
      SET @LastCleared = 0

      IF @YTDDepPosId = 0 
      BEGIN
        IF @YTDPer = 255
        BEGIN
          SELECT @LastSales = [!ActiveSchema!].[ifn_GetNominalValue] (1,(@TheYear + 1900) - 1,0,@TheCcy,@NomCode,@NomCC,@NomDept,@CDFlag,0)
                    
          SELECT @LastPurchase = [!ActiveSchema!].[ifn_GetNominalValue] (2,(@TheYear + 1900) - 1,0,@TheCcy,@NomCode,@NomCC,@NomDept,@CDFlag,0)
                    
          SELECT @LastCleared = [!ActiveSchema!].[ifn_GetNominalValue] (6,(@TheYear + 1900) - 1,0,@TheCcy,@NomCode,@NomCC,@NomDept,@CDFlag,0)
        END
                
        INSERT INTO [!ActiveSchema!].[HISTORY]
                  ( [hiCode]
                  , [hiExCLass]
                  , [hiCurrency]
                  , [hiYear]
                  , [hiPeriod]
                  , [hiSales]
                  , [hiPurchases]
                  , [hiBudget]
                  , [hiCleared]
                  , [hiRevisedBudget1]
                  , [hiValue1]
                  , [hiValue2]
                  , [hiValue3]
                  , [hiRevisedBudget2]
                  , [hiRevisedBudget3]
                  , [hiRevisedBudget4]
                  , [hiRevisedBudget5]
                  , [hiSpareV]
                  )
        VALUES    ( @DepCCKey
                  , ASCII(@NomType)
                  , @TheCcy
                  , @TheYear
                  , @YTDPer
                  , @LastSales
                  , @LastPurchase
                  , 0
                  , @LastCleared
                  , 0
                  , 0
                  , 0
                  , 0
                  , 0
                  , 0
                  , 0
                  , 0
                  , 0
                  )    -- Debug

        SELECT @YTDDepPosId = PositionId
             , @YTDCreated  = 1 
        FROM [!ActiveSchema!].[HISTORY]
        WHERE hiExCLass  = ASCII(@NomType) 
        AND   hiCode     = @DepCCKey
        AND   hiCurrency = @TheCcy
        AND   hiYear     = @TheYear
        AND   hiPeriod   = @YTDPer
                
      END
    END

    -- Check if Period History Record Exists

    SELECT @BudPosID          = ISNULL(PositionId,0)
    FROM [!ActiveSchema!].[HISTORY]
    WHERE hiExCLass  = ASCII(@NomType) 
    AND   hiCode     = @Key 
    AND   hiCurrency = @TheCcy
    AND   hiYear     = @TheYear 
    AND   hiPeriod   = @ThePeriod

    IF @BudPosID = 0
    BEGIN
            
      INSERT INTO [!ActiveSchema!].[HISTORY]
                ( [hiCode]
                , [hiExCLass]
                , [hiCurrency]
                , [hiYear]
                , [hiPeriod]
                , [hiSales]
                , [hiPurchases]
                , [hiBudget]
                , [hiCleared]
                , [hiRevisedBudget1]
                , [hiValue1]
                , [hiValue2]
                , [hiValue3]
                , [hiRevisedBudget2]
                , [hiRevisedBudget3]
                , [hiRevisedBudget4]
                , [hiRevisedBudget5]
                , [hiSpareV]
                )
      VALUES    ( @Key
                , ASCII(@NomType)
                , @TheCcy
                , @TheYear
                , @ThePeriod
                , 0
                , 0
                , 0
                , 0
                , 0
                , 0
                , 0
                , 0
                , 0
                , 0
                , 0
                , 0
                , 0
                )    -- Debug

      SELECT @BudPosID = PositionId
      FROM [!ActiveSchema!].[HISTORY]
      WHERE hiExCLass  = ASCII(@NomType) 
      AND   hiCode     = @Key 
      AND   hiCurrency = @TheCcy
      AND   hiYear     = @TheYear 
      AND   hiPeriod   = @ThePeriod
    END
    
    IF @NomCDType = 'K'
    BEGIN
      SELECT @BudDepPosId         = ISNULL(PositionId,0)
      FROM [!ActiveSchema!].[HISTORY]
      WHERE hiExCLass  = ASCII(@NomType) 
      AND   hiCode     = @DepCCKey 
      AND   hiCurrency = @TheCcy
      AND   hiYear     = @TheYear 
      AND   hiPeriod   = @ThePeriod

      IF @BudDepPosId = 0
      BEGIN
                
        INSERT INTO [!ActiveSchema!].[HISTORY]
                  ( [hiCode]
                  , [hiExCLass]
                  , [hiCurrency]
                  , [hiYear]
                  , [hiPeriod]
                  , [hiSales]
                  , [hiPurchases]
                  , [hiBudget]
                  , [hiCleared]
                  , [hiRevisedBudget1]
                  , [hiValue1]
                  , [hiValue2]
                  , [hiValue3]
                  , [hiRevisedBudget2]
                  , [hiRevisedBudget3]
                  , [hiRevisedBudget4]
                  , [hiRevisedBudget5]
                  , [hiSpareV]
                  )
        VALUES    ( @DepCCKey
                  , ASCII(@NomType)
                  , @TheCcy
                  , @TheYear
                  , @ThePeriod
                  , 0
                  , 0
                  , 0
                  , 0
                  , 0
                  , 0
                  , 0
                  , 0
                  , 0
                  , 0
                  , 0
                  , 0
                  , 0
                  )    -- Debug

        SELECT @BudDepPosId = PositionId 
        FROM [!ActiveSchema!].[HISTORY]
        WHERE hiExCLass  = ASCII(@NomType) 
        AND   hiCode     = @DepCCKey 
        AND   hiCurrency = @TheCcy
        AND   hiYear     = @TheYear 
        AND   hiPeriod   = @ThePeriod
      END
    END

    -- Set Budgets
    UPDATE [!ActiveSchema!].[HISTORY]
       SET hiBudget         = CASE
                              WHEN @SaveValue = 1 THEN @NewBudget
                              ELSE hiBudget
                              END
         , hiRevisedBudget1 = CASE
                              WHEN @SaveValue = 2 THEN @NewBudget
                              ELSE hiRevisedBudget1
                              END
         , hiRevisedBudget2 = CASE
                              WHEN @SaveValue = 3 THEN @NewBudget
                              ELSE hiRevisedBudget2
                              END
         , hiRevisedBudget3 = CASE
                              WHEN @SaveValue = 4 THEN @NewBudget
                              ELSE hiRevisedBudget3
                              END
         , hiRevisedBudget4 = CASE
                              WHEN @SaveValue = 5 THEN @NewBudget
                              ELSE hiRevisedBudget4
                              END
         , hiRevisedBudget5 = CASE
                              WHEN @SaveValue = 6 THEN @NewBudget
                              ELSE hiRevisedBudget5
                              END
    WHERE PositionId = @BudPosId

    IF @NomCDType = 'K'
    BEGIN

      UPDATE [!ActiveSchema!].[HISTORY]
         SET hiBudget         = CASE
                                WHEN @SaveValue = 1 THEN @NewBudget
                                ELSE hiBudget
                                END
           , hiRevisedBudget1 = CASE
                                WHEN @SaveValue = 2 THEN @NewBudget
                                ELSE hiRevisedBudget1
                                END
           , hiRevisedBudget2 = CASE
                                WHEN @SaveValue = 3 THEN @NewBudget
                                ELSE hiRevisedBudget2
                                END
           , hiRevisedBudget3 = CASE
                                WHEN @SaveValue = 4 THEN @NewBudget
                                ELSE hiRevisedBudget3
                                END
           , hiRevisedBudget4 = CASE
                                WHEN @SaveValue = 5 THEN @NewBudget
                                ELSE hiRevisedBudget4
                                END
           , hiRevisedBudget5 = CASE
                                WHEN @SaveValue = 6 THEN @NewBudget
                                ELSE hiRevisedBudget5
                                END
      WHERE PositionId = @BudDepPosId

    END

    SET @ReturnCode = 0
    
  END
  -- Return the result of the function

  SET NOCOUNT OFF

  RETURN @ReturnCode

END

GO