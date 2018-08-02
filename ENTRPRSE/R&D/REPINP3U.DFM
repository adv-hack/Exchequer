inherited RepInpMsg3: TRepInpMsg3
  Left = 751
  Top = 180
  HelpContext = 42
  Caption = 'Aged'
  ClientHeight = 284
  ClientWidth = 311
  PixelsPerInch = 96
  TextHeight = 14
  inherited SBSPanel4: TSBSBackGroup
    Width = 300
    Height = 245
  end
  object Label82: Label8 [1]
    Left = 31
    Top = 14
    Width = 114
    Height = 14
    Alignment = taRightJustify
    Caption = 'Summary Only Report : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label81: Label8 [2]
    Left = 39
    Top = 34
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
  object Label83: Label8 [3]
    Left = 28
    Top = 83
    Width = 114
    Height = 14
    Alignment = taRightJustify
    Caption = 'Cost Centre/Dept Filter :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label84: Label8 [4]
    Left = 65
    Top = 111
    Width = 79
    Height = 14
    Alignment = taRightJustify
    Caption = 'Age Report by : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label85: Label8 [5]
    Left = 63
    Top = 137
    Width = 81
    Height = 14
    Alignment = taRightJustify
    Caption = 'Ageing Interval : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label86: Label8 [6]
    Left = 26
    Top = 159
    Width = 118
    Height = 14
    Alignment = taRightJustify
    Caption = 'O/S Transactions Only : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label87: Label8 [7]
    Left = 15
    Top = 181
    Width = 129
    Height = 14
    Alignment = taRightJustify
    Caption = 'Posted Bal as at (Per/Yr) : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label88: Label8 [8]
    Left = 39
    Top = 203
    Width = 105
    Height = 14
    Alignment = taRightJustify
    Caption = 'Back-Date to Per/Yr : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label811: Label8 [9]
    Left = 200
    Top = 34
    Width = 29
    Height = 14
    Alignment = taRightJustify
    Caption = 'Txlate'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label810: Label8 [10]
    Left = 24
    Top = 59
    Width = 118
    Height = 14
    Alignment = taRightJustify
    Caption = 'Account / Ctrl A/C Filter :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label89: Label8 [11]
    Left = 21
    Top = 223
    Width = 123
    Height = 14
    HelpContext = 8062
    Alignment = taRightJustify
    Caption = 'Print Report Parameters : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  inherited OkCP1Btn: TButton
    Left = 68
    Top = 254
    TabOrder = 12
  end
  inherited ClsCP1Btn: TButton
    Left = 154
    Top = 254
    TabOrder = 13
  end
  inherited SBSPanel1: TSBSPanel
    TabOrder = 15
  end
  object CurrF: TSBSComboBox
    Tag = 1
    Left = 145
    Top = 30
    Width = 53
    Height = 22
    HelpContext = 630
    Style = csDropDownList
    Color = clWhite
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
  object Id3CCF: Text8Pt
    Tag = 1
    Left = 145
    Top = 80
    Width = 46
    Height = 22
    HelpContext = 633
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    OnExit = Id3CCFExit
    TextId = 0
    ViaSBtn = False
  end
  object Id3DepF: Text8Pt
    Tag = 1
    Left = 196
    Top = 80
    Width = 46
    Height = 22
    HelpContext = 633
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 6
    OnExit = Id3CCFExit
    TextId = 0
    ViaSBtn = False
  end
  object AgeX: TSBSComboBox
    Left = 145
    Top = 108
    Width = 78
    Height = 22
    HelpContext = 634
    Style = csDropDownList
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 14
    ParentFont = False
    TabOrder = 7
    Items.Strings = (
      'Days'
      'Weeks'
      'Months')
    MaxListWidth = 0
  end
  object AgeInt: TCurrencyEdit
    Left = 145
    Top = 135
    Width = 37
    Height = 22
    HelpContext = 40109
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      '1 ')
    MaxLength = 3
    ParentFont = False
    TabOrder = 8
    WantReturns = False
    WordWrap = False
    AutoSize = False
    BlockNegative = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0 ;###,###,##0-'
    DecPlaces = 0
    ShowCurrency = False
    TextId = 0
    Value = 1
  end
  object I1PrYrF: TEditPeriod
    Tag = 1
    Left = 145
    Top = 178
    Width = 80
    Height = 22
    HelpContext = 636
    AutoSelect = False
    Color = clWhite
    EditMask = '00/0000;0;'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 7
    ParentFont = False
    TabOrder = 10
    Text = '011996'
    Placement = cpAbove
    EPeriod = 1
    EYear = 96
    ViewMask = '000/0000;0;'
    OnConvDate = I1PrYrFConvDate
    OnShowPeriod = I1PrYrFShowPeriod
  end
  object Back1: TBorCheck
    Left = 142
    Top = 201
    Width = 17
    Height = 20
    HelpContext = 637
    Caption = 'BorCheck2'
    CheckColor = clWindowText
    Color = clBtnFace
    ParentColor = False
    TabOrder = 11
    TabStop = True
    TextId = 0
  end
  object OS1: TBorCheck
    Left = 142
    Top = 157
    Width = 17
    Height = 20
    HelpContext = 635
    Caption = 'OS1'
    CheckColor = clWindowText
    Color = clBtnFace
    ParentColor = False
    TabOrder = 9
    TabStop = True
    TextId = 0
  end
  object Sum1: TBorCheck
    Left = 142
    Top = 10
    Width = 17
    Height = 20
    HelpContext = 632
    Caption = 'Sum1'
    CheckColor = clWindowText
    Color = clBtnFace
    ParentColor = False
    TabOrder = 0
    TabStop = True
    TextId = 0
  end
  object CurrF2: TSBSComboBox
    Tag = 1
    Left = 233
    Top = 30
    Width = 62
    Height = 22
    HelpContext = 649
    Style = csDropDownList
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 14
    MaxLength = 3
    ParentFont = False
    TabOrder = 2
    ExtendedList = True
    MaxListWidth = 90
    Validate = True
  end
  object GLMDC: Text8Pt
    Left = 224
    Top = 55
    Width = 72
    Height = 22
    HelpContext = 40104
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    OnExit = GLMDCExit
    TextId = 0
    ViaSBtn = False
  end
  object ACCF: Text8Pt
    Tag = 1
    Left = 145
    Top = 55
    Width = 71
    Height = 22
    Hint = 
      'Double click to drill down|Double clicking or using the down but' +
      'ton will drill down to the record for this field. The up button ' +
      'will search for the nearest match.'
    HelpContext = 652
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    OnExit = ACCFExit
    TextId = 0
    ViaSBtn = False
    Link_to_Cust = True
    ShowHilight = True
  end
  object chkPrintParameters: TBorCheck
    Left = 144
    Top = 221
    Width = 15
    Height = 20
    HelpContext = 8062
    CheckColor = clWindowText
    Color = clBtnFace
    ParentColor = False
    TabOrder = 14
    TextId = 0
  end
end
