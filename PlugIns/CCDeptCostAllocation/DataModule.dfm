object SQLDataModule: TSQLDataModule
  OldCreateOrder = False
  Left = 493
  Top = 297
  Height = 193
  Width = 161
  object ADOConnection_Common: TADOConnection
    LoginPrompt = False
    Provider = 'SQLOLEDB.1'
    Left = 56
    Top = 24
  end
  object qCommonQuery: TADOQuery
    Connection = ADOConnection_Common
    Parameters = <>
    Left = 56
    Top = 80
  end
end
