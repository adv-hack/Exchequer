--/////////////////////////////////////////////////////////////////////////////
--// Filename		: ExchqSSUpgraderV3.sql
--// Author			: Chris Sandow
--// Date				: 25 August 2009
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2015. All rights reserved.
--// Description		: SQL Script to upgrade table for the 6.2 release
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	25th August 2009:	File Creation - Chris Sandow
--//
--/////////////////////////////////////////////////////////////////////////////

SET NOCOUNT ON

-- First we check to see if one of the new columns exists in table Details
IF EXISTS (
            SELECT  *
            FROM    sysobjects tab 
            WHERE   (tab.id = object_id('[!ActiveSchema!].EXCHQSS')) 
          )
   AND
   NOT EXISTS (
                 SELECT *
                 FROM   sysobjects tab INNER JOIN
                        syscolumns col ON tab.id = col.id
                 WHERE  (tab.id = object_id('[!ActiveSchema!].EXCHQSS')) 
                  AND   (col.name = 'EnableECServices') 
              ) 
BEGIN
  ALTER TABLE [!ActiveSchema!].EXCHQSS
  ADD 
    EnableECServices bit NOT NULL DEFAULT 0,
    ECSalesThreshold float NOT NULL DEFAULT -1.0
END

-- Now we update the Version number for ExchqSS_final.xml in the SchemaVersion table
UPDATE    [!ActiveSchema!].SchemaVersion
SET       Version = 3
WHERE     SchemaName = 'EXCHQSS_Final.xml' AND Version = 2

SET NOCOUNT OFF

