--/////////////////////////////////////////////////////////////////////////////
--// Filename		: DOCUMENTUpgraderV6.sql
--// Author			: Chris Sandow
--// Date				: 14 October 2013
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2015. All rights reserved.
--// Description		: SQL Script to upgrade table for the 7.0.7 release
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	14 October 2013:	Copied amendments from 7.x MRD branch - Chris Sandow
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
                 AND   (col.name = 'thDeliveryPostCode')
              )
BEGIN
  ALTER TABLE [!ActiveSchema!].DOCUMENT
  ADD
    -- Fields which are in the <fixedfields> section of the XML schema MUST
    -- be specified as NOT NULL, with a DEFAULT.
    thDeliveryPostCode  varchar(20) NOT NULL DEFAULT CHAR(0),
    thOriginator        varchar(36) NOT NULL DEFAULT CHAR(0),
    thCreationTime      varchar(6)  NOT NULL DEFAULT CHAR(0),
    thCreationDate      varchar(8)  NOT NULL DEFAULT CHAR(0)
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
                 AND   (col.name = 'thDeliveryPostCode')
              )
BEGIN
  ALTER TABLE [!ActiveSchema!].EBUSDOC
  ADD
    -- Fields which are in the <fixedfields> section of the XML schema MUST
    -- be specified as NOT NULL, with a DEFAULT.
    thDeliveryPostCode  varchar(20) NOT NULL DEFAULT CHAR(0),
    thOriginator        varchar(36) NOT NULL DEFAULT CHAR(0),
    thCreationTime      varchar(6)  NOT NULL DEFAULT CHAR(0),
    thCreationDate      varchar(8)  NOT NULL DEFAULT CHAR(0)
END
GO

-- Now we update the Version number for the SchemaVersion table
UPDATE    [!ActiveSchema!].SchemaVersion
SET       Version = 6
WHERE     SchemaName = 'DOCUMENT_Final.xml' AND Version = 5

SET NOCOUNT OFF

