--/////////////////////////////////////////////////////////////////////////////
--// Filename		: MLocStkUpgraderV8.sql
--// Author			: Chris Sandow
--// Date				: 1 December 2014
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2015. All rights reserved.
--// Description		: SQL Script to upgrade table for the 7.0.7 release
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	1 December 2014:	File Creation - Chris Sandow
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
                 AND   (col.name = 'tcDeliveryCountry')
              )
BEGIN
  ALTER TABLE [!ActiveSchema!].MLOCSTK
  ADD
    tcDeliveryCountry varchar(2) NULL
END

-- Now we update the Version number for the SchemaVersion table
UPDATE    [!ActiveSchema!].SchemaVersion
SET       Version = 8
WHERE     SchemaName = 'MLocStk_Final.xml' AND Version = 7

SET NOCOUNT OFF

