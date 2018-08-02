--/////////////////////////////////////////////////////////////////////////////
--// Filename		: isp_Report_GLHistory.sql
--// Author		: 
--// Date		: 
--// Copyright Notice	: (c) 2015 Advanced Business Software & Solutions Ltd. All rights reserved.
--// Description	: SQL Script to add isp_Report_GLHistory stored procedure
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	: File Creation
--//
--/////////////////////////////////////////////////////////////////////////////

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[isp_Report_GLHistory]') AND type in (N'P', N'PC'))
	drop procedure [!ActiveSchema!].[isp_Report_GLHistory]
go

/*
   General Ledger History Report

   Usage:
          EXEC [!ActiveSchema!].isp_Report_GLHistory @iv_AccountCode        = ''
                                         , @iv_Currency           = 0
                                         , @iv_DepartmentCode     = ''
                                         , @iv_CostCentreCode     = ''
                                         , @iv_FromYear           = 109    -- Exchequer Year takes form of Year - 1900, e.g. 2009 - 1900 = 109
                                         , @iv_FromPeriod         = 9
                                         , @iv_ToYear             = 109
                                         , @iv_ToPeriod           = 9
                                         , @iv_FromDate           = '2009-09-01'
                                         , @iv_ToDate             = '2012-12-01'
                                         , @iv_FromGLCode         = 11020
                                         , @iv_ToGLCode           = 11090
                                         , @iv_FilterByDate       = 1
                                         , @iv_TransactionType    = -99  -- a.k.a. DocumentType ... -99 = all document types
                                         , @iv_CommitMode         = 0
                                         , @iv_IsSOPEnabled       = 0
                                         , @iv_IsQuote            = 0
                                         , @iv_IsCommitAccounting = 0

*/
CREATE PROCEDURE [!ActiveSchema!].isp_Report_GLHistory
               ( @iv_AccountCode        VARCHAR(10)
               , @iv_Currency           INT
               , @iv_DepartmentCode     VARCHAR(3)
               , @iv_CostCentreCode     VARCHAR(3)
               , @iv_FromYear           INT
               , @iv_FromPeriod         INT
               , @iv_ToYear             INT
               , @iv_ToPeriod           INT
               , @iv_FromDate           DATETIME
               , @iv_ToDate             DATETIME
               , @iv_FromGLCode         INT
               , @iv_ToGLCode           INT
               , @iv_FilterByDate       BIT
               , @iv_TransactionType    INT
               , @iv_CommitMode         INT
               , @iv_IsSOPEnabled       BIT
               , @iv_IsQuote            BIT
               , @iv_IsCommitAccounting BIT
               )
AS
BEGIN

/*
-- Debug purposes only

DECLARE @iv_AccountCode        VARCHAR(10) = ''
      , @iv_Currency           INT         = 0
      , @iv_DepartmentCode     VARCHAR(3)  = ''
      , @iv_CostCentreCode     VARCHAR(3)  = ''
      , @iv_FromYear           INT         = 109    -- Exchequer Year takes form of Year - 1900, e.g. 2009 - 1900 = 109
      , @iv_FromPeriod         INT         = 9
      , @iv_ToYear             INT         = 109
      , @iv_ToPeriod           INT         = 9
      , @iv_FromDate           DATETIME    = '2009-09-01'
      , @iv_ToDate             DATETIME    = GETDATE()
      , @iv_FromGLCode         INT         = 1
      , @iv_ToGLCode           INT         = 99999999
      , @iv_FilterByDate       BIT         = 1
      , @iv_TransactionType    INT         = -99  -- a.k.a. DocumentType ... -99 = all document types
      , @iv_CommitMode         INT         = 0
      , @iv_IsSOPEnabled       BIT         = 0
      , @iv_IsQuote            BIT         = 0
      , @iv_IsCommitAccounting BIT         = 0
*/
-- Constants
DECLARE @c_RunTransactionType INT
      , @c_CommitOrdRunNo INT

SET @c_RunTransactionType = 31
SET @c_CommitOrdRunNo = -53

-- Variables

DECLARE @FromPeriod    INT
      , @ToPeriod      INT
      , @FromDate      VARCHAR(8)
      , @ToDate        VARCHAR(8)

