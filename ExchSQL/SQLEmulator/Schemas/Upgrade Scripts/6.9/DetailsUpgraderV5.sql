--/////////////////////////////////////////////////////////////////////////////
--// Filename		: DETAILSUpgraderV5.sql
--// Author			: Chris Sandow / Simon Molloy
--// Date				: 2011-09-30
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2015. All rights reserved.
--// Description		: SQL Script to upgrade table for the 6.9 release
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	2011-09-30:	File Creation - Chris Sandow
--//  2 2011-11-01: Added new index - Simon Molloy / Chris Sandow
--//  3 2011-12-08: Adde new field to index - Simon Molloy / Chris Sandow
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
                 AND   (col.name = 'tlUserField5')
              )
BEGIN
  ALTER TABLE [!ActiveSchema!].DETAILS
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

-- Now create the index
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[DETAILS]') AND name = N'DETAILS_Index10_Report_GLPrePosting')
	CREATE NONCLUSTERED INDEX [DETAILS_Index10_Report_GLPrePosting] ON [!ActiveSchema!].[DETAILS]
	(
		-- The field coverage and order is optimal across all datasets tested. Certain datasets consider FolioNum
		-- appearing ahead of GLCode sub-optimal, though these seem to be the smaller ones where performance
		-- is perfectly fine anyway. For the larger datasets GLCode before FolioNum can be seriously sub-optimal
		[tlRunNo] ASC,
		[tlFolioNum] ASC,
		[tlGLCode] ASC
	)
	INCLUDE
	(
		[tlCurrency],
		[tlYear],
		[tlPeriod],
		[tlDepartment],
		[tlCostCentre],
		[tlDocType],
		[tlQty],
		[tlQtyMul],
		[tlUsePack],
		[tlPrxPack],
		[tlShowCase],
		[tlAcCode],
		[tlDescription],
		[tlNetValue],
		[tlDiscount],
		[tlDiscFlag],
		[tlCompanyRate],
		[tlDailyRate],
		[tlUseOriginalRates],
		[tlOurRef],
		[tlQtyPack],
		[tlDiscount2],
		[tlDiscount2Chr],
		[tlDiscount3],
		[tlDiscount3Chr],
		[tlPaymentCode],
		[tlLineDate],
		[tlJobCode],
		[tlAnalysisCode],
		[tlPriceMultiplier],
		[tlPreviousBalance],
		[PositionId]
	) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
GO

-- Now we update the Version number for the SchemaVersion table
UPDATE    [!ActiveSchema!].SchemaVersion
SET       Version = 5
WHERE     SchemaName = 'DETAILS_Final.xml' AND Version = 4

SET NOCOUNT OFF

