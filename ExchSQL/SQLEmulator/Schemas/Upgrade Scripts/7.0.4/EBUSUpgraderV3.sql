--/////////////////////////////////////////////////////////////////////////////
--// Filename		: EBUSUpgraderV3.sql
--// Author			: Chris Sandow
--// Date				: 2013-05-20
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2015. All rights reserved.
--// Description		: SQL Script to upgrade table for the 7.0.4 release
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	2013-05-20:	File Creation - Chris Sandow
--//
--/////////////////////////////////////////////////////////////////////////////

SET NOCOUNT ON

-- First we check to see if the new column already exists in the table. This is
-- because all the upgrade scripts are run every time the system is upgraded,
-- so we must be careful not to try to make amendments which have already been
-- done.
IF EXISTS (
            SELECT *
            FROM   sysobjects tab
            WHERE  (tab.id = object_id('[!ActiveSchema!].EBUS'))
          )
   AND
   NOT EXISTS (
                SELECT *
                FROM   sysobjects tab INNER JOIN
                       syscolumns col ON tab.id = col.id
                WHERE  (tab.id = object_id('[!ActiveSchema!].EBUS'))
                 AND   (col.name = 'CompDescLinesFromXML')
              )
BEGIN
  ALTER TABLE [!ActiveSchema!].EBUS
  ADD
    -- Fields which are in the <recordtype> sections of the XML schema MUST be
    -- specified as NULL (to allow null values).
    CompDescLinesFromXML bit NULL
END

-- Now we update the Version number for the SchemaVersion table
UPDATE    [!ActiveSchema!].SchemaVersion
SET       Version = 3
WHERE     SchemaName = 'EBUS_Final.xml' AND Version = 2

SET NOCOUNT OFF
