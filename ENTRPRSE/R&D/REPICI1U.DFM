inherited RepJCCISEInp: TRepJCCISEInp
  Left = 461
  Top = 297
  HelpContext = 1217
  Caption = 'Sub-contractor list'
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
  object Label81: Label8 [2]
    Left = 63
    Top = 108
    Width = 79
    Height = 14
    Alignment = taRightJustify
    Caption = 'Sort Report by : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label85: Label8 [3]
    Left = 12
    Top = 81
    Width = 129
    Height = 14
    Alignment = taRightJustify
    Caption = 'Show Cert. Expiry within : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label82: Label8 [4]
    Left = 186
    Top = 81
    Width = 24
    Height = 14
    Caption = 'days'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label86: Label8 [5]
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
    Visible = False
    TextId = 0
  end
  object Label87: Label8 [6]
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
    Visible = False
    TextId = 0
  end
  inherited OkCP1Btn: TButton
    Left = 93
    Top = 151
    TabOrder = 5
  end
  inherited ClsCP1Btn: TButton
    Left = 179
    Top = 151
    TabOrder = 6
  end
  inherited SBSPanel1: TSBSPanel
    TabOrder = 7
  end
  object SxSF: TSBSComboBox
    Tag = 1
    Left = 142
    Top = 52
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
    TabOrder = 2
    OnChange = SxSFChange
    Items.Strings = (
      'All'
      'CIS 4T'
      'CIS 4P'
      'CIS 5'
      'CIS 5 Partner'
      'CIS 6 Group'
      'Non CIS'
      'Expired')
    MaxListWidth = 90
    Validate = True
  end
  object SortXCB: TSBSComboBox
    Tag = 1
    Left = 142
    Top = 105
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
    TabOrder = 4
    Items.Strings = (
      'Code'
      'Surname'
      'Sub Contract Name')
    MaxListWidth = 90
    Validate = True
  end
  object AgeInt: TCurrencyEdit
    Left = 142
    Top = 79
    Width = 37
    Height = 22
    HelpContext = 40109
    Color = clWhite
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      '0 ')
    MaxLength = 2
    ParentFont = False
    TabOrder = 3
    WantReturns = False
    WordWrap = False
    OnKeyPress = AgeIntKeyPress
    AutoSize = False
    BlockNegative = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0 ;###,###,##0-'
    DecPlaces = 0
    ShowCurrency = False
    TextId = 0
    Value = 1E-10
  end
  object I1TransDateF: TEditDate
    Tag = 1
    Left = 142
    Top = 24
    Width = 80
    Height = 22
    HelpContext = 678
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
    Visible = False
    Placement = cpAbove
  end
  object I2TransDateF: TEditDate
    Tag = 1
    Left = 245
    Top = 24
    Width = 80
    Height = 22
    HelpContext = 678
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
    Visible = False
    Placement = cpAbove
  end
end
