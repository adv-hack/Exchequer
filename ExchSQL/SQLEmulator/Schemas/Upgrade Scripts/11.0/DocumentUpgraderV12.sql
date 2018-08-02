--/////////////////////////////////////////////////////////////////////////////
--// Filename		: DocumentUpgraderV12.sql
--// Author			: Rahul Bhavani	
--// Date				: 17 November 2017
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2016. All rights reserved.
--// Description		: SQL Script to upgrade table for GDPR
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	21st March 2016:	Added new fields - Chris Sandow
--//
--/////////////////////////////////////////////////////////////////////////////

SET NOCOUNT ON

-- First we check to see if the new column already exists in the table. This is
-- because all the upgrade scripts are run every time the system is upgraded,
-- so we must be careful not to try to make amendments which have already been
-- done.
IF EXISTS (
            SELECT *
            FROM   sysobjects tab
            WHERE  (tab.id = object_id('[!ActiveSchema!].DOCUMENT'))
          )
   AND
   NOT EXISTS (
                SELECT *
                FROM   sysobjects tab INNER JOIN
                       syscolumns col ON tab.id = col.id
                WHERE  (tab.id = object_id('[!ActiveSchema!].DOCUMENT'))
                 AND   (col.name = 'thAnonymised')
              )
   AND
   NOT EXISTS (
                SELECT *
                FROM   sysobjects tab INNER JOIN
                       syscolumns col ON tab.id = col.id
                WHERE  (tab.id = object_id('[!ActiveSchema!].DOCUMENT'))
                 AND   (col.name = 'thAnonymisedDate')
              )
   AND
   NOT EXISTS (
                SELECT *
                FROM   sysobjects tab INNER JOIN
                       syscolumns col ON tab.id = col.id
                WHERE  (tab.id = object_id('[!ActiveSchema!].DOCUMENT'))
                 AND   (col.name = 'thAnonymisedTime')
              )
BEGIN
  ALTER TABLE [!ActiveSchema!].DOCUMENT
  ADD
    -- Fields which are in the <fixedfields> section of the XML schema MUST
    -- be specified as NOT NULL, with a DEFAULT.
    thAnonymised bit NOT NULL DEFAULT 0,
    thAnonymisedDate varchar(8) NOT NULL DEFAULT CHAR(0),
    thAnonymisedTime varchar(6) NOT NULL DEFAULT CHAR(0)
END
GO

-- Also add the field to EBUSDOC
IF EXISTS (
            SELECT *
            FROM   sysobjects tab
            WHERE  (tab.id = object_id('[!ActiveSchema!].EBUSDOC'))
          )
   AND
   NOT EXISTS (
                SELECT *
                FROM   sysobjects tab INNER JOIN
                       syscolumns col ON tab.id = col.id
                WHERE  (tab.id = object_id('[!ActiveSchema!].EBUSDOC'))
                 AND   (col.name = 'thAnonymised')
              )
   AND
   NOT EXISTS (
                SELECT *
                FROM   sysobjects tab INNER JOIN
                       syscolumns col ON tab.id = col.id
                WHERE  (tab.id = object_id('[!ActiveSchema!].EBUSDOC'))
                 AND   (col.name = 'thAnonymisedDate')
              )
   AND
   NOT EXISTS (
                SELECT *
                FROM   sysobjects tab INNER JOIN
                       syscolumns col ON tab.id = col.id
                WHERE  (tab.id = object_id('[!ActiveSchema!].EBUSDOC'))
                 AND   (col.name = 'thAnonymisedTime')
              )
BEGIN
  ALTER TABLE [!ActiveSchema!].EBUSDOC
  ADD
    -- Fields which are in the <fixedfields> section of the XML schema MUST
    -- be specified as NOT NULL, with a DEFAULT.
    thAnonymised bit NOT NULL DEFAULT 0,
    thAnonymisedDate varchar(8) NOT NULL DEFAULT CHAR(0),
    thAnonymisedTime varchar(6) NOT NULL DEFAULT CHAR(0)
END
GO

-- Now we update the Version number for the SchemaVersion table
UPDATE    [!ActiveSchema!].SchemaVersion
SET       Version = 12
WHERE     SchemaName = 'DOCUMENT_Final.xml' AND Version = 11

SET NOCOUNT OFF

