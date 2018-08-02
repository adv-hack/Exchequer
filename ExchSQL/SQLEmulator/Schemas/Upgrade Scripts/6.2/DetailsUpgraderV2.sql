--/////////////////////////////////////////////////////////////////////////////
--// Filename		: DetailsUpgraderV1.sql
--// Author			: Chris Sandow
--// Date				: 24 August 2009
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2015. All rights reserved.
--// Description		: SQL Script to upgrade table for the 6.2 release
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	24th August 2009:	File Creation - Chris Sandow
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
                  AND   (col.name = 'tlECService') 
              ) 
BEGIN
  ALTER TABLE [!ActiveSchema!].DETAILS
  ADD 
    tlECService bit NOT NULL DEFAULT 0,
    tlServiceStartDate varchar(8) NOT NULL DEFAULT CHAR(0),
    tlServiceEndDate varchar(8) NOT NULL DEFAULT CHAR(0),
    tlECSalesTaxReported float NOT NULL DEFAULT 0.0,
    tlPurchaseServiceTax float NOT NULL DEFAULT 0.0
END

-- Now we update the Version number for Details_final.xml in the SchemaVersion table
UPDATE    [!ActiveSchema!].SchemaVersion
SET       Version = 2
WHERE     SchemaName = 'Details_Final.xml' AND Version = 1

SET NOCOUNT OFF

