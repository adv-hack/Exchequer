--/////////////////////////////////////////////////////////////////////////////
--// Filename		: MultiBuyCreate.sql
--// Author		: Chris Sandow
--// Date		: 12th May 2009
--// Copyright Notice	: (c) 2015 Advanced Business Software & Solutions Ltd. All rights reserved.
--// Description	: SQL Script to create table for the 6.01 release
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	12th May 2009:	File Creation - Chris Sandow
--/////////////////////////////////////////////////////////////////////////////

-- Check to see if the MULTIBUY table exists
IF NOT EXISTS 
(
  SELECT  *
  FROM    sysobjects tab 
  WHERE   (tab.id = object_id('[!ActiveSchema!].MULTIBUY')) 
)
BEGIN
  CREATE TABLE [!ActiveSchema!].MULTIBUY (
    [mbdOwnerType] [char] NOT NULL,
    [mbdAcCode] [varchar](6) NOT NULL,
    [mbdStockCode] [varchar](16) NOT NULL,
    [mbdBuyQtyString] [varchar](20) NOT NULL,
    [mbdCurrency] [int] NOT NULL,
    [mbdDiscountType] [char] NOT NULL,
    [mbdStartDate] [varchar](8) NOT NULL,
    [mbdEndDate] [varchar](8) NOT NULL,
    [mbdUseDates] [bit] NOT NULL,
    [mbdBuyQty] [float] NOT NULL,
    [mbdRewardValue] [float] NOT NULL,
    [PositionId] [int] IDENTITY(1,1) NOT NULL
  ) ON [PRIMARY]
  
	CREATE UNIQUE INDEX [MULTIBUY_Index_Identity] ON [!ActiveSchema!].[MULTIBUY] 
	(
		[PositionId] ASC
	)WITH 
	(
		PAD_INDEX  = OFF,
    FILLFACTOR = 90, 
		SORT_IN_TEMPDB = OFF, 
		DROP_EXISTING = OFF, 
		IGNORE_DUP_KEY = OFF, 
		ONLINE = OFF
	) ON [PRIMARY]
  
	CREATE INDEX [MULTIBUY_Index0] ON [!ActiveSchema!].[MULTIBUY] 
	(
		[mbdAcCode] ASC,
		[mbdStockCode] ASC,
		[mbdBuyQtyString] ASC,
		[mbdCurrency] ASC,
		[mbdDiscountType] ASC
	)WITH 
	(
		PAD_INDEX  = OFF,
    FILLFACTOR = 90, 
		SORT_IN_TEMPDB = OFF, 
		DROP_EXISTING = OFF, 
		IGNORE_DUP_KEY = OFF, 
		ONLINE = OFF
	) ON [PRIMARY]
  
	CREATE INDEX [MULTIBUY_Index1] ON [!ActiveSchema!].[MULTIBUY] 
	(
		[mbdStartDate] ASC
	)WITH 
	(
		PAD_INDEX  = OFF,
    FILLFACTOR = 90, 
		SORT_IN_TEMPDB = OFF, 
		DROP_EXISTING = OFF, 
		IGNORE_DUP_KEY = OFF, 
		ONLINE = OFF
	) ON [PRIMARY]
  
	CREATE INDEX [MULTIBUY_Index2] ON [!ActiveSchema!].[MULTIBUY] 
	(
		[mbdEndDate] ASC
	)WITH 
	(
		PAD_INDEX  = OFF,
    FILLFACTOR = 90, 
		SORT_IN_TEMPDB = OFF, 
		DROP_EXISTING = OFF, 
		IGNORE_DUP_KEY = OFF, 
		ONLINE = OFF
	) ON [PRIMARY]
  
  -- Now we add an entry to the SchemaVersion table
--  INSERT INTO [!ActiveSchema!].SchemaVersion (SchemaName, Version)
--  VALUES ('MULTIBUY_Final.xml', 0)
  
END


