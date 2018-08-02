--/////////////////////////////////////////////////////////////////////////////
--// Filename		: ifn_GetCompanyCurrentProcessCount.sql
--// Author		: 
--// Date		: 17th Jun 2008 
--// Copyright Notice	: (c) 2015 Advanced Business Software & Solutions Ltd. All rights reserved.
--// Description:	This function returns a count of users attached to the given company 
--// Execute: SELECT [common].[ifn_GetCompanyCurrentProcessCount] ('ZZZZ01')		
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	: File Creation
--//
--/////////////////////////////////////////////////////////////////////////////

IF  EXISTS ( SELECT TOP 1 1  
			 FROM	dbo.sysobjects 
			 WHERE	id = OBJECT_ID(N'[common].[ifn_GetCompanyCurrentProcessCount]') 
			 AND xtype in (N'FN', N'IF', N'TF')
			)

	DROP FUNCTION [common].[ifn_GetCompanyCurrentProcessCount]


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

CREATE FUNCTION [common].[ifn_GetCompanyCurrentProcessCount]
(
	  @iv_CompanyCode			varchar(50)
)
RETURNS int
AS
BEGIN	
	DECLARE   @CompanyCode		varchar(50)
			, @CurrentDb		varchar(50)
			, @c_SchemaVersion	varchar(50)
			, @c_CommentedText  varchar(50)
			, @c_ifnNAme		varchar(50)
			, @c_Setting 		varchar(50)
			, @c_dbosysobject	varchar(50)
			, @c_spid			int


	SELECT	  @CompanyCode = '%' + @iv_CompanyCode + '%'
			, @CurrentDb = DB_NAME()
			, @c_SchemaVersion = '%SchemaVersion%'
			, @c_CommentedText = '%K=0*//*O=5*%'
			, @c_ifnNAme = UPPER('%ifn_GetCompanyCurrentProcessCount%')
			, @c_Setting	= '%SETTINGS%'
			, @c_dbosysobject = UPPER('%dbo.sysobjects%')
			, @c_spid = @@SPID
			
	RETURN (	
				SELECT		    COUNT(*) as CountLoginToCompany
				FROM			sys.sysprocesses				  SP
				CROSS APPLY		sys.dm_exec_sql_text (sql_handle) SE
				WHERE			(DB_NAME(SP.dbid) = @CurrentDb
				AND				UPPER(RTRIM(LTRIM(CAST(text AS VARCHAR(MAX))))) LIKE @CompanyCode)
				AND				UPPER(RTRIM(LTRIM(CAST(text AS VARCHAR(MAX))))) NOT LIKE @c_SchemaVersion	-- [Emulator is checking schemaVersion- we can exclude]
				AND				UPPER(RTRIM(LTRIM(CAST(text AS VARCHAR(MAX))))) NOT LIKE @c_CommentedText	-- [Excluding : Comment statement in query for company]
				AND				UPPER(RTRIM(LTRIM(CAST(text AS VARCHAR(MAX))))) NOT LIKE @c_ifnNAme			-- [Excluding : function called ]
				AND				UPPER(RTRIM(LTRIM(CAST(text AS VARCHAR(MAX))))) NOT LIKE '%EXCHQSS%'
				AND				program_name <> ''
				--AND				UPPER(RTRIM(LTRIM(CAST(text AS VARCHAR(MAX))))) NOT LIKE @c_Setting			-- [Excluding : updating some setting through reports]
				--AND				UPPER(RTRIM(LTRIM(CAST(text AS VARCHAR(MAX))))) NOT LIKE @c_dbosysobject	-- [Excluding : sysobject records]
				--AND				UPPER(RTRIM(LTRIM(CAST(text AS VARCHAR(MAX))))) NOT LIKE 'SELECT COUNT(*)%'
				AND 			SP.spid <> @c_SPID	
			)
END
