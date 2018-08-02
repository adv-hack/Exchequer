--/////////////////////////////////////////////////////////////////////////////
--// Filename		: isp_DropCustomerSchema.sql
--// Author		: 
--// Date		: 
--// Copyright Notice	: (c) 2015 Advanced Business Software & Solutions Ltd. All rights reserved.
--// Description	: SQL Script to add isp_DropCustomerSchema stored procedure.
--//                  Wrapper Stored Procedure to drop all of the objects associated with a particular schema.
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	: 23 March 2007 : Catherine Bremner : File Creation
--//  2 : 21 August 2008 : Nilesh Desai
--//  3 :  1 September 2008 : James Waygood : Changed order of deletion to enable functions to be released
--//  4 :  3 December 2009 : James Waygood : Changed order of deletion for additional History Views
--//  5 : 24 March 2014 : Chris Sandow : Moved disabling of referential integrity to BEFORE attempting to delete the tables
--//
--/////////////////////////////////////////////////////////////////////////////

/****** Object:  StoredProcedure [common].[isp_DropCustomerSchema]    Script Date: 03/23/2007 15:39:00 ******/

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[common].[isp_DropCustomerSchema]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
BEGIN
  DROP PROCEDURE [common].[isp_DropCustomerSchema]
END
GO

CREATE PROCEDURE [common].[isp_DropCustomerSchema](
	@iv_SchemaName NVARCHAR(128)
	)
AS
BEGIN

	DECLARE   @SQLString		NVARCHAR(1000)
			, @TranCount		INT
			, @ReturnValue	INT

	SET NOCOUNT ON

	SET @TranCount = @@TRANCOUNT

	-- Drop any Foreign Key Constraints on any tables owned by the schema

	EXEC @ReturnValue = [common].[isp_DropSchemaReferentialConstraints] @iv_SchemaName = @iv_SchemaName

	IF @ReturnValue <> 0
	BEGIN
		IF @@TRANCOUNT > @TranCount ROLLBACK TRAN
			RAISERROR('There was a problem dropping Foreign Key Constraints.', 1, 1)
		
		RETURN -1
	END

	-- Drop any Views owned by the schema

	EXEC @ReturnValue = [common].[isp_DropSchemaViews] @iv_SchemaName = @iv_SchemaName

	IF @ReturnValue <> 0
	BEGIN
		IF @@TRANCOUNT > @TranCount ROLLBACK TRAN
			RAISERROR('There was a problem dropping Views.', 1, 1)
		
		RETURN -1
	END

	-- Drop any Tables owned by the schema
	EXEC @ReturnValue = [common].[isp_DropSchemaTables] @iv_SchemaName = @iv_SchemaName

	IF @ReturnValue <> 0
	BEGIN
		IF @@TRANCOUNT > @TranCount ROLLBACK TRAN
			RAISERROR('There was a problem dropping Tables.', 1, 1)
		
		RETURN -1
	END

	-- Drop any User-Defined Functions owned by the schema

	EXEC @ReturnValue = [common].[isp_DropSchemaFunctions] @iv_SchemaName = @iv_SchemaName

	IF @ReturnValue <> 0
	BEGIN
		IF @@TRANCOUNT > @TranCount ROLLBACK TRAN
			RAISERROR('There was a problem dropping Functions.', 1, 1)
		
		RETURN -1
	END

	-- Drop any Stored Procedures owned by the schema

	EXEC @ReturnValue = [common].[isp_DropSchemaProcedures] @iv_SchemaName = @iv_SchemaName

	IF @ReturnValue <> 0
	BEGIN
		IF @@TRANCOUNT > @TranCount ROLLBACK TRAN
			RAISERROR('There was a problem dropping Stored Procedures.', 1, 1)
		
		RETURN -1
	END

    -- Drop any User-Defined Functions owned by the schema (this will drop any that were
    -- referenced by other objects)

	EXEC @ReturnValue = [common].[isp_DropSchemaFunctions] @iv_SchemaName = @iv_SchemaName

	IF @ReturnValue <> 0
	BEGIN
		IF @@TRANCOUNT > @TranCount ROLLBACK TRAN
			RAISERROR('There was a problem dropping Functions(2).', 1, 1)
		
		RETURN -1
	END
	
	-- Drop the schema itself  
	SELECT @SQLString = 'DROP SCHEMA ' + QUOTENAME(@iv_SchemaName,'[')
	EXECUTE @ReturnValue = sp_executesql @SQLString
	IF @ReturnValue <> 0
	BEGIN
		IF @@TRANCOUNT > @TranCount ROLLBACK TRAN
		    RAISERROR('There was a problem dropping schema: %s', 1, 1, @iv_SchemaName)
		
		RETURN @ReturnValue
	END

	RETURN 0
END
