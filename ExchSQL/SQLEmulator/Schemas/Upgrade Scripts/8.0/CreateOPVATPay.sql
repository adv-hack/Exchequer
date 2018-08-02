--/////////////////////////////////////////////////////////////////////////////
--// Filename   : CreateOPVATPay.sql
--// Author     : Chris Sandow
--// Date       : 23 July 2014
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2015. All rights reserved.
--// Description    : SQL Script to create table for the 7.x Order Payments release
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//  1 23rd July 2014:  File Creation - Chris Sandow
--//
--/////////////////////////////////////////////////////////////////////////////

SET NOCOUNT ON

-- Check that table does not already exist.
IF NOT EXISTS (
            SELECT  *
            FROM    sysobjects tab
            WHERE   (tab.id = object_id('[!ActiveSchema!].OPVATPay'))
          )
BEGIN
  CREATE TABLE [!ActiveSchema!].[OPVATPay](
    [vpOrderRef] [varchar](10) NOT NULL,
    [vpReceiptRef] [varchar](10) NOT NULL,
    [vpTransRef] [varchar](10) NOT NULL,
    [vpLineOrderNo] [int] NOT NULL,
    [vpSORABSLineNo] [int] NOT NULL,
    [vpType] [int] NOT NULL,
    [vpCurrency] [int] NOT NULL,
    [vpDescription] [varchar](60) NOT NULL,
    [vpVATCode] [varchar](1) NOT NULL,
    [vpGoodsValue] [float] NOT NULL,
    [vpVATValue] [float] NOT NULL,
    [vpUserName] [varchar](10) NOT NULL,
    [vpDateCreated] [varchar](8) NOT NULL,
    [vpTimeCreated] [varchar](6) NOT NULL,
    PositionId int IDENTITY(1,1) NOT NULL
  ) ON [PRIMARY]
  
  -- Create main Emulator index
  CREATE UNIQUE INDEX OPVATPay_Index_Identity ON [!ActiveSchema!].OPVATPay(PositionId)

  CREATE UNIQUE INDEX OPVATPay_Index0 ON [!ActiveSchema!].OPVATPay([vpOrderRef], [vpReceiptRef], [vpLineOrderNo], [PositionId])
  CREATE UNIQUE INDEX OPVATPay_Index1 ON [!ActiveSchema!].OPVATPay([vpOrderRef], [vpTransRef], [vpLineOrderNo], [PositionId])
  CREATE UNIQUE INDEX OPVATPay_Index2 ON [!ActiveSchema!].OPVATPay([vpOrderRef], [vpType], [vpReceiptRef], [PositionId]) INCLUDE ( [vpGoodsValue], [vpVATValue] )
  CREATE UNIQUE INDEX OPVATPay_Index3 ON [!ActiveSchema!].OPVATPay([vpOrderRef], [vpType], [vpTransRef], [PositionId]) INCLUDE ( [vpGoodsValue], [vpVATValue] )

END

SET NOCOUNT OFF
