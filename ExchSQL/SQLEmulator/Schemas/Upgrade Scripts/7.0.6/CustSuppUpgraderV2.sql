--/////////////////////////////////////////////////////////////////////////////
--// Filename		: CustSuppUpgraderV2.sql
--// Author			: Chris Sandow
--// Date				: 9 September 2013
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2015. All rights reserved.
--// Description		: SQL Script to upgrade table for the 7.0.6 release
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	9th September 2013:	File Creation - Chris Sandow
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
                 AND   (col.name = 'acBankSortCode')
              )
BEGIN
  ALTER TABLE [!ActiveSchema!].CustSupp
  ADD
    -- Fields which are in the <fixedfields> section of the XML schema MUST
    -- be specified as NOT NULL, with a DEFAULT.
    acBankSortCode      varbinary(23) NOT NULL DEFAULT 0,
    acBankAccountCode   varbinary(55) NOT NULL DEFAULT 0,
    acMandateID         varbinary(55) NOT NULL DEFAULT 0,
    acMandateDate       varchar(8)    NOT NULL DEFAULT CHAR(0)
END
GO

-- Now rename the old fields
EXEC sp_rename @objname='[!ActiveSchema!].CUSTSUPP.acBankSort', @newname='acOldBankSort', @objtype='COLUMN'
EXEC sp_rename @objname='[!ActiveSchema!].CUSTSUPP.acBankAcc', @newname='acOldBankAcc', @objtype='COLUMN'
GO

-- Now we update the Version number for the SchemaVersion table
UPDATE    [!ActiveSchema!].SchemaVersion
SET       Version = 2
WHERE     SchemaName = 'CustSupp_Final.xml' AND Version = 1

SET NOCOUNT OFF

