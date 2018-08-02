object frmPrinterBinInfo: TfrmPrinterBinInfo
  Left = -686
  Top = -107
  Width = 626
  Height = 549
  Caption = 'Printer Bin Information'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  OnCreate = FormCreate
  DesignSize = (
    610
    510)
  PixelsPerInch = 96
  TextHeight = 14
  object memInfo: TMemo
    Left = 5
    Top = 5
    Width = 600
    Height = 500
    Anchors = [akLeft, akTop, akRight, akBottom]
    Lines.Strings = (
      'memInfo')
    ScrollBars = ssVertical
    TabOrder = 0
  end
end
