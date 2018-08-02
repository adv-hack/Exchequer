--/////////////////////////////////////////////////////////////////////////////
--// Filename		: MLOCSTKUpgraderV1.sql
--// Author			: Chris Sandow
--// Date				: 9 August 2011
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2015. All rights reserved.
--// Description		: SQL Script to upgrade table for the 6.6 release
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	 9 August 2011:	File Creation - Chris Sandow
--//
--/////////////////////////////////////////////////////////////////////////////

SET NOCOUNT ON

-- First we check to see if one of the new columns exists in table
IF EXISTS (
            SELECT  *
            FROM    sysobjects tab 
            WHERE   (tab.id = object_id('[!ActiveSchema!].MLOCSTK')) 
          )
   AND
   NOT EXISTS (
                 SELECT *
                 FROM   sysobjects tab INNER JOIN
                        syscolumns col ON tab.id = col.id
                 WHERE  (tab.id = object_id('[!ActiveSchema!].MLOCSTK')) 
                  AND   (col.name = 'ShowGLCodes') 
              ) 
BEGIN
  ALTER TABLE [!ActiveSchema!].MLOCSTK
  ADD
    ShowGLCodes bit null
END

-- Now we update the Version number for MLOCSTK_final.xml in the SchemaVersion table
UPDATE    [!ActiveSchema!].SchemaVersion
SET       Version = 3
WHERE     SchemaName = 'MLOCSTK_Final.xml' AND Version = 2

SET NOCOUNT OFF

