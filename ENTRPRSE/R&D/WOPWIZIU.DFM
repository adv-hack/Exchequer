object WORWizBuild: TWORWizBuild
  Left = 754
  Top = 314
  ActiveControl = PAMntF
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Build Sub BOM'
  ClientHeight = 139
  ClientWidth = 180
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  Scaled = False
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object SBSBackGroup1: TSBSBackGroup
    Left = 5
    Top = 2
    Width = 168
    Height = 97
    TextId = 0
  end
  object PALab: Label8
    Left = 10
    Top = 13
    Width = 157
    Height = 14
    Alignment = taCenter
    AutoSize = False
    Caption = 'Build how many?'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object OkCP1Btn: TButton
    Tag = 1
    Left = 8
    Top = 112
    Width = 80
    Height = 21
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 2
  end
  object CanCP1Btn: TButton
    Tag = 1
    Left = 91
    Top = 112
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object PAMntF: TCurrencyEdit
    Tag = 1
    Left = 26
    Top = 30
    Width = 121
    Height = 21
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      '0.67-')
    ParentFont = False
    TabOrder = 0
    WantReturns = False
    WordWrap = False
    AutoSize = False
    BlockNegative = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
    ShowCurrency = False
    TextId = 0
    Value = -0.666666
  end
  object BorCheck1: TBorCheck
    Left = 18
    Top = 64
    Width = 128
    Height = 20
    HelpContext = 1293
    Caption = 'Generate a WOR?'
    CheckColor = clWindowText
    Color = clBtnFace
    ParentColor = False
    TabOrder = 1
    TextId = 0
  end
end
