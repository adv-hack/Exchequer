object frmDbfWrite: TfrmDbfWrite
  Left = 440
  Top = 182
  Width = 187
  Height = 135
  Caption = 'frmDbfWrite'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object HalcyonDataSet1: THalcyonDataSet
    About = 'Halcyon Demo Version 6.94 (14 Dec 2001)'
    AutoFlush = False
    Exclusive = False
    LargeIntegerAs = asInteger
    LockProtocol = Default
    TranslateASCII = True
    UseDeleted = False
    UserID = 0
  end
  object CreateHalcyonDataSet1: TCreateHalcyonDataSet
    AutoOverwrite = False
    DBFType = Clipper
    Top = 32
  end
end
