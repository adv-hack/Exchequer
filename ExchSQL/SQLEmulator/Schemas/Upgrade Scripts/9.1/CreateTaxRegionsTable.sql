--/////////////////////////////////////////////////////////////////////////////
--// Filename   : CreateTaxRegionsTable.sql
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
            WHERE   (tab.id = object_id('[!ActiveSchema!].TaxRegions'))
          )
BEGIN
  CREATE TABLE [!ActiveSchema!].[TaxRegions](
    [trID] [int] NOT NULL DEFAULT 0,
    [trName] [varchar](100) NOT NULL DEFAULT CHAR(0),
    [trTaxRegistered] bit NOT NULL DEFAULT 0,
    [trPeriodClosedDate] [varchar](8) NOT NULL DEFAULT CHAR(0),
    [trReportingMonths] int NOT NULL DEFAULT 0,
    [trInputControlCode] [int] NOT NULL DEFAULT 0,
    [trOutputControlCode] [int] NOT NULL DEFAULT 0,
    [trTaxReturnCurrency] int NOT NULL DEFAULT 0,
    [trTaxRegistrationNo] [varchar](50) NOT NULL DEFAULT CHAR(0),
    [trUserField1] [varchar](30) NOT NULL DEFAULT CHAR(0),
    [trUserField2] [varchar](30) NOT NULL DEFAULT CHAR(0),
    [trDateCreated] [datetime] NOT NULL,
    [trDateModified] [datetime] NOT NULL,
    PositionId int IDENTITY(1,1) NOT NULL
  ) ON [PRIMARY]
  
  -- Create main Emulator index
  CREATE UNIQUE INDEX TaxRegions_Index_Identity ON [!ActiveSchema!].TaxRegions(PositionId)

  -- Create other indexes
  CREATE UNIQUE INDEX TaxRegions_Index0 ON [!ActiveSchema!].TaxRegions([trID], [PositionId])
  CREATE UNIQUE INDEX TaxRegions_Index1 ON [!ActiveSchema!].TaxRegions([trName], [PositionId])

END

SET NOCOUNT OFF
