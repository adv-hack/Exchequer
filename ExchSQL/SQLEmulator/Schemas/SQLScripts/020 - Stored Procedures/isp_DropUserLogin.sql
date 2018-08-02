--/////////////////////////////////////////////////////////////////////////////
--// Filename		: isp_DropUserLogin.sql
--// Author		: 
--// Date		: 
--// Copyright Notice	: (c) 2015 Advanced Business Software & Solutions Ltd. All rights reserved.
--// Description	: SQL Script to add isp_DropUserLogin stored procedure
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	: File Creation
--//
--/////////////////////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[common].[isp_DropUserLogin]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
BEGIN
  DROP PROCEDURE [common].[isp_DropUserLogin]
END
GO

CREATE PROCEDURE [common].[isp_DropUserLogin](
	@iv_UserName NVARCHAR(128),
  @iv_DropLogin BIT
	)
AS
BEGIN
  DECLARE @SQLString		  NVARCHAR(1000)
    , @TranCount		      INT
    , @ReturnValue	      INT
    , @LoginName          NVARCHAR(128)

	SET NOCOUNT ON

	SET @TranCount = @@TRANCOUNT


  -- Get the server login for the database user
  SELECT @LoginName = SUSER_SNAME(sid)
  FROM sysusers
  WHERE name = @iv_UserName

  -- Drop the database user
  SELECT @SQLString = 'DROP USER ' + QUOTENAME(@iv_UserName, '[')
  EXECUTE @ReturnValue = sp_executesql @SQLString
  IF @ReturnValue <> 0
  BEGIN
		IF @@TRANCOUNT > @TranCount ROLLBACK TRAN
    RAISERROR('There was a problem dropping user: %s', 1, 1, @iv_UserName)
		RETURN @ReturnValue
  END

  -- Drop the server login if asked
  IF @iv_DropLogin = 1
  BEGIN
    SELECT @SQLString = 'DROP LOGIN ' + QUOTENAME(@LoginName, '[')
    EXECUTE @ReturnValue = sp_executesql @SQLString
    IF @ReturnValue <> 0
    BEGIN
			IF @@TRANCOUNT > @TranCount ROLLBACK TRAN
      RAISERROR('There was a problem dropping the login: %s', 1, 1, @LoginName)
			RETURN @ReturnValue
    END
  END

  RETURN 0

END
