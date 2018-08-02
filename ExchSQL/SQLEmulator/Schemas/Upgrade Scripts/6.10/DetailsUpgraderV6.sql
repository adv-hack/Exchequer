--/////////////////////////////////////////////////////////////////////////////
--// Filename		: DETAILSUpgraderV6.sql
--// Author			: Chris Sandow
--// Date				: 2012-03-06
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2015. All rights reserved.
--// Description		: SQL Script to upgrade table for the 6.10 release
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	2012-03-06:	File Creation - Chris Sandow
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
            WHERE  (tab.id = object_id('[!ActiveSchema!].DETAILS'))
          )
   AND
   NOT EXISTS (
                SELECT *
                FROM   sysobjects tab INNER JOIN
                       syscolumns col ON tab.id = col.id
                WHERE  (tab.id = object_id('[!ActiveSchema!].DETAILS'))
                 AND   (col.name = 'tlThresholdCode')
              )
BEGIN
  ALTER TABLE [!ActiveSchema!].DETAILS
  ADD
    -- Fields which are in the <fixedfields> section of the XML schema MUST
    -- be specified as NOT NULL, with a DEFAULT.
    --
    -- Fields which are in the <recordtype> sections of the XML schema MUST be
    -- specified as NULL (to allow null values).
    tlThresholdCode varchar(12) NOT NULL DEFAULT CHAR(0)
END
GO

IF EXISTS (
            SELECT *
            FROM   sysobjects tab
            WHERE  (tab.id = object_id('[!ActiveSchema!].EBUSDETL'))
          )
   AND
   NOT EXISTS (
                SELECT *
                FROM   sysobjects tab INNER JOIN
                       syscolumns col ON tab.id = col.id
                WHERE  (tab.id = object_id('[!ActiveSchema!].EBUSDETL'))
                 AND   (col.name = 'tlThresholdCode')
              )
BEGIN
  ALTER TABLE [!ActiveSchema!].EBUSDETL
  ADD
    -- Fields which are in the <fixedfields> section of the XML schema MUST
    -- be specified as NOT NULL, with a DEFAULT.
    --
    -- Fields which are in the <recordtype> sections of the XML schema MUST be
    -- specified as NULL (to allow null values).
    tlThresholdCode varchar(12) NOT NULL DEFAULT CHAR(0)
END
GO

IF EXISTS (
            SELECT *
            FROM   sysobjects tab
            WHERE  (tab.id = object_id('[!ActiveSchema!].EBUSDETL'))
          )
   AND
   NOT EXISTS (
                SELECT *
                FROM   sysobjects tab INNER JOIN
                       syscolumns col ON tab.id = col.id
                WHERE  (tab.id = object_id('[!ActiveSchema!].EBUSDETL'))
                 AND   (col.name = 'tlUserField5')
              )
BEGIN
  ALTER TABLE [!ActiveSchema!].EBUSDETL
  ADD
    -- Fields which are in the <fixedfields> section of the XML schema MUST
    -- be specified as NOT NULL, with a DEFAULT.
    --
    -- Fields which are in the <recordtype> sections of the XML schema MUST be
    -- specified as NULL (to allow null values).
    tlUserField5  varchar(30) NOT NULL DEFAULT CHAR(0),
    tlUserField6  varchar(30) NOT NULL DEFAULT CHAR(0),
    tlUserField7  varchar(30) NOT NULL DEFAULT CHAR(0),
    tlUserField8  varchar(30) NOT NULL DEFAULT CHAR(0),
    tlUserField9  varchar(30) NOT NULL DEFAULT CHAR(0),
    tlUserField10 varchar(30) NOT NULL DEFAULT CHAR(0)
END
GO

-- Create the new index (for Check All Accounts performance)
DECLARE @table_id INT
SET @table_id = object_id('[!ActiveSchema!].[DETAILS]')

IF NOT EXISTS (
	SELECT name FROM sys.indexes
	WHERE object_id = @table_id
	  AND name = 'DETAILS_Index11_CheckAllAccounts'
)
BEGIN
	CREATE NONCLUSTERED INDEX DETAILS_Index11_CheckAllAccounts
	ON [!ActiveSchema!].[DETAILS] ([tlFolioNum],[tlGLCode])
	INCLUDE ([tlRunNo],[tlCurrency],[tlYear],[tlPeriod],[tlDepartment],[tlCostCentre],[tlDocType],[tlQty],[tlQtyMul],[tlNetValue],[tlDiscount],[tlVATCode],[tlPaymentCode],[tlDiscFlag],[tlAcCode],[tlLineDate],[tlDescription],[tlCompanyRate],[tlDailyRate],[tlUsePack],[tlOurRef],[tlPrxPack],[tlQtyPack],[tlShowCase],[tlUseOriginalRates],[tlPriceMultiplier],[tlVATIncValue],[tlDiscount2],[tlDiscount2Chr],[tlDiscount3],[tlDiscount3Chr])
END
GO

-- Now update the Version number for the SchemaVersion table
UPDATE    [!ActiveSchema!].SchemaVersion
SET       Version = 6
WHERE     SchemaName = 'DETAILS_Final.xml' AND Version = 5

SET NOCOUNT OFF

