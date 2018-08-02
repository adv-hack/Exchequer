--/////////////////////////////////////////////////////////////////////////////
--// Filename		    : MLocStkCollateUpgraderV12.sql
--// Author			    : Trapti Gupta	
--// Date				: 13 June 2017
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2016. All rights reserved.
--// Description		: SQL Script to upgrade table for the 9.1 release

SET NOCOUNT ON

IF EXISTS (
            SELECT *
            FROM   sysobjects tab
            WHERE  (tab.id = object_id('[!ActiveSchema!].MLOCSTK'))
          )
   AND
   EXISTS (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].MLOCSTK'))
            AND   (col.name = 'ArcOldYourRef')
           )
   AND
   EXISTS (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].MLOCSTK'))
            AND   (col.name = 'ArcOurRef')
           )

  AND
  EXISTS  ( 
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].MLOCSTK'))
            AND   (col.name = 'ArcSRCPIRef')
           )
 
  AND
  EXISTS  (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].MLOCSTK'))
            AND   (col.name = 'ArcUD1')
           )
 
  AND
  EXISTS  (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].MLOCSTK'))
            AND   (col.name = 'ArcUD2')
           )
 
  AND
  EXISTS  (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].MLOCSTK'))
            AND   (col.name = 'ArcUD3')
           )
  AND
  EXISTS  (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].MLOCSTK'))
            AND   (col.name = 'ArcUD4')
           )
  AND
  EXISTS  (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].MLOCSTK'))
            AND   (col.name = 'ArcUD5')
           )
  AND
  EXISTS  (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].MLOCSTK'))
            AND   (col.name = 'ArcUD6')
           )
  AND
  EXISTS  (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].MLOCSTK'))
            AND   (col.name = 'ArcUD7')
           )
  AND
  EXISTS  (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].MLOCSTK'))
            AND   (col.name = 'ArcUD8')
           )
  AND
  EXISTS  (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].MLOCSTK'))
            AND   (col.name = 'ArcUD9')
           )
  AND
  EXISTS  (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].MLOCSTK'))
            AND   (col.name = 'ArcUD10')
           )
  AND
  EXISTS  (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].MLOCSTK'))
            AND   (col.name = 'ArcYourRef')
           )
  AND
  EXISTS  (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].MLOCSTK'))
            AND   (col.name = 'BrChargeInst')
           )
  AND
  EXISTS  (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].MLOCSTK'))
            AND   (col.name = 'BrOldYourRef')
           )
  AND
  EXISTS  (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].MLOCSTK'))
            AND   (col.name = 'BrSwiftBIC')
           )
  AND
  EXISTS  (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].MLOCSTK'))
            AND   (col.name = 'BrSwiftRef1')
           )
  AND
  EXISTS  (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].MLOCSTK'))
            AND   (col.name = 'BrSwiftRef2')
           )
  AND
  EXISTS  (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].MLOCSTK'))
            AND   (col.name = 'BrSwiftRef3')
           )
  AND
  EXISTS  (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].MLOCSTK'))
            AND   (col.name = 'BrUOM')
           )
  AND
  EXISTS  (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].MLOCSTK'))
            AND   (col.name = 'BrYourRef')
           )
  AND
  EXISTS  (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].MLOCSTK'))
            AND   (col.name = 'CsDesc1')
           )
  AND
  EXISTS  (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].MLOCSTK'))
            AND   (col.name = 'CsDesc2')
           )
  AND
  EXISTS  (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].MLOCSTK'))
            AND   (col.name = 'CsDesc3')
           )
  AND
  EXISTS  (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].MLOCSTK'))
            AND   (col.name = 'CsDesc4')
           )
  AND
  EXISTS  (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].MLOCSTK'))
            AND   (col.name = 'CsDesc5')
           )
  AND
  EXISTS  (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].MLOCSTK'))
            AND   (col.name = 'CsDesc6')
           )

  AND
  EXISTS  (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].MLOCSTK'))
            AND   (col.name = 'EbLineRef')
           )
  AND
  EXISTS  (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].MLOCSTK'))
            AND   (col.name = 'EbLineRef2')
           )
  AND
  EXISTS  (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].MLOCSTK'))
            AND   (col.name = 'EbStatRef')
           )

  AND
  EXISTS  (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].MLOCSTK'))
            AND   (col.name = 'EmDocRef')
           )
  AND
  EXISTS  (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].MLOCSTK'))
            AND   (col.name = 'LoArea')
           )
  AND
  EXISTS  (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].MLOCSTK'))
            AND   (col.name = 'LoContact')
           )
  AND
  EXISTS  (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].MLOCSTK'))
            AND   (col.name = 'LoRep')
           )
  AND
  EXISTS  (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].MLOCSTK'))
            AND   (col.name = 'LsBinLoc')
           )
  AND
  EXISTS  (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].MLOCSTK'))
            AND   (col.name = 'SdDesc')
           )
  AND
  EXISTS  (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].MLOCSTK'))
            AND   (col.name = 'TcLYRef')
           )
  AND
  EXISTS  (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].MLOCSTK'))
            AND   (col.name = 'TcOldYourRef')
           )
  AND
  EXISTS  (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].MLOCSTK'))
            AND   (col.name = 'TcYourRef')
           )
