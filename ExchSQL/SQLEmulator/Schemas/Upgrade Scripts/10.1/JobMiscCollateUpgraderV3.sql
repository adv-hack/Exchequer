--/////////////////////////////////////////////////////////////////////////////
--// Filename		    : JobMiscCollateUpgraderV3.sql
--// Author			    : Trapti Gupta	
--// Date				: 13 June 2017
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2016. All rights reserved.
--// Description		: SQL Script to upgrade table for the 9.1 release

SET NOCOUNT ON

IF EXISTS (
            SELECT *
            FROM   sysobjects tab
            WHERE  (tab.id = object_id('[!ActiveSchema!].JOBMISC'))
          )
   AND
   EXISTS (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].JOBMISC'))
            AND   (col.name = 'EmpName')
           )
   AND
   EXISTS (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].JOBMISC'))
            AND   (col.name = 'JAName')
           )

  AND
  EXISTS  (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].JOBMISC'))
            AND   (col.name = 'JTypeName')
           )
 
  AND
  EXISTS  (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].JOBMISC'))
            AND   (col.name = 'UserDef1')
           )
 
  AND
  EXISTS  (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].JOBMISC'))
            AND   (col.name = 'UserDef2')
           )
 
  AND
  EXISTS  (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].JOBMISC'))
            AND   (col.name = 'UserDef3')
           )
  AND
  EXISTS  (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].JOBMISC'))
            AND   (col.name = 'UserDef4')
           )

BEGIN

--Altering All the columns so to be collated SQL_Latin1_General_CP1_CI_AS
--CP1 - Codepage 1
--CI - Case Insensitive
--AS - Accent Sensitive.

ALTER TABLE [!ActiveSchema!].[JOBMISC] ALTER COLUMN EmpName varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[JOBMISC] ALTER COLUMN JAName varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[JOBMISC] ALTER COLUMN JTypeName varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[JOBMISC] ALTER COLUMN UserDef1 varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[JOBMISC] ALTER COLUMN UserDef2 varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[JOBMISC] ALTER COLUMN UserDef3 varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[JOBMISC] ALTER COLUMN UserDef4 varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS

END 

-- Now we update the Version number for the SchemaVersion table
UPDATE    [!ActiveSchema!].SchemaVersion
SET       Version = 3
WHERE     SchemaName = 'JobMisc_final.xml' AND Version = 2


SET NOCOUNT OFF
