--/////////////////////////////////////////////////////////////////////////////
--// Filename		: DocumentUpgraderV1.sql
--// Author			: Chris Sandow
--// Date				: 03 February 2010
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2015. All rights reserved.
--// Description		: SQL Script to upgrade table for the 6.3 release
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	3rd February 2010:	File Creation - Chris Sandow
--//
--/////////////////////////////////////////////////////////////////////////////

SET NOCOUNT ON

-- First we check to see if one of the new columns exists in table
IF EXISTS (
            SELECT  *
            FROM    sysobjects tab 
            WHERE   (tab.id = object_id('[!ActiveSchema!].DOCUMENT')) 
          )
   AND
   NOT EXISTS (
                 SELECT *
                 FROM   sysobjects tab INNER JOIN
                        syscolumns col ON tab.id = col.id
                 WHERE  (tab.id = object_id('[!ActiveSchema!].DOCUMENT')) 
                  AND   (col.name = 'thWeekMonth') 
              ) 
BEGIN
  ALTER TABLE [!ActiveSchema!].DOCUMENT
  DROP COLUMN thSpare5
  ALTER TABLE [!ActiveSchema!].DOCUMENT
  ADD 
	  thSpare5 VARBINARY(58) NOT NULL DEFAULT 0x0,
    thWeekMonth int NOT NULL DEFAULT 0,
    thWorkflowState int NOT NULL DEFAULT 0
END

GO

-- Copy the thSettleDiscDays field into the new thWeekMonth field.
UPDATE    [!ActiveSchema!].DOCUMENT
SET       thWeekMonth = thSettleDiscDays
WHERE     thOurRef LIKE 'TSH%'

-- Now we update the Version number for Document_final.xml in the SchemaVersion table
UPDATE    [!ActiveSchema!].SchemaVersion
SET       Version = 1
WHERE     SchemaName = 'Document_Final.xml' AND Version = 0

SET NOCOUNT OFF

