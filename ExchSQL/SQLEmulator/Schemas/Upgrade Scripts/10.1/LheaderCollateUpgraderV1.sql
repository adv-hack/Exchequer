--/////////////////////////////////////////////////////////////////////////////
--// Filename		    : LheaderCollateUpgraderV1.sql
--// Author			    : Trapti Gupta	
--// Date				: 13 June 2017
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2016. All rights reserved.
--// Description		: SQL Script to upgrade table for the 9.1 release

SET NOCOUNT ON

IF EXISTS (
            SELECT *
            FROM   sysobjects tab
            WHERE  (tab.id = object_id('[!ActiveSchema!].LHEADER'))
          )
   AND
   EXISTS (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].LHEADER'))
            AND   (col.name = 'DocUser1')
           )
   AND
   EXISTS (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].LHEADER'))
            AND   (col.name = 'DocUser2')
           )

  AND
  EXISTS  (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].LHEADER'))
            AND   (col.name = 'DocUser3')
           )
 
  AND
  EXISTS (
           SELECT *
           FROM   sysobjects tab INNER JOIN
           syscolumns col ON tab.id = col.id
           WHERE  (tab.id = object_id('[!ActiveSchema!].LHEADER'))
           AND   (col.name = 'DocUser4')
          )
 
  AND
  EXISTS (
           SELECT *
           FROM   sysobjects tab INNER JOIN
           syscolumns col ON tab.id = col.id
           WHERE  (tab.id = object_id('[!ActiveSchema!].LHEADER'))
           AND   (col.name = 'lhItemsDesc')
          )
 
  AND
  EXISTS (
           SELECT *
           FROM   sysobjects tab INNER JOIN
           syscolumns col ON tab.id = col.id
           WHERE  (tab.id = object_id('[!ActiveSchema!].LHEADER'))
           AND   (col.name = 'lhOrderNo')
          )
  AND
  EXISTS  (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].LHEADER'))
            AND   (col.name = 'LongYrRef')
           )
  AND
  EXISTS  (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].LHEADER'))
            AND   (col.name = 'OldYourRef')
           )
  AND
  EXISTS  (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].LHEADER'))
            AND   (col.name = 'thDeliveryNoteRef')
           )
  AND
  EXISTS (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].LHEADER'))
            AND   (col.name = 'YourRef')
           )

BEGIN

--Altering All the columns so to be collated SQL_Latin1_General_CP1_CI_AS
--CP1 - Codepage 1
--CI - Case Insensitive
--AS - Accent Sensitive.

ALTER TABLE [!ActiveSchema!].[LHEADER] ALTER COLUMN DocUser1 varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[LHEADER] ALTER COLUMN DocUser2 varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[LHEADER] ALTER COLUMN DocUser3 varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[LHEADER] ALTER COLUMN DocUser4 varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[LHEADER] ALTER COLUMN lhItemsDesc varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[LHEADER] ALTER COLUMN lhOrderNo varchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[LHEADER] ALTER COLUMN LongYrRef varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[LHEADER] ALTER COLUMN OldYourRef varchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[LHEADER] ALTER COLUMN thDeliveryNoteRef varchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[LHEADER] ALTER COLUMN YourRef varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS

END 

-- Now we update the Version number for the SchemaVersion table
UPDATE    [!ActiveSchema!].SchemaVersion
SET       Version = 1
WHERE     SchemaName = 'lheader_final.xml' AND Version = 0


SET NOCOUNT OFF
