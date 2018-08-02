object frmPassword: TfrmPassword
  Left = 248
  Top = 252
  Width = 231
  Height = 127
  Caption = 'frmPassword'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object MsgLbl: Label8
    Left = 6
    Top = 9
    Width = 209
    Height = 14
    Alignment = taCenter
    AutoSize = False
    Caption = 'Enter Security Password'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object PWord: Text8Pt
    Left = 66
    Top = 30
    Width = 89
    Height = 22
    CharCase = ecUpperCase
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 8
    ParentFont = False
    ParentShowHint = False
    PasswordChar = '*'
    ShowHint = True
    TabOrder = 0
    TextId = 0
    ViaSBtn = False
  end
  object OKBtn: TButton
    Left = 28
    Top = 60
    Width = 80
    Height = 21
    Caption = '&OK'
    Default = True
    TabOrder = 1
  end
  object CancelBtn: TButton
    Left = 113
    Top = 60
    Width = 80
    Height = 21
    Caption = 'Cancel'
    TabOrder = 2
  end
end
