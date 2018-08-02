--/////////////////////////////////////////////////////////////////////////////
--// Filename		: DOCUMENTUpgraderV5.sql
--// Author			: Chris Sandow
--// Date				: 2011-09-30
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2015. All rights reserved.
--// Description		: SQL Script to upgrade table for the 6.10 release. This
--//                 adds the new User-Defined Fields into EBUSDOC. These were
--//                 omitted in v6.9.
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	2012-04-26:	File Creation - Chris Sandow
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
            WHERE  (tab.id = object_id('[!ActiveSchema!].EBUSDOC'))
          )
   AND
   NOT EXISTS (
                SELECT *
                FROM   sysobjects tab INNER JOIN
                       syscolumns col ON tab.id = col.id
                WHERE  (tab.id = object_id('[!ActiveSchema!].EBUSDOC'))
                 AND   (col.name = 'thUserField5')
              )
BEGIN
  ALTER TABLE [!ActiveSchema!].EBUSDOC
  ADD
    -- Fields which are in the <fixedfields> section of the XML schema MUST
    -- be specified as NOT NULL, with a DEFAULT.
    --
    -- Fields which are in the <recordtype> sections of the XML schema MUST be
    -- specified as NULL (to allow null values).
    thUserField5  varchar(30) NOT NULL DEFAULT CHAR(0),
    thUserField6  varchar(30) NOT NULL DEFAULT CHAR(0),
    thUserField7  varchar(30) NOT NULL DEFAULT CHAR(0),
    thUserField8  varchar(30) NOT NULL DEFAULT CHAR(0),
    thUserField9  varchar(30) NOT NULL DEFAULT CHAR(0),
    thUserField10 varchar(30) NOT NULL DEFAULT CHAR(0)
END
GO

-- Now we update the Version number for the SchemaVersion table.
-- Because EBUSDOC uses the DOCUMENT schema file, the version number of the
-- schema file needs to be updated as well, so that the Emulator's upgrade
-- routines will run this script.
UPDATE    [!ActiveSchema!].SchemaVersion
SET       Version = 5
WHERE     SchemaName = 'DOCUMENT_Final.xml' AND Version = 4

SET NOCOUNT OFF

