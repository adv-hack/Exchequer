object frmPass1: TfrmPass1
  Left = 378
  Top = 166
  BorderStyle = bsDialog
  Caption = 'Custom Hold Plug-in Administration'
  ClientHeight = 85
  ClientWidth = 312
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 14
  object Panel1: TPanel
    Left = 16
    Top = 8
    Width = 201
    Height = 73
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    object Label1: TLabel
      Left = 24
      Top = 16
      Width = 141
      Height = 14
      Caption = 'Please enter your password:'
    end
    object edtPass: TEdit
      Left = 24
      Top = 32
      Width = 121
      Height = 22
      CharCase = ecUpperCase
      PasswordChar = '*'
      TabOrder = 0
    end
  end
  object SBSButton1: TSBSButton
    Left = 224
    Top = 8
    Width = 80
    Height = 21
    Caption = '&OK'
    TabOrder = 1
    OnClick = SBSButton1Click
    TextId = 0
  end
  object SBSButton2: TSBSButton
    Left = 224
    Top = 32
    Width = 80
    Height = 21
    Caption = '&Cancel'
    TabOrder = 2
    OnClick = SBSButton2Click
    TextId = 0
  end
end
