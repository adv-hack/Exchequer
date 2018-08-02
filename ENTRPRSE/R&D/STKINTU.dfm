object StkIntFrm: TStkIntFrm
  Left = 396
  Top = 273
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Intrastat Details'
  ClientHeight = 186
  ClientWidth = 271
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
  object SBSPanel1: TSBSBackGroup
    Left = 5
    Top = 1
    Width = 260
    Height = 147
    TextId = 0
  end
  object Label81: Label8
    Left = 61
    Top = 20
    Width = 80
    Height = 14
    Caption = 'Commodity Code'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label83: Label8
    Left = 31
    Top = 48
    Width = 110
    Height = 14
    Caption = 'Stock Units in SSD Unit'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label84: Label8
    Left = 33
    Top = 73
    Width = 101
    Height = 14
    Caption = 'Line Unit Weight (Kg)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label847: Label8
    Left = 47
    Top = 124
    Width = 94
    Height = 14
    Alignment = taRightJustify
    Caption = 'Intrastat State Uplift'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    WordWrap = True
    TextId = 0
  end
  object Label848: Label8
    Left = 17
    Top = 98
    Width = 124
    Height = 14
    Alignment = taRightJustify
    Caption = 'Intrastat Country of Origin'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    WordWrap = True
    TextId = 0
  end
  object OkCP1Btn: TButton
    Tag = 1
    Left = 52
    Top = 158
    Width = 80
    Height = 21
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 5
  end
  object ClsCP1Btn: TButton
    Left = 137
    Top = 158
    Width = 80
    Height = 21
    Cancel = True
    Caption = 'C&lose'
    ModalResult = 2
    TabOrder = 6
  end
  object CCodeF: Text8Pt
    Tag = 1
    Left = 147
    Top = 18
    Width = 107
    Height = 22
    Color = clWhite
    EditMask = '>cccccccc;0; '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 8
    ParentFont = False
    ParentShowHint = False
    ReadOnly = True
    ShowHint = True
    TabOrder = 0
    TextId = 0
    ViaSBtn = False
  end
  object SSDUF: TCurrencyEdit
    Tag = 1
    Left = 147
    Top = 43
    Width = 107
    Height = 22
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      '0.67-')
    ParentFont = False
    ReadOnly = True
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
  object SWF: TCurrencyEdit
    Tag = 1
    Left = 147
    Top = 68
    Width = 107
    Height = 22
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      '0.67-')
    ParentFont = False
    ReadOnly = True
    TabOrder = 2
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
  object SUP: TCurrencyEdit
    Tag = 1
    Left = 147
    Top = 118
    Width = 49
    Height = 22
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      '1.00% ')
    ParentFont = False
    ReadOnly = True
    TabOrder = 4
    WantReturns = False
    WordWrap = False
    AutoSize = False
    BlockNegative = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0.00% ;###,###,##0.00%-'
    ShowCurrency = False
    TextId = 0
    Value = 1
  end
  object COF: Text8Pt
    Tag = 1
    Left = 147
    Top = 93
    Width = 102
    Height = 22
    HelpContext = 209
    AutoSize = False
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 5
    ParentFont = False
    ParentShowHint = False
    ReadOnly = True
    ShowHint = True
    TabOrder = 3
    TextId = 0
    ViaSBtn = False
  end
end
