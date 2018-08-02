object dmHttp: TdmHttp
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Left = 349
  Top = 222
  Height = 150
  Width = 215
  object Http1: TWinHTTP
    Agent = 'acHTTP component (AppControls.com)'
    OnDone = Http1Done
    Left = 88
    Top = 40
  end
end
