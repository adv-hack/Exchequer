--/////////////////////////////////////////////////////////////////////////////
--// Filename   : CreateTaxCodesTable.sql
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
DECLARE @TaxCodesExists INT
SELECT  @TaxCodesExists = 1 

IF NOT EXISTS (
            SELECT  *
            FROM    sysobjects tab
            WHERE   (tab.id = object_id('[!ActiveSchema!].TaxCodes'))
          )
BEGIN
    SELECT @TaxCodesExists = 0
END

IF @TaxCodesExists = 0
BEGIN
  CREATE TABLE [!ActiveSchema!].[TaxCodes](
    [tcID] [int] NOT NULL DEFAULT 0,
    [tcCode] [varchar](1) NOT NULL DEFAULT CHAR(0),
    [tcDescription] [varchar](30) NOT NULL DEFAULT CHAR(0),
    [tcDateCreated] [datetime] NOT NULL,
    [tcDateModified] [datetime] NOT NULL,
    PositionId int IDENTITY(1,1) NOT NULL
  ) ON [PRIMARY]
  
  -- Create main Emulator index
  CREATE UNIQUE INDEX TaxCodes_Index_Identity ON [!ActiveSchema!].TaxCodes(PositionId)

  -- Create other indexes
  CREATE UNIQUE INDEX TaxCodes_Index0 ON [!ActiveSchema!].TaxCodes([tcID], [tcCode], [PositionId])

END

IF @TaxCodesExists = 0
BEGIN
  SET IDENTITY_INSERT [!ActiveSchema!].[TaxCodes] ON 
  INSERT [!ActiveSchema!].[TaxCodes] ([tcId], [tcCode], [tcDescription], [tcDateCreated], [tcDateModified], [PositionId]) VALUES ( 1, N'S', N'S',   GETDATE(), GETDATE(),  1)
  INSERT [!ActiveSchema!].[TaxCodes] ([tcId], [tcCode], [tcDescription], [tcDateCreated], [tcDateModified], [PositionId]) VALUES ( 2, N'E', N'E',   GETDATE(), GETDATE(),  2)
  INSERT [!ActiveSchema!].[TaxCodes] ([tcId], [tcCode], [tcDescription], [tcDateCreated], [tcDateModified], [PositionId]) VALUES ( 3, N'Z', N'Z',   GETDATE(), GETDATE(),  3)
  INSERT [!ActiveSchema!].[TaxCodes] ([tcId], [tcCode], [tcDescription], [tcDateCreated], [tcDateModified], [PositionId]) VALUES ( 4, N'1', N'1',   GETDATE(), GETDATE(),  4)
  INSERT [!ActiveSchema!].[TaxCodes] ([tcId], [tcCode], [tcDescription], [tcDateCreated], [tcDateModified], [PositionId]) VALUES ( 5, N'2', N'2',   GETDATE(), GETDATE(),  5)
  INSERT [!ActiveSchema!].[TaxCodes] ([tcId], [tcCode], [tcDescription], [tcDateCreated], [tcDateModified], [PositionId]) VALUES ( 6, N'3', N'3/A', GETDATE(), GETDATE(),  6)
  INSERT [!ActiveSchema!].[TaxCodes] ([tcId], [tcCode], [tcDescription], [tcDateCreated], [tcDateModified], [PositionId]) VALUES ( 7, N'4', N'4/D', GETDATE(), GETDATE(),  7)
  INSERT [!ActiveSchema!].[TaxCodes] ([tcId], [tcCode], [tcDescription], [tcDateCreated], [tcDateModified], [PositionId]) VALUES ( 8, N'5', N'5',   GETDATE(), GETDATE(),  8)
  INSERT [!ActiveSchema!].[TaxCodes] ([tcId], [tcCode], [tcDescription], [tcDateCreated], [tcDateModified], [PositionId]) VALUES ( 9, N'6', N'6',   GETDATE(), GETDATE(),  9)
  INSERT [!ActiveSchema!].[TaxCodes] ([tcId], [tcCode], [tcDescription], [tcDateCreated], [tcDateModified], [PositionId]) VALUES (10, N'7', N'7',   GETDATE(), GETDATE(), 10)
  INSERT [!ActiveSchema!].[TaxCodes] ([tcId], [tcCode], [tcDescription], [tcDateCreated], [tcDateModified], [PositionId]) VALUES (11, N'8', N'8',   GETDATE(), GETDATE(), 11)
  INSERT [!ActiveSchema!].[TaxCodes] ([tcId], [tcCode], [tcDescription], [tcDateCreated], [tcDateModified], [PositionId]) VALUES (12, N'9', N'9',   GETDATE(), GETDATE(), 12)
  INSERT [!ActiveSchema!].[TaxCodes] ([tcId], [tcCode], [tcDescription], [tcDateCreated], [tcDateModified], [PositionId]) VALUES (13, N'T', N'T',   GETDATE(), GETDATE(), 13)
  INSERT [!ActiveSchema!].[TaxCodes] ([tcId], [tcCode], [tcDescription], [tcDateCreated], [tcDateModified], [PositionId]) VALUES (14, N'X', N'X',   GETDATE(), GETDATE(), 14)
  INSERT [!ActiveSchema!].[TaxCodes] ([tcId], [tcCode], [tcDescription], [tcDateCreated], [tcDateModified], [PositionId]) VALUES (15, N'B', N'B',   GETDATE(), GETDATE(), 15)
  INSERT [!ActiveSchema!].[TaxCodes] ([tcId], [tcCode], [tcDescription], [tcDateCreated], [tcDateModified], [PositionId]) VALUES (16, N'C', N'C',   GETDATE(), GETDATE(), 16)
  INSERT [!ActiveSchema!].[TaxCodes] ([tcId], [tcCode], [tcDescription], [tcDateCreated], [tcDateModified], [PositionId]) VALUES (17, N'F', N'F',   GETDATE(), GETDATE(), 17)
  INSERT [!ActiveSchema!].[TaxCodes] ([tcId], [tcCode], [tcDescription], [tcDateCreated], [tcDateModified], [PositionId]) VALUES (18, N'G', N'G',   GETDATE(), GETDATE(), 18)
  INSERT [!ActiveSchema!].[TaxCodes] ([tcId], [tcCode], [tcDescription], [tcDateCreated], [tcDateModified], [PositionId]) VALUES (19, N'R', N'R',   GETDATE(), GETDATE(), 19)
  INSERT [!ActiveSchema!].[TaxCodes] ([tcId], [tcCode], [tcDescription], [tcDateCreated], [tcDateModified], [PositionId]) VALUES (20, N'W', N'W',   GETDATE(), GETDATE(), 20)
  INSERT [!ActiveSchema!].[TaxCodes] ([tcId], [tcCode], [tcDescription], [tcDateCreated], [tcDateModified], [PositionId]) VALUES (21, N'Y', N'Y',   GETDATE(), GETDATE(), 21)
  SET IDENTITY_INSERT [!ActiveSchema!].[TaxCodes] OFF 
END

SET NOCOUNT OFF