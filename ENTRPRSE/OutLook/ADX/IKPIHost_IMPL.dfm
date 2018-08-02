object AddInModule: TAddInModule
  OldCreateOrder = True
  AddInName = 'KPIAddin'
  SupportedApps = [ohaOutlook]
  OnAddInInitialize = adxCOMAddInModuleAddInInitialize
  TaskPanes = <>
  Left = 393
  Top = 160
  Height = 400
  Width = 380
  object FormsManager: TadxOlFormsManager
    Items = <
      item
        ExplorerItemTypes = []
        ExplorerLayout = elWebViewPane
        InspectorItemTypes = []
        FormClassName = 'TKPIForm'
      end>
    Left = 52
    Top = 16
  end
  object OutlookAppEvents: TadxOutlookAppEvents
    OnQuit = OutlookAppEventsQuit
    OnExplorerActivate = OutlookAppEventsExplorerActivate
    Left = 248
    Top = 16
  end
end
