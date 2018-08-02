--/////////////////////////////////////////////////////////////////////////////
--// Filename		: ExchqChkUpgraderV3.sql
--// Author		: Chris Sandow
--// Date		: 6 May 2015
--// Copyright Notice	: (c) 2015 Advanced Business Software & Solutions Ltd. All rights reserved.
--// Description	: SQL Script to update the table structure for 7.0.14
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	6th May 2015:	File Creation - Chris Sandow
--//
--/////////////////////////////////////////////////////////////////////////////

SET NOCOUNT ON

-- First we check to see if the new column exists in table
IF EXISTS (
            SELECT  *
            FROM    sysobjects tab 
            WHERE   (tab.id = object_id('[!ActiveSchema!].EXCHQCHK')) 
          )
   AND
   NOT EXISTS (
                 SELECT *
                 FROM   sysobjects tab INNER JOIN
                        syscolumns col ON tab.id = col.id
                 WHERE  (tab.id = object_id('[!ActiveSchema!].EXCHQCHK')) 
                  AND   (col.name = 'ApplyPPD') 
              ) 
BEGIN
  ALTER TABLE [!ActiveSchema!].EXCHQCHK
  ADD 
    ApplyPPD bit NULL,
    IntendedPaymentDate varchar(8) NULL,
    PPDExpiryToleranceDays int NULL
END

-- Now we update the Version number in the SchemaVersion table
UPDATE    [!ActiveSchema!].SchemaVersion
SET       Version = 3
WHERE     SchemaName = 'EXCHQCHK_Final.xml' AND Version = 2

SET NOCOUNT OFF