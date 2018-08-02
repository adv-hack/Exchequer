--/////////////////////////////////////////////////////////////////////////////
--// Filename   : InitialiseTaxCodesTable.sql
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
            WHERE   (obj.id = object_id('[!ActiveSchema!].epk_TaxCodes'))
          )
BEGIN
  ALTER TABLE [!ActiveSchema!].[TaxCodes] ADD CONSTRAINT [epk_TaxCodes] PRIMARY KEY CLUSTERED 
  (
    [tcId] ASC
  ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
END
GO

-- =============================================================================
-- Date defaults
-- =============================================================================
IF NOT EXISTS (
            SELECT  *
            FROM    sysobjects obj
            WHERE   (obj.id = object_id('[!ActiveSchema!].DF_TaxCodes_tcDateModified'))
          )
BEGIN
  ALTER TABLE [!ActiveSchema!].[TaxCodes] ADD CONSTRAINT [DF_TaxCodes_tcDateModified] DEFAULT (getdate()) FOR [tcDateModified]
END
GO

IF NOT EXISTS (
            SELECT  *
            FROM    sysobjects obj
            WHERE   (obj.id = object_id('[!ActiveSchema!].DF_TaxCodes_tcDateCreated'))
          )
BEGIN
  ALTER TABLE [!ActiveSchema!].[TaxCodes] ADD CONSTRAINT [DF_TaxCodes_tcDateCreated] DEFAULT (getdate()) FOR [tcDateCreated]
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
            WHERE   (tab.id = object_id('[!ActiveSchema!].etr_TaxCodesUpdate'))
          )
BEGIN
	SET @SQLString = N'DROP TRIGGER [!ActiveSchema!].etr_TaxCodesUpdate'
	EXEC sp_executesql @SQLString
END

-- Add trigger
IF NOT EXISTS (
            SELECT  *
            FROM    sysobjects tab
            WHERE   (tab.id = object_id('[!ActiveSchema!].etr_TaxCodesUpdate'))
          )
BEGIN
	SET @SQLString = N'
		CREATE TRIGGER [!ActiveSchema!].[etr_TaxCodesUpdate]  
			ON  [!ActiveSchema!].[TaxCodes]
			AFTER UPDATE
		AS 
		BEGIN
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;
		BEGIN TRY 
			UPDATE tb 
			SET tcDateModified = GETDATE() 
			FROM inserted i 
			JOIN [!ActiveSchema!].[TaxCodes] tb ON (i.tcId = tb.tcId)
		END TRY 
		BEGIN CATCH 
			ROLLBACK 
		END CATCH 
		END'
	EXEC sp_executesql @SQLString
END

GO

SET NOCOUNT OFF

