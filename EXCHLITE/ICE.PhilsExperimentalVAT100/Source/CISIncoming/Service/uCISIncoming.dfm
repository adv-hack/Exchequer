object CISService: TCISService
  OldCreateOrder = False
  Dependencies = <
    item
      Name = 'DSRWrapperServer'
      IsGroup = False
    end>
  DisplayName = 'CISService'
  ErrorSeverity = esIgnore
  ServiceStartName = 'CIS Incoming System'
  OnExecute = ServiceExecute
  OnStart = ServiceStart
  OnStop = ServiceStop
  Left = 687
  Top = 222
  Height = 150
  Width = 215
end
