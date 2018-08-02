inherited RepInpMsg4: TRepInpMsg4
  Left = 187
  Top = 176
  HelpContext = 621
  Caption = 'Statement Run'
  ClientHeight = 268
  PixelsPerInch = 96
  TextHeight = 14
  inherited SBSPanel4: TSBSBackGroup
    Height = 227
  end
  object Label87: Label8 [1]
    Left = 37
    Top = 20
    Width = 106
    Height = 14
    Alignment = taRightJustify
    Caption = 'Aged Analysis as at : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label86: Label8 [2]
    Left = 18
    Top = 47
    Width = 125
    Height = 14
    Alignment = taRightJustify
    Caption = 'Show matched in month : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label84: Label8 [3]
    Left = 48
    Top = 100
    Width = 95
    Height = 14
    Alignment = taRightJustify
    Caption = 'Age Statement by : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label85: Label8 [4]
    Left = 62
    Top = 126
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
  object Label81: Label8 [5]
    Left = 34
    Top = 150
    Width = 109
    Height = 14
    Alignment = taRightJustify
    Caption = 'Separate Currencies : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label83: Label8 [6]
    Left = 18
    Top = 70
    Width = 125
    Height = 14
    Alignment = taRightJustify
    Caption = 'Account No. range from : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label82: Label8 [7]
    Left = 204
    Top = 69
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
  object Label88: Label8 [8]
    Left = 42
    Top = 171
    Width = 101
    Height = 14
    Alignment = taRightJustify
    Caption = 'Account type filter  : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label89: Label8 [9]
    Left = 20
    Top = 202
    Width = 123
    Height = 14
    Alignment = taRightJustify
    Caption = 'Produce Statements for : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label810: Label8 [10]
    Left = 167
    Top = 148
    Width = 53
    Height = 14
    Alignment = taRightJustify
    Caption = 'Curr Filter :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label811: Label8 [11]
    Left = 170
    Top = 47
    Width = 43
    Height = 14
    Alignment = taRightJustify
    Caption = 'Include : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    Visible = False
    TextId = 0
  end
  inherited OkCP1Btn: TButton
    Top = 242
    TabOrder = 10
  end
  inherited ClsCP1Btn: TButton
    Top = 242
    TabOrder = 11
  end
  inherited SBSPanel1: TSBSPanel
    TabOrder = 13
  end
  object AgeX: TSBSComboBox
    Left = 145
    Top = 94
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
    TabOrder = 5
    Items.Strings = (
      'Days'
      'Weeks'
      'Months')
    MaxListWidth = 0
  end
  object AgeInt: TCurrencyEdit
    Left = 145
    Top = 121
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
    MaxLength = 4
    ParentFont = False
    TabOrder = 6
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
  object I1TransDateF: TEditDate
    Tag = 1
    Left = 145
    Top = 16
    Width = 80
    Height = 22
    HelpContext = 640
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
  object OS1: TBorCheck
    Left = 142
    Top = 43
    Width = 17
    Height = 20
    HelpContext = 641
    Caption = 'OS1'
    CheckColor = clWindowText
    Color = clBtnFace
    ParentColor = False
    TabOrder = 1
    TabStop = True
    TextId = 0
  end
  object SepCr: TBorCheck
    Left = 142
    Top = 145
    Width = 17
    Height = 20
    HelpContext = 643
    Caption = 'OS1'
    CheckColor = clWindowText
    Color = clBtnFace
    ParentColor = False
    TabOrder = 7
    TabStop = True
    TextId = 0
    OnClick = Label81Click
  end
  object ACFF: Text8Pt
    Tag = 1
    Left = 145
    Top = 66
    Width = 55
    Height = 22
    Hint = 
      'Double click to drill down|Double clicking or using the down but' +
      'ton will drill down to the record for this field. The up button ' +
      'will search for the nearest match.'
    HelpContext = 642
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
    Link_to_Cust = True
    ShowHilight = True
  end
  object ACTF: Text8Pt
    Tag = 1
    Left = 224
    Top = 66
    Width = 55
    Height = 22
    Hint = 
      'Double click to drill down|Double clicking or using the down but' +
      'ton will drill down to the record for this field. The up button ' +
      'will search for the nearest match.'
    HelpContext = 642
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    OnExit = ACFFExit
    TextId = 0
    ViaSBtn = False
    Link_to_Cust = True
    ShowHilight = True
  end
  object ACFI: Text8Pt
    Tag = 1
    Left = 145
    Top = 167
    Width = 49
    Height = 22
    HelpContext = 644
    Color = clWhite
    EditMask = '>cccc;0; '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 4
    ParentFont = False
    TabOrder = 9
    TextId = 0
    ViaSBtn = False
  end
  object FilterX: TSBSComboBox
    Left = 145
    Top = 196
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
    TabOrder = 12
    Items.Strings = (
      'All Accounts'
      'Hard Copy '
      'Fax '
      'Email')
    MaxListWidth = 0
  end
  object CurrF: TSBSComboBox
    Tag = 1
    Left = 224
    Top = 144
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
    TabOrder = 8
    ExtendedList = True
    MaxListWidth = 90
    Validate = True
  end
  object IncF: TSBSComboBox
    Left = 210
    Top = 41
    Width = 67
    Height = 22
    HelpContext = 1582
    Style = csDropDownList
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 14
    ParentFont = False
    TabOrder = 2
    Visible = False
    Items.Strings = (
      '+/- Bal'
      '+ve Bal')
    MaxListWidth = 0
  end
end
