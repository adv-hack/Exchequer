--/////////////////////////////////////////////////////////////////////////////
--// Filename		    : AllocWizardSessionCollateUpgraderV3.sql
--// Author			    : Trapti Gupta	
--// Date				: 13 June 2017
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2016. All rights reserved.
--// Description		: SQL Script to upgrade table for the 9.1 release
SET NOCOUNT ON

IF  EXISTS (
            SELECT *
            FROM   sysobjects tab
            WHERE  (tab.id = object_id('[!ActiveSchema!].AllocWizardSession'))
           )
    AND
    EXISTS (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].AllocWizardSession'))
            AND   (col.name = 'ArcOldYourRef')
           )
	AND
	EXISTS (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].AllocWizardSession'))
            AND   (col.name = 'ArcPayDetails1')
           )	
    AND
	EXISTS (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].AllocWizardSession'))
            AND   (col.name = 'ArcPayDetails2')
           )	
    AND
	EXISTS (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].AllocWizardSession'))
            AND   (col.name = 'ArcPayDetails3')
           )	
	AND
	EXISTS (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].AllocWizardSession'))
            AND   (col.name = 'ArcPayDetails4')
           )	
	AND
	EXISTS (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].AllocWizardSession'))
            AND   (col.name = 'ArcPayDetails5')
           )
	AND
	EXISTS (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].AllocWizardSession'))
            AND   (col.name = 'ArcSRCPIRef')
           )
	AND
	EXISTS (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].AllocWizardSession'))
            AND   (col.name = 'ArcUD1')
           )
    AND
	EXISTS (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].AllocWizardSession'))
            AND   (col.name = 'ArcUD2')
           )
    AND
	EXISTS (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].AllocWizardSession'))
            AND   (col.name = 'ArcUD3')
           )
    AND
	EXISTS (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].AllocWizardSession'))
            AND   (col.name = 'ArcUD4')
           )
    AND
	EXISTS (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].AllocWizardSession'))
            AND   (col.name = 'ArcUD5')
           )
    AND
	EXISTS (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].AllocWizardSession'))
            AND   (col.name = 'ArcUD6')
           )
    AND
	EXISTS (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].AllocWizardSession'))
            AND   (col.name = 'ArcUD7')
           )
    AND
	EXISTS (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].AllocWizardSession'))
            AND   (col.name = 'ArcUD8')
           )
    AND
	EXISTS (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].AllocWizardSession'))
            AND   (col.name = 'ArcUD9')
           )
    AND
	EXISTS (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].AllocWizardSession'))
            AND   (col.name = 'ArcUD10')
           )
    AND
	EXISTS (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].AllocWizardSession'))
            AND   (col.name = 'ArcYourRef')
           )
BEGIN

--Altering All the columns so to be collated SQL_Latin1_General_CP1_CI_AS
--CP1 - Codepage 1
--CI - Case Insensitive
--AS - Accent Sensitive.

ALTER TABLE [!ActiveSchema!].[AllocWizardSession] ALTER COLUMN ArcOldYourRef varchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[AllocWizardSession] ALTER COLUMN ArcPayDetails1 varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[AllocWizardSession] ALTER COLUMN ArcPayDetails2 varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[AllocWizardSession] ALTER COLUMN ArcPayDetails3 varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[AllocWizardSession] ALTER COLUMN ArcPayDetails4 varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[AllocWizardSession] ALTER COLUMN ArcPayDetails5 varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[AllocWizardSession] ALTER COLUMN ArcUD1 varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[AllocWizardSession] ALTER COLUMN ArcUD2 varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[AllocWizardSession] ALTER COLUMN ArcUD3 varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[AllocWizardSession] ALTER COLUMN ArcUD4 varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[AllocWizardSession] ALTER COLUMN ArcUD5 varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[AllocWizardSession] ALTER COLUMN ArcUD6 varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[AllocWizardSession] ALTER COLUMN ArcUD7 varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[AllocWizardSession] ALTER COLUMN ArcUD8 varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[AllocWizardSession] ALTER COLUMN ArcUD9 varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[AllocWizardSession] ALTER COLUMN ArcUD10 varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[AllocWizardSession] ALTER COLUMN ArcYourRef varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS

END 

-- Now we update the Version number for the SchemaVersion table
UPDATE    [!ActiveSchema!].SchemaVersion
SET       Version = 3
WHERE     SchemaName = 'AllocWizardSession.xml' AND Version = 2


SET NOCOUNT OFF
