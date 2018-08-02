--/////////////////////////////////////////////////////////////////////////////
--// Filename		: CustSuppUpgraderV7.sql
--// Author		: Chris Sandow
--// Date		: 21 March 2016
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2016. All rights reserved.
--// Description	: SQL Script to upgrade table for the 2016 R2 release
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	21st March 2015:	File Creation - Chris Sandow
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
            WHERE  (tab.id = object_id('[!ActiveSchema!].CustSupp'))
          )
   AND
   NOT EXISTS (
                SELECT *
                FROM   sysobjects tab INNER JOIN
                       syscolumns col ON tab.id = col.id
                WHERE  (tab.id = object_id('[!ActiveSchema!].CustSupp'))
                 AND   (col.name = 'acTaxRegion')
              )
BEGIN
  ALTER TABLE [!ActiveSchema!].CustSupp
  ADD
    -- Fields which are in the <fixedfields> section of the XML schema MUST
    -- be specified as NOT NULL, with a DEFAULT.
    acTaxRegion  int NOT NULL DEFAULT 0
END
GO

-- Now we update the Version number for the SchemaVersion table
UPDATE    [!ActiveSchema!].SchemaVersion
SET       Version = 7
WHERE     SchemaName = 'CustSupp_Final.xml' AND Version = 6

SET NOCOUNT OFF
