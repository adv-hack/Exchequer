--/////////////////////////////////////////////////////////////////////////////
--// Filename		: isp_DropSchemaViews.sql
--// Author		: Catherine Bremner
--// Date		: 22 March 2007
--// Copyright Notice	: (c) 2015 Advanced Business Software & Solutions Ltd. All rights reserved.
--// Description	: SQL Script to add isp_DropSchemaViews stored procedure.
--//                  Stored Procedure to drop all of the views
--//                  associated with a particular schema
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	: 22 March 2007 : Catherine Bremner : File Creation
--//  2 : 21 August 2008 : Nilesh Desai : Commented RAISERROR before and after executing sp_executesql
--//
--/////////////////////////////////////////////////////////////////////////////

/****** Object:  StoredProcedure [common].[isp_DropSchemaViews]    Script Date: 03/23/2007 15:39:00 ******/

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[common].[isp_DropSchemaViews]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
BEGIN
  DROP PROCEDURE [common].[isp_DropSchemaViews]
END
GO

CREATE PROCEDURE [common].[isp_DropSchemaViews](
	@iv_SchemaName NVARCHAR(128)
	)
AS
BEGIN

	DECLARE   @SQLString	NVARCHAR(1000)
			, @TranCount	INT
			, @ObjectName	NVARCHAR(100)
			, @ViewName		NVARCHAR(100)
			, @ReturnValue	INT

	SET NOCOUNT ON

	SET @TranCount = @@TRANCOUNT

	SET LOCK_TIMEOUT 30000

	-- Declare a READ-ONLY cursor to identify each View in schema

	DECLARE CurViews CURSOR FOR	SELECT	TABLE_NAME
								FROM	INFORMATION_SCHEMA.TABLES
								WHERE	TABLE_SCHEMA = @iv_SchemaName
								AND		TABLE_TYPE = 'VIEW'
					 FOR READ ONLY

	OPEN CurViews
	
	FETCH NEXT FROM CurViews INTO @ViewName

	WHILE @@fetch_status = 0
	BEGIN

		SELECT @ObjectName = @iv_SchemaName + N'.' + @ViewName

	    SELECT @SQLString = 'DROP VIEW ' + @ObjectName

		--RAISERROR('Dropping View: %s', 1, 1, @ObjectName)
 
		EXECUTE @ReturnValue = sp_executesql @SQLString

		IF @ReturnValue <> 0
		BEGIN
			IF @@TRANCOUNT > @TranCount ROLLBACK TRAN
				RAISERROR('There is a problem dropping View: %s', 1, 1, @ObjectName)

			RETURN @ReturnValue
		END

		--RAISERROR ('Finished dropping View: %s', 1, 1, @ObjectName)

		FETCH NEXT FROM CurViews INTO @ViewName
	END

	CLOSE CurViews
	DEALLOCATE CurViews

	RETURN 0

END
