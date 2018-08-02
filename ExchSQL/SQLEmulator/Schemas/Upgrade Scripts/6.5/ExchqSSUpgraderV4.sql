--/////////////////////////////////////////////////////////////////////////////
--// Filename		: ExchqSSUpgraderV4.sql
--// Author			: Chris Sandow
--// Date				: 12 October 2010
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2015. All rights reserved.
--// Description		: SQL Script to upgrade table for the 6.5 release
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	12th October 2010:	File Creation - Chris Sandow
--//
--/////////////////////////////////////////////////////////////////////////////

SET NOCOUNT ON

-- First we check to see if the new column exists in the table
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
                  AND   (col.name = 'EnableOverrideLocations') 
              ) 
BEGIN
  ALTER TABLE [!ActiveSchema!].EXCHQSS
  ADD 
    EnableOverrideLocations bit NULL
END

-- Now we update the Version number for ExchqSS_final.xml in the SchemaVersion table
UPDATE    [!ActiveSchema!].SchemaVersion
SET       Version = 4
WHERE     SchemaName = 'EXCHQSS_Final.xml' AND Version = 3

SET NOCOUNT OFF

