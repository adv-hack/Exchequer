object WRServer: TWRServer
  OldCreateOrder = False
  AppName = 'Exchequer Release Codes'
  ComInitialization = ciNone
  SessionTrackingMethod = tmURL
  Description = 'Exchequer Release Codes'
  DestinationDevice = ddWeb
  ExceptionDisplayMode = smAlert
  ExecCmd = 'wrexec'
  HistoryEnabled = False
  Port = 80
  RestrictIPs = False
  ShowResyncWarning = True
  SessionTimeout = 10
  SSLPort = 443
  StartCmd = 'webrel'
  SupportedBrowsers = [brIE, brNetscape6, brOpera]
  TimeoutURL = 'http://www.exchequer.com'
  OnNewSession = IWServerControllerBaseNewSession
  Left = 690
  Top = 260
  Height = 310
  Width = 342
end
