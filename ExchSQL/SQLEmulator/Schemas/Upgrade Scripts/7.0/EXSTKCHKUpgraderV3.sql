--/////////////////////////////////////////////////////////////////////////////
--// Filename		: EXSTKCHKUpgraderV3.sql
--// Author			: C Sandow
--// Date				: 8 March 2012
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2015. All rights reserved.
--// Description		: SQL Script to upgrade EXSTKCHK for the 7.0 release
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	22 August 2012:	File Creation - C Sandow
--//
--/////////////////////////////////////////////////////////////////////////////

SET NOCOUNT ON

-- Update the Version number for the SchemaVersion
UPDATE    [!ActiveSchema!].SchemaVersion
SET       Version = 3
WHERE     SchemaName = 'EXSTKCHK_Final.xml' AND Version = 2

SET NOCOUNT OFF

