object frmClient: TfrmClient
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Left = 561
  Top = 140
  Height = 211
  Width = 153
  object ClientConnxn: TIdTCPClient
    Host = '10.1.1.2'
    Port = 6001
    Left = 48
    Top = 40
  end
  object Blowfish: TBlowfish
    CipherMode = CBC
    StringMode = smEncode
    Left = 48
    Top = 104
  end
end
