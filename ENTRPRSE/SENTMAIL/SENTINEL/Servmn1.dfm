object SentimailService: TSentimailService
  OldCreateOrder = False
  OnCreate = ServiceCreate
  AllowPause = False
  DisplayName = 'Sentimail'
  AfterInstall = ServiceAfterInstall
  OnShutdown = ServiceShutdown
  OnStart = ServiceStart
  OnStop = ServiceStop
  Left = 192
  Top = 114
  Height = 150
  Width = 215
end
