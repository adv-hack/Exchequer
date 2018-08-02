object frmDbf: TfrmDbf
  Left = 192
  Top = 107
  Width = 154
  Height = 231
  Caption = 'frmDbf'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 40
    Top = 136
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 0
    OnClick = Button1Click
  end
  object CH1: TCreateHalcyonDataSet
    AutoOverwrite = True
    DBFType = DBaseIV
    Left = 8
    Top = 8
  end
  object Table1: THalcyonDataSet
    About = 'Halcyon Demo Version 6.94 (14 Dec 2001)'
    AutoFlush = False
    Exclusive = False
    LargeIntegerAs = asInteger
    LockProtocol = Default
    TranslateASCII = True
    UseDeleted = False
    UserID = 0
    Left = 8
    Top = 48
  end
end
