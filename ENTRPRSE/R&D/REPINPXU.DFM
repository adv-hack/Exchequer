inherited RepInpMsgX: TRepInpMsgX
  Left = 512
  Top = 261
  HelpContext = 670
  Caption = 'Works Order Report'
  ClientHeight = 292
  ClientWidth = 379
  PixelsPerInch = 96
  TextHeight = 14
  inherited SBSPanel4: TSBSBackGroup
    Width = 370
    Height = 245
  end
  object Label81: Label8 [1]
    Left = 26
    Top = 29
    Width = 118
    Height = 14
    Alignment = taRightJustify
    Caption = 'Stock Code/Group filter :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label89: Label8 [2]
    Left = 54
    Top = 52
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
    Left = 13
    Top = 76
    Width = 134
    Height = 14
    Alignment = taRightJustify
    Caption = 'For completion date range : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object LocLab: Label8 [4]
    Left = 192
    Top = 181
    Width = 57
    Height = 14
    Alignment = taRightJustify
    Caption = 'Locn filter : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label82: Label8 [5]
    Left = 26
    Top = 105
    Width = 119
    Height = 14
    Alignment = taRightJustify
    Caption = ' WOR Document range : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label83: Label8 [6]
    Left = 249
    Top = 104
    Width = 17
    Height = 14
    Alignment = taRightJustify
    Caption = 'To :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label84: Label8 [7]
    Left = 232
    Top = 78
    Width = 17
    Height = 14
    Alignment = taRightJustify
    Caption = 'To :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label85: Label8 [8]
    Left = 66
    Top = 130
    Width = 79
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
  object Label87: Label8 [9]
    Left = 44
    Top = 177
    Width = 97
    Height = 14
    Alignment = taRightJustify
    Caption = 'Include only tag No :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label88: Label8 [10]
    Left = 43
    Top = 190
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
  object Label810: Label8 [11]
    Left = 65
    Top = 209
    Width = 79
    Height = 14
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Include : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    Visible = False
    TextId = 0
  end
  object Label811: Label8 [12]
    Left = 168
    Top = 158
    Width = 156
    Height = 14
    AutoSize = False
    Caption = '(Allocated figure will include Sales)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -9
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  inherited OkCP1Btn: TButton
    Left = 106
    Top = 262
    TabOrder = 13
  end
  inherited ClsCP1Btn: TButton
    Left = 192
    Top = 262
    TabOrder = 14
  end
  inherited SBSPanel1: TSBSPanel
    TabOrder = 0
  end
  object ACFF: Text8Pt
    Tag = 1
    Left = 147
    Top = 24
    Width = 99
    Height = 22
    Hint = 
      'Double click to drill down|Double clicking or using the down but' +
      'ton will drill down to the record for this field. The up button ' +
      'will search for the nearest match.'
    HelpContext = 1248
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnExit = ACFFExit
    TextId = 0
    ViaSBtn = False
    Link_to_Stock = True
    ShowHilight = True
  end
  object AccF3: Text8Pt
    Tag = 1
    Left = 147
    Top = 49
    Width = 60
    Height = 22
    Hint = 
      'Double click to drill down|Double clicking or using the down but' +
      'ton will drill down to the record for this field. The up button ' +
      'will search for the nearest match.'
    HelpContext = 1249
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    OnExit = AccF3Exit
    TextId = 0
    ViaSBtn = False
    Link_to_Cust = True
    ShowHilight = True
  end
  object I1TransDateF: TEditDate
    Tag = 1
    Left = 147
    Top = 74
    Width = 80
    Height = 22
    HelpContext = 1250
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
  object LocF: Text8Pt
    Tag = 1
    Left = 251
    Top = 177
    Width = 46
    Height = 22
    HelpContext = 1255
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 10
    OnExit = LocFExit
    TextId = 0
    ViaSBtn = False
  end
  object I2TransDateF: TEditDate
    Tag = 1
    Left = 249
    Top = 74
    Width = 80
    Height = 22
    HelpContext = 1250
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
  object SorF: Text8Pt
    Tag = 1
    Left = 147
    Top = 100
    Width = 99
    Height = 22
    HelpContext = 1251
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    OnExit = SorFExit
    TextId = 0
    ViaSBtn = False
  end
  object SorTF: Text8Pt
    Tag = 1
    Left = 266
    Top = 100
    Width = 99
    Height = 22
    HelpContext = 1251
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 6
    OnExit = SorFExit
    TextId = 0
    ViaSBtn = False
  end
  object AgeX: TSBSComboBox
    Left = 147
    Top = 127
    Width = 178
    Height = 22
    HelpContext = 1252
    Style = csDropDownList
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 14
    ParentFont = False
    TabOrder = 7
    Items.Strings = (
      'Completion Date'
      'Tag Number/Completion Date'
      'Account Code/Completion Date'
      'WOR No. Ascending Order'
      'WOR No. Descending Order')
    MaxListWidth = 0
  end
  object CBFiltF: TSBSComboBox
    Left = 147
    Top = 205
    Width = 152
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
      'Both Started & Unstarted WOR'#39's'
      'Only Unstarted WOR'#39's'
      'Only Started WOR'#39's')
    MaxListWidth = 0
  end
  object Sum1: TCurrencyEdit
    Tag = 1
    Left = 147
    Top = 177
    Width = 32
    Height = 22
    HelpContext = 1254
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      '0 ')
    MaxLength = 2
    ParentFont = False
    TabOrder = 9
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
    Value = 1E-10
  end
  object BorCheck1: TBorCheck
    Left = 10
    Top = 153
    Width = 150
    Height = 20
    HelpContext = 1253
    Caption = 'Include Sales Allocations'
    CheckColor = clWindowText
    Color = clBtnFace
    ParentColor = False
    TabOrder = 8
    TabStop = True
    TextId = 0
  end
  object CBShowF: TSBSComboBox
    Left = 147
    Top = 224
    Width = 152
    Height = 22
    HelpContext = 1256
    Style = csDropDownList
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 14
    ParentFont = False
    TabOrder = 12
    Visible = False
    Items.Strings = (
      'Shortage Costs'
      'Completion Date Forecast')
    MaxListWidth = 0
  end
end
