inherited RepInpMsgJ: TRepInpMsgJ
  HelpContext = 675
  Caption = 'Stock Take Report'
  ClientHeight = 236
  PixelsPerInch = 96
  TextHeight = 14
  inherited SBSPanel4: TSBSBackGroup
    Height = 199
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
  object Label89: Label8 [2]
    Left = 66
    Top = 153
    Width = 72
    Height = 14
    Alignment = taRightJustify
    Caption = 'Supplier filter : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label83: Label8 [3]
    Left = 63
    Top = 54
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
  object Label810: Label8 [4]
    Left = 43
    Top = 101
    Width = 94
    Height = 14
    Alignment = taRightJustify
    Caption = 'Bin Location Filter : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object LocLab: Label8 [5]
    Left = 78
    Top = 127
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
    Left = 67
    Top = 208
    TabOrder = 7
  end
  inherited ClsCP1Btn: TButton
    Left = 153
    Top = 208
    TabOrder = 8
  end
  inherited SBSPanel1: TSBSPanel
    TabOrder = 9
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
  object AccF3: Text8Pt
    Tag = 1
    Left = 137
    Top = 150
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
    TabOrder = 6
    OnExit = AccF3Exit
    TextId = 0
    ViaSBtn = False
    Link_to_Cust = True
    ShowHilight = True
  end
  object SxSF: TSBSComboBox
    Tag = 1
    Left = 137
    Top = 51
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
    TabOrder = 1
    Items.Strings = (
      'Code'
      'Description'
      'Bin Location')
    MaxListWidth = 90
    Validate = True
  end
  object Sum1: TBorCheck
    Left = 20
    Top = 76
    Width = 132
    Height = 20
    HelpContext = 699
    Caption = 'Show Stock Levels :'
    CheckColor = clWindowText
    Color = clBtnFace
    ParentColor = False
    TabOrder = 2
    TabStop = True
    TextId = 0
  end
  object DocFiltF: Text8Pt
    Left = 137
    Top = 97
    Width = 57
    Height = 22
    HelpContext = 687
    Color = clWhite
    EditMask = '>cccccccc;0; '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 8
    ParentFont = False
    TabOrder = 3
    TextId = 0
    ViaSBtn = False
  end
  object LocF: Text8Pt
    Tag = 1
    Left = 137
    Top = 123
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
  object Sum2: TBorCheck
    Left = 198
    Top = 97
    Width = 80
    Height = 20
    HelpContext = 1485
    Caption = 'Show Bins :'
    CheckColor = clWindowText
    Color = clBtnFace
    ParentColor = False
    TabOrder = 4
    TabStop = True
    TextId = 0
  end
  object chkPrintParameters: TBorCheck
    Left = 14
    Top = 175
    Width = 138
    Height = 20
    HelpContext = 8062
    Caption = 'Print Report Parameters:'
    CheckColor = clWindowText
    Color = clBtnFace
    ParentColor = False
    TabOrder = 10
    TextId = 0
  end
end
