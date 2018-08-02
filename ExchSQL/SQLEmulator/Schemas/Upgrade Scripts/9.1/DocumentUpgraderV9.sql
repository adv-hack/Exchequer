--/////////////////////////////////////////////////////////////////////////////
--// Filename		: DOCUMENTUpgraderV8.sql
--// Author			: Chris Sandow
--// Date				: 21 March 2016
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2016. All rights reserved.
--// Description		: SQL Script to upgrade table for the 2016 R2 release
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	21st March 2016:	Added new fields - Chris Sandow
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
            WHERE  (tab.id = object_id('[!ActiveSchema!].DOCUMENT'))
          )
   AND
   NOT EXISTS (
                SELECT *
                FROM   sysobjects tab INNER JOIN
                       syscolumns col ON tab.id = col.id
                WHERE  (tab.id = object_id('[!ActiveSchema!].DOCUMENT'))
                 AND   (col.name = 'thUserField11')
              )
BEGIN
  ALTER TABLE [!ActiveSchema!].DOCUMENT
  ADD
    -- Fields which are in the <fixedfields> section of the XML schema MUST
    -- be specified as NOT NULL, with a DEFAULT.
    thUserField11 varchar(30) NOT NULL DEFAULT CHAR(0),
    thUserField12 varchar(30) NOT NULL DEFAULT CHAR(0),
    thTaxRegion int NOT NULL DEFAULT 0
END
GO

-- Add the new index
DECLARE @table_id INT
SET @table_id = object_id('[!ActiveSchema!].[DOCUMENT]')

IF NOT EXISTS (
	SELECT name FROM sys.indexes
	WHERE object_id = @table_id
	  AND name = 'DOCUMENT_Index14'
)
BEGIN
	CREATE UNIQUE NONCLUSTERED INDEX DOCUMENT_Index14 ON [!ActiveSchema!].[DOCUMENT] ([thTaxRegion], [thVATPostDate], [thOurRef], [PositionID])
END
GO

-- Also add the field to EBUSDOC
IF EXISTS (
            SELECT *
            FROM   sysobjects tab
            WHERE  (tab.id = object_id('[!ActiveSchema!].EBUSDOC'))
          )
   AND
   NOT EXISTS (
                SELECT *
                FROM   sysobjects tab INNER JOIN
                       syscolumns col ON tab.id = col.id
                WHERE  (tab.id = object_id('[!ActiveSchema!].EBUSDOC'))
                 AND   (col.name = 'thUserField11')
              )
BEGIN
  ALTER TABLE [!ActiveSchema!].EBUSDOC
  ADD
    -- Fields which are in the <fixedfields> section of the XML schema MUST
    -- be specified as NOT NULL, with a DEFAULT.
    thUserField11 varchar(30) NOT NULL DEFAULT CHAR(0),
    thUserField12 varchar(30) NOT NULL DEFAULT CHAR(0),
    thTaxRegion int NOT NULL DEFAULT 0
END
GO

-- Add the new index
DECLARE @table_id INT
SET @table_id = object_id('[!ActiveSchema!].[EBUSDOC]')

IF EXISTS (
            SELECT *
            FROM   sysobjects tab
            WHERE  (tab.id = object_id('[!ActiveSchema!].EBUSDOC'))
          )
AND NOT EXISTS (
	SELECT name FROM sys.indexes
	WHERE object_id = @table_id
	  AND name = 'EBUSDOC_Index14'
)
BEGIN
	CREATE UNIQUE NONCLUSTERED INDEX EBUSDOC_Index14 ON [!ActiveSchema!].[EBUSDOC] ([thTaxRegion], [thVATPostDate], [thOurRef], [PositionID])
END
GO

-- Now we update the Version number for the SchemaVersion table
UPDATE    [!ActiveSchema!].SchemaVersion
SET       Version = 9
WHERE     SchemaName = 'DOCUMENT_Final.xml' AND Version = 8

SET NOCOUNT OFF

