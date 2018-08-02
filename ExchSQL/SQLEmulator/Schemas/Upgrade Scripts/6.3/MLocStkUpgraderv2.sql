--/////////////////////////////////////////////////////////////////////////////
--// Filename		: MLocStkUpgraderv2.sql
--// Author			: Chris Sandow
--// Date				: 24 November 2009
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2015. All rights reserved.
--// Description		: SQL Script to upgrade table for the 6.3 release
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	24th November 2009:	File Creation - Chris Sandow
--//
--/////////////////////////////////////////////////////////////////////////////

SET NOCOUNT ON

-- First we check to see if one of the new columns exists in the table.
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
                 AND    (col.name = 'BrSortCodeEx') 
              ) 
BEGIN
  ALTER TABLE [!ActiveSchema!].MLOCSTK
  ADD 
    BrSortCodeEx varchar(13) null,	
    BrAccountCodeEx varchar(26) null	
END

-- Now we update the Version number for EBUS_final.xml in the SchemaVersion table
UPDATE    [!ActiveSchema!].SchemaVersion
SET       Version = 2
WHERE     SchemaName = 'MLocStk_Final.xml' AND Version = 1

SET NOCOUNT OFF

