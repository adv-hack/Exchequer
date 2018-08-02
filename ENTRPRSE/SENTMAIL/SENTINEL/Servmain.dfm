object SentimailVAOService: TSentimailVAOService
  OldCreateOrder = False
  OnCreate = ServiceCreate
  AllowPause = False
  DisplayName = 'Sentimail VAO'
  AfterInstall = ServiceAfterInstall
  OnExecute = ServiceExecute
  OnStart = ServiceStart
  OnStop = ServiceStop
  Left = 192
  Top = 114
  Height = 150
  Width = 215
end
