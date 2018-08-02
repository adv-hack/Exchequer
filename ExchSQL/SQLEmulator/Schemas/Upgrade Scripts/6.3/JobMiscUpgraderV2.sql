--/////////////////////////////////////////////////////////////////////////////
--// Filename		: JobMiscUpgraderV2.sql
--// Author			: Chris Sandow
--// Date				: 03 February 2010
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2015. All rights reserved.
--// Description		: SQL Script to upgrade table for the 6.2 release
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	3rd February 2010:	File Creation - Chris Sandow
--//
--/////////////////////////////////////////////////////////////////////////////

SET NOCOUNT ON

-- First we check to see if one of the new columns exists in table Details
IF EXISTS (
            SELECT  *
            FROM    sysobjects tab 
            WHERE   (tab.id = object_id('[!ActiveSchema!].JOBMISC')) 
          )
   AND
   NOT EXISTS (
                 SELECT *
                 FROM   sysobjects tab INNER JOIN
                        syscolumns col ON tab.id = col.id
                 WHERE  (tab.id = object_id('[!ActiveSchema!].JOBMISC')) 
                  AND   (col.name = 'EmailAddr') 
              ) 
BEGIN
  ALTER TABLE [!ActiveSchema!].JOBMISC
  ADD 
    EmailAddr VARCHAR(100) NULL
END

-- Now we update the Version number for JOBMISC_final.xml in the SchemaVersion table
UPDATE    [!ActiveSchema!].SchemaVersion
SET       Version = 2
WHERE     SchemaName = 'JobMisc_Final.xml' AND Version = 1

SET NOCOUNT OFF

