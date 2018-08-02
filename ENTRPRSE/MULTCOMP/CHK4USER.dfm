object dmCheckForUsersRep: TdmCheckForUsersRep
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Left = 282
  Top = 197
  Height = 106
  Width = 244
  object ReportFiler1: TReportFiler
    StatusFormat = 'Printing page %p'
    LineHeightMethod = lhmFont
    Units = unMM
    UnitsFactor = 25.4
    Title = 'Logged In Users Report'
    Orientation = poPortrait
    ScaleX = 100
    ScaleY = 100
    StreamMode = smFile
    OnPrint = ReportFiler1Print
    OnBeforePrint = ReportFiler1BeforePrint
    OnNewPage = ReportFiler1NewPage
    Left = 30
    Top = 16
  end
  object FilePrinter1: TFilePrinter
    PrintTitle = 'Logged In Users Report'
    StreamMode = smFile
    Left = 97
    Top = 17
  end
end
