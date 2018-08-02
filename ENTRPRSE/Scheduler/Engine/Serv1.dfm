object IRISExchequerScheduler: TIRISExchequerScheduler
  OldCreateOrder = False
  OnCreate = ServiceCreate
  DisplayName = 'Test Service 1'
  StartType = stManual
  OnStart = ServiceStart
  OnStop = ServiceStop
  Left = 348
  Top = 110
  Height = 150
  Width = 215
end
