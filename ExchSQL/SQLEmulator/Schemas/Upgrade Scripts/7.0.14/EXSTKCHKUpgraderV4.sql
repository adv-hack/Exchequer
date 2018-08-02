--/////////////////////////////////////////////////////////////////////////////
--// Filename		: EXSTKCHKUpgraderV4.sql
--// Author		: C Sandow
--// Date		: 6 May 2015
--// Copyright Notice	: (c) 2015 Advanced Business Software & Solutions Ltd. All rights reserved.
--// Description	: SQL Script to upgrade EXSTKCHK for the 7.0.14 release
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	6 May 2015:	File Creation - C Sandow
--//
--/////////////////////////////////////////////////////////////////////////////

SET NOCOUNT ON

-- First we check to see if the new column already exists in the EXSTKCHK. This is
-- because all the upgrade scripts are run every time the system is upgraded,
-- so we must be careful not to try to make amendments which have already been
-- done.
IF EXISTS (
            SELECT *
            FROM   sysobjects tab
            WHERE  (tab.id = object_id('[!ActiveSchema!].EXSTKCHK'))
          )
   AND
   NOT EXISTS (
                SELECT *
                FROM   sysobjects tab INNER JOIN
                       syscolumns col ON tab.id = col.id
                WHERE  (tab.id = object_id('[!ActiveSchema!].EXSTKCHK'))
                 AND   (col.name = 'ariPPDStatus')
              )
BEGIN
  ALTER TABLE [!ActiveSchema!].EXSTKCHK
  ADD
    ariPPDStatus int NULL,
    TraderPPDPercentage float NULL,
    TraderPPDDays int NULL
END
GO

-- Now we update the Version number for the SchemaVersion
UPDATE    [!ActiveSchema!].SchemaVersion
SET       Version = 4
WHERE     SchemaName = 'EXSTKCHK_Final.xml' AND Version = 3

SET NOCOUNT OFF
