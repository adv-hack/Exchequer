--/////////////////////////////////////////////////////////////////////////////
--// Filename			: !ActiveSchema!.esp_AnonymiseTraderJobs
--// Author				: James Waygood 
--// Date				: 08th December 2017 
--// Copyright Notice	: (c) 2017 Advanced Business Software & Solutions Ltd. All rights reserved.
--// Description		: SQL Script to anonymise GDPR Employee data within Exchequer
--// Execute			: EXEC [!ActiveSchema!].[esp_AnonymiseTraderJobs] 'BATH01', 'DeleteNotes'
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	: File Creation
--//	2	: Added setting of Anonymisation Status, Date and Time
--//
--/////////////////////////////////////////////////////////////////////////////

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[esp_AnonymiseTraderJobs]') AND type in (N'P', N'PC'))
DROP PROCEDURE [!ActiveSchema!].[esp_AnonymiseTraderJobs]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [!ActiveSchema!].[esp_AnonymiseTraderJobs] 
(
	@iv_AnonymisationCode	int = 0, 			-- Job Folio 
	@iv_OptionalParameters	varchar(200) = ''	-- DeleteNotes, DeleteLetters, DeleteLinks -- CSV
)
AS
BEGIN
	/* DEBUG
	DECLARE @iv_AnonymisationCode	int;
	DECLARE @iv_OptionalParameters = 'DeleteNotes'
	*/
	DECLARE @JobFolio varchar(10) = convert(varchar(10),@iv_AnonymisationCode)

	UPDATE [!ActiveSchema!].JOBHEAD WITH (READPAST)
		SET  JobDesc = common.efn_RandomText(JobDesc)
			,Contact = common.efn_RandomText(Contact)
			,JobMan = common.efn_RandomText(JobMan)
			,UserDef1 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 27001) = 1 THEN common.efn_RandomText(UserDef1) ELSE UserDef1 END
			,UserDef2 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 27002) = 1 THEN common.efn_RandomText(UserDef2) ELSE UserDef2 END
			,UserDef3 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 27003) = 1 THEN common.efn_RandomText(UserDef3) ELSE UserDef3 END
			,UserDef4 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 27004) = 1 THEN common.efn_RandomText(UserDef4) ELSE UserDef4 END
			,UserDef5 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 27005) = 1 THEN common.efn_RandomText(UserDef5) ELSE UserDef5 END
			,UserDef6 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 27006) = 1 THEN common.efn_RandomText(UserDef6) ELSE UserDef6 END
			,UserDef7 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 27007) = 1 THEN common.efn_RandomText(UserDef7) ELSE UserDef7 END
			,UserDef8 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 27008) = 1 THEN common.efn_RandomText(UserDef8) ELSE UserDef8 END
			,UserDef9 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 27009) = 1 THEN common.efn_RandomText(UserDef9) ELSE UserDef9 END
			,UserDef10 = CASE WHEN (SELECT cfContainsPIIData FROM [!ActiveSchema!].CUSTOMFIELDS WHERE cfFieldID = 27010) = 1 THEN common.efn_RandomText(UserDef10) ELSE UserDef10 END
			,jrAnonymised = 1
			,jrAnonymisedDate = CONVERT(varchar(8), GETDATE(), 112)
			,jrAnonymisedTime = REPLACE(CONVERT(varchar(8),GetDate(), 108),':','')
	WHERE JobFolio = @iv_AnonymisationCode

	-- Anonymise Job Notes
	IF upper(@iv_OptionalParameters) LIKE '%DELETENOTES%' OR upper(@iv_OptionalParameters) LIKE '%ANONYMISENOTES%'
	EXEC [!ActiveSchema!].esp_AnonymiseNotes 5, @JobFolio, @iv_OptionalParameters
	
	-- Anonymise Job Letters
	IF upper(@iv_OptionalParameters) LIKE '%DELETELETTERS%' OR upper(@iv_OptionalParameters) LIKE '%ANONYMISELETTERS%'
	EXEC [!ActiveSchema!].esp_AnonymiseLetters 5, @JobFolio, @iv_OptionalParameters
	
	-- Anonymise Job Links
	IF upper(@iv_OptionalParameters) LIKE '%DELETELINKS%' OR upper(@iv_OptionalParameters) LIKE '%ANONYMISELINKS%'
	EXEC [!ActiveSchema!].esp_AnonymiseLinks 5, @JobFolio, @iv_OptionalParameters
	

END
GO


