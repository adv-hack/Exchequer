object DBkTotals: TDBkTotals
  Left = 561
  Top = 277
  ActiveControl = CanCP1Btn
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Daybook Totals'
  ClientHeight = 89
  ClientWidth = 433
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
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object CurrFLab: Label8
    Left = 12
    Top = 56
    Width = 45
    Height = 14
    Caption = 'Currency'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Tot1Lab: Label8
    Left = 16
    Top = 9
    Width = 92
    Height = 14
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Payments/Receipts'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Tot2Lab: Label8
    Left = 114
    Top = 9
    Width = 96
    Height = 14
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Net Total'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Tot3Lab: Label8
    Left = 214
    Top = 9
    Width = 99
    Height = 14
    Alignment = taRightJustify
    AutoSize = False
    Caption = ' Total'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Tot4Lab: Label8
    Left = 319
    Top = 9
    Width = 94
    Height = 14
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Total'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Bevel1: TBevel
    Left = 4
    Top = 6
    Width = 422
    Height = 2
  end
  object Bevel2: TBevel
    Left = 4
    Top = 7
    Width = 2
    Height = 74
  end
  object Bevel3: TBevel
    Left = 4
    Top = 81
    Width = 121
    Height = 2
  end
  object Bevel4: TBevel
    Left = 123
    Top = 55
    Width = 2
    Height = 27
  end
  object Bevel5: TBevel
    Left = 123
    Top = 53
    Width = 303
    Height = 2
  end
  object Bevel6: TBevel
    Left = 424
    Top = 7
    Width = 2
    Height = 46
  end
  object Tot1F: TCurrencyEdit
    Tag = 1
    Left = 10
    Top = 25
    Width = 100
    Height = 22
    TabStop = False
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      '0.10 ')
    ParentFont = False
    ReadOnly = True
    TabOrder = 0
    WantReturns = False
    WordWrap = False
    AutoSize = False
    BlockNegative = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
    ShowCurrency = False
    TextId = 0
    Value = 0.1
  end
  object Tot3F: TCurrencyEdit
    Tag = 1
    Left = 214
    Top = 25
    Width = 100
    Height = 22
    TabStop = False
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      '0.10 ')
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
    Value = 0.1
  end
  object Tot2F: TCurrencyEdit
    Tag = 1
    Left = 112
    Top = 25
    Width = 100
    Height = 22
    TabStop = False
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      '0.10 ')
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
    Value = 0.1
  end
  object Tot4F: TCurrencyEdit
    Tag = 1
    Left = 316
    Top = 25
    Width = 100
    Height = 22
    TabStop = False
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      '0.10 ')
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
    Value = 0.1
  end
  object CurrF: TSBSComboBox
    Tag = 1
    Left = 57
    Top = 53
    Width = 53
    Height = 22
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 14
    MaxLength = 3
    ParentFont = False
    TabOrder = 4
    OnChange = CurrFChange
    ExtendedList = True
    MaxListWidth = 120
    Validate = True
  end
  object CanCP1Btn: TButton
    Tag = 1
    Left = 346
    Top = 63
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Close'
    ModalResult = 2
    TabOrder = 5
    OnClick = CanCP1BtnClick
  end
end
