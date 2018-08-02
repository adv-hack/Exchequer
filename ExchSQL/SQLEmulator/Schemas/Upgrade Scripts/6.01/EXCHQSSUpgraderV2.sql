--/////////////////////////////////////////////////////////////////////////////
--// Filename		: ExchqSSUpgraderV2.sql
--// Author			: Chris Sandow
--// Date				: 12 May 2009
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2015. All rights reserved.
--// Description		: SQL Script to upgrade table for the 6.01 release
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	12th May 2009:	File Creation - Chris Sandow
--//
--/////////////////////////////////////////////////////////////////////////////

SET NOCOUNT ON

-- First we check to see if one of the new columns exists in table EXCHQSS
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
                  AND   (col.name = 'EnableTTDDiscounts') 
              ) 
BEGIN
  ALTER TABLE [!ActiveSchema!].EXCHQSS
  ADD 
    EnableTTDDiscounts bit NOT NULL DEFAULT 0,
    EnableVBDDiscounts bit NOT NULL DEFAULT 0
END

-- Now we update the Version number for EXCHQSS_final.xml in the SchemaVersion table
UPDATE    [!ActiveSchema!].SchemaVersion
SET       Version = 2
WHERE     SchemaName = 'EXCHQSS_Final.xml' AND Version = 1

SET NOCOUNT OFF

