inherited RepJCHInp: TRepJCHInp
  Left = 379
  Top = 238
  HelpContext = 1218
  Caption = 'Job History Report'
  ClientHeight = 274
  ClientWidth = 356
  PixelsPerInch = 96
  TextHeight = 14
  inherited SBSPanel4: TSBSBackGroup
    Top = 8
    Width = 342
    Height = 233
  end
  object Label83: Label8 [1]
    Left = 22
    Top = 133
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
    Top = 185
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
  object LocLab: Label8 [7]
    Left = 264
    Top = 133
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
  object Label88: Label8 [8]
    Left = 246
    Top = 103
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
  inherited OkCP1Btn: TButton
    Left = 98
    Top = 247
    TabOrder = 16
  end
  inherited ClsCP1Btn: TButton
    Left = 184
    Top = 247
    TabOrder = 17
  end
  inherited SBSPanel1: TSBSPanel
    TabOrder = 18
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
    TabOrder = 4
    Text = '011996'
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
    TabOrder = 5
    Text = '011996'
    Placement = cpAbove
    EPeriod = 1
    EYear = 96
    ViewMask = '000/0000;0;'
  end
  object Id3CCF: Text8Pt
    Tag = 1
    Left = 160
    Top = 130
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
    TabOrder = 9
    OnExit = Id3CCFExit
    TextId = 0
    ViaSBtn = False
  end
  object Id3DepF: Text8Pt
    Tag = 1
    Left = 211
    Top = 130
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
    TabOrder = 10
    OnExit = Id3CCFExit
    TextId = 0
    ViaSBtn = False
  end
  object ACFF: Text8Pt
    Tag = 1
    Left = 160
    Top = 181
    Width = 80
    Height = 22
    Hint = 
      'Double click to drill down|Double clicking or using the down but' +
      'ton will drill down to the record for this field. The up button ' +
      'will search for the nearest match.'
    HelpContext = 40174
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 14
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
    Top = 211
    Width = 145
    Height = 20
    HelpContext = 40175
    Caption = 'Summary Report :       '
    CheckColor = clWindowText
    Color = clBtnFace
    ParentColor = False
    TabOrder = 15
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
    HelpContext = 40171
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
    Top = 130
    Width = 46
    Height = 22
    HelpContext = 8065
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 11
    OnExit = LocFExit
    TextId = 0
    ViaSBtn = False
  end
  object RepQtyChk: TBorCheck
    Left = 40
    Top = 156
    Width = 135
    Height = 20
    HelpContext = 40172
    Caption = 'Report on Qty/Hrs :       '
    CheckColor = clWindowText
    Color = clBtnFace
    ParentColor = False
    TabOrder = 12
    TabStop = True
    TextId = 0
  end
  object SUInvChk: TBorCheck
    Left = 177
    Top = 156
    Width = 162
    Height = 20
    HelpContext = 40173
    Caption = 'Show uninvoiced items only :'
    CheckColor = clWindowText
    Color = clBtnFace
    ParentColor = False
    TabOrder = 13
    TabStop = True
    TextId = 0
  end
  object UPF: TBorRadio
    Left = 14
    Top = 72
    Width = 142
    Height = 20
    Caption = 'Period/Year Range from :'
    CheckColor = clWindowText
    Checked = True
    GroupIndex = 1
    TabOrder = 3
    TabStop = True
    TextId = 0
  end
  object UDF: TBorRadio
    Left = 40
    Top = 98
    Width = 116
    Height = 20
    HelpContext = 692
    AutoSet = False
    Caption = 'Date Range from :'
    CheckColor = clWindowText
    GroupIndex = 1
    TabOrder = 6
    TabStop = True
    TextId = 0
  end
  object I1TransDateF: TEditDate
    Tag = 1
    Left = 160
    Top = 99
    Width = 80
    Height = 22
    HelpContext = 692
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
    TabOrder = 7
    Placement = cpAbove
  end
  object I2TransDateF: TEditDate
    Tag = 1
    Left = 263
    Top = 99
    Width = 80
    Height = 22
    HelpContext = 692
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
    TabOrder = 8
    Placement = cpAbove
  end
end
