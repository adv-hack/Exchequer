object frmMBDDetails: TfrmMBDDetails
  Left = 392
  Top = 227
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsDialog
  Caption = 'Add Multi-Buy Discount'
  ClientHeight = 203
  ClientWidth = 280
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poDefault
  OnActivate = FormActivate
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 14
  object lblStockCode: Label8
    Left = 47
    Top = 10
    Width = 55
    Height = 14
    Alignment = taRightJustify
    Caption = 'Stock Code'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label811: Label8
    Left = 182
    Top = 140
    Width = 11
    Height = 14
    Caption = 'To'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label814: Label8
    Left = 32
    Top = 62
    Width = 70
    Height = 14
    Alignment = taRightJustify
    Caption = 'Multi-Buy Type'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label815: Label8
    Left = 40
    Top = 88
    Width = 62
    Height = 14
    Alignment = taRightJustify
    Caption = 'Buy Quantity'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object lblReward: Label8
    Left = 78
    Top = 114
    Width = 24
    Height = 14
    Alignment = taRightJustify
    Caption = 'Price'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object lblStockDesc: Label8
    Left = 47
    Top = 36
    Width = 55
    Height = 14
    Alignment = taRightJustify
    Caption = 'Stock Desc'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object btnOK: TButton
    Tag = 1
    Left = 58
    Top = 172
    Width = 80
    Height = 21
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 9
  end
  object btnCancel: TButton
    Tag = 1
    Left = 142
    Top = 172
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 10
  end
  object cbCurrency: TSBSComboBox
    Tag = 1
    Left = 106
    Top = 110
    Width = 60
    Height = 22
    HelpContext = 123
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 14
    ParentFont = False
    TabOrder = 4
    Text = 'GBP'
    Items.Strings = (
      ''
      'A'
      'B'
      'C'
      'D'
      'E'
      'F'
      'G'
      'H')
    ExtendedList = True
    MaxListWidth = 0
    Validate = True
  end
  object edtStockCode: Text8Pt
    Left = 106
    Top = 6
    Width = 121
    Height = 22
    HelpContext = 8006
    TabStop = False
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    OnExit = edtStockCodeExit
    TextId = 0
    ViaSBtn = False
  end
  object edtStockDesc: Text8Pt
    Left = 106
    Top = 32
    Width = 162
    Height = 22
    HelpContext = 120
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
  object deStartDate: TEditDate
    Tag = 1
    Left = 106
    Top = 136
    Width = 69
    Height = 22
    HelpContext = 1575
    AutoSelect = False
    Color = clWhite
    EditMask = '00/00/0000;0;'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 10
    ParentFont = False
    TabOrder = 7
    Placement = cpAbove
    AllowBlank = True
  end
  object deEndDate: TEditDate
    Tag = 1
    Left = 200
    Top = 136
    Width = 68
    Height = 22
    HelpContext = 1575
    AutoSelect = False
    Color = clWhite
    EditMask = '00/00/0000;0;'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 10
    ParentFont = False
    TabOrder = 8
    Placement = cpAbove
    AllowBlank = True
  end
  object chkUseDates: TBorCheckEx
    Left = 9
    Top = 136
    Width = 93
    Height = 20
    HelpContext = 1575
    Caption = 'Effective Dates'
    Color = clBtnFace
    ParentColor = False
    TabOrder = 6
    TabStop = True
    TextId = 0
    OnClick = chkUseDatesClick
  end
  object ceBuyQty: TCurrencyEdit
    Tag = 1
    Left = 106
    Top = 84
    Width = 99
    Height = 22
    HelpContext = 8008
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      '3.00 ')
    MaxLength = 12
    ParentFont = False
    TabOrder = 3
    WantReturns = False
    WordWrap = False
    AutoSize = False
    BlockNegative = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0.00 '
    ShowCurrency = False
    TextId = 0
    Value = 3
  end
  object ceRewardValue: TCurrencyEdit
    Tag = 1
    Left = 168
    Top = 110
    Width = 99
    Height = 22
    HelpContext = 8009
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      '1.00 ')
    MaxLength = 13
    ParentFont = False
    TabOrder = 5
    WantReturns = False
    WordWrap = False
    AutoSize = False
    BlockNegative = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
    ShowCurrency = False
    TextId = 0
    Value = 1
  end
  object cbType: TComboBox
    Left = 106
    Top = 58
    Width = 161
    Height = 22
    HelpContext = 8007
    Style = csDropDownList
    Color = clWhite
    Font.Charset = ANSI_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 14
    ItemIndex = 0
    ParentFont = False
    TabOrder = 2
    Text = 'Buy X Get Y Free'
    OnChange = cbTypeChange
    Items.Strings = (
      'Buy X Get Y Free'
      'Buy X For Specified Price'
      'Buy X Get Y% Off')
  end
  object EnterToTab1: TEnterToTab
    ConvertEnters = True
    OverrideFont = True
    Version = 'TEnterToTab v1.02 for Delphi 6.01'
    Left = 240
    Top = 168
  end
end
