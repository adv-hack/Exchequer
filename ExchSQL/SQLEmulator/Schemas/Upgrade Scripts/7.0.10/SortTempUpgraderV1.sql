--/////////////////////////////////////////////////////////////////////////////
--// Filename		: SORTTEMPUpgraderV1.sql
--// Author			: Chris Sandow
--// Date				: 20 May 2014
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2015. All rights reserved.
--// Description		: SQL Script to upgrade table for the 7.0.10 release
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	20 May 2014:	File Creation - Chris Sandow
--//
--/////////////////////////////////////////////////////////////////////////////

SET NOCOUNT ON

-- SORTTEMP is a temporary table, so there is no table to make changes to, but
-- we need to update the version number so that the Emulator knows that a new
-- schema is in use.
UPDATE    [!ActiveSchema!].SchemaVersion
SET       Version = 1
WHERE     SchemaName = 'sorttemp_final.xml' AND Version = 0

SET NOCOUNT OFF