DECLARE @TransTable TABLE
    (
	[thLongYourRef] [varbinary](30) NULL,
	[thYourRef] [varchar](20) NULL,
	[thOurRef] [varchar](10) NULL,
	[thAcCode] [varchar](10) NULL,
	[thTransDate] [varchar](8) NULL,
	[thDueDate] [varchar](8) NULL,
	[tlRunNo] [int] NOT NULL,
	[tlFolioNum] [int] NOT NULL,
	[tlOurRef] [varchar](10) NOT NULL,
	[tlGLCode] [int] NOT NULL,
	[tlDocType] [int] NOT NULL,
	[tlLineDate] [varchar](8) NOT NULL,
	[tlPaymentCode] [varchar](1) NOT NULL,
	[tlPriceMultiplier] [float] NOT NULL,
	[tlNetValue] [float] NOT NULL,
	[tlQty] [float] NOT NULL,
	[tlQtyMul] [float] NOT NULL,
	[tlUsePack] [bit] NOT NULL,
	[tlPrxPack] [bit] NOT NULL,
	[tlQtyPack] [float] NOT NULL,
	[tlShowCase] [bit] NOT NULL,
	[tlVATCode] [varchar](1) NOT NULL,
	[tlVATIncValue] [float] NOT NULL,
	[tlDiscount] [float] NOT NULL,
	[tlDiscFlag] [varchar](1) NOT NULL,
	[tlDiscount2] [float] NOT NULL,
	[tlDiscount2Chr] [varchar](1) NOT NULL,
	[tlDiscount3] [float] NOT NULL,
	[tlDiscount3Chr] [varchar](1) NOT NULL,
	[tlCompanyRate] [float] NOT NULL,
        [tlDailyRate] [float] NOT NULL,
	[tlUseOriginalRates] [int] NOT NULL,
	[tlCurrency] [int] NOT NULL,
	[tlPeriod] [int] NOT NULL,
	[tlYear] [int] NOT NULL,
	[tlDescription] [varchar](60) NOT NULL,
	[YearPeriod] INT NOT NULL,
	[tlAcCode] varchar(50) not null,
	[tlDepartment] varchar(50) not null,
	[tlCostCentre] varchar(50) not null
	)

-- Validate ToGLCode, if its Zero(0) then set to Max. Number to gather all Codes

IF @iv_ToGLCode = 0
BEGIN
  SET @iv_ToGLCode = 99999999    -- Set to max. number
END

-- Set From and To Period for easier select criteria
SET @FromPeriod = (@iv_FromYear * 1000) + @iv_FromPeriod
SET @ToPeriod   = (@iv_ToYear * 1000) + @iv_ToPeriod
SET @FromDate   = CONVERT(VARCHAR(8), @iv_FromDate, 112)
SET @ToDate     = CONVERT(VARCHAR(8), @iv_ToDate, 112)

--PRINT @FROMPeriod
--PRINT @ToPeriod

INSERT @TransTable
SELECT thLongYourRef = CONVERT(VARBINARY, NULL)
     , thYourRef     = CONVERT(VARCHAR(20), NULL)
     , thOurRef      = CONVERT(VARCHAR(10), NULL)
     , thAcCode      = tlAcCode
     , thTransDate   = CONVERT(VARCHAR(8), NULL)
     , thDueDate     = CONVERT(VARCHAR(8), NULL)
     , [tlRunNo]
     , [tlFolioNum]
     , [tlOurRef]
     , [tlGLCode]
     , [tlDocType]
     , [tlLineDate]
     , [tlPaymentCode]
     , [tlPriceMultiplier]
     , [tlNetValue]
     , [tlQty]
     , [tlQtyMul]
     , [tlUsePack]
     , [tlPrxPack]
     , [tlQtyPack]
     , [tlShowCase]
     , [tlVATCode]
     , [tlVATIncValue]
     , [tlDiscount]
     , [tlDiscFlag]
     , [tlDiscount2]
     , [tlDiscount2Chr]
     , [tlDiscount3]
     , [tlDiscount3Chr]
     , [tlCompanyRate]
     , [tlDailyRate]
     , [tlUseOriginalRates]
     , [tlCurrency]
     , [tlPeriod]
     , [tlYear]
     , [tlDescription]
     , [YearPeriod] = ((TL.tlYear * 1000) + TL.tlPeriod)
     , tlAcCode
     , tlDepartment
     , tlCostCentre

FROM   [!ActiveSchema!].DETAILS TL
--LEFT JOIN   [!ActiveSchema!].DOCUMENT  TH ON TH.thRunNo    = TL.tlRunNo -- TH.thFolioNum = TL.tlFolioNum -- TH.thRunNo = TL.tlRunNo

