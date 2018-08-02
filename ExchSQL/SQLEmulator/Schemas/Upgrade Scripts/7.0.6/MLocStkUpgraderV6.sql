--/////////////////////////////////////////////////////////////////////////////
--// Filename		: MLocStkUpgraderV5.sql
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
            WHERE  (tab.id = object_id('[!ActiveSchema!].MLocStk'))
          )
   AND
   NOT EXISTS (
                SELECT *
                FROM   sysobjects tab INNER JOIN
                       syscolumns col ON tab.id = col.id
                WHERE  (tab.id = object_id('[!ActiveSchema!].MLocStk'))
                 AND   (col.name = 'BrBankSortCode')
              )
BEGIN
  ALTER TABLE [!ActiveSchema!].MLOCSTK
  ADD
    BrBankSortCode     varbinary(23) NULL,
    BrBankAccountCode  varbinary(55) NULL,
    BrUserIdEx         varbinary(55) NULL,
    BrUserId2Ex        varbinary(55) NULL
END
GO

-- Rename old fields
EXEC sp_rename @objname='[!ActiveSchema!].MLOCSTK.brSortCode', @newname='brOldSortCode', @objtype='COLUMN'
EXEC sp_rename @objname='[!ActiveSchema!].MLOCSTK.brAccountCode', @newname='brOldAccountCode', @objtype='COLUMN'
GO

-- Now we update the Version number for the SchemaVersion table
UPDATE    [!ActiveSchema!].SchemaVersion
SET       Version = 6
WHERE     SchemaName = 'MLocStk_Final.xml' AND Version = 5

SET NOCOUNT OFF

