--/////////////////////////////////////////////////////////////////////////////
--// Filename		    : DetailsCollateUpgraderV11.sql
--// Author			    : Trapti Gupta	
--// Date				: 13 June 2017
--// Copyright  ice	: (c) Advanced Business Software & Solutions Ltd 2016. All rights reserved.
--// Description		: SQL Script to upgrade table for the 9.1 release
SET NOCOUNT ON

--Validating weather the column name and the table name exists or not 

IF  EXISTS (
            SELECT *
            FROM   sysobjects tab
            WHERE  (tab.id = object_id('[!ActiveSchema!].DETAILS'))
          )
	AND  
	EXISTS (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].DETAILS'))
            AND   (col.name = 'tlDescription')
           )   
	AND
	EXISTS (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].DETAILS'))
            AND   (col.name = 'tlUserField1')
           )	
    AND
	EXISTS (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].DETAILS'))
            AND   (col.name = 'tlUserField2')
           )	
    AND
	EXISTS (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].DETAILS'))
            AND   (col.name = 'tlUserField3')
           )	
	AND
	EXISTS (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].DETAILS'))
            AND   (col.name = 'tlUserField4')
           )	
	AND
	EXISTS (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].DETAILS'))
            AND   (col.name = 'tlUserField5')
           )
	AND
	EXISTS (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].DETAILS'))
            AND   (col.name = 'tlUserField6')
           )
	AND
	EXISTS (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].DETAILS'))
            AND   (col.name = 'tlUserField7')
           )
    AND
	EXISTS (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].DETAILS'))
            AND   (col.name = 'tlUserField8')
           )
    AND
	EXISTS (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].DETAILS'))
            AND   (col.name = 'tlUserField9')
           )
    AND
	EXISTS (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].DETAILS'))
            AND   (col.name = 'tlUserField10')
           )
    
    
BEGIN

	-- Dropping the indexes over tlDescription
	DROP INDEX DETAILS_Index10_Report_GLPrePosting
    ON [!ActiveSchema!].[DETAILS]; 
	DROP INDEX DETAILS_Index11_CheckAllAccounts
    ON [!ActiveSchema!].[DETAILS];
	
	-- ALtering the columns 
	--Altering All the columns so to be collated SQL_Latin1_General_CP1_CI_AS
    --CP1 - Codepage 1
    --CI - Case Insensitive
    --AS - Accent Sensitive.
    ALTER TABLE [!ActiveSchema!].[DETAILS] ALTER COLUMN tlDescription varchar(60) COLLATE SQL_Latin1_General_CP1_CI_AS
	ALTER TABLE [!ActiveSchema!].[DETAILS] ALTER COLUMN tlUserField1 varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS
	ALTER TABLE [!ActiveSchema!].[DETAILS] ALTER COLUMN tlUserField2 varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS
	ALTER TABLE [!ActiveSchema!].[DETAILS] ALTER COLUMN tlUserField3 varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS
	ALTER TABLE [!ActiveSchema!].[DETAILS] ALTER COLUMN tlUserField4 varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS
	ALTER TABLE [!ActiveSchema!].[DETAILS] ALTER COLUMN tlUserField5 varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS
	ALTER TABLE [!ActiveSchema!].[DETAILS] ALTER COLUMN tlUserField6 varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS
	ALTER TABLE [!ActiveSchema!].[DETAILS] ALTER COLUMN tlUserField7 varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS
	ALTER TABLE [!ActiveSchema!].[DETAILS] ALTER COLUMN tlUserField8 varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS
	ALTER TABLE [!ActiveSchema!].[DETAILS] ALTER COLUMN tlUserField9 varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS
	ALTER TABLE [!ActiveSchema!].[DETAILS] ALTER COLUMN tlUserField10 varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS
	
	-- Re-creating the columns when all the columns are altered
	-- Re-creating DETAILS_Index10_Report_GLPrePosting
	CREATE NONCLUSTERED INDEX [DETAILS_Index10_Report_GLPrePosting] ON [!ActiveSchema!].[DETAILS]
	(
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
	
	-- Re-creating DETAILS_Index11_CheckAllAccounts
	CREATE NONCLUSTERED INDEX [DETAILS_Index11_CheckAllAccounts] ON [!ActiveSchema!].[DETAILS]
	(
	[tlFolioNum] ASC,
	[tlGLCode] ASC
	)
	INCLUDE 
	(  
		[tlRunNo],
		[tlCurrency],
		[tlYear],
		[tlPeriod],
		[tlDepartment],
		[tlCostCentre],
		[tlDocType],
		[tlQty],
		[tlQtyMul],
		[tlNetValue],
		[tlDiscount],
		[tlVATCode],
		[tlPaymentCode],
		[tlDiscFlag],
		[tlAcCode],
		[tlLineDate],
		[tlDescription],
		[tlCompanyRate],
		[tlDailyRate],
		[tlUsePack],
		[tlOurRef],
		[tlPrxPack],
		[tlQtyPack],
		[tlShowCase],
		[tlUseOriginalRates],
		[tlPriceMultiplier],
		[tlVATIncValue],
		[tlDiscount2],
		[tlDiscount2Chr],
		[tlDiscount3],
		[tlDiscount3Chr]
	) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

END 

-- Now we update the Version number for the SchemaVersion table
UPDATE    [!ActiveSchema!].SchemaVersion
SET       Version = 11
WHERE     SchemaName = 'Details_final.xml' AND Version = 10


SET NOCOUNT OFF
