inherited RepInpMsgP: TRepInpMsgP
  HelpContext = 711
  Caption = 'Print a Range of Documents'
  ClientHeight = 215
  PixelsPerInch = 96
  TextHeight = 14
  inherited SBSPanel4: TSBSBackGroup
    Top = 3
    Height = 178
  end
  object Label86: Label8 [1]
    Left = 13
    Top = 46
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
  object Label87: Label8 [2]
    Left = 193
    Top = 48
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
    Left = 14
    Top = 21
    Width = 91
    Height = 14
    Alignment = taRightJustify
    Caption = 'Document Range : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label83: Label8 [4]
    Left = 193
    Top = 19
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
  object AccLab: Label8 [5]
    Left = 13
    Top = 76
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
  object Label84: Label8 [6]
    Left = 17
    Top = 105
    Width = 88
    Height = 14
    Alignment = taRightJustify
    Caption = 'Include Currency :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label811: Label8 [7]
    Left = 61
    Top = 158
    Width = 44
    Height = 14
    Alignment = taRightJustify
    Caption = 'Print for :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  inherited OkCP1Btn: TButton
    Top = 189
    TabOrder = 11
  end
  inherited ClsCP1Btn: TButton
    Top = 189
    TabOrder = 12
  end
  inherited SBSPanel1: TSBSPanel
    Top = 84
    TabOrder = 13
  end
  object I1TransDateF: TEditDate
    Tag = 1
    Left = 108
    Top = 44
    Width = 80
    Height = 22
    HelpContext = 659
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
    TabOrder = 2
    Placement = cpAbove
  end
  object I2TransDateF: TEditDate
    Tag = 1
    Left = 208
    Top = 44
    Width = 80
    Height = 22
    HelpContext = 659
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
  object ACFF: Text8Pt
    Tag = 1
    Left = 108
    Top = 16
    Width = 80
    Height = 22
    HelpContext = 658
    Color = clWhite
    EditMask = '>ccccccccc;0; '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 9
    ParentFont = False
    TabOrder = 0
    OnExit = ACFFExit
    TextId = 0
    ViaSBtn = False
  end
  object ACCF2: Text8Pt
    Tag = 1
    Left = 208
    Top = 16
    Width = 80
    Height = 22
    HelpContext = 658
    Color = clWhite
    EditMask = '>ccccccccc;0; '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 9
    ParentFont = False
    TabOrder = 1
    OnExit = ACFFExit
    TextId = 0
    ViaSBtn = False
  end
  object AccF3: Text8Pt
    Tag = 1
    Left = 108
    Top = 72
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
    TabOrder = 4
    OnExit = AccF3Exit
    TextId = 0
    ViaSBtn = False
    Link_to_Cust = True
    ShowHilight = True
  end
  object Sum1: TBorCheck
    Left = 176
    Top = 72
    Width = 110
    Height = 20
    HelpContext = 654
    Caption = 'Sort by Account : '
    CheckColor = clWindowText
    Color = clBtnFace
    ParentColor = False
    TabOrder = 5
    TabStop = True
    TextId = 0
  end
  object CurrF: TSBSComboBox
    Tag = 1
    Left = 108
    Top = 102
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
    TabOrder = 6
    ExtendedList = True
    MaxListWidth = 90
    Validate = True
  end
  object Over1Chk: TBorCheck
    Left = 16
    Top = 131
    Width = 110
    Height = 20
    HelpContext = 1153
    Caption = 'Override Form : '
    CheckColor = clWindowText
    Color = clBtnFace
    ParentColor = False
    TabOrder = 8
    TabStop = True
    TextId = 0
  end
  object FilterX: TSBSComboBox
    Left = 108
    Top = 152
    Width = 78
    Height = 22
    HelpContext = 634
    Style = csDropDownList
    Color = clWhite
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 14
    ParentFont = False
    TabOrder = 10
    Items.Strings = (
      'All Accounts'
      'Hard Copy '
      'Fax '
      'Email')
    MaxListWidth = 0
  end
  object PaperCheck: TBorCheck
    Left = 130
    Top = 131
    Width = 102
    Height = 20
    HelpContext = 1153
    Caption = 'Use Paperless : '
    CheckColor = clWindowText
    Color = clBtnFace
    ParentColor = False
    TabOrder = 9
    TabStop = True
    TextId = 0
    OnClick = PaperCheckClick
  end
  object cbUseCustom: TBorCheck
    Left = 173
    Top = 103
    Width = 113
    Height = 20
    HelpContext = 654
    Caption = 'Use Custom Filter : '
    CheckColor = clWindowText
    Color = clBtnFace
    ParentColor = False
    TabOrder = 7
    TabStop = True
    TextId = 0
  end
end
