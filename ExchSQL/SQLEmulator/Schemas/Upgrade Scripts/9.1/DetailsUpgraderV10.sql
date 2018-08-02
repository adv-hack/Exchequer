--/////////////////////////////////////////////////////////////////////////////
--// Filename		: DETAILSUpgraderV10.sql
--// Author			: Chris Sandow
--// Date				: 21 March 2016
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2016. All rights reserved.
--// Description		: SQL Script to upgrade table for the 2016 R2 release
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	21st March 2016:	File Creation - Chris Sandow
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
            WHERE  (tab.id = object_id('[!ActiveSchema!].DETAILS'))
          )
   AND
   NOT EXISTS (
                SELECT *
                FROM   sysobjects tab INNER JOIN
                       syscolumns col ON tab.id = col.id
                WHERE  (tab.id = object_id('[!ActiveSchema!].DETAILS'))
                 AND   (col.name = 'tlTaxRegion')
              )
BEGIN
  ALTER TABLE [!ActiveSchema!].DETAILS
  ADD
    -- Fields which are in the <fixedfields> section of the XML schema MUST
    -- be specified as NOT NULL, with a DEFAULT.
    --
    -- Fields which are in the <recordtype> sections of the XML schema MUST be
    -- specified as NULL (to allow null values).
    tlTaxRegion int NOT NULL DEFAULT 0
END
GO

--/////////////////////////////////////////////////////////////////////////////
-- The EBUSDETL table duplicates the structure of the DETAILS table, so it must
-- be updated to match
--/////////////////////////////////////////////////////////////////////////////
IF EXISTS (
            SELECT *
            FROM   sysobjects tab
            WHERE  (tab.id = object_id('[!ActiveSchema!].EBUSDETL'))
          )
   AND
   NOT EXISTS (
                SELECT *
                FROM   sysobjects tab INNER JOIN
                       syscolumns col ON tab.id = col.id
                WHERE  (tab.id = object_id('[!ActiveSchema!].EBUSDETL'))
                 AND   (col.name = 'tlTaxRegion')
              )
BEGIN
  ALTER TABLE [!ActiveSchema!].EBUSDETL
  ADD
    -- Fields which are in the <fixedfields> section of the XML schema MUST
    -- be specified as NOT NULL, with a DEFAULT.
    --
    -- Fields which are in the <recordtype> sections of the XML schema MUST be
    -- specified as NULL (to allow null values).
    tlTaxRegion int NOT NULL DEFAULT 0
END
GO

--/////////////////////////////////////////////////////////////////////////////
-- Update the Version number for the SchemaVersion table
--/////////////////////////////////////////////////////////////////////////////
UPDATE    [!ActiveSchema!].SchemaVersion
SET       Version = 10
WHERE     SchemaName = 'DETAILS_Final.xml' AND Version = 9

SET NOCOUNT OFF

