inherited RepJCBInp: TRepJCBInp
  Left = 370
  Top = 228
  HelpContext = 1215
  Caption = 'Job Budget Analysis'
  ClientHeight = 219
  ClientWidth = 356
  PixelsPerInch = 96
  TextHeight = 14
  inherited SBSPanel4: TSBSBackGroup
    Top = 8
    Width = 342
    Height = 175
  end
  object Label85: Label8 [1]
    Left = 246
    Top = 51
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
  object Label810: Label8 [2]
    Left = 62
    Top = 26
    Width = 98
    Height = 14
    Alignment = taRightJustify
    Caption = 'Job/Contract Code : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label82: Label8 [3]
    Left = 35
    Top = 54
    Width = 121
    Height = 14
    Caption = 'Period/Year Range from :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label81: Label8 [4]
    Left = 53
    Top = 145
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
  object Label811: Label8 [5]
    Left = 222
    Top = 146
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
  inherited OkCP1Btn: TButton
    Left = 98
    Top = 190
    TabOrder = 8
  end
  inherited ClsCP1Btn: TButton
    Left = 184
    Top = 190
    TabOrder = 9
  end
  inherited SBSPanel1: TSBSPanel
    TabOrder = 10
  end
  object I1PrYrF: TEditPeriod
    Tag = 1
    Left = 160
    Top = 48
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
    TabOrder = 1
    Text = '011996'
    Placement = cpAbove
    EPeriod = 1
    EYear = 96
    ViewMask = '000/0000;0;'
  end
  object I2PrYrF: TEditPeriod
    Tag = 1
    Left = 263
    Top = 48
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
    TabOrder = 2
    Text = '011996'
    Placement = cpAbove
    EPeriod = 1
    EYear = 96
    ViewMask = '000/0000;0;'
  end
  object Sum1: TBorCheck
    Left = 10
    Top = 113
    Width = 165
    Height = 20
    HelpContext = 700
    Caption = 'Show Time/Stock code detail :'
    CheckColor = clWindowText
    Color = clBtnFace
    ParentColor = False
    TabOrder = 5
    TabStop = True
    TextId = 0
  end
  object ProdF: Text8Pt
    Left = 160
    Top = 21
    Width = 131
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
    OnExit = ProdFExit
    TextId = 0
    ViaSBtn = False
    Link_to_Job = True
    ShowHilight = True
  end
  object RepQtyChk: TBorCheck
    Left = 40
    Top = 91
    Width = 135
    Height = 21
    HelpContext = 700
    Caption = 'Show Qty/Hrs :'
    CheckColor = clWindowText
    Color = clBtnFace
    ParentColor = False
    TabOrder = 4
    TabStop = True
    TextId = 0
  end
  object SUInvChk: TBorCheck
    Left = 13
    Top = 72
    Width = 162
    Height = 20
    HelpContext = 700
    Caption = 'Show zero balances  :'
    CheckColor = clWindowText
    Color = clBtnFace
    Checked = True
    ParentColor = False
    State = cbChecked
    TabOrder = 3
    TabStop = True
    TextId = 0
  end
  object CurrF: TSBSComboBox
    Tag = 1
    Left = 160
    Top = 142
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
  object CurrF2: TSBSComboBox
    Tag = 1
    Left = 286
    Top = 142
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
    TabOrder = 7
    ExtendedList = True
    MaxListWidth = 90
    Validate = True
  end
end