BEGIN

--Altering All the columns so to be collated SQL_Latin1_General_CP1_CI_AS
--CP1 - Codepage 1
--CI - Case Insensitive
--AS - Accent Sensitive.

ALTER TABLE [!ActiveSchema!].[MLOCSTK] ALTER COLUMN ArcOldYourRef varchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[MLOCSTK] ALTER COLUMN ArcOurRef varchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[MLOCSTK] ALTER COLUMN ArcSRCPIRef varchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[MLOCSTK] ALTER COLUMN ArcUD1 varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[MLOCSTK] ALTER COLUMN ArcUD2 varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[MLOCSTK] ALTER COLUMN ArcUD3 varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[MLOCSTK] ALTER COLUMN ArcUD4 varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[MLOCSTK] ALTER COLUMN ArcUD5 varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[MLOCSTK] ALTER COLUMN ArcUD6 varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[MLOCSTK] ALTER COLUMN ArcUD7 varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[MLOCSTK] ALTER COLUMN ArcUD8 varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[MLOCSTK] ALTER COLUMN ArcUD9 varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[MLOCSTK] ALTER COLUMN ArcUD10 varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[MLOCSTK] ALTER COLUMN ArcYourRef varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[MLOCSTK] ALTER COLUMN BrChargeInst varchar(5) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[MLOCSTK] ALTER COLUMN BrOldYourRef varchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[MLOCSTK] ALTER COLUMN BrSwiftBIC varchar(11) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[MLOCSTK] ALTER COLUMN BrSwiftRef1 varchar(60) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[MLOCSTK] ALTER COLUMN BrSwiftRef2 varchar(60) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[MLOCSTK] ALTER COLUMN BrSwiftRef3 varchar(60) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[MLOCSTK] ALTER COLUMN BrUOM varchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[MLOCSTK] ALTER COLUMN BrYourRef varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[MLOCSTK] ALTER COLUMN CsDesc1 varchar(35) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[MLOCSTK] ALTER COLUMN CsDesc2 varchar(35) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[MLOCSTK] ALTER COLUMN CsDesc3 varchar(35) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[MLOCSTK] ALTER COLUMN CsDesc4 varchar(35) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[MLOCSTK] ALTER COLUMN CsDesc5 varchar(35) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[MLOCSTK] ALTER COLUMN CsDesc6 varchar(35) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[MLOCSTK] ALTER COLUMN EbLineRef varchar(40) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[MLOCSTK] ALTER COLUMN EbLineRef2 varchar(40) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[MLOCSTK] ALTER COLUMN EbStatRef varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[MLOCSTK] ALTER COLUMN EmDocRef varchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[MLOCSTK] ALTER COLUMN LoArea varchar(5) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[MLOCSTK] ALTER COLUMN LoContact varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[MLOCSTK] ALTER COLUMN LoRep varchar(5) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[MLOCSTK] ALTER COLUMN LsBinLoc varchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[MLOCSTK] ALTER COLUMN SdDesc varchar(35) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[MLOCSTK] ALTER COLUMN TcLYRef varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[MLOCSTK] ALTER COLUMN TcOldYourRef varchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[MLOCSTK] ALTER COLUMN TcYourRef varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS

END 

-- Now we update the Version number for the SchemaVersion table
UPDATE    [!ActiveSchema!].SchemaVersion
SET       Version = 12
WHERE     SchemaName = 'MLOCSTK_final.xml' AND Version = 11


SET NOCOUNT OFF
