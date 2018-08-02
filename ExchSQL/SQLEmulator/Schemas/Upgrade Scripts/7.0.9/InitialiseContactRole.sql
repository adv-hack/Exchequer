--/////////////////////////////////////////////////////////////////////////////
--// Filename   : InitialiseContactRole.sql
--// Author     : Chris Sandow
--// Date       : 2014-01-20
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2015. All rights reserved.
--// Description    : SQL Script to create table constraints
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//  1 20th January 2014:  File Creation - Chris Sandow
--//  2 14th March 2014:    Disable/re-enable foreign key constraints - Chris Sandow
--//  3  4th April 2014:    Use SQL2005-compatible INSERT for ContactRole records - Chris Sandow
--//  4 31/07/2017:         Add DateCreated and DateModified which were removed from schema (ABSEXCH-16979);
--//                        Remove adding constraints
--//
--/////////////////////////////////////////////////////////////////////////////

SET NOCOUNT ON

-- =============================================================================
-- Primary Index
-- =============================================================================
IF NOT EXISTS (
            SELECT  *
            FROM    sysobjects obj
            WHERE   (obj.id = object_id('[!ActiveSchema!].epk_ContactRole'))
          )
BEGIN
  ALTER TABLE [!ActiveSchema!].[ContactRole] ADD CONSTRAINT [epk_ContactRole] PRIMARY KEY CLUSTERED 
  (
    [crRoleId] ASC
  ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
END
GO

-- Temporarily disable foreign key constraints so that we can delete the rows
-- from the ContactRole table
IF EXISTS (
            SELECT  *
            FROM    sysobjects obj
            WHERE   (obj.id = object_id('[!ActiveSchema!].efk_AccountContact_AccountContactRole'))
          )
BEGIN
  ALTER TABLE [!ActiveSchema!].[AccountContactRole] NOCHECK CONSTRAINT [efk_AccountContact_AccountContactRole]
  ALTER TABLE [!ActiveSchema!].[AccountContactRole] NOCHECK CONSTRAINT [efk_ContactRole_AccountContactRole]
END
GO

DELETE FROM [!ActiveSchema!].ContactRole
GO


-- =============================================================================
-- Add DateModified and DateCreated
-- =============================================================================

IF EXISTS (
            SELECT *
            FROM   sysobjects tab
            WHERE  (tab.id = object_id('[!ActiveSchema!].ContactRole'))
          )
   AND
   NOT EXISTS (
                SELECT *
                FROM   sysobjects tab INNER JOIN
                       syscolumns col ON tab.id = col.id
                WHERE  (tab.id = object_id('[!ActiveSchema!].ContactRole'))
                 AND   (col.name = 'crDateCreated')
              )
BEGIN
  ALTER TABLE [!ActiveSchema!].ContactRole
  ADD
    crDateModified datetime NOT NULL,
    crDateCreated datetime NOT NULL
END
GO

-- =============================================================================
-- Date defaults
-- =============================================================================
IF NOT EXISTS (
            SELECT  *
            FROM    sysobjects obj
            WHERE   (obj.id = object_id('[!ActiveSchema!].DF_ContactRole_crDateModified'))
          )
BEGIN
  ALTER TABLE [!ActiveSchema!].[ContactRole] ADD  CONSTRAINT [DF_ContactRole_crDateModified]  DEFAULT (getdate()) FOR [crDateModified]
END
GO

IF NOT EXISTS (
            SELECT  *
            FROM    sysobjects obj
            WHERE   (obj.id = object_id('[!ActiveSchema!].DF_ContactRole_crDateCreated'))
          )
BEGIN
  ALTER TABLE [!ActiveSchema!].[ContactRole] ADD  CONSTRAINT [DF_ContactRole_crDateCreated]  DEFAULT (getdate()) FOR [crDateCreated]
END
GO



-- =============================================================================
-- Regenerate Contact Role Update trigger
-- =============================================================================
DECLARE @SQLString NVARCHAR(MAX)

-- Remove existing trigger, if found
IF EXISTS (
            SELECT  *
            FROM    sysobjects tab
            WHERE   (tab.id = object_id('[!ActiveSchema!].etr_ContactRoleUpdate'))
          )
BEGIN
	SET @SQLString = N'DROP TRIGGER [!ActiveSchema!].etr_ContactRoleUpdate'
	EXEC sp_executesql @SQLString
END

-- Add trigger
IF NOT EXISTS (
            SELECT  *
            FROM    sysobjects tab
            WHERE   (tab.id = object_id('[!ActiveSchema!].etr_ContactRoleUpdate'))
          )
BEGIN
	SET @SQLString = N'
    CREATE TRIGGER [!ActiveSchema!].[etr_ContactRoleUpdate] ON [!ActiveSchema!].[ContactRole]
        FOR UPDATE
    AS
    BEGIN 
      SET NOCOUNT ON;
      BEGIN TRY 
        UPDATE tb 
        SET crDateModified = GETDATE() 
        FROM inserted i 
        JOIN [!ActiveSchema!].[ContactRole] tb ON i.crRoleId = tb.crRoleId
      END TRY 
      BEGIN CATCH 
        ROLLBACK 
      END CATCH 
    END'
	EXEC sp_executesql @SQLString
END

-- =============================================================================
-- Insert data (replace any existing rows)
-- =============================================================================
-- The rows should match the rows that are added by GEUpgrade.DLL, so any
-- changes should be done both here and in GEUpgrade.


INSERT INTO [!ActiveSchema!].[ContactRole]
           ([crRoleId]
           ,[crRoleDescription]
           ,[crRoleAppliesToCustomer]
           ,[crRoleAppliesToSupplier])
SELECT * FROM ( 
   SELECT crRoleId  = 1
        , crRoleDescription = 'General Contact'
        , crRoleAppliesToCustomer = 1
        , crRoleAppliesToSupplier = 1
   UNION
   SELECT crRoleId  = 2
        , crRoleDescription = 'Send Quote'
        , crRoleAppliesToCustomer = 1
        , crRoleAppliesToSupplier = 1
   UNION
   SELECT crRoleId  = 3
        , crRoleDescription = 'Send Order'
        , crRoleAppliesToCustomer = 1
        , crRoleAppliesToSupplier = 1
   UNION
   SELECT crRoleId  = 4
        , crRoleDescription = 'Send Delivery Note'
        , crRoleAppliesToCustomer = 1
        , crRoleAppliesToSupplier = 1
   UNION
   SELECT crRoleId  = 5
        , crRoleDescription = 'Send Invoice'
        , crRoleAppliesToCustomer = 1
        , crRoleAppliesToSupplier = 1
   UNION
   SELECT crRoleId  = 6
        , crRoleDescription = 'Send Receipt'
        , crRoleAppliesToCustomer = 1
        , crRoleAppliesToSupplier = 0
   UNION
   SELECT crRoleId  = 7
        , crRoleDescription = 'Send Remittance'
        , crRoleAppliesToCustomer = 0
        , crRoleAppliesToSupplier = 1
   UNION
   SELECT crRoleId  = 8
        , crRoleDescription = 'Send Statement'
        , crRoleAppliesToCustomer = 1
        , crRoleAppliesToSupplier = 0
   UNION
   SELECT crRoleId  = 9
        , crRoleDescription = 'Send Debt Chase 1'
        , crRoleAppliesToCustomer = 1
        , crRoleAppliesToSupplier = 0
   UNION
   SELECT crRoleId  = 10
        , crRoleDescription = 'Send Debt Chase 2'
        , crRoleAppliesToCustomer = 1
        , crRoleAppliesToSupplier = 0
   UNION
   SELECT crRoleId  = 11
        , crRoleDescription = 'Send Debt Chase 3'
        , crRoleAppliesToCustomer = 1
        , crRoleAppliesToSupplier = 0
   UNION
   SELECT crRoleId  = 12
        , crRoleDescription = 'Credit Card Payment'
        , crRoleAppliesToCustomer = 1
        , crRoleAppliesToSupplier = 0
   UNION
   SELECT crRoleId  = 13
        , crRoleDescription = 'Send Credit Note'
        , crRoleAppliesToCustomer = 1
        , crRoleAppliesToSupplier = 1        
   UNION
   SELECT crRoleId  = 14
        , crRoleDescription = 'Send Receipt with Invoice'
        , crRoleAppliesToCustomer = 1
        , crRoleAppliesToSupplier = 0
   UNION
   SELECT crRoleId  = 15
        , crRoleDescription = 'Send Payment with Invoice'
        , crRoleAppliesToCustomer = 0
        , crRoleAppliesToSupplier = 1
   UNION
   SELECT crRoleId  = 16
        , crRoleDescription = 'Send Journal Invoice'
        , crRoleAppliesToCustomer = 1
        , crRoleAppliesToSupplier = 1
   UNION
   SELECT crRoleId  = 17
        , crRoleDescription = 'Send Journal Credit'
        , crRoleAppliesToCustomer = 1
        , crRoleAppliesToSupplier = 1
   UNION
   SELECT crRoleId  = 18
        , crRoleDescription = 'Send Credit with Refund' 
        , crRoleAppliesToCustomer = 1
        , crRoleAppliesToSupplier = 1
   UNION
   SELECT crRoleId  = 19
        , crRoleDescription = 'Send Return' 
        , crRoleAppliesToCustomer = 1
        , crRoleAppliesToSupplier = 1  		        
) Role
GO

-- Re-enable foreign key constraints
IF EXISTS (
            SELECT  *
            FROM    sysobjects obj
            WHERE   (obj.id = object_id('[!ActiveSchema!].efk_AccountContact_AccountContactRole'))
          )
BEGIN
  ALTER TABLE [!ActiveSchema!].[AccountContactRole] CHECK CONSTRAINT [efk_AccountContact_AccountContactRole]
  ALTER TABLE [!ActiveSchema!].[AccountContactRole] CHECK CONSTRAINT [efk_ContactRole_AccountContactRole]
END
GO

SET NOCOUNT OFF

