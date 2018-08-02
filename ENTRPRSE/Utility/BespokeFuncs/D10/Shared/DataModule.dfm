object SQLDataModule: TSQLDataModule
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Left = 285
  Top = 267
  Height = 417
  Width = 729
  object ADOConnectionBespoke: TADOConnection
    KeepConnection = False
    LoginPrompt = False
    Provider = 'SQLOLEDB.1'
    Left = 208
    Top = 24
  end
  object ADOConnection_Create: TADOConnection
    LoginPrompt = False
    Provider = 'SQLOLEDB.1'
    Left = 640
    Top = 248
  end
  object qCreateTables: TADOQuery
    Connection = ADOConnection_Create
    Parameters = <>
    SQL.Strings = (
      'SET ANSI_NULLS ON'
      'GO'
      'SET QUOTED_IDENTIFIER ON'
      'GO'
      
        'IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJEC' +
        'T_ID(N'#39'[dbo].[Discount]'#39') AND type in (N'#39'U'#39'))'
      'BEGIN'
      'CREATE TABLE [dbo].[Discount]('
      #9'[diFolioNo] [int] IDENTITY(1,1) NOT NULL,'
      #9'[diCompanyCode] [varchar](6) NOT NULL,'
      #9'[diDiscountGroup] [varchar](20) NOT NULL,'
      #9'[diBand] [char](1) NOT NULL,'
      #9'[diQtyFrom] [float] NOT NULL,'
      #9'[diDiscountPercent] [decimal](5, 2) NOT NULL,'
      ' CONSTRAINT [PK_Discount] PRIMARY KEY CLUSTERED '
      '('
      #9'[diFolioNo] ASC'
      
        ')WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_D' +
        'UP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON ' +
        '[PRIMARY]'
      ') ON [PRIMARY]'
      'END'
      'GO')
    Left = 648
    Top = 304
  end
  object qTableExists: TADOQuery
    Connection = ADOConnectionBespoke
    Parameters = <
      item
        Name = 'TableName'
        Size = -1
        Value = Null
      end>
    SQL.Strings = (
      
        'IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID' +
        '(:TableName) AND type in (N'#39'U'#39'))'
      'BEGIN'
      #9'SELECT 1'
      'END'
      'ELSE'
      'BEGIN'
      #9'SELECT 0'
      'END')
    Left = 208
    Top = 96
  end
  object qDatabaseExists: TADOQuery
    Connection = ADOConnectionStandard
    Parameters = <
      item
        Name = 'DatabaseName'
        Size = -1
        Value = Null
      end>
    SQL.Strings = (
      
        'IF EXISTS (select * from sys.databases WHERE database_id = DB_ID' +
        '(:DatabaseName))'
      'BEGIN'
      #9'SELECT 1'
      'END'
      'ELSE'
      'BEGIN'
      #9'SELECT 0'
      'END')
    Left = 56
    Top = 96
  end
  object qFillList: TADOQuery
    Connection = ADOConnectionBespoke
    CursorType = ctStatic
    Parameters = <
      item
        Name = 'CompanyCode'
        DataType = ftString
        NumericScale = 255
        Precision = 255
        Size = 6
        Value = Null
      end>
    SQL.Strings = (
      'select * from discount where diCompanyCode = :CompanyCode'
      'order by diDiscountGroup, diBand, diQtyFrom')
    Left = 560
    Top = 104
  end
  object qAddDiscount: TADOQuery
    Connection = ADOConnectionBespoke
    CursorType = ctStatic
    Parameters = <
      item
        Name = 'diCompanyCode'
        DataType = ftString
        NumericScale = 255
        Precision = 255
        Size = 6
        Value = Null
      end
      item
        Name = 'diDiscountGroup'
        Size = -1
        Value = Null
      end
      item
        Name = 'diBand'
        DataType = ftString
        NumericScale = 255
        Precision = 255
        Size = 1
        Value = Null
      end
      item
        Name = 'diQtyFrom'
        Attributes = [paSigned]
        DataType = ftFloat
        NumericScale = 255
        Precision = 15
        Size = 8
        Value = Null
      end
      item
        Name = 'diDiscountPercent'
        Attributes = [paSigned]
        DataType = ftBCD
        NumericScale = 2
        Precision = 5
        Size = 19
        Value = Null
      end>
    SQL.Strings = (
      
        'insert into Discount (diCompanyCode, diDiscountGroup, diBand, di' +
        'QtyFrom, diDiscountPercent) '
      
        'values (:diCompanyCode, :diDiscountGroup, :diBand, :diQtyFrom, :' +
        'diDiscountPercent)')
    Left = 560
    Top = 152
  end
  object qEditDiscount: TADOQuery
    Connection = ADOConnectionBespoke
    CursorType = ctStatic
    Parameters = <
      item
        Name = 'diCompanyCode'
        DataType = ftString
        NumericScale = 255
        Precision = 255
        Size = 6
        Value = Null
      end
      item
        Name = 'diDiscountGroup'
        Size = -1
        Value = Null
      end
      item
        Name = 'diBand'
        DataType = ftString
        NumericScale = 255
        Precision = 255
        Size = 1
        Value = Null
      end
      item
        Name = 'diQtyFrom'
        Attributes = [paSigned]
        DataType = ftFloat
        NumericScale = 255
        Precision = 15
        Size = 8
        Value = Null
      end
      item
        Name = 'diDiscountPercent'
        Attributes = [paSigned]
        DataType = ftBCD
        NumericScale = 2
        Precision = 5
        Size = 19
        Value = Null
      end
      item
        Name = 'diFolioNo'
        Attributes = [paSigned]
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end>
    SQL.Strings = (
      'update Discount '
      'set '
      'diCompanyCode = :diCompanyCode,'
      'diDiscountGroup = :diDiscountGroup,'
      'diBand = :diBand, '
      'diQtyFrom = :diQtyFrom, '
      'diDiscountPercent = :diDiscountPercent'
      'where (diFolioNo = :diFolioNo)')
    Left = 560
    Top = 208
  end
  object qDeleteDiscount: TADOQuery
    Connection = ADOConnectionBespoke
    CursorType = ctStatic
    Parameters = <
      item
        Name = 'diFolioNo'
        Attributes = [paSigned]
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end>
    SQL.Strings = (
      'Delete from Discount '
      'where (diFolioNo = :diFolioNo)')
    Left = 560
    Top = 256
  end
  object qDiscountClash: TADOQuery
    Connection = ADOConnectionBespoke
    CursorType = ctStatic
    Parameters = <
      item
        Name = 'CompanyCode'
        DataType = ftString
        NumericScale = 255
        Precision = 255
        Size = 6
        Value = Null
      end
      item
        Name = 'DiscountGroup'
        Size = -1
        Value = Null
      end
      item
        Name = 'Band'
        DataType = ftString
        NumericScale = 255
        Precision = 255
        Size = 1
        Value = Null
      end
      item
        Name = 'CurrentFolioNo'
        Attributes = [paSigned]
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end
      item
        Name = 'QtyFrom'
        Size = -1
        Value = Null
      end>
    SQL.Strings = (
      'select count(*) from discount'
      'where'
      ''
      '(diCompanyCode = :CompanyCode)'
      'and (diDiscountGroup = :DiscountGroup)'
      'and (diBand = :Band)'
      'and (diFolioNo <> :CurrentFolioNo)'
      'and (diQtyFrom = :QtyFrom) '
      '')
    Left = 560
    Top = 304
  end
  object ADOConnectionAdmin: TADOConnection
    KeepConnection = False
    Provider = 'SQLOLEDB.1'
    Left = 360
    Top = 24
  end
  object ADOConnectionStandard: TADOConnection
    KeepConnection = False
    LoginPrompt = False
    Provider = 'SQLOLEDB.1'
    Left = 56
    Top = 24
  end
  object qCreateBespokeUser: TADOQuery
    Parameters = <>
    SQL.Strings = (
      'USE [ExchBespoke_EXCHDEMULT000216]'
      'GO'
      'CREATE USER [ExchBespokeUser_RO] FOR LOGIN [ExchBespokeUser_RO]'
      'GO'
      'USE [ExchBespoke_EXCHDEMULT000216]'
      'GO'
      'EXEC sp_addrolemember N'#39'db_datareader'#39', N'#39'ExchBespokeUser_RO'#39
      'GO')
    Left = 632
    Top = 32
  end
  object qCreateExchUser: TADOQuery
    Parameters = <>
    SQL.Strings = (
      'USE [Exchequer601]'
      'GO'
      
        'CREATE USER [ExchBespokeUser_RO] FOR LOGIN [ExchBespokeUser_RO] ' +
        'WITH DEFAULT_SCHEMA=[dbo]')
    Left = 632
    Top = 88
  end
  object qCreateDatabase: TADOQuery
    Connection = ADOConnectionAdmin
    Parameters = <
      item
        Name = 'DatabaseName'
        Size = -1
        Value = Null
      end>
    SQL.Strings = (
      'CREATE DATABASE')
    Left = 360
    Top = 96
  end
  object qDeleteDatabase: TADOQuery
    Connection = ADOConnectionAdmin
    Parameters = <
      item
        Name = 'DatabaseName'
        Size = -1
        Value = Null
      end>
    SQL.Strings = (
      'DROP DATABASE')
    Left = 360
    Top = 152
  end
  object qLoginExists: TADOQuery
    Connection = ADOConnectionStandard
    Parameters = <
      item
        Name = 'Login'
        Size = -1
        Value = Null
      end>
    SQL.Strings = (
      'select (SUSER_SID(:Login))')
    Left = 56
    Top = 152
  end
  object qUserExists: TADOQuery
    Connection = ADOConnectionBespoke
    Parameters = <
      item
        Name = 'User'
        Size = -1
        Value = Null
      end>
    SQL.Strings = (
      'select (USER_ID(:User))')
    Left = 208
    Top = 152
  end
  object qCreateLogin: TADOQuery
    Connection = ADOConnectionAdmin
    Parameters = <
      item
        Name = 'Login'
        Size = -1
        Value = Null
      end
      item
        Name = 'Password'
        Size = -1
        Value = Null
      end>
    SQL.Strings = (
      'CREATE LOGIN [:Login ]'
      'WITH PASSWORD=:Password'
      ', DEFAULT_DATABASE=[master]'
      ', CHECK_EXPIRATION=OFF'
      ', CHECK_POLICY=ON'
      '')
    Left = 360
    Top = 216
  end
  object qCreateUserDatabase: TADOQuery
    Connection = ADOConnectionAdmin
    Parameters = <
      item
        Name = 'Login'
        Size = -1
        Value = Null
      end
      item
        Name = 'Password'
        Size = -1
        Value = Null
      end>
    SQL.Strings = (
      'CREATE LOGIN [:Login ]'
      'WITH PASSWORD=:Password'
      ', DEFAULT_DATABASE=[master]'
      ', CHECK_EXPIRATION=OFF'
      ', CHECK_POLICY=ON'
      '')
    Left = 360
    Top = 272
  end
  object qSQL: TADOQuery
    Connection = ADOConnectionAdmin
    Parameters = <>
    Left = 360
    Top = 320
  end
end
