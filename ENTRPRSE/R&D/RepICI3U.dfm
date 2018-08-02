inherited RepJCCISYInp: TRepJCCISYInp
  Left = 445
  Top = 225
  HelpContext = 2168
  Caption = 'Contractor'#39's Return'
  ClientHeight = 175
  ClientWidth = 343
  PixelsPerInch = 96
  TextHeight = 14
  inherited SBSPanel4: TSBSBackGroup
    Width = 336
    Height = 141
  end
  object Label83: Label8 [1]
    Left = 81
    Top = 55
    Width = 61
    Height = 14
    Alignment = taRightJustify
    Caption = ' Type Filter : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label86: Label8 [2]
    Left = 47
    Top = 27
    Width = 91
    Height = 14
    Alignment = taRightJustify
    Caption = 'For which period? '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label87: Label8 [3]
    Left = 228
    Top = 28
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
  object Label85: Label8 [4]
    Left = 66
    Top = 82
    Width = 71
    Height = 14
    Alignment = taRightJustify
    Caption = 'Supplier Filter :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label81: Label8 [5]
    Left = 69
    Top = 109
    Width = 73
    Height = 14
    Alignment = taRightJustify
    Caption = 'Report Detail :  '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  inherited OkCP1Btn: TButton
    Left = 93
    Top = 151
    TabOrder = 6
  end
  inherited ClsCP1Btn: TButton
    Left = 179
    Top = 151
    TabOrder = 7
  end
  inherited SBSPanel1: TSBSPanel
    TabOrder = 3
  end
  object SxSF: TSBSComboBox
    Tag = 1
    Left = 142
    Top = 52
    Width = 88
    Height = 22
    HelpContext = 2170
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
    Items.Strings = (
      'All'
      'CIS23'
      'CIS24'
      'CIS25')
    MaxListWidth = 90
    Validate = True
  end
  object I1TransDateF: TEditDate
    Tag = 1
    Left = 142
    Top = 24
    Width = 80
    Height = 22
    HelpContext = 2169
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
    TabOrder = 0
    Placement = cpAbove
  end
  object I2TransDateF: TEditDate
    Tag = 1
    Left = 245
    Top = 24
    Width = 80
    Height = 22
    HelpContext = 2169
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
    TabOrder = 1
    Placement = cpAbove
  end
  object V25PF: Text8Pt
    Left = 142
    Top = 79
    Width = 80
    Height = 22
    HelpContext = 2171
    CharCase = ecUpperCase
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 5
    ParentFont = False
    TabOrder = 4
    OnExit = V25PFExit
    TextId = 0
    ViaSBtn = False
  end
  object cbDetail: TSBSComboBox
    Tag = 1
    Left = 142
    Top = 106
    Width = 113
    Height = 22
    HelpContext = 2172
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
    TabOrder = 5
    Items.Strings = (
      'Summary'
      'Detailed'
      'Detailed + Matching')
    MaxListWidth = 90
    Validate = True
  end
end
