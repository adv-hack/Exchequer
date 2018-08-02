--/////////////////////////////////////////////////////////////////////////////
--// Filename		: ExchqSSUpgraderV6.sql
--// Author			: Chris Sandow
--// Date				: 13 May 2013
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2015. All rights reserved.
--// Description		: SQL Script to upgrade table for the 7.0.4 release
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	13th May 2013:	File Creation - Chris Sandow
--//  2 1st July 2013:  Corrected type of VAT100SenderType - Chris Sandow
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
                  AND   (col.name = 'VAT100UserID')
              )
BEGIN
  ALTER TABLE [!ActiveSchema!].EXCHQSS
  ADD
    VAT100UserID       varbinary(33) NULL,
    VAT100UserPassword varbinary(55) NULL,
    VAT100SenderType   varchar(30) NULL
END

-- Now we update the Version number for ExchqSS_final.xml in the SchemaVersion table
UPDATE    [!ActiveSchema!].SchemaVersion
SET       Version = 6
WHERE     SchemaName = 'EXCHQSS_Final.xml' AND Version = 5

SET NOCOUNT OFF
