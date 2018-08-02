--/////////////////////////////////////////////////////////////////////////////
--// Filename   : CreateRegionTaxCodesTable.sql
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
            WHERE   (tab.id = object_id('[!ActiveSchema!].RegionTaxCodes'))
          )
BEGIN
  CREATE TABLE [!ActiveSchema!].[RegionTaxCodes](
    [rtcRegionID] [int] NOT NULL DEFAULT 0,
    [rtcTaxID] [int] NOT NULL DEFAULT 0,
    [rtcTaxCodeDescription] [varchar](100) NOT NULL DEFAULT CHAR(0),
    [rtcTaxRate] [float] NOT NULL DEFAULT 0,
    [rtcTaxReportingBehaviour] int NOT NULL DEFAULT 0,
    [rtcActive] bit NOT NULL DEFAULT 0,
    [rtcDateCreated] [datetime] NOT NULL,
    [rtcDateModified] [datetime] NOT NULL,
    PositionId int IDENTITY(1,1) NOT NULL
  ) ON [PRIMARY]
  
  -- Create main Emulator index
  CREATE UNIQUE INDEX RegionTaxCodes_Index_Identity ON [!ActiveSchema!].RegionTaxCodes(PositionId)

  -- Create other indexes
  CREATE UNIQUE INDEX RegionTaxCodes_Index0 ON [!ActiveSchema!].RegionTaxCodes([rtcRegionID], [rtcTaxID], [PositionId])
  CREATE UNIQUE INDEX RegionTaxCodes_Index1 ON [!ActiveSchema!].RegionTaxCodes([rtcTaxID], [rtcRegionID], [PositionId])

END

SET NOCOUNT OFF
