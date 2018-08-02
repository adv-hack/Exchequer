inherited RepInpMsgA: TRepInpMsgA
  Left = 18
  Top = 159
  HelpContext = 623
  Caption = 'RepInpMsgA'
  ClientHeight = 224
  ClientWidth = 326
  PixelsPerInch = 96
  TextHeight = 14
  inherited SBSPanel4: TSBSBackGroup
    Left = 4
    Width = 317
    Height = 191
  end
  object Label84: Label8 [1]
    Left = 25
    Top = 74
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
  object Label811: Label8 [2]
    Left = 192
    Top = 75
    Width = 63
    Height = 14
    Alignment = taRightJustify
    Caption = 'Translate to :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label85: Label8 [3]
    Left = 14
    Top = 99
    Width = 114
    Height = 14
    Alignment = taRightJustify
    Caption = 'Report to Level (0=All) :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label86: Label8 [4]
    Left = 66
    Top = 23
    Width = 62
    Height = 14
    Alignment = taRightJustify
    Caption = 'Period/Year :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object GLSLAb: Label8 [5]
    Left = 13
    Top = 51
    Width = 118
    Height = 14
    Alignment = taRightJustify
    Caption = 'General Ledger Range : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object GLELab: Label8 [6]
    Left = 211
    Top = 49
    Width = 15
    Height = 14
    Alignment = taRightJustify
    Caption = 'to :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label88: Label8 [7]
    Left = 20
    Top = 124
    Width = 108
    Height = 14
    Alignment = taRightJustify
    Caption = 'Cost Centre/Dept/Tag :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  inherited OkCP1Btn: TButton
    Left = 81
    Top = 198
    TabOrder = 13
  end
  inherited ClsCP1Btn: TButton
    Left = 167
    Top = 198
    TabOrder = 14
  end
  inherited SBSPanel1: TSBSPanel
    TabOrder = 15
  end
  object CurrF: TSBSComboBox
    Tag = 1
    Left = 130
    Top = 71
    Width = 57
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
    TabOrder = 4
    ExtendedList = True
    MaxListWidth = 90
    Validate = True
  end
  object CurrF2: TSBSComboBox
    Tag = 1
    Left = 257
    Top = 71
    Width = 57
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
    TabOrder = 5
    ExtendedList = True
    MaxListWidth = 90
    Validate = True
  end
  object AgeInt: TCurrencyEdit
    Left = 130
    Top = 96
    Width = 42
    Height = 22
    HelpContext = 650
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      '0 ')
    MaxLength = 3
    ParentFont = False
    TabOrder = 6
    WantReturns = False
    WordWrap = False
    OnKeyPress = AgeIntKeyPress
    AutoSize = False
    BlockNegative = True
    BlankOnZero = False
    DisplayFormat = '###,###,##0 ;###,###,##0-'
    DecPlaces = 0
    ShowCurrency = False
    TextId = 0
    Value = 1E-10
  end
  object I1PrYrF: TEditPeriod
    Tag = 1
    Left = 130
    Top = 21
    Width = 59
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
    TabOrder = 0
    Text = '011996'
    Placement = cpAbove
    EPeriod = 1
    EYear = 96
    ViewMask = '000/0000;0;'
    OnConvDate = I1PrYrFConvDate
    OnShowPeriod = I1PrYrFShowPeriod
  end
  object CYTDF: TBorCheck
    Left = 209
    Top = 20
    Width = 104
    Height = 20
    HelpContext = 647
    Caption = 'Comparative YTD'
    CheckColor = clWindowText
    Color = clBtnFace
    ParentColor = False
    TabOrder = 1
    TabStop = True
    TextId = 0
  end
  object IncZBF: TBorCheck
    Left = 12
    Top = 143
    Width = 134
    Height = 20
    HelpContext = 651
    Caption = 'Include Zero Balances :'
    CheckColor = clWindowText
    Color = clBtnFace
    ParentColor = False
    TabOrder = 11
    TabStop = True
    TextId = 0
  end
  object ACFF: Text8Pt
    Tag = 1
    Left = 130
    Top = 46
    Width = 74
    Height = 22
    HelpContext = 648
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    OnExit = ACFFExit
    TextId = 0
    ViaSBtn = False
  end
  object ACCF2: Text8Pt
    Tag = 1
    Left = 229
    Top = 46
    Width = 84
    Height = 22
    HelpContext = 648
    Color = clWhite
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
  object Id3CCF: Text8Pt
    Tag = 1
    Left = 130
    Top = 121
    Width = 46
    Height = 22
    HelpContext = 762
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 3
    ParentFont = False
    TabOrder = 8
    OnEnter = Id3CCFEnter
    OnExit = Id3CCFExit
    TextId = 0
    ViaSBtn = False
  end
  object Id3DepF: Text8Pt
    Tag = 1
    Left = 181
    Top = 121
    Width = 46
    Height = 22
    HelpContext = 762
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 3
    ParentFont = False
    TabOrder = 9
    OnEnter = Id3CCFEnter
    OnExit = Id3CCFExit
    TextId = 0
    ViaSBtn = False
  end
  object CommitMCB: TSBSComboBox
    Tag = 1
    Left = 177
    Top = 96
    Width = 137
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
    TabOrder = 7
    Visible = False
    Items.Strings = (
      'Show Actuals only'
      'Combine Committed & Actuals'
      'Show Committed only')
    MaxListWidth = 90
    Validate = True
  end
  object ccTagChk: TBorCheck
    Left = 231
    Top = 122
    Width = 16
    Height = 20
    HelpContext = 762
    CheckColor = clWindowText
    Color = clBtnFace
    ParentColor = False
    TabOrder = 10
    TabStop = True
    TextId = 0
  end
  object chkPrintParameters: TBorCheck
    Left = 8
    Top = 164
    Width = 138
    Height = 20
    HelpContext = 8062
    Caption = 'Print Report Parameters :'
    CheckColor = clWindowText
    Color = clBtnFace
    ParentColor = False
    TabOrder = 12
    TabStop = True
    TextId = 0
  end
end
