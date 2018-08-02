--/////////////////////////////////////////////////////////////////////////////
--// Filename		: ExchqSSUpgraderV10.sql
--// Author			: Chris Sandow
--// Date				: 23 July 2014
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2015. All rights reserved.
--// Description		: SQL Script to upgrade table for the 7.X Order Payments release
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	23rd July 2014:	File Creation - Chris Sandow
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
                  AND   (col.name = 'ssEnableOrderPayments')
              )
BEGIN
  ALTER TABLE [!ActiveSchema!].EXCHQSS
  ADD
    ssEnableOrderPayments bit NULL
END

-- Now we update the Version number for ExchqSS_final.xml in the SchemaVersion table
UPDATE    [!ActiveSchema!].SchemaVersion
SET       Version = 10
WHERE     SchemaName = 'EXCHQSS_Final.xml' AND Version = 9

SET NOCOUNT OFF

