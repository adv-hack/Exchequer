inherited SOPInpMsg: TSOPInpMsg
  Left = 530
  Top = 158
  HelpContext = 492
  Caption = 'Sales Order Processing'
  ClientHeight = 360
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 14
  inherited SBSPanel4: TSBSBackGroup
    Top = 0
    Height = 329
  end
  object Label87: Label8 [1]
    Left = 184
    Top = 21
    Width = 47
    Height = 14
    Alignment = taRightJustify
    Caption = 'Run No. : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label83: Label8 [2]
    Left = 37
    Top = 52
    Width = 123
    Height = 14
    Alignment = taRightJustify
    Caption = 'Generate from Location : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label81: Label8 [3]
    Left = 29
    Top = 17
    Width = 103
    Height = 14
    Alignment = taRightJustify
    Caption = 'Process only tag No :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label82: Label8 [4]
    Left = 29
    Top = 30
    Width = 74
    Height = 14
    Caption = '(0 includes all)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsItalic]
    ParentFont = False
    TextId = 0
  end
  object Label811: Label8 [5]
    Left = 24
    Top = 194
    Width = 134
    Height = 14
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Print delivery method : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    Visible = False
    TextId = 0
  end
  object lblXMLLocation: Label8 [6]
    Left = 24
    Top = 222
    Width = 134
    Height = 14
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'eBis XML Output folder : '
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
    Left = 66
    Top = 335
    TabOrder = 16
  end
  inherited ClsCP1Btn: TButton
    Left = 152
    Top = 335
    TabOrder = 17
  end
  inherited SBSPanel1: TSBSPanel
    Top = 168
    TabOrder = 18
  end
  object Sum6: TBorCheck
    Left = 18
    Top = 244
    Width = 156
    Height = 20
    HelpContext = 487
    Caption = 'Convert SOR to SIN :'
    CheckColor = clWindowText
    Color = clBtnFace
    ParentColor = False
    TabOrder = 12
    TabStop = True
    TextId = 0
    OnClick = Sum6Click
  end
  object Sum7: TBorCheck
    Left = 27
    Top = 263
    Width = 147
    Height = 20
    HelpContext = 488
    Caption = 'Consolidate Transactions :'
    CheckColor = clWindowText
    Color = clBtnFace
    ParentColor = False
    TabOrder = 13
    TabStop = True
    TextId = 0
  end
  object Sum2: TBorCheck
    Left = 34
    Top = 75
    Width = 140
    Height = 20
    HelpContext = 483
    Caption = 'Print Delivery Notes :'
    CheckColor = clWindowText
    Color = clBtnFace
    ParentColor = False
    TabOrder = 3
    TabStop = True
    TextId = 0
  end
  object Sum3: TBorCheck
    Left = 42
    Top = 104
    Width = 132
    Height = 20
    HelpContext = 484
    Caption = 'Print Packaging Labels :'
    CheckColor = clWindowText
    Color = clBtnFace
    ParentColor = False
    TabOrder = 5
    TabStop = True
    TextId = 0
  end
  object Sum4: TBorCheck
    Left = 29
    Top = 133
    Width = 145
    Height = 20
    HelpContext = 485
    Caption = 'Print Consignment Notes :'
    CheckColor = clWindowText
    Color = clBtnFace
    ParentColor = False
    TabOrder = 7
    TabStop = True
    TextId = 0
  end
  object AgeInt: TCurrencyEdit
    Left = 233
    Top = 17
    Width = 52
    Height = 22
    HelpContext = 482
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      '1 ')
    ParentFont = False
    ReadOnly = True
    TabOrder = 1
    WantReturns = False
    WordWrap = False
    AutoSize = False
    BlockNegative = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0 ;###,###,##0-'
    DecPlaces = 0
    ShowCurrency = False
    TextId = 0
    Value = 1
  end
  object Sum5: TBorCheck
    Left = 29
    Top = 161
    Width = 145
    Height = 20
    HelpContext = 486
    Caption = 'Print Product Labels :'
    CheckColor = clWindowText
    Color = clBtnFace
    ParentColor = False
    TabOrder = 9
    TabStop = True
    TextId = 0
  end
  object PDNote: TSBSComboBox
    Left = 183
    Top = 74
    Width = 103
    Height = 22
    HelpContext = 483
    Style = csDropDownList
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 14
    ParentFont = False
    TabOrder = 4
    ExtendedList = True
    MaxListWidth = 250
  end
  object PDLab: TSBSComboBox
    Left = 183
    Top = 103
    Width = 103
    Height = 22
    HelpContext = 484
    Style = csDropDownList
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 14
    ParentFont = False
    TabOrder = 6
    ExtendedList = True
    MaxListWidth = 250
  end
  object PConN: TSBSComboBox
    Left = 183
    Top = 132
    Width = 103
    Height = 22
    HelpContext = 485
    Style = csDropDownList
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 14
    ParentFont = False
    TabOrder = 8
    ExtendedList = True
    MaxListWidth = 250
  end
  object PPLab: TSBSComboBox
    Left = 183
    Top = 161
    Width = 103
    Height = 22
    HelpContext = 486
    Style = csDropDownList
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 14
    ParentFont = False
    TabOrder = 10
    ExtendedList = True
    MaxListWidth = 250
  end
  object PrnScrnB: TBorCheck
    Left = 27
    Top = 303
    Width = 147
    Height = 20
    HelpContext = 490
    Caption = 'Print to Screen :'
    CheckColor = clWindowText
    Color = clBtnFace
    ParentColor = False
    TabOrder = 15
    TabStop = True
    TextId = 0
  end
  object PPaper: TBorCheck
    Left = 27
    Top = 283
    Width = 147
    Height = 20
    HelpContext = 489
    Caption = 'Prompt for paper change :'
    CheckColor = clWindowText
    Color = clBtnFace
    ParentColor = False
    TabOrder = 14
    TabStop = True
    TextId = 0
  end
  object ACFF: Text8Pt
    Tag = 1
    Left = 183
    Top = 46
    Width = 103
    Height = 22
    Hint = 
      'Double click to drill down|Double clicking or using the down but' +
      'ton will drill down to the record for this field. The up button ' +
      'will search for the nearest match.'
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
    Link_to_Cust = True
    ShowHilight = True
  end
  object Sum1: TCurrencyEdit
    Tag = 1
    Left = 139
    Top = 17
    Width = 32
    Height = 22
    HelpContext = 482
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      '99 ')
    MaxLength = 2
    ParentFont = False
    TabOrder = 0
    WantReturns = False
    WordWrap = False
    OnKeyPress = Sum1KeyPress
    AutoSize = False
    BlockNegative = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0 ;###,###,##0-'
    DecPlaces = 0
    ShowCurrency = False
    TextId = 0
    Value = 99
  end
  object FilterX: TSBSComboBox
    Left = 183
    Top = 190
    Width = 103
    Height = 22
    HelpContext = 634
    Style = csDropDownList
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 14
    ParentFont = False
    TabOrder = 11
    Visible = False
    Items.Strings = (
      'All Accounts'
      'Hard Copy '
      'Fax '
      'Email')
    MaxListWidth = 0
  end
  object edtXMLLocation: TAdvDirectoryEdit
    Left = 183
    Top = 219
    Width = 103
    Height = 22
    Flat = False
    LabelFont.Charset = DEFAULT_CHARSET
    LabelFont.Color = clWindowText
    LabelFont.Height = -11
    LabelFont.Name = 'MS Sans Serif'
    LabelFont.Style = []
    Lookup.Separator = ';'
    Color = clWindow
    Enabled = True
    TabOrder = 19
    Visible = False
    Version = '1.3.1.0'
    ButtonStyle = bsButton
    ButtonWidth = 18
    Etched = False
    Glyph.Data = {
      CE000000424DCE0000000000000076000000280000000C0000000B0000000100
      0400000000005800000000000000000000001000000000000000000000000000
      8000008000000080800080000000800080008080000080808000C0C0C0000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00F00000000FFF
      00000088888880FF00000B088888880F00000BB08888888000000BBB00000000
      00000BBBBBBB0B0F00000BBB00000B0F0000F000BBBBBB0F0000FF0BBBBBBB0F
      0000FF0BBB00000F0000FFF000FFFFFF0000}
    BrowseDialogText = 'Select Directory'
  end
end
