--/////////////////////////////////////////////////////////////////////////////
--// Filename			: !ActiveSchema!.esp_AnonymiseNotes
--// Author				: James Waygood 
--// Date				: 12th December 2017 
--// Copyright Notice	: (c) 2017 Advanced Business Software & Solutions Ltd. All rights reserved.
--// Description		: SQL Script to anonymise GDPR Notes within Exchequer
--// Execute			: EXEC [!ActiveSchema!].[esp_AnonymiseNotes] 1, 'ABAP01', 'DELETE'
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	: File Creation
--//
--/////////////////////////////////////////////////////////////////////////////

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[esp_AnonymiseNotes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [!ActiveSchema!].[esp_AnonymiseNotes]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [!ActiveSchema!].[esp_AnonymiseNotes] 
(
	@iv_AnonymisationType	int = 1,				-- 1=Customer/Consumer, 2=Supplier, 3=Employee, 5=Job
	@iv_AnonymisationCode	varchar(10) = '',		-- Entity Code 
	@iv_OptionalParameters	varchar(200) = ''		-- DeleteNotes, (AnonymiseNotes to be added time permitting)
)
AS
BEGIN
	/* DEBUG
	DECLARE @iv_AnonymisationType	int = 1
	DECLARE @iv_AnonymisationCode	varchar(10) = ''
	*/

	SET NOCOUNT ON
	
	IF upper(@iv_OptionalParameters) LIKE '%DELETENOTES%'
	BEGIN
		IF  @iv_AnonymisationType = 1		-- Customer/Consumer
		BEGIN
			-- Customer/Consumer Notes
			DELETE FROM [!ActiveSchema!].EXCHQCHK
			WHERE RecPfix = 'N' AND SubType = 65 AND NType IN (1,2) AND EXCHQCHKcode1Trans7 = @iv_AnonymisationCode

			-- Job Notes
			DELETE FROM [!ActiveSchema!].EXCHQCHK
			WHERE RecPfix = 'N' AND SubType = 74 AND NType IN (1,2) AND EXCHQCHKcode1Trans5 IN (SELECT JobFolio 
																			 FROM [!ActiveSchema!].JOBHEAD
																			 WHERE @iv_AnonymisationCode = Exchqchkcode1Trans7) 
			-- Sales Transaction Notes
			DELETE FROM [!ActiveSchema!].TransactionNote
			WHERE NoteFolio IN (SELECT thFolioNum 
								FROM [!ActiveSchema!].DOCUMENT 
								WHERE thAcCode = @iv_AnonymisationCode
								AND NoteType IN (1,2) AND thDocType IN (0,1,2,3,4,5,6,7,8,9,10,44,47,49))

			-- JST/JSA Transaction Notes
			DELETE FROM [!ActiveSchema!].TransactionNote
			WHERE NoteFolio IN (SELECT thFolioNum 
								FROM [!ActiveSchema!].DOCUMENT 
								WHERE SUBSTRING(thBatchLink,3,6) = @iv_AnonymisationCode
								AND NoteType IN (1,2) AND thDocType IN (47,49))


		END
		ELSE IF @iv_AnonymisationType = 2	-- Supplier
		BEGIN
			-- Supplier Notes
			DELETE FROM [!ActiveSchema!].EXCHQCHK
			WHERE RecPfix = 'N' AND SubType = 65 AND NType IN (1,2) AND EXCHQCHKcode1Trans7 = @iv_AnonymisationCode

			-- Purchase Transaction Notes
			DELETE FROM [!ActiveSchema!].TransactionNote
			WHERE NoteFolio IN (SELECT thFolioNum 
								FROM [!ActiveSchema!].DOCUMENT 
								WHERE thAcCode = @iv_AnonymisationCode AND NoteType IN (1,2)
								AND thDocType IN (15,16,17,18,19,20,21,22,23,24,25,45))

/*
			-- Supplier Employee TSH Transaction Notes
			DELETE FROM [!ActiveSchema!].TransactionNote
			WHERE NoteFolio IN (SELECT thFolioNum 
								FROM [!ActiveSchema!].DOCUMENT 
								WHERE thBatchLinkTrans IN (SELECT var_code1Trans1
														   FROM [!ActiveSchema!].JOBMISC
														   WHERE var_code4 = @iv_AnonymisationCode)
								AND NoteType IN (1,2) AND thDocType IN (41,46,50))

			-- Supplier Employee JCT/JPA Transaction Notes
			DELETE FROM [!ActiveSchema!].TransactionNote
			WHERE NoteFolio IN (SELECT thFolioNum 
								FROM [!ActiveSchema!].DOCUMENT 
								WHERE SUBSTRING(thBatchLink,3,6) IN (SELECT var_code1Trans1
																	 FROM [!ActiveSchema!].JOBMISC
																	 WHERE var_code4 = @iv_AnonymisationCode)
								AND NoteType IN (1,2) AND thDocType IN (41,46,50))
*/
		END
		ELSE IF @iv_AnonymisationType = 3	-- Employee
		BEGIN
			-- Employee Notes
			DELETE FROM [!ActiveSchema!].EXCHQCHK
			WHERE RecPfix = 'N' AND SubType = 69 AND NType IN (1,2) AND EXCHQCHKcode1Trans7 = @iv_AnonymisationCode

			-- Employee TSH Transaction Notes
			DELETE FROM [!ActiveSchema!].TransactionNote
			WHERE NoteFolio IN (SELECT thFolioNum 
								FROM [!ActiveSchema!].DOCUMENT 
								WHERE thBatchLinkTrans = @iv_AnonymisationCode
								AND NoteType IN (1,2) AND thDocType = 41)

			-- Employee JCT/JPA Transaction Notes
			DELETE FROM [!ActiveSchema!].TransactionNote
			WHERE NoteFolio IN (SELECT thFolioNum 
								FROM [!ActiveSchema!].DOCUMENT 
								WHERE SUBSTRING(thBatchLink,3,6) = @iv_AnonymisationCode
								AND NoteType IN (1,2) AND thDocType IN (46,50))

		END
		ELSE IF @iv_AnonymisationType = 5	-- Job
		BEGIN
			-- Job Notes
			DELETE FROM [!ActiveSchema!].EXCHQCHK
			WHERE RecPfix = 'N' AND SubType = 74 AND NType IN (1,2) AND Exchqchkcode1Trans5 = convert(int,@iv_AnonymisationCode)
		END
	
	END
END
GO


