--/////////////////////////////////////////////////////////////////////////////
--// Filename		: CustomFieldsUpgraderV1.sql
--// Author			: Rahul Bhavani
--// Date			: 14 November 2016
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2016. All rights reserved.
--// Description	: SQL Script to upgrade table for the 2016 R2 release
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	21st March 2015:	File Creation - Chris Sandow
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
            WHERE  (tab.id = object_id('[!ActiveSchema!].CustomFields'))
          )
   AND
   NOT EXISTS (
                SELECT *
                FROM   sysobjects tab INNER JOIN
                       syscolumns col ON tab.id = col.id
                WHERE  (tab.id = object_id('[!ActiveSchema!].CustomFields'))
                 AND   (col.name = 'cfDisplayPIIOption')
              )
   AND
   NOT EXISTS (
                SELECT *
                FROM   sysobjects tab INNER JOIN
                       syscolumns col ON tab.id = col.id
                WHERE  (tab.id = object_id('[!ActiveSchema!].CustomFields'))
                 AND   (col.name = 'cfContainsPIIData')
              )
BEGIN
  ALTER TABLE [!ActiveSchema!].CustomFields
  ADD
    -- Fields which are in the <fixedfields> section of the XML schema MUST
    -- be specified as NOT NULL, with a DEFAULT.
    cfDisplayPIIOption bit NOT NULL DEFAULT 0,
	cfContainsPIIData bit NOT NULL DEFAULT 0

  -- MH 12/12/2017 - Moved Update into EXEC as it was causing the script to crash when upgrading 2017-R1 or
  --                 earlier databases where the cfDisplayPIIOption and cfContainsPIIData don't exist when this
  --                 script is loaded, even though it then creates them!

  --Update cfDisplayPIIOption based on whether the field is within PIIscope	
  EXEC('       
        UPDATE [!ActiveSchema!].CUSTOMFIELDS
        SET cfDisplayPIIOption = 
        CASE
      	      --Fields Outside PII scope
      	      WHEN (cfFieldID >= 3001 and cfFieldID <= 3004) THEN 0
	      WHEN (cfFieldID >= 20001 and cfFieldID <= 20012) THEN 0
	      WHEN (cfFieldID >= 21001 and cfFieldID <= 21010) THEN 0
	      WHEN (cfFieldID >= 22001 and cfFieldID <= 22010) THEN 0
	      WHEN (cfFieldID >= 23001 and cfFieldID <= 23012) THEN 0
	      WHEN (cfFieldID >= 24001 and cfFieldID <= 24010) THEN 0
	      WHEN (cfFieldID >= 25001 and cfFieldID <= 25012) THEN 0
	      WHEN (cfFieldID >= 26001 and cfFieldID <= 26010) THEN 0
		  WHEN (cfFieldID >= 37001 and cfFieldID <= 37012) THEN 0
		  WHEN (cfFieldID >= 38001 and cfFieldID <= 38010) THEN 0		  
	      WHEN (cfFieldID >= 45001 and cfFieldID <= 45005) THEN 0
	      WHEN (cfFieldID >= 46001 and cfFieldID <= 46002) THEN 0		  
	      ELSE 1
        END
       ')
END
GO

--Alter size of cfDescription field
IF ((SELECT COLUMNPROPERTY( OBJECT_ID('[!ActiveSchema!].CustomFields'), 'cfDescription', 'PRECISION') AS COL_LENGTH) = 30)
BEGIN
  ALTER TABLE [!ActiveSchema!].CustomFields
  ALTER COLUMN [cfDescription] [varchar](255) NOT NULL
END
GO


-- Now we update the Version number for the SchemaVersion table
UPDATE    [!ActiveSchema!].SchemaVersion
SET       Version = 1
WHERE     SchemaName = 'CUSTOMFIELDS.XML' AND Version = 0

SET NOCOUNT OFF
