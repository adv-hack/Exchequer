--/////////////////////////////////////////////////////////////////////////////
--// Filename		: DocumentUpgraderV3.sql
--// Author			: Chris Sandow
--// Date				: 12 October 2010
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2015. All rights reserved.
--// Description		: SQL Script to upgrade table for the 6.5 release
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	12th October 2010:	File Creation - Chris Sandow
--//
--/////////////////////////////////////////////////////////////////////////////
--// Adds the new thOverrideLocation field.
--// This also updates EBUSDOC, which shares the same schema as DOCUMENT.

SET NOCOUNT ON

declare @default sysname, @sql nvarchar(max) 

-- Update DOCUMENT
-- First we check to see if the new column exists in the table
IF EXISTS (
            SELECT  *
            FROM    sysobjects tab 
            WHERE   (tab.id = object_id('[!ActiveSchema!].DOCUMENT')) 
          )
   AND
   NOT EXISTS (
                 SELECT *
                 FROM   sysobjects tab INNER JOIN
                        syscolumns col ON tab.id = col.id
                 WHERE  (tab.id = object_id('[!ActiveSchema!].DOCUMENT')) 
                  AND   (col.name = 'thOverrideLocation') 
              ) 
BEGIN
  select @default = name  
  from sys.default_constraints  
  where parent_object_id = object_id('[!ActiveSchema!].DOCUMENT') 
  AND type = 'D' 
  AND parent_column_id = ( 
      select column_id  
      from sys.columns  
      where object_id = object_id('[!ActiveSchema!].DOCUMENT') 
      and name = 'thSpare5'
      ) 
   
  set @sql = N'alter table [!ActiveSchema!].DOCUMENT drop constraint ' + @default 
  exec sp_executesql @sql 
   
  set @sql = N'alter table [!ActiveSchema!].DOCUMENT drop column thSpare5'
  exec sp_executesql @sql
  
  ALTER TABLE [!ActiveSchema!].DOCUMENT
  ADD 
    thSpare5 VARBINARY(54) NOT NULL DEFAULT 0x0,
    thOverrideLocation VARCHAR(3) NOT NULL DEFAULT ''
END

-- Update EBUSDOC
-- First we check to see if the new column exists in the table
IF EXISTS (
            SELECT  *
            FROM    sysobjects tab 
            WHERE   (tab.id = object_id('[!ActiveSchema!].EBUSDOC')) 
          )
   AND
   NOT EXISTS (
                 SELECT *
                 FROM   sysobjects tab INNER JOIN
                        syscolumns col ON tab.id = col.id
                 WHERE  (tab.id = object_id('[!ActiveSchema!].EBUSDOC')) 
                  AND   (col.name = 'thOverrideLocation') 
              ) 
BEGIN
  select @default = name  
  from sys.default_constraints  
  where parent_object_id = object_id('[!ActiveSchema!].EBUSDOC') 
  AND type = 'D' 
  AND parent_column_id = ( 
      select column_id  
      from sys.columns  
      where object_id = object_id('[!ActiveSchema!].EBUSDOC') 
      and name = 'thSpare5'
      ) 
   
  set @sql = N'alter table [!ActiveSchema!].EBUSDOC drop constraint ' + @default 
  exec sp_executesql @sql 
   
  set @sql = N'alter table [!ActiveSchema!].EBUSDOC drop column thSpare5'
  
  exec sp_executesql @sql   ALTER TABLE [!ActiveSchema!].EBUSDOC
  ADD 
    thSpare5 VARBINARY(54) NOT NULL DEFAULT 0x0,
    thOverrideLocation VARCHAR(3) NOT NULL DEFAULT ''
END

-- Now we update the Version number for Document_final.xml in the SchemaVersion table
UPDATE    [!ActiveSchema!].SchemaVersion
SET       Version = 3
WHERE     SchemaName = 'Document_Final.xml' AND Version = 2

SET NOCOUNT OFF

