inherited RepInpMsgR: TRepInpMsgR
  HelpContext = 675
  Caption = 'Stock Availability by Bin Report'
  ClientHeight = 242
  PixelsPerInch = 96
  TextHeight = 14
  inherited SBSPanel4: TSBSBackGroup
    Height = 209
  end
  object Label81: Label8 [1]
    Left = 28
    Top = 32
    Width = 85
    Height = 14
    Alignment = taRightJustify
    Caption = 'Product / Group : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label83: Label8 [2]
    Left = 64
    Top = 79
    Width = 47
    Height = 14
    Alignment = taRightJustify
    Caption = 'Sort by :  '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label810: Label8 [3]
    Left = 61
    Top = 132
    Width = 50
    Height = 14
    Alignment = taRightJustify
    Caption = 'Bin Filter : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object LocLab: Label8 [4]
    Left = 52
    Top = 158
    Width = 59
    Height = 14
    Alignment = taRightJustify
    Caption = 'Locn Filter : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label86: Label8 [5]
    Left = 16
    Top = 104
    Width = 90
    Height = 14
    Alignment = taRightJustify
    Caption = 'Date Range. from :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label87: Label8 [6]
    Left = 194
    Top = 106
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
  object Label82: Label8 [7]
    Left = 52
    Top = 183
    Width = 59
    Height = 14
    Alignment = taRightJustify
    Caption = 'Filter Bins :  '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label84: Label8 [8]
    Left = 170
    Top = 131
    Width = 33
    Height = 14
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Tag :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label85: Label8 [9]
    Left = 19
    Top = 55
    Width = 92
    Height = 14
    Alignment = taRightJustify
    Caption = 'Transaction Filter : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  inherited OkCP1Btn: TButton
    Left = 67
    Top = 216
    TabOrder = 9
  end
  inherited ClsCP1Btn: TButton
    Left = 153
    Top = 216
    TabOrder = 10
  end
  inherited SBSPanel1: TSBSPanel
    TabOrder = 11
  end
  object ACFF: Text8Pt
    Tag = 1
    Left = 111
    Top = 25
    Width = 99
    Height = 22
    Hint = 
      'Double click to drill down|Double clicking or using the down but' +
      'ton will drill down to the record for this field. The up button ' +
      'will search for the nearest match.'
    HelpContext = 683
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnExit = ACFFExit
    TextId = 0
    ViaSBtn = False
    Link_to_Stock = True
    ShowHilight = True
  end
  object SxSF: TSBSComboBox
    Tag = 1
    Left = 111
    Top = 76
    Width = 99
    Height = 22
    HelpContext = 1482
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
    Items.Strings = (
      'Bin Code'
      'Stock Code')
    MaxListWidth = 90
    Validate = True
  end
  object DocFiltF: Text8Pt
    Left = 111
    Top = 128
    Width = 57
    Height = 22
    HelpContext = 1483
    Color = clWhite
    EditMask = '>cccccccc;0; '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 8
    ParentFont = False
    TabOrder = 5
    OnEnter = DocFiltFEnter
    TextId = 0
    ViaSBtn = False
  end
  object LocF: Text8Pt
    Tag = 1
    Left = 111
    Top = 154
    Width = 46
    Height = 22
    HelpContext = 688
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 7
    OnExit = LocFExit
    TextId = 0
    ViaSBtn = False
  end
  object I1TransDateF: TEditDate
    Tag = 1
    Left = 111
    Top = 102
    Width = 80
    Height = 22
    HelpContext = 682
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
    TabOrder = 3
    Placement = cpAbove
  end
  object I2TransDateF: TEditDate
    Tag = 1
    Left = 206
    Top = 102
    Width = 80
    Height = 22
    HelpContext = 682
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
    TabOrder = 4
    Placement = cpAbove
  end
  object FxLBCB: TSBSComboBox
    Tag = 1
    Left = 111
    Top = 180
    Width = 118
    Height = 22
    HelpContext = 1484
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
    Items.Strings = (
      'Include all Bins'
      'Exclude Hold Bins '
      'Only Inc. Bins on Hold')
    MaxListWidth = 90
    Validate = True
  end
  object AgeInt: TCurrencyEdit
    Left = 206
    Top = 128
    Width = 33
    Height = 22
    Hint = 
      'Enter Run Noumber.|Enter the run number of the posting report yo' +
      'u wish to reprint. 0 for unposted items, -1 for all posting runs' +
      '.'
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      '0 ')
    MaxLength = 2
    ParentFont = False
    TabOrder = 6
    WantReturns = False
    WordWrap = False
    OnKeyPress = AgeIntKeyPress
    AutoSize = False
    BlockNegative = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0 ;###,###,##0-'
    DecPlaces = 0
    ShowCurrency = False
    TextId = 0
    Value = 1E-10
  end
  object OrdFiltF: Text8Pt
    Left = 111
    Top = 51
    Width = 100
    Height = 22
    HelpContext = 1483
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 9
    ParentFont = False
    TabOrder = 1
    OnExit = OrdFiltFExit
    TextId = 0
    ViaSBtn = False
  end
end
