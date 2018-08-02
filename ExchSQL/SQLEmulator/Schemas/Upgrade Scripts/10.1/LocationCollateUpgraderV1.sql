--/////////////////////////////////////////////////////////////////////////////
--// Filename		    : LocationCollateUpgraderV1.sql
--// Author			    : Trapti Gupta	
--// Date				: 13 June 2017
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2016. All rights reserved.
--// Description		: SQL Script to upgrade table for the 9.1 release

SET NOCOUNT ON

IF EXISTS (
            SELECT *
            FROM   sysobjects tab
            WHERE  (tab.id = object_id('[!ActiveSchema!].LOCATION'))
          )
   AND
   EXISTS (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].LOCATION'))
            AND   (col.name = 'LoArea')
           )
   AND
   EXISTS (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].LOCATION'))
            AND   (col.name = 'LoContact')
           )

  AND
  EXISTS  (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].LOCATION'))
            AND   (col.name = 'LoRep')
           )
 
BEGIN

--Altering All the columns so to be collated SQL_Latin1_General_CP1_CI_AS
--CP1 - Codepage 1
--CI - Case Insensitive
--AS - Accent Sensitive.

ALTER TABLE [!ActiveSchema!].[LOCATION] ALTER COLUMN LoArea varchar(5) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[LOCATION] ALTER COLUMN LoContact varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[LOCATION] ALTER COLUMN LoRep varchar(5) COLLATE SQL_Latin1_General_CP1_CI_AS

END 

-- Now we update the Version number for the SchemaVersion table
UPDATE    [!ActiveSchema!].SchemaVersion
SET       Version = 1
WHERE     SchemaName = 'Location.xml' AND Version = 0


SET NOCOUNT OFF
