--/////////////////////////////////////////////////////////////////////////////
--// Filename		: ExchqSSUpgraderV8.sql
--// Author			: Chris Sandow
--// Date				: 22 November 2013
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2015. All rights reserved.
--// Description		: SQL Script to upgrade table for the 7.0.8 release
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	22nd November 2013:	File Creation - Chris Sandow
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
                  AND   (col.name = 'ssConsumersEnabled')
              )
BEGIN
  ALTER TABLE [!ActiveSchema!].EXCHQSS
  ADD
    ssConsumersEnabled   bit NULL
END

-- Now we update the Version number for ExchqSS_final.xml in the SchemaVersion table
UPDATE    [!ActiveSchema!].SchemaVersion
SET       Version = 8
WHERE     SchemaName = 'EXCHQSS_Final.xml' AND Version = 7

SET NOCOUNT OFF
