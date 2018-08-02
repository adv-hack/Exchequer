object frmDbUtility: TfrmDbUtility
  Left = 246
  Top = 105
  Width = 870
  Height = 640
  Caption = 'DB Utility'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object btnEncrypt: TButton
    Left = 90
    Top = 26
    Width = 75
    Height = 25
    Caption = 'Encrypt'
    TabOrder = 1
    OnClick = btnEncryptClick
  end
  object btnDecrypt: TButton
    Left = 171
    Top = 26
    Width = 75
    Height = 25
    Caption = 'Decrypt'
    TabOrder = 2
    OnClick = btnDecryptClick
  end
  object btnLoad: TButton
    Left = 10
    Top = 26
    Width = 75
    Height = 25
    Caption = 'Load'
    TabOrder = 0
    OnClick = btnLoadClick
  end
  object btnSave: TButton
    Left = 252
    Top = 26
    Width = 75
    Height = 25
    Caption = 'Save'
    TabOrder = 3
    OnClick = btnSaveClick
  end
  object mmScript: TMemo
    Left = 0
    Top = 70
    Width = 854
    Height = 532
    Align = alBottom
    TabOrder = 4
  end
  object odDbFile: TOpenDialog
    Left = 466
    Top = 14
  end
  object sdDbFile: TSaveDialog
    Left = 494
    Top = 14
  end
end
