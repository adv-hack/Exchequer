inherited RepInpMsg9: TRepInpMsg9
  Left = 522
  Top = 201
  HelpContext = 627
  Caption = 'RepInpMsg9'
  ClientHeight = 278
  ClientWidth = 420
  PixelsPerInch = 96
  TextHeight = 14
  inherited SBSPanel4: TSBSBackGroup
    Left = 7
    Top = 5
    Width = 405
    Height = 242
  end
  object Label85: Label8 [1]
    Left = 33
    Top = 22
    Width = 109
    Height = 14
    Alignment = taRightJustify
    Caption = 'Folio No. Range from : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label82: Label8 [2]
    Left = 254
    Top = 21
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
  object Label81: Label8 [3]
    Left = 24
    Top = 49
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
  object Label83: Label8 [4]
    Left = 215
    Top = 47
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
  object Label84: Label8 [5]
    Left = 36
    Top = 72
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
  object Label87: Label8 [6]
    Left = 205
    Top = 97
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
    Left = 32
    Top = 148
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
  object Label89: Label8 [8]
    Left = 50
    Top = 174
    Width = 93
    Height = 14
    Alignment = taRightJustify
    Caption = 'Account No. filter : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label810: Label8 [9]
    Left = 34
    Top = 199
    Width = 106
    Height = 14
    Alignment = taRightJustify
    Caption = 'Document Type/Filter :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label811: Label8 [10]
    Left = 204
    Top = 73
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
  object Label812: Label8 [11]
    Left = 227
    Top = 123
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
  inherited OkCP1Btn: TButton
    Left = 132
    Top = 253
    TabOrder = 20
  end
  inherited ClsCP1Btn: TButton
    Left = 218
    Top = 253
    TabOrder = 21
  end
  inherited SBSPanel1: TSBSPanel
    TabOrder = 23
  end
  object AgeInt: TCurrencyEdit
    Left = 142
    Top = 19
    Width = 107
    Height = 22
    HelpContext = 657
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      '0 ')
    ParentFont = False
    TabOrder = 0
    WantReturns = False
    WordWrap = False
    OnExit = AgeIntExit
    AutoSize = False
    BlockNegative = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0 ;###,###,##0-'
    DecPlaces = 0
    ShowCurrency = False
    TextId = 0
    Value = 1E-10
  end
  object AgeInt2: TCurrencyEdit
    Left = 272
    Top = 19
    Width = 107
    Height = 22
    HelpContext = 657
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      '0 ')
    ParentFont = False
    TabOrder = 1
    WantReturns = False
    WordWrap = False
    OnExit = AgeInt2Exit
    AutoSize = False
    BlockNegative = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0 ;###,###,##0-'
    DecPlaces = 0
    ShowCurrency = False
    TextId = 0
    Value = 1E-10
  end
  object ACFF: Text8Pt
    Tag = 1
    Left = 142
    Top = 44
    Width = 69
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
    Left = 233
    Top = 44
    Width = 69
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
  object CurrF: TSBSComboBox
    Tag = 1
    Left = 142
    Top = 69
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
    Left = 272
    Top = 69
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
  object I1PrYrF: TEditPeriod
    Tag = 1
    Left = 142
    Top = 94
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
    TabOrder = 7
    Text = '011996'
    Placement = cpAbove
    EPeriod = 1
    EYear = 96
    ViewMask = '000/0000;0;'
    OnConvDate = I1PrYrFConvDate
    OnShowPeriod = I1PrYrFShowPeriod
  end
  object I2PrYrF: TEditPeriod
    Tag = 1
    Left = 221
    Top = 94
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
    TabOrder = 8
    Text = '011996'
    Placement = cpAbove
    EPeriod = 1
    EYear = 96
    ViewMask = '000/0000;0;'
    OnConvDate = I1PrYrFConvDate
    OnShowPeriod = I1PrYrFShowPeriod
  end
  object Id3CCF: Text8Pt
    Tag = 1
    Left = 142
    Top = 145
    Width = 46
    Height = 22
    HelpContext = 762
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 12
    OnExit = Id3CCFExit
    TextId = 0
    ViaSBtn = False
  end
  object Id3DepF: Text8Pt
    Tag = 1
    Left = 193
    Top = 145
    Width = 46
    Height = 22
    HelpContext = 762
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 13
    OnExit = Id3CCFExit
    TextId = 0
    ViaSBtn = False
  end
  object AccF3: Text8Pt
    Tag = 1
    Left = 142
    Top = 170
    Width = 78
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
    TabOrder = 16
    OnExit = AccF3Exit
    TextId = 0
    ViaSBtn = False
    Link_to_Cust = True
    ShowHilight = True
  end
  object DocFiltF: Text8Pt
    Left = 142
    Top = 195
    Width = 57
    Height = 22
    HelpContext = 653
    Color = clWhite
    EditMask = '>ccc;0; '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 3
    ParentFont = False
    TabOrder = 18
    OnExit = DocFiltFExit
    TextId = 0
    ViaSBtn = False
  end
  object Sum1: TBorCheck
    Left = 208
    Top = 195
    Width = 104
    Height = 20
    HelpContext = 750
    Caption = 'Summary Report :'
    CheckColor = clWindowText
    Color = clBtnFace
    ParentColor = False
    TabOrder = 19
    TabStop = True
    TextId = 0
  end
  object CommitMCB: TSBSComboBox
    Tag = 1
    Left = 268
    Top = 145
    Width = 134
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
    TabOrder = 15
    Visible = False
    Items.Strings = (
      'Show Actuals only'
      'Combine Committed & Actuals'
      'Show Committed only')
    MaxListWidth = 90
    Validate = True
  end
  object ccTagChk: TBorCheck
    Left = 246
    Top = 146
    Width = 16
    Height = 20
    HelpContext = 762
    CheckColor = clWindowText
    Color = clBtnFace
    ParentColor = False
    TabOrder = 14
    TextId = 0
  end
  object UPF: TBorRadio
    Left = 16
    Top = 92
    Width = 120
    Height = 20
    Caption = 'Period/Year Range'
    Checked = True
    GroupIndex = 1
    TabOrder = 6
    TabStop = True
    TextId = 0
  end
  object UDF: TBorRadio
    Left = 21
    Top = 118
    Width = 116
    Height = 20
    HelpContext = 692
    AutoSet = False
    Caption = 'Date Range from'
    GroupIndex = 1
    TabOrder = 9
    TabStop = True
    TextId = 0
  end
  object I1TransDateF: TEditDate
    Tag = 1
    Left = 141
    Top = 119
    Width = 80
    Height = 22
    HelpContext = 692
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
    TabOrder = 10
    Placement = cpAbove
  end
  object I2TransDateF: TEditDate
    Tag = 1
    Left = 244
    Top = 119
    Width = 80
    Height = 22
    HelpContext = 692
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
    TabOrder = 11
    Placement = cpAbove
  end
  object chkPrintParameters: TBorCheck
    Left = 17
    Top = 219
    Width = 138
    Height = 20
    HelpContext = 8062
    Caption = 'Print Report Parameters: '
    CheckColor = clWindowText
    Color = clBtnFace
    ParentColor = False
    TabOrder = 22
    TextId = 0
  end
  object cbAccountTypes: TSBSComboBox
    Tag = 1
    Left = 224
    Top = 170
    Width = 178
    Height = 22
    HelpContext = 8098
    Style = csDropDownList
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 14
    ItemIndex = 0
    ParentFont = False
    TabOrder = 17
    Text = 'Customers & Consumers'
    Items.Strings = (
      'Customers & Consumers'
      'Customers Only'
      'Consumers Only')
    MaxListWidth = 77
    Validate = True
  end
end
