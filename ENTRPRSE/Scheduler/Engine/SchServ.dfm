object IRISExchequerScheduler: TIRISExchequerScheduler
  OldCreateOrder = False
  OnCreate = ServiceCreate
  DisplayName = 'Exchequer Scheduler'
  StartType = stManual
  AfterInstall = ServiceAfterInstall
  OnStart = ServiceStart
  OnStop = ServiceStop
  Left = 344
  Top = 110
  Height = 150
  Width = 215
end
