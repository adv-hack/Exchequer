--/////////////////////////////////////////////////////////////////////////////
--// Filename		: JobHeadUpgraderV3.sql
--// Author         : Hitesh Vaghani	
--// Date           : 16 November 2017
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2015. All rights reserved.
--// Description    : GDPR Fields changes for JOBHEAD 
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	: 16th November 2017 : GDPR related JOBHEAD database changes
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
            WHERE  (tab.id = object_id('[!ActiveSchema!].JOBHEAD'))
          )
   AND
   NOT EXISTS (
                SELECT *
                FROM   sysobjects tab INNER JOIN
                       syscolumns col ON tab.id = col.id
                WHERE  (tab.id = object_id('[!ActiveSchema!].JOBHEAD'))
                 AND   (col.name = 'jrAnonymised')
              )
   AND
   NOT EXISTS (
                SELECT *
                FROM   sysobjects tab INNER JOIN
                       syscolumns col ON tab.id = col.id
                WHERE  (tab.id = object_id('[!ActiveSchema!].JOBHEAD'))
                 AND   (col.name = 'jrAnonymisedDate')
              )
   AND
   NOT EXISTS (
                SELECT *
                FROM   sysobjects tab INNER JOIN
                       syscolumns col ON tab.id = col.id
                WHERE  (tab.id = object_id('[!ActiveSchema!].JOBHEAD'))
                 AND   (col.name = 'jrAnonymisedTime')
              )
BEGIN
  ALTER TABLE [!ActiveSchema!].JOBHEAD
  ADD    	
	jrAnonymised bit NOT NULL DEFAULT 0,
	jrAnonymisedDate varchar(8) NOT NULL DEFAULT CHAR(0),
	jrAnonymisedTime varchar(6) NOT NULL DEFAULT CHAR(0)
END

-- Now we update the Version number for the SchemaVersion table
UPDATE    [!ActiveSchema!].SchemaVersion
SET       Version = 3
WHERE     SchemaName = 'JOBHEAD_Final.xml' AND Version = 2

SET NOCOUNT OFF

