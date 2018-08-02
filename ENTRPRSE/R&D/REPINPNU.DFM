inherited RepInpMsgN: TRepInpMsgN
  HelpContext = 670
  Caption = 'Sales Back Order Report'
  ClientHeight = 194
  PixelsPerInch = 96
  TextHeight = 14
  inherited SBSPanel4: TSBSBackGroup
    Height = 157
  end
  object Label81: Label8 [1]
    Left = 22
    Top = 43
    Width = 120
    Height = 14
    Alignment = taRightJustify
    Caption = 'Stock Code/Group Filter :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label89: Label8 [2]
    Left = 52
    Top = 66
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
  object Label86: Label8 [3]
    Left = 12
    Top = 90
    Width = 129
    Height = 14
    Alignment = taRightJustify
    Caption = 'Up to Order Delivery Date :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label82: Label8 [4]
    Left = 39
    Top = 17
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
  object LocLab: Label8 [5]
    Left = 84
    Top = 135
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
    Top = 166
    TabOrder = 7
  end
  inherited ClsCP1Btn: TButton
    Top = 166
    TabOrder = 8
  end
  inherited SBSPanel1: TSBSPanel
    TabOrder = 0
  end
  object ACFF: Text8Pt
    Tag = 1
    Left = 145
    Top = 38
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
    TabOrder = 2
    OnExit = ACFFExit
    TextId = 0
    ViaSBtn = False
    Link_to_Stock = True
    ShowHilight = True
  end
  object AccF3: Text8Pt
    Tag = 1
    Left = 145
    Top = 63
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
    TabOrder = 3
    OnExit = AccF3Exit
    TextId = 0
    ViaSBtn = False
    Link_to_Cust = True
    ShowHilight = True
  end
  object Sum1: TBorCheck
    Left = 12
    Top = 111
    Width = 147
    Height = 20
    HelpContext = 694
    Caption = 'Explode B.O.M shortages :'
    CheckColor = clWindowText
    Color = clBtnFace
    ParentColor = False
    TabOrder = 5
    TabStop = True
    TextId = 0
  end
  object I1TransDateF: TEditDate
    Tag = 1
    Left = 145
    Top = 88
    Width = 80
    Height = 22
    HelpContext = 693
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
  object CurrF: TSBSComboBox
    Tag = 1
    Left = 145
    Top = 13
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
  object LocF: Text8Pt
    Tag = 1
    Left = 145
    Top = 131
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
end
