object frmSystemSetup: TfrmSystemSetup
  Left = 396
  Top = 298
  BorderStyle = bsDialog
  Caption = 'Tools Setup'
  ClientHeight = 119
  ClientWidth = 226
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object Bevel1: TBevel
    Left = 8
    Top = 16
    Width = 209
    Height = 65
    Shape = bsFrame
  end
  object lPassword: TLabel
    Left = 16
    Top = 44
    Width = 50
    Height = 14
    Caption = 'Password'
  end
  object edPassword: TEdit
    Left = 80
    Top = 40
    Width = 121
    Height = 22
    MaxLength = 50
    PasswordChar = '*'
    TabOrder = 1
  end
  object cbUsePassword: TCheckBox
    Left = 16
    Top = 8
    Width = 97
    Height = 17
    Caption = 'Use Password'
    TabOrder = 0
    OnClick = cbUsePasswordClick
  end
  object btnCancel: TButton
    Left = 136
    Top = 88
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    TabOrder = 3
    OnClick = btnCancelClick
  end
  object btnOK: TButton
    Left = 48
    Top = 88
    Width = 80
    Height = 21
    Caption = '&OK'
    Default = True
    TabOrder = 2
    OnClick = btnOKClick
  end
end
