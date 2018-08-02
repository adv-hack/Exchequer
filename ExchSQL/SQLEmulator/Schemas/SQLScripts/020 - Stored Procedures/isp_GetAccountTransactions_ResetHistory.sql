--/////////////////////////////////////////////////////////////////////////////
--// Filename		: isp_GetAccountTransactions_ResetHistory.sql
--// Author		: 
--// Date		: 
--// Copyright Notice	: (c) 2015 Advanced Business Software & Solutions Ltd. All rights reserved.
--// Description	: SQL Script to add isp_GetAccountTransactions_ResetHistory stored procedure
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	: File Creation
--//
--/////////////////////////////////////////////////////////////////////////////

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[isp_GetAccountTransactions_ResetHistory]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [!ActiveSchema!].[isp_GetAccountTransactions_ResetHistory]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Resets History for History Classifications U, V, W for specified Account
-- then returns all Transaction Headers for the Account

-- Usage: EXEC [!ActiveSchema!].[isp_GetAccountTransactions_ResetHistory] 'C07709', 101

CREATE PROCEDURE [!ActiveSchema!].[isp_GetAccountTransactions_ResetHistory]
	(
	  @iv_strAccountCode   VARCHAR(6)
	, @iv_intExchStartYear INT
	)
AS
BEGIN

  -- Declare Variables
  DECLARE @Company     VARCHAR(10)
        , @AccountCode VARCHAR(10)

  SET @Company = '!ActiveSchema!'  -- '[!ActiveSchema!]'

  -- Reset audit history for this account. Sets Sales, Purchases and Cleared to 0 for specified account
  -- where found and > specified year. NOTE: > NOT >= ???

  DECLARE @intReturnValue INT

  -- Reset Audit History requires the History Classification (hiExClass) concatinated at front of Account Code
  --
  -- Reset 'U' History
  SET @AccountCode = 'U ' + @iv_strAccountCode
  EXEC @intReturnValue = common.isp_ResetAuditHistory @Company, @AccountCode, 0, @iv_intExchStartYear, 6

  -- Error Check
  IF @intReturnValue <> 0
  BEGIN
    EXEC common.isp_RaiseError @iv_IRISExchequerErrorMessage = 'Procedure [!ActiveSchema!].[isp_CheckAllAccounts_ResetHistory] ... Resetting U Audit History'
    RETURN -1
  END

  -- Reset 'V' History
  SET @AccountCode = 'V ' + @iv_strAccountCode
  EXEC @intReturnValue = common.isp_ResetAuditHistory @Company, @AccountCode, 0, @iv_intExchStartYear, 6

  -- Error Check
  IF @intReturnValue <> 0
  BEGIN
	EXEC common.isp_RaiseError @iv_IRISExchequerErrorMessage = 'Procedure [!ActiveSchema!].[isp_CheckAllAccounts_ResetHistory] ... Resetting V Audit History'
	RETURN -1
  END

  -- Reset 'W' History
  SET @AccountCode = 'W ' + @iv_strAccountCode
  EXEC @intReturnValue = common.isp_ResetAuditHistory @Company, @AccountCode, 0, @iv_intExchStartYear, 6

  -- Return Transaction Headers

  SELECT thAcCode
       , thCustSupp
       , thNomAuto
       , thFolioNum
       , thRunNo
       , thDocType
       , thControlGL
       , thYear
       , thPeriod
       , thCurrency
       , thRemitNo
       , thSettledVAT
       , thVATPostDate
       , thUntilDate
       , thCurrSettled
       , thOurRef
       , thCompanyRate
       , thDailyRate
       , thOutstanding
       , thDueDate
       , thTotalOrderOS
       , thTotalCost
       , thTotalOrdered
       , thDeliveryNoteRef
       , thNetValue
       , thTotalVAT
       , thTotalLineDiscount
       , thVariance
       , thRevalueAdj
       , thSettleDiscAmount
       , thSettleDiscTaken
       , thAmountSettled
       , PostDiscAm
       , PositionId
  FROM   [!ActiveSchema!].DOCUMENT TH
  JOIN   common.ivw_TransactionType TT ON TH.thDocType = TT.TransactionTypeId
  WHERE  TT.TransactionTypeCode NOT IN ('SQU', 'PQU', 'WOR', 'WIN', 'JCT', 'JST', 'JPT', 'JSA', 'JPA', 'SRN', 'PRN')
  AND    TH.thNomAuto <> 0
  AND    TH.thAcCodeComputed = @iv_strAccountCode    -- using thAcCodeComputed because indexes on this field

END
GO

