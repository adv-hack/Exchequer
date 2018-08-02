object frmLogin: TfrmLogin
  Left = 476
  Top = 377
  BorderStyle = bsDialog
  Caption = 'Login'
  ClientHeight = 108
  ClientWidth = 242
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
    Top = 8
    Width = 225
    Height = 65
    Shape = bsFrame
  end
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 59
    Height = 14
    Caption = 'Password : '
  end
  object edPassword: TEdit
    Left = 16
    Top = 32
    Width = 209
    Height = 22
    PasswordChar = '*'
    TabOrder = 0
  end
  object btnCancel: TButton
    Left = 152
    Top = 80
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    TabOrder = 1
    OnClick = btnCancelClick
  end
  object btnOK: TButton
    Left = 64
    Top = 80
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&OK'
    TabOrder = 2
    OnClick = btnOKClick
  end
end
