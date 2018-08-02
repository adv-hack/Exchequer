object Form1: TForm1
  Left = 331
  Top = 127
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'IRIS Licensing - Create ICE DB Utility'
  ClientHeight = 399
  ClientWidth = 770
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object btnJustDoIt: TButton
    Left = 7
    Top = 7
    Width = 755
    Height = 71
    Caption = 'Just Do It'
    TabOrder = 0
    OnClick = btnJustDoItClick
  end
  object Memo1: TMemo
    Left = 7
    Top = 88
    Width = 755
    Height = 297
    Lines.Strings = (
      'USE [master]'
      'GO'
      ''
      
        'IF EXISTS (SELECT name FROM sys.databases WHERE name = N'#39'IrisCom' +
        'municationEngine'#39')'
      'BEGIN'
      'DROP DATABASE [IrisCommunicationEngine]'
      'END'
      'GO'
      ''
      
        'IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'#39'Iri' +
        'sCommunicationEngine'#39')'
      'BEGIN'
      'CREATE DATABASE [IrisCommunicationEngine]'
      'END'
      'GO'
      ''
      'GO'
      
        'EXEC dbo.sp_dbcmptlevel @dbname=N'#39'IrisCommunicationEngine'#39', @new' +
        '_cmptlevel=90'
      'GO'
      'IF (1 = FULLTEXTSERVICEPROPERTY('#39'IsFullTextInstalled'#39'))'#10
      'begin'#10
      
        'EXEC [IrisCommunicationEngine].[dbo].[sp_fulltext_database] @act' +
        'ion = '#39'enable'#39#10
      'end'
      'GO'
      
        'ALTER DATABASE [IrisCommunicationEngine] SET ANSI_NULL_DEFAULT O' +
        'FF '
      'GO'
      'ALTER DATABASE [IrisCommunicationEngine] SET ANSI_NULLS OFF '
      'GO'
      'ALTER DATABASE [IrisCommunicationEngine] SET ANSI_PADDING OFF '
      'GO'
      'ALTER DATABASE [IrisCommunicationEngine] SET ANSI_WARNINGS OFF '
      'GO'
      'ALTER DATABASE [IrisCommunicationEngine] SET ARITHABORT OFF '
      'GO'
      'ALTER DATABASE [IrisCommunicationEngine] SET AUTO_CLOSE ON '
      'GO'
      
        'ALTER DATABASE [IrisCommunicationEngine] SET AUTO_CREATE_STATIST' +
        'ICS ON '
      'GO'
      'ALTER DATABASE [IrisCommunicationEngine] SET AUTO_SHRINK OFF '
      'GO'
      
        'ALTER DATABASE [IrisCommunicationEngine] SET AUTO_UPDATE_STATIST' +
        'ICS ON '
      'GO'
      
        'ALTER DATABASE [IrisCommunicationEngine] SET CURSOR_CLOSE_ON_COM' +
        'MIT OFF '
      'GO'
      
        'ALTER DATABASE [IrisCommunicationEngine] SET CURSOR_DEFAULT  GLO' +
        'BAL '
      'GO'
      
        'ALTER DATABASE [IrisCommunicationEngine] SET CONCAT_NULL_YIELDS_' +
        'NULL OFF '
      'GO'
      
        'ALTER DATABASE [IrisCommunicationEngine] SET NUMERIC_ROUNDABORT ' +
        'OFF '
      'GO'
      
        'ALTER DATABASE [IrisCommunicationEngine] SET QUOTED_IDENTIFIER O' +
        'FF '
      'GO'
      
        'ALTER DATABASE [IrisCommunicationEngine] SET RECURSIVE_TRIGGERS ' +
        'OFF '
      'GO'
      'ALTER DATABASE [IrisCommunicationEngine] SET  DISABLE_BROKER '
      'GO'
      
        'ALTER DATABASE [IrisCommunicationEngine] SET AUTO_UPDATE_STATIST' +
        'ICS_ASYNC OFF '
      'GO'
      
        'ALTER DATABASE [IrisCommunicationEngine] SET DATE_CORRELATION_OP' +
        'TIMIZATION OFF '
      'GO'
      'ALTER DATABASE [IrisCommunicationEngine] SET TRUSTWORTHY OFF '
      'GO'
      
        'ALTER DATABASE [IrisCommunicationEngine] SET ALLOW_SNAPSHOT_ISOL' +
        'ATION OFF '
      'GO'
      
        'ALTER DATABASE [IrisCommunicationEngine] SET PARAMETERIZATION SI' +
        'MPLE '
      'GO'
      'ALTER DATABASE [IrisCommunicationEngine] SET  READ_WRITE '
      'GO'
      'ALTER DATABASE [IrisCommunicationEngine] SET RECOVERY SIMPLE '
      'GO'
      'ALTER DATABASE [IrisCommunicationEngine] SET  MULTI_USER '
      'GO'
      
        'ALTER DATABASE [IrisCommunicationEngine] SET PAGE_VERIFY CHECKSU' +
        'M  '
      'GO'
      'ALTER DATABASE [IrisCommunicationEngine] SET DB_CHAINING OFF '
      
        '/* For security reasons the login is created disabled and with a' +
        ' random password. */'
      
        'IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = ' +
        'N'#39'GHJHyhjghIRISICEhdskjJ432!'#39')'
      
        'CREATE LOGIN [GHJHyhjghIRISICEhdskjJ432!] WITH PASSWORD=N'#39'HGjkyu' +
        'ifdsnjkUH765iuHJ!'#39', DEFAULT_DATABASE=[IrisCommunicationEngine], '
      
        'DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=ON, CHECK_POLICY' +
        '=ON'
      'GO'
      
        'IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = ' +
        'N'#39'NT AUTHORITY\SYSTEM'#39')'
      
        'CREATE LOGIN [NT AUTHORITY\SYSTEM] FROM WINDOWS WITH DEFAULT_DAT' +
        'ABASE=[master], DEFAULT_LANGUAGE=[us_english]'
      'GO'
      
        'IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = ' +
        'N'#39'BUILTIN\Users'#39')'
      
        'CREATE LOGIN [BUILTIN\Users] FROM WINDOWS WITH DEFAULT_DATABASE=' +
        '[master], DEFAULT_LANGUAGE=[us_english]'
      'GO'
      
        'IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = ' +
        'N'#39'BUILTIN\Administrators'#39')'
      
        'CREATE LOGIN [BUILTIN\Administrators] FROM WINDOWS WITH DEFAULT_' +
        'DATABASE=[master], DEFAULT_LANGUAGE=[us_english]'
      'GO'
      'USE [IrisCommunicationEngine]'
      'GO'
      
        'IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name ' +
        '= N'#39'GHJHyhjghIRISICEhdskjJ432!'#39')'
      
        'CREATE USER [GHJHyhjghIRISICEhdskjJ432!] FOR LOGIN [GHJHyhjghIRI' +
        'SICEhdskjJ432!] WITH DEFAULT_SCHEMA=[dbo]'
      'GO'
      'GRANT ALTER TO [GHJHyhjghIRISICEhdskjJ432!]'
      'GO'
      'GRANT ALTER ANY ASYMMETRIC KEY TO [GHJHyhjghIRISICEhdskjJ432!]'
      'GO'
      'GRANT ALTER ANY APPLICATION ROLE TO [GHJHyhjghIRISICEhdskjJ432!]'
      'GO'
      'GRANT ALTER ANY ASSEMBLY TO [GHJHyhjghIRISICEhdskjJ432!]'
      'GO'
      'GRANT ALTER ANY CERTIFICATE TO [GHJHyhjghIRISICEhdskjJ432!]'
      'GO'
      'GRANT ALTER ANY DATASPACE TO [GHJHyhjghIRISICEhdskjJ432!]'
      'GO'
      
        'GRANT ALTER ANY DATABASE EVENT NOTIFICATION TO [GHJHyhjghIRISICE' +
        'hdskjJ432!]'
      'GO'
      'GRANT ALTER ANY FULLTEXT CATALOG TO [GHJHyhjghIRISICEhdskjJ432!]'
      'GO'
      'GRANT ALTER ANY MESSAGE TYPE TO [GHJHyhjghIRISICEhdskjJ432!]'
      'GO'
      'GRANT ALTER ANY ROLE TO [GHJHyhjghIRISICEhdskjJ432!]'
      'GO'
      'GRANT ALTER ANY ROUTE TO [GHJHyhjghIRISICEhdskjJ432!]'
      'GO'
      
        'GRANT ALTER ANY REMOTE SERVICE BINDING TO [GHJHyhjghIRISICEhdskj' +
        'J432!]'
      'GO'
      'GRANT ALTER ANY CONTRACT TO [GHJHyhjghIRISICEhdskjJ432!]'
      'GO'
      'GRANT ALTER ANY SYMMETRIC KEY TO [GHJHyhjghIRISICEhdskjJ432!]'
      'GO'
      'GRANT ALTER ANY SCHEMA TO [GHJHyhjghIRISICEhdskjJ432!]'
      'GO'
      'GRANT ALTER ANY SERVICE TO [GHJHyhjghIRISICEhdskjJ432!]'
      'GO'
      
        'GRANT ALTER ANY DATABASE DDL TRIGGER TO [GHJHyhjghIRISICEhdskjJ4' +
        '32!]'
      'GO'
      'GRANT ALTER ANY USER TO [GHJHyhjghIRISICEhdskjJ432!]'
      'GO'
      'GRANT AUTHENTICATE TO [GHJHyhjghIRISICEhdskjJ432!]'
      'GO'
      'GRANT BACKUP DATABASE TO [GHJHyhjghIRISICEhdskjJ432!]'
      'GO'
      'GRANT BACKUP LOG TO [GHJHyhjghIRISICEhdskjJ432!]'
      'GO'
      'GRANT CONTROL TO [GHJHyhjghIRISICEhdskjJ432!]'
      'GO'
      'GRANT CONNECT TO [GHJHyhjghIRISICEhdskjJ432!]'
      'GO'
      'GRANT CONNECT REPLICATION TO [GHJHyhjghIRISICEhdskjJ432!]'
      'GO'
      'GRANT CHECKPOINT TO [GHJHyhjghIRISICEhdskjJ432!]'
      'GO'
      'GRANT CREATE AGGREGATE TO [GHJHyhjghIRISICEhdskjJ432!]'
      'GO'
      'GRANT CREATE ASYMMETRIC KEY TO [GHJHyhjghIRISICEhdskjJ432!]'
      'GO'
      'GRANT CREATE ASSEMBLY TO [GHJHyhjghIRISICEhdskjJ432!]'
      'GO'
      'GRANT CREATE CERTIFICATE TO [GHJHyhjghIRISICEhdskjJ432!]'
      'GO'
      'GRANT CREATE DEFAULT TO [GHJHyhjghIRISICEhdskjJ432!]'
      'GO'
      
        'GRANT CREATE DATABASE DDL EVENT NOTIFICATION TO [GHJHyhjghIRISIC' +
        'EhdskjJ432!]'
      'GO'
      'GRANT CREATE FUNCTION TO [GHJHyhjghIRISICEhdskjJ432!]'
      'GO'
      'GRANT CREATE FULLTEXT CATALOG TO [GHJHyhjghIRISICEhdskjJ432!]'
      'GO'
      'GRANT CREATE MESSAGE TYPE TO [GHJHyhjghIRISICEhdskjJ432!]'
      'GO'
      'GRANT CREATE PROCEDURE TO [GHJHyhjghIRISICEhdskjJ432!]'
      'GO'
      'GRANT CREATE QUEUE TO [GHJHyhjghIRISICEhdskjJ432!]'
      'GO'
      'GRANT CREATE ROLE TO [GHJHyhjghIRISICEhdskjJ432!]'
      'GO'
      'GRANT CREATE ROUTE TO [GHJHyhjghIRISICEhdskjJ432!]'
      'GO'
      'GRANT CREATE RULE TO [GHJHyhjghIRISICEhdskjJ432!]'
      'GO'
      
        'GRANT CREATE REMOTE SERVICE BINDING TO [GHJHyhjghIRISICEhdskjJ43' +
        '2!]'
      'GO'
      'GRANT CREATE CONTRACT TO [GHJHyhjghIRISICEhdskjJ432!]'
      'GO'
      'GRANT CREATE SYMMETRIC KEY TO [GHJHyhjghIRISICEhdskjJ432!]'
      'GO'
      'GRANT CREATE SCHEMA TO [GHJHyhjghIRISICEhdskjJ432!]'
      'GO'
      'GRANT CREATE SYNONYM TO [GHJHyhjghIRISICEhdskjJ432!]'
      'GO'
      'GRANT CREATE SERVICE TO [GHJHyhjghIRISICEhdskjJ432!]'
      'GO'
      'GRANT CREATE TABLE TO [GHJHyhjghIRISICEhdskjJ432!]'
      'GO'
      'GRANT CREATE TYPE TO [GHJHyhjghIRISICEhdskjJ432!]'
      'GO'
      'GRANT CREATE VIEW TO [GHJHyhjghIRISICEhdskjJ432!]'
      'GO'
      
        'GRANT CREATE XML SCHEMA COLLECTION TO [GHJHyhjghIRISICEhdskjJ432' +
        '!]'
      'GO'
      'GRANT DELETE TO [GHJHyhjghIRISICEhdskjJ432!]'
      'GO'
      'GRANT EXECUTE TO [GHJHyhjghIRISICEhdskjJ432!]'
      'GO'
      'GRANT INSERT TO [GHJHyhjghIRISICEhdskjJ432!]'
      'GO'
      'GRANT REFERENCES TO [GHJHyhjghIRISICEhdskjJ432!]'
      'GO'
      'GRANT SELECT TO [GHJHyhjghIRISICEhdskjJ432!]'
      'GO'
      'GRANT SHOWPLAN TO [GHJHyhjghIRISICEhdskjJ432!]'
      'GO'
      
        'GRANT SUBSCRIBE QUERY NOTIFICATIONS TO [GHJHyhjghIRISICEhdskjJ43' +
        '2!]'
      'GO'
      'GRANT TAKE OWNERSHIP TO [GHJHyhjghIRISICEhdskjJ432!]'
      'GO'
      'GRANT UPDATE TO [GHJHyhjghIRISICEhdskjJ432!]'
      'GO'
      'GRANT VIEW DEFINITION TO [GHJHyhjghIRISICEhdskjJ432!]'
      'GO'
      'GRANT VIEW DATABASE STATE TO [GHJHyhjghIRISICEhdskjJ432!]'
      'GO'
      'SET ANSI_NULLS ON'
      'GO'
      'SET QUOTED_IDENTIFIER ON'
      'GO'
      
        'IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJEC' +
        'T_ID(N'#39'[dbo].[Contacts]'#39') AND type in (N'#39'U'#39'))'
      'BEGIN'
      'CREATE TABLE [dbo].[Contacts]('
      #9'[Id] [int] IDENTITY(1,1) NOT NULL,'
      #9'[ContactName] [varchar](255) NOT NULL,'
      #9'[ContactMail] [varchar](255) NOT NULL,'
      ' CONSTRAINT [PK_AddressBook] PRIMARY KEY CLUSTERED '
      '('
      #9'[Id] ASC'
      ')WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
      ') ON [PRIMARY]'
      'END'
      'GO'
      ''
      
        'IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJEC' +
        'T_ID(N'#39'[dbo].[Contacts]'#39') AND name = N'#39'IX_AddressBook_Mail'#39')'
      
        'CREATE NONCLUSTERED INDEX [IX_AddressBook_Mail] ON [dbo].[Contac' +
        'ts] '
      '('
      #9'[ContactMail] ASC'
      ')WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
      'GO'
      ''
      
        'IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJEC' +
        'T_ID(N'#39'[dbo].[Contacts]'#39') AND name = N'#39'IX_AddressBook_Name'#39')'
      
        'CREATE NONCLUSTERED INDEX [IX_AddressBook_Name] ON [dbo].[Contac' +
        'ts] '
      '('
      #9'[ContactName] ASC'
      ')WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
      'GO'
      'SET ANSI_NULLS ON'
      'GO'
      'SET QUOTED_IDENTIFIER ON'
      'GO'
      
        'IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJEC' +
        'T_ID(N'#39'[dbo].[ListBook]'#39') AND type in (N'#39'U'#39'))'
      'BEGIN'
      'CREATE TABLE [dbo].[ListBook]('
      #9'[Id] [int] IDENTITY(1,1) NOT NULL,'
      #9'[ListName] [varchar](255) NOT NULL'
      ') ON [PRIMARY]'
      'END'
      'GO'
      'SET ANSI_NULLS ON'
      'GO'
      'SET QUOTED_IDENTIFIER ON'
      'GO'
      
        'IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJEC' +
        'T_ID(N'#39'[dbo].[ListItems]'#39') AND type in (N'#39'U'#39'))'
      'BEGIN'
      'CREATE TABLE [dbo].[ListItems]('
      #9'[List_id] [int] NOT NULL,'
      #9'[AddressBook_Id] [int] NOT NULL,'
      ' CONSTRAINT [PK_ListItems] PRIMARY KEY CLUSTERED '
      '('
      #9'[List_id] ASC,'
      #9'[AddressBook_Id] ASC'
      ')WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
      ') ON [PRIMARY]'
      'END'
      'GO'
      'SET ANSI_NULLS ON'
      'GO'
      'SET QUOTED_IDENTIFIER ON'
      'GO'
      
        'IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJEC' +
        'T_ID(N'#39'[dbo].[System]'#39') AND type in (N'#39'U'#39'))'
      'BEGIN'
      'CREATE TABLE [dbo].[System]('
      #9'[Id] [int] IDENTITY(1,1) NOT NULL,'
      #9'[Description] [varchar](16) NOT NULL,'
      #9'[Value] [varchar](50) NOT NULL,'
      ' CONSTRAINT [PK_System] PRIMARY KEY CLUSTERED '
      '('
      #9'[Id] ASC'
      ')WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
      ') ON [PRIMARY]'
      'END'
      'GO'
      'SET ANSI_NULLS ON'
      'GO'
      'SET QUOTED_IDENTIFIER ON'
      'GO'
      
        'IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJEC' +
        'T_ID(N'#39'[dbo].[Users]'#39') AND type in (N'#39'U'#39'))'
      'BEGIN'
      'CREATE TABLE [dbo].[Users]('
      #9'[Id] [int] IDENTITY(1,1) NOT NULL,'
      #9'[UserName] [varchar](32) NOT NULL,'
      #9'[UserLogin] [varchar](32) NOT NULL,'
      #9'[Password] [varchar](16) NOT NULL,'
      ' CONSTRAINT [PK_User] PRIMARY KEY CLUSTERED '
      '('
      #9'[Id] ASC'
      ')WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
      ') ON [PRIMARY]'
      'END'
      'GO'
      ''
      
        'IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJEC' +
        'T_ID(N'#39'[dbo].[Users]'#39') AND name = N'#39'IX_Users_Login'#39')'
      
        'CREATE UNIQUE NONCLUSTERED INDEX [IX_Users_Login] ON [dbo].[User' +
        's] '
      '('
      #9'[UserLogin] ASC'
      ')WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
      'GO'
      'SET ANSI_NULLS ON'
      'GO'
      'SET QUOTED_IDENTIFIER ON'
      'GO'
      
        'IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJEC' +
        'T_ID(N'#39'[dbo].[Config]'#39') AND type in (N'#39'U'#39'))'
      'BEGIN'
      'CREATE TABLE [dbo].[Config]('
      #9'[Id] [int] IDENTITY(1,1) NOT NULL,'
      #9'[Description] [varchar](16) NOT NULL,'
      #9'[Value] [varchar](50) NOT NULL,'
      ' CONSTRAINT [PK_Config] PRIMARY KEY CLUSTERED '
      '('
      #9'[Id] ASC'
      ')WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
      ') ON [PRIMARY]'
      'END'
      'GO'
      'SET ANSI_NULLS ON'
      'GO'
      'SET QUOTED_IDENTIFIER ON'
      'GO'
      
        'IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJEC' +
        'T_ID(N'#39'[dbo].[Rules]'#39') AND type in (N'#39'U'#39'))'
      'BEGIN'
      'CREATE TABLE [dbo].[Rules]('
      #9'[Id] [int] IDENTITY(1,1) NOT NULL,'
      #9'[Description] [varchar](255) NOT NULL,'
      ' CONSTRAINT [PK_Rules] PRIMARY KEY CLUSTERED '
      '('
      #9'[Id] ASC'
      ')WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
      ') ON [PRIMARY]'
      'END'
      'GO'
      'SET ANSI_NULLS ON'
      'GO'
      'SET QUOTED_IDENTIFIER ON'
      'GO'
      
        'IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJEC' +
        'T_ID(N'#39'[dbo].[MailBoxes]'#39') AND type in (N'#39'U'#39'))'
      'BEGIN'
      'CREATE TABLE [dbo].[MailBoxes]('
      #9'[Id] [int] NOT NULL,'
      #9'[PoolingTime] [int] NOT NULL,'
      #9'[UserName] [varchar](50) NOT NULL,'
      #9'[PassWord] [varchar](50) NOT NULL,'
      #9'[Server] [varchar](255) NOT NULL,'
      #9'[Port] [int] NOT NULL,'
      #9'[Active] [bit] NOT NULL,'
      ' CONSTRAINT [PK_MailBoxes] PRIMARY KEY CLUSTERED '
      '('
      #9'[Id] ASC'
      ')WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
      ') ON [PRIMARY]'
      'END'
      'GO'
      'SET ANSI_NULLS ON'
      'GO'
      'SET QUOTED_IDENTIFIER ON'
      'GO'
      
        'IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJEC' +
        'T_ID(N'#39'[dbo].[sp_DELETE_IMPPACKAGE]'#39') AND type in (N'#39'P'#39', N'#39'PC'#39'))'
      'BEGIN'
      'EXEC dbo.sp_executesql @statement = N'#39
      ''
      ''
      ''
      'CREATE procedure [dbo].[sp_DELETE_IMPPACKAGE] '
      'as '
      'truncate table imppackage'
      ''
      ''
      ''
      #39' '
      'END'
      'GO'
      'SET ANSI_NULLS ON'
      'GO'
      'SET QUOTED_IDENTIFIER ON'
      'GO'
      
        'IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJEC' +
        'T_ID(N'#39'[dbo].[sp_DELETE_EXPPACKAGE]'#39') AND type in (N'#39'P'#39', N'#39'PC'#39'))'
      'BEGIN'
      'EXEC dbo.sp_executesql @statement = N'#39
      ''
      ''
      ''
      'CREATE procedure [dbo].[sp_DELETE_EXPPACKAGE] '
      'as '
      'truncate table exppackage'
      ''
      ''
      ''
      #39' '
      'END'
      'GO'
      'SET ANSI_NULLS ON'
      'GO'
      'SET QUOTED_IDENTIFIER ON'
      'GO'
      
        'IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJEC' +
        'T_ID(N'#39'[dbo].[ScheduleType]'#39') AND type in (N'#39'U'#39'))'
      'BEGIN'
      'CREATE TABLE [dbo].[ScheduleType]('
      #9'[Id] [int] IDENTITY(1,1) NOT NULL,'
      #9'[Description] [varchar](32) NOT NULL,'
      ' CONSTRAINT [PK_ScheduleType] PRIMARY KEY CLUSTERED '
      '('
      #9'[Id] ASC'
      ')WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
      ') ON [PRIMARY]'
      'END'
      'GO'
      'SET ANSI_NULLS ON'
      'GO'
      'SET QUOTED_IDENTIFIER ON'
      'GO'
      
        'IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJEC' +
        'T_ID(N'#39'[dbo].[ExpPackage]'#39') AND type in (N'#39'U'#39'))'
      'BEGIN'
      'CREATE TABLE [dbo].[ExpPackage]('
      #9'[Id] [int] IDENTITY(1,1) NOT NULL,'
      #9'[Company_Id] [int] NULL,'
      #9'[Description] [varchar](255) NOT NULL,'
      #9'[FileGuid] [varchar](38) NOT NULL,'
      
        #9'[UserReference] [int] NULL CONSTRAINT [DF_ExpPackage_UserRefere' +
        'nce]  DEFAULT ((0)),'
      #9'[PluginLink] [varchar](32) NOT NULL,'
      ' CONSTRAINT [PK_ExpPackage] PRIMARY KEY CLUSTERED '
      '('
      #9'[Id] ASC'
      ')WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
      ') ON [PRIMARY]'
      'END'
      'GO'
      ''
      
        'IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJEC' +
        'T_ID(N'#39'[dbo].[ExpPackage]'#39') AND name = N'#39'IX_ExpPackage_Company_I' +
        'd'#39')'
      
        'CREATE NONCLUSTERED INDEX [IX_ExpPackage_Company_Id] ON [dbo].[E' +
        'xpPackage] '
      '('
      #9'[Company_Id] ASC'
      ')WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
      'GO'
      ''
      
        'IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJEC' +
        'T_ID(N'#39'[dbo].[ExpPackage]'#39') AND name = N'#39'IX_ExpPackage_Plugin_Li' +
        'nk'#39')'
      
        'CREATE NONCLUSTERED INDEX [IX_ExpPackage_Plugin_Link] ON [dbo].[' +
        'ExpPackage] '
      '('
      #9'[PluginLink] ASC'
      ')WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
      'GO'
      ''
      
        'IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJEC' +
        'T_ID(N'#39'[dbo].[ExpPackage]'#39') AND name = N'#39'IX_PackageId'#39')'
      'CREATE NONCLUSTERED INDEX [IX_PackageId] ON [dbo].[ExpPackage] '
      '('
      #9'[UserReference] ASC'
      ')WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
      'GO'
      'SET ANSI_NULLS ON'
      'GO'
      'SET QUOTED_IDENTIFIER ON'
      'GO'
      
        'IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJEC' +
        'T_ID(N'#39'[dbo].[ImpPackage]'#39') AND type in (N'#39'U'#39'))'
      'BEGIN'
      'CREATE TABLE [dbo].[ImpPackage]('
      #9'[Id] [int] IDENTITY(1,1) NOT NULL,'
      #9'[Company_Id] [int] NULL,'
      #9'[Description] [varchar](255) NOT NULL,'
      #9'[FileGuid] [varchar](38) NOT NULL,'
      
        #9'[UserReference] [int] NULL CONSTRAINT [DF_ImpPackage_UserRefere' +
        'nce]  DEFAULT ((0)),'
      #9'[PluginLink] [varchar](32) NOT NULL,'
      ' CONSTRAINT [PK_impPackage] PRIMARY KEY CLUSTERED '
      '('
      #9'[Id] ASC'
      ')WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
      ') ON [PRIMARY]'
      'END'
      'GO'
      ''
      
        'IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJEC' +
        'T_ID(N'#39'[dbo].[ImpPackage]'#39') AND name = N'#39'IX_ImpPackage_Company_I' +
        'd'#39')'
      
        'CREATE NONCLUSTERED INDEX [IX_ImpPackage_Company_Id] ON [dbo].[I' +
        'mpPackage] '
      '('
      #9'[Company_Id] ASC'
      ')WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
      'GO'
      ''
      
        'IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJEC' +
        'T_ID(N'#39'[dbo].[ImpPackage]'#39') AND name = N'#39'IX_ImpPackage_Plugin_Li' +
        'nk'#39')'
      
        'CREATE NONCLUSTERED INDEX [IX_ImpPackage_Plugin_Link] ON [dbo].[' +
        'ImpPackage] '
      '('
      #9'[PluginLink] ASC'
      ')WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
      'GO'
      'SET ANSI_NULLS ON'
      'GO'
      'SET QUOTED_IDENTIFIER ON'
      'GO'
      
        'IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJEC' +
        'T_ID(N'#39'[dbo].[Company]'#39') AND type in (N'#39'U'#39'))'
      'BEGIN'
      'CREATE TABLE [dbo].[Company]('
      #9'[Id] [int] IDENTITY(1,1) NOT NULL,'
      #9'[ExCode] [varchar](16) NOT NULL,'
      #9'[Description] [varchar](50) NOT NULL,'
      
        #9'[Periods] [smallint] NOT NULL CONSTRAINT [DF_Company_Periods]  ' +
        'DEFAULT ((12)),'
      
        #9'[Active] [bit] NOT NULL CONSTRAINT [DF_Company_Active]  DEFAULT' +
        ' ((0)),'
      '    [Directory] [varchar] (255) NOT NULL,'
      #9'[LastUpdate] [datetime] NULL,'
      ' CONSTRAINT [PK_Company] PRIMARY KEY CLUSTERED '
      '('
      #9'[Id] ASC'
      ')WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
      ') ON [PRIMARY]'
      'END'
      'GO'
      ''
      
        'IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJEC' +
        'T_ID(N'#39'[dbo].[Company]'#39') AND name = N'#39'IX_Company_ExCode'#39')'
      
        'CREATE UNIQUE NONCLUSTERED INDEX [IX_Company_ExCode] ON [dbo].[C' +
        'ompany] '
      '('
      #9'[ExCode] ASC'
      ')WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
      'GO'
      'SET ANSI_NULLS ON'
      'GO'
      'SET QUOTED_IDENTIFIER ON'
      'GO'
      
        'IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJEC' +
        'T_ID(N'#39'[dbo].[IceLog]'#39') AND type in (N'#39'U'#39'))'
      'BEGIN'
      'CREATE TABLE [dbo].[IceLog]('
      #9'[Id] [int] IDENTITY(1,1) NOT NULL,'
      #9'[Description] [varchar](255) NOT NULL,'
      #9'[Location] [varchar](64) NULL,'
      
        #9'[LastUpdate] [datetime] NOT NULL CONSTRAINT [DF__IceLog__LastUp' +
        'da__31EC6D26]  DEFAULT ((0)),'
      'PRIMARY KEY CLUSTERED '
      '('
      #9'[Id] ASC'
      ')WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
      ') ON [PRIMARY]'
      'END'
      'GO'
      'SET ANSI_NULLS ON'
      'GO'
      'SET QUOTED_IDENTIFIER ON'
      'GO'
      
        'IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJEC' +
        'T_ID(N'#39'[dbo].[Schedule]'#39') AND type in (N'#39'U'#39'))'
      'BEGIN'
      'CREATE TABLE [dbo].[Schedule]('
      #9'[Id] [int] IDENTITY(1,1) NOT NULL,'
      #9'[Outbox_Id] [int] NOT NULL,'
      #9'[Outbox_Guid] [varchar](38) NOT NULL,'
      #9'[ScheduleType_Id] [int] NOT NULL,'
      ' CONSTRAINT [PK_Schedule] PRIMARY KEY CLUSTERED '
      '('
      #9'[Id] ASC'
      ')WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
      ') ON [PRIMARY]'
      'END'
      'GO'
      ''
      
        'IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJEC' +
        'T_ID(N'#39'[dbo].[Schedule]'#39') AND name = N'#39'IX_Schedule_Outbox_Guid'#39')'
      
        'CREATE NONCLUSTERED INDEX [IX_Schedule_Outbox_Guid] ON [dbo].[Sc' +
        'hedule] '
      '('
      #9'[Outbox_Guid] ASC'
      ')WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
      'GO'
      ''
      
        'IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJEC' +
        'T_ID(N'#39'[dbo].[Schedule]'#39') AND name = N'#39'IX_Schedule_Schedule_Type' +
        #39')'
      
        'CREATE NONCLUSTERED INDEX [IX_Schedule_Schedule_Type] ON [dbo].[' +
        'Schedule] '
      '('
      #9'[ScheduleType_Id] ASC'
      ')WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
      'GO'
      'SET ANSI_NULLS ON'
      'GO'
      'SET QUOTED_IDENTIFIER ON'
      'GO'
      
        'IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJEC' +
        'T_ID(N'#39'[dbo].[UserRule]'#39') AND type in (N'#39'U'#39'))'
      'BEGIN'
      'CREATE TABLE [dbo].[UserRule]('
      #9'[Id] [int] IDENTITY(1,1) NOT NULL,'
      #9'[User_Id] [int] NOT NULL,'
      #9'[Rule_Id] [int] NOT NULL,'
      ' CONSTRAINT [PK_UserRole] PRIMARY KEY CLUSTERED '
      '('
      #9'[Id] ASC'
      ')WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
      ') ON [PRIMARY]'
      'END'
      'GO'
      'SET ANSI_NULLS ON'
      'GO'
      'SET QUOTED_IDENTIFIER ON'
      'GO'
      
        'IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJEC' +
        'T_ID(N'#39'[dbo].[DaySchedule]'#39') AND type in (N'#39'U'#39'))'
      'BEGIN'
      'CREATE TABLE [dbo].[DaySchedule]('
      #9'[Id] [int] IDENTITY(1,1) NOT NULL,'
      #9'[Schedule_Id] [int] NOT NULL,'
      #9'[StartDate] [datetime] NOT NULL,'
      #9'[EndDate] [datetime] NOT NULL,'
      #9'[StartTime] [datetime] NOT NULL,'
      
        #9'[AllDays] [bit] NULL CONSTRAINT [DF_DaySchedule_AllDays]  DEFAU' +
        'LT ((0)),'
      
        #9'[WeekDays] [bit] NULL CONSTRAINT [DF_DaySchedule_WeekDays]  DEF' +
        'AULT ((0)),'
      #9'[Everyday] [smallint] NULL,'
      ' CONSTRAINT [PK_DaySchedule] PRIMARY KEY CLUSTERED '
      '('
      #9'[Id] ASC'
      ')WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
      ') ON [PRIMARY]'
      'END'
      'GO'
      ''
      
        'IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJEC' +
        'T_ID(N'#39'[dbo].[DaySchedule]'#39') AND name = N'#39'IX_DaySchedule_Shcedul' +
        'e_Id'#39')'
      
        'CREATE NONCLUSTERED INDEX [IX_DaySchedule_Shcedule_Id] ON [dbo].' +
        '[DaySchedule] '
      '('
      #9'[Schedule_Id] ASC'
      ')WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
      'GO'
      'SET ANSI_NULLS ON'
      'GO'
      'SET QUOTED_IDENTIFIER ON'
      'GO'
      
        'IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJEC' +
        'T_ID(N'#39'[dbo].[MonthSchedule]'#39') AND type in (N'#39'U'#39'))'
      'BEGIN'
      'CREATE TABLE [dbo].[MonthSchedule]('
      #9'[Id] [int] IDENTITY(1,1) NOT NULL,'
      #9'[Schedule_Id] [int] NOT NULL,'
      #9'[Day] [smallint] NOT NULL,'
      #9'[StartTime] [datetime] NOT NULL,'
      #9'[EndDate] [datetime] NOT NULL,'
      
        #9'[Jan] [bit] NULL CONSTRAINT [DF_MonthlySchedule_Jan]  DEFAULT (' +
        '(0)),'
      
        #9'[Feb] [bit] NULL CONSTRAINT [DF_MonthlySchedule_Feb]  DEFAULT (' +
        '(0)),'
      
        #9'[Mar] [bit] NULL CONSTRAINT [DF_MonthlySchedule_Mar]  DEFAULT (' +
        '(0)),'
      
        #9'[Apr] [bit] NULL CONSTRAINT [DF_MonthlySchedule_Apr]  DEFAULT (' +
        '(0)),'
      
        #9'[May] [bit] NULL CONSTRAINT [DF_MonthlySchedule_May]  DEFAULT (' +
        '(0)),'
      
        #9'[Jun] [bit] NULL CONSTRAINT [DF_MonthlySchedule_Jun]  DEFAULT (' +
        '(0)),'
      
        #9'[Jul] [bit] NULL CONSTRAINT [DF_MonthlySchedule_Jul]  DEFAULT (' +
        '(0)),'
      
        #9'[Aug] [bit] NULL CONSTRAINT [DF_MonthlySchedule_Aug]  DEFAULT (' +
        '(0)),'
      
        #9'[Sep] [bit] NULL CONSTRAINT [DF_MonthlySchedule_Sep]  DEFAULT (' +
        '(0)),'
      
        #9'[Oct] [bit] NULL CONSTRAINT [DF_MonthlySchedule_Oct]  DEFAULT (' +
        '(0)),'
      
        #9'[Nov] [bit] NULL CONSTRAINT [DF_MonthlySchedule_Nov]  DEFAULT (' +
        '(0)),'
      
        #9'[Dec] [bit] NULL CONSTRAINT [DF_MonthlySchedule_Dec]  DEFAULT (' +
        '(0)),'
      ' CONSTRAINT [PK_MonthlySchedule] PRIMARY KEY CLUSTERED '
      '('
      #9'[Id] ASC'
      ')WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
      ') ON [PRIMARY]'
      'END'
      'GO'
      ''
      
        'IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJEC' +
        'T_ID(N'#39'[dbo].[MonthSchedule]'#39') AND name = '
      'N'#39'IX_MonthlySchedule_Shcedule_Id'#39')'
      
        'CREATE NONCLUSTERED INDEX [IX_MonthlySchedule_Shcedule_Id] ON [d' +
        'bo].[MonthSchedule] '
      '('
      #9'[Schedule_Id] ASC'
      ')WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
      'GO'
      'SET ANSI_NULLS ON'
      'GO'
      'SET QUOTED_IDENTIFIER ON'
      'GO'
      
        'IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJEC' +
        'T_ID(N'#39'[dbo].[OneTimeSchedule]'#39') AND type in (N'#39'U'#39'))'
      'BEGIN'
      'CREATE TABLE [dbo].[OneTimeSchedule]('
      #9'[Id] [int] IDENTITY(1,1) NOT NULL,'
      #9'[Schedule_Id] [int] NOT NULL,'
      #9'[StartDate] [datetime] NOT NULL,'
      #9'[StartTime] [datetime] NOT NULL,'
      #9'[Process] [bit] NOT NULL,'
      ' CONSTRAINT [PK_OneTimeSchedule] PRIMARY KEY CLUSTERED '
      '('
      #9'[Id] ASC'
      ')WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
      ') ON [PRIMARY]'
      'END'
      'GO'
      ''
      
        'IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJEC' +
        'T_ID(N'#39'[dbo].[OneTimeSchedule]'#39') AND name = '
      'N'#39'IX_OneTimeSchedule_Schedule_Id'#39')'
      
        'CREATE NONCLUSTERED INDEX [IX_OneTimeSchedule_Schedule_Id] ON [d' +
        'bo].[OneTimeSchedule] '
      '('
      #9'[Schedule_Id] ASC'
      ')WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
      'GO'
      'SET ANSI_NULLS ON'
      'GO'
      'SET QUOTED_IDENTIFIER ON'
      'GO'
      
        'IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJEC' +
        'T_ID(N'#39'[dbo].[WeekSchedule]'#39') AND type in (N'#39'U'#39'))'
      'BEGIN'
      'CREATE TABLE [dbo].[WeekSchedule]('
      #9'[Id] [int] IDENTITY(1,1) NOT NULL,'
      #9'[Schedule_Id] [int] NOT NULL,'
      #9'[EveryWeek] [smallint] NOT NULL,'
      #9'[StartTime] [datetime] NOT NULL,'
      #9'[EndDate] [datetime] NOT NULL,'
      
        #9'[Monday] [bit] NULL CONSTRAINT [DF_WeekSchedule_Monday]  DEFAUL' +
        'T ((0)),'
      
        #9'[Tuesday] [bit] NULL CONSTRAINT [DF_WeekSchedule_Tuesday]  DEFA' +
        'ULT ((0)),'
      
        #9'[Wednesday] [bit] NULL CONSTRAINT [DF_WeekSchedule_Wednesday]  ' +
        'DEFAULT ((0)),'
      
        #9'[Thursday] [bit] NULL CONSTRAINT [DF_WeekSchedule_Thursday]  DE' +
        'FAULT ((0)),'
      
        #9'[Friday] [bit] NULL CONSTRAINT [DF_WeekSchedule_Friday]  DEFAUL' +
        'T ((0)),'
      
        #9'[Saturday] [bit] NULL CONSTRAINT [DF_WeekSchedule_Saturday]  DE' +
        'FAULT ((0)),'
      
        #9'[Sunday] [bit] NULL CONSTRAINT [DF_WeekSchedule_Sunday]  DEFAUL' +
        'T ((0)),'
      ' CONSTRAINT [PK_WeekSchedule_1] PRIMARY KEY CLUSTERED '
      '('
      #9'[Id] ASC'
      ')WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
      ') ON [PRIMARY]'
      'END'
      'GO'
      ''
      
        'IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJEC' +
        'T_ID(N'#39'[dbo].[WeekSchedule]'#39') AND name = N'#39'IX_WeekSchedule_Shced' +
        'ule_Id'#39')'
      
        'CREATE NONCLUSTERED INDEX [IX_WeekSchedule_Shcedule_Id] ON [dbo]' +
        '.[WeekSchedule] '
      '('
      #9'[Schedule_Id] ASC'
      ')WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
      'GO'
      'SET ANSI_NULLS ON'
      'GO'
      'SET QUOTED_IDENTIFIER ON'
      'GO'
      
        'IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJEC' +
        'T_ID(N'#39'[dbo].[Outbox]'#39') AND type in (N'#39'U'#39'))'
      'BEGIN'
      'CREATE TABLE [dbo].[Outbox]('
      #9'[Id] [int] IDENTITY(1,1) NOT NULL,'
      #9'[Guid] [varchar](38) NOT NULL,'
      
        #9'[Company_Id] [int] NOT NULL CONSTRAINT [DF_Outbox_Company_Id]  ' +
        'DEFAULT ((0)),'
      #9'[Subject] [varchar](255) NOT NULL,'
      #9'[UserFrom] [varchar](255) NOT NULL,'
      #9'[UserTo] [varchar](255) NOT NULL,'
      
        #9'[Package_Id] [int] NOT NULL CONSTRAINT [DF__Outbox__MessageT__0' +
        'EA330E9]  DEFAULT ((0)),'
      
        #9'[Status] [tinyint] NOT NULL CONSTRAINT [DF__Outbox__Status__0F9' +
        '75522]  DEFAULT ((0)),'
      #9'[Param1] [varchar](50) NULL,'
      #9'[Param2] [varchar](50) NULL,'
      
        #9'[TotalItems] [smallint] NOT NULL CONSTRAINT [DF__Outbox__TotalI' +
        'te__300424B4]  DEFAULT ((0)),'
      #9'[IrMark] [varchar](30) NULL,'
      
        #9'[Sent] [datetime] NOT NULL CONSTRAINT [DF__Outbox__LastUpda__32' +
        'E0915F]  DEFAULT ((0)),'
      
        #9'[Mode] [smallint] NULL CONSTRAINT [DF_Outbox_Mode]  DEFAULT ((-' +
        '1)),'
      #9'[LastUpdate] [datetime] NULL,'
      ' CONSTRAINT [PK_Outbox_1] PRIMARY KEY CLUSTERED '
      '('
      #9'[Id] ASC,'
      #9'[Guid] ASC'
      ')WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
      ') ON [PRIMARY]'
      'END'
      'GO'
      ''
      
        'IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJEC' +
        'T_ID(N'#39'[dbo].[Outbox]'#39') AND name = N'#39'IX_Outbox_Company_Id'#39')'
      
        'CREATE NONCLUSTERED INDEX [IX_Outbox_Company_Id] ON [dbo].[Outbo' +
        'x] '
      '('
      #9'[Company_Id] ASC'
      ')WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
      'GO'
      ''
      
        'IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJEC' +
        'T_ID(N'#39'[dbo].[Outbox]'#39') AND name = N'#39'IX_Outbox_Sent'#39')'
      'CREATE NONCLUSTERED INDEX [IX_Outbox_Sent] ON [dbo].[Outbox] '
      '('
      #9'[Sent] ASC'
      ')WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
      'GO'
      'SET ANSI_NULLS ON'
      'GO'
      'SET QUOTED_IDENTIFIER ON'
      'GO'
      
        'IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJEC' +
        'T_ID(N'#39'[dbo].[Inbox]'#39') AND type in (N'#39'U'#39'))'
      'BEGIN'
      'CREATE TABLE [dbo].[Inbox]('
      #9'[Id] [int] IDENTITY(1,1) NOT NULL,'
      #9'[Guid] [varchar](38) NOT NULL,'
      
        #9'[Company_Id] [int] NOT NULL CONSTRAINT [DF_Inbox_Company_Id]  D' +
        'EFAULT ((0)),'
      #9'[Subject] [varchar](255) NOT NULL,'
      #9'[UserFrom] [varchar](255) NOT NULL,'
      #9'[UserTo] [varchar](255) NOT NULL,'
      #9'[Package_Id] [int] NOT NULL,'
      #9'[TotalItems] [smallint] NOT NULL,'
      #9'[Status] [tinyint] NOT NULL,'
      
        #9'[Received] [datetime] NOT NULL CONSTRAINT [DF__Inbox__LastUpdat' +
        '__30F848ED]  DEFAULT ((0)),'
      
        #9'[Mode] [smallint] NULL CONSTRAINT [DF_Inbox_Mode]  DEFAULT ((-1' +
        ')),'
      #9'[LastUpdate] [datetime] NULL,'
      ' CONSTRAINT [PK_Inbox_1] PRIMARY KEY CLUSTERED '
      '('
      #9'[Id] ASC,'
      #9'[Guid] ASC'
      ')WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
      ') ON [PRIMARY]'
      'END'
      'GO'
      ''
      
        'IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJEC' +
        'T_ID(N'#39'[dbo].[Inbox]'#39') AND name = N'#39'IX_Inbox_CompanyId'#39')'
      'CREATE NONCLUSTERED INDEX [IX_Inbox_CompanyId] ON [dbo].[Inbox] '
      '('
      #9'[Company_Id] ASC'
      ')WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
      'GO'
      ''
      
        'IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJEC' +
        'T_ID(N'#39'[dbo].[Inbox]'#39') AND name = N'#39'IX_Inbox_Received'#39')'
      'CREATE NONCLUSTERED INDEX [IX_Inbox_Received] ON [dbo].[Inbox] '
      '('
      #9'[Received] ASC'
      ')WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
      'GO'
      'SET ANSI_NULLS ON'
      'GO'
      'SET QUOTED_IDENTIFIER ON'
      'GO'
      
        'IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJEC' +
        'T_ID(N'#39'[dbo].[sp_DELETE_ICELOG]'#39') AND type in (N'#39'P'#39', N'#39'PC'#39'))'
      'BEGIN'
      'EXEC dbo.sp_executesql @statement = N'#39
      ''
      ''
      ''
      'CREATE procedure [dbo].[sp_DELETE_ICELOG] @pDays int'
      'as '
      
        'delete from icelog where lastupdate <  DATEADD(dd, - @pDays, GET' +
        'DATE())'
      ''
      ''
      ''
      #39' '
      'END'
      'GO'
      'SET ANSI_NULLS ON'
      'GO'
      'SET QUOTED_IDENTIFIER ON'
      'GO'
      
        'IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJEC' +
        'T_ID(N'#39'[dbo].[sp_UPDATE_ICELOG]'#39') AND type in (N'#39'P'#39', N'#39'PC'#39'))'
      'BEGIN'
      'EXEC dbo.sp_executesql @statement = N'#39
      ''
      
        'create procedure [dbo].[sp_UPDATE_ICELOG] @pDesc varchar(255), @' +
        'pLocation varchar(64)'
      'as '
      ''
      'if (@pDesc <> '#39#39#39#39') and (@pLocation <> '#39#39#39#39')'
      
        '  insert into icelog (description, location, lastupdate) values ' +
        '(@pDesc, @pLocation, getdate()) '#39' '
      'END'
      'GO'
      'USE [IrisCommunicationEngine]'
      'GO'
      'USE [IrisCommunicationEngine]'
      'GO'
      'USE [IrisCommunicationEngine]'
      'GO'
      'USE [IrisCommunicationEngine]'
      'GO'
      'USE [IrisCommunicationEngine]'
      'GO'
      'USE [IrisCommunicationEngine]'
      'GO'
      'USE [IrisCommunicationEngine]'
      'GO'
      'USE [IrisCommunicationEngine]'
      'GO'
      
        'IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = ' +
        'OBJECT_ID(N'#39'[dbo].[FK_Schedule_Outbox]'#39') AND parent_object_id = '
      'OBJECT_ID(N'#39'[dbo].[Schedule]'#39'))'
      
        'ALTER TABLE [dbo].[Schedule]  WITH CHECK ADD  CONSTRAINT [FK_Sch' +
        'edule_Outbox] FOREIGN KEY([Outbox_Id], [Outbox_Guid])'
      'REFERENCES [dbo].[Outbox] ([Id], [Guid])'
      'ON DELETE CASCADE'
      'GO'
      
        'IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = ' +
        'OBJECT_ID(N'#39'[dbo].[FK_Schedule_ScheduleType]'#39') AND parent_object' +
        '_id = '
      'OBJECT_ID(N'#39'[dbo].[Schedule]'#39'))'
      
        'ALTER TABLE [dbo].[Schedule]  WITH CHECK ADD  CONSTRAINT [FK_Sch' +
        'edule_ScheduleType] FOREIGN KEY([ScheduleType_Id])'
      'REFERENCES [dbo].[ScheduleType] ([Id])'
      'GO'
      
        'IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = ' +
        'OBJECT_ID(N'#39'[dbo].[FK_UserRule_Rules]'#39') AND parent_object_id = '
      'OBJECT_ID(N'#39'[dbo].[UserRule]'#39'))'
      
        'ALTER TABLE [dbo].[UserRule]  WITH CHECK ADD  CONSTRAINT [FK_Use' +
        'rRule_Rules] FOREIGN KEY([Rule_Id])'
      'REFERENCES [dbo].[Rules] ([Id])'
      'GO'
      
        'IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = ' +
        'OBJECT_ID(N'#39'[dbo].[FK_UserRule_User]'#39') AND parent_object_id = '
      'OBJECT_ID(N'#39'[dbo].[UserRule]'#39'))'
      
        'ALTER TABLE [dbo].[UserRule]  WITH CHECK ADD  CONSTRAINT [FK_Use' +
        'rRule_User] FOREIGN KEY([User_Id])'
      'REFERENCES [dbo].[Users] ([Id])'
      'ON DELETE CASCADE'
      'GO'
      
        'IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = ' +
        'OBJECT_ID(N'#39'[dbo].[FK_DaySchedule_Schedule]'#39') AND parent_object_' +
        'id = '
      'OBJECT_ID(N'#39'[dbo].[DaySchedule]'#39'))'
      
        'ALTER TABLE [dbo].[DaySchedule]  WITH CHECK ADD  CONSTRAINT [FK_' +
        'DaySchedule_Schedule] FOREIGN KEY([Schedule_Id])'
      'REFERENCES [dbo].[Schedule] ([Id])'
      'ON DELETE CASCADE'
      'GO'
      
        'IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = ' +
        'OBJECT_ID(N'#39'[dbo].[FK_MonthSchedule_Schedule]'#39') AND parent_objec' +
        't_id = '
      'OBJECT_ID(N'#39'[dbo].[MonthSchedule]'#39'))'
      
        'ALTER TABLE [dbo].[MonthSchedule]  WITH CHECK ADD  CONSTRAINT [F' +
        'K_MonthSchedule_Schedule] FOREIGN KEY([Schedule_Id])'
      'REFERENCES [dbo].[Schedule] ([Id])'
      'ON DELETE CASCADE'
      'GO'
      
        'IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = ' +
        'OBJECT_ID(N'#39'[dbo].[FK_OneTimeSchedule_Schedule]'#39') AND parent_obj' +
        'ect_id = '
      'OBJECT_ID(N'#39'[dbo].[OneTimeSchedule]'#39'))'
      
        'ALTER TABLE [dbo].[OneTimeSchedule]  WITH CHECK ADD  CONSTRAINT ' +
        '[FK_OneTimeSchedule_Schedule] FOREIGN KEY([Schedule_Id])'
      'REFERENCES [dbo].[Schedule] ([Id])'
      'ON DELETE CASCADE'
      'GO'
      
        'IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = ' +
        'OBJECT_ID(N'#39'[dbo].[FK_WeekSchedule_Schedule]'#39') AND parent_object' +
        '_id = '
      'OBJECT_ID(N'#39'[dbo].[WeekSchedule]'#39'))'
      
        'ALTER TABLE [dbo].[WeekSchedule]  WITH CHECK ADD  CONSTRAINT [FK' +
        '_WeekSchedule_Schedule] FOREIGN KEY([Schedule_Id])'
      'REFERENCES [dbo].[Schedule] ([Id])'
      'ON DELETE CASCADE'
      'GO')
    TabOrder = 1
  end
end
