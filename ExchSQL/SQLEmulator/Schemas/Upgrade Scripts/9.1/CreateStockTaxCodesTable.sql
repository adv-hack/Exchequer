--/////////////////////////////////////////////////////////////////////////////
--// Filename   : CreateStockTaxCodesTable.sql
--// Author     : Chris Sandow
--// Date       : 2016-03-22
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2016. All rights reserved.
--// Description    : SQL Script to create table for the 9.1 release
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//  1 2016-03-22:  File Creation - Chris Sandow
--//
--/////////////////////////////////////////////////////////////////////////////

SET NOCOUNT ON

-- Check that table does not already exist.
IF NOT EXISTS (
            SELECT  *
            FROM    sysobjects tab
            WHERE   (tab.id = object_id('[!ActiveSchema!].StockTaxCodes'))
          )
BEGIN
  CREATE TABLE [!ActiveSchema!].[StockTaxCodes](
    [stcStockFolio] [int] NOT NULL DEFAULT 0,
    [stcRegionID] [int] NOT NULL DEFAULT 0,
    [stcTaxCode] [varchar](1) NOT NULL DEFAULT CHAR(0),
    [stcInclusive] bit NOT NULL DEFAULT 0,
    [stcDateCreated] [datetime] NOT NULL,
    [stcDateModified] [datetime] NOT NULL,
    PositionId int IDENTITY(1,1) NOT NULL
  ) ON [PRIMARY]
  
  -- Create main Emulator index
  CREATE UNIQUE INDEX StockTaxCodes_Index_Identity ON [!ActiveSchema!].StockTaxCodes(PositionId)

  -- Create other indexes
  CREATE UNIQUE INDEX StockTaxCodes_Index0 ON [!ActiveSchema!].StockTaxCodes([stcStockFolio], [stcRegionID], [PositionId])
  CREATE UNIQUE INDEX StockTaxCodes_Index1 ON [!ActiveSchema!].StockTaxCodes([stcRegionID], [stcTaxCode], [PositionId])

END

SET NOCOUNT OFF
