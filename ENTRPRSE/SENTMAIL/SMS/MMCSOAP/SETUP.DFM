object frmSetup: TfrmSetup
  Left = 314
  Top = 192
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Mobile Message Centre Configuration'
  ClientHeight = 176
  ClientWidth = 399
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel
    Left = 8
    Top = 12
    Width = 26
    Height = 14
    Caption = 'URL :'
  end
  object Label2: TLabel
    Left = 8
    Top = 52
    Width = 59
    Height = 14
    Caption = 'User Name :'
  end
  object Label3: TLabel
    Left = 8
    Top = 116
    Width = 56
    Height = 14
    Caption = 'Password :'
  end
  object Label4: TLabel
    Left = 8
    Top = 84
    Width = 51
    Height = 14
    Caption = 'Company :'
  end
  object btnOK: TButton
    Left = 256
    Top = 144
    Width = 65
    Height = 25
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 0
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 328
    Top = 144
    Width = 65
    Height = 25
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object edURL: TEdit
    Left = 40
    Top = 8
    Width = 353
    Height = 22
    TabOrder = 2
  end
  object edUserName: TEdit
    Left = 72
    Top = 48
    Width = 105
    Height = 22
    TabOrder = 3
  end
  object edPassword: TEdit
    Left = 72
    Top = 112
    Width = 105
    Height = 22
    PasswordChar = '*'
    TabOrder = 4
  end
  object edCompany: TEdit
    Left = 72
    Top = 80
    Width = 105
    Height = 22
    TabOrder = 5
  end
end
