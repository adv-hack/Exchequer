--/////////////////////////////////////////////////////////////////////////////
--// Filename		: common.ifn_GetNominalValue.sql
--// Author		: James Waygood 
--// Date		: 17th July 2015 
--// Copyright Notice	: (c) 2015 Advanced Business Software & Solutions Ltd. All rights reserved.
--// Description	: SQL Script to add common.ifn_GetNominalValue function to retrieve cross company Nominal History Details 
--// Execute		: SELECT [common].[esp_GetNominalValue] ('ZZZZ01,ZZZZ02,ZZZZ03,ZZZZ04,ZZZZ05', 1, 2008, 0, 0, 2010, '', '', '', 0)
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	: File Creation
--//	2	: Performance Improvements
--//
--/////////////////////////////////////////////////////////////////////////////

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[common].[esp_GetNominalValue]') AND type in (N'P', N'PC'))
DROP PROCEDURE [common].[esp_GetNominalValue]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [common].[esp_GetNominalValue] 
(
	@Companies		varchar(max), -- Companies List as CSV
	@ValueReq		int,		  -- 1=Debit 2=Credit 3=Actual (balance, 2-1) 4=Budget 5=Budget2 6=Cleared
	@TheYear		int,		  -- Year to retrieve value for 
	@ThePeriod		int,		  -- Period to retrieve value for
	@TheCcy			int,		  -- Currency
	@NomCodeList	varchar(max), -- GL Code
	@NomCC			char(3),	  -- Cost Centre
	@NomDept		char(3),	  -- Department
	@NomCDType		char(1),
	@Commited		smallint
)
AS
BEGIN
	DECLARE @SchemaOutput table(splitdata varchar(6))
	DECLARE @start INT, @end INT 
	DECLARE @SQLString nvarchar(max)
	DECLARE @SchemaName varchar(6)
	DECLARE @NomCode varchar(10)
	DECLARE @ReturnValue float, @NomValue float
	DECLARE @Result float
	SET @ReturnValue = 0
	SET @NomValue = 0
	SET @SQLString = ''
	SET @SchemaName = ''
	SET @NomCode = ''
	
	SET NOCOUNT ON
	
CREATE TABLE #tblNomResults 
	(
	glCode						VARCHAR(10) not null PRIMARY KEY,
	TotalValue					FLOAT DEFAULT 0
	)
	
		
	SELECT @start = 1, @end = CHARINDEX(',', @NomCodeList)
	 
	WHILE @start < LEN(@NomCodeList) + 1 BEGIN 
		IF @end = 0  
			SET @end = LEN(@NomCodeList) + 1
       
		INSERT INTO #tblNomResults (glCode)  
		VALUES(SUBSTRING(@NomCodeList, @start, @end - @start)) 
		SET @start = @end + 1 
		SET @end = CHARINDEX(',', @NomCodeList, @start)
        
	END 

	SELECT @start = 1, @end = CHARINDEX(',', @Companies)
	 
		WHILE @start < LEN(@Companies) + 1 BEGIN 
			IF @end = 0  
				SET @end = LEN(@Companies) + 1
	       
			INSERT INTO @SchemaOutput (splitdata)  
			VALUES(SUBSTRING(@Companies, @start, @end - @start)) 
			SET @start = @end + 1 
			SET @end = CHARINDEX(',', @Companies, @start)
	        
		END 	

		DECLARE CurViews CURSOR FOR	(SELECT splitdata FROM @SchemaOutput)
								FOR READ ONLY

		OPEN CurViews
		
		FETCH NEXT FROM CurViews INTO @SchemaName

		WHILE @@fetch_status = 0
		BEGIN

				DECLARE GLViews CURSOR FOR	(SELECT glCode FROM #tblNomResults)
										FOR READ ONLY

				OPEN GLViews
				
				FETCH NEXT FROM GLViews INTO @NomCode

				WHILE @@fetch_status = 0
				BEGIN
					SELECT @SQLString = 'SELECT @Res = ' + @SchemaName + '.ifn_GetNominalValue(' + convert(char(2),@ValueReq) + ',' + convert(varchar(4),@TheYear) + ',' + convert(varchar(4),@ThePeriod) + ',' + convert(varchar(2),@TheCcy) + ',' + @NomCode + ',''' + convert(varchar(3),@NomCC) + ''',''' + convert(varchar(3),@NomDept) + ''',''' + convert(varchar(1),@NomCDType) + ''',' + convert(char(1),@Commited) + ')'
			 
					EXECUTE sp_executesql @SQLString, N'@Res float OUTPUT', @Res=@Result OUTPUT

					IF @Result > 100000500 SET @Result = 0
					
					IF @NomValue < 100000500 AND @Result < 100000500
						
						UPDATE #tblNomResults
						SET TotalValue = TotalValue + ROUND(@Result,2)
						WHERE glCode = @NomCode 

					ELSE
						BEGIN
							IF @Result > 100000500
							UPDATE #tblNomResults
							SET TotalValue =  @Result
							WHERE glCode = @NomCode 
						END

					FETCH NEXT FROM GLViews INTO @NomCode
				END

				CLOSE GLViews
				DEALLOCATE GLViews
		
			FETCH NEXT FROM CurViews INTO @SchemaName
		END

		CLOSE CurViews
		DEALLOCATE CurViews
				
	SELECT glCode,TotalValue FROM #tblNomResults
	
	DROP TABLE #tblNomResults
END
GO