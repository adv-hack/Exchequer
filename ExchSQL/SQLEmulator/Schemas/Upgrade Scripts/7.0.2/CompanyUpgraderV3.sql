--/////////////////////////////////////////////////////////////////////////////
--// Filename		: CompanyUpgraderV3.sql
--// Author			: Chris Sandow
--// Date				: 15 January 2013
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2015. All rights reserved.
--// Description		: SQL Script to upgrade table for the 7.0.2 release
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	11th February 2013:	File Creation - Chris Sandow
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
                  AND   (col.name = 'CompExportToAnalytics') 
              ) 
BEGIN
  ALTER TABLE common.COMPANY
  ADD 
    CompExportToAnalytics bit NULL
END

-- Now we update the Version number for Company_final.xml in the SchemaVersion table
UPDATE    common.SchemaVersion
SET       Version = 3
WHERE     SchemaName = 'Company_Final.xml' AND Version = 2

SET NOCOUNT OFF

