--/////////////////////////////////////////////////////////////////////////////
--// Filename		: UpdateDatabaseCompatibilityLevel.sql
--// Author		: Glen Jones / Chris Sandow
--// Date		: 2015-02-24
--// Copyright Notice	: (c) 2015 Advanced Business Software & Solutions Ltd. All rights reserved.
--// Description	: SQL Script to upgrade database for the 7.0.13 release
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	2015-02-24:	File Creation - Chris Sandow
--//
--/////////////////////////////////////////////////////////////////////////////

DECLARE @ExistingCompatibilityLevel INT
      , @DatabaseName               VARCHAR(100)
      , @SQLCommand                 VARCHAR(max)

SELECT @DatabaseName = DB_NAME()

SELECT @ExistingCompatibilityLevel = compatibility_level
FROM   sys.databases d
WHERE  name = @DatabaseName

--For Debug
--SELECT @ExistingCompatibilityLevel, @DatabaseName

IF @ExistingCompatibilityLevel < 100
BEGIN
  SET @SQLCommand = 'ALTER DATABASE ' + @DatabaseName + ' SET COMPATIBILITY_LEVEL = 100;'
  EXEC(@SQLCommand)
END
