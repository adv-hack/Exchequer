inherited RepInpMsgD: TRepInpMsgD
  Left = 378
  Top = 220
  HelpContext = 664
  Caption = 'Price List'
  ClientHeight = 215
  PixelsPerInch = 96
  TextHeight = 14
  inherited SBSPanel4: TSBSBackGroup
    Height = 181
  end
  object Label81: Label8 [1]
    Left = 58
    Top = 30
    Width = 79
    Height = 14
    Alignment = taRightJustify
    Caption = 'Product Group : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label94: Label8 [2]
    Left = 46
    Top = 53
    Width = 91
    Height = 14
    Alignment = taRightJustify
    Caption = 'Sales Price Band : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label89: Label8 [3]
    Left = 45
    Top = 129
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
  object Label84: Label8 [4]
    Left = 31
    Top = 78
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
  object Label83: Label8 [5]
    Left = 63
    Top = 103
    Width = 74
    Height = 14
    Alignment = taRightJustify
    Caption = 'Sort by Stock : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object LocLab: Label8 [6]
    Left = 78
    Top = 153
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
  inherited OkCP1Btn: TButton
    Left = 66
    Top = 189
    TabOrder = 6
  end
  inherited ClsCP1Btn: TButton
    Left = 152
    Top = 189
    TabOrder = 7
  end
  inherited SBSPanel1: TSBSPanel
    TabOrder = 8
  end
  object ACFF: Text8Pt
    Tag = 1
    Left = 137
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
  object CurrF2: TSBSComboBox
    Tag = 1
    Left = 137
    Top = 50
    Width = 57
    Height = 22
    HelpContext = 684
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
    Items.Strings = (
      'All'
      'A'
      'B'
      'C'
      'D'
      'E'
      'F'
      'G'
      'H')
    MaxListWidth = 90
    Validate = True
  end
  object AccF3: Text8Pt
    Tag = 1
    Left = 137
    Top = 125
    Width = 57
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
    TabOrder = 4
    OnExit = AccF3Exit
    TextId = 0
    ViaSBtn = False
    Link_to_Cust = True
    ShowHilight = True
  end
  object CurrF: TSBSComboBox
    Tag = 1
    Left = 137
    Top = 75
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
  object SxSF: TSBSComboBox
    Tag = 1
    Left = 137
    Top = 100
    Width = 57
    Height = 22
    HelpContext = 685
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
    Items.Strings = (
      'Groups'
      'Code'
      'Desc')
    MaxListWidth = 90
    Validate = True
  end
  object LocF: Text8Pt
    Tag = 1
    Left = 137
    Top = 150
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
    TabOrder = 5
    OnExit = LocFExit
    TextId = 0
    ViaSBtn = False
  end
end
