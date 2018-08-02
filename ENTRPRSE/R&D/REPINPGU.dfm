inherited RepInpMsgG: TRepInpMsgG
  Left = 522
  Top = 242
  HelpContext = 662
  Caption = 'Stock Sales by Product Report'
  ClientHeight = 253
  ClientWidth = 335
  PixelsPerInch = 96
  TextHeight = 14
  inherited SBSPanel4: TSBSBackGroup
    Width = 326
    Height = 218
  end
  object Label86: Label8 [1]
    Left = 39
    Top = 33
    Width = 84
    Height = 14
    Alignment = taRightJustify
    Caption = 'Date Range. from'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label87: Label8 [2]
    Left = 213
    Top = 35
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
  object Label84: Label8 [3]
    Left = 26
    Top = 61
    Width = 97
    Height = 14
    Alignment = taRightJustify
    Caption = 'Report for Currency'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label811: Label8 [4]
    Left = 192
    Top = 62
    Width = 57
    Height = 14
    Alignment = taRightJustify
    Caption = 'Translate to'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label88: Label8 [5]
    Left = 15
    Top = 88
    Width = 108
    Height = 14
    Alignment = taRightJustify
    Caption = 'Cost Centre/Dept Filter'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object AccLab: Label8 [6]
    Left = 39
    Top = 142
    Width = 84
    Height = 14
    Alignment = taRightJustify
    Caption = 'Account No. filter'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label810: Label8 [7]
    Left = 25
    Top = 169
    Width = 98
    Height = 14
    Alignment = taRightJustify
    Caption = 'Product Code/Group'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object LocLab: Label8 [8]
    Left = 236
    Top = 88
    Width = 24
    Height = 14
    Alignment = taRightJustify
    Caption = 'Locn'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label83: Label8 [9]
    Left = 43
    Top = 114
    Width = 80
    Height = 14
    Alignment = taRightJustify
    Caption = 'Report based on'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object lblAccountTypes: Label8 [10]
    Left = 22
    Top = 195
    Width = 101
    Height = 14
    Alignment = taRightJustify
    Caption = 'Include Trader Types'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  inherited OkCP1Btn: TButton
    Left = 87
    Top = 226
    TabOrder = 11
  end
  inherited ClsCP1Btn: TButton
    Left = 173
    Top = 226
    TabOrder = 12
  end
  inherited SBSPanel1: TSBSPanel
    Left = 263
    Top = 125
    TabOrder = 13
    inherited Animated1: TAnimated
      Frame = 15
    end
  end
  object I1TransDateF: TEditDate
    Tag = 1
    Left = 127
    Top = 31
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
    TabOrder = 0
    Placement = cpAbove
  end
  object I2TransDateF: TEditDate
    Tag = 1
    Left = 230
    Top = 31
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
    TabOrder = 1
    Placement = cpAbove
  end
  object CurrF: TSBSComboBox
    Tag = 1
    Left = 127
    Top = 58
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
    TabOrder = 2
    ExtendedList = True
    MaxListWidth = 90
    Validate = True
  end
  object CurrF2: TSBSComboBox
    Tag = 1
    Left = 254
    Top = 58
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
    TabOrder = 3
    ExtendedList = True
    MaxListWidth = 90
    Validate = True
  end
  object Id3CCF: Text8Pt
    Tag = 1
    Left = 127
    Top = 85
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
    TabOrder = 4
    OnExit = Id3CCFExit
    TextId = 0
    ViaSBtn = False
  end
  object Id3DepF: Text8Pt
    Tag = 1
    Left = 178
    Top = 85
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
  object AccF3: Text8Pt
    Tag = 1
    Left = 127
    Top = 138
    Width = 60
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
    TabOrder = 8
    OnExit = AccF3Exit
    TextId = 0
    ViaSBtn = False
    Link_to_Cust = True
    ShowHilight = True
  end
  object DocFiltF: Text8Pt
    Left = 127
    Top = 165
    Width = 104
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
    TabOrder = 9
    OnExit = DocFiltFExit
    TextId = 0
    ViaSBtn = False
    Link_to_Stock = True
    ShowHilight = True
  end
  object LocF: Text8Pt
    Tag = 1
    Left = 264
    Top = 85
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
    TabOrder = 6
    OnExit = LocFExit
    TextId = 0
    ViaSBtn = False
  end
  object SxSF: TSBSComboBox
    Tag = 1
    Left = 127
    Top = 111
    Width = 99
    Height = 22
    HelpContext = 698
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
    Items.Strings = (
      'Invoice data'
      'Order data')
    MaxListWidth = 90
    Validate = True
  end
  object cbAccountTypes: TSBSComboBox
    Left = 127
    Top = 191
    Width = 183
    Height = 22
    HelpContext = 8098
    Style = csDropDownList
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 14
    ItemIndex = 0
    ParentFont = False
    TabOrder = 10
    Text = 'Customers & Consumers'
    Items.Strings = (
      'Customers & Consumers'
      'Customers Only'
      'Consumers Only')
    MaxListWidth = 0
  end
end
