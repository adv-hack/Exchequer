object frmListener: TfrmListener
  OldCreateOrder = False
  DisplayName = 'Webrel Listener'
  OnExecute = ServiceExecute
  OnStart = OnStart
  Left = 302
  Top = 152
  Height = 279
  Width = 276
  object ServerConnxn: TIdTCPServer
    Bindings = <>
    DefaultPort = 6001
    OnExecute = ServerConnxnExecute
    Left = 48
    Top = 32
  end
  object Blowfish: TBlowfish
    CipherMode = CBC
    StringMode = smEncode
    Left = 120
    Top = 32
  end
  object WRDB: TPvSqlDatabase
    AliasName = 'SecAdmin'
    DatabaseName = 'WRDB'
    LoginPrompt = False
    LoginPromptOnlyIfNecessary = False
    Params.Strings = (
      'USER NAME=Master'
      'PASSWORD=XYs!viw')
    SessionName = 'WRSession_1'
    Left = 45
    Top = 90
  end
  object WRSession: TPvSqlSession
    Active = True
    AutoSessionName = True
    Left = 115
    Top = 95
  end
  object qyPrimary: TPvQuery
    DatabaseName = 'WRDB'
    SessionName = 'WRSession_1'
    Params = <>
    Left = 195
    Top = 30
  end
  object qySMS: TPvQuery
    DatabaseName = 'WRDB'
    SessionName = 'WRSession_1'
    SQL.Strings = (
      'select * from smspending '
      'where smssent = 0'
      'order by smsid')
    Params = <>
    Left = 190
    Top = 90
  end
  object qyUpdateSMS: TPvQuery
    DatabaseName = 'WRDB'
    SessionName = 'WRSession_1'
    SQL.Strings = (
      'update smspending'
      'set smssent = 1, smserror = :perror'
      'where smsid = :psmsid')
    Params = <
      item
        DataType = ftUnknown
        Name = 'perror'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'psmsid'
        ParamType = ptUnknown
      end>
    Left = 190
    Top = 145
  end
end
