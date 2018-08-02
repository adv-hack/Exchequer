--/////////////////////////////////////////////////////////////////////////////
--// Filename		: CustSuppUpgraderV9.sql
--// Author			: Rahul Bhavani
--// Date			: 14 November 2017
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2016. All rights reserved.
--// Description	: GDPR Fields
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	21st March 2015:	File Creation - Chris Sandow
--//	9   14th Novemeber 2017: GDPR Database changes.
--/////////////////////////////////////////////////////////////////////////////

SET NOCOUNT ON

-- First we check to see if the new column already exists in the table. This is
-- because all the upgrade scripts are run every time the system is upgraded,
-- so we must be careful not to try to make amendments which have already been
-- done.
IF EXISTS (
            SELECT *
            FROM   sysobjects tab
            WHERE  (tab.id = object_id('[!ActiveSchema!].CustSupp'))
          )
   AND
   NOT EXISTS (
                SELECT *
                FROM   sysobjects tab INNER JOIN
                       syscolumns col ON tab.id = col.id
                WHERE  (tab.id = object_id('[!ActiveSchema!].CustSupp'))
                 AND   (col.name = 'acAnonymisationStatus')
              )
   AND
   NOT EXISTS (
                SELECT *
                FROM   sysobjects tab INNER JOIN
                       syscolumns col ON tab.id = col.id
                WHERE  (tab.id = object_id('[!ActiveSchema!].CustSupp'))
                 AND   (col.name = 'acAnonymisedDate')
              )
   AND
   NOT EXISTS (
                SELECT *
                FROM   sysobjects tab INNER JOIN
                       syscolumns col ON tab.id = col.id
                WHERE  (tab.id = object_id('[!ActiveSchema!].CustSupp'))
                 AND   (col.name = 'acAnonymisedTime')
              )
BEGIN
  ALTER TABLE [!ActiveSchema!].CustSupp
  ADD
    -- Fields which are in the <fixedfields> section of the XML schema MUST
    -- be specified as NOT NULL, with a DEFAULT.
    acAnonymisationStatus int NOT NULL DEFAULT 0,
	acAnonymisedDate varchar(8) NOT NULL DEFAULT CHAR(0),
	acAnonymisedTime varchar(6) NOT NULL DEFAULT CHAR(0)
	
END
GO

-- Now we update the Version number for the SchemaVersion table
UPDATE    [!ActiveSchema!].SchemaVersion
SET       Version = 9
WHERE     SchemaName = 'CustSupp_Final.xml' AND Version = 8

SET NOCOUNT OFF
