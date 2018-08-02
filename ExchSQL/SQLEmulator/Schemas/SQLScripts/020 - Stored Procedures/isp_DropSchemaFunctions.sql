--/////////////////////////////////////////////////////////////////////////////
--// Filename		: isp_DropSchemaFunctions.sql
--// Author		: Catherine Bremner
--// Date		: 22 March 2007
--// Copyright Notice	: (c) 2015 Advanced Business Software & Solutions Ltd. All rights reserved.
--// Description	: SQL Script to add isp_DropSchemaFunctions stored procedure.
--//                  Stored Procedure to drop all of the Functions associated 
--//                  with a particular schema but that are not bound to by 
--//                  other objects
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	: 22 March 2007 : Catherine Bremner : File Creation
--//  2 : 21 August 2008 : Nilesh Desai : Commented RAISERROR before and after executing sp_executesql and not exists condition [after changing sequence it will work]
--//
--/////////////////////////////////////////////////////////////////////////////

/****** Object:  StoredProcedure [common].[isp_DropSchemaFunctions]    Script Date: 03/23/2007 15:39:00 ******/

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[common].[isp_DropSchemaFunctions]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE [common].[isp_DropSchemaFunctions]
END
GO

CREATE PROCEDURE [common].[isp_DropSchemaFunctions](
	@iv_SchemaName NVARCHAR(128)
	)
AS
BEGIN

	DECLARE	  @SQLString	NVARCHAR(1000)
			, @TranCount	INT
			, @ObjectName	NVARCHAR(100)
			, @FunctionName	NVARCHAR(100)
			, @ReturnValue	INT

	SET NOCOUNT ON

	SET @TranCount = @@TRANCOUNT

	SET LOCK_TIMEOUT 30000

	-- Declare a READ-ONLY cursor to identify each Function in schema

	DECLARE CurFunctions CURSOR FOR	SELECT	ROUTINE_NAME 
									FROM	INFORMATION_SCHEMA.ROUTINES
									WHERE	SPECIFIC_SCHEMA = @iv_SchemaName
									AND		ROUTINE_TYPE = 'FUNCTION'
									/*
									AND		NOT EXISTS ( SELECT *
														 FROM sys.sql_dependencies
														 WHERE referenced_major_id = OBJECT_ID(@iv_SchemaName + '.' + ROUTINE_NAME) )
									*/					 
					     FOR READ ONLY

	OPEN CurFunctions

	FETCH NEXT FROM CurFunctions INTO @FunctionName

	WHILE @@fetch_status = 0
	BEGIN

		SELECT @ObjectName = @iv_SchemaName + N'.' + @FunctionName

		SELECT @SQLString = 'DROP FUNCTION ' + @ObjectName

		--RAISERROR('Dropping Function: %s', 1, 1, @ObjectName)
 
		EXECUTE @ReturnValue = sp_executesql @SQLString

		IF @ReturnValue <> 0
		BEGIN
			IF @@TRANCOUNT > @TranCount ROLLBACK TRAN
				RAISERROR('There is a problem dropping Function: %s', 1, 1, @ObjectName)

			RETURN @ReturnValue
	    END

		--RAISERROR ('Finished dropping Function: %s', 1, 1, @ObjectName)

		FETCH NEXT FROM CurFunctions INTO @FunctionName
	END

	CLOSE CurFunctions
	DEALLOCATE CurFunctions

	RETURN 0

END
