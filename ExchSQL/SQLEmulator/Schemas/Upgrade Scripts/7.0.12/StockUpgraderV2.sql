--/////////////////////////////////////////////////////////////////////////////
--// Filename		: StockUpgraderV2.sql
--// Author			: Chris Sandow
--// Date				: 2014-09-08
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2015. All rights reserved.
--// Description		: SQL Script to upgrade table for the 7.1 release
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	2014-09-08:	File Creation - Chris Sandow
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
            WHERE  (tab.id = object_id('[!ActiveSchema!].STOCK'))
          )
   AND
   NOT EXISTS (
                SELECT *
                FROM   sysobjects tab INNER JOIN
                       syscolumns col ON tab.id = col.id
                WHERE  (tab.id = object_id('[!ActiveSchema!].STOCK'))
                 AND   (col.name = 'stIsService')
              )
BEGIN
  ALTER TABLE [!ActiveSchema!].STOCK
  ADD
    -- Fields which are in the <fixedfields> section of the XML schema MUST
    -- be specified as NOT NULL, with a DEFAULT.
    --
    -- Fields which are in the <recordtype> sections of the XML schema MUST be
    -- specified as NULL (to allow null values).
    stIsService bit NOT NULL DEFAULT 0
END

-- Now we update the Version number for the SchemaVersion table
UPDATE    [!ActiveSchema!].SchemaVersion
SET       Version = 2
WHERE     SchemaName = 'STOCK_Final.xml' AND Version = 1

SET NOCOUNT OFF

