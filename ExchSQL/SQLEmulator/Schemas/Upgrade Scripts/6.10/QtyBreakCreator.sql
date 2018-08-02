--/////////////////////////////////////////////////////////////////////////////
--// Filename   : QtyBreakCreator.sql
--// Author     : Chris Sandow
--// Date       : 20 February 2012
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2015. All rights reserved.
--// Description    : SQL Script to create table for the 6.10 release
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//  1 20th February 2012:  File Creation - Chris Sandow
--//
--/////////////////////////////////////////////////////////////////////////////

SET NOCOUNT ON

-- Check that table does not already exist.
IF NOT EXISTS (
            SELECT  *
            FROM    sysobjects tab
            WHERE   (tab.id = object_id('[!ActiveSchema!].QTYBREAK'))
          )
BEGIN
  CREATE TABLE [!ActiveSchema!].[QTYBREAK](
    [qbFolio] [int] NOT NULL,
    [qbAcCode] [varchar](6) NOT NULL,
    [qbStockFolio] [int] NOT NULL,
    [qbCurrency] [int] NOT NULL,
    [qbStartDate] [varchar](8) NOT NULL,
    [qbEndDate] [varchar](8) NOT NULL,
    [qbQtyToString] [varchar](16) NOT NULL,
    [qbQtyTo] [float] NOT NULL,
    [qbQtyFrom] [float] NOT NULL,
    [qbBreakType] [int] NOT NULL,
    [qbPriceBand] [varchar](1) NOT NULL,
    [qbSpecialPrice] [float] NOT NULL,
    [qbDiscountPercent] [float] NOT NULL,
    [qbDiscountAmount] [float] NOT NULL,
    [qbMarginOrMarkup] [float] NOT NULL,
    [qbUseDates] [bit] NOT NULL,
    [PositionId] [int] IDENTITY(1,1) NOT NULL
  ) ON [PRIMARY]
  -- Create primary index
  CREATE UNIQUE INDEX QTYBREAK_Index_Identity ON [!ActiveSchema!].QTYBREAK(PositionId)
  -- Create other indexes
  CREATE UNIQUE INDEX QTYBREAK_Index0 ON [!ActiveSchema!].QTYBREAK([qbAcCode], [qbStockFolio], [qbCurrency], [qbStartDate], [qbEndDate], [qbQtyToString], [PositionId])
  CREATE UNIQUE NONCLUSTERED INDEX QTYBREAK_Index1 ON [!ActiveSchema!].QTYBREAK([qbFolio], [qbQtyToString], [PositionId])
END

SET NOCOUNT OFF

