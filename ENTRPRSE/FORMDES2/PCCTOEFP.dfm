object frmConvertPCC: TfrmConvertPCC
  Left = 200
  Top = 104
  Width = 178
  Height = 115
  Caption = 'Convert PCC To EFP'
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  PixelsPerInch = 96
  TextHeight = 13
  object ReportFiler1: TReportFiler
    StatusFormat = 'Printing page %p'
    LineHeightMethod = lhmFont
    Units = unMM
    UnitsFactor = 25.4
    Title = 'Exchequer Exchequer Report'
    Orientation = poPortrait
    ScaleX = 100
    ScaleY = 100
    StreamMode = smFile
    OnPrint = ReportFiler1Print
    OnBeforePrint = ReportFiler1BeforePrint
    Left = 27
    Top = 16
  end
end
