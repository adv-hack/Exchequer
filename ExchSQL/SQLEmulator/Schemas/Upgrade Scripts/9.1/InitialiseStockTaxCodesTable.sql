--/////////////////////////////////////////////////////////////////////////////
--// Filename   : InitialiseStockTaxCodesTable.sql
--// Author     : Chris Sandow
--// Date       : 2016-04-12
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2016. All rights reserved.
--// Description    : SQL Script to create table constraints
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//  1 12th April 2014:  File Creation - Chris Sandow
--//
--/////////////////////////////////////////////////////////////////////////////

SET NOCOUNT ON

-- =============================================================================
-- Primary Index
-- =============================================================================
IF NOT EXISTS (
            SELECT  *
            FROM    sysobjects obj
            WHERE   (obj.id = object_id('[!ActiveSchema!].epk_StockTaxCodes'))
          )
BEGIN
  ALTER TABLE [!ActiveSchema!].[StockTaxCodes] ADD CONSTRAINT [epk_StockTaxCodes] PRIMARY KEY CLUSTERED 
  (
    [stcStockFolio] ASC, [stcRegionId] ASC, [stcTaxCode] ASC
  ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
END
GO

-- =============================================================================
-- Date defaults
-- =============================================================================
IF NOT EXISTS (
            SELECT  *
            FROM    sysobjects obj
            WHERE   (obj.id = object_id('[!ActiveSchema!].DF_StockTaxCodes_stcDateModified'))
          )
BEGIN
  ALTER TABLE [!ActiveSchema!].[StockTaxCodes] ADD CONSTRAINT [DF_StockTaxCodes_stcDateModified] DEFAULT (getdate()) FOR [stcDateModified]
END
GO

IF NOT EXISTS (
            SELECT  *
            FROM    sysobjects obj
            WHERE   (obj.id = object_id('[!ActiveSchema!].DF_StockTaxCodes_stcDateCreated'))
          )
BEGIN
  ALTER TABLE [!ActiveSchema!].[StockTaxCodes] ADD CONSTRAINT [DF_StockTaxCodes_stcDateCreated] DEFAULT (getdate()) FOR [stcDateCreated]
END
GO

-- =============================================================================
-- Regenerate Update trigger
-- =============================================================================
DECLARE @SQLString NVARCHAR(MAX)

-- Remove existing trigger, if found
IF EXISTS (
            SELECT  *
            FROM    sysobjects tab
            WHERE   (tab.id = object_id('[!ActiveSchema!].etr_StockTaxCodesUpdate'))
          )
BEGIN
	SET @SQLString = N'DROP TRIGGER [!ActiveSchema!].etr_StockTaxCodesUpdate'
	EXEC sp_executesql @SQLString
END

-- Add trigger
IF NOT EXISTS (
            SELECT  *
            FROM    sysobjects tab
            WHERE   (tab.id = object_id('[!ActiveSchema!].etr_StockTaxCodesUpdate'))
          )
BEGIN
	SET @SQLString = N'
		CREATE TRIGGER [!ActiveSchema!].[etr_StockTaxCodesUpdate]  
			ON  [!ActiveSchema!].[StockTaxCodes]
			AFTER UPDATE
		AS 
		BEGIN
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;
		BEGIN TRY 
			UPDATE tb 
			SET stcDateModified = GETDATE() 
			FROM inserted i 
			JOIN [!ActiveSchema!].[StockTaxCodes] tb ON (i.stcStockFolio = tb.stcStockFolio) AND (i.stcRegionId = tb.stcRegionId) AND (i.stcTaxCode = tb.stcTaxCode)
		END TRY 
		BEGIN CATCH 
			ROLLBACK 
		END CATCH 
		END'
	EXEC sp_executesql @SQLString
END

GO

SET NOCOUNT OFF

