object Form_PrintPCC: TForm_PrintPCC
  Left = 631
  Top = 612
  Width = 140
  Height = 82
  Caption = 'Print PCC Form'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object ReportPrinter1: TReportPrinter
    StatusFormat = 'Printing page %p'
    LineHeightMethod = lhmFont
    Units = unMM
    UnitsFactor = 25.4
    Title = 'Exchequer Report'
    Orientation = poPortrait
    ScaleX = 100
    ScaleY = 100
    OnPrint = Batch_Print
    Left = 19
    Top = 4
  end
  object FilePrinter1: TFilePrinter
    StreamMode = smFile
    Left = 59
    Top = 8
  end
end
