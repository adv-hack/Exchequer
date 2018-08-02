object WRData: TWRData
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Left = 277
  Top = 153
  Height = 269
  Width = 417
  object WRDB: TPvSqlDatabase
    AliasName = 'SecAdmin'
    DatabaseName = 'WRDB'
    LoginPrompt = False
    LoginPromptOnlyIfNecessary = False
    Params.Strings = (
      'USER NAME=Master'
      'PASSWORD=XYs!viw')
    SessionName = 'WRSession_1'
    Left = 112
    Top = 24
  end
  object WRSession: TPvSqlSession
    Active = True
    AutoSessionName = True
    Left = 32
    Top = 24
  end
  object qyPrimary: TPvQuery
    DatabaseName = 'WRDB'
    SessionName = 'WRSession_1'
    Params = <>
    Left = 192
    Top = 24
  end
  object qyUserGroups: TPvQuery
    DatabaseName = 'WRDB'
    SessionName = 'WRSession_1'
    Params = <>
    Left = 32
    Top = 96
  end
  object qyCustomers: TPvQuery
    DatabaseName = 'WRDB'
    SessionName = 'WRSession_1'
    Params = <>
    Left = 112
    Top = 96
  end
  object qyESNs: TPvQuery
    DatabaseName = 'WRDB'
    SessionName = 'WRSession_1'
    SQL.Strings = (
      'select * from ESNs'
      'where custid = :pcustid'
      'and active = 1')
    Params = <
      item
        DataType = ftUnknown
        Name = 'pcustid'
        ParamType = ptUnknown
      end>
    Left = 192
    Top = 96
  end
  object qyAuditLog: TPvQuery
    DatabaseName = 'WRDB'
    SessionName = 'WRSession_1'
    SQL.Strings = (
      'insert into auditlog'
      
        '(userid, dealerid, custid, esnid, codeid, secdate, fullrelease, ' +
        'counts, auditstamp)'
      'values'
      
        '(:puserid, :pdealerid, :pcustid, :pesnid, :pcodeid, :psecdate, :' +
        'pfullrelease, :pcounts, :pauditstamp)')
    Params = <
      item
        DataType = ftUnknown
        Name = 'puserid'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'pdealerid'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'pcustid'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'pesnid'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'pcodeid'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'psecdate'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'pfullrelease'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'pcounts'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'pauditstamp'
        ParamType = ptUnknown
      end>
    Left = 268
    Top = 95
  end
  object qySecondary: TPvQuery
    DatabaseName = 'WRDB'
    SessionName = 'WRSession_1'
    Params = <>
    Left = 268
    Top = 24
  end
  object qyTertiary: TPvQuery
    DatabaseName = 'WRDB'
    SessionName = 'WRSession_1'
    Params = <>
    Left = 340
    Top = 24
  end
  object SMTPer: TIdSMTP
    Host = '127.0.0.1'
    Left = 32
    Top = 168
  end
  object msgMain: TIdMessage
    Body.Strings = (
      'See attached file')
    BccList = <>
    CCList = <>
    From.Address = 'wradmin@exchequer-secure.com'
    From.Name = 'Exchequer Release Codes'
    From.Text = 'Exchequer Release Codes <wradmin@exchequer-secure.com>'
    Recipients = <
      item
        Address = 'ebus@exchequer.com'
        Name = 'EBus Imports'
        Text = 'EBus Imports <ebus@exchequer.com>'
      end>
    ReplyTo = <>
    Sender.Address = 'wradmin@exchequer-secure.com'
    Sender.Name = 'Exchequer Release Codes'
    Sender.Text = 'Exchequer Release Codes <wradmin@exchequer-secure.com>'
    Left = 112
    Top = 168
  end
  object qyAudit: TPvQuery
    DatabaseName = 'WRDB'
    SessionName = 'WRSession_1'
    Params = <>
    Left = 188
    Top = 168
  end
  object qyAuditGrid: TPvQuery
    DatabaseName = 'WRDB'
    SessionName = 'WRSession_1'
    Params = <>
    Left = 268
    Top = 168
  end
  object dsAudit: TDataSource
    DataSet = qyAuditGrid
    Left = 340
    Top = 168
  end
  object qyAdminLog: TPvQuery
    DatabaseName = 'WRDB'
    SessionName = 'WRSession_1'
    SQL.Strings = (
      'insert into adminlog'
      '(idadministered, idtype, changedesc, auditstamp, userid)'
      'values'
      
        '(:pidadministered, :pidtype, :pchangedesc, :pauditstamp, :puseri' +
        'd)')
    Params = <
      item
        DataType = ftUnknown
        Name = 'pidadministered'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'pidtype'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'pchangedesc'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'pauditstamp'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'puserid'
        ParamType = ptUnknown
      end>
    Left = 340
    Top = 95
  end
end
