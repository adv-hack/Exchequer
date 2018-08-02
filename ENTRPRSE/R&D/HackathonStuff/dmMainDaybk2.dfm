object MainDataModule: TMainDataModule
  OldCreateOrder = False
  OnDestroy = DataModuleDestroy
  Left = 419
  Top = 163
  Height = 495
  Width = 756
  object connMain: TADOConnection
    LoginPrompt = False
    Provider = 'SQLOLEDB.1'
    Left = 152
    Top = 40
  end
end
