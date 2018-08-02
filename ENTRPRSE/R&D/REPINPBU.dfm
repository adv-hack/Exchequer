inherited RepInpMsgB: TRepInpMsgB
  Left = 38
  Top = 354
  HelpContext = 629
  Caption = 'Cost Centre & Department Analysis'
  ClientHeight = 210
  ClientWidth = 382
  PixelsPerInch = 96
  TextHeight = 14
  inherited SBSPanel4: TSBSBackGroup
    Width = 369
    Height = 171
  end
  object Label84: Label8 [1]
    Left = 76
    Top = 20
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
    Left = 244
    Top = 21
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
  object Label86: Label8 [3]
    Left = 37
    Top = 71
    Width = 143
    Height = 14
    Alignment = taRightJustify
    Caption = 'Primary Pr/Year Range. from :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label87: Label8 [4]
    Left = 245
    Top = 72
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
  object Label88: Label8 [5]
    Left = 72
    Top = 122
    Width = 108
    Height = 14
    Alignment = taRightJustify
    Caption = 'Cost Centre/Dept/Tag :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label810: Label8 [6]
    Left = 74
    Top = 150
    Width = 106
    Height = 14
    Alignment = taRightJustify
    Caption = 'Document Type/Filter :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label81: Label8 [7]
    Left = 13
    Top = 96
    Width = 167
    Height = 14
    Alignment = taRightJustify
    Caption = 'Comparative Pr/Year Range. from :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label82: Label8 [8]
    Left = 245
    Top = 97
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
  object Label83: Label8 [9]
    Left = 64
    Top = 48
    Width = 118
    Height = 14
    Alignment = taRightJustify
    Caption = 'General Ledger Range : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label85: Label8 [10]
    Left = 255
    Top = 46
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
    Left = 112
    Top = 182
    TabOrder = 13
  end
  inherited ClsCP1Btn: TButton
    Left = 196
    Top = 182
    TabOrder = 14
  end
  inherited SBSPanel1: TSBSPanel
    TabOrder = 15
  end
  object CurrF: TSBSComboBox
    Tag = 1
    Left = 182
    Top = 17
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
    TabOrder = 0
    ExtendedList = True
    MaxListWidth = 90
    Validate = True
  end
  object CurrF2: TSBSComboBox
    Tag = 1
    Left = 308
    Top = 17
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
    TabOrder = 1
    ExtendedList = True
    MaxListWidth = 90
    Validate = True
  end
  object I1PrYrF: TEditPeriod
    Tag = 1
    Left = 182
    Top = 69
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
    OnConvDate = I1PrYrFConvDate
    OnShowPeriod = I1PrYrFShowPeriod
  end
  object I2PrYrF: TEditPeriod
    Tag = 1
    Left = 261
    Top = 69
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
    OnConvDate = I1PrYrFConvDate
    OnShowPeriod = I1PrYrFShowPeriod
  end
  object Id3CCF: Text8Pt
    Tag = 1
    Left = 182
    Top = 119
    Width = 46
    Height = 22
    HelpContext = 762
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 8
    OnExit = Id3CCFExit
    TextId = 0
    ViaSBtn = False
  end
  object Id3DepF: Text8Pt
    Tag = 1
    Left = 233
    Top = 119
    Width = 46
    Height = 22
    HelpContext = 762
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
  object DocFiltF: Text8Pt
    Left = 182
    Top = 145
    Width = 57
    Height = 22
    HelpContext = 653
    Color = clWhite
    EditMask = '>ccc;0; '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 3
    ParentFont = False
    TabOrder = 11
    OnExit = DocFiltFExit
    TextId = 0
    ViaSBtn = False
  end
  object I3PrYrF: TEditPeriod
    Tag = 1
    Left = 182
    Top = 94
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
    TabOrder = 6
    Text = '011996'
    Placement = cpAbove
    EPeriod = 1
    EYear = 96
    ViewMask = '000/0000;0;'
    OnConvDate = I1PrYrFConvDate
    OnShowPeriod = I1PrYrFShowPeriod
  end
  object I4PrYrF: TEditPeriod
    Tag = 1
    Left = 261
    Top = 94
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
    TabOrder = 7
    Text = '011996'
    Placement = cpAbove
    EPeriod = 1
    EYear = 96
    ViewMask = '000/0000;0;'
    OnConvDate = I1PrYrFConvDate
    OnShowPeriod = I1PrYrFShowPeriod
  end
  object ACFF: Text8Pt
    Tag = 1
    Left = 182
    Top = 43
    Width = 69
    Height = 22
    HelpContext = 648
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
  end
  object ACCF2: Text8Pt
    Tag = 1
    Left = 273
    Top = 43
    Width = 69
    Height = 22
    HelpContext = 648
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    OnExit = ACFFExit
    TextId = 0
    ViaSBtn = False
  end
  object CommitMCB: TSBSComboBox
    Tag = 1
    Left = 243
    Top = 145
    Width = 122
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
    TabOrder = 12
    Visible = False
    Items.Strings = (
      'Actuals only'
      'Comm & Actuals'
      'Committed only')
    MaxListWidth = 90
    Validate = True
  end
  object ccTagChk: TBorCheck
    Left = 286
    Top = 120
    Width = 16
    Height = 20
    HelpContext = 762
    CheckColor = clWindowText
    Color = clBtnFace
    ParentColor = False
    TabOrder = 10
    TextId = 0
  end
end
