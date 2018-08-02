--/////////////////////////////////////////////////////////////////////////////
--// Filename		    : LlinesCollateUpgraderV1.sql
--// Author			    : Trapti Gupta	
--// Date				: 13 June 2017
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2016. All rights reserved.
--// Description		: SQL Script to upgrade table for the 9.1 release

SET NOCOUNT ON

IF EXISTS (
            SELECT *
            FROM   sysobjects tab
            WHERE  (tab.id = object_id('[!ActiveSchema!].LLINES'))
          )
   AND
   EXISTS (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].LLINES'))
            AND   (col.name = 'description')
           )
   AND
   EXISTS (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].LLINES'))
            AND   (col.name = 'lineuser1')
           )

  AND
  EXISTS  (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].LLINES'))
            AND   (col.name = 'lineuser2')
           )
 
  AND
  EXISTS  (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].LLINES'))
            AND   (col.name = 'lineuser3')
           )
 
  AND
  EXISTS  (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].LLINES'))
            AND   (col.name = 'lineuser4')
           )
 
  AND
  EXISTS  (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].LLINES'))
            AND   (col.name = 'lldescription1')
           )
  AND
  EXISTS  (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].LLINES'))
            AND   (col.name = 'lldescription2')
           )
  AND
  EXISTS  (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].LLINES'))
            AND   (col.name = 'lldescription3')
           )
  AND
  EXISTS  (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].LLINES'))
            AND   (col.name = 'lldescription4')
           )
  AND
  EXISTS  (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].LLINES'))
            AND   (col.name = 'lldescription5')
           )
  AND
  EXISTS  (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].LLINES'))
            AND   (col.name = 'lldescription6')
           )

BEGIN

--Altering All the columns so to be collated SQL_Latin1_General_CP1_CI_AS
--CP1 - Codepage 1
--CI - Case Insensitive
--AS - Accent Sensitive.

ALTER TABLE [!ActiveSchema!].[LLINES] ALTER COLUMN description varchar(55) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[LLINES] ALTER COLUMN lineuser1 varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[LLINES] ALTER COLUMN lineuser2 varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[LLINES] ALTER COLUMN lineuser3 varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[LLINES] ALTER COLUMN lineuser4 varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[LLINES] ALTER COLUMN lldescription1 varchar(35) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[LLINES] ALTER COLUMN lldescription2 varchar(35) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[LLINES] ALTER COLUMN lldescription3 varchar(35) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[LLINES] ALTER COLUMN lldescription4 varchar(35) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[LLINES] ALTER COLUMN lldescription5 varchar(35) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[LLINES] ALTER COLUMN lldescription6 varchar(35) COLLATE SQL_Latin1_General_CP1_CI_AS

END 

-- Now we update the Version number for the SchemaVersion table
UPDATE    [!ActiveSchema!].SchemaVersion
SET       Version = 1
WHERE     SchemaName = 'llines_final.xml' AND Version = 0


SET NOCOUNT OFF
