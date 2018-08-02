--/////////////////////////////////////////////////////////////////////////////
--// Filename   : CreateAccountContact.sql
--// Author     : Chris Sandow
--// Date       : 2014-01-20
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2015. All rights reserved.
--// Description    : SQL Script to create table for the 7.0.9 release
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//  1 20th January 2014:  File Creation - Chris Sandow
--//  2 2nd December 2014:  Added acoContactCountry field - Chris Sandow
--//
--/////////////////////////////////////////////////////////////////////////////

SET NOCOUNT ON

-- Check that table does not already exist.
IF NOT EXISTS (
            SELECT  *
            FROM    sysobjects tab
            WHERE   (tab.id = object_id('[!ActiveSchema!].AccountContact'))
          )
BEGIN
  CREATE TABLE [!ActiveSchema!].[AccountContact](
    [acoContactId] [int] NOT NULL,
    [acoAccountCode] [varchar](10) NOT NULL,
    [acoContactName] [varchar](45) NOT NULL,
    [acoContactJobTitle] [varchar](30) NOT NULL,
    [acoContactPhoneNumber] [varchar](30) NOT NULL,
    [acoContactFaxNumber] [varchar](30) NOT NULL,
    [acoContactEmailAddress] [varchar](100) NOT NULL,
    [acoContactHasOwnAddress] [bit] NOT NULL,
    [acoContactAddress1] [varchar](30) NOT NULL,
    [acoContactAddress2] [varchar](30) NOT NULL,
    [acoContactAddress3] [varchar](30) NOT NULL,
    [acoContactAddress4] [varchar](30) NOT NULL,
    [acoContactAddress5] [varchar](30) NOT NULL,
    [acoContactPostCode] [varchar](30) NOT NULL,
    [acoContactCountry] [varchar](2) NOT NULL,
    [acoDateModified] [datetime] NOT NULL,
    [acoDateCreated] [datetime] NOT NULL,
    PositionId int IDENTITY(1,1) NOT NULL
  ) ON [PRIMARY]
  
  -- Create main Emulator index
  CREATE UNIQUE INDEX AccountContact_Index_Identity ON [!ActiveSchema!].AccountContact(PositionId)

  CREATE UNIQUE INDEX AccountContact_Index0 ON [!ActiveSchema!].AccountContact([acoContactId], [PositionId])
  CREATE UNIQUE INDEX AccountContact_Index1 ON [!ActiveSchema!].AccountContact([acoAccountCode], [acoContactName], [PositionId])

  -- Other indexes and constraints will be created by the InitialiseAccountContact.sql script  
  
END

SET NOCOUNT OFF

