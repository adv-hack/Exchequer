--/////////////////////////////////////////////////////////////////////////////
--// Filename		: EBUSUpgraderv2.sql
--// Author			: Chris Sandow
--// Date				: 30 July 2009
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2015. All rights reserved.
--// Description		: SQL Script to upgrade table for the 6.01 release
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	30th July 2009:	File Creation - Chris Sandow
--//
--/////////////////////////////////////////////////////////////////////////////

SET NOCOUNT ON

-- First we check to see if one of the new columns exists in table EBUS
IF EXISTS (
            SELECT  *
            FROM    sysobjects tab 
            WHERE   (tab.id = object_id('[common].EBUS')) 
          )
   AND
   NOT EXISTS (
                 SELECT *
                 FROM   sysobjects tab INNER JOIN
                        syscolumns col ON tab.id = col.id
                 WHERE  (tab.id = object_id('[common].EBUS')) 
                  AND   (col.name = 'IdDisc2Amount') 
              ) 
BEGIN
  ALTER TABLE [common].EBUS
  ADD 
    CompUseBasda309 bit null,
    IdDisc2Amount float null,	
    IdDisc2Char varchar(1) null,	
    IdDisc3Amount float null,
    IdDisc3Char varchar(1) null,	
    IdDisc3Type int null	
END

-- Now we update the Version number for EBUS_final.xml in the SchemaVersion table
UPDATE    [common].SchemaVersion
SET       Version = 2
WHERE     SchemaName = 'EBUS_Final.xml' AND Version = 1

SET NOCOUNT OFF

