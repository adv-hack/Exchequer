--/////////////////////////////////////////////////////////////////////////////
--// Filename   : CreateContactRole.sql
--// Author     : Chris Sandow
--// Date       : 2014-01-20
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2015. All rights reserved.
--// Description: SQL Script to create table for the 7.x (MRD) release
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//  1 20th January 2014:  File Creation - Chris Sandow
--//
--/////////////////////////////////////////////////////////////////////////////

SET NOCOUNT ON

-- Check that table does not already exist.
IF NOT EXISTS (
            SELECT  *
            FROM    sysobjects tab
            WHERE   (tab.id = object_id('[!ActiveSchema!].ContactRole'))
          )
BEGIN
  CREATE TABLE [!ActiveSchema!].[ContactRole](
	  [crRoleId] [int] NOT NULL,
	  [crRoleDescription] [varchar](50) NOT NULL,
	  [crRoleAppliesToCustomer] [bit] NOT NULL,
	  [crRoleAppliesToSupplier] [bit] NOT NULL,
	  [crDateModified] [datetime] NOT NULL,
	  [crDateCreated] [datetime] NOT NULL,
    PositionId int IDENTITY(1,1) NOT NULL
  ) ON [PRIMARY]
  
  -- Create main Emulator index
  CREATE UNIQUE INDEX ContactRole_Index_Identity ON [!ActiveSchema!].ContactRole(PositionId)

  CREATE UNIQUE INDEX ContactRole_Index0 ON [!ActiveSchema!].ContactRole([crRoleId], [PositionId])
  CREATE UNIQUE INDEX ContactRole_Index1 ON [!ActiveSchema!].ContactRole([crRoleDescription], [PositionId])
  
  -- Other indexes and constraints will be created by the InitialiseContactRole.sql script  
  
END
GO

SET NOCOUNT OFF

