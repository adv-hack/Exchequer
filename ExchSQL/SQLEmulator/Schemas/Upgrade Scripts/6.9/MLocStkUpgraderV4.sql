--/////////////////////////////////////////////////////////////////////////////
--// Filename		: MLocStkUpgraderV4.sql
--// Author			: Chris Sandow
--// Date				: 2011-09-30
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2015. All rights reserved.
--// Description		: SQL Script to upgrade table for the 6.9 release
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	2011-09-30:	File Creation - Chris Sandow
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
            WHERE  (tab.id = object_id('[!ActiveSchema!].MLocStk'))
          )
   AND
   NOT EXISTS (
                SELECT *
                FROM   sysobjects tab INNER JOIN
                       syscolumns col ON tab.id = col.id
                WHERE  (tab.id = object_id('[!ActiveSchema!].MLocStk'))
                 AND   (col.name = 'ArcUD5')
              )
BEGIN
  ALTER TABLE [!ActiveSchema!].MLocStk
  ADD
    -- Fields which are in the <fixedfields> section of the XML schema MUST
    -- be specified as NOT NULL, with a DEFAULT.
    --
    -- Fields which are in the <recordtype> sections of the XML schema MUST be
    -- specified as NULL (to allow null values).
    ArcUD5  varchar(30) NULL,
    ArcUD6  varchar(30) NULL,
    ArcUD7  varchar(30) NULL,
    ArcUD8  varchar(30) NULL,
    ArcUD9  varchar(30) NULL,
    ArcUD10 varchar(30) NULL,
    BrGroupBy int NULL
END

-- Now we update the Version number for the SchemaVersion table
UPDATE    [!ActiveSchema!].SchemaVersion
SET       Version = 4
WHERE     SchemaName = 'MLocStk_Final.xml' AND Version = 3

SET NOCOUNT OFF

