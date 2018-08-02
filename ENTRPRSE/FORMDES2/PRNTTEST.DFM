object Form_PrintTest: TForm_PrintTest
  Left = 177
  Top = 114
  Width = 366
  Height = 283
  Caption = 'Print Test'
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  PixelsPerInch = 96
  OnCreate = FormCreate
  TextHeight = 13
  object ScrollBox1: TScrollBox
    Left = 5
    Top = 5
    Width = 338
    Height = 231
    TabOrder = 0
  end
  object ReportPrinter1: TReportPrinter
    StatusFormat = 'Printing page %p'
    Units = unMM
    UnitsFactor = 25.4
    Title = 'ReportPrinter Report'
    Orientation = poPortrait
    ScaleX = 100
    ScaleY = 100
    OnPrint = TestSize_Print
    OnBeforePrint = TestSize_BeforePrint
    Left = 11
    Top = 12
  end
  object FilePreview1: TFilePreview
    FileName = 'REPORT.SBS'
    ScrollBox = ScrollBox1
    ZoomFactor = 100
    Left = 42
    Top = 10
  end
  object ReportFiler1: TReportFiler
    StatusFormat = 'Printing page %p'
    UnitsFactor = 1
    Title = 'ReportPrinter Report'
    Orientation = poPortrait
    ScaleX = 100
    ScaleY = 100
    FileName = 'REPORT.SBS'
    Left = 11
    Top = 44
  end
end
