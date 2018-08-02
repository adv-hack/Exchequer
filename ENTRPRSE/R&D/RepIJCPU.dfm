inherited RepJCPInp: TRepJCPInp
  Tag = 3
  HelpContext = 1553
  Caption = 'Job Application Report'
  ClientHeight = 337
  ClientWidth = 356
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 14
  inherited SBSPanel4: TSBSBackGroup
    Top = 8
    Width = 342
    Height = 293
  end
  object Label83: Label8 [1]
    Left = 22
    Top = 99
    Width = 114
    Height = 14
    Alignment = taRightJustify
    Caption = 'Cost Centre/Dept Filter :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object AccLab: Label8 [2]
    Left = 46
    Top = 151
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
  object Label85: Label8 [3]
    Left = 246
    Top = 74
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
    Visible = False
    TextId = 0
  end
  object Label81: Label8 [4]
    Left = 33
    Top = 49
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
    Top = 50
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
  object Label810: Label8 [6]
    Left = 41
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
  object Label82: Label8 [7]
    Left = 14
    Top = 77
    Width = 121
    Height = 14
    Caption = 'Period/Year Range from :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    Visible = False
    TextId = 0
  end
  object LocLab: Label8 [8]
    Left = 264
    Top = 99
    Width = 29
    Height = 14
    Alignment = taRightJustify
    Caption = 'Type :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label84: Label8 [9]
    Left = 46
    Top = 127
    Width = 93
    Height = 14
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Include in Report  : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label86: Label8 [10]
    Left = 31
    Top = 176
    Width = 108
    Height = 14
    Alignment = taRightJustify
    Caption = 'Sub Contractor. filter : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label87: Label8 [11]
    Left = 46
    Top = 225
    Width = 93
    Height = 14
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Sort Report by : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label88: Label8 [12]
    Left = 55
    Top = 248
    Width = 81
    Height = 14
    Alignment = taRightJustify
    Caption = 'Job Terms Filter :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label89: Label8 [13]
    Left = 88
    Top = 200
    Width = 51
    Height = 14
    Alignment = taRightJustify
    Caption = 'QS. filter : '
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
    Top = 308
    TabOrder = 15
  end
  inherited ClsCP1Btn: TButton
    Left = 184
    Top = 308
    TabOrder = 16
  end
  inherited SBSPanel1: TSBSPanel
    TabOrder = 17
  end
  object I1PrYrF: TEditPeriod
    Tag = 1
    Left = 160
    Top = 71
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
    TabOrder = 3
    Text = '011996'
    Visible = False
    Placement = cpAbove
    EPeriod = 1
    EYear = 96
    ViewMask = '000/0000;0;'
  end
  object I2PrYrF: TEditPeriod
    Tag = 1
    Left = 263
    Top = 71
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
    TabOrder = 4
    Text = '011996'
    Visible = False
    Placement = cpAbove
    EPeriod = 1
    EYear = 96
    ViewMask = '000/0000;0;'
  end
  object Id3CCF: Text8Pt
    Tag = 1
    Left = 160
    Top = 96
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
  object Id3DepF: Text8Pt
    Tag = 1
    Left = 211
    Top = 96
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
    TabOrder = 6
    OnExit = Id3CCFExit
    TextId = 0
    ViaSBtn = False
  end
  object ACFF: Text8Pt
    Tag = 1
    Left = 160
    Top = 147
    Width = 80
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
    TabOrder = 9
    OnExit = ACFFExit
    TextId = 0
    ViaSBtn = False
    Link_to_Cust = True
    ShowHilight = True
  end
  object CurrF: TSBSComboBox
    Tag = 1
    Left = 160
    Top = 46
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
    TabOrder = 1
    ExtendedList = True
    MaxListWidth = 90
    Validate = True
  end
  object CurrF2: TSBSComboBox
    Tag = 1
    Left = 286
    Top = 46
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
    TabOrder = 2
    ExtendedList = True
    MaxListWidth = 90
    Validate = True
  end
  object Sum1: TBorCheck
    Left = 30
    Top = 274
    Width = 145
    Height = 20
    HelpContext = 700
    Caption = 'Summary Report :       '
    CheckColor = clWindowText
    Color = clBtnFace
    ParentColor = False
    TabOrder = 14
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
  object LocF: Text8Pt
    Tag = 1
    Left = 296
    Top = 96
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
  object IncFcb: TSBSComboBox
    Tag = 1
    Left = 160
    Top = 122
    Width = 135
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
    ItemIndex = 0
    MaxLength = 3
    ParentFont = False
    TabOrder = 8
    Text = 'Certified'
    Items.Strings = (
      'Certified'
      'Uncertified'
      'Certified and Uncertified')
    MaxListWidth = 90
    Validate = True
  end
  object SubCF: Text8Pt
    Tag = 1
    Left = 160
    Top = 172
    Width = 80
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
    TabOrder = 10
    OnExit = SubCFExit
    TextId = 0
    ViaSBtn = False
  end
  object Sortcb: TSBSComboBox
    Tag = 1
    Left = 160
    Top = 220
    Width = 77
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
    ItemIndex = 0
    MaxLength = 3
    ParentFont = False
    TabOrder = 12
    Text = 'Job'
    Items.Strings = (
      'Job'
      'Account')
    MaxListWidth = 90
    Validate = True
  end
  object JCTFiltF: Text8Pt
    Tag = 1
    Left = 160
    Top = 245
    Width = 87
    Height = 22
    HelpContext = 633
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 13
    OnExit = JCTFiltFExit
    TextId = 0
    ViaSBtn = False
  end
  object QSF1: Text8Pt
    Tag = 1
    Left = 160
    Top = 196
    Width = 80
    Height = 22
    Hint = 
      'Double click to drill down|Double clicking or using the down but' +
      'ton will drill down to the record for this field. The up button ' +
      'will search for the nearest match.'
    HelpContext = 652
    CharCase = ecUpperCase
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 20
    ParentFont = False
    TabOrder = 11
    OnExit = QSF1Exit
    TextId = 0
    ViaSBtn = False
    OnEntHookEvent = QSF1EntHookEvent
  end
end
