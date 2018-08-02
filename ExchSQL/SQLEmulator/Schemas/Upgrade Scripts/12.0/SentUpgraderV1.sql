--/////////////////////////////////////////////////////////////////////////////
--// Filename		: SentUpgraderV1.sql
--// Author			: Rahul Bhavani
--// Date			: 20 July 2018
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2016. All rights reserved.
--// Description	: Script to rename elCSVFileName field and adding new field.
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	20 July 2018:	Renaming elCSVFileName field - Rahul Bhavani
--//--/////////////////////////////////////////////////////////////////////////////

SET NOCOUNT ON

-- First we check to see if the new column already exists in the table. This is
-- because all the upgrade scripts are run every time the system is upgraded,
-- so we must be careful not to try to make amendments which have already been
-- done.
IF EXISTS (
            SELECT *
            FROM   sysobjects tab
            WHERE  (tab.id = object_id('[!ActiveSchema!].Sent'))
          )
   AND
   NOT EXISTS (
                SELECT *
                FROM   sysobjects tab INNER JOIN
                       syscolumns col ON tab.id = col.id
                WHERE  (tab.id = object_id('[!ActiveSchema!].Sent'))
                 AND   (col.name = 'elCSVFileNameOld')
              )
BEGIN
  
  -- Now rename the old field
  EXEC sp_rename @objname='[!ActiveSchema!].Sent.elCSVFileName', @newname='elCSVFileNameOld', @objtype='COLUMN'
  
  -- Now add the new field
  ALTER TABLE [!ActiveSchema!].Sent
  ADD
    -- Fields which are in the <fixedfields> section of the XML schema MUST
    -- be specified as NOT NULL, with a DEFAULT.
	elCSVFileName varchar(60) NOT NULL DEFAULT CHAR(0)
	
  -- Now copy data from elCSVFileNameOld -> elCSVFileName
  EXEC(' 
		UPDATE [!ActiveSchema!].Sent
		SET elCSVFileName = elCSVFileNameOld	
	  ')	
END
GO

-- Now we update the Version number for the SchemaVersion table
UPDATE    [!ActiveSchema!].SchemaVersion
SET       Version = 1
WHERE     SchemaName = 'SENT_FINAL.XML' AND Version = 0

SET NOCOUNT OFF
