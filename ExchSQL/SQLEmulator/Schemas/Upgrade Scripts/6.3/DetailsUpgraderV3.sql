--/////////////////////////////////////////////////////////////////////////////
--// Filename		: DetailsUpgraderV3.sql
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
            WHERE   (tab.id = object_id('[!ActiveSchema!].DETAILS')) 
          )
   AND
   NOT EXISTS (
                 SELECT *
                 FROM   sysobjects tab INNER JOIN
                        syscolumns col ON tab.id = col.id
                 WHERE  (tab.id = object_id('[!ActiveSchema!].DETAILS')) 
                  AND   (col.name = 'tlReference') 
              ) 
BEGIN
  ALTER TABLE [!ActiveSchema!].DETAILS
  ADD 
    tlReference varchar(20) NOT NULL DEFAULT CHAR(0),
    tlReceiptNo varchar(20) NOT NULL DEFAULT CHAR(0),
    tlFromPostCode varchar(15) NOT NULL DEFAULT CHAR(0),
    tlToPostCode varchar(15) NOT NULL DEFAULT CHAR(0)
END

-- Now we update the Version number for Details_final.xml in the SchemaVersion table
UPDATE    [!ActiveSchema!].SchemaVersion
SET       Version = 3
WHERE     SchemaName = 'Details_Final.xml' AND Version = 2

SET NOCOUNT OFF

