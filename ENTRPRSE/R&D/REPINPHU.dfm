inherited RepInpMsgH: TRepInpMsgH
  HelpContext = 668
  Caption = 'Stock Reconciliation/Valuation Report'
  ClientHeight = 237
  ClientWidth = 349
  PixelsPerInch = 96
  TextHeight = 14
  inherited SBSPanel4: TSBSBackGroup
    Width = 340
    Height = 191
  end
  object Label84: Label8 [1]
    Left = 34
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
  object Label811: Label8 [2]
    Left = 202
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
  object Label88: Label8 [3]
    Left = 24
    Top = 76
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
  object AccLab: Label8 [4]
    Left = 48
    Top = 102
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
  object Label810: Label8 [5]
    Left = 33
    Top = 127
    Width = 107
    Height = 14
    Alignment = taRightJustify
    Caption = 'Product Code/Group : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label81: Label8 [6]
    Left = 14
    Top = 22
    Width = 124
    Height = 14
    Alignment = taRightJustify
    Caption = 'Period/Year Range. from :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label82: Label8 [7]
    Left = 203
    Top = 23
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
  object LocLab: Label8 [8]
    Left = 243
    Top = 76
    Width = 33
    Height = 14
    Alignment = taRightJustify
    Caption = 'Locn  :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    Visible = False
    TextId = 0
  end
  inherited OkCP1Btn: TButton
    Left = 85
    Top = 206
    TabOrder = 10
  end
  inherited ClsCP1Btn: TButton
    Left = 171
    Top = 206
    TabOrder = 11
  end
  inherited SBSPanel1: TSBSPanel
    Left = 257
    Top = 122
    TabOrder = 12
  end
  object CurrF: TSBSComboBox
    Tag = 1
    Left = 140
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
    TabOrder = 2
    ExtendedList = True
    MaxListWidth = 90
    Validate = True
  end
  object CurrF2: TSBSComboBox
    Tag = 1
    Left = 267
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
    TabOrder = 3
    ExtendedList = True
    MaxListWidth = 90
    Validate = True
  end
  object Id3CCF: Text8Pt
    Tag = 1
    Left = 140
    Top = 73
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
    Left = 191
    Top = 73
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
    Left = 140
    Top = 98
    Width = 49
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
    TabOrder = 7
    OnExit = AccF3Exit
    TextId = 0
    ViaSBtn = False
    Link_to_Cust = True
    ShowHilight = True
  end
  object StkFiltF: Text8Pt
    Left = 140
    Top = 123
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
    TabOrder = 8
    OnExit = StkFiltFExit
    TextId = 0
    ViaSBtn = False
    Link_to_Stock = True
    ShowHilight = True
  end
  object Sum1: TBorCheck
    Left = 51
    Top = 146
    Width = 104
    Height = 20
    HelpContext = 689
    Caption = 'Summary Report :'
    CheckColor = clWindowText
    Color = clBtnFace
    ParentColor = False
    TabOrder = 9
    TabStop = True
    TextId = 0
  end
  object I1PrYrF: TEditPeriod
    Tag = 1
    Left = 140
    Top = 20
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
    TabOrder = 0
    Text = '011996'
    Placement = cpAbove
    EPeriod = 1
    EYear = 96
    ViewMask = '000/0000;0;'
    OnConvDate = I1PrYrFConvDate
    OnShowPeriod = I1PrYrFShowPeriod
  end
  object I2PrYrF: TEditPeriod
    Tag = 1
    Left = 219
    Top = 20
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
    OnConvDate = I1PrYrFConvDate
    OnShowPeriod = I1PrYrFShowPeriod
  end
  object LocF: Text8Pt
    Tag = 1
    Left = 277
    Top = 73
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
    Visible = False
    OnExit = LocFExit
    TextId = 0
    ViaSBtn = False
  end
  object chkPrintParameters: TBorCheck
    Left = 11
    Top = 165
    Width = 144
    Height = 20
    HelpContext = 8062
    Caption = 'Print Report Parameters: '
    CheckColor = clWindowText
    Color = clBtnFace
    ParentColor = False
    TabOrder = 13
    TextId = 0
  end
end
