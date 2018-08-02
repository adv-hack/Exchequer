object StkTake: TStkTake
  Left = 229
  Top = 577
  HelpContext = 517
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Stock Take Entry'
  ClientHeight = 152
  ClientWidth = 427
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  KeyPreview = True
  OldCreateOrder = True
  Position = poDefault
  Scaled = False
  Visible = True
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object SBSBackGroup1: TSBSBackGroup
    Left = 3
    Top = 0
    Width = 421
    Height = 147
    TextId = 0
  end
  object Label81: Label8
    Left = 291
    Top = 20
    Width = 38
    Height = 14
    Caption = 'In Stock'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label82: Label8
    Left = 297
    Top = 47
    Width = 31
    Height = 14
    Caption = 'Actual'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label83: Label8
    Left = 275
    Top = 73
    Width = 55
    Height = 14
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Difference'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Bevel1: TBevel
    Left = 261
    Top = 14
    Width = 2
    Height = 76
  end
  object StkDescLab: Label8
    Left = 14
    Top = 46
    Width = 55
    Height = 14
    Caption = 'Stock Desc'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label87: Label8
    Left = 26
    Top = 72
    Width = 42
    Height = 14
    Caption = 'Bin Locn'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label89: Label8
    Left = 14
    Top = 19
    Width = 55
    Height = 14
    Caption = 'Stock Code'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object StkDesc: Text8Pt
    Left = 77
    Top = 42
    Width = 166
    Height = 22
    TabStop = False
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ReadOnly = True
    ShowHint = True
    TabOrder = 1
    TextId = 0
    ViaSBtn = False
  end
  object OkCP1Btn: TButton
    Tag = 1
    Left = 132
    Top = 115
    Width = 81
    Height = 21
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 6
    OnClick = CanCP1BtnClick
  end
  object CanCP1Btn: TButton
    Left = 217
    Top = 115
    Width = 81
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 7
    OnClick = CanCP1BtnClick
  end
  object FreeStk: TCurrencyEdit
    Left = 335
    Top = 15
    Width = 80
    Height = 22
    HelpContext = 247
    TabStop = False
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      '0.67-')
    ParentFont = False
    ReadOnly = True
    TabOrder = 3
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
  object OnOrd: TCurrencyEdit
    Left = 335
    Top = 69
    Width = 80
    Height = 22
    TabStop = False
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      '0.67-')
    ParentFont = False
    ReadOnly = True
    TabOrder = 5
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
  object OrdQty: TCurrencyEdit
    Tag = 1
    Left = 335
    Top = 42
    Width = 80
    Height = 22
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      '0.67-')
    MaxLength = 13
    ParentFont = False
    ReadOnly = True
    TabOrder = 4
    WantReturns = False
    WordWrap = False
    OnExit = OrdQtyExit
    AutoSize = False
    BlockNegative = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
    ShowCurrency = False
    TextId = 0
    Value = -0.666666
  end
  object BinLocn: Text8Pt
    Left = 77
    Top = 70
    Width = 98
    Height = 22
    TabStop = False
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ReadOnly = True
    ShowHint = True
    TabOrder = 2
    TextId = 0
    ViaSBtn = False
  end
  object StkCodeF: Text8Pt
    Left = 77
    Top = 15
    Width = 128
    Height = 22
    TabStop = False
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ReadOnly = True
    ShowHint = True
    TabOrder = 0
    TextId = 0
    ViaSBtn = False
  end
end
