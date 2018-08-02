--/////////////////////////////////////////////////////////////////////////////
--// Filename		: ContactRoleUpgraderV1.sql
--// Author			: Rahul Bhavani
--// Date				: 25 April 2017
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2016. All rights reserved.
--// Description		: SQL Script to update version of ContactRole.xml in SchemaVersion table
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1   25 April 2017: Removed f_date_created and f_date_modified from schema(ABSEXCH-16979)
--/////////////////////////////////////////////////////////////////////////////

SET NOCOUNT ON

-- Update the Version number for the SchemaVersion table
UPDATE    [!ActiveSchema!].SchemaVersion
SET       Version = 1
WHERE     SchemaName = 'ContactRole.xml' AND Version = 0

SET NOCOUNT OFF
