--/////////////////////////////////////////////////////////////////////////////
--// Filename		: isp_DropSchemaReferentialConstraints.sql
--// Author		: Catherine Bremner
--// Date		: 22 March 2007
--// Copyright Notice	: (c) 2015 Advanced Business Software & Solutions Ltd. All rights reserved.
--// Description	: SQL Script to add isp_DropSchemaReferentialConstraints stored procedure.
--//                  Stored Procedure to drop all of the foreign key constraints
--//                  associated with a particular schema
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	: 22 March 2007 : Catherine Bremner : File Creation
--//  2 : 21 August 2008 : Nilesh Desai : Commented RAISERROR before and after executing sp_executesql
--//
--/////////////////////////////////////////////////////////////////////////////

/****** Object:  StoredProcedure [common].[isp_DropSchemaReferentialConstraints]    Script Date: 03/23/2007 15:39:00 ******/

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[common].[isp_DropSchemaReferentialConstraints]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
BEGIN
  DROP PROCEDURE [common].[isp_DropSchemaReferentialConstraints]
END
GO

CREATE PROCEDURE [common].[isp_DropSchemaReferentialConstraints](
	@iv_SchemaName NVARCHAR(128)
	)
AS
BEGIN

	DECLARE	  @SQLString		NVARCHAR(1000)
			, @TranCount		INT
			, @ObjectName		NVARCHAR(100)
			, @TableName		NVARCHAR(100)
			, @ConstraintName	NVARCHAR(100)
			, @ReturnValue		INT

	SET NOCOUNT ON

	SET @TranCount = @@TRANCOUNT

	SET LOCK_TIMEOUT 30000

	-- Declare a READ-ONLY cursor to identify each Foreign Key constraint

	DECLARE CurConstraints CURSOR FOR	SELECT	CONSTRAINT_NAME
										FROM	INFORMATION_SCHEMA.TABLE_CONSTRAINTS
										WHERE	CONSTRAINT_TYPE = 'FOREIGN KEY'
										AND		CONSTRAINT_SCHEMA = @iv_SchemaName
										ORDER BY TABLE_NAME
						   FOR READ ONLY

	OPEN CurConstraints

	FETCH NEXT FROM CurConstraints INTO @ConstraintName

	WHILE @@fetch_status = 0
	BEGIN

		SELECT	@TableName = TABLE_NAME
		FROM	INFORMATION_SCHEMA.TABLE_CONSTRAINTS
		WHERE	CONSTRAINT_TYPE = 'FOREIGN KEY'
		AND		CONSTRAINT_NAME = @ConstraintName

		SELECT @ObjectName = @iv_SchemaName + N'.' + @TableName

		SELECT @SQLString = 'ALTER TABLE ' + @ObjectName + ' DROP CONSTRAINT ' + @ConstraintName

		--RAISERROR('Dropping Constraint: %s', 1, 1, @ConstraintName)
	 
		EXECUTE @ReturnValue = sp_executesql @SQLString

		IF @ReturnValue <> 0
		BEGIN
			IF @@TRANCOUNT > @TranCount ROLLBACK TRAN
				RAISERROR('There is a problem dropping Constraint: %s', 1, 1, @ConstraintName)

			RETURN @ReturnValue
		END

		--RAISERROR ('Finished dropping Constraint: %s', 1, 1, @ConstraintName)

		FETCH NEXT FROM CurConstraints INTO @ConstraintName
	END

	CLOSE CurConstraints
	DEALLOCATE CurConstraints

	RETURN 0

END