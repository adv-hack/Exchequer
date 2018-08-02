--/////////////////////////////////////////////////////////////////////////////
--// Filename			: !ActiveSchema!.esp_AnonymiseTrader
--// Author				: James Waygood 
--// Date				: 12th December 2017 
--// Copyright Notice	: (c) 2017 Advanced Business Software & Solutions Ltd. All rights reserved.
--// Description		: SQL Script to anonymise GDPR Trader data within Exchequer
--// Execute			: EXEC [!ActiveSchema!].[esp_AnonymiseTrader] 1, 'ABAP01'
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	: File Creation
--//	2	: Added setting of Anonymisation Status, Date and Time
--//
--/////////////////////////////////////////////////////////////////////////////

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[esp_AnonymiseTrader]') AND type in (N'P', N'PC'))
DROP PROCEDURE [!ActiveSchema!].[esp_AnonymiseTrader]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [!ActiveSchema!].[esp_AnonymiseTrader] 
(
	@iv_AnonymisationType	int = 1,			-- 1=Customer/Consumer, 2=Supplier
	@iv_AnonymisationCode	varchar(10) = '',	-- Trader Code 
	@iv_OptionalParameters	varchar(200) = ''	-- DeleteNotes, DeleteLetters, DeleteLinks -- CSV
)
AS
BEGIN
	/* DEBUG
	DECLARE @iv_AnonymisationType	int = 1
	DECLARE @iv_AnonymisationCode	varchar(10) = ''
	DECLARE @iv_OptionalParameters = 'DeleteNotes'
	*/

	UPDATE [!ActiveSchema!].CUSTSUPP WITH (READPAST)
	SET   acCompany = common.efn_RandomText(acCompany)
		, acContact = common.efn_RandomText(acContact)
		, acAddressLine1 = common.efn_RandomText(acAddressLine1)
		, acAddressLine2 = common.efn_RandomText(acAddressLine2)
		, acAddressLine3 = common.efn_RandomText(acAddressLine3)
		, acAddressLine4 = common.efn_RandomText(acAddressLine4)
		, acAddressLine5 = common.efn_RandomText(acAddressLine5)
		, acPostCode = common.efn_RandomText(acPostCode)
		, acEmailAddr = ''
		, acPhone   = ''
		, acFax     = ''
		, acPhone2  = ''
		, acDespAddressLine1 = common.efn_RandomText(acDespAddressLine1)
		, acDespAddressLine2 = common.efn_RandomText(acDespAddressLine2)
		, acDespAddressLine3 = common.efn_RandomText(acDespAddressLine3)
		, acDespAddressLine4 = common.efn_RandomText(acDespAddressLine4)
		, acDespAddressLine5 = common.efn_RandomText(acDespAddressLine5)
		, acDeliveryPostCode = common.efn_RandomText(acDeliveryPostCode)
		, acTheirAcc = common.efn_RandomText(acTheirAcc)
		, acVATRegNo = ''
		, acBankAccountCode  = 0x00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
		, acBankSortCode = 0x0000000000000000000000000000000000000000000000
		, acMandateID = 0x00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
		, acMandateDate = ''
		, acBankRef  = common.efn_RandomText(acBankRef)
		, acCCNumber = common.efn_RandomText(acCCNumber)
		, acEBusPword = ''
		, acAnonymisationStatus = 2
		, acAnonymisedDate = CONVERT(varchar(8), GETDATE(), 112)
		, acAnonymisedTime = REPLACE(CONVERT(varchar(8),GetDate(), 108),':','')
	WHERE acCode = @iv_AnonymisationCode
	
	-- Anonymise User Defined Fields if CII - Customer/Consumer
	IF @iv_AnonymisationType = 1
	BEGIN
		UPDATE [!ActiveSchema!].CUSTSUPP WITH (READPAST)
		SET  acUserDef1 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 1001) = 1 THEN common.efn_RandomText(acUserDef1) ELSE acUserDef1 END
			,acUserDef2 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 1002) = 1 THEN common.efn_RandomText(acUserDef2) ELSE acUserDef2 END
			,acUserDef3 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 1003) = 1 THEN common.efn_RandomText(acUserDef3) ELSE acUserDef3 END
			,acUserDef4 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 1004) = 1 THEN common.efn_RandomText(acUserDef4) ELSE acUserDef4 END
			,acUserDef5 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 1005) = 1 THEN common.efn_RandomText(acUserDef5) ELSE acUserDef5 END
			,acUserDef6 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 1006) = 1 THEN common.efn_RandomText(acUserDef6) ELSE acUserDef6 END
			,acUserDef7 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 1007) = 1 THEN common.efn_RandomText(acUserDef7) ELSE acUserDef7 END
			,acUserDef8 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 1008) = 1 THEN common.efn_RandomText(acUserDef8) ELSE acUserDef8 END
			,acUserDef9 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 1009) = 1 THEN common.efn_RandomText(acUserDef9) ELSE acUserDef9 END
			,acUserDef10 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 1010) = 1 THEN common.efn_RandomText(acUserDef10) ELSE acUserDef10 END
			,acCCNumber = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 1011) = 1 THEN common.efn_RandomText(acCCNumber) ELSE acCCNumber END
			,acCCStart = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 1012) = 1 THEN '' ELSE acCCStart END
			,acCCEnd = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 1013) = 1 THEN '' ELSE acCCEnd END
			,acCCName = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 1014) = 1 THEN common.efn_RandomText(acCCName) ELSE acCCName END
			,acCCSwitch = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 1015) = 1 THEN common.efn_RandomText(acCCSwitch) ELSE acCCSwitch END
		WHERE acCode = @iv_AnonymisationCode
	END	

	-- Anonymise User Defined Fields if CII - Supplier
	IF @iv_AnonymisationType = 2
	BEGIN
		UPDATE [!ActiveSchema!].CUSTSUPP WITH (READPAST)
		SET  acUserDef1 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 2001) = 1 THEN common.efn_RandomText(acUserDef1) ELSE acUserDef1 END
			,acUserDef2 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 2002) = 1 THEN common.efn_RandomText(acUserDef2) ELSE acUserDef2 END
			,acUserDef3 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 2003) = 1 THEN common.efn_RandomText(acUserDef3) ELSE acUserDef3 END
			,acUserDef4 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 2004) = 1 THEN common.efn_RandomText(acUserDef4) ELSE acUserDef4 END
			,acUserDef5 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 2005) = 1 THEN common.efn_RandomText(acUserDef5) ELSE acUserDef5 END
			,acUserDef6 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 2006) = 1 THEN common.efn_RandomText(acUserDef6) ELSE acUserDef6 END
			,acUserDef7 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 2007) = 1 THEN common.efn_RandomText(acUserDef7) ELSE acUserDef7 END
			,acUserDef8 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 2008) = 1 THEN common.efn_RandomText(acUserDef8) ELSE acUserDef8 END
			,acUserDef9 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 2009) = 1 THEN common.efn_RandomText(acUserDef9) ELSE acUserDef9 END
			,acUserDef10 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 2010) = 1 THEN common.efn_RandomText(acUserDef10) ELSE acUserDef10 END
			,acCCNumber = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 2011) = 1 THEN common.efn_RandomText(acCCNumber) ELSE acCCNumber END
			,acCCStart = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 2012) = 1 THEN '' ELSE acCCStart END
			,acCCEnd = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 2013) = 1 THEN '' ELSE acCCEnd END
			,acCCName = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 2014) = 1 THEN common.efn_RandomText(acCCName) ELSE acCCName END
			,acCCSwitch = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 2015) = 1 THEN common.efn_RandomText(acCCSwitch) ELSE acCCSwitch END
		WHERE acCode = @iv_AnonymisationCode
	END	
	
	
	UPDATE [!ActiveSchema!].AccountContact  WITH (READPAST)
	SET   acoContactName = common.efn_RandomText(acoContactName)
		, acoContactJobTitle = common.efn_RandomText(acoContactJobTitle)
		, acoContactPhoneNumber   = ''
		, acoContactFaxNumber     = ''
		, acoContactEmailAddress  = ''
		, acoContactAddress1 = common.efn_RandomText(acoContactAddress1)
		, acoContactAddress2 = common.efn_RandomText(acoContactAddress2)
		, acoContactAddress3 = common.efn_RandomText(acoContactAddress3)
		, acoContactAddress4 = common.efn_RandomText(acoContactAddress4)
		, acoContactAddress5 = common.efn_RandomText(acoContactAddress5)
		, acoContactPostCode = common.efn_RandomText(acoContactPostCode)
	WHERE acoAccountCode = @iv_AnonymisationCode
		
	-- Anonymise entity related Contacts in Contacts Plug-In table
	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES 
				WHERE TABLE_SCHEMA = 'common' 
				AND  TABLE_NAME = 'CONTACT'))
	BEGIN
		UPDATE [common].Contact WITH (READPAST)
		SET coFirstName = common.efn_RandomText(coFirstName)
			, coSurname = common.efn_RandomText(coSurname)
			, coPosition = common.efn_RandomText(coPosition)
			, coTitle = common.efn_RandomText(coTitle)
			, coSalutation = common.efn_RandomText(coSalutation)
			, coContactNo   = ''
			, coFaxNumber     = ''
			, coEmailAddr  = ''
			, coAddress1 = common.efn_RandomText(coAddress1)
			, coAddress2 = common.efn_RandomText(coAddress2)
			, coAddress3 = common.efn_RandomText(coAddress3)
			, coAddress4 = common.efn_RandomText(coAddress4)
			, coPostCode = common.efn_RandomText(coPostCode)
		WHERE coAccount = @iv_AnonymisationCode and coCompany = '!ActiveSchema!'
	END



	-- Delete/Anonymise Notes
	IF upper(@iv_OptionalParameters) LIKE '%DELETENOTES%' OR upper(@iv_OptionalParameters) LIKE '%ANONYMISENOTES%'
		EXEC [!ActiveSchema!].esp_AnonymiseNotes @iv_AnonymisationType, @iv_AnonymisationCode, @iv_OptionalParameters
			
	-- Delete/Anonymise Letters
	IF upper(@iv_OptionalParameters) LIKE '%DELETELETTERS%' OR upper(@iv_OptionalParameters) LIKE '%ANONYMISELETTERS%'
		EXEC [!ActiveSchema!].esp_AnonymiseLetters @iv_AnonymisationType, @iv_AnonymisationCode, @iv_OptionalParameters
			
	-- Delete/Anonymise Links
	IF upper(@iv_OptionalParameters) LIKE '%DELETELINKS%' OR upper(@iv_OptionalParameters) LIKE '%ANONYMISELINKS%'
		EXEC [!ActiveSchema!].esp_AnonymiseLinks @iv_AnonymisationType, @iv_AnonymisationCode, @iv_OptionalParameters

	-- Anonymise Customer/Consumer Jobs
	IF  @iv_AnonymisationType = 1
	BEGIN
		DECLARE @JobFolio int = 0

		DECLARE JobList CURSOR FOR	(SELECT JobFolio FROM [!ActiveSchema!].JOBHEAD
										 WHERE CustCode = @iv_AnonymisationCode)
									FOR READ ONLY

		OPEN JobList
		
		FETCH NEXT FROM JobList INTO @JobFolio

		WHILE @@fetch_status = 0
		BEGIN
			EXEC [!ActiveSchema!].esp_AnonymiseTraderJobs @JobFolio, @iv_OptionalParameters

			FETCH NEXT FROM JobList INTO @JobFolio
		END

		CLOSE JobList
		DEALLOCATE JobList
	END

	-- Anonymise Employee
	IF @iv_AnonymisationType = 2
	BEGIN
		DECLARE @EmployeeCode varchar(10) = ''
		DECLARE @iv_OptionalEmployeeParameters varchar(100)

		DECLARE @DeleteLetters int
		DECLARE @DeleteLinks int
		DECLARE @DeleteNotes int
		
		SELECT @DeleteLetters = sysValue FROM [!ActiveSchema!].SystemSetup WHERE sysName = 'GDPREmployeeAnonLettersOption'
		SELECT @DeleteLinks = sysValue FROM [!ActiveSchema!].SystemSetup WHERE sysName = 'GDPREmployeeAnonLinksOption'
		SELECT @DeleteNotes = sysValue FROM [!ActiveSchema!].SystemSetup WHERE sysName = 'GDPREmployeeAnonNotesOption'

		SET @iv_OptionalEmployeeParameters = CASE
												WHEN @DeleteLetters IN (2,3) THEN 'DELETELETTERS,'
										     END  
										   + CASE
												WHEN @DeleteLinks IN (2,3) THEN 'DELETELINKS,'
										     END
										   + CASE
												WHEN @DeleteNotes IN (2,3) THEN 'DELETENOTES'
											 END


		DECLARE EmployeeList CURSOR FOR	(SELECT var_code1Trans1 FROM [!ActiveSchema!].JOBMISC
										 WHERE var_code4 = @iv_AnonymisationCode)
									FOR READ ONLY

		OPEN EmployeeList
		
		FETCH NEXT FROM EmployeeList INTO @EmployeeCode

		WHILE @@fetch_status = 0
		BEGIN
			EXEC [!ActiveSchema!].esp_AnonymiseEmployee @EmployeeCode, @iv_OptionalEmployeeParameters

			FETCH NEXT FROM EmployeeList INTO @EmployeeCode
		END

		CLOSE EmployeeList
		DEALLOCATE EmployeeList
	END

	-- Anonymise Transactions
	EXEC [!ActiveSchema!].esp_AnonymiseTransactions @iv_AnonymisationType, @iv_AnonymisationCode, @iv_OptionalParameters
		
END
GO


