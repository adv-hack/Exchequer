--/////////////////////////////////////////////////////////////////////////////
--// Filename		: WindowSettingsCreator.sql
--// Author		: Chris Sandow
--// Date		: 9 November 2010
--// Copyright Notice	: (c) 2015 Advanced Business Software & Solutions Ltd. All rights reserved.
--// Description	: SQL Script to upgrade table for the 6.5 release
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	9th November 2010:	File Creation - Chris Sandow
--//
--/////////////////////////////////////////////////////////////////////////////

--/////////////////////////////////////////////////////////////////////////////
--// Window Settings
--/////////////////////////////////////////////////////////////////////////////
IF NOT EXISTS 
(
  SELECT  *
  FROM    sysobjects tab 
  WHERE   (tab.id = object_id('[!ActiveSchema!].WINSET')) 
)
BEGIN
  CREATE TABLE [!ActiveSchema!].[WINSET](
    [wpExeName] [varchar](20) NOT NULL,
    [wpUserName] [varchar](10) NOT NULL,
    [wpWindowName] [varchar](40) NOT NULL,
    [wpLeft] [int] NOT NULL,
    [wpTop] [int] NOT NULL,
    [wpWidth] [int] NOT NULL,
    [wpHeight] [int] NOT NULL,
    [PositionId] [int] IDENTITY(1,1) NOT NULL
  ) ON [PRIMARY]
  
  CREATE UNIQUE NONCLUSTERED INDEX [WINSET_Index_Identity] ON [!ActiveSchema!].[WINSET] 
  (
    [PositionId] ASC
  ) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
  
  CREATE UNIQUE NONCLUSTERED INDEX [WINSET_Index0] ON [!ActiveSchema!].[WINSET] 
  (
    [wpExeName] ASC,
    [wpUserName] ASC,
    [wpWindowName] ASC,
    [PositionId] ASC
  ) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
END

--/////////////////////////////////////////////////////////////////////////////
--// Parent Settings
--/////////////////////////////////////////////////////////////////////////////
IF NOT EXISTS 
(
  SELECT  *
  FROM    sysobjects tab 
  WHERE   (tab.id = object_id('[!ActiveSchema!].PARSET')) 
)
BEGIN
  CREATE TABLE [!ActiveSchema!].[PARSET](
    [psExeName] [varchar](20) NOT NULL,
    [psUserName] [varchar](10) NOT NULL,
    [psWindowName] [varchar](40) NOT NULL,
    [psName] [varchar](40) NOT NULL,
    [psBackgroundColor] [int] NOT NULL,
    [psFontName] [varchar](40) NOT NULL,
    [psFontSize] [int] NOT NULL,
    [psFontColor] [int] NOT NULL,
    [psFontStyle] [int] NOT NULL,
    [psHeaderBackgroundColor] [int] NOT NULL,
    [psHeaderFontName] [varchar](40) NOT NULL,
    [psHeaderFontSize] [int] NOT NULL,
    [psHeaderFontColor] [int] NOT NULL,
    [psHeaderFontStyle] [int] NOT NULL,
    [psHighlightBackgroundColor] [int] NOT NULL,
    [psHighlightFontColor] [int] NOT NULL,
    [psHighlightFontStyle] [int] NOT NULL,
    [psMultiSelectBackgroundColor] [int] NOT NULL,
    [psMultiSelectFontColor] [int] NOT NULL,
    [psMultiSelectFontStyle] [int] NOT NULL,
    [PositionId] [int] IDENTITY(1,1) NOT NULL
  ) ON [PRIMARY]
  
  CREATE UNIQUE NONCLUSTERED INDEX [PARSET_Index_Identity] ON [!ActiveSchema!].[PARSET] 
  (
    [PositionId] ASC
  ) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
  
  CREATE UNIQUE NONCLUSTERED INDEX [PARSET_Index0] ON [!ActiveSchema!].[PARSET] 
  (
    [psExeName] ASC,
    [psUserName] ASC,
    [psWindowName] ASC,
    [psName] ASC,
    [PositionId] ASC
  ) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
END

--/////////////////////////////////////////////////////////////////////////////
--// Column Settings
--/////////////////////////////////////////////////////////////////////////////
IF NOT EXISTS 
(
  SELECT  *
  FROM    sysobjects tab 
  WHERE   (tab.id = object_id('[!ActiveSchema!].COLSET')) 
)
BEGIN

  CREATE TABLE [!ActiveSchema!].[COLSET](
    [csExeName] [varchar](20) NOT NULL,
    [csUserName] [varchar](10) NOT NULL,
    [csWindowName] [varchar](40) NOT NULL,
    [csParentName] [varchar](40) NOT NULL,
    [csColumnNo] [int] NOT NULL,
    [DummyChar] [int] NOT NULL,
    [csOrder] [int] NOT NULL,
    [csLeft] [int] NOT NULL,
    [csWidth] [int] NOT NULL,
    [csTop] [int] NOT NULL,
    [csHeight] [int] NOT NULL,
    [PositionId] [int] IDENTITY(1,1) NOT NULL
  ) ON [PRIMARY]
  
  CREATE UNIQUE NONCLUSTERED INDEX [COLSET_Index_Identity] ON [!ActiveSchema!].[COLSET] 
  (
    [PositionId] ASC
  ) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
  
  CREATE UNIQUE NONCLUSTERED INDEX [COLSET_Index0] ON [!ActiveSchema!].[COLSET] 
  (
    [csExeName] ASC,
    [csUserName] ASC,
    [csWindowName] ASC,
    [csParentName] ASC,
    [csColumnNo] ASC,
    [DummyChar] ASC,
    [PositionId] ASC
  ) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

END
