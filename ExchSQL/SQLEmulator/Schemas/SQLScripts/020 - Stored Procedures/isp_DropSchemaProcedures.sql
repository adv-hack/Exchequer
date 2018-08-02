--/////////////////////////////////////////////////////////////////////////////
--// Filename		: isp_DropSchemaProcedures.sql
--// Author		: Catherine Bremner
--// Date		: 22 March 2007
--// Copyright Notice	: (c) 2015 Advanced Business Software & Solutions Ltd. All rights reserved.
--// Description	: SQL Script to add isp_DropSchemaProcedures stored procedure.
--//                  Stored Procedure to drop all of the stored procedures
--//                  associated with a particular schema
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	: 22 March 2007 : Catherine Bremner : File Creation
--//  2 : 21 August 2008 : Nilesh Desai : Commented RAISERROR before and after executing sp_executesql
--//
--/////////////////////////////////////////////////////////////////////////////

/****** Object:  StoredProcedure [common].[isp_DropSchemaProcedures]    Script Date: 03/23/2007 15:39:00 ******/

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[common].[isp_DropSchemaProcedures]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
BEGIN
  DROP PROCEDURE [common].[isp_DropSchemaProcedures]
END
GO

CREATE PROCEDURE [common].[isp_DropSchemaProcedures](
	@iv_SchemaName NVARCHAR(128)
	)
AS
BEGIN

  DECLARE	  @SQLString		NVARCHAR(1000)
			, @TranCount		INT
			, @ObjectName		NVARCHAR(100)
			, @ProcedureName	NVARCHAR(100)
			, @ReturnValue		INT

	SET NOCOUNT ON

	SET @TranCount = @@TRANCOUNT

	SET LOCK_TIMEOUT 30000

	-- Declare a READ-ONLY cursor to identify each Function in schema

	DECLARE CurProcedures CURSOR FOR	SELECT	ROUTINE_NAME 
										FROM	INFORMATION_SCHEMA.ROUTINES
										WHERE	SPECIFIC_SCHEMA = @iv_SchemaName
										AND		ROUTINE_TYPE = 'PROCEDURE'
						  FOR READ ONLY

	OPEN CurProcedures

	FETCH NEXT FROM CurProcedures INTO @ProcedureName

	WHILE @@fetch_status = 0
	BEGIN

		SELECT @ObjectName = @iv_SchemaName + N'.' + @ProcedureName

		SELECT @SQLString = 'DROP PROCEDURE ' + @ObjectName

		--RAISERROR('Dropping Stored Procedure: %s', 1, 1, @ObjectName)
 
		EXECUTE @ReturnValue = sp_executesql @SQLString

		IF @ReturnValue <> 0
		BEGIN
			IF @@TRANCOUNT > @TranCount ROLLBACK TRAN
				RAISERROR('There is a problem dropping Stored Procedure: %s', 1, 1, @ObjectName)

			RETURN @ReturnValue
		END

		--RAISERROR ('Finished dropping Stored Procedure: %s', 1, 1, @ObjectName)

		FETCH NEXT FROM CurProcedures INTO @ProcedureName
	END

	CLOSE CurProcedures
	DEALLOCATE CurProcedures

	RETURN 0

END