WHERE 1 = 1
AND ( (@iv_FilterByDate = 0 AND ((TL.tlYear * 1000) + TL.tlPeriod) BETWEEN @FromPeriod AND @ToPeriod)
   OR (@iv_FilterByDate = 1 AND TL.tlLineDate BETWEEN @FromDate AND @ToDate )
    )

-- Update the Transaction Header data
UPDATE tt
   SET thDueDate     = TH.thDueDate
     , thTransDate   = TH.thTransDate
     , thOurRef      = TH.thOurRef
     , thYourRef     = TH.thYourRef
     , thLongYourRef = TH.thLongYourRef

FROM   @TransTable tt
JOIN   [!ActiveSchema!].DOCUMENT TH ON tt.tlFolioNum = TH.thFolioNum
                         AND tt.tlRunNo    = TH.thRunNo
                         AND tt.tlOurRef   = TH.thOurRef

-- Select back the data

SELECT [tlGLCode]
     , [tlDocType]
     , [tlLineDate]
     , [tlPaymentCode]
     , [tlPriceMultiplier]
     , [tlNetValue]
     , [tlQty]
     , [tlQtyMul]
     , [tlUsePack]
     , [tlPrxPack]
     , [tlQtyPack]
     , [tlShowCase]
     , [tlVATCode]
     , [tlVATIncValue]
     , [tlDiscount]
     , [tlDiscFlag]
     , [tlDiscount2]
     , [tlDiscount2Chr]
     , [tlDiscount3]
     , [tlDiscount3Chr]
     , [tlCompanyRate]
     , [tlDailyRate]
     , [tlUseOriginalRates]
     , [tlCurrency]
     , [tlPeriod]
     , [tlYear]
     , [tlDescription]
     , [thLongYourRef]
     , [thYourRef]
     , [thOurRef]
     , [thAcCode]
     , [thTransDate]
     , [thDueDate]
FROM   @TransTable TL
WHERE 1 = 1

-- Standard Filters

AND   TL.tlFolioNum >= 0
AND   (TL.tlCurrency = @iv_Currency OR @iv_Currency = 0)

AND   TL.tlGLCode   BETWEEN @iv_FromGLCode  AND @iv_ToGLCode

-- Transaction Header Filters
--AND (TH.thOurRef   = TL.tlOurRef OR TL.tlOurRef = '')
--AND ( (@iv_IsQuote = 1 AND thRunNo = 0 AND thFolioNum <> 0)
--   OR (@iv_IsQuote = 0 AND ( thRunNo > 0 OR thDocType = @c_RunTransactionType ))
--    )
AND ( (@iv_IsQuote = 1 AND tlRunNo = 0 AND tlFolioNum <> 0)
   OR (@iv_IsQuote = 0 AND ( tlRunNo > 0 OR tlDocType = @c_RunTransactionType ))
    )

-- Account Code Filter
AND   (@iv_AccountCode = '' OR tlAcCode = @iv_AccountCode)

-- Posted Filter
AND   ( (TL.tlDocType = @c_RunTransactionType AND tlRunNo > 0 AND tlCurrency = @iv_Currency)
        OR (TL.tlDocType <> @c_RunTransactionType)
        OR (TL.tlRunNo   = @c_CommitOrdRunNo AND @iv_CommitMode IN (1,2))
      )

-- Transaction Type (Document Type) Filter
AND   (@iv_TransactionType = -99 OR TL.tlDocType    = @iv_TransactionType)

-- Cost Centre Filter
AND   (@iv_CostCentreCode  = ''  OR TL.tlCostCentre = @iv_CostCentreCode)

-- Department Filter
AND   (@iv_DepartmentCode  = ''  OR TL.tlDepartment = @iv_DepartmentCode)

-- SOP Filter
AND   (  @iv_IsSOPEnabled = 0
     OR
       ( @iv_IsSOPEnabled = 1
        AND (@iv_IsCommitAccounting = 0
             OR ( ( TL.tlDocType <> @c_RunTransactionType)  AND ( @iv_CommitMode IN (0,1)) )
             OR ( ( TL.tlRunNo   <> @c_CommitOrdRunNo) AND ( @iv_CommitMode IN (0,1)) )
             OR ( ( TL.tlRunNo   =  @c_CommitOrdRunNo) AND ( @iv_CommitMode IN (1,2)) )
            )
       )
      )

ORDER BY tlGLCode 
       , tlYear 
       , tlPeriod 
       , thACCode 
       , tlLinedate 
END

