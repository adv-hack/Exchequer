object FrmLogin: TFrmLogin
  Left = 399
  Top = 261
  HelpContext = 28
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Trade Counter Administrator Login'
  ClientHeight = 148
  ClientWidth = 296
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel
    Left = 8
    Top = 20
    Width = 51
    Height = 14
    Caption = 'Company :'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 8
    Top = 52
    Width = 59
    Height = 14
    Caption = 'User Name :'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 8
    Top = 84
    Width = 56
    Height = 14
    Caption = 'Password :'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object cmbCompany: TComboBox
    Left = 72
    Top = 16
    Width = 217
    Height = 22
    Style = csDropDownList
    ItemHeight = 14
    TabOrder = 4
  end
  object edUserName: TEdit
    Left = 72
    Top = 48
    Width = 137
    Height = 22
    CharCase = ecUpperCase
    TabOrder = 0
    OnExit = edUserNameExit
  end
  object edPassword: TEdit
    Left = 72
    Top = 80
    Width = 137
    Height = 22
    PasswordChar = '*'
    TabOrder = 1
    OnExit = edPasswordExit
  end
  object btnOK: TButton
    Left = 120
    Top = 120
    Width = 80
    Height = 21
    Caption = '&OK'
    TabOrder = 2
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 208
    Top = 120
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 3
    OnClick = btnCancelClick
  end
end
