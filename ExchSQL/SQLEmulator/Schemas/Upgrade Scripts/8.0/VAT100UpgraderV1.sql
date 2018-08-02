--/////////////////////////////////////////////////////////////////////////////
--// Filename		: VAT100UpgraderV1.sql
--// Author			: Chris Sandow
--// Date				: 14 August 2015
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2015. All rights reserved.
--// Description		: SQL Script to upgrade table for the 2015 R1 release
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	14 August 2015:	File Creation - Chris Sandow
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
            WHERE  (tab.id = object_id('[!ActiveSchema!].VAT100'))
          )
   AND
   NOT EXISTS (
                SELECT *
                FROM   sysobjects tab INNER JOIN
                       syscolumns col ON tab.id = col.id
                WHERE  (tab.id = object_id('[!ActiveSchema!].VAT100'))
                 AND   (col.name = 'vatPollingURL')
              )
BEGIN
  ALTER TABLE [!ActiveSchema!].VAT100
  ADD
    -- Fields which are in the <fixedfields> section of the XML schema MUST
    -- be specified as NOT NULL, with a DEFAULT.
    --
    -- Fields which are in the <recordtype> sections of the XML schema MUST be
    -- specified as NULL (to allow null values).
    [vatPollingURL] [varchar](255) NOT NULL
END

-- Now we update the Version number for the SchemaVersion table
UPDATE    [!ActiveSchema!].SchemaVersion
SET       Version = 1
WHERE     SchemaName = 'VAT100.xml' AND Version = 0

SET NOCOUNT OFF

