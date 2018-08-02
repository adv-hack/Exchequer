--/////////////////////////////////////////////////////////////////////////////
--// Filename   : AnonymisationDiaryCreator.sql
--// Author     : Mark Higginson
--// Date       : 06/12/2017
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2017. All rights reserved.
--// Description    : SQL Script to create table for the 2018-R1 release
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//  1 - 06/12/2017:  File Creation - Mark Higginson
--//
--/////////////////////////////////////////////////////////////////////////////

SET NOCOUNT ON

-- Check that table does not already exist.
IF NOT EXISTS (
            SELECT  *
            FROM    sysobjects tab
            WHERE   (tab.id = object_id('[!ActiveSchema!].ANONYMISATIONDIARY'))
          )
BEGIN
  CREATE TABLE [!ActiveSchema!].[ANONYMISATIONDIARY](
    [adEntityType] [int] NOT NULL,
    [adEntityCode] [varchar](200) NOT NULL,
    [adAnonymisationDate] [varchar](8) NOT NULL,
    [PositionId] [int] IDENTITY(1,1) NOT NULL
  ) ON [PRIMARY]
  -- Create primary index
  CREATE UNIQUE INDEX ANONYMISATIONDIARY_Index_Identity ON [!ActiveSchema!].ANONYMISATIONDIARY(PositionId)
  -- Create other indexes
  CREATE UNIQUE INDEX ANONYMISATIONDIARY_Index0 ON [!ActiveSchema!].ANONYMISATIONDIARY(adEntityType, adEntityCode, PositionId)
  CREATE UNIQUE INDEX ANONYMISATIONDIARY_Index1 ON [!ActiveSchema!].ANONYMISATIONDIARY(adAnonymisationDate, adEntityCode, adEntityType, PositionId)
END

SET NOCOUNT OFF

