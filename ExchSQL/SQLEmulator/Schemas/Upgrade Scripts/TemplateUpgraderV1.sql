-- -----------------------------------------------------------------------------
-- Usage notes (REMOVE!)
-- -----------------------------------------------------------------------------
-- This is a template for scripts to upgrade the tables. To use it, you should
-- replace tag values with the appropriate real values.
-- <AUTHOR> - your name
-- <DATE>   - today's date
-- <TABLE>  - the table which is being upgraded
-- <VER>    - the version number which is being upgraded to. This is the version
--            number of the XML schema file, and is simply incremented when the
--            table is changed. Make sure that the version number in the XML
--            schema file is updated to match.
--
-- An entry for this script must be included in the <dbUpgrade> section of the
-- ExchSQLDbCreateUpgradeConfig.xml file.
-- -----------------------------------------------------------------------------
-- End of usage Notes
-- -----------------------------------------------------------------------------

--/////////////////////////////////////////////////////////////////////////////
--// Filename		: <TABLE>UpgraderV<VER>.sql
--// Author			: <AUTHOR>
--// Date				: <DATE>
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2015. All rights reserved.
--// Description		: SQL Script to upgrade table for the 6.2 release
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	<DATE>:	File Creation - <AUTHOR>
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
            WHERE  (tab.id = object_id('[!ActiveSchema!].<TABLE>'))
          )
   AND
   NOT EXISTS (
                SELECT *
                FROM   sysobjects tab INNER JOIN
                       syscolumns col ON tab.id = col.id
                WHERE  (tab.id = object_id('[!ActiveSchema!].<TABLE>'))
                 AND   (col.name = '<FIELD>')
              )
BEGIN
  ALTER TABLE [!ActiveSchema!].<TABLE>
  ADD
    -- Fields which are in the <fixedfields> section of the XML schema MUST
    -- be specified as NOT NULL, with a DEFAULT.
    --
    -- Fields which are in the <recordtype> sections of the XML schema MUST be
    -- specified as NULL (to allow null values).
    <FIELD> varchar(8) NOT NULL DEFAULT CHAR(0)
END

-- Now we update the Version number for the SchemaVersion table
UPDATE    [!ActiveSchema!].SchemaVersion
SET       Version = <VER>
WHERE     SchemaName = '<TABLE>_Final.xml' AND Version = <VER> - 1

SET NOCOUNT OFF

