inherited RepInpMsg8: TRepInpMsg8
  Left = 381
  Top = 248
  HelpContext = 580
  Caption = 'Bank Reconciliation'
  ClientHeight = 216
  PixelsPerInch = 96
  TextHeight = 14
  inherited SBSPanel4: TSBSBackGroup
    Top = 4
    Height = 169
  end
  object Label87: Label8 [1]
    Left = 36
    Top = 23
    Width = 112
    Height = 14
    Alignment = taRightJustify
    Caption = 'Last Transaction Date :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label81: Label8 [2]
    Left = 45
    Top = 47
    Width = 103
    Height = 14
    Alignment = taRightJustify
    Caption = 'Report for Currency :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label85: Label8 [3]
    Left = 24
    Top = 72
    Width = 126
    Height = 14
    Alignment = taRightJustify
    Caption = 'Bank Statement Balance : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label82: Label8 [4]
    Left = 68
    Top = 99
    Width = 81
    Height = 14
    Alignment = taRightJustify
    Caption = 'Bank G/L Code : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label84: Label8 [5]
    Left = 39
    Top = 121
    Width = 109
    Height = 14
    Alignment = taRightJustify
    Caption = 'Up to which Per/Year :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label88: Label8 [6]
    Left = 11
    Top = 145
    Width = 139
    Height = 14
    Alignment = taRightJustify
    Caption = 'Group SRC'#39's by Pay-In Ref : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  inherited OkCP1Btn: TButton
    Top = 185
    TabOrder = 6
  end
  inherited ClsCP1Btn: TButton
    Top = 185
    TabOrder = 7
  end
  inherited SBSPanel1: TSBSPanel
    TabOrder = 8
  end
  object I1TransDateF: TEditDate
    Tag = 1
    Left = 151
    Top = 19
    Width = 80
    Height = 22
    HelpContext = 581
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
    TabOrder = 0
    Placement = cpAbove
  end
  object CurrF: TSBSComboBox
    Tag = 1
    Left = 151
    Top = 44
    Width = 57
    Height = 22
    HelpContext = 561
    Style = csDropDownList
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 14
    MaxLength = 3
    ParentFont = False
    TabOrder = 1
    ExtendedList = True
    MaxListWidth = 90
    Validate = True
  end
  object AgeInt: TCurrencyEdit
    Left = 151
    Top = 69
    Width = 107
    Height = 22
    HelpContext = 582
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      '0.00 ')
    ParentFont = False
    TabOrder = 2
    WantReturns = False
    WordWrap = False
    AutoSize = False
    BlockNegative = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
    ShowCurrency = False
    TextId = 0
    Value = 1E-10
  end
  object ACFF: Text8Pt
    Tag = 1
    Left = 151
    Top = 94
    Width = 69
    Height = 22
    HelpContext = 562
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    OnExit = ACFFExit
    TextId = 0
    ViaSBtn = False
  end
  object I1PrYrF: TEditPeriod
    Tag = 1
    Left = 151
    Top = 119
    Width = 59
    Height = 22
    HelpContext = 583
    AutoSelect = False
    EditMask = '00/0000;0;'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 7
    ParentFont = False
    TabOrder = 4
    Text = '011996'
    Placement = cpAbove
    EPeriod = 1
    EYear = 96
    ViewMask = '000/0000;0;'
    OnConvDate = I1PrYrFConvDate
    OnShowPeriod = I1PrYrFShowPeriod
  end
  object Back1: TBorCheck
    Left = 148
    Top = 143
    Width = 17
    Height = 20
    HelpContext = 584
    Caption = 'BorCheck2'
    CheckColor = clWindowText
    Color = clBtnFace
    ParentColor = False
    TabOrder = 5
    TabStop = True
    TextId = 0
  end
end
