--/////////////////////////////////////////////////////////////////////////////
--// Filename		: SortViewCreate.sql
--// Author		: Chris Sandow
--// Date		: 12th May 2009
--// Copyright Notice	: (c) 2015 Advanced Business Software & Solutions Ltd. All rights reserved.
--// Description	: SQL Script to create table for the 6.01 release
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	12th May 2009:	File Creation - Chris Sandow
--/////////////////////////////////////////////////////////////////////////////

-- Check to see if the SORTVIEW table exists
IF NOT EXISTS 
(
  SELECT  *
  FROM    sysobjects tab 
  WHERE   (tab.id = object_id('[!ActiveSchema!].SORTVIEW')) 
)
BEGIN
  CREATE TABLE [!ActiveSchema!].SORTVIEW (
    [svrViewId] [int] NOT NULL,
    [svrUserId] [varchar](30) NOT NULL,
    [svrListType] [int] NOT NULL,
    [svrDescr] [varchar](100) NOT NULL,
    [svsEnabled01] [bit] NOT NULL,
    [svsFieldId01] [int] NOT NULL,
    [svsAscending01] [bit] NOT NULL,
    [svsSpare01] [varbinary](50) NOT NULL,
    [svsEnabled02] [bit] NOT NULL,
    [svsFieldId02] [int] NOT NULL,
    [svsAscending02] [bit] NOT NULL,
    [svsSpare02] [varbinary](50) NOT NULL,
    [svsEnabled03] [bit] NOT NULL,
    [svsFieldId03] [int] NOT NULL,
    [svsAscending03] [bit] NOT NULL,
    [svsSpare03] [varbinary](50) NOT NULL,
    [svsEnabled04] [bit] NOT NULL,
    [svsFieldId04] [int] NOT NULL,
    [svsAscending04] [bit] NOT NULL,
    [svsSpare04] [varbinary](50) NOT NULL,
    [svfEnabled01] [bit] NOT NULL,
    [svfFieldId01] [int] NOT NULL,
    [svfComparison01] [int] NOT NULL,
    [svfValue01] [varchar](100) NOT NULL,
    [svfSpare01] [varbinary](100) NOT NULL,
    [svfEnabled02] [bit] NOT NULL,
    [svfFieldId02] [int] NOT NULL,
    [svfComparison02] [int] NOT NULL,
    [svfValue02] [varchar](100) NOT NULL,
    [svfSpare02] [varbinary](100) NOT NULL,
    [svfEnabled03] [bit] NOT NULL,
    [svfFieldId03] [int] NOT NULL,
    [svfComparison03] [int] NOT NULL,
    [svfValue03] [varchar](100) NOT NULL,
    [svfSpare03] [varbinary](100) NOT NULL,
    [svfEnabled04] [bit] NOT NULL,
    [svfFieldId04] [int] NOT NULL,
    [svfComparison04] [int] NOT NULL,
    [svfValue04] [varchar](100) NOT NULL,
    [svfSpare04] [varbinary](100) NOT NULL,
    [svfEnabled05] [bit] NOT NULL,
    [svfFieldId05] [int] NOT NULL,
    [svfComparison05] [int] NOT NULL,
    [svfValue05] [varchar](100) NOT NULL,
    [svfSpare05] [varbinary](100) NOT NULL,
    [svfEnabled06] [bit] NOT NULL,
    [svfFieldId06] [int] NOT NULL,
    [svfComparison06] [int] NOT NULL,
    [svfValue06] [varchar](100) NOT NULL,
    [svfSpare06] [varbinary](100) NOT NULL,
    [svfEnabled07] [bit] NOT NULL,
    [svfFieldId07] [int] NOT NULL,
    [svfComparison07] [int] NOT NULL,
    [svfValue07] [varchar](100) NOT NULL,
    [svfSpare07] [varbinary](100) NOT NULL,
    [svfEnabled08] [bit] NOT NULL,
    [svfFieldId08] [int] NOT NULL,
    [svfComparison08] [int] NOT NULL,
    [svfValue08] [varchar](100) NOT NULL,
    [svfSpare08] [varbinary](100) NOT NULL,
    [PositionId] [int] IDENTITY(1,1) NOT NULL
  ) ON [PRIMARY]
  
	CREATE UNIQUE INDEX [SORTVIEW_Index_Identity] ON [!ActiveSchema!].[SORTVIEW] 
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
  
	CREATE UNIQUE INDEX [SORTVIEW_Index0] ON [!ActiveSchema!].[SORTVIEW] 
	(
		[svrViewID] ASC
	)WITH 
	(
		PAD_INDEX  = OFF,
    FILLFACTOR = 90, 
		SORT_IN_TEMPDB = OFF, 
		DROP_EXISTING = OFF, 
		IGNORE_DUP_KEY = OFF, 
		ONLINE = OFF
	) ON [PRIMARY]
  
	CREATE UNIQUE INDEX [SORTVIEW_Index1] ON [!ActiveSchema!].[SORTVIEW] 
	(
		[svrListType] ASC,
		[svrUserID] ASC,
		[svrDescr] ASC
	)WITH 
	(
		PAD_INDEX  = OFF,
    FILLFACTOR = 90, 
		SORT_IN_TEMPDB = OFF, 
		DROP_EXISTING = OFF, 
		IGNORE_DUP_KEY = OFF, 
		ONLINE = OFF
	) ON [PRIMARY]
  
END

-- Check to see if the SVUSRDEF table exists
IF NOT EXISTS 
(
  SELECT  *
  FROM    sysobjects tab 
  WHERE   (tab.id = object_id('[!ActiveSchema!].SVUSRDEF')) 
)
BEGIN
  CREATE TABLE [!ActiveSchema!].SVUSRDEF (
    [svuUserId] [varchar](30) NOT NULL,
    [svuListType] [int] NOT NULL,
    [svuDefaultView] [int] NOT NULL,
    [svuSpare] [varbinary](900) NOT NULL,
    [PositionId] [int] IDENTITY(1,1) NOT NULL
  ) ON [PRIMARY]
  
	CREATE UNIQUE INDEX [SVUSRDEF_Index_Identity] ON [!ActiveSchema!].[SVUSRDEF] 
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
  
	CREATE UNIQUE INDEX [SVUSRDEF_Index0] ON [!ActiveSchema!].[SVUSRDEF] 
	(
		[svuUserID] ASC,
		[svuListType] ASC
	)WITH 
	(
		PAD_INDEX  = OFF,
    FILLFACTOR = 90, 
		SORT_IN_TEMPDB = OFF, 
		DROP_EXISTING = OFF, 
		IGNORE_DUP_KEY = OFF, 
		ONLINE = OFF
	) ON [PRIMARY]

  -- Now we update the Version numbers in the SchemaVersion table
--  INSERT INTO [!ActiveSchema!].SchemaVersion (SchemaName, Version)
--  VALUES ('SORTVIEW_Final.xml', 0)
--  
--  INSERT INTO [!ActiveSchema!].SchemaVersion (SchemaName, Version)
--  VALUES ('SVUSRDEF_Final.xml', 0)
--  
--  INSERT INTO [!ActiveSchema!].SchemaVersion (SchemaName, Version)
--  VALUES ('SORTTEMP_Final.xml', 0)
  
END

