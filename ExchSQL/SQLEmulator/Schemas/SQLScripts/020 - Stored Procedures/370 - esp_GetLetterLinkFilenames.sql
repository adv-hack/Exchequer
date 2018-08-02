--/////////////////////////////////////////////////////////////////////////////
--// Filename			: common.esp_GetLetterLinkFilenames
--// Author				: James Waygood 
--// Date				: 08th December 2017 
--// Copyright Notice	: (c) 2017 Advanced Business Software & Solutions Ltd. All rights reserved.
--// Description		: SQL Script to retrieve cross company Letter and Link Filenames
--// Execute			: EXEC [common].[esp_GetLetterLinkFilenames] 'ZZZZ01,ZZZZ02,ZZZZ03,ZZZZ04,ZZZZ05', 1, ''
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	: File Creation
--//
--/////////////////////////////////////////////////////////////////////////////

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[common].[esp_GetLetterLinkFilenames]') AND type in (N'P', N'PC'))
DROP PROCEDURE [common].[esp_GetLetterLinkFilenames]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [common].[esp_GetLetterLinkFilenames] 
(
	@iv_Companies			varchar(max), -- Companies List as CSV
	@iv_AnonymisationType	int,		  -- 0=Company, 1=Customer/Consumer, 2=Supplier, 3=Employee
	@iv_AnonymisationCode	varchar(10)	  -- Trader Code or Employee Code 
)
AS
BEGIN
	/* DEBUG
	DECLARE @iv_Companies			varchar(max) = ''
	DECLARE @iv_AnonymisationType	int = 1
	DECLARE @iv_AnonymisationCode	varchar(10) = ''
	*/

	DECLARE @SQLString nvarchar(max)
	DECLARE @CompanyCode varchar(6)

	SET @SQLString = ''
	SET @CompanyCode = ''
	
	SET NOCOUNT ON
	
	CREATE TABLE #tblLetterLinks 
		(
		CompanyCode					varchar(10),
		Filename					varchar(100)
		)
	
	IF LEN(@iv_Companies) = 0
	BEGIN
		SET @iv_Companies = SUBSTRING((SELECT ',' + CONVERT(VARCHAR(6), CompanyCode1Computed) 
									   FROM common.COMPANY
									   WHERE RecPfix = 'C' 
									   ORDER BY CompanyCode1Computed
									   FOR XML PATH('')),2,200000)
	END

	DECLARE @CompanyList common.edt_Varchar
  
	INSERT INTO @CompanyList
	SELECT ListValue
	FROM   common.efn_TableFromList(@iv_Companies)

	DECLARE CompaniesList CURSOR FOR	(SELECT * FROM @CompanyList)
							FOR READ ONLY

	OPEN CompaniesList
		
	FETCH NEXT FROM CompaniesList INTO @CompanyCode

	WHILE @@fetch_status = 0
	BEGIN
		
		IF  @iv_AnonymisationType IN (0, 1)	-- 1=Customer/Consumer
		BEGIN
			-- Customer/Consumer Letters & Links
			SELECT @SQLString = 'INSERT INTO #tblLetterLinks
								 SELECT CompanyCode = ''' +  @CompanyCode + ''',
										Filename = CASE
													WHEN VERSION = 0 THEN UPPER(''DOCS\'' + convert(varchar(12),substring([LetterLinkData1],124,12)))
													ELSE UPPER(LetterLinkData1Trans2)
												   END 
								 FROM ' +  @CompanyCode + '.EXSTKCHK 
								 WHERE RecMfix = ''W'' AND SubType IN (''C'',''U'')'
			IF @iv_AnonymisationCode <> ''
				SELECT @SQLString = @SQLString + ' AND AccCodeTrans = ''' + @iv_AnonymisationCode + ''''
		
			EXEC (@SQLString)
		
			-- Job Letters & Links
			SELECT @SQLString = 'INSERT INTO #tblLetterLinks
								 SELECT CompanyCode = ''' +  @CompanyCode + ''',
										Filename = CASE
													WHEN VERSION = 0 THEN UPPER(''DOCS\'' + convert(varchar(12),substring([LetterLinkData1],124,12)))
													ELSE UPPER(LetterLinkData1Trans2)
												   END 
								 FROM ' +  @CompanyCode + '.EXSTKCHK 
								 WHERE RecMfix = ''W'' AND SubType = ''J'''
			IF @iv_AnonymisationCode <> ''
				SELECT @SQLString = @SQLString + ' AND exstchkvar1Trans2 IN (SELECT JobFolio 
																			 FROM ' +  @CompanyCode + '.JOBHEAD
																			 WHERE  CustCode = ''' + @iv_AnonymisationCode + ''')'
		
			EXEC (@SQLString)
		
			-- Customer/Consumer Transaction Letters & Links
			SELECT @SQLString = 'INSERT INTO #tblLetterLinks
								 SELECT CompanyCode = ''' +  @CompanyCode + ''',
										Filename = CASE
													WHEN VERSION = 0 THEN UPPER(''DOCS\'' + convert(varchar(12),substring([LetterLinkData1],124,12)))
													ELSE UPPER(LetterLinkData1Trans2)
												   END 
								 FROM ' +  @CompanyCode + '.EXSTKCHK 
								 WHERE RecMfix = ''W'' AND SubType = ''T'''
			IF @iv_AnonymisationCode <> ''
				SELECT @SQLString = @SQLString + ' AND Exstchkvar1Trans2 IN (SELECT thFolioNum 
																			 FROM ' +  @CompanyCode + '.DOCUMENT 
																			 WHERE thAcCode = ''' + @iv_AnonymisationCode + '''
																			 AND thDocType IN (0,1,2,3,4,5,6,7,8,9,10,44,47,49))'
		
			EXEC (@SQLString)
		END

		IF  @iv_AnonymisationType IN (0, 2)	--  2=Supplier
		BEGIN
			SELECT @SQLString = 'INSERT INTO #tblLetterLinks
								 SELECT CompanyCode = ''' +  @CompanyCode + ''',
										Filename = CASE
													WHEN VERSION = 0 THEN UPPER(''DOCS\'' + convert(varchar(12),substring([LetterLinkData1],124,12)))
													ELSE UPPER(LetterLinkData1Trans2)
												   END 
								 FROM ' +  @CompanyCode + '.EXSTKCHK 
								 WHERE RecMfix = ''W'' AND SubType = ''S'''
			IF @iv_AnonymisationCode <> ''
				SELECT @SQLString = @SQLString + ' AND AccCodeTrans = ''' + @iv_AnonymisationCode + ''''
		
			EXEC (@SQLString)
		
			-- Supplier Transaction Letters & Links
			SELECT @SQLString = 'INSERT INTO #tblLetterLinks
								 SELECT CompanyCode = ''' +  @CompanyCode + ''',
										Filename = CASE
													WHEN VERSION = 0 THEN UPPER(''DOCS\'' + convert(varchar(12),substring([LetterLinkData1],124,12)))
													ELSE UPPER(LetterLinkData1Trans2)
												   END 
								 FROM ' +  @CompanyCode + '.EXSTKCHK 
								 WHERE RecMfix = ''W'' AND SubType = ''T'''
			IF @iv_AnonymisationCode <> ''
				SELECT @SQLString = @SQLString + ' AND Exstchkvar1Trans2 IN (SELECT thFolioNum 
																			 FROM ' +  @CompanyCode + '.DOCUMENT 
																			 WHERE thAcCode = ''' + @iv_AnonymisationCode + '''
																			 AND thDocType IN (15,16,17,18,19,20,21,22,23,24,25,45))'
		
			EXEC (@SQLString)

			-- Employee Letters & Links
			SELECT @SQLString = 'DECLARE @DeleteLetters int 
								 DECLARE @DeleteLinks int 
								 
								 SELECT @DeleteLetters = sysValue FROM ' +  @CompanyCode + '.SystemSetup WHERE sysName = ''GDPREmployeeAnonLettersOption''
								 SELECT @DeleteLinks = sysValue FROM ' +  @CompanyCode + '.SystemSetup WHERE sysName = ''GDPREmployeeAnonLinksOption''
			
								 IF @DeleteLetters = 3
								 BEGIN
									 INSERT INTO #tblLetterLinks
									 SELECT CompanyCode = ''' +  @CompanyCode + ''',
											Filename = CASE
														WHEN VERSION = 0 THEN UPPER(''DOCS\'' + convert(varchar(12),substring([LetterLinkData1],124,12)))
														ELSE UPPER(LetterLinkData1Trans2)
													   END 
									 FROM ' +  @CompanyCode + '.EXSTKCHK 
									 WHERE RecMfix = ''W'' AND SubType = ''E'' AND Version = 0 '

			IF @iv_AnonymisationCode <> ''
				SELECT @SQLString = @SQLString + ' AND AccCodeTrans IN (SELECT var_code1Trans1
																		FROM ' +  @CompanyCode + '.JOBMISC
																		WHERE var_code4 = ''' + @iv_AnonymisationCode + ''') '

			SELECT @SQLString = @SQLString + 'END 

								 IF @DeleteLinks = 3
								 BEGIN
									 INSERT INTO #tblLetterLinks
									 SELECT CompanyCode = ''' +  @CompanyCode + ''',
											Filename = CASE
														WHEN VERSION = 0 THEN UPPER(''DOCS\'' + convert(varchar(12),substring([LetterLinkData1],124,12)))
														ELSE UPPER(LetterLinkData1Trans2)
													   END 
									 FROM ' +  @CompanyCode + '.EXSTKCHK 
									 WHERE RecMfix = ''W'' AND SubType = ''E'' AND Version <> 0 '

			IF @iv_AnonymisationCode <> ''
				SELECT @SQLString = @SQLString + ' AND AccCodeTrans IN (SELECT var_code1Trans1
																		FROM ' +  @CompanyCode + '.JOBMISC
																		WHERE var_code4 = ''' + @iv_AnonymisationCode + ''') '
			SELECT @SQLString = @SQLString + ' END '
			EXEC (@SQLString)
		
			-- Supplier Employee Transaction Letters & Links
			SELECT @SQLString = 'DECLARE @DeleteLetters int 
								 DECLARE @DeleteLinks int 
								 
								 SELECT @DeleteLetters = sysValue FROM ' +  @CompanyCode + '.SystemSetup WHERE sysName = ''GDPREmployeeAnonLettersOption''
								 SELECT @DeleteLinks = sysValue FROM ' +  @CompanyCode + '.SystemSetup WHERE sysName = ''GDPREmployeeAnonLinksOption''
			
								 IF @DeleteLetters = 3
								 BEGIN
									 INSERT INTO #tblLetterLinks
									 SELECT CompanyCode = ''' +  @CompanyCode + ''',
											Filename = CASE
														WHEN VERSION = 0 THEN UPPER(''DOCS\'' + convert(varchar(12),substring([LetterLinkData1],124,12)))
														ELSE UPPER(LetterLinkData1Trans2)
													   END 
									 FROM ' +  @CompanyCode + '.EXSTKCHK 
									 WHERE RecMfix = ''W'' AND SubType = ''T'' AND VERSION = 0 '
			IF @iv_AnonymisationCode <> ''
				SELECT @SQLString = @SQLString + ' AND (Exstchkvar1Trans2 IN (SELECT thFolioNum 
																			FROM  ' +  @CompanyCode + '.DOCUMENT 
																			WHERE thBatchLinkTrans IN (SELECT var_code1Trans1
																							 		FROM  ' +  @CompanyCode + '.JOBMISC
																									WHERE var_code4 = ''' + @iv_AnonymisationCode + ''')
																			AND thDocType IN (41))'

											   + ' OR Exstchkvar1Trans2 IN (SELECT thFolioNum 
																			FROM ' +  @CompanyCode + '.DOCUMENT 
																			WHERE SUBSTRING(thBatchLink,3,6) IN (SELECT var_code1Trans1
																												FROM ' +  @CompanyCode + '.JOBMISC
																												WHERE var_code4 = ''' + @iv_AnonymisationCode + ''')
																			AND thDocType IN (46,50))) '
			SELECT @SQLString = @SQLString + ' END 
							IF @DeleteLinks = 3
								 BEGIN
									 INSERT INTO #tblLetterLinks
									 SELECT CompanyCode = ''' +  @CompanyCode + ''',
											Filename = CASE
														WHEN VERSION = 0 THEN UPPER(''DOCS\'' + convert(varchar(12),substring([LetterLinkData1],124,12)))
														ELSE UPPER(LetterLinkData1Trans2)
													   END 
									 FROM ' +  @CompanyCode + '.EXSTKCHK 
									 WHERE RecMfix = ''W'' AND SubType = ''T'' AND VERSION <> 0 '
			IF @iv_AnonymisationCode <> ''
				SELECT @SQLString = @SQLString + ' AND (Exstchkvar1Trans2 IN (SELECT thFolioNum 
																			FROM  ' +  @CompanyCode + '.DOCUMENT 
																			WHERE thBatchLinkTrans IN (SELECT var_code1Trans1
																							 		FROM  ' +  @CompanyCode + '.JOBMISC
																									WHERE var_code4 = ''' + @iv_AnonymisationCode + ''')
																			AND thDocType IN (41))'

											   + ' OR Exstchkvar1Trans2 IN (SELECT thFolioNum 
																			FROM ' +  @CompanyCode + '.DOCUMENT 
																			WHERE SUBSTRING(thBatchLink,3,6) IN (SELECT var_code1Trans1
																												FROM ' +  @CompanyCode + '.JOBMISC
																												WHERE var_code4 = ''' + @iv_AnonymisationCode + ''')
																			AND thDocType IN (46,50)))'

			SELECT @SQLString = @SQLString + ' END'
		
			EXEC (@SQLString)
		END

		IF  @iv_AnonymisationType IN (0, 3)	-- 3=Employee
		BEGIN
			SELECT @SQLString = 'INSERT INTO #tblLetterLinks
								 SELECT CompanyCode = ''' +  @CompanyCode + ''',
										Filename = CASE
													WHEN VERSION = 0 THEN UPPER(''DOCS\'' + convert(varchar(12),substring([LetterLinkData1],124,12)))
													ELSE UPPER(LetterLinkData1Trans2)
												   END 
								 FROM ' +  @CompanyCode + '.EXSTKCHK 
								 WHERE RecMfix = ''W'' AND SubType = ''E'''
			IF @iv_AnonymisationCode <> ''
				SELECT @SQLString = @SQLString + ' AND AccCodeTrans = ''' + @iv_AnonymisationCode + ''''
		
			EXEC (@SQLString)
		
			-- Employee Transaction Letters & Links
			SELECT @SQLString = 'INSERT INTO #tblLetterLinks
								 SELECT CompanyCode = ''' +  @CompanyCode + ''',
										Filename = CASE
													WHEN VERSION = 0 THEN UPPER(''DOCS\'' + convert(varchar(12),substring([LetterLinkData1],124,12)))
													ELSE UPPER(LetterLinkData1Trans2)
												   END 
								 FROM ' +  @CompanyCode + '.EXSTKCHK 
								 WHERE RecMfix = ''W'' AND SubType = ''T'''
			IF @iv_AnonymisationCode <> ''
				SELECT @SQLString = @SQLString + ' AND (Exstchkvar1Trans2 IN (SELECT thFolioNum 
																			FROM  ' +  @CompanyCode + '.DOCUMENT 
																			WHERE thBatchLinkTrans IN (''' + @iv_AnonymisationCode + ''')
																			AND thDocType IN (41))'

											   + ' OR Exstchkvar1Trans2 IN (SELECT thFolioNum 
																			FROM ' +  @CompanyCode + '.DOCUMENT 
																			WHERE SUBSTRING(thBatchLink,3,6) IN (''' + @iv_AnonymisationCode + ''')
																			AND thDocType IN (46,50)))'

		
			EXEC (@SQLString)
		END

		FETCH NEXT FROM CompaniesList INTO @CompanyCode
	END

	CLOSE CompaniesList
	DEALLOCATE CompaniesList
				
	SELECT DISTINCT CompanyCode, Filename 
	FROM #tblLetterLinks
	ORDER BY CompanyCode, Filename
	
	DROP TABLE #tblLetterLinks
END
GO


