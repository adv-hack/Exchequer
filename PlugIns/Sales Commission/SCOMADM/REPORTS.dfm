object ModReports: TModReports
  Left = 360
  Top = 236
  Width = 152
  Height = 68
  Caption = 'ModReports'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object FilePrinter1: TFilePrinter
    Left = 40
    Top = 8
  end
  object TheReport: TReportFiler
    StatusFormat = 'Printing page %p'
    Units = unMM
    UnitsFactor = 25.4
    Title = 'Card List'
    Orientation = poPortrait
    ScaleX = 100
    ScaleY = 100
    Left = 8
    Top = 8
  end
end
