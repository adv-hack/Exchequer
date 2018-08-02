--/////////////////////////////////////////////////////////////////////////////
--// Filename		: AllocWizardSessionUpgraderV2.sql
--// Author			: Chris Sandow
--// Date				: 25 August 2015
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2015. All rights reserved.
--// Description		: SQL Script to upgrade table for the 2015 R1 release
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	25 August 2015:	File Creation - Chris Sandow
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
            WHERE  (tab.id = object_id('[!ActiveSchema!].AllocWizardSession'))
          )
   AND
   NOT EXISTS (
                SELECT *
                FROM   sysobjects tab INNER JOIN
                       syscolumns col ON tab.id = col.id
                WHERE  (tab.id = object_id('[!ActiveSchema!].AllocWizardSession'))
                 AND   (col.name = 'ArcUsePPD')
              )
BEGIN
  ALTER TABLE [!ActiveSchema!].AllocWizardSession
  ADD
    ArcUsePPD bit NOT NULL DEFAULT 0
END

-- Now we update the Version number for the SchemaVersion table
UPDATE    [!ActiveSchema!].SchemaVersion
SET       Version = 2
WHERE     SchemaName = 'AllocWizardSession.xml' AND Version = 1

SET NOCOUNT OFF

