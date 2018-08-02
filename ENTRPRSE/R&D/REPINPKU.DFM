inherited RepInpMsgK: TRepInpMsgK
  HelpContext = 667
  Caption = 'Stock Valuation Report'
  ClientHeight = 200
  PixelsPerInch = 96
  TextHeight = 14
  object Label86: Label8 [0]
    Left = 48
    Top = 88
    Width = 86
    Height = 14
    Alignment = taRightJustify
    Caption = 'Age Stock as at : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    Visible = False
    TextId = 0
  end
  inherited SBSPanel4: TSBSBackGroup
    Height = 165
  end
  object Label81: Label8 [2]
    Left = 58
    Top = 24
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
  object Label83: Label8 [3]
    Left = 36
    Top = 88
    Width = 101
    Height = 14
    Alignment = taRightJustify
    Caption = 'For valuation types : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object LocLab: Label8 [4]
    Left = 78
    Top = 117
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
  object I1TransDateF: TEditDate [5]
    Tag = 1
    Left = 139
    Top = 86
    Width = 80
    Height = 22
    HelpContext = 682
    AutoSelect = False
    EditMask = '00/00/0000;0;'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 10
    ParentFont = False
    TabOrder = 4
    Visible = False
    Placement = cpAbove
  end
  inherited OkCP1Btn: TButton
    Top = 173
    TabOrder = 6
  end
  inherited ClsCP1Btn: TButton
    Top = 173
    TabOrder = 7
  end
  inherited SBSPanel1: TSBSPanel
    TabOrder = 8
  end
  object ACFF: Text8Pt
    Tag = 1
    Left = 137
    Top = 19
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
    Left = 137
    Top = 85
    Width = 88
    Height = 22
    HelpContext = 691
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
      'Code'
      'Desc'
      'Bin Loc')
    MaxListWidth = 90
    Validate = True
  end
  object Sum1: TBorCheck
    Left = 20
    Top = 44
    Width = 132
    Height = 20
    HelpContext = 689
    Caption = 'Summary Report :'
    CheckColor = clWindowText
    Color = clBtnFace
    ParentColor = False
    TabOrder = 1
    TabStop = True
    TextId = 0
  end
  object SLive: TBorCheck
    Left = 20
    Top = 62
    Width = 132
    Height = 20
    HelpContext = 690
    Caption = 'Use Live Stock Levels :'
    CheckColor = clWindowText
    Color = clBtnFace
    ParentColor = False
    TabOrder = 2
    TabStop = True
    TextId = 0
  end
  object LocF: Text8Pt
    Tag = 1
    Left = 137
    Top = 113
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
  object chkPrintParameters: TBorCheck
    Left = 8
    Top = 137
    Width = 144
    Height = 20
    HelpContext = 8062
    Caption = 'Print Report Parameters: '
    CheckColor = clWindowText
    Color = clBtnFace
    ParentColor = False
    TabOrder = 9
    TextId = 0
  end
end
