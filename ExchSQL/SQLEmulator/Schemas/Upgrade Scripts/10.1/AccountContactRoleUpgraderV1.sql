--/////////////////////////////////////////////////////////////////////////////
--// Filename		: AccountContactUpgraderV1.sql
--// Author			: Hitesh Vaghani
--// Date				: 15 May 2017
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2015. All rights reserved.
--// Description		: SQL Script to upgrade table for the 9.1 release
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	2	15 May 2016:	Added Delete rule for constraint [efk_AccountContact_AccountContactRole]  
--//        19 May 2016:    Removed datecreated field from schema file
--/////////////////////////////////////////////////////////////////////////////

SET NOCOUNT ON

-- First we check to see if the column already exists in the table and also exists
-- constraint with No Action Delete Rule. 

IF EXISTS (
            SELECT *
            FROM   sysobjects tab
            WHERE  (tab.id = object_id('[!ActiveSchema!].AccountContactRole'))
          )
   AND
   EXISTS (
                SELECT *
                FROM   sysobjects tab INNER JOIN
                       syscolumns col ON tab.id = col.id
                WHERE  (tab.id = object_id('[!ActiveSchema!].AccountContactRole'))
                 AND   (col.name = 'acrContactId')
              )
   AND
   EXISTS (
				SELECT * 
				FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS 
				WHERE CONSTRAINT_NAME ='efk_AccountContact_AccountContactRole'
				AND DELETE_RULE = 'NO ACTION'
			  )
BEGIN
	--Drop current constraint
	ALTER TABLE [!ActiveSchema!].AccountContactRole
	DROP CONSTRAINT [efk_AccountContact_AccountContactRole]
	
	--Recreate constraint with Delete rule
	ALTER TABLE [!ActiveSchema!].[AccountContactRole]  WITH NOCHECK ADD  CONSTRAINT [efk_AccountContact_AccountContactRole] FOREIGN KEY([acrContactId])
	REFERENCES [!ActiveSchema!].[AccountContact] ([acoContactId])
	ON DELETE CASCADE
END

-- Now we update the Version number for the SchemaVersion table
UPDATE    [!ActiveSchema!].SchemaVersion
SET       Version = 1
WHERE     SchemaName = 'AccountContactRole.xml' AND Version = 0

SET NOCOUNT OFF
