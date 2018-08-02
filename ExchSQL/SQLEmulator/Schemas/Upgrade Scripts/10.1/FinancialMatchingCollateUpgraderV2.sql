--/////////////////////////////////////////////////////////////////////////////
--// Filename		    : FinancialMatchingCollateUpgraderV2.sql
--// Author			    : Trapti Gupta	
--// Date				: 13 June 2017
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2016. All rights reserved.
--// Description		: SQL Script to upgrade table for the 9.1 release
SET NOCOUNT ON

IF EXISTS (
            SELECT *
            FROM   sysobjects tab
            WHERE  (tab.id = object_id('[!ActiveSchema!].FinancialMatching'))
          )
   AND
   EXISTS (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].FinancialMatching'))
            AND   (col.name = 'AltRef')
           )
   AND
   EXISTS (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].FinancialMatching'))
            AND   (col.name = 'OldAltRef')
           )       
BEGIN


ALTER TABLE [!ActiveSchema!].[FinancialMatching] ALTER COLUMN AltRef varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[FinancialMatching] ALTER COLUMN OldAltRef varchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS

END 

-- Now we update the Version number for the SchemaVersion table
UPDATE    [!ActiveSchema!].SchemaVersion
SET       Version = 2
WHERE     SchemaName = 'FinancialMatching.xml' AND Version = 1


SET NOCOUNT OFF
