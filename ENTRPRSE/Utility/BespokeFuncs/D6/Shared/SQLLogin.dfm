object frmSQLLogin: TfrmSQLLogin
  Left = 391
  Top = 347
  BorderStyle = bsDialog
  Caption = 'SQL Server Login'
  ClientHeight = 189
  ClientWidth = 314
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnClick = RadioChange
  PixelsPerInch = 96
  TextHeight = 14
  object Bevel1: TBevel
    Left = 8
    Top = 56
    Width = 297
    Height = 97
    Shape = bsFrame
  end
  object lPassword: TLabel
    Left = 16
    Top = 116
    Width = 59
    Height = 14
    Caption = 'Password : '
  end
  object lUsername: TLabel
    Left = 16
    Top = 84
    Width = 59
    Height = 14
    Caption = 'User Name :'
  end
  object edPassword: TEdit
    Left = 80
    Top = 112
    Width = 209
    Height = 22
    PasswordChar = '*'
    TabOrder = 3
  end
  object btnCancel: TButton
    Left = 224
    Top = 160
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 5
  end
  object btnOK: TButton
    Left = 136
    Top = 160
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 4
  end
  object rbWindows: TRadioButton
    Left = 16
    Top = 16
    Width = 169
    Height = 17
    Caption = 'Use Windows Authentication'
    TabOrder = 0
    OnClick = RadioChange
  end
  object rbSQL: TRadioButton
    Left = 16
    Top = 48
    Width = 177
    Height = 17
    Caption = 'Use SQL Server Authentication'
    TabOrder = 1
    OnClick = RadioChange
  end
  object edUserName: TEdit
    Left = 80
    Top = 80
    Width = 209
    Height = 22
    TabOrder = 2
  end
  object cbRemember: TCheckBox
    Left = 8
    Top = 160
    Width = 121
    Height = 17
    Caption = 'Remember Details'
    TabOrder = 6
  end
end
