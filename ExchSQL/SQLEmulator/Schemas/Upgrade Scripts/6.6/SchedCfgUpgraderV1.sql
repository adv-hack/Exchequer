--/////////////////////////////////////////////////////////////////////////////
--// Filename		: SchedCfgUpgraderV1.sql
--// Author			: Chris Sandow
--// Date				: 16 December 2010
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2015. All rights reserved.
--// Description		: SQL Script to upgrade table for the 6.6 release
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	16 December 2010:	File Creation - Chris Sandow
--//
--/////////////////////////////////////////////////////////////////////////////

SET NOCOUNT ON

-- First we check to see if one of the new columns exists in table
IF EXISTS (
            SELECT  *
            FROM    sysobjects tab 
            WHERE   (tab.id = object_id('[common].SCHEDCFG')) 
          )
   AND
   NOT EXISTS (
                 SELECT *
                 FROM   sysobjects tab INNER JOIN
                        syscolumns col ON tab.id = col.id
                 WHERE  (tab.id = object_id('[common].SCHEDCFG')) 
                  AND   (col.name = 'scTimeStamp') 
              ) 
BEGIN
  ALTER TABLE [common].SCHEDCFG
  ADD
    scTimeStamp datetime null
END

-- Now we update the Version number for Schedule_final.xml in the SchemaVersion table
UPDATE    [common].SchemaVersion
SET       Version = 1
WHERE     SchemaName = 'SCHEDCFG_Final.xml' AND Version = 0

SET NOCOUNT OFF

