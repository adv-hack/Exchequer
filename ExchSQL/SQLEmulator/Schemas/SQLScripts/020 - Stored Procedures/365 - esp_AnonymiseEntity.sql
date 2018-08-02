--/////////////////////////////////////////////////////////////////////////////
--// Filename			: common.esp_AnonymiseEntity
--// Author				: James Waygood 
--// Date				: 08th December 2017 
--// Copyright Notice	: (c) 2017 Advanced Business Software & Solutions Ltd. All rights reserved.
--// Description		: SQL Script to anonymise GDPR data within Exchequer
--// Execute			: EXEC [common].[esp_AnonymiseEntity] 'ZZZZ01,ZZZZ02,ZZZZ03,ZZZZ04,ZZZZ05', 1, 'ABAP01'
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	: File Creation
--//
--/////////////////////////////////////////////////////////////////////////////

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[common].[esp_AnonymiseEntity]') AND type in (N'P', N'PC'))
DROP PROCEDURE [common].[esp_AnonymiseEntity]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [common].[esp_AnonymiseEntity] 
(
	@iv_Companies			varchar(max) = '',	-- Companies List as CSV
	@iv_AnonymisationType	int = 1,			-- 0=Company, 1=Customer/Consumer, 2=Supplier, 3=Employee
	@iv_AnonymisationCode	varchar(10) = '',	-- Trader Code or Employee Code 
	@iv_OptionalParameters	varchar(200) = ''	-- DeleteNotes, DeleteLetters, DeleteLinks -- CSV
)
AS
BEGIN
	/* DEBUG
	DECLARE @iv_Companies			varchar(max) = ''
	DECLARE @iv_AnonymisationType	int = 1
	DECLARE @iv_AnonymisationCode	varchar(10) = ''
	DECLARE @iv_OptionalParameters = 'DeleteNotes'
	*/

	DECLARE @SQLString nvarchar(max)
	DECLARE @CompanyCode varchar(6)

	SET @SQLString = ''
	SET @CompanyCode = ''
	
	SET NOCOUNT ON
	
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
		
		IF  @iv_AnonymisationType IN (0, 1, 2)	-- 0=Company, 1=Customer/Consumer, 2=Supplier
		BEGIN
			
			SET @SQLString = @CompanyCode + '.esp_AnonymiseTrader ' 
													+ CONVERT(varchar(1), @iv_AnonymisationType) + ', ''' 
													+ @iv_AnonymisationCode + ''', ''' 
													+ @iv_OptionalParameters + ''''
			EXECUTE sp_executesql @SQLString
				
		END

		IF  @iv_AnonymisationType IN (0, 3)		-- 0=Company, 3=Employee
		BEGIN

			SET @SQLString = @CompanyCode + '.esp_AnonymiseEmployee ' 
													+ '''' + @iv_AnonymisationCode + ''', ''' 
													+ @iv_OptionalParameters + ''''
			EXECUTE sp_executesql @SQLString


		END

		FETCH NEXT FROM CompaniesList INTO @CompanyCode
	END

	CLOSE CompaniesList
	DEALLOCATE CompaniesList
				
END
GO


