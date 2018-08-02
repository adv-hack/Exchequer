--/////////////////////////////////////////////////////////////////////////////
--// Filename		: UpdateVersion.sql
--// Author		: Chris Sandow
--// Date		: 13 Jun 2014
--// Copyright Notice	: (c) 2015 Advanced Business Software & Solutions Ltd. All rights reserved.
--// Description	: SQL Script to upgrade database for the 7.0.11 release
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	13 Jun 2014:	File Creation - Chris Sandow
--//
--/////////////////////////////////////////////////////////////////////////////

SET NOCOUNT ON

-- If the Exchequer Version property already exists, delete it
IF EXISTS (SELECT 1 FROM ::fn_listextendedproperty(N'Exchequer Version', NULL, NULL, NULL, NULL, NULL, NULL))
BEGIN
  EXEC sp_dropextendedproperty N'Exchequer Version', NULL, NULL, NULL, NULL, NULL, NULL
END

-- Add the property, using the current Exchequer Version number. This will have
-- to be changed for each version of Exchequer
EXEC sp_addextendedproperty N'Exchequer Version', N'2018 R1.1', NULL, NULL, NULL, NULL, NULL, NULL
GO 

SET NOCOUNT OFF

