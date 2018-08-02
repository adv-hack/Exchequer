--/////////////////////////////////////////////////////////////////////////////
--// Filename		: AccountContactUpgraderV1.sql
--// Author			: Hitesh Vaghani
--// Date				: 15 May 2017
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2015. All rights reserved.
--// Description		: SQL Script to upgrade table for the 9.1 release
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	3	15 May 2017:	Added Delete rule for constraint [efk_CUSTSUPP_AccountContact]
--//        19 May 2016:    Removed datecreated & datemodified field from schema file
--/////////////////////////////////////////////////////////////////////////////

SET NOCOUNT ON

-- First we check to see if the column already exists in the table and also exists
-- constraint with No Action Delete Rule. 

IF EXISTS (
            SELECT *
            FROM   sysobjects tab
            WHERE  (tab.id = object_id('[!ActiveSchema!].AccountContact'))
          )
   AND
   EXISTS (
                SELECT *
                FROM   sysobjects tab INNER JOIN
                       syscolumns col ON tab.id = col.id
                WHERE  (tab.id = object_id('[!ActiveSchema!].AccountContact'))
                 AND   (col.name = 'acoAccountCode')
              )
   AND 
   EXISTS (
				SELECT * 
				FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS 
				WHERE CONSTRAINT_NAME ='efk_CUSTSUPP_AccountContact'
				AND DELETE_RULE = 'NO ACTION'
			  )
BEGIN

	--Drop current constraint
	ALTER TABLE [!ActiveSchema!].AccountContact
	DROP CONSTRAINT [efk_CUSTSUPP_AccountContact]

	--Recreate constraint with delete rule
	ALTER TABLE [!ActiveSchema!].[AccountContact]  WITH CHECK ADD  CONSTRAINT [efk_CUSTSUPP_AccountContact] FOREIGN KEY([acoAccountCode])
	REFERENCES [!ActiveSchema!].[CUSTSUPP] ([acCode])
	ON UPDATE CASCADE
	ON DELETE CASCADE
END

-- Now we update the Version number for the SchemaVersion table
UPDATE    [!ActiveSchema!].SchemaVersion
SET       Version = 2
WHERE     SchemaName = 'AccountContact.xml' AND Version = 1

SET NOCOUNT OFF