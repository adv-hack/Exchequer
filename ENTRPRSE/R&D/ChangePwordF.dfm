object frmChangeUserPword: TfrmChangeUserPword
  Left = 634
  Top = 265
  HelpContext = 1230
  ActiveControl = edtCurrentPword
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Change Password'
  ClientHeight = 159
  ClientWidth = 277
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poOwnerFormCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel
    Left = 10
    Top = 14
    Width = 125
    Height = 14
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'User name'
  end
  object Label2: TLabel
    Left = 10
    Top = 42
    Width = 125
    Height = 14
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Current Password'
  end
  object Label3: TLabel
    Left = 10
    Top = 70
    Width = 125
    Height = 14
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'New Password'
  end
  object Label4: TLabel
    Left = 10
    Top = 97
    Width = 125
    Height = 14
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Confirm New Password'
  end
  object edtUserName: TEdit
    Left = 141
    Top = 11
    Width = 121
    Height = 22
    TabStop = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 0
  end
  object edtCurrentPword: TEdit
    Left = 141
    Top = 39
    Width = 121
    Height = 22
    CharCase = ecUpperCase
    Font.Charset = ANSI_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 9
    ParentFont = False
    PasswordChar = 'X'
    TabOrder = 1
  end
  object edtNewPword: TEdit
    Left = 141
    Top = 67
    Width = 121
    Height = 22
    CharCase = ecUpperCase
    Font.Charset = ANSI_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 9
    ParentFont = False
    PasswordChar = 'X'
    TabOrder = 2
  end
  object edtConfirmPword: TEdit
    Left = 141
    Top = 94
    Width = 121
    Height = 22
    CharCase = ecUpperCase
    Font.Charset = ANSI_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 9
    ParentFont = False
    PasswordChar = 'X'
    TabOrder = 3
  end
  object btnOK: TButton
    Left = 51
    Top = 127
    Width = 80
    Height = 21
    Caption = 'OK'
    TabOrder = 4
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 146
    Top = 127
    Width = 80
    Height = 21
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 5
  end
  object EnterToTab1: TEnterToTab
    ConvertEnters = True
    OverrideFont = False
    Version = 'TEnterToTab v1.02 for Delphi 6.01'
    Left = 185
    Top = 21
  end
end
