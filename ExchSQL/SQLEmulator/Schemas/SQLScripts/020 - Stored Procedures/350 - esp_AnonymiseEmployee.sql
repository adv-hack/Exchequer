--/////////////////////////////////////////////////////////////////////////////
--// Filename			: !ActiveSchema!.esp_AnonymiseEmployee
--// Author				: James Waygood 
--// Date				: 08th December 2017 
--// Copyright Notice	: (c) 2017 Advanced Business Software & Solutions Ltd. All rights reserved.
--// Description		: SQL Script to anonymise GDPR Employee data within Exchequer
--// Execute			: EXEC [!ActiveSchema!].[esp_AnonymiseEmployee] 'MARK01', 'DeleteNotes'
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	: File Creation
--//	2	: Added setting of Anonymisation Status, Date and Time
--//
--/////////////////////////////////////////////////////////////////////////////

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[esp_AnonymiseEmployee]') AND type in (N'P', N'PC'))
DROP PROCEDURE [!ActiveSchema!].[esp_AnonymiseEmployee]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [!ActiveSchema!].[esp_AnonymiseEmployee] 
(
	@iv_AnonymisationCode	varchar(10) = '',	-- Employee Code 
	@iv_OptionalParameters	varchar(200) = ''	-- DeleteNotes, DeleteLetters, DeleteLinks -- CSV
)
AS
BEGIN
	/* DEBUG
	DECLARE @iv_AnonymisationCode	varchar(10) = ''
	DECLARE @iv_OptionalParameters = 'DeleteNotes'
	*/
	UPDATE [!ActiveSchema!].JOBMISC WITH (READPAST)
		SET EmpName = common.efn_RandomText(EmpName)
			,Addr1 = common.efn_RandomText(Addr1)
			,Addr2 = common.efn_RandomText(Addr2)
			,Addr3 = common.efn_RandomText(Addr3)
			,Addr4 = common.efn_RandomText(Addr4)
			,Addr5 = common.efn_RandomText(Addr5)
			,Phone = ''
			,EmailAddr = ''
			,Fax = ''
			,Phone2 = ''
			,PayNo =common.efn_RandomText(PayNo)
			,CertNo =common.efn_RandomText(CertNo)
			,ENINo =common.efn_RandomText(ENINo)
			,UTRCode =common.efn_RandomText(UTRCode)
			,HMRCVerifyNo =common.efn_RandomText(HMRCVerifyNo)
			,emAnonymisationStatus = 2
			,emAnonymisedDate = CONVERT(varchar(8), GETDATE(), 112)
			,emAnonymisedTime = REPLACE(CONVERT(varchar(8),GetDate(), 108),':','')

	WHERE RecPfix = 'J' AND SubType = 'E' AND var_code1Trans1 = @iv_AnonymisationCode

	UPDATE [!ActiveSchema!].JOBMISC WITH (READPAST)
		SET  UserDef1 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 28001) = 1 THEN common.efn_RandomText(UserDef1) ELSE UserDef1 END
			,UserDef2 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 28002) = 1 THEN common.efn_RandomText(UserDef2) ELSE UserDef2 END
			,UserDef3 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 28003) = 1 THEN common.efn_RandomText(UserDef3) ELSE UserDef3 END
			,UserDef4 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 28004) = 1 THEN common.efn_RandomText(UserDef4) ELSE UserDef4 END
		WHERE RecPfix = 'J' AND SubType = 'E' AND var_code1Trans1 = @iv_AnonymisationCode
	
	-- Delete/Anonymise Notes
	IF upper(@iv_OptionalParameters) LIKE '%DELETENOTES%' OR upper(@iv_OptionalParameters) LIKE '%ANONYMISENOTES%'
		EXEC [!ActiveSchema!].esp_AnonymiseNotes 3, @iv_AnonymisationCode, @iv_OptionalParameters

	-- Delete/Anonymise Letters
	IF upper(@iv_OptionalParameters) LIKE '%DELETELETTERS%' OR upper(@iv_OptionalParameters) LIKE '%ANONYMISELETTERS%'
		EXEC [!ActiveSchema!].esp_AnonymiseLetters 3, @iv_AnonymisationCode, @iv_OptionalParameters

	-- Delete/Anonymise Links
	IF upper(@iv_OptionalParameters) LIKE '%DELETELINKS%' OR upper(@iv_OptionalParameters) LIKE '%ANONYMISELINKS%'
		EXEC [!ActiveSchema!].esp_AnonymiseLinks 3, @iv_AnonymisationCode, @iv_OptionalParameters

	EXEC [!ActiveSchema!].esp_AnonymiseTransactions 3, @iv_AnonymisationCode, @iv_OptionalParameters

END
GO


