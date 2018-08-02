--/////////////////////////////////////////////////////////////////////////////
--// Filename		: esp_GLJobActual.sql
--// Author		: Glen Jones, Chris Sandow
--// Date		: 2014-07-07
--// Copyright Notice	: (c) 2015 Advanced Business Software & Solutions Ltd. All rights reserved.
--// Description	: SQL Script to install stored procedure for the v7.0.11 release
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	2014-07-07:	File Creation - Glen Jones, Chris Sandow
--//    2   2016-08-09: ABSEXCH-16765 - Glen Jones
--//
--/////////////////////////////////////////////////////////////////////////////

SET NOCOUNT ON

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[esp_GLJobActual]') AND type in (N'P', N'PC'))
DROP PROCEDURE [!ActiveSchema!].[esp_GLJobActual]
GO

CREATE PROCEDURE [!ActiveSchema!].esp_GLJobActual
               ( @iv_GLCode       INTEGER
               , @iv_StartPeriod  INT
               , @iv_StartYear    INT
               , @iv_EndPeriod    INT
               , @iv_EndYear      INT
               , @iv_Currency     INT
               , @iv_JobCode      VARCHAR(10)
               , @iv_AnalysisCode VARCHAR(10) = ''
               , @iv_StockCode    VARCHAR(20) = ''
               , @iv_LocationCode VARCHAR(10) = ''
               , @iv_CostCentre   VARCHAR(3)  = ''
               , @iv_Department   VARCHAR(3)  = ''
               , @iv_AccountCode  VARCHAR(10) = ''
               )
AS
BEGIN
  
  IF EXISTS(SELECT TOP 1 JA.RecPfix
            FROM [!ActiveSchema!].JOBDET JA  

            WHERE (JA.RecPFix = 'J') 
            AND   (JA.SubType = 'E') 
            AND   (JA.Posted  = 1) 
            AND   (JA.JDDT NOT IN (8, 23, 9, 24, 7, 22, 35, 41)) 

            -- Mandatory Parameters
            AND (JA.JobCode   = @iv_JobCode )
            AND (JA.OrigNCode = @iv_GLCode  )
  
            AND (JA.JobTranYear * 100)
               + JA.JobTranPeriod BETWEEN ((@iv_StartYear * 100) + @iv_StartPeriod)
                                      AND ((@iv_EndYear * 100) + @iv_EndPeriod)

            AND (JA.CurrencyId = @iv_Currency OR @iv_Currency = 0)

            -- Optional Parameters
  
            AND (JA.var_code5    = @iv_AnalysisCode OR @iv_AnalysisCode = '') 
            AND (JA.StockCode    = @iv_StockCode    OR @iv_StockCode    = '')
           )
  BEGIN            
    SELECT      tlFolioNum, tlLineNo, tlRunNo, tlGLCode, tlNominalMode, tlCurrency
              , tlYear, tlPeriod, tlDepartment, tlCostCentre, tlStockCode, tlABSLineNo
              , tlLineType, tlDocType
              , tlDLLUpdate, tlOldSerialQty, tlQty, tlQtyMul, tlNetValue, tlDiscount
              , tlVATCode, tlVATAmount, tlPaymentCode, tlOldPBal, tlRecStatus, tlDiscFlag
              , tlQtyWOFF, tlQtyDel, tlCost
              , tlAcCode, tlLineDate, tlItemNo, tlDescription, tlJobCode, tlAnalysisCode
              , tlCompanyRate, tlDailyRate, tlUnitWeight, tlStockDeductQty, tlBOMKitLink, tlSOPFolioNum
              , tlSOPABSLineNo, tlLocation, tlQtyPicked, tlQtyPickedWO, tlUsePack, tlSerialQty, tlCOSNomCode
              , tlOurRef, tlDocLTLink, tlPrxPack, tlQtyPack, tlReconciliationDate, tlShowCase, tlSdbFolio
              , tlOriginalBaseValue, tlUseOriginalRates, tlUserField1, tlUserField2, tlUserField3
              , tlUserField4, tlSSDUpliftPerc, tlSSDCountry, tlInclusiveVATCode, tlSSDCommodCode
              , tlSSDSalesUnit, tlPriceMultiplier, tlB2BLinkFolio, tlB2BLineNo, tlTriRates, tlTriEuro
              , tlTriInvert, tlTriFloat, tlSpare1, tlSSDUseLineValues, tlPreviousBalance, tlLiveUplift 
              , tlCOSDailyRate, tlVATIncValue, tlLineSource, tlCISRateCode, tlCISRate, tlCostApport
              , tlNOMIOFlag, tlBinQty, tlCISAdjustment, tlDeductionType, tlSerialReturnQty, tlBinReturnQty
              , tlDiscount2, tlDiscount2Chr, tlDiscount3, tlDiscount3Chr, tlDiscount3Type, tlECService
              , tlServiceStartDate, tlServiceEndDate, tlECSalesTaxReported, tlPurchaseServiceTax, tlReference
              , tlReceiptNo, tlFromPostCode, tlToPostCode, tlUserField5, tlUserField6, tlUserField7, tlUserField8
              , tlUserField9, tlUserField10, tlThresholdCode, tlMaterialsOnlyRetention 
              , tlIntrastatNoTC
              , tlTaxRegion
    FROM [!ActiveSchema!].JOBDET JA  
    JOIN [!ActiveSchema!].DETAILS TL WITH (INDEX(DETAILS_Index5)) ON (JA.LineFolio  = TL.tlFolioNum)
                                                       AND (JA.LineNUmber = TL.tlABSLineNo)
    WHERE (JA.RecPFix = 'J') 
    AND   (JA.SubType = 'E') 
    AND   (JA.Posted  = 1) 
    AND   (JA.JDDT NOT IN (8, 23, 9, 24, 7, 22, 35, 41)) 

    -- Mandatory Parameters
    AND (JA.JobCode   = @iv_JobCode )
    AND (JA.OrigNCode = @iv_GLCode  )
  
    AND (JA.JobTranYear * 100)
       + JA.JobTranPeriod BETWEEN ((@iv_StartYear * 100) + @iv_StartPeriod)
                              AND ((@iv_EndYear * 100) + @iv_EndPeriod)
  
    AND (JA.CurrencyId = @iv_Currency OR @iv_Currency = 0)

    -- Optional Parameters
  
    AND (JA.var_code5    = @iv_AnalysisCode OR @iv_AnalysisCode = '') 
    AND (JA.StockCode    = @iv_StockCode    OR @iv_StockCode    = '')
    AND (TL.tlLocation   = @iv_LocationCode OR @iv_LocationCode = '')
    AND (TL.tlCostCentre = @iv_CostCentre   OR @iv_CostCentre   = '') 
    AND (TL.tlDepartment = @iv_Department   OR @iv_Department   = '')
    AND (TL.tlAcCode     = @iv_AccountCode  OR @iv_AccountCode  = '')

  END
  ELSE
  BEGIN

    SELECT NoRows = 1
    WHERE 1 = 2
  
  END
END
GO
