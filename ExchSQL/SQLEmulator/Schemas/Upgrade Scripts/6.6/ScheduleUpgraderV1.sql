--/////////////////////////////////////////////////////////////////////////////
--// Filename		: ScheduleUpgraderV1.sql
--// Author			: Chris Sandow
--// Date				: 16 December 2010
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2015. All rights reserved.
--// Description		: SQL Script to upgrade table for the 6.6 release
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	  16 December 2010:	File Creation - Chris Sandow
--//	1a	12 January 2011:	Added stRestartCount field - Chris Sandow
--//
--/////////////////////////////////////////////////////////////////////////////

SET NOCOUNT ON

-- First we check to see if one of the new columns exists in table
IF EXISTS (
            SELECT  *
            FROM    sysobjects tab 
            WHERE   (tab.id = object_id('[!ActiveSchema!].SCHEDULE')) 
          )
   AND
   NOT EXISTS (
                 SELECT *
                 FROM   sysobjects tab INNER JOIN
                        syscolumns col ON tab.id = col.id
                 WHERE  (tab.id = object_id('[!ActiveSchema!].SCHEDULE')) 
                  AND   (col.name = 'stOneTimeOnly') 
              ) 
BEGIN
  ALTER TABLE [!ActiveSchema!].SCHEDULE
  ADD
    stOneTimeOnly bit not null DEFAULT 0,
    stRestartCount int not null DEFAULT 0
END

-- Now we update the Version number for Schedule_final.xml in the SchemaVersion table
UPDATE    [!ActiveSchema!].SchemaVersion
SET       Version = 1
WHERE     SchemaName = 'SCHEDULE_Final.xml' AND Version = 0

SET NOCOUNT OFF

