--/////////////////////////////////////////////////////////////////////////////
--// Filename		    : exstkchkCollateUpgraderV5.sql
--// Author			    : Trapti Gupta	
--// Date				: 13 June 2017
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2016. All rights reserved.
--// Description		: SQL Script to upgrade table for the 9.1 release
SET NOCOUNT ON

IF EXISTS (
            SELECT *
            FROM   sysobjects tab
            WHERE  (tab.id = object_id('[!ActiveSchema!].EXSTKCHK'))
          )
   AND
     EXISTS (
                SELECT *
                FROM   sysobjects tab INNER JOIN
                       syscolumns col ON tab.id = col.id
                WHERE  (tab.id = object_id('[!ActiveSchema!].EXSTKCHK'))
                 AND   (col.name = 'LocFDesc')
              )

  AND
     EXISTS (
                SELECT *
                FROM   sysobjects tab INNER JOIN
                       syscolumns col ON tab.id = col.id
                WHERE  (tab.id = object_id('[!ActiveSchema!].EXSTKCHK'))
                 AND   (col.name = 'ReasonDesc')
              )
      
  
BEGIN

--Altering All the columns so to be collated SQL_Latin1_General_CP1_CI_AS
--CP1 - Codepage 1
--CI - Case Insensitive
--AS - Accent Sensitive.

ALTER TABLE [!ActiveSchema!].[EXSTKCHK] ALTER COLUMN LocFDesc varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[EXSTKCHK] ALTER COLUMN ReasonDesc varchar(60) COLLATE SQL_Latin1_General_CP1_CI_AS

END 

-- Now we update the Version number for the SchemaVersion table
UPDATE    [!ActiveSchema!].SchemaVersion
SET       Version = 5
WHERE     SchemaName = 'EXSTKCHK_final.xml' AND Version = 4


SET NOCOUNT OFF
