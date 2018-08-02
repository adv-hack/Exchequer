--/////////////////////////////////////////////////////////////////////////////
--// Filename		: MLocStkUpgraderV13.sql
--// Author			: Rahul Bhavani
--// Date				: 4th July 2017
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2016. All rights reserved.
--// Description		: SQL Script to upgrade table for the 10.1 release
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	ABSEXCH-18830: 2.3.1 User Management List - Database Changes (Password Complexity)
--//
--/////////////////////////////////////////////////////////////////////////////

SET NOCOUNT ON

-- First we check to see if the new columnss already exists in the table. This is
-- because all the upgrade scripts are run every time the system is upgraded,
-- so we must be careful not to try to make amendments which have already been
-- done.
IF EXISTS (
            SELECT *
            FROM   sysobjects tab
            WHERE  (tab.id = object_id('[!ActiveSchema!].MLocStk'))
          )
   AND
   NOT EXISTS (
                SELECT *
                FROM   sysobjects tab INNER JOIN
                       syscolumns col ON tab.id = col.id
                WHERE  (tab.id = object_id('[!ActiveSchema!].MLocStk'))
                 AND   (col.name = 'UserStatus')
              )
   AND
   NOT EXISTS (
                SELECT *
                FROM   sysobjects tab INNER JOIN
                       syscolumns col ON tab.id = col.id
                WHERE  (tab.id = object_id('[!ActiveSchema!].MLocStk'))
                 AND   (col.name = 'PasswordSalt')
              )
   AND
   NOT EXISTS (
                SELECT *
                FROM   sysobjects tab INNER JOIN
                       syscolumns col ON tab.id = col.id
                WHERE  (tab.id = object_id('[!ActiveSchema!].MLocStk'))
                 AND   (col.name = 'PasswordHash')
              )
   AND
   NOT EXISTS (
                SELECT *
                FROM   sysobjects tab INNER JOIN
                       syscolumns col ON tab.id = col.id
                WHERE  (tab.id = object_id('[!ActiveSchema!].MLocStk'))
                 AND   (col.name = 'WindowUserId')
              )
   AND
   NOT EXISTS (
                SELECT *
                FROM   sysobjects tab INNER JOIN
                       syscolumns col ON tab.id = col.id
                WHERE  (tab.id = object_id('[!ActiveSchema!].MLocStk'))
                 AND   (col.name = 'SecurityQuestionId')
              )
   AND
   NOT EXISTS (
                SELECT *
                FROM   sysobjects tab INNER JOIN
                       syscolumns col ON tab.id = col.id
                WHERE  (tab.id = object_id('[!ActiveSchema!].MLocStk'))
                 AND   (col.name = 'SecurityAnswer')
              )
   AND
   NOT EXISTS (
                SELECT *
                FROM   sysobjects tab INNER JOIN
                       syscolumns col ON tab.id = col.id
                WHERE  (tab.id = object_id('[!ActiveSchema!].MLocStk'))
                 AND   (col.name = 'ForcePasswordChange')
              )
   AND
   NOT EXISTS (
                SELECT *
                FROM   sysobjects tab INNER JOIN
                       syscolumns col ON tab.id = col.id
                WHERE  (tab.id = object_id('[!ActiveSchema!].MLocStk'))
                 AND   (col.name = 'LoginFailureCount')
              )
BEGIN
  ALTER TABLE [!ActiveSchema!].MLOCSTK
  ADD
    UserStatus int NULL,
	  PasswordSalt varchar(16) NULL,
	  PasswordHash varchar(64) NULL,
	  WindowUserId varchar(100) NULL,
	  SecurityQuestionId int NULL,
	  SecurityAnswer varchar(139) NULL,
	  ForcePasswordChange bit NULL,
	  LoginFailureCount int NULL; 
END

-- Now we update the Version number for the SchemaVersion table
UPDATE    [!ActiveSchema!].SchemaVersion
SET       Version = 13
WHERE     SchemaName = 'MLocStk_Final.xml' AND Version = 12

SET NOCOUNT OFF