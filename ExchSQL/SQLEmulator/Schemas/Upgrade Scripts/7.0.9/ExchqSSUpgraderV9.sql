--/////////////////////////////////////////////////////////////////////////////
--// Filename		: ExchqSSUpgraderV9.sql
--// Author			: Chris Sandow
--// Date				: 5 March 2014
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2015. All rights reserved.
--// Description		: SQL Script to upgrade table for the 7.0.9 release
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	5th March 2014:	File Creation - Chris Sandow
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
                  AND   (col.name = 'CalcCISOnGross')
              )
BEGIN
  ALTER TABLE [!ActiveSchema!].EXCHQSS
  ADD
    CalcCISOnGross bit NULL
END

-- Now we update the Version number for ExchqSS_final.xml in the SchemaVersion table
UPDATE    [!ActiveSchema!].SchemaVersion
SET       Version = 9
WHERE     SchemaName = 'EXCHQSS_Final.xml' AND Version = 8

SET NOCOUNT OFF
