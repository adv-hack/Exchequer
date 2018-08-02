--/////////////////////////////////////////////////////////////////////////////
--// Filename		: MLocStkUpgraderV14.sql
--// Author			: Hitesh Vaghani
--// Date				: 16 Oct 2017
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2016. All rights reserved.
--// Description		: SQL Script to upgrade table for the 10.1 release
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	ABSEXCH-19284: User Profile Highlight PII fields flag
--//
--/////////////////////////////////////////////////////////////////////////////

SET NOCOUNT ON

-- First we check to see if the new columnss already exists in the table. This is
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
                 AND   (col.name = 'HighlightPIIFields')
              )
   AND
   NOT EXISTS (
                SELECT *
                FROM   sysobjects tab INNER JOIN
                       syscolumns col ON tab.id = col.id
                WHERE  (tab.id = object_id('[!ActiveSchema!].MLocStk'))
                 AND   (col.name = 'HighlightPIIColour')
              )   
BEGIN
  ALTER TABLE [!ActiveSchema!].MLOCSTK
  ADD     
	HighlightPIIColour int NULL,	 
	HighlightPIIFields bit NULL;
END

GO
-- Set default colour value. RGB(237, 139, 0)
UPDATE    [!ActiveSchema!].MLOCSTK
SET       HighlightPIIColour = 35281
WHERE     RecPfix = 'P' and SubType = 'D'  

-- Now we update the Version number for the SchemaVersion table
UPDATE    [!ActiveSchema!].SchemaVersion
SET       Version = 14
WHERE     SchemaName = 'MLocStk_Final.xml' AND Version = 13

SET NOCOUNT OFF