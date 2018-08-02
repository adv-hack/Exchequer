--/////////////////////////////////////////////////////////////////////////////
--// Filename		: DocumentUpgraderV2.sql
--// Author			: Chris Sandow
--// Date				: 07 July 2010
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2015. All rights reserved.
--// Description		: SQL Script to upgrade table for the 6.4 release
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//  1   7th July 2010:	File Creation - Chris Sandow
--//  1a 14th January 2011: Amended to call update of field after begin/end - Chris Sandow
--//  1b 28th February 2011: Amended to call check for presence of EBUS before update - Chris Sandow
--//  1c 17th March 2011: Amended to remove updating of timesheet records, as this is not required for EBUS - Chris Sandow
--//
--/////////////////////////////////////////////////////////////////////////////
--// This actually updates EBUSDOC, which shares the same schema as DOCUMENT,
--// but has not previously been updated with new fields which have been added
--// to DOCUMENT.

SET NOCOUNT ON

-- First we check to see if one of the new columns exists in table
DECLARE @hasEBUS INT
IF EXISTS (
            SELECT  *
            FROM    sysobjects tab 
            WHERE   (tab.id = object_id('[!ActiveSchema!].EBUSDOC')) 
          )
	SELECT @hasEBUS = 1
ELSE
	SELECT @hasEBUS = 0

DECLARE @ebusModified INT
SELECT @ebusModified = 0
IF (@hasEBUS = 1) AND NOT EXISTS (
                 SELECT *
                 FROM   sysobjects tab INNER JOIN
                        syscolumns col ON tab.id = col.id
                 WHERE  (tab.id = object_id('[!ActiveSchema!].EBUSDOC')) 
                  AND   (col.name = 'thWeekMonth') 
              ) 
BEGIN
  ALTER TABLE [!ActiveSchema!].EBUSDOC
  DROP COLUMN thSpare5
  ALTER TABLE [!ActiveSchema!].EBUSDOC
  ADD 
	  thSpare5 VARBINARY(58) NOT NULL DEFAULT 0x0,
    thWeekMonth int NOT NULL DEFAULT 0,
    thWorkflowState int NOT NULL DEFAULT 0
  SELECT @ebusModified = 1
END

/*
IF (@hasEBUS = 1) AND (@ebusModified = 1)
BEGIN
	-- Copy the thSettleDiscDays field into the new thWeekMonth field.
	UPDATE    [!ActiveSchema!].EBUSDOC
	SET       thWeekMonth = thSettleDiscDays
	WHERE     thOurRef LIKE 'TSH%'
END
*/

-- Now we update the Version number for Document_final.xml in the SchemaVersion table
UPDATE    [!ActiveSchema!].SchemaVersion
SET       Version = 2
WHERE     SchemaName = 'Document_Final.xml' AND Version = 1


SET NOCOUNT OFF

