object frmPaUserID: TfrmPaUserID
  Left = 192
  Top = 107
  Width = 399
  Height = 229
  Caption = 'Exchequer Authoris-e'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 289
    Height = 185
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    object Label1: TLabel
      Left = 48
      Top = 100
      Width = 39
      Height = 13
      Caption = 'User ID:'
    end
    object Label2: TLabel
      Left = 40
      Top = 140
      Width = 49
      Height = 13
      Caption = 'Password:'
    end
    object Label3: TLabel
      Left = 8
      Top = 56
      Width = 273
      Height = 33
      Alignment = taCenter
      AutoSize = False
      Caption = 'Please enter a suitable User ID and password.'
      WordWrap = True
    end
    object lblReason: TLabel
      Left = 8
      Top = 8
      Width = 273
      Height = 25
      Alignment = taCenter
      AutoSize = False
      WordWrap = True
    end
    object edtUserID: TEdit
      Left = 104
      Top = 96
      Width = 121
      Height = 21
      CharCase = ecUpperCase
      TabOrder = 0
    end
    object edtPassword: TEdit
      Left = 104
      Top = 136
      Width = 121
      Height = 21
      CharCase = ecUpperCase
      PasswordChar = '*'
      TabOrder = 1
    end
  end
  object Button1: TButton
    Left = 304
    Top = 8
    Width = 80
    Height = 21
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 1
  end
  object Button2: TButton
    Left = 304
    Top = 40
    Width = 80
    Height = 21
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object btnEar: TButton
    Left = 304
    Top = 72
    Width = 80
    Height = 21
    Caption = '&EAR'
    ModalResult = 4
    TabOrder = 3
    Visible = False
  end
end
