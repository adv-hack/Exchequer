--/////////////////////////////////////////////////////////////////////////////
--// Filename		: DetailsUpgraderV1.sql
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

-- First we check to see if one of the new columns exists in table Details
IF EXISTS (
            SELECT  *
            FROM    sysobjects tab 
            WHERE   (tab.id = object_id('[!ActiveSchema!].DETAILS')) 
          )
   AND
   NOT EXISTS (
                 SELECT *
                 FROM   sysobjects tab INNER JOIN
                        syscolumns col ON tab.id = col.id
                 WHERE  (tab.id = object_id('[!ActiveSchema!].DETAILS')) 
                  AND   (col.name = 'tlDiscount2') 
              ) 
BEGIN
  ALTER TABLE [!ActiveSchema!].DETAILS
  ADD 
    tlDiscount2     float NOT NULL DEFAULT 0.0,
    tlDiscount2Chr  char NOT NULL DEFAULT CHAR(0),
    tlDiscount3     float NOT NULL DEFAULT 0.0,
    tlDiscount3Chr  char NOT NULL DEFAULT CHAR(0),
    tlDiscount3Type int NOT NULL DEFAULT 0
END

-- Now we update the Version number for Details_final.xml in the SchemaVersion table
UPDATE    [!ActiveSchema!].SchemaVersion
SET       Version = 1
WHERE     SchemaName = 'Details_Final.xml' AND Version = 0

SET NOCOUNT OFF

