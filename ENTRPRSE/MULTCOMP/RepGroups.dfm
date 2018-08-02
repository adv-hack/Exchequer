object dmGroupsReport: TdmGroupsReport
  OldCreateOrder = False
  Left = 446
  Top = 262
  Height = 166
  Width = 208
  object ReportFiler1: TReportFiler
    StatusFormat = 'Printing page %p'
    LineHeightMethod = lhmFont
    Units = unMM
    UnitsFactor = 25.4
    Title = 'Bureau Groups Report'
    Orientation = poPortrait
    ScaleX = 100
    ScaleY = 100
    OnPrint = ReportFiler1Print
    OnBeforePrint = ReportFiler1BeforePrint
    OnNewPage = ReportFiler1NewPage
    Left = 36
    Top = 9
  end
  object FilePrinter1: TFilePrinter
    PrintTitle = 'Bureau Groups Report'
    StreamMode = smFile
    Left = 36
    Top = 62
  end
end
