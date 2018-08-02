object dmHttp: TdmHttp
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Left = 349
  Top = 222
  Height = 150
  Width = 215
  object http1: TmsHTTPClient
    Version = '2.1'
    Authorization = False
    ProxyAuthorization = False
    ProxyPort = 0
    Left = 8
    Top = 8
  end
end
