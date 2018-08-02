object Form1: TForm1
  Left = 331
  Top = 110
  Width = 870
  Height = 640
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Events1: TFmPrintIFmPrinterEvents
    PrintComplete = Events1PrintComplete
    Left = 56
    Top = 64
  end
end
