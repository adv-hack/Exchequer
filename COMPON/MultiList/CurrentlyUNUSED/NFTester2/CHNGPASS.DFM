object FrmChangePassword: TFrmChangePassword
  Left = 306
  Top = 255
  Width = 296
  Height = 188
  HelpContext = 52
  Caption = 'Change Password'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object Bevel1: TBevel
    Left = 8
    Top = 8
    Width = 273
    Height = 113
    Shape = bsFrame
  end
  object Label1: TLabel
    Left = 46
    Top = 26
    Width = 95
    Height = 14
    Alignment = taRightJustify
    Caption = 'Current Password :'
  end
  object Label2: TLabel
    Left = 59
    Top = 58
    Width = 82
    Height = 14
    Alignment = taRightJustify
    Caption = 'New Password :'
  end
  object Label3: TLabel
    Left = 19
    Top = 90
    Width = 122
    Height = 14
    Alignment = taRightJustify
    Caption = 'Confirm New Password :'
  end
  object edOldPass: Text8Pt
    Left = 144
    Top = 22
    Width = 121
    Height = 22
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    PasswordChar = '*'
    ShowHint = True
    TabOrder = 0
    OnExit = edOldPassExit
    TextId = 0
    ViaSBtn = False
  end
  object edNewPass: Text8Pt
    Left = 144
    Top = 54
    Width = 121
    Height = 22
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    PasswordChar = '*'
    ShowHint = True
    TabOrder = 1
    TextId = 0
    ViaSBtn = False
  end
  object edConfirmPass: Text8Pt
    Left = 144
    Top = 86
    Width = 121
    Height = 22
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    PasswordChar = '*'
    ShowHint = True
    TabOrder = 2
    OnExit = edConfirmPassExit
    TextId = 0
    ViaSBtn = False
  end
  object btnCancel: TButton
    Left = 216
    Top = 128
    Width = 65
    Height = 25
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 4
  end
  object btnOK: TButton
    Left = 144
    Top = 128
    Width = 65
    Height = 25
    Caption = '&OK'
    TabOrder = 3
    OnClick = btnOKClick
  end
end
