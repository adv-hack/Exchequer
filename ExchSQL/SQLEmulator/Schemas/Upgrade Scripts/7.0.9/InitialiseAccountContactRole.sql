--/////////////////////////////////////////////////////////////////////////////
--// Filename   : InitialiseAccountContactRole.sql
--// Author     : Chris Sandow
--// Date       : 2014-01-20
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2015. All rights reserved.
--// Description    : SQL Script to create table constraints
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//  1 20th January 2014:  File Creation - Chris Sandow
--//  2 31/07/2017: Add DateCreated which was removed from schema (ABSEXCH-16979)
--//
--/////////////////////////////////////////////////////////////////////////////

SET NOCOUNT ON

-- =============================================================================
-- Primary Index
-- =============================================================================
IF NOT EXISTS (
            SELECT  *
            FROM    sysobjects obj
            WHERE   (obj.id = object_id('[!ActiveSchema!].epk_AccountContactRole'))
          )
BEGIN
  ALTER TABLE [!ActiveSchema!].[AccountContactRole] ADD CONSTRAINT [epk_AccountContactRole] PRIMARY KEY CLUSTERED 
  (
    [PositionId] ASC
  ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
END
GO

-- =============================================================================
-- Add DateCreated
-- =============================================================================

IF EXISTS (
            SELECT *
            FROM   sysobjects tab
            WHERE  (tab.id = object_id('[!ActiveSchema!].AccountContactRole'))
          )
   AND
   NOT EXISTS (
                SELECT *
                FROM   sysobjects tab INNER JOIN
                       syscolumns col ON tab.id = col.id
                WHERE  (tab.id = object_id('[!ActiveSchema!].AccountContactRole'))
                 AND   (col.name = 'acrDateCreated')
              )
BEGIN
  ALTER TABLE [!ActiveSchema!].AccountContactRole
  ADD
    acrDateCreated datetime NOT NULL
END
GO


-- =============================================================================
-- Date default
-- =============================================================================
IF NOT EXISTS (
            SELECT  *
            FROM    sysobjects obj
            WHERE   (obj.id = object_id('[!ActiveSchema!].DF_AccountContactRole_acrDateCreated'))
          )
BEGIN
  ALTER TABLE [!ActiveSchema!].[AccountContactRole] ADD  CONSTRAINT [DF_AccountContactRole_acrDateCreated]  DEFAULT (getdate()) FOR [acrDateCreated]
END
GO

-- =============================================================================
-- Foreign Keys
-- =============================================================================
IF NOT EXISTS (
            SELECT  *
            FROM    sysobjects obj
            WHERE   (obj.id = object_id('[!ActiveSchema!].[efk_AccountContact_AccountContactRole]'))
          )
BEGIN
  ALTER TABLE [!ActiveSchema!].[AccountContactRole]  WITH CHECK ADD  CONSTRAINT [efk_AccountContact_AccountContactRole] FOREIGN KEY([acrContactId])
  REFERENCES [!ActiveSchema!].[AccountContact] ([acoContactId])
  ON DELETE CASCADE
  
  ALTER TABLE [!ActiveSchema!].[AccountContactRole] CHECK CONSTRAINT [efk_AccountContact_AccountContactRole]
END  
GO

IF NOT EXISTS (
            SELECT  *
            FROM    sysobjects obj
            WHERE   (obj.id = object_id('[!ActiveSchema!].[efk_ContactRole_AccountContactRole]'))
          )
BEGIN
  ALTER TABLE [!ActiveSchema!].[AccountContactRole]  WITH CHECK ADD  CONSTRAINT [efk_ContactRole_AccountContactRole] FOREIGN KEY([acrRoleId])
  REFERENCES [!ActiveSchema!].[ContactRole] ([crRoleId])

  ALTER TABLE [!ActiveSchema!].[AccountContactRole] CHECK CONSTRAINT [efk_ContactRole_AccountContactRole]
END  
GO


SET NOCOUNT OFF

