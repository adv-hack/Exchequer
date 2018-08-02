--/////////////////////////////////////////////////////////////////////////////
--// Filename			: !ActiveSchema!.esp_AnonymiseTransactions
--// Author				: James Waygood 
--// Date				: 12th December 2017 
--// Copyright Notice	: (c) 2017 Advanced Business Software & Solutions Ltd. All rights reserved.
--// Description		: SQL Script to anonymise GDPR Notes within Exchequer
--// Execute			: EXEC [!ActiveSchema!].[esp_AnonymiseTransactions] 1, 'ABAP01'
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	: File Creation
--//	2	: Added setting of Anonymisation Status, Date and Time
--//	3	: Fixed anonymisation of JC transactions
--//
--/////////////////////////////////////////////////////////////////////////////

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[esp_AnonymiseTransactions]') AND type in (N'P', N'PC'))
DROP PROCEDURE [!ActiveSchema!].[esp_AnonymiseTransactions]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [!ActiveSchema!].[esp_AnonymiseTransactions] 
(
	@iv_AnonymisationType	int = 1,				-- 1 = Customer/Consumer 2 = Supplier 3 = Employee
	@iv_AnonymisationCode	varchar(10) = '',		-- Entity Code 
	@iv_OptionalParameters	varchar(200) = ''		-- DeleteNotes, DeleteLetters, DeleteLinks -- CSV
)
AS
BEGIN
	/* DEBUG
	DECLARE @iv_AnonymisationType	int = 1
	DECLARE @iv_AnonymisationCode	varchar(10) = ''
	*/

	SET NOCOUNT ON
	
	-- Anonymise generic transaction fields
	UPDATE [!ActiveSchema!].DOCUMENT WITH (READPAST)
		SET  thDeliveryAddr1 = common.efn_RandomText(thDeliveryAddr1)
			,thDeliveryAddr2 = common.efn_RandomText(thDeliveryAddr2)
			,thDeliveryAddr3 = common.efn_RandomText(thDeliveryAddr3)
			,thDeliveryAddr4 = common.efn_RandomText(thDeliveryAddr4)
			,thDeliveryAddr5 = common.efn_RandomText(thDeliveryAddr5)
			,thDeliveryPostCode = common.efn_RandomText(thDeliveryPostCode)
			,thAnonymised = 1
			,thAnonymisedDate = CONVERT(varchar(8), GETDATE(), 112)
			,thAnonymisedTime = REPLACE(CONVERT(varchar(8),GetDate(), 108),':','')
			,thHoldFlag = CASE WHEN UPPER(@iv_OptionalParameters) LIKE '%DELETENOTES%'
							   THEN CASE WHEN thHoldFlag IN (32,33,34,35,36,37,38,160,161,162,163,164,165,166)
										 THEN thHoldFlag - 32
									ELSE thHoldFlag 
									END
							   ELSE thHoldFlag
						  END

	WHERE thAcCode = @iv_AnonymisationCode AND thDocType NOT IN (41,46,49,50)

	IF @iv_AnonymisationType = 1
	BEGIN
		-- Anonymise Sales Type Transaction Headers
		UPDATE [!ActiveSchema!].DOCUMENT WITH (READPAST)
			SET  thUserField1 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 4001) = 1 THEN common.efn_RandomText(thUserField1) ELSE thUserField1 END
				,thUserField2 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 4002) = 1 THEN common.efn_RandomText(thUserField2) ELSE thUserField2 END
				,thUserField3 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 4003) = 1 THEN common.efn_RandomText(thUserField3) ELSE thUserField3 END
				,thUserField4 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 4004) = 1 THEN common.efn_RandomText(thUserField4) ELSE thUserField4 END
				,thUserField5 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 4005) = 1 THEN common.efn_RandomText(thUserField5) ELSE thUserField5 END
				,thUserField6 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 4006) = 1 THEN common.efn_RandomText(thUserField6) ELSE thUserField6 END
				,thUserField7 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 4007) = 1 THEN common.efn_RandomText(thUserField7) ELSE thUserField7 END
				,thUserField8 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 4008) = 1 THEN common.efn_RandomText(thUserField8) ELSE thUserField8 END
				,thUserField9 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 4009) = 1 THEN common.efn_RandomText(thUserField9) ELSE thUserField9 END
				,thUserField10 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 4010) = 1 THEN common.efn_RandomText(thUserField10) ELSE thUserField10 END
				,thUserField11 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 4011) = 1 THEN common.efn_RandomText(thUserField11) ELSE thUserField11 END
				,thUserField12 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 4012) = 1 THEN common.efn_RandomText(thUserField12) ELSE thUserField12 END
		WHERE thAcCode = @iv_AnonymisationCode AND thDocType IN (0,2,3,4,5,6)

		-- Anonymise Sales Type Transaction Lines
		UPDATE [!ActiveSchema!].DETAILS WITH (READPAST)
			SET  tlUserField1 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 5001) = 1 THEN common.efn_RandomText(tlUserField1) ELSE tlUserField1 END
				,tlUserField2 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 5002) = 1 THEN common.efn_RandomText(tlUserField2) ELSE tlUserField2 END
				,tlUserField3 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 5003) = 1 THEN common.efn_RandomText(tlUserField3) ELSE tlUserField3 END
				,tlUserField4 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 5004) = 1 THEN common.efn_RandomText(tlUserField4) ELSE tlUserField4 END
				,tlUserField5 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 5005) = 1 THEN common.efn_RandomText(tlUserField5) ELSE tlUserField5 END
				,tlUserField6 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 5006) = 1 THEN common.efn_RandomText(tlUserField6) ELSE tlUserField6 END
				,tlUserField7 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 5007) = 1 THEN common.efn_RandomText(tlUserField7) ELSE tlUserField7 END
				,tlUserField8 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 5008) = 1 THEN common.efn_RandomText(tlUserField8) ELSE tlUserField8 END
				,tlUserField9 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 5009) = 1 THEN common.efn_RandomText(tlUserField9) ELSE tlUserField9 END
				,tlUserField10 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 5010) = 1 THEN common.efn_RandomText(tlUserField10) ELSE tlUserField10 END
		WHERE tlFolioNum IN (SELECT thFolioNum FROM [!ActiveSchema!].DOCUMENT WHERE thAcCode = @iv_AnonymisationCode AND thDocType IN (0,2,3,4,5,6))

		-- Anonymise Sales Receipt Transaction Headers
		UPDATE [!ActiveSchema!].DOCUMENT WITH (READPAST)
			SET  thUserField1 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 6001) = 1 THEN common.efn_RandomText(thUserField1) ELSE thUserField1 END
				,thUserField2 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 6002) = 1 THEN common.efn_RandomText(thUserField2) ELSE thUserField2 END
				,thUserField3 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 6003) = 1 THEN common.efn_RandomText(thUserField3) ELSE thUserField3 END
				,thUserField4 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 6004) = 1 THEN common.efn_RandomText(thUserField4) ELSE thUserField4 END
				,thUserField5 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 6005) = 1 THEN common.efn_RandomText(thUserField5) ELSE thUserField5 END
				,thUserField6 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 6006) = 1 THEN common.efn_RandomText(thUserField6) ELSE thUserField6 END
				,thUserField7 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 6007) = 1 THEN common.efn_RandomText(thUserField7) ELSE thUserField7 END
				,thUserField8 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 6008) = 1 THEN common.efn_RandomText(thUserField8) ELSE thUserField8 END
				,thUserField9 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 6009) = 1 THEN common.efn_RandomText(thUserField9) ELSE thUserField9 END
				,thUserField10 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 6010) = 1 THEN common.efn_RandomText(thUserField10) ELSE thUserField10 END
				,thUserField11 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 6011) = 1 THEN common.efn_RandomText(thUserField11) ELSE thUserField11 END
				,thUserField12 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 6012) = 1 THEN common.efn_RandomText(thUserField12) ELSE thUserField12 END
		WHERE thAcCode = @iv_AnonymisationCode AND thDocType = 1

		-- Anonymise Sales Receipt Transaction Lines
		UPDATE [!ActiveSchema!].DETAILS WITH (READPAST)
			SET  tlUserField1 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 7001) = 1 THEN common.efn_RandomText(tlUserField1) ELSE tlUserField1 END
				,tlUserField2 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 7002) = 1 THEN common.efn_RandomText(tlUserField2) ELSE tlUserField2 END
				,tlUserField3 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 7003) = 1 THEN common.efn_RandomText(tlUserField3) ELSE tlUserField3 END
				,tlUserField4 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 7004) = 1 THEN common.efn_RandomText(tlUserField4) ELSE tlUserField4 END
				,tlUserField5 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 7005) = 1 THEN common.efn_RandomText(tlUserField5) ELSE tlUserField5 END
				,tlUserField6 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 7006) = 1 THEN common.efn_RandomText(tlUserField6) ELSE tlUserField6 END
				,tlUserField7 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 7007) = 1 THEN common.efn_RandomText(tlUserField7) ELSE tlUserField7 END
				,tlUserField8 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 7008) = 1 THEN common.efn_RandomText(tlUserField8) ELSE tlUserField8 END
				,tlUserField9 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 7009) = 1 THEN common.efn_RandomText(tlUserField9) ELSE tlUserField9 END
				,tlUserField10 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 7010) = 1 THEN common.efn_RandomText(tlUserField10) ELSE tlUserField10 END
		WHERE tlFolioNum IN (SELECT thFolioNum FROM [!ActiveSchema!].DOCUMENT WHERE thAcCode = @iv_AnonymisationCode AND thDocType = 1)
		
		-- Anonymise Sales Quotation Transaction Headers
		UPDATE [!ActiveSchema!].DOCUMENT WITH (READPAST)
			SET  thUserField1 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 8001) = 1 THEN common.efn_RandomText(thUserField1) ELSE thUserField1 END
				,thUserField2 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 8002) = 1 THEN common.efn_RandomText(thUserField2) ELSE thUserField2 END
				,thUserField3 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 8003) = 1 THEN common.efn_RandomText(thUserField3) ELSE thUserField3 END
				,thUserField4 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 8004) = 1 THEN common.efn_RandomText(thUserField4) ELSE thUserField4 END
				,thUserField5 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 8005) = 1 THEN common.efn_RandomText(thUserField5) ELSE thUserField5 END
				,thUserField6 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 8006) = 1 THEN common.efn_RandomText(thUserField6) ELSE thUserField6 END
				,thUserField7 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 8007) = 1 THEN common.efn_RandomText(thUserField7) ELSE thUserField7 END
				,thUserField8 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 8008) = 1 THEN common.efn_RandomText(thUserField8) ELSE thUserField8 END
				,thUserField9 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 8009) = 1 THEN common.efn_RandomText(thUserField9) ELSE thUserField9 END
				,thUserField10 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 8010) = 1 THEN common.efn_RandomText(thUserField10) ELSE thUserField10 END
				,thUserField11 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 8011) = 1 THEN common.efn_RandomText(thUserField11) ELSE thUserField11 END
				,thUserField12 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 8012) = 1 THEN common.efn_RandomText(thUserField12) ELSE thUserField12 END
		WHERE thAcCode = @iv_AnonymisationCode AND thDocType = 7

		-- Anonymise Sales Quotation Transaction Lines
		UPDATE [!ActiveSchema!].DETAILS WITH (READPAST)
			SET  tlUserField1 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 9001) = 1 THEN common.efn_RandomText(tlUserField1) ELSE tlUserField1 END
				,tlUserField2 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 9002) = 1 THEN common.efn_RandomText(tlUserField2) ELSE tlUserField2 END
				,tlUserField3 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 9003) = 1 THEN common.efn_RandomText(tlUserField3) ELSE tlUserField3 END
				,tlUserField4 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 9004) = 1 THEN common.efn_RandomText(tlUserField4) ELSE tlUserField4 END
				,tlUserField5 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 9005) = 1 THEN common.efn_RandomText(tlUserField5) ELSE tlUserField5 END
				,tlUserField6 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 9006) = 1 THEN common.efn_RandomText(tlUserField6) ELSE tlUserField6 END
				,tlUserField7 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 9007) = 1 THEN common.efn_RandomText(tlUserField7) ELSE tlUserField7 END
				,tlUserField8 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 9008) = 1 THEN common.efn_RandomText(tlUserField8) ELSE tlUserField8 END
				,tlUserField9 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 9009) = 1 THEN common.efn_RandomText(tlUserField9) ELSE tlUserField9 END
				,tlUserField10 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 9010) = 1 THEN common.efn_RandomText(tlUserField10) ELSE tlUserField10 END
		WHERE tlFolioNum IN (SELECT thFolioNum FROM [!ActiveSchema!].DOCUMENT WHERE thAcCode = @iv_AnonymisationCode AND thDocType = 7)
		
		-- Anonymise Sales Order & Delivery Notes Transaction Headers
		UPDATE [!ActiveSchema!].DOCUMENT WITH (READPAST)
			SET  thUserField1 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 10001) = 1 THEN common.efn_RandomText(thUserField1) ELSE thUserField1 END
				,thUserField2 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 10002) = 1 THEN common.efn_RandomText(thUserField2) ELSE thUserField2 END
				,thUserField3 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 10003) = 1 THEN common.efn_RandomText(thUserField3) ELSE thUserField3 END
				,thUserField4 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 10004) = 1 THEN common.efn_RandomText(thUserField4) ELSE thUserField4 END
				,thUserField5 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 10005) = 1 THEN common.efn_RandomText(thUserField5) ELSE thUserField5 END
				,thUserField6 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 10006) = 1 THEN common.efn_RandomText(thUserField6) ELSE thUserField6 END
				,thUserField7 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 10007) = 1 THEN common.efn_RandomText(thUserField7) ELSE thUserField7 END
				,thUserField8 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 10008) = 1 THEN common.efn_RandomText(thUserField8) ELSE thUserField8 END
				,thUserField9 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 10009) = 1 THEN common.efn_RandomText(thUserField9) ELSE thUserField9 END
				,thUserField10 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 10010) = 1 THEN common.efn_RandomText(thUserField10) ELSE thUserField10 END
				,thUserField11 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 10011) = 1 THEN common.efn_RandomText(thUserField11) ELSE thUserField11 END
				,thUserField12 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 10012) = 1 THEN common.efn_RandomText(thUserField12) ELSE thUserField12 END
		WHERE thAcCode = @iv_AnonymisationCode AND thDocType IN (8,9)

		-- Anonymise Sales Order & Delivery Notes Transaction Lines
		UPDATE [!ActiveSchema!].DETAILS WITH (READPAST)
			SET  tlUserField1 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 11001) = 1 THEN common.efn_RandomText(tlUserField1) ELSE tlUserField1 END
				,tlUserField2 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 11002) = 1 THEN common.efn_RandomText(tlUserField2) ELSE tlUserField2 END
				,tlUserField3 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 11003) = 1 THEN common.efn_RandomText(tlUserField3) ELSE tlUserField3 END
				,tlUserField4 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 11004) = 1 THEN common.efn_RandomText(tlUserField4) ELSE tlUserField4 END
				,tlUserField5 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 11005) = 1 THEN common.efn_RandomText(tlUserField5) ELSE tlUserField5 END
				,tlUserField6 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 11006) = 1 THEN common.efn_RandomText(tlUserField6) ELSE tlUserField6 END
				,tlUserField7 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 11007) = 1 THEN common.efn_RandomText(tlUserField7) ELSE tlUserField7 END
				,tlUserField8 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 11008) = 1 THEN common.efn_RandomText(tlUserField8) ELSE tlUserField8 END
				,tlUserField9 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 11009) = 1 THEN common.efn_RandomText(tlUserField9) ELSE tlUserField9 END
				,tlUserField10 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 11010) = 1 THEN common.efn_RandomText(tlUserField10) ELSE tlUserField10 END
		WHERE tlFolioNum IN (SELECT thFolioNum FROM [!ActiveSchema!].DOCUMENT WHERE thAcCode = @iv_AnonymisationCode AND thDocType IN (8,9))
		
		-- Anonymise JST Transaction Headers
		UPDATE [!ActiveSchema!].DOCUMENT WITH (READPAST)
			SET  thDeliveryAddr1 = common.efn_RandomText(thDeliveryAddr1)
				,thDeliveryAddr2 = common.efn_RandomText(thDeliveryAddr2)
				,thDeliveryAddr3 = common.efn_RandomText(thDeliveryAddr3)
				,thDeliveryAddr4 = common.efn_RandomText(thDeliveryAddr4)
				,thDeliveryAddr5 = common.efn_RandomText(thDeliveryAddr5)
				,thDeliveryPostCode = common.efn_RandomText(thDeliveryPostCode)
				,thAnonymised = 1
				,thAnonymisedDate = CONVERT(varchar(8), GETDATE(), 112)
				,thAnonymisedTime = REPLACE(CONVERT(varchar(8),GetDate(), 108),':','')
				,thHoldFlag = CASE WHEN UPPER(@iv_OptionalParameters) LIKE '%DELETENOTES%'
								   THEN CASE WHEN thHoldFlag IN (32,33,34,35,36,37,38,160,161,162,163,164,165,166)
											 THEN thHoldFlag - 32
										ELSE thHoldFlag 
										END
								   ELSE thHoldFlag
							  END
		WHERE SUBSTRING(thBatchLink,3,6) = @iv_AnonymisationCode AND thDocType = 47


		UPDATE [!ActiveSchema!].DOCUMENT WITH (READPAST)
			SET  thUserField1 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 39001) = 1 THEN common.efn_RandomText(thUserField1) ELSE thUserField1 END
				,thUserField2 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 39002) = 1 THEN common.efn_RandomText(thUserField2) ELSE thUserField2 END
				,thUserField3 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 39003) = 1 THEN common.efn_RandomText(thUserField3) ELSE thUserField3 END
				,thUserField4 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 39004) = 1 THEN common.efn_RandomText(thUserField4) ELSE thUserField4 END
				,thUserField5 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 39005) = 1 THEN common.efn_RandomText(thUserField5) ELSE thUserField5 END
				,thUserField6 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 39006) = 1 THEN common.efn_RandomText(thUserField6) ELSE thUserField6 END
				,thUserField7 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 39007) = 1 THEN common.efn_RandomText(thUserField7) ELSE thUserField7 END
				,thUserField8 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 39008) = 1 THEN common.efn_RandomText(thUserField8) ELSE thUserField8 END
				,thUserField9 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 39009) = 1 THEN common.efn_RandomText(thUserField9) ELSE thUserField9 END
				,thUserField10 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 39010) = 1 THEN common.efn_RandomText(thUserField10) ELSE thUserField10 END
				,thUserField11 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 39011) = 1 THEN common.efn_RandomText(thUserField11) ELSE thUserField11 END
				,thUserField12 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 39012) = 1 THEN common.efn_RandomText(thUserField12) ELSE thUserField12 END
		WHERE SUBSTRING(thBatchLink,3,6) = @iv_AnonymisationCode AND thDocType = 47

		-- Anonymise JST Transaction Lines
		UPDATE [!ActiveSchema!].DETAILS WITH (READPAST)
			SET  tlUserField1 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 40001) = 1 THEN common.efn_RandomText(tlUserField1) ELSE tlUserField1 END
				,tlUserField2 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 40002) = 1 THEN common.efn_RandomText(tlUserField2) ELSE tlUserField2 END
				,tlUserField3 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 40003) = 1 THEN common.efn_RandomText(tlUserField3) ELSE tlUserField3 END
				,tlUserField4 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 40004) = 1 THEN common.efn_RandomText(tlUserField4) ELSE tlUserField4 END
				,tlUserField5 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 40005) = 1 THEN common.efn_RandomText(tlUserField5) ELSE tlUserField5 END
				,tlUserField6 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 40006) = 1 THEN common.efn_RandomText(tlUserField6) ELSE tlUserField6 END
				,tlUserField7 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 40007) = 1 THEN common.efn_RandomText(tlUserField7) ELSE tlUserField7 END
				,tlUserField8 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 40008) = 1 THEN common.efn_RandomText(tlUserField8) ELSE tlUserField8 END
				,tlUserField9 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 40009) = 1 THEN common.efn_RandomText(tlUserField9) ELSE tlUserField9 END
				,tlUserField10 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 40010) = 1 THEN common.efn_RandomText(tlUserField10) ELSE tlUserField10 END
		WHERE tlFolioNum IN (SELECT thFolioNum FROM [!ActiveSchema!].DOCUMENT WHERE SUBSTRING(thBatchLink,3,6) = @iv_AnonymisationCode AND thDocType = 47)

		-- Anonymise JSA Transaction Headers
		UPDATE [!ActiveSchema!].DOCUMENT WITH (READPAST)
			SET  thDeliveryAddr1 = common.efn_RandomText(thDeliveryAddr1)
				,thDeliveryAddr2 = common.efn_RandomText(thDeliveryAddr2)
				,thDeliveryAddr3 = common.efn_RandomText(thDeliveryAddr3)
				,thDeliveryAddr4 = common.efn_RandomText(thDeliveryAddr4)
				,thDeliveryAddr5 = common.efn_RandomText(thDeliveryAddr5)
				,thDeliveryPostCode = common.efn_RandomText(thDeliveryPostCode)
				,thAnonymised = 1
				,thAnonymisedDate = CONVERT(varchar(8), GETDATE(), 112)
				,thAnonymisedTime = REPLACE(CONVERT(varchar(8),GetDate(), 108),':','')
				,thHoldFlag = CASE WHEN UPPER(@iv_OptionalParameters) LIKE '%DELETENOTES%'
								   THEN CASE WHEN thHoldFlag IN (32,33,34,35,36,37,38,160,161,162,163,164,165,166)
											 THEN thHoldFlag - 32
										ELSE thHoldFlag 
										END
								   ELSE thHoldFlag
							  END
		WHERE SUBSTRING(thBatchLink,3,6) = @iv_AnonymisationCode AND thDocType = 49

		UPDATE [!ActiveSchema!].DOCUMENT WITH (READPAST)
			SET  thUserField1 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 43001) = 1 THEN common.efn_RandomText(thUserField1) ELSE thUserField1 END
				,thUserField2 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 43002) = 1 THEN common.efn_RandomText(thUserField2) ELSE thUserField2 END
				,thUserField3 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 43003) = 1 THEN common.efn_RandomText(thUserField3) ELSE thUserField3 END
				,thUserField4 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 43004) = 1 THEN common.efn_RandomText(thUserField4) ELSE thUserField4 END
				,thUserField5 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 43005) = 1 THEN common.efn_RandomText(thUserField5) ELSE thUserField5 END
				,thUserField6 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 43006) = 1 THEN common.efn_RandomText(thUserField6) ELSE thUserField6 END
				,thUserField7 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 43007) = 1 THEN common.efn_RandomText(thUserField7) ELSE thUserField7 END
				,thUserField8 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 43008) = 1 THEN common.efn_RandomText(thUserField8) ELSE thUserField8 END
				,thUserField9 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 43009) = 1 THEN common.efn_RandomText(thUserField9) ELSE thUserField9 END
				,thUserField10 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 43010) = 1 THEN common.efn_RandomText(thUserField10) ELSE thUserField10 END
				,thUserField11 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 43011) = 1 THEN common.efn_RandomText(thUserField11) ELSE thUserField11 END
				,thUserField12 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 43012) = 1 THEN common.efn_RandomText(thUserField12) ELSE thUserField12 END
		WHERE SUBSTRING(thBatchLink,3,6) = @iv_AnonymisationCode AND thDocType = 49

		-- Anonymise JSA Transaction Lines
		UPDATE [!ActiveSchema!].DETAILS WITH (READPAST)
			SET  tlUserField1 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 44001) = 1 THEN common.efn_RandomText(tlUserField1) ELSE tlUserField1 END
				,tlUserField2 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 44002) = 1 THEN common.efn_RandomText(tlUserField2) ELSE tlUserField2 END
				,tlUserField3 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 44003) = 1 THEN common.efn_RandomText(tlUserField3) ELSE tlUserField3 END
				,tlUserField4 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 44004) = 1 THEN common.efn_RandomText(tlUserField4) ELSE tlUserField4 END
				,tlUserField5 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 44005) = 1 THEN common.efn_RandomText(tlUserField5) ELSE tlUserField5 END
				,tlUserField6 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 44006) = 1 THEN common.efn_RandomText(tlUserField6) ELSE tlUserField6 END
				,tlUserField7 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 44007) = 1 THEN common.efn_RandomText(tlUserField7) ELSE tlUserField7 END
				,tlUserField8 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 44008) = 1 THEN common.efn_RandomText(tlUserField8) ELSE tlUserField8 END
				,tlUserField9 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 44009) = 1 THEN common.efn_RandomText(tlUserField9) ELSE tlUserField9 END
				,tlUserField10 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 44010) = 1 THEN common.efn_RandomText(tlUserField10) ELSE tlUserField10 END
		WHERE tlFolioNum IN (SELECT thFolioNum FROM [!ActiveSchema!].DOCUMENT WHERE SUBSTRING(thBatchLink,3,6) = @iv_AnonymisationCode AND thDocType = 49)

		-- Anonymise Sales Return Transaction Headers
		UPDATE [!ActiveSchema!].DOCUMENT WITH (READPAST)
			SET  thUserField1 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 31001) = 1 THEN common.efn_RandomText(thUserField1) ELSE thUserField1 END
				,thUserField2 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 31002) = 1 THEN common.efn_RandomText(thUserField2) ELSE thUserField2 END
				,thUserField3 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 31003) = 1 THEN common.efn_RandomText(thUserField3) ELSE thUserField3 END
				,thUserField4 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 31004) = 1 THEN common.efn_RandomText(thUserField4) ELSE thUserField4 END
				,thUserField5 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 31005) = 1 THEN common.efn_RandomText(thUserField5) ELSE thUserField5 END
				,thUserField6 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 31006) = 1 THEN common.efn_RandomText(thUserField6) ELSE thUserField6 END
				,thUserField7 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 31007) = 1 THEN common.efn_RandomText(thUserField7) ELSE thUserField7 END
				,thUserField8 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 31008) = 1 THEN common.efn_RandomText(thUserField8) ELSE thUserField8 END
				,thUserField9 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 31009) = 1 THEN common.efn_RandomText(thUserField9) ELSE thUserField9 END
				,thUserField10 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 31010) = 1 THEN common.efn_RandomText(thUserField10) ELSE thUserField10 END
				,thUserField11 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 31011) = 1 THEN common.efn_RandomText(thUserField11) ELSE thUserField11 END
				,thUserField12 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 31012) = 1 THEN common.efn_RandomText(thUserField12) ELSE thUserField12 END
		WHERE thAcCode = @iv_AnonymisationCode AND thDocType = 44

		-- Anonymise Sales Return Transaction Lines
		UPDATE [!ActiveSchema!].DETAILS WITH (READPAST)
			SET  tlUserField1 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 32001) = 1 THEN common.efn_RandomText(tlUserField1) ELSE tlUserField1 END
				,tlUserField2 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 32002) = 1 THEN common.efn_RandomText(tlUserField2) ELSE tlUserField2 END
				,tlUserField3 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 32003) = 1 THEN common.efn_RandomText(tlUserField3) ELSE tlUserField3 END
				,tlUserField4 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 32004) = 1 THEN common.efn_RandomText(tlUserField4) ELSE tlUserField4 END
				,tlUserField5 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 32005) = 1 THEN common.efn_RandomText(tlUserField5) ELSE tlUserField5 END
				,tlUserField6 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 32006) = 1 THEN common.efn_RandomText(tlUserField6) ELSE tlUserField6 END
				,tlUserField7 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 32007) = 1 THEN common.efn_RandomText(tlUserField7) ELSE tlUserField7 END
				,tlUserField8 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 32008) = 1 THEN common.efn_RandomText(tlUserField8) ELSE tlUserField8 END
				,tlUserField9 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 32009) = 1 THEN common.efn_RandomText(tlUserField9) ELSE tlUserField9 END
				,tlUserField10 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 32010) = 1 THEN common.efn_RandomText(tlUserField10) ELSE tlUserField10 END
		WHERE tlFolioNum IN (SELECT thFolioNum FROM [!ActiveSchema!].DOCUMENT WHERE thAcCode = @iv_AnonymisationCode AND thDocType = 44)
	END
	
	-- Anonymise Supplier Transactions
	ELSE IF @iv_AnonymisationType = 2
	BEGIN
		-- Anonymise Purchase Type Transaction Headers
		UPDATE [!ActiveSchema!].DOCUMENT WITH (READPAST)
			SET  thUserField1 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 12001) = 1 THEN common.efn_RandomText(thUserField1) ELSE thUserField1 END
				,thUserField2 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 12002) = 1 THEN common.efn_RandomText(thUserField2) ELSE thUserField2 END
				,thUserField3 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 12003) = 1 THEN common.efn_RandomText(thUserField3) ELSE thUserField3 END
				,thUserField4 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 12004) = 1 THEN common.efn_RandomText(thUserField4) ELSE thUserField4 END
				,thUserField5 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 12005) = 1 THEN common.efn_RandomText(thUserField5) ELSE thUserField5 END
				,thUserField6 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 12006) = 1 THEN common.efn_RandomText(thUserField6) ELSE thUserField6 END
				,thUserField7 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 12007) = 1 THEN common.efn_RandomText(thUserField7) ELSE thUserField7 END
				,thUserField8 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 12008) = 1 THEN common.efn_RandomText(thUserField8) ELSE thUserField8 END
				,thUserField9 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 12009) = 1 THEN common.efn_RandomText(thUserField9) ELSE thUserField9 END
				,thUserField10 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 12010) = 1 THEN common.efn_RandomText(thUserField10) ELSE thUserField10 END
				,thUserField11 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 12011) = 1 THEN common.efn_RandomText(thUserField11) ELSE thUserField11 END
				,thUserField12 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 12012) = 1 THEN common.efn_RandomText(thUserField12) ELSE thUserField12 END
		WHERE thAcCode = @iv_AnonymisationCode AND thDocType IN (15,17,18,19,20,21)

		-- Anonymise Purchase Type Transaction Lines
		UPDATE [!ActiveSchema!].DETAILS WITH (READPAST)
			SET  tlUserField1 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 13001) = 1 THEN common.efn_RandomText(tlUserField1) ELSE tlUserField1 END
				,tlUserField2 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 13002) = 1 THEN common.efn_RandomText(tlUserField2) ELSE tlUserField2 END
				,tlUserField3 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 13003) = 1 THEN common.efn_RandomText(tlUserField3) ELSE tlUserField3 END
				,tlUserField4 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 13004) = 1 THEN common.efn_RandomText(tlUserField4) ELSE tlUserField4 END
				,tlUserField5 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 13005) = 1 THEN common.efn_RandomText(tlUserField5) ELSE tlUserField5 END
				,tlUserField6 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 13006) = 1 THEN common.efn_RandomText(tlUserField6) ELSE tlUserField6 END
				,tlUserField7 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 13007) = 1 THEN common.efn_RandomText(tlUserField7) ELSE tlUserField7 END
				,tlUserField8 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 13008) = 1 THEN common.efn_RandomText(tlUserField8) ELSE tlUserField8 END
				,tlUserField9 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 13009) = 1 THEN common.efn_RandomText(tlUserField9) ELSE tlUserField9 END
				,tlUserField10 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 13010) = 1 THEN common.efn_RandomText(tlUserField10) ELSE tlUserField10 END
		WHERE tlFolioNum IN (SELECT thFolioNum FROM [!ActiveSchema!].DOCUMENT WHERE thAcCode = @iv_AnonymisationCode AND thDocType IN (15,17,18,19,20,21))

		-- Anonymise Purchase Payment Transaction Headers
		UPDATE [!ActiveSchema!].DOCUMENT WITH (READPAST)
			SET  thUserField1 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 14001) = 1 THEN common.efn_RandomText(thUserField1) ELSE thUserField1 END
				,thUserField2 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 14002) = 1 THEN common.efn_RandomText(thUserField2) ELSE thUserField2 END
				,thUserField3 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 14003) = 1 THEN common.efn_RandomText(thUserField3) ELSE thUserField3 END
				,thUserField4 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 14004) = 1 THEN common.efn_RandomText(thUserField4) ELSE thUserField4 END
				,thUserField5 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 14005) = 1 THEN common.efn_RandomText(thUserField5) ELSE thUserField5 END
				,thUserField6 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 14006) = 1 THEN common.efn_RandomText(thUserField6) ELSE thUserField6 END
				,thUserField7 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 14007) = 1 THEN common.efn_RandomText(thUserField7) ELSE thUserField7 END
				,thUserField8 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 14008) = 1 THEN common.efn_RandomText(thUserField8) ELSE thUserField8 END
				,thUserField9 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 14009) = 1 THEN common.efn_RandomText(thUserField9) ELSE thUserField9 END
				,thUserField10 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 14010) = 1 THEN common.efn_RandomText(thUserField10) ELSE thUserField10 END
				,thUserField11 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 14011) = 1 THEN common.efn_RandomText(thUserField11) ELSE thUserField11 END
				,thUserField12 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 14012) = 1 THEN common.efn_RandomText(thUserField12) ELSE thUserField12 END
		WHERE thAcCode = @iv_AnonymisationCode AND thDocType = 16

		-- Anonymise Purchase Payment Transaction Lines
		UPDATE [!ActiveSchema!].DETAILS WITH (READPAST)
			SET  tlUserField1 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 15001) = 1 THEN common.efn_RandomText(tlUserField1) ELSE tlUserField1 END
				,tlUserField2 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 15002) = 1 THEN common.efn_RandomText(tlUserField2) ELSE tlUserField2 END
				,tlUserField3 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 15003) = 1 THEN common.efn_RandomText(tlUserField3) ELSE tlUserField3 END
				,tlUserField4 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 15004) = 1 THEN common.efn_RandomText(tlUserField4) ELSE tlUserField4 END
				,tlUserField5 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 15005) = 1 THEN common.efn_RandomText(tlUserField5) ELSE tlUserField5 END
				,tlUserField6 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 15006) = 1 THEN common.efn_RandomText(tlUserField6) ELSE tlUserField6 END
				,tlUserField7 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 15007) = 1 THEN common.efn_RandomText(tlUserField7) ELSE tlUserField7 END
				,tlUserField8 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 15008) = 1 THEN common.efn_RandomText(tlUserField8) ELSE tlUserField8 END
				,tlUserField9 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 15009) = 1 THEN common.efn_RandomText(tlUserField9) ELSE tlUserField9 END
				,tlUserField10 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 15010) = 1 THEN common.efn_RandomText(tlUserField10) ELSE tlUserField10 END
		WHERE tlFolioNum IN (SELECT thFolioNum FROM [!ActiveSchema!].DOCUMENT WHERE thAcCode = @iv_AnonymisationCode AND thDocType = 16)
		
		-- Anonymise Purchase Quotation Transaction Headers
		UPDATE [!ActiveSchema!].DOCUMENT WITH (READPAST)
			SET  thUserField1 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 16001) = 1 THEN common.efn_RandomText(thUserField1) ELSE thUserField1 END
				,thUserField2 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 16002) = 1 THEN common.efn_RandomText(thUserField2) ELSE thUserField2 END
				,thUserField3 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 16003) = 1 THEN common.efn_RandomText(thUserField3) ELSE thUserField3 END
				,thUserField4 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 16004) = 1 THEN common.efn_RandomText(thUserField4) ELSE thUserField4 END
				,thUserField5 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 16005) = 1 THEN common.efn_RandomText(thUserField5) ELSE thUserField5 END
				,thUserField6 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 16006) = 1 THEN common.efn_RandomText(thUserField6) ELSE thUserField6 END
				,thUserField7 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 16007) = 1 THEN common.efn_RandomText(thUserField7) ELSE thUserField7 END
				,thUserField8 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 16008) = 1 THEN common.efn_RandomText(thUserField8) ELSE thUserField8 END
				,thUserField9 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 16009) = 1 THEN common.efn_RandomText(thUserField9) ELSE thUserField9 END
				,thUserField10 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 16010) = 1 THEN common.efn_RandomText(thUserField10) ELSE thUserField10 END
				,thUserField11 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 16011) = 1 THEN common.efn_RandomText(thUserField11) ELSE thUserField11 END
				,thUserField12 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 16012) = 1 THEN common.efn_RandomText(thUserField12) ELSE thUserField12 END
		WHERE thAcCode = @iv_AnonymisationCode AND thDocType = 22

		-- Anonymise Purchase Quotation Transaction Lines
		UPDATE [!ActiveSchema!].DETAILS WITH (READPAST)
			SET  tlUserField1 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 17001) = 1 THEN common.efn_RandomText(tlUserField1) ELSE tlUserField1 END
				,tlUserField2 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 17002) = 1 THEN common.efn_RandomText(tlUserField2) ELSE tlUserField2 END
				,tlUserField3 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 17003) = 1 THEN common.efn_RandomText(tlUserField3) ELSE tlUserField3 END
				,tlUserField4 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 17004) = 1 THEN common.efn_RandomText(tlUserField4) ELSE tlUserField4 END
				,tlUserField5 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 17005) = 1 THEN common.efn_RandomText(tlUserField5) ELSE tlUserField5 END
				,tlUserField6 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 17006) = 1 THEN common.efn_RandomText(tlUserField6) ELSE tlUserField6 END
				,tlUserField7 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 17007) = 1 THEN common.efn_RandomText(tlUserField7) ELSE tlUserField7 END
				,tlUserField8 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 17008) = 1 THEN common.efn_RandomText(tlUserField8) ELSE tlUserField8 END
				,tlUserField9 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 17009) = 1 THEN common.efn_RandomText(tlUserField9) ELSE tlUserField9 END
				,tlUserField10 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 17010) = 1 THEN common.efn_RandomText(tlUserField10) ELSE tlUserField10 END
		WHERE tlFolioNum IN (SELECT thFolioNum FROM [!ActiveSchema!].DOCUMENT WHERE thAcCode = @iv_AnonymisationCode AND thDocType = 22)
		
		-- Anonymise Purchase Order & Delivery Notes Transaction Headers
		UPDATE [!ActiveSchema!].DOCUMENT WITH (READPAST)
			SET  thUserField1 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 18001) = 1 THEN common.efn_RandomText(thUserField1) ELSE thUserField1 END
				,thUserField2 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 18002) = 1 THEN common.efn_RandomText(thUserField2) ELSE thUserField2 END
				,thUserField3 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 18003) = 1 THEN common.efn_RandomText(thUserField3) ELSE thUserField3 END
				,thUserField4 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 18004) = 1 THEN common.efn_RandomText(thUserField4) ELSE thUserField4 END
				,thUserField5 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 18005) = 1 THEN common.efn_RandomText(thUserField5) ELSE thUserField5 END
				,thUserField6 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 18006) = 1 THEN common.efn_RandomText(thUserField6) ELSE thUserField6 END
				,thUserField7 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 18007) = 1 THEN common.efn_RandomText(thUserField7) ELSE thUserField7 END
				,thUserField8 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 18008) = 1 THEN common.efn_RandomText(thUserField8) ELSE thUserField8 END
				,thUserField9 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 18009) = 1 THEN common.efn_RandomText(thUserField9) ELSE thUserField9 END
				,thUserField10 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 18010) = 1 THEN common.efn_RandomText(thUserField10) ELSE thUserField10 END
				,thUserField11 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 18011) = 1 THEN common.efn_RandomText(thUserField11) ELSE thUserField11 END
				,thUserField12 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 18012) = 1 THEN common.efn_RandomText(thUserField12) ELSE thUserField12 END
		WHERE thAcCode = @iv_AnonymisationCode AND thDocType IN (23,24)

		-- Anonymise Purchase Order & Delivery Notes Transaction Lines
		UPDATE [!ActiveSchema!].DETAILS WITH (READPAST)
			SET  tlUserField1 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 19001) = 1 THEN common.efn_RandomText(tlUserField1) ELSE tlUserField1 END
				,tlUserField2 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 19002) = 1 THEN common.efn_RandomText(tlUserField2) ELSE tlUserField2 END
				,tlUserField3 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 19003) = 1 THEN common.efn_RandomText(tlUserField3) ELSE tlUserField3 END
				,tlUserField4 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 19004) = 1 THEN common.efn_RandomText(tlUserField4) ELSE tlUserField4 END
				,tlUserField5 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 19005) = 1 THEN common.efn_RandomText(tlUserField5) ELSE tlUserField5 END
				,tlUserField6 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 19006) = 1 THEN common.efn_RandomText(tlUserField6) ELSE tlUserField6 END
				,tlUserField7 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 19007) = 1 THEN common.efn_RandomText(tlUserField7) ELSE tlUserField7 END
				,tlUserField8 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 19008) = 1 THEN common.efn_RandomText(tlUserField8) ELSE tlUserField8 END
				,tlUserField9 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 19009) = 1 THEN common.efn_RandomText(tlUserField9) ELSE tlUserField9 END
				,tlUserField10 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 19010) = 1 THEN common.efn_RandomText(tlUserField10) ELSE tlUserField10 END
		WHERE tlFolioNum IN (SELECT thFolioNum FROM [!ActiveSchema!].DOCUMENT WHERE thAcCode = @iv_AnonymisationCode AND thDocType IN (23,24))

		-- Anonymise Purchase Return Transaction Headers
		UPDATE [!ActiveSchema!].DOCUMENT WITH (READPAST)
			SET  thUserField1 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 33001) = 1 THEN common.efn_RandomText(thUserField1) ELSE thUserField1 END
				,thUserField2 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 33002) = 1 THEN common.efn_RandomText(thUserField2) ELSE thUserField2 END
				,thUserField3 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 33003) = 1 THEN common.efn_RandomText(thUserField3) ELSE thUserField3 END
				,thUserField4 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 33004) = 1 THEN common.efn_RandomText(thUserField4) ELSE thUserField4 END
				,thUserField5 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 33005) = 1 THEN common.efn_RandomText(thUserField5) ELSE thUserField5 END
				,thUserField6 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 33006) = 1 THEN common.efn_RandomText(thUserField6) ELSE thUserField6 END
				,thUserField7 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 33007) = 1 THEN common.efn_RandomText(thUserField7) ELSE thUserField7 END
				,thUserField8 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 33008) = 1 THEN common.efn_RandomText(thUserField8) ELSE thUserField8 END
				,thUserField9 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 33009) = 1 THEN common.efn_RandomText(thUserField9) ELSE thUserField9 END
				,thUserField10 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 33010) = 1 THEN common.efn_RandomText(thUserField10) ELSE thUserField10 END
				,thUserField11 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 33011) = 1 THEN common.efn_RandomText(thUserField11) ELSE thUserField11 END
				,thUserField12 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 33012) = 1 THEN common.efn_RandomText(thUserField12) ELSE thUserField12 END
		WHERE thAcCode = @iv_AnonymisationCode AND thDocType = 45

		-- Anonymise Purchase Return Transaction Lines
		UPDATE [!ActiveSchema!].DETAILS WITH (READPAST)
			SET  tlUserField1 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 34001) = 1 THEN common.efn_RandomText(tlUserField1) ELSE tlUserField1 END
				,tlUserField2 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 34002) = 1 THEN common.efn_RandomText(tlUserField2) ELSE tlUserField2 END
				,tlUserField3 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 34003) = 1 THEN common.efn_RandomText(tlUserField3) ELSE tlUserField3 END
				,tlUserField4 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 34004) = 1 THEN common.efn_RandomText(tlUserField4) ELSE tlUserField4 END
				,tlUserField5 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 34005) = 1 THEN common.efn_RandomText(tlUserField5) ELSE tlUserField5 END
				,tlUserField6 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 34006) = 1 THEN common.efn_RandomText(tlUserField6) ELSE tlUserField6 END
				,tlUserField7 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 34007) = 1 THEN common.efn_RandomText(tlUserField7) ELSE tlUserField7 END
				,tlUserField8 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 34008) = 1 THEN common.efn_RandomText(tlUserField8) ELSE tlUserField8 END
				,tlUserField9 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 34009) = 1 THEN common.efn_RandomText(tlUserField9) ELSE tlUserField9 END
				,tlUserField10 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 34010) = 1 THEN common.efn_RandomText(tlUserField10) ELSE tlUserField10 END
		WHERE tlFolioNum IN (SELECT thFolioNum FROM [!ActiveSchema!].DOCUMENT WHERE thAcCode = @iv_AnonymisationCode AND thDocType = 45)
	END
	ELSE IF @iv_AnonymisationType = 3 -- Employee
	BEGIN
		-- Anonymise Timesheets
		UPDATE [!ActiveSchema!].DOCUMENT WITH (READPAST)
			SET  thDeliveryAddr1 = common.efn_RandomText(thDeliveryAddr1)
				,thDeliveryAddr2 = common.efn_RandomText(thDeliveryAddr2)
				,thDeliveryAddr3 = common.efn_RandomText(thDeliveryAddr3)
				,thDeliveryAddr4 = common.efn_RandomText(thDeliveryAddr4)
				,thDeliveryAddr5 = common.efn_RandomText(thDeliveryAddr5)
				,thDeliveryPostCode = common.efn_RandomText(thDeliveryPostCode)
				,thAnonymised = 1
				,thAnonymisedDate = CONVERT(varchar(8), GETDATE(), 112)
				,thAnonymisedTime = REPLACE(CONVERT(varchar(8),GetDate(), 108),':','')
				,thHoldFlag = CASE WHEN UPPER(@iv_OptionalParameters) LIKE '%DELETENOTES%'
								   THEN CASE WHEN thHoldFlag IN (32,33,34,35,36,37,38,160,161,162,163,164,165,166)
											 THEN thHoldFlag - 32
										ELSE thHoldFlag 
										END
								   ELSE thHoldFlag
							  END
		WHERE thBatchLinkTrans = @iv_AnonymisationCode AND thDocType = 41

		UPDATE [!ActiveSchema!].DOCUMENT WITH (READPAST)
			SET  thUserField1 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 29001) = 1 THEN common.efn_RandomText(thUserField1) ELSE thUserField1 END
				,thUserField2 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 29002) = 1 THEN common.efn_RandomText(thUserField2) ELSE thUserField2 END
				,thUserField3 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 29003) = 1 THEN common.efn_RandomText(thUserField3) ELSE thUserField3 END
				,thUserField4 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 29004) = 1 THEN common.efn_RandomText(thUserField4) ELSE thUserField4 END
				,thUserField5 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 29005) = 1 THEN common.efn_RandomText(thUserField5) ELSE thUserField5 END
				,thUserField6 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 29006) = 1 THEN common.efn_RandomText(thUserField6) ELSE thUserField6 END
				,thUserField7 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 29007) = 1 THEN common.efn_RandomText(thUserField7) ELSE thUserField7 END
				,thUserField8 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 29008) = 1 THEN common.efn_RandomText(thUserField8) ELSE thUserField8 END
				,thUserField9 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 29009) = 1 THEN common.efn_RandomText(thUserField9) ELSE thUserField9 END
				,thUserField10 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 29010) = 1 THEN common.efn_RandomText(thUserField10) ELSE thUserField10 END
				,thUserField11 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 29011) = 1 THEN common.efn_RandomText(thUserField11) ELSE thUserField11 END
				,thUserField12 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 29012) = 1 THEN common.efn_RandomText(thUserField12) ELSE thUserField12 END
		WHERE thBatchLinkTrans = @iv_AnonymisationCode AND thDocType = 41

		-- Anonymise Timesheet Transaction Lines
		UPDATE [!ActiveSchema!].DETAILS WITH (READPAST)
			SET  tlUserField1 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 30001) = 1 THEN common.efn_RandomText(tlUserField1) ELSE tlUserField1 END
				,tlUserField2 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 30002) = 1 THEN common.efn_RandomText(tlUserField2) ELSE tlUserField2 END
				,tlUserField3 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 30003) = 1 THEN common.efn_RandomText(tlUserField3) ELSE tlUserField3 END
				,tlUserField4 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 30004) = 1 THEN common.efn_RandomText(tlUserField4) ELSE tlUserField4 END
				,tlUserField5 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 30005) = 1 THEN common.efn_RandomText(tlUserField5) ELSE tlUserField5 END
				,tlUserField6 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 30006) = 1 THEN common.efn_RandomText(tlUserField6) ELSE tlUserField6 END
				,tlUserField7 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 30007) = 1 THEN common.efn_RandomText(tlUserField7) ELSE tlUserField7 END
				,tlUserField8 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 30008) = 1 THEN common.efn_RandomText(tlUserField8) ELSE tlUserField8 END
				,tlUserField9 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 30009) = 1 THEN common.efn_RandomText(tlUserField9) ELSE tlUserField9 END
				,tlUserField10 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 30010) = 1 THEN common.efn_RandomText(tlUserField10) ELSE tlUserField10 END
		WHERE tlFolioNum IN (SELECT thFolioNum FROM [!ActiveSchema!].DOCUMENT WHERE thBatchLinkTrans = @iv_AnonymisationCode AND thDocType = 41)

		-- Anonymise Jxx transactions
		UPDATE [!ActiveSchema!].DOCUMENT WITH (READPAST)
			SET  thDeliveryAddr1 = common.efn_RandomText(thDeliveryAddr1)
				,thDeliveryAddr2 = common.efn_RandomText(thDeliveryAddr2)
				,thDeliveryAddr3 = common.efn_RandomText(thDeliveryAddr3)
				,thDeliveryAddr4 = common.efn_RandomText(thDeliveryAddr4)
				,thDeliveryAddr5 = common.efn_RandomText(thDeliveryAddr5)
				,thDeliveryPostCode = common.efn_RandomText(thDeliveryPostCode)
				,thAnonymised = 1
				,thAnonymisedDate = CONVERT(varchar(8), GETDATE(), 112)
				,thAnonymisedTime = REPLACE(CONVERT(varchar(8),GetDate(), 108),':','')
				,thHoldFlag = CASE WHEN UPPER(@iv_OptionalParameters) LIKE '%DELETENOTES%'
								   THEN CASE WHEN thHoldFlag IN (32,33,34,35,36,37,38,160,161,162,163,164,165,166)
											 THEN thHoldFlag - 32
										ELSE thHoldFlag 
										END
								   ELSE thHoldFlag
							  END
		WHERE SUBSTRING(thBatchLink,3,6) = @iv_AnonymisationCode AND thDocType IN (46, 50)

		-- Anonymise JPA
		UPDATE [!ActiveSchema!].DOCUMENT WITH (READPAST)
			SET  thUserField1 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 41001) = 1 THEN common.efn_RandomText(thUserField1) ELSE thUserField1 END
				,thUserField2 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 41002) = 1 THEN common.efn_RandomText(thUserField2) ELSE thUserField2 END
				,thUserField3 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 41003) = 1 THEN common.efn_RandomText(thUserField3) ELSE thUserField3 END
				,thUserField4 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 41004) = 1 THEN common.efn_RandomText(thUserField4) ELSE thUserField4 END
				,thUserField5 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 41005) = 1 THEN common.efn_RandomText(thUserField5) ELSE thUserField5 END
				,thUserField6 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 41006) = 1 THEN common.efn_RandomText(thUserField6) ELSE thUserField6 END
				,thUserField7 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 41007) = 1 THEN common.efn_RandomText(thUserField7) ELSE thUserField7 END
				,thUserField8 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 41008) = 1 THEN common.efn_RandomText(thUserField8) ELSE thUserField8 END
				,thUserField9 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 41009) = 1 THEN common.efn_RandomText(thUserField9) ELSE thUserField9 END
				,thUserField10 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 41010) = 1 THEN common.efn_RandomText(thUserField10) ELSE thUserField10 END
				,thUserField11 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 41011) = 1 THEN common.efn_RandomText(thUserField11) ELSE thUserField11 END
				,thUserField12 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 41012) = 1 THEN common.efn_RandomText(thUserField12) ELSE thUserField12 END
		WHERE substring(thBatchLink,3,6) = @iv_AnonymisationCode AND thDocType = 50

		-- Anonymise JPA Transaction Lines
		UPDATE [!ActiveSchema!].DETAILS WITH (READPAST)
			SET  tlUserField1 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 42001) = 1 THEN common.efn_RandomText(tlUserField1) ELSE tlUserField1 END
				,tlUserField2 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 42002) = 1 THEN common.efn_RandomText(tlUserField2) ELSE tlUserField2 END
				,tlUserField3 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 42003) = 1 THEN common.efn_RandomText(tlUserField3) ELSE tlUserField3 END
				,tlUserField4 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 42004) = 1 THEN common.efn_RandomText(tlUserField4) ELSE tlUserField4 END
				,tlUserField5 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 42005) = 1 THEN common.efn_RandomText(tlUserField5) ELSE tlUserField5 END
				,tlUserField6 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 42006) = 1 THEN common.efn_RandomText(tlUserField6) ELSE tlUserField6 END
				,tlUserField7 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 42007) = 1 THEN common.efn_RandomText(tlUserField7) ELSE tlUserField7 END
				,tlUserField8 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 42008) = 1 THEN common.efn_RandomText(tlUserField8) ELSE tlUserField8 END
				,tlUserField9 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 42009) = 1 THEN common.efn_RandomText(tlUserField9) ELSE tlUserField9 END
				,tlUserField10 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 42010) = 1 THEN common.efn_RandomText(tlUserField10) ELSE tlUserField10 END
		WHERE tlFolioNum IN (SELECT thFolioNum FROM [!ActiveSchema!].DOCUMENT WHERE substring(thBatchLink,3,6) = @iv_AnonymisationCode AND thDocType = 50)

		-- Anonymise JCT
		UPDATE [!ActiveSchema!].DOCUMENT WITH (READPAST)
			SET  thUserField1 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 35001) = 1 THEN common.efn_RandomText(thUserField1) ELSE thUserField1 END
				,thUserField2 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 35002) = 1 THEN common.efn_RandomText(thUserField2) ELSE thUserField2 END
				,thUserField3 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 35003) = 1 THEN common.efn_RandomText(thUserField3) ELSE thUserField3 END
				,thUserField4 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 35004) = 1 THEN common.efn_RandomText(thUserField4) ELSE thUserField4 END
				,thUserField5 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 35005) = 1 THEN common.efn_RandomText(thUserField5) ELSE thUserField5 END
				,thUserField6 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 35006) = 1 THEN common.efn_RandomText(thUserField6) ELSE thUserField6 END
				,thUserField7 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 35007) = 1 THEN common.efn_RandomText(thUserField7) ELSE thUserField7 END
				,thUserField8 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 35008) = 1 THEN common.efn_RandomText(thUserField8) ELSE thUserField8 END
				,thUserField9 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 35009) = 1 THEN common.efn_RandomText(thUserField9) ELSE thUserField9 END
				,thUserField10 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 35010) = 1 THEN common.efn_RandomText(thUserField10) ELSE thUserField10 END
				,thUserField11 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 35011) = 1 THEN common.efn_RandomText(thUserField11) ELSE thUserField11 END
				,thUserField12 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 35012) = 1 THEN common.efn_RandomText(thUserField12) ELSE thUserField12 END
		WHERE substring(thBatchLink,3,6) = @iv_AnonymisationCode AND thDocType = 46

		-- Anonymise JCT Transaction Lines
		UPDATE [!ActiveSchema!].DETAILS WITH (READPAST)
			SET  tlUserField1 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 36001) = 1 THEN common.efn_RandomText(tlUserField1) ELSE tlUserField1 END
				,tlUserField2 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 36002) = 1 THEN common.efn_RandomText(tlUserField2) ELSE tlUserField2 END
				,tlUserField3 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 36003) = 1 THEN common.efn_RandomText(tlUserField3) ELSE tlUserField3 END
				,tlUserField4 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 36004) = 1 THEN common.efn_RandomText(tlUserField4) ELSE tlUserField4 END
				,tlUserField5 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 36005) = 1 THEN common.efn_RandomText(tlUserField5) ELSE tlUserField5 END
				,tlUserField6 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 36006) = 1 THEN common.efn_RandomText(tlUserField6) ELSE tlUserField6 END
				,tlUserField7 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 36007) = 1 THEN common.efn_RandomText(tlUserField7) ELSE tlUserField7 END
				,tlUserField8 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 36008) = 1 THEN common.efn_RandomText(tlUserField8) ELSE tlUserField8 END
				,tlUserField9 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 36009) = 1 THEN common.efn_RandomText(tlUserField9) ELSE tlUserField9 END
				,tlUserField10 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 36010) = 1 THEN common.efn_RandomText(tlUserField10) ELSE tlUserField10 END
		WHERE tlFolioNum IN (SELECT thFolioNum FROM [!ActiveSchema!].DOCUMENT WHERE substring(thBatchLink,3,6) = @iv_AnonymisationCode AND thDocType = 46)

	END

		-- Anonymise generic eBusiness transaction fields
	UPDATE [!ActiveSchema!].EBUSDOC WITH (READPAST)
		SET  thDeliveryAddr1 = common.efn_RandomText(thDeliveryAddr1)
			,thDeliveryAddr2 = common.efn_RandomText(thDeliveryAddr2)
			,thDeliveryAddr3 = common.efn_RandomText(thDeliveryAddr3)
			,thDeliveryAddr4 = common.efn_RandomText(thDeliveryAddr4)
			,thDeliveryAddr5 = common.efn_RandomText(thDeliveryAddr5)
			,thDeliveryPostCode = common.efn_RandomText(thDeliveryPostCode)
			,thAnonymised = 1
			,thAnonymisedDate = CONVERT(varchar(8), GETDATE(), 112)
			,thAnonymisedTime = REPLACE(CONVERT(varchar(8),GetDate(), 108),':','')
			,thHoldFlag = CASE WHEN UPPER(@iv_OptionalParameters) LIKE '%DELETENOTES%'
							   THEN CASE WHEN thHoldFlag IN (32,33,34,35,36,37,38,160,161,162,163,164,165,166)
										 THEN thHoldFlag - 32
									ELSE thHoldFlag 
									END
							   ELSE thHoldFlag
						  END
		WHERE thAcCode = @iv_AnonymisationCode

	
END
GO


