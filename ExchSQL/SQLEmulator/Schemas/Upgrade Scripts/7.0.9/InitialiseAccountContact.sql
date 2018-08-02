--/////////////////////////////////////////////////////////////////////////////
--// Filename   : InitialiseAccountContact.sql
--// Author     : Chris Sandow
--// Date       : 2014-01-20
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2015. All rights reserved.
--// Description    : SQL Script to create table constraints
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//  1 20th January 2014:  File Creation - Chris Sandow
--//  2 31/07/2017: Add DateCreated and DateModified which were removed from schema (ABSEXCH-16979)
--//
--/////////////////////////////////////////////////////////////////////////////

SET NOCOUNT ON

-- =============================================================================
-- Primary Index
-- =============================================================================
IF NOT EXISTS (
            SELECT  *
            FROM    sysobjects obj
            WHERE   (obj.id = object_id('[!ActiveSchema!].epk_AccountContact'))
          )
BEGIN
  ALTER TABLE [!ActiveSchema!].[AccountContact] ADD CONSTRAINT [epk_AccountContact] PRIMARY KEY CLUSTERED 
  (
    [acoContactId] ASC
  ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
END
GO

-- =============================================================================
-- Add DateModified and DateCreated
-- =============================================================================

IF EXISTS (
            SELECT *
            FROM   sysobjects tab
            WHERE  (tab.id = object_id('[!ActiveSchema!].AccountContact'))
          )
   AND
   NOT EXISTS (
                SELECT *
                FROM   sysobjects tab INNER JOIN
                       syscolumns col ON tab.id = col.id
                WHERE  (tab.id = object_id('[!ActiveSchema!].AccountContact'))
                 AND   (col.name = 'acoDateCreated')
              )
BEGIN
  ALTER TABLE [!ActiveSchema!].AccountContact
  ADD
    acoDateModified datetime NOT NULL,
    acoDateCreated datetime NOT NULL
END
GO


-- =============================================================================
-- Date defaults
-- =============================================================================
IF NOT EXISTS (
            SELECT  *
            FROM    sysobjects obj
            WHERE   (obj.id = object_id('[!ActiveSchema!].DF_AccountContact_modifiedDate'))
          )
BEGIN
  ALTER TABLE [!ActiveSchema!].[AccountContact] ADD CONSTRAINT [DF_AccountContact_modifiedDate] DEFAULT (getdate()) FOR [acoDateModified]
END
GO

IF NOT EXISTS (
            SELECT  *
            FROM    sysobjects obj
            WHERE   (obj.id = object_id('[!ActiveSchema!].DF_AccountContact_acoDateCreated'))
          )
BEGIN
  ALTER TABLE [!ActiveSchema!].[AccountContact] ADD CONSTRAINT [DF_AccountContact_acoDateCreated] DEFAULT (getdate()) FOR [acoDateCreated]
END
GO

-- =============================================================================
-- Foreign Key into CustSupp table
-- =============================================================================
IF NOT EXISTS (
            SELECT  *
            FROM    sysobjects obj
            WHERE   (obj.id = object_id('[!ActiveSchema!].efk_CUSTSUPP_AccountContact'))
          )
BEGIN
  ALTER TABLE [!ActiveSchema!].[AccountContact] WITH CHECK ADD CONSTRAINT [efk_CUSTSUPP_AccountContact] FOREIGN KEY([acoAccountCode])
  REFERENCES [!ActiveSchema!].[CUSTSUPP] ([acCode])
  ON UPDATE CASCADE
  ON DELETE CASCADE
  
  ALTER TABLE [!ActiveSchema!].[AccountContact] CHECK CONSTRAINT [efk_CUSTSUPP_AccountContact]
END  
GO

-- =============================================================================
-- Regenerate Contact Update and Insert triggers
-- =============================================================================
DECLARE @SQLString NVARCHAR(MAX)

-- Remove existing trigger, if found
IF EXISTS (
            SELECT  *
            FROM    sysobjects tab
            WHERE   (tab.id = object_id('[!ActiveSchema!].etr_AccountContactUpdate'))
          )
BEGIN
	SET @SQLString = N'DROP TRIGGER [!ActiveSchema!].etr_AccountContactUpdate'
	EXEC sp_executesql @SQLString
END

-- Add trigger
IF NOT EXISTS (
            SELECT  *
            FROM    sysobjects tab
            WHERE   (tab.id = object_id('[!ActiveSchema!].etr_AccountContactUpdate'))
          )
BEGIN
	SET @SQLString = N'
		CREATE TRIGGER [!ActiveSchema!].[etr_AccountContactUpdate]  
			ON  [!ActiveSchema!].[AccountContact]
			AFTER UPDATE
		AS 
		BEGIN
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;
		BEGIN TRY 
			UPDATE tb 
			SET acoDateModified = GETDATE() 
			FROM inserted i 
			JOIN [!ActiveSchema!].[AccountContact] tb ON i.acoContactId = tb.acoContactId
		END TRY 
		BEGIN CATCH 
			ROLLBACK 
		END CATCH 
		END'
	EXEC sp_executesql @SQLString
END

-- Remove existing trigger, if found
IF EXISTS (
            SELECT  *
            FROM    sysobjects tab
            WHERE   (tab.id = object_id('[!ActiveSchema!].etr_AccountContactInsert'))
          )
BEGIN
	SET @SQLString = N'DROP TRIGGER [!ActiveSchema!].etr_AccountContactInsert'
	EXEC sp_executesql @SQLString
END

IF NOT EXISTS (
            SELECT  *
            FROM    sysobjects tab
            WHERE   (tab.id = object_id('[!ActiveSchema!].etr_AccountContactInsert'))
          )
BEGIN
	SET @SQLString = N'
    CREATE TRIGGER [!ActiveSchema!].etr_AccountContactInsert ON [!ActiveSchema!].AccountContact
    FOR INSERT
    AS
    BEGIN
      -- Maintain the acoContactId column
      BEGIN TRY
        UPDATE AC
        SET    acoContactId = i.PositionId
        FROM   [!ActiveSchema!].AccountContact AC
        JOIN   inserted i ON AC.PositionId = i.PositionId
      END TRY
      BEGIN CATCH 
        ROLLBACK 
      END CATCH 
    END'
	EXEC sp_executesql @SQLString
END

GO

SET NOCOUNT OFF

