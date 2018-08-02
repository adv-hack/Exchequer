--/////////////////////////////////////////////////////////////////////////////
--// Filename   : CurrencyHistoryCreator.sql
--// Author     : Chris Sandow
--// Date       : 2012-06-18
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2015. All rights reserved.
--// Description    : SQL Script to create table for the 7.0 release
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//  1 18th June 2012:  File Creation - Chris Sandow
--//
--/////////////////////////////////////////////////////////////////////////////

SET NOCOUNT ON

-- Check that table does not already exist.
IF NOT EXISTS (
            SELECT  *
            FROM    sysobjects tab
            WHERE   (tab.id = object_id('[!ActiveSchema!].CurrencyHistory'))
          )
BEGIN
  CREATE TABLE [!ActiveSchema!].[CurrencyHistory](
    [PositionId] [int] IDENTITY(1,1) NOT NULL,
    [chDateChanged] [varchar](8) NOT NULL,
    [chTimeChanged] [varchar](6) NOT NULL,
    [chCurrNumber] [int] NOT NULL,
    [chStopKey] [varchar](1) NOT NULL,
    [chDailyRate] [float] NOT NULL,
    [chCompanyRate] [float] NOT NULL,
    [chInvert] [bit] NOT NULL,
    [chFloat] [bit] NOT NULL,
    [chTriangulationNumber] [int] NOT NULL,
    [chTriangulationRate] [float] NOT NULL,
    [chDescription] [varchar](11) NOT NULL,
    [chSymbolScreen] [varchar](3) NOT NULL,
    [chSymbolPrint] [varchar](3) NOT NULL,
    [chUser] [varchar](10) NOT NULL
  ) ON [PRIMARY]

  -- Create primary index
  CREATE UNIQUE INDEX CurrencyHistory_Index_Identity ON [!ActiveSchema!].CurrencyHistory([PositionId])

  -- Create other indexes
  CREATE UNIQUE INDEX CurrencyHistory_Index0 ON [!ActiveSchema!].CurrencyHistory([chDateChanged], [chTimeChanged], [chCurrNumber], [PositionId])
  CREATE UNIQUE INDEX CurrencyHistory_Index1 ON [!ActiveSchema!].CurrencyHistory([chCurrNumber], [chDateChanged], [chTimeChanged], [PositionId])

END

SET NOCOUNT OFF

