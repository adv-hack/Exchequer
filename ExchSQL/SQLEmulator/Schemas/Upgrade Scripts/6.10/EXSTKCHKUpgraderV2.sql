--/////////////////////////////////////////////////////////////////////////////
--// Filename		: EXSTKCHKUpgraderV2.sql
--// Author			: C Sandow
--// Date				: 8 March 2012
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2015. All rights reserved.
--// Description		: SQL Script to upgrade EXSTKCHK for the 6.10 release
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	2	8 March 2012:	File Creation - C Sandow
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
                 AND   (col.name = 'QtyBreakFolio')
              )
BEGIN
  ALTER TABLE [!ActiveSchema!].EXSTKCHK
  ADD
    QtyBreakFolio INTEGER NULL
END
GO

-- The QtyBreakFolio field needs to be set to a valid value for the relevant
-- record types.
UPDATE [!ActiveSchema!].EXSTKCHK
SET QtyBreakFolio = 0
WHERE RecMFix = 'C' AND (SubType = 'C' OR SubType = 'S') AND QtyBreakFolio IS NULL
GO

-- The same field needs to be included in the redirected table, CustomerDiscount
IF EXISTS (
            SELECT *
            FROM   sysobjects tab
            WHERE  (tab.id = object_id('[!ActiveSchema!].CustomerDiscount'))
          )
   AND
   NOT EXISTS (
                SELECT *
                FROM   sysobjects tab INNER JOIN
                       syscolumns col ON tab.id = col.id
                WHERE  (tab.id = object_id('[!ActiveSchema!].CustomerDiscount'))
                 AND   (col.name = 'QtyBreakFolio')
              )
BEGIN
  ALTER TABLE [!ActiveSchema!].CustomerDiscount
  ADD
    QtyBreakFolio INTEGER NOT NULL DEFAULT 0
END


-- Now we update the Version number for the SchemaVersion
UPDATE    [!ActiveSchema!].SchemaVersion
SET       Version = 2
WHERE     SchemaName = 'EXSTKCHK_Final.xml' AND Version = 1

SET NOCOUNT OFF

