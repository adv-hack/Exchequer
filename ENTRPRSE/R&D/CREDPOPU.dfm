object CredPopUp: TCredPopUp
  Left = 882
  Top = 259
  HelpContext = 720
  ActiveControl = AccF
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'ObjectCredit Controller'
  ClientHeight = 302
  ClientWidth = 441
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  FormStyle = fsMDIChild
  KeyPreview = True
  OldCreateOrder = True
  Position = poDefaultPosOnly
  Scaled = False
  Visible = True
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 14
  object SBSPanel1: TSBSPanel
    Left = 0
    Top = 0
    Width = 441
    Height = 113
    Align = alTop
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
    object AccCodeLab: Label8
      Left = 10
      Top = 12
      Width = 18
      Height = 14
      Caption = 'A/C'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object CrLimitLab: Label8
      Left = 50
      Top = 64
      Width = 52
      Height = 14
      Caption = 'Credit Limit'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object BalanceLab: Label8
      Left = 168
      Top = 64
      Width = 39
      Height = 14
      Caption = 'Balance'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object CredAvailLab: Label8
      Left = 352
      Top = 64
      Width = 74
      Height = 14
      Alignment = taRightJustify
      Caption = 'Credit Available'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object DDaysLab1: Label8
      Left = 258
      Top = 5
      Width = 23
      Height = 14
      Caption = 'Avg.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object DDaysLab2: Label8
      Left = 252
      Top = 19
      Width = 35
      Height = 14
      Caption = 'D/Days'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Label81: Label8
      Left = 345
      Top = 8
      Width = 31
      Height = 14
      Caption = 'Oldest'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Label82: Label8
      Left = 337
      Top = 19
      Width = 46
      Height = 14
      Caption = 'Debt Wks'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Label85: Label8
      Left = 251
      Top = 41
      Width = 108
      Height = 14
      Alignment = taRightJustify
      Caption = 'Translate to Currency:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object AccF: Text8Pt
      Left = 31
      Top = 8
      Width = 61
      Height = 22
      Hint = 
        'Double click to drill down|Double clicking or using the down but' +
        'ton will drill down to the record for this field. The up button ' +
        'will search for the nearest match.'
      HelpContext = 721
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnExit = AccFExit
      TextId = 0
      ViaSBtn = False
      Link_to_Cust = True
      ShowHilight = True
    end
    object CompF: Text8Pt
      Left = 96
      Top = 8
      Width = 151
      Height = 22
      Hint = 
        'Double click to drill down|Double clicking will drill down to th' +
        'e main record for this field.'
      HelpContext = 721
      TabStop = False
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ReadOnly = True
      ShowHint = True
      TabOrder = 1
      OnDblClick = CompFDblClick
      TextId = 0
      ViaSBtn = False
    end
    object CrLimF: TCurrencyEdit
      Left = 11
      Top = 82
      Width = 100
      Height = 22
      HelpContext = 100
      TabStop = False
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'ARIAL'
      Font.Style = []
      Lines.Strings = (
        '0.01 ')
      MaxLength = 13
      ParentFont = False
      ReadOnly = True
      TabOrder = 5
      WantReturns = False
      WordWrap = False
      AutoSize = False
      BlockNegative = False
      BlankOnZero = False
      DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
      ShowCurrency = False
      TextId = 0
      Value = 0.01
    end
    object BalF: TCurrencyEdit
      Left = 117
      Top = 82
      Width = 100
      Height = 22
      HelpContext = 724
      TabStop = False
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'ARIAL'
      Font.Style = []
      Lines.Strings = (
        '0.01 ')
      MaxLength = 13
      ParentFont = False
      ReadOnly = True
      TabOrder = 6
      WantReturns = False
      WordWrap = False
      AutoSize = False
      BlockNegative = False
      BlankOnZero = False
      DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
      ShowCurrency = False
      TextId = 0
      Value = 0.01
    end
    object CommitF: TCurrencyEdit
      Left = 222
      Top = 82
      Width = 100
      Height = 22
      HelpContext = 725
      TabStop = False
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'ARIAL'
      Font.Style = []
      Lines.Strings = (
        '0.01 ')
      MaxLength = 13
      ParentFont = False
      ReadOnly = True
      TabOrder = 7
      WantReturns = False
      WordWrap = False
      AutoSize = False
      BlockNegative = False
      BlankOnZero = False
      DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
      ShowCurrency = False
      TextId = 0
      Value = 0.01
    end
    object AvailF: TCurrencyEdit
      Left = 327
      Top = 82
      Width = 100
      Height = 22
      HelpContext = 99
      TabStop = False
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'ARIAL'
      Font.Style = []
      Lines.Strings = (
        '0.01 ')
      MaxLength = 13
      ParentFont = False
      ReadOnly = True
      TabOrder = 8
      WantReturns = False
      WordWrap = False
      AutoSize = False
      BlockNegative = False
      BlankOnZero = False
      DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
      ShowCurrency = False
      TextId = 0
      Value = 0.01
    end
    object DDaysF: TCurrencyEdit
      Left = 289
      Top = 9
      Width = 44
      Height = 22
      HelpContext = 722
      TabStop = False
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'ARIAL'
      Font.Style = []
      Lines.Strings = (
        '0 ')
      MaxLength = 10
      ParentFont = False
      ReadOnly = True
      TabOrder = 2
      WantReturns = False
      WordWrap = False
      AutoSize = False
      BlockNegative = False
      BlankOnZero = False
      DisplayFormat = '###,###,##0 ;###,###,##0-'
      DecPlaces = 0
      ShowCurrency = False
      TextId = 0
      Value = 0.01
    end
    object CredSF: TCurrencyEdit
      Left = 383
      Top = 9
      Width = 44
      Height = 22
      HelpContext = 723
      TabStop = False
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'ARIAL'
      Font.Style = []
      Lines.Strings = (
        '0 ')
      MaxLength = 10
      ParentFont = False
      ReadOnly = True
      TabOrder = 9
      WantReturns = False
      WordWrap = False
      AutoSize = False
      BlockNegative = False
      BlankOnZero = False
      DisplayFormat = '###,###,##0 ;###,###,##0-'
      DecPlaces = 0
      ShowCurrency = False
      TextId = 0
      Value = 0.01
    end
    object HOComF: TBorCheck
      Left = 285
      Top = 61
      Width = 38
      Height = 20
      HelpContext = 725
      Caption = 'H/O'
      Color = clBtnFace
      Checked = True
      ParentColor = False
      State = cbChecked
      TabOrder = 4
      TabStop = True
      TextId = 0
      Visible = False
      OnMouseUp = HOComFMouseUp
    end
    object CommitBttn: TButton
      Left = 223
      Top = 64
      Width = 100
      Height = 16
      HelpContext = 725
      Caption = 'Committed'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnClick = CommitBttnClick
    end
    object CurrF3: TSBSComboBox
      Tag = 1
      Left = 360
      Top = 37
      Width = 66
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
      TabOrder = 10
      OnChange = CurrFChange
      ExtendedList = True
      MaxListWidth = 90
      Validate = True
    end
  end
  object SOPPanel: TSBSPanel
    Left = 0
    Top = 113
    Width = 441
    Height = 37
    Align = alTop
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 1
    Visible = False
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
    object SORLab: Label8
      Left = 29
      Top = 11
      Width = 85
      Height = 14
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Orders O/S '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object SDNLab: Label8
      Left = 234
      Top = 11
      Width = 91
      Height = 14
      Caption = 'Delivery Notes O/S'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object SORF: TCurrencyEdit
      Left = 117
      Top = 7
      Width = 100
      Height = 22
      Hint = 
        'Double click to drill down|Double clicking will drill down to th' +
        'e main record for this field.'
      HelpContext = 725
      TabStop = False
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'ARIAL'
      Font.Style = []
      Lines.Strings = (
        '0.01 ')
      MaxLength = 13
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
      WantReturns = False
      WordWrap = False
      OnDblClick = SORFDblClick
      AutoSize = False
      BlockNegative = False
      BlankOnZero = False
      DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
      ShowCurrency = False
      TextId = 0
      Value = 0.01
    end
    object SDNF: TCurrencyEdit
      Left = 327
      Top = 7
      Width = 100
      Height = 22
      Hint = 
        'Double click to drill down|Double clicking will drill down to th' +
        'e main record for this field.'
      HelpContext = 725
      TabStop = False
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'ARIAL'
      Font.Style = []
      Lines.Strings = (
        '0.01 ')
      MaxLength = 13
      ParentFont = False
      ReadOnly = True
      TabOrder = 1
      WantReturns = False
      WordWrap = False
      OnChange = SDNFChange
      OnDblClick = SORFDblClick
      AutoSize = False
      BlockNegative = False
      BlankOnZero = False
      DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
      ShowCurrency = False
      TextId = 0
      Value = 0.01
    end
  end
  object SBSPanel3: TSBSPanel
    Left = 0
    Top = 150
    Width = 441
    Height = 109
    Align = alTop
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 2
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
    object AgeAtLab: Label8
      Left = 13
      Top = 14
      Width = 78
      Height = 14
      Caption = 'Age Debts as at'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object AgeByLab: Label8
      Left = 183
      Top = 14
      Width = 35
      Height = 14
      Caption = 'Age by'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object AgeIntLab: Label8
      Left = 303
      Top = 14
      Width = 35
      Height = 14
      Caption = 'Interval'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Age1Lab: Label8
      Left = 8
      Top = 59
      Width = 77
      Height = 14
      Alignment = taCenter
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Age2Lab: Label8
      Left = 94
      Top = 59
      Width = 77
      Height = 14
      Alignment = taCenter
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Age3Lab: Label8
      Left = 179
      Top = 59
      Width = 77
      Height = 14
      Alignment = taCenter
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Age4Lab: Label8
      Left = 263
      Top = 59
      Width = 77
      Height = 14
      Alignment = taCenter
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Age5Lab: Label8
      Left = 348
      Top = 59
      Width = 82
      Height = 14
      Alignment = taCenter
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object IntText: Label8
      Left = 386
      Top = 15
      Width = 46
      Height = 14
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Label83: Label8
      Left = 10
      Top = 41
      Width = 82
      Height = 14
      Alignment = taRightJustify
      Caption = 'Ageing Currency'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Label811: Label8
      Left = 179
      Top = 41
      Width = 44
      Height = 14
      Alignment = taRightJustify
      Caption = 'Txlate to '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Label84: Label8
      Left = 296
      Top = 41
      Width = 47
      Height = 14
      Caption = 'Last Paid '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      Visible = False
      TextId = 0
    end
    object AgeAtF: TEditDate
      Left = 94
      Top = 10
      Width = 80
      Height = 22
      HelpContext = 637
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
      OnExit = AgeByFChange
      Placement = cpAbove
    end
    object AgeByF: TSBSComboBox
      Left = 224
      Top = 10
      Width = 66
      Height = 22
      HelpContext = 40108
      Style = csDropDownList
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ItemHeight = 14
      ParentFont = False
      TabOrder = 1
      OnChange = AgeByFChange
      Items.Strings = (
        'Days'
        'Weeks'
        'Months'
        '')
      MaxListWidth = 0
    end
    object AgeIntF: TCurrencyEdit
      Left = 346
      Top = 11
      Width = 40
      Height = 22
      HelpContext = 40109
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'ARIAL'
      Font.Style = []
      Lines.Strings = (
        '0 ')
      MaxLength = 10
      ParentFont = False
      TabOrder = 2
      WantReturns = False
      WordWrap = False
      OnExit = AgeByFChange
      AutoSize = False
      BlockNegative = False
      BlankOnZero = False
      DisplayFormat = '###,###,##0 ;###,###,##0-'
      DecPlaces = 0
      ShowCurrency = False
      TextId = 0
      Value = 0.01
    end
    object Age1: TCurrencyEdit
      Left = 6
      Top = 77
      Width = 80
      Height = 22
      Hint = 
        'Double click to drill down|Double clicking will drill down to th' +
        'e main record for this field.'
      HelpContext = 726
      TabStop = False
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'ARIAL'
      Font.Style = []
      Lines.Strings = (
        '0.01 ')
      MaxLength = 13
      ParentFont = False
      ReadOnly = True
      TabOrder = 5
      WantReturns = False
      WordWrap = False
      OnDblClick = Age1DblClick
      AutoSize = False
      BlockNegative = False
      BlankOnZero = False
      DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
      ShowCurrency = False
      TextId = 0
      Value = 0.01
    end
    object Age2: TCurrencyEdit
      Left = 92
      Top = 77
      Width = 80
      Height = 22
      Hint = 
        'Double click to drill down|Double clicking will drill down to th' +
        'e main record for this field.'
      HelpContext = 726
      TabStop = False
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'ARIAL'
      Font.Style = []
      Lines.Strings = (
        '0.01 ')
      MaxLength = 13
      ParentFont = False
      ReadOnly = True
      TabOrder = 6
      WantReturns = False
      WordWrap = False
      OnDblClick = Age1DblClick
      AutoSize = False
      BlockNegative = False
      BlankOnZero = False
      DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
      ShowCurrency = False
      TextId = 0
      Value = 0.01
    end
    object Age3: TCurrencyEdit
      Left = 177
      Top = 77
      Width = 80
      Height = 22
      Hint = 
        'Double click to drill down|Double clicking will drill down to th' +
        'e main record for this field.'
      HelpContext = 726
      TabStop = False
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'ARIAL'
      Font.Style = []
      Lines.Strings = (
        '0.01 ')
      MaxLength = 13
      ParentFont = False
      ReadOnly = True
      TabOrder = 7
      WantReturns = False
      WordWrap = False
      OnDblClick = Age1DblClick
      AutoSize = False
      BlockNegative = False
      BlankOnZero = False
      DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
      ShowCurrency = False
      TextId = 0
      Value = 0.01
    end
    object Age4: TCurrencyEdit
      Left = 262
      Top = 77
      Width = 80
      Height = 22
      Hint = 
        'Double click to drill down|Double clicking will drill down to th' +
        'e main record for this field.'
      HelpContext = 726
      TabStop = False
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'ARIAL'
      Font.Style = []
      Lines.Strings = (
        '0.01 ')
      MaxLength = 13
      ParentFont = False
      ReadOnly = True
      TabOrder = 8
      WantReturns = False
      WordWrap = False
      OnDblClick = Age1DblClick
      AutoSize = False
      BlockNegative = False
      BlankOnZero = False
      DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
      ShowCurrency = False
      TextId = 0
      Value = 0.01
    end
    object Age5: TCurrencyEdit
      Left = 346
      Top = 77
      Width = 85
      Height = 22
      Hint = 
        'Double click to drill down|Double clicking will drill down to th' +
        'e main record for this field.'
      HelpContext = 726
      TabStop = False
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'ARIAL'
      Font.Style = []
      Lines.Strings = (
        '0.01 ')
      MaxLength = 13
      ParentFont = False
      ReadOnly = True
      TabOrder = 9
      WantReturns = False
      WordWrap = False
      OnDblClick = Age1DblClick
      AutoSize = False
      BlockNegative = False
      BlankOnZero = False
      DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
      ShowCurrency = False
      TextId = 0
      Value = 0.01
    end
    object CurrF: TSBSComboBox
      Tag = 1
      Left = 94
      Top = 37
      Width = 80
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
      TabOrder = 3
      OnChange = CurrFChange
      ExtendedList = True
      MaxListWidth = 90
      Validate = True
    end
    object CurrF2: TSBSComboBox
      Tag = 1
      Left = 224
      Top = 37
      Width = 66
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
      TabOrder = 4
      OnChange = CurrFChange
      ExtendedList = True
      MaxListWidth = 90
      Validate = True
    end
    object LastPaidF: TEditDate
      Left = 346
      Top = 37
      Width = 80
      Height = 22
      HelpContext = 1576
      TabStop = False
      AutoSelect = False
      Color = clBtnFace
      EditMask = '00/00/0000;0;'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      MaxLength = 10
      ParentFont = False
      ReadOnly = True
      TabOrder = 10
      Visible = False
      OnExit = AgeByFChange
      Placement = cpAbove
    end
  end
  object SBSPanel2: TSBSPanel
    Left = 0
    Top = 258
    Width = 441
    Height = 44
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 3
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
    object OkCP1Btn: TButton
      Tag = 1
      Left = 140
      Top = 6
      Width = 80
      Height = 21
      Cancel = True
      Caption = '&OK'
      ModalResult = 1
      TabOrder = 0
      OnClick = OkCP1BtnClick
    end
    object FrzeBtn: TButton
      Tag = 1
      Left = 226
      Top = 6
      Width = 80
      Height = 21
      Caption = '&Freeze'
      TabOrder = 1
      OnClick = FrzeBtnClick
    end
  end
end
