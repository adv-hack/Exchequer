--/////////////////////////////////////////////////////////////////////////////
--// Filename		: CustSuppUpgraderV4.sql
--// Author			: Chris Sandow
--// Date				: 22 November 2013
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2015. All rights reserved.
--// Description		: SQL Script to upgrade table for the 7.0.8 release
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	22nd November 2013:	File Creation - Chris Sandow
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
            WHERE  (tab.id = object_id('[!ActiveSchema!].CustSupp'))
          )
   AND
   NOT EXISTS (
                SELECT *
                FROM   sysobjects tab INNER JOIN
                       syscolumns col ON tab.id = col.id
                WHERE  (tab.id = object_id('[!ActiveSchema!].CustSupp'))
                 AND   (col.name = 'acSubType')
              )
BEGIN
  ALTER TABLE [!ActiveSchema!].CustSupp
  ADD
    -- Fields which are in the <fixedfields> section of the XML schema MUST
    -- be specified as NOT NULL, with a DEFAULT.
    acSubType           varchar(1)    NOT NULL DEFAULT CHAR(0),
    acLongAcCode        varchar(30)   NOT NULL DEFAULT CHAR(0)
END
GO

UPDATE [!ActiveSchema!].CUSTSUPP
SET acSubType = acCustSupp
WHERE acSubType = CHAR(0)

-- Add new indexes
IF (SELECT COUNT(sys.indexes.name) FROM sys.indexes INNER JOIN sys.tables ON sys.indexes.object_id = sys.tables.object_id 
WHERE sys.tables.name = 'CustSupp' AND SUBSTRING(sys.indexes.name, 1, 16) = 'CUSTSUPP_Index12') = 0
BEGIN
  CREATE UNIQUE INDEX CUSTSUPP_Index12 ON [!ActiveSchema!].CUSTSUPP(acSubType, acCode, PositionId);
  CREATE UNIQUE INDEX CUSTSUPP_Index13 ON [!ActiveSchema!].CUSTSUPP(acSubType, acLongAcCode, PositionId);
  CREATE UNIQUE INDEX CUSTSUPP_Index14 ON [!ActiveSchema!].CUSTSUPP(acSubType, acCompany, PositionId);
  CREATE UNIQUE INDEX CUSTSUPP_Index15 ON [!ActiveSchema!].CUSTSUPP(acSubType, acAltCode, PositionId);
END

-- Now we update the Version number for the SchemaVersion table
UPDATE    [!ActiveSchema!].SchemaVersion
SET       Version = 4
WHERE     SchemaName = 'CustSupp_Final.xml' AND Version = 3

SET NOCOUNT OFF

