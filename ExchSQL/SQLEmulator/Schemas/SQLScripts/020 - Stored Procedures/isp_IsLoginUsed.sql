--/////////////////////////////////////////////////////////////////////////////
--// Filename		: isp_IsLoginUsed.sql
--// Author		: 
--// Date		: 
--// Copyright Notice	: (c) 2015 Advanced Business Software & Solutions Ltd. All rights reserved.
--// Description	: SQL Script to add isp_IsLoginUsed stored procedure.
--//                  This procedure checks whether the login associated with 
--//                  the current connection is mapped to a user in any 
--//                  databases (excluding the current database)
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	: File Creation
--//
--/////////////////////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[common].[isp_IsLoginUsed]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
BEGIN
  DROP PROCEDURE [common].[isp_IsLoginUsed]
END
GO

CREATE PROCEDURE [common].[isp_IsLoginUsed](
  @ov_LoginUsed bit OUTPUT
	)
AS
BEGIN
  DECLARE @SQLString		  NVARCHAR(1000)
    , @TranCount		      INT
    , @ReturnValue	      INT
    , @LoginName          NVARCHAR(128)
    , @DatabaseName       NVARCHAR(128)
    , @ExcludeDatabase    NVARCHAR(128)
    , @DatabaseUserCount  INT
    , @LoginMappedToUser  BIT

	SET NOCOUNT ON

	SET @TranCount = @@TRANCOUNT


  SELECT  @LoginName = ORIGINAL_LOGIN()
      ,   @ExcludeDatabase = DB_NAME()

  -- Get the server login for the database user
  -- Iterate the databases to check whether the server login is used in any other databases
  SET @LoginMappedToUser = 0
  DECLARE CursorDatabases CURSOR FOR
					SELECT
	          dtb.name AS [Name]
          FROM
	          master.dbo.sysdatabases AS dtb
          WHERE
		          ((DATABASEPROPERTY(dtb.name,'IsInLoad') = 0 and
                   (DATABASEPROPERTY(dtb.name,'IsInRecovery') = 0 or DATABASEPROPERTY(dtb.name,'IsInRecovery') is null) and
                   (DATABASEPROPERTY(dtb.name,'IsNotRecovered') = 0 or DATABASEPROPERTY(dtb.name,'IsNotRecovered') is null) and
                    DATABASEPROPERTY(dtb.name,'IsSuspect') = 0 and
                    DATABASEPROPERTY(dtb.name,'IsOffline') = 0 and
                    DATABASEPROPERTY(dtb.name,'IsInStandBy') = 0 and
                   (DATABASEPROPERTY(dtb.name,'IsShutDown') = 0 or DATABASEPROPERTY(dtb.name,'IsShutDown') is null) and
                    DATABASEPROPERTY(dtb.name,'IsEmergencyMode') = 0)
              )
              AND 
              dtb.name <> @ExcludeDatabase
          ORDER BY
	          [Name] ASC

  OPEN CursorDatabases

  FETCH NEXT FROM CursorDatabases INTO @DatabaseName

  WHILE @@fetch_status = 0
  BEGIN
    BEGIN TRY
      -- test whether the database has any users mapped to the login
      SELECT @SQLString = 'SELECT 
	        @InnerUserCount = COUNT(*)
        FROM ' + QUOTENAME(@DatabaseName,'[') + '.dbo.sysusers AS u
        WHERE
	        (
		        (
			        (u.issqlrole != 1 and u.isapprole != 1 ) 
			        or 
			        (u.sid=0x00)
		        ) 
		        and 
		        u.isaliased != 1 
		        and 
		        u.hasdbaccess != 0
	        )
	        and
	        ( ISNULL(suser_sname(u.sid),N'''') = @InnerLogin)'

      EXECUTE @ReturnValue = sp_executesql @SQLString,
                N'@InnerUserCount INT OUTPUT, @InnerLogin NVARCHAR(128)',
                @InnerUserCount = @DatabaseUserCount OUTPUT,
                @InnerLogin = @LoginName
      IF @ReturnValue <> 0
      BEGIN
			  IF @@TRANCOUNT > @TranCount ROLLBACK TRAN
        RAISERROR('There was a problem checking the database (%s) for users mapped to login (%s)', 1, 1, @DatabaseName, @LoginName)
			  RETURN @ReturnValue
      END
      IF @DatabaseUserCount <> 0
      BEGIN
        -- The database has a user mapped to the login
        -- Set the @CanDeleteLogin flag to false to prevent deletion
        SET @LoginMappedToUser = 1
        -- Drop out of the loop as we don't need to check any more databases
        BREAK
      END
    END TRY
    BEGIN CATCH
      IF ERROR_NUMBER() <> 916  -- 916 is raised if we can't access the database => not mapped to a user
      BEGIN
        EXEC isp_RethrowError -- re-throw the original error
        RETURN ERROR_NUMBER()
      END
    END CATCH
    
    FETCH NEXT FROM CursorDatabases INTO @DatabaseName
  END

  CLOSE CursorDatabases
  DEALLOCATE CursorDatabases

  SET @ov_LoginUsed = @LoginMappedToUser

  RETURN 0

END
GO

GRANT EXECUTE ON common.isp_IsLoginUsed TO common_readonly
GO
