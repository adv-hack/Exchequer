--/////////////////////////////////////////////////////////////////////////////
--// Filename		    : jobheadCollateUpgraderV2.sql
--// Author			    : Trapti Gupta	
--// Date				: 13 June 2017
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2016. All rights reserved.
--// Description		: SQL Script to upgrade table for the 9.1 release
SET NOCOUNT ON

IF EXISTS (
            SELECT *
            FROM   sysobjects tab
            WHERE  (tab.id = object_id('[!ActiveSchema!].JOBHEAD'))
          )
   AND
     EXISTS (
                SELECT *
                FROM   sysobjects tab INNER JOIN
                       syscolumns col ON tab.id = col.id
                WHERE  (tab.id = object_id('[!ActiveSchema!].JOBHEAD'))
                 AND   (col.name = 'Contact')
              )

  AND
     EXISTS (
                SELECT *
                FROM   sysobjects tab INNER JOIN
                       syscolumns col ON tab.id = col.id
                WHERE  (tab.id = object_id('[!ActiveSchema!].JOBHEAD'))
                 AND   (col.name = 'JobMan')
              )
      
  AND
     EXISTS (
                SELECT *
                FROM   sysobjects tab INNER JOIN
                       syscolumns col ON tab.id = col.id
                WHERE  (tab.id = object_id('[!ActiveSchema!].JOBHEAD'))
                 AND   (col.name = 'UserDef1')
              )
      
  AND
     EXISTS (
                SELECT *
                FROM   sysobjects tab INNER JOIN
                       syscolumns col ON tab.id = col.id
                WHERE  (tab.id = object_id('[!ActiveSchema!].JOBHEAD'))
                 AND   (col.name = 'UserDef2')
              )
      
  AND
     EXISTS (
                SELECT *
                FROM   sysobjects tab INNER JOIN
                       syscolumns col ON tab.id = col.id
                WHERE  (tab.id = object_id('[!ActiveSchema!].JOBHEAD'))
                 AND   (col.name = 'UserDef3')
              )
      
  AND
     EXISTS (
                SELECT *
                FROM   sysobjects tab INNER JOIN
                       syscolumns col ON tab.id = col.id
                WHERE  (tab.id = object_id('[!ActiveSchema!].JOBHEAD'))
                 AND   (col.name = 'UserDef4')
              )
      
  AND
     EXISTS (
                SELECT *
                FROM   sysobjects tab INNER JOIN
                       syscolumns col ON tab.id = col.id
                WHERE  (tab.id = object_id('[!ActiveSchema!].JOBHEAD'))
                 AND   (col.name = 'UserDef5')
              )
      
  AND
     EXISTS (
                SELECT *
                FROM   sysobjects tab INNER JOIN
                       syscolumns col ON tab.id = col.id
                WHERE  (tab.id = object_id('[!ActiveSchema!].JOBHEAD'))
                 AND   (col.name = 'UserDef6')
              )
      
  AND
     EXISTS (
                SELECT *
                FROM   sysobjects tab INNER JOIN
                       syscolumns col ON tab.id = col.id
                WHERE  (tab.id = object_id('[!ActiveSchema!].JOBHEAD'))
                 AND   (col.name = 'UserDef7')
              )
       
  AND
     EXISTS (
                SELECT *
                FROM   sysobjects tab INNER JOIN
                       syscolumns col ON tab.id = col.id
                WHERE  (tab.id = object_id('[!ActiveSchema!].JOBHEAD'))
                 AND   (col.name = 'UserDef8')
              )
   
      
  AND
     EXISTS (
                SELECT *
                FROM   sysobjects tab INNER JOIN
                       syscolumns col ON tab.id = col.id
                WHERE  (tab.id = object_id('[!ActiveSchema!].JOBHEAD'))
                 AND   (col.name = 'UserDef9')
              )
   
      
  AND
     EXISTS (
                SELECT *
                FROM   sysobjects tab INNER JOIN
                       syscolumns col ON tab.id = col.id
                WHERE  (tab.id = object_id('[!ActiveSchema!].JOBHEAD'))
                 AND   (col.name = 'UserDef10')
              )
 
BEGIN

--Altering All the columns so to be collated SQL_Latin1_General_CP1_CI_AS
--CP1 - Codepage 1
--CI - Case Insensitive
--AS - Accent Sensitive.

ALTER TABLE [!ActiveSchema!].[JOBHEAD] ALTER COLUMN Contact varchar(25) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[JOBHEAD] ALTER COLUMN JobMan varchar(25) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[JOBHEAD] ALTER COLUMN UserDef1 varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[JOBHEAD] ALTER COLUMN UserDef2 varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[JOBHEAD] ALTER COLUMN UserDef3 varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[JOBHEAD] ALTER COLUMN UserDef4 varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[JOBHEAD] ALTER COLUMN UserDef5 varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[JOBHEAD] ALTER COLUMN UserDef6 varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[JOBHEAD] ALTER COLUMN UserDef7 varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[JOBHEAD] ALTER COLUMN UserDef8 varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[JOBHEAD] ALTER COLUMN UserDef9 varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[JOBHEAD] ALTER COLUMN UserDef10 varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS

END 

-- Now we update the Version number for the SchemaVersion table
UPDATE    [!ActiveSchema!].SchemaVersion
SET       Version = 2
WHERE     SchemaName = 'jobhead_final.xml' AND Version = 1


SET NOCOUNT OFF
