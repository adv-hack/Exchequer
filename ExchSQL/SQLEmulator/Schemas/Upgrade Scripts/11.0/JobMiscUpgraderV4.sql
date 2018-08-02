--/////////////////////////////////////////////////////////////////////////////
--// Filename       : JobMiscUpgraderV4.sql
--// Author         : Suman Sarkar
--// Date           : 15 November 2017
--// Copyright Notice : (c) Advanced Business Software & Solutions Ltd 2017. All rights reserved.
--// Description    : GDPR Fields changes for Employee (JobMisc table)
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	
--//	4 : 15th November 2017 : GDPR related Employee database changes
--/////////////////////////////////////////////////////////////////////////////

SET NOCOUNT ON

-- First we check to see if the new column already exists in the table. This is
-- because all the upgrade scripts are run every time the system is upgraded,
-- so we must be careful not to try to make amendments which have already been
-- done.
IF EXISTS (
            SELECT *
            FROM   sysobjects tab
            WHERE  (tab.id = object_id('[!ActiveSchema!].JOBMISC'))
          )
   AND
   NOT EXISTS (
                SELECT *
                FROM   sysobjects tab INNER JOIN
                       syscolumns col ON tab.id = col.id
                WHERE  (tab.id = object_id('[!ActiveSchema!].JOBMISC'))
                 AND   (col.name = 'emStatus')
              )
   AND
   NOT EXISTS (
                SELECT *
                FROM   sysobjects tab INNER JOIN
                       syscolumns col ON tab.id = col.id
                WHERE  (tab.id = object_id('[!ActiveSchema!].JOBMISC'))
                 AND   (col.name = 'emAnonymisationStatus')
              )
   AND
   NOT EXISTS (
                SELECT *
                FROM   sysobjects tab INNER JOIN
                       syscolumns col ON tab.id = col.id
                WHERE  (tab.id = object_id('[!ActiveSchema!].JOBMISC'))
                 AND   (col.name = 'emAnonymisedDate')
              )
   AND
   NOT EXISTS (
                SELECT *
                FROM   sysobjects tab INNER JOIN
                       syscolumns col ON tab.id = col.id
                WHERE  (tab.id = object_id('[!ActiveSchema!].JOBMISC'))
                 AND   (col.name = 'emAnonymisedTime')
              )
BEGIN
  ALTER TABLE [!ActiveSchema!].JOBMISC
  ADD
  emStatus int NULL,
  emAnonymisationStatus int NULL,
  emAnonymisedDate varchar(8) NULL,
  emAnonymisedTime varchar(6) NULL
END
GO

-- Now we update the Version number for the SchemaVersion table
UPDATE    [!ActiveSchema!].SchemaVersion
SET       Version = 4
WHERE     SchemaName = 'JOBMISC_FINAL.XML' AND Version = 3

SET NOCOUNT OFF
