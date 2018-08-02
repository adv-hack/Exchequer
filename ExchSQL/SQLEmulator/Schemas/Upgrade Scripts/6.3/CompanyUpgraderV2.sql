--/////////////////////////////////////////////////////////////////////////////
--// Filename		: CompanyUpgraderV2.sql
--// Author			: Chris Sandow
--// Date				: 6 October 2009
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2015. All rights reserved.
--// Description		: SQL Script to upgrade table for the 6.3 release
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	6th October 2009:	File Creation - Chris Sandow
--//
--/////////////////////////////////////////////////////////////////////////////

SET NOCOUNT ON

-- First we check to see if one of the new columns exists in table Company
IF EXISTS (
            SELECT  *
            FROM    sysobjects tab 
            WHERE   (tab.id = object_id('common.COMPANY')) 
          )
   AND
   NOT EXISTS (
                 SELECT *
                 FROM   sysobjects tab INNER JOIN
                        syscolumns col ON tab.id = col.id
                 WHERE  (tab.id = object_id('common.COMPANY')) 
                  AND   (col.name = 'hkVersion') 
              ) 
BEGIN
  ALTER TABLE common.COMPANY
  ADD 
    hkVersion int NULL,
    hkEncryptedCode varbinary(17) NULL
END

-- Now we update the Version number for Company_final.xml in the SchemaVersion table
UPDATE    common.SchemaVersion
SET       Version = 2
WHERE     SchemaName = 'Company_Final.xml' AND Version = 1

SET NOCOUNT OFF

