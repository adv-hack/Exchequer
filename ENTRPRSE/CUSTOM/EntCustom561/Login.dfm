object frmLogin: TfrmLogin
  Left = 379
  Top = 193
  BorderStyle = bsDialog
  Caption = 'Menu Designer Login'
  ClientHeight = 116
  ClientWidth = 223
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 14
  object Bevel1: TBevel
    Left = 8
    Top = 16
    Width = 209
    Height = 57
    Shape = bsFrame
  end
  object Label1: TLabel
    Left = 16
    Top = 38
    Width = 50
    Height = 14
    Caption = 'Password'
  end
  object edPassword: TEdit
    Left = 80
    Top = 34
    Width = 121
    Height = 22
    MaxLength = 50
    PasswordChar = '*'
    TabOrder = 0
  end
  object btnCancel: TButton
    Left = 136
    Top = 88
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object btnOK: TButton
    Left = 48
    Top = 88
    Width = 80
    Height = 21
    Caption = '&OK'
    Default = True
    TabOrder = 1
    OnClick = btnOKClick
  end
end
