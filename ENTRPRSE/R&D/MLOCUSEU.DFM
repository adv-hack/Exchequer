object MLUseI: TMLUseI
  Left = 467
  Top = 289
  ActiveControl = PkMntF
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Location Split Quantities'
  ClientHeight = 98
  ClientWidth = 222
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  Scaled = False
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object SBSBackGroup1: TSBSBackGroup
    Left = 5
    Top = 2
    Width = 210
    Height = 59
    TextId = 0
  end
  object PKLab: Label8
    Left = 25
    Top = 13
    Width = 83
    Height = 14
    Alignment = taCenter
    AutoSize = False
    Caption = 'Pack Quantity'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object PALab: Label8
    Left = 111
    Top = 13
    Width = 83
    Height = 14
    Alignment = taCenter
    AutoSize = False
    Caption = 'Use Quantity'
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
    Left = 26
    Top = 72
    Width = 80
    Height = 21
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 2
  end
  object CanCP1Btn: TButton
    Tag = 1
    Left = 109
    Top = 72
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object PkMntF: TCurrencyEdit
    Tag = 1
    Left = 26
    Top = 30
    Width = 81
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
  object PAmntF: TCurrencyEdit
    Tag = 1
    Left = 112
    Top = 30
    Width = 81
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
    TabOrder = 1
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
end
