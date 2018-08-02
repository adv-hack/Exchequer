object Form_TechSupp: TForm_TechSupp
  Left = 306
  Top = 244
  Width = 156
  Height = 66
  Caption = 'Form_TechSupp'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object ReportFiler1: TReportFiler
    StatusFormat = 'Printing page %p'
    Units = unMM
    UnitsFactor = 25.4
    MarginLeft = 20
    MarginRight = 20
    MarginTop = 20
    MarginBottom = 20
    Title = 'ReportPrinter Report'
    Orientation = poPortrait
    ScaleX = 100
    ScaleY = 100
    StreamMode = smFile
    OnPrint = ReportFiler1Print
    OnBeforePrint = ReportFiler1BeforePrint
    OnNewPage = ReportFiler1NewPage
    Left = 42
    Top = 7
  end
end
