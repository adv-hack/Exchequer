--/////////////////////////////////////////////////////////////////////////////
--// Filename   : GLBudgetHistoryCreator.sql
--// Author     : Chris Sandow
--// Date       : 2012-06-20
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2015. All rights reserved.
--// Description    : SQL Script to create table for the 7.0 release
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//  1 20th June 2012:  File Creation - Chris Sandow
--//
--/////////////////////////////////////////////////////////////////////////////

SET NOCOUNT ON

-- Check that table does not already exist.
IF NOT EXISTS (
            SELECT  *
            FROM    sysobjects tab
            WHERE   (tab.id = object_id('[!ActiveSchema!].GLBudgetHistory'))
          )
BEGIN
  CREATE TABLE [!ActiveSchema!].[GLBudgetHistory](
    [PositionId] [int] IDENTITY(1,1) NOT NULL,
    [bhGLCode] [int] NOT NULL,
    [bhYear] [int] NOT NULL,
    [bhPeriod] [int] NOT NULL,
    [bhCurrency] [int] NOT NULL,
    [bhDateChanged] [varchar](8) NOT NULL,
    [bhTimeChanged] [varchar](6) NOT NULL,
    [bhValue] [float] NOT NULL,
    [bhChange] [float] NOT NULL,
    [bhUser] [varchar](10) NOT NULL
  ) ON [PRIMARY]

  -- Create primary index
  CREATE UNIQUE INDEX GLBudgetHistory_Index_Identity ON [!ActiveSchema!].GLBudgetHistory([PositionId])

  -- Create other indexes
  CREATE UNIQUE INDEX GLBudgetHistory_Index0 ON [!ActiveSchema!].GLBudgetHistory([bhGLCode], [bhCurrency], [bhYear], [bhPeriod], [bhDateChanged], [bhTimeChanged], [PositionId])

END

SET NOCOUNT OFF

