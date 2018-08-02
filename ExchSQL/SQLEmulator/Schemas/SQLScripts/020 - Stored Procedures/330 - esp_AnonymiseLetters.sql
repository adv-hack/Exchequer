--/////////////////////////////////////////////////////////////////////////////
--// Filename			: !ActiveSchema!.esp_AnonymiseLetters
--// Author				: James Waygood 
--// Date				: 12th December 2017 
--// Copyright Notice	: (c) 2017 Advanced Business Software & Solutions Ltd. All rights reserved.
--// Description		: SQL Script to anonymise GDPR Letters within Exchequer
--// Execute			: EXEC [!ActiveSchema!].[esp_AnonymiseLetters] 1, 'ABAP01', 'DELETELETTERS'
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	: File Creation
--//
--/////////////////////////////////////////////////////////////////////////////

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[esp_AnonymiseLetters]') AND type in (N'P', N'PC'))
DROP PROCEDURE [!ActiveSchema!].[esp_AnonymiseLetters]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [!ActiveSchema!].[esp_AnonymiseLetters] 
(
	@iv_AnonymisationType	int = 1,				-- 1=Customer/Consumer, 2=Supplier, 3=Employee, 4=Transaction, 5=Job
	@iv_AnonymisationCode	varchar(10) = '',		-- Entity Code 
	@iv_OptionalParameters	varchar(200) = ''		-- DeleteLetters, AnonymiseLetters to be added at a later date
)
AS
BEGIN
	/* DEBUG
	DECLARE @iv_AnonymisationType	int = 1
	DECLARE @iv_AnonymisationCode	varchar(10) = ''
	DECLARE @iv_OptionalParameters	varchar(20) = 'DELETELETTERS'
	*/

	SET NOCOUNT ON
	
	IF upper(@iv_OptionalParameters) LIKE '%DELETELETTERS%'
	BEGIN
		IF  @iv_AnonymisationType = 1	-- Customer/Consumer
		BEGIN
			-- Delete Letters for Customer
			DELETE FROM [!ActiveSchema!].EXSTKCHK
			WHERE RecMfix = 'W' AND SubType = 'C' AND Version = 0 AND AccCodeTrans = @iv_AnonymisationCode

			-- Delete Letters for Consumer
			DELETE FROM [!ActiveSchema!].EXSTKCHK
			WHERE RecMfix = 'W' AND SubType = 'U' AND Version = 0 AND AccCodeTrans = @iv_AnonymisationCode

			-- Delete Job Letters for Customer/Consumer
			DELETE FROM [!ActiveSchema!].EXSTKCHK
			WHERE RecMfix = 'W' AND SubType = 'J' AND Version = 0 AND exstchkvar1Trans2 IN (SELECT JobFolio 
																							 FROM [!ActiveSchema!].JOBHEAD
																							 WHERE CustCode = @iv_AnonymisationCode)
		
			-- Delete Transaction Letters for Customer/Consumer
			DELETE FROM [!ActiveSchema!].EXSTKCHK
			WHERE RecMfix = 'W' AND SubType = 'T' AND Version = 0 AND Exstchkvar1Trans2 IN (SELECT thFolioNum 
																							 FROM [!ActiveSchema!].DOCUMENT 
																							 WHERE thAcCode = @iv_AnonymisationCode
																							 AND thDocType IN (0,1,2,3,4,5,6,7,8,9,10,44,47,49))
			-- JST/JSA Transaction Links for Customer/Consumer
			DELETE FROM [!ActiveSchema!].EXSTKCHK
			WHERE RecMfix = 'W' AND SubType = 'T' AND Version = 0 AND Exstchkvar1Trans2 IN (SELECT thFolioNum 
																							 FROM [!ActiveSchema!].DOCUMENT 
																							 WHERE thAcCode = @iv_AnonymisationCode
																							 AND thDocType IN (47,49))


		END
		ELSE IF @iv_AnonymisationType = 2	-- Supplier
		BEGIN
			-- Delete Letters for Supplier
			DELETE FROM [!ActiveSchema!].EXSTKCHK
			WHERE RecMfix = 'W' AND SubType = 'S' AND Version = 0 AND AccCodeTrans = @iv_AnonymisationCode

			-- Delete Transaction Letters for Supplier
			DELETE FROM [!ActiveSchema!].EXSTKCHK
			WHERE RecMfix = 'W' AND SubType = 'T' AND Version = 0 AND Exstchkvar1Trans2 IN (SELECT thFolioNum 
																							 FROM [!ActiveSchema!].DOCUMENT 
																							 WHERE thAcCode = @iv_AnonymisationCode
																							 AND thDocType IN (15,16,17,18,19,20,21,22,23,24,25,45))

			-- Delete Transaction Links for Supplier Employee TSH
			DELETE FROM [!ActiveSchema!].EXSTKCHK
			WHERE RecMfix = 'W' AND SubType = 'T' AND Version = 0 AND Exstchkvar1Trans2 IN (SELECT thFolioNum 
																							 FROM [!ActiveSchema!].DOCUMENT 
																						 	 WHERE thBatchLinkTrans IN (SELECT var_code1Trans1
																							 						    FROM [!ActiveSchema!].JOBMISC
																													    WHERE var_code4 = @iv_AnonymisationCode)
																							 AND thDocType IN (41))

/*			-- Delete Transaction Links for Supplier Employee JCT/JPA
			DELETE FROM [!ActiveSchema!].EXSTKCHK
			WHERE RecMfix = 'W' AND SubType = 'T' AND Version = 0 AND Exstchkvar1Trans2 IN (SELECT thFolioNum 
																							 FROM [!ActiveSchema!].DOCUMENT 
																							 WHERE SUBSTRING(thBatchLink,3,6) IN (SELECT var_code1Trans1
																																  FROM [!ActiveSchema!].JOBMISC
																																  WHERE var_code4 = @iv_AnonymisationCode)
																							 AND thDocType IN (46,50))
*/
		END
		ELSE IF @iv_AnonymisationType = 3	-- Employee
		BEGIN
			-- Delete Letters for Employee
			DELETE FROM [!ActiveSchema!].EXSTKCHK
			WHERE RecMfix = 'W' AND SubType = 'E' AND Version = 0 AND AccCodeTrans = @iv_AnonymisationCode

			-- Delete TSH Transaction Links for Employee
			DELETE FROM [!ActiveSchema!].EXSTKCHK
			WHERE RecMfix = 'W' AND SubType = 'T' AND Version = 0 AND Exstchkvar1Trans2 IN (SELECT thFolioNum 
																							 FROM [!ActiveSchema!].DOCUMENT 
																							 WHERE thBatchLinkTrans = @iv_AnonymisationCode
																							 AND thDocType = 41)

			-- Delete JCT/JPA Transaction Links for Employee
			DELETE FROM [!ActiveSchema!].EXSTKCHK
			WHERE RecMfix = 'W' AND SubType = 'T' AND Version = 0 AND Exstchkvar1Trans2 IN (SELECT thFolioNum 
																							 FROM [!ActiveSchema!].DOCUMENT 
																							 WHERE SUBSTRING(thBatchLink,3,6) = @iv_AnonymisationCode
																							 AND thDocType IN (46,50))

		END
		ELSE IF @iv_AnonymisationType = 5	-- Job
		BEGIN
			-- Delete Links for Employee
			DELETE FROM [!ActiveSchema!].EXSTKCHK
			WHERE RecMfix = 'W' AND SubType = 'J' AND Version = 0 AND exstchkvar1Trans2 = convert(int,@iv_AnonymisationCode)
		END
	END
END
GO


