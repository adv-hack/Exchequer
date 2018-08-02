--/////////////////////////////////////////////////////////////////////////////
--// Filename		    : StockCollateUpgraderV3.sql
--// Author			    : Trapti Gupta	
--// Date				: 13 June 2017
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2016. All rights reserved.
--// Description		: SQL Script to upgrade table for the 9.1 release

SET NOCOUNT ON

IF EXISTS (
            SELECT *
            FROM   sysobjects tab
            WHERE  (tab.id = object_id('[!ActiveSchema!].STOCK'))
          )
   AND
   EXISTS (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].STOCK'))
            AND   (col.name = 'stDescLine2')
           )
   AND
   EXISTS (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].STOCK'))
            AND   (col.name = 'stDescLine3')
           )

  AND
  EXISTS  (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].STOCK'))
            AND   (col.name = 'stDescLine4')
           )
 
  AND
  EXISTS  (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].STOCK'))
            AND   (col.name = 'stDescLine5')
           )
 
  AND
  EXISTS  (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].STOCK'))
            AND   (col.name = 'stDescLine6')
           )
 
  AND
  EXISTS  (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].STOCK'))
            AND   (col.name = 'stSSDUnitDesc')
           )
			    
  AND
  EXISTS  (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].STOCK'))
            AND   (col.name = 'stUnitOfPurch')
           )
  AND
  EXISTS  (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].STOCK'))
            AND   (col.name = 'stUnitOfSale')
           )
  
  AND
  EXISTS  (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].STOCK'))
            AND   (col.name = 'stUnitOfStock')
           )
  AND
  EXISTS  ( 
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].STOCK'))
            AND   (col.name = 'stUserField1')
           )
  AND
  EXISTS  (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].STOCK'))
            AND   (col.name = 'stUserField2')
           )
  AND
  EXISTS  (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].STOCK'))
            AND   (col.name = 'stUserField3')
           )
  AND
  EXISTS  (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].STOCK'))
            AND   (col.name = 'stUserField4')
           )
  AND
  EXISTS  (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].STOCK'))
            AND   (col.name = 'stUserField5')
           )
  AND
  EXISTS  (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].STOCK'))
            AND   (col.name = 'stUserField6')
           )
  AND
  EXISTS  (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].STOCK'))
            AND   (col.name = 'stUserField7')
           )
  AND
  EXISTS  (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].STOCK'))
            AND   (col.name = 'stUserField8')
           )
  AND
  EXISTS  (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].STOCK'))
            AND   (col.name = 'stUserField9')
           )
  AND
  EXISTS  (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].STOCK'))
            AND   (col.name = 'stUserField10')
           )
 			  
BEGIN

--Altering All the columns so to be collated SQL_Latin1_General_CP1_CI_AS
--CP1 - Codepage 1
--CI - Case Insensitive
--AS - Accent Sensitive.

ALTER TABLE [!ActiveSchema!].[STOCK] ALTER COLUMN stDescLine2 varchar(35) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[STOCK] ALTER COLUMN stDescLine3 varchar(35) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[STOCK] ALTER COLUMN stDescLine4 varchar(35) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[STOCK] ALTER COLUMN stDescLine5 varchar(35) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[STOCK] ALTER COLUMN stDescLine6 varchar(35) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[STOCK] ALTER COLUMN stSSDUnitDesc varchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[STOCK] ALTER COLUMN stUnitOfPurch varchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[STOCK] ALTER COLUMN stUnitOfSale varchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[STOCK] ALTER COLUMN stUnitOfStock varchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[STOCK] ALTER COLUMN stUserField1 varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[STOCK] ALTER COLUMN stUserField2 varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[STOCK] ALTER COLUMN stUserField3 varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[STOCK] ALTER COLUMN stUserField4 varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[STOCK] ALTER COLUMN stUserField5 varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[STOCK] ALTER COLUMN stUserField6 varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[STOCK] ALTER COLUMN stUserField7 varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[STOCK] ALTER COLUMN stUserField8 varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[STOCK] ALTER COLUMN stUserField9 varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[STOCK] ALTER COLUMN stUserField10 varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS

END 

-- Now we update the Version number for the SchemaVersion table
UPDATE    [!ActiveSchema!].SchemaVersion
SET       Version = 3
WHERE     SchemaName = 'stock_final.xml' AND Version = 2


SET NOCOUNT OFF
