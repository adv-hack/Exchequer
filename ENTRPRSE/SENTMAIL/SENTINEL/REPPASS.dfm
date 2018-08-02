object frmRepPass: TfrmRepPass
  Left = 192
  Top = 107
  BorderStyle = bsDialog
  Caption = 'Password Entry'
  ClientHeight = 129
  ClientWidth = 255
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
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 241
    Height = 81
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 8
      Width = 225
      Height = 13
      Alignment = taCenter
      AutoSize = False
      Caption = 'A password is required for this Report Group'
    end
    object lblGrp: TLabel
      Left = 8
      Top = 28
      Width = 225
      Height = 13
      Alignment = taCenter
      AutoSize = False
      Caption = 'lblGrp'
    end
    object edtPassword: TEdit
      Left = 76
      Top = 48
      Width = 89
      Height = 21
      CharCase = ecUpperCase
      MaxLength = 8
      PasswordChar = '*'
      TabOrder = 0
    end
  end
  object btnOK: TButton
    Left = 42
    Top = 96
    Width = 75
    Height = 25
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 1
  end
  object Button2: TButton
    Left = 138
    Top = 96
    Width = 75
    Height = 25
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
