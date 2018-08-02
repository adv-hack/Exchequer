--/////////////////////////////////////////////////////////////////////////////
--// Filename		: ExchqSSUpgraderV7.sql
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

-- First we check to see if the new column exists in the table
IF EXISTS (
            SELECT  *
            FROM    sysobjects tab
            WHERE   (tab.id = object_id('[!ActiveSchema!].EXCHQSS'))
          )
   AND
   NOT EXISTS (
                 SELECT *
                 FROM   sysobjects tab INNER JOIN
                        syscolumns col ON tab.id = col.id
                 WHERE  (tab.id = object_id('[!ActiveSchema!].EXCHQSS'))
                  AND   (col.name = 'ssBankSortCode')
              )
BEGIN
  ALTER TABLE [!ActiveSchema!].EXCHQSS
  ADD
    ssBankSortCode    varbinary(23) NULL,
    ssBankAccountCode varbinary(55) NULL
END

-- Rename old fields
EXEC sp_rename @objname='[!ActiveSchema!].EXCHQSS.UserSort', @newname='OldUserSort', @objtype='COLUMN'
EXEC sp_rename @objname='[!ActiveSchema!].EXCHQSS.UserAcc', @newname='OldUserAcc', @objtype='COLUMN'

-- Now we update the Version number for ExchqSS_final.xml in the SchemaVersion table
UPDATE    [!ActiveSchema!].SchemaVersion
SET       Version = 7
WHERE     SchemaName = 'EXCHQSS_Final.xml' AND Version = 6

SET NOCOUNT OFF
