--/////////////////////////////////////////////////////////////////////////////
--// Filename   : CreateAccountContactRole.sql
--// Author     : Chris Sandow
--// Date       : 2014-01-20
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2015. All rights reserved.
--// Description    : SQL Script to create table for the 7.x (MRD) release
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//  1 20th January 2013:  File Creation - Chris Sandow
--//
--/////////////////////////////////////////////////////////////////////////////

SET NOCOUNT ON

-- Check that table does not already exist.
IF NOT EXISTS (
            SELECT  *
            FROM    sysobjects tab
            WHERE   (tab.id = object_id('[!ActiveSchema!].AccountContactRole'))
          )
BEGIN
  CREATE TABLE [!ActiveSchema!].[AccountContactRole](
    [acrContactId] [int] NOT NULL,
    [acrRoleId] [int] NOT NULL,
    [acrDateCreated] [datetime] NOT NULL,
    PositionId int IDENTITY(1,1) NOT NULL
  ) ON [PRIMARY]
  
  -- Create main Emulator index
  CREATE UNIQUE INDEX AccountContactRole_Index_Identity ON [!ActiveSchema!].AccountContactRole(PositionId)
  
  CREATE UNIQUE INDEX AccountContactRole_Index0 ON [!ActiveSchema!].AccountContactRole([acrContactId], [acrRoleId], [PositionId])
  CREATE UNIQUE INDEX AccountContactRole_Index1 ON [!ActiveSchema!].AccountContactRole([acrRoleId], [acrContactId], [PositionId])
  
  -- Other indexes and constraints will be created by the InitialiseAccountContactRole.sql script  
  
END

SET NOCOUNT OFF

