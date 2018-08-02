--/////////////////////////////////////////////////////////////////////////////
--// Filename   : CreateVAT100.sql
--// Author     : Chris Sandow
--// Date       : 2015-06-08
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2015. All rights reserved.
--// Description    : SQL Script to create table for the 7.0.14 release
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//  1 8th June 2014:  File Creation - Chris Sandow
--//
--/////////////////////////////////////////////////////////////////////////////

SET NOCOUNT ON

-- Check that table does not already exist.
IF NOT EXISTS (
            SELECT  *
            FROM    sysobjects tab
            WHERE   (tab.id = object_id('[!ActiveSchema!].VAT100'))
          )
BEGIN
  CREATE TABLE [!ActiveSchema!].[VAT100](
    [vatCorrelationId]          [varchar](40)       NOT NULL,
    [vatIRMark]                 [varchar](40)       NOT NULL,
    [vatDateSubmitted]          [varchar](16)       NOT NULL,
    [vatDocumentType]           [varchar](10)       NOT NULL,
    [vatPeriod]                 [varchar](10)       NOT NULL,
    [vatUsername]               [varchar](255)      NOT NULL,
    [vatStatus]                 [int]               NOT NULL,
    [vatPollingInterval]        [int]               NOT NULL DEFAULT 600000,
    [vatDueOnOutputs]           [float]             NOT NULL,
    [vatDueOnECAcquisitions]    [float]             NOT NULL,
    [vatTotal]                  [float]             NOT NULL,
    [vatReclaimedOnInputs]      [float]             NOT NULL,
    [vatNet]                    [float]             NOT NULL,
    [vatNetSalesAndOutputs]     [float]             NOT NULL,
    [vatNetPurchasesAndInputs]  [float]             NOT NULL,
    [vatNetECSupplies]          [float]             NOT NULL,
    [vatNetECAcquisitions]      [float]             NOT NULL,
    [vatHMRCNarrative]          [varbinary](2048)   NOT NULL,
    [vatNotifyEmail]            [varchar](255)      NOT NULL,
    [vatPollingURL]             [varchar](255)      NOT NULL,
    [vatDateModified]           [datetime]          NULL,
    [vatDateCreated]            [datetime]          NULL,
    [PositionId]                [int] IDENTITY(1,1) NOT NULL
  ) ON [PRIMARY]
  
  -- Create main Emulator index
  CREATE UNIQUE INDEX VAT100_Index_Identity ON [!ActiveSchema!].VAT100(PositionId)

  CREATE UNIQUE INDEX VAT100_Index0 ON [!ActiveSchema!].VAT100([vatCorrelationId], [PositionId])
  
END
GO

-- =============================================================================
-- Date defaults
-- =============================================================================
IF NOT EXISTS (
            SELECT  *
            FROM    sysobjects obj
            WHERE   (obj.id = object_id('[!ActiveSchema!].DF_VAT100_vatDateModified'))
          )
BEGIN
  ALTER TABLE [!ActiveSchema!].[VAT100] ADD CONSTRAINT [DF_VAT100_vatDateModified] DEFAULT (getdate()) FOR [vatDateModified]
END
GO

IF NOT EXISTS (
            SELECT  *
            FROM    sysobjects obj
            WHERE   (obj.id = object_id('[!ActiveSchema!].DF_VAT100_vatDateCreated'))
          )
BEGIN
  ALTER TABLE [!ActiveSchema!].[VAT100] ADD CONSTRAINT [DF_VAT100_vatDateCreated] DEFAULT (getdate()) FOR [vatDateCreated]
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
            WHERE   (tab.id = object_id('[!ActiveSchema!].etr_VAT100Update'))
          )
BEGIN
	SET @SQLString = N'DROP TRIGGER [!ActiveSchema!].etr_VAT100Update'
	EXEC sp_executesql @SQLString
END

-- Add trigger
IF NOT EXISTS (
            SELECT  *
            FROM    sysobjects tab
            WHERE   (tab.id = object_id('[!ActiveSchema!].etr_VAT100Update'))
          )
BEGIN
	SET @SQLString = N'
		CREATE TRIGGER [!ActiveSchema!].[etr_VAT100Update]  
			ON  [!ActiveSchema!].[VAT100]
			AFTER UPDATE
		AS 
		BEGIN
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;
		BEGIN TRY 
			UPDATE tb 
			SET vatDateModified = GETDATE() 
			FROM inserted i 
			JOIN [!ActiveSchema!].[VAT100] tb ON i.vatCorrelationId = tb.vatCorrelationId
		END TRY 
		BEGIN CATCH 
			ROLLBACK 
		END CATCH 
		END'
	EXEC sp_executesql @SQLString
END

SET NOCOUNT OFF
