object InputPW: TInputPW
  Left = 216
  Top = 183
  HelpContext = 1230
  ActiveControl = ADL1F
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Confirm password'
  ClientHeight = 64
  ClientWidth = 188
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  Position = poOwnerFormCenter
  Scaled = False
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object OkCP1Btn: TButton
    Tag = 1
    Left = 10
    Top = 35
    Width = 80
    Height = 21
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 1
  end
  object ClsCP1Btn: TButton
    Left = 95
    Top = 35
    Width = 80
    Height = 21
    Cancel = True
    Caption = 'C&lose'
    ModalResult = 2
    TabOrder = 2
  end
  object ADL1F: Text8Pt
    Tag = 1
    Left = 40
    Top = 5
    Width = 100
    Height = 21
    CharCase = ecUpperCase
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MaxLength = 30
    ParentFont = False
    ParentShowHint = False
    PasswordChar = '*'
    ShowHint = True
    TabOrder = 0
    OnEnter = ADL1FEnter
    OnExit = ADL1FExit
    TextId = 0
    ViaSBtn = False
  end
end
