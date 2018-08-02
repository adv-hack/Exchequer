inherited BatchInp: TBatchInp
  HelpContext = 40100
  Caption = 'Batch'
  ClientHeight = 456
  ClientWidth = 396
  PixelsPerInch = 96
  TextHeight = 14
  inherited SBSPanel4: TSBSBackGroup
    Left = 3
    Top = 4
    Width = 386
    Height = 277
  end
  object Label81: Label8 [1]
    Left = 57
    Top = 18
    Width = 59
    Height = 14
    Caption = 'Run Number'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label82: Label8 [2]
    Left = 48
    Top = 48
    Width = 67
    Height = 14
    Caption = 'Payment Type'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label83: Label8 [3]
    Left = 44
    Top = 77
    Width = 72
    Height = 14
    Caption = 'Bank G/L Code'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label84: Label8 [4]
    Left = 34
    Top = 131
    Width = 82
    Height = 14
    Caption = 'Cost Centre/Dept'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label85: Label8 [5]
    Left = 14
    Top = 220
    Width = 102
    Height = 14
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Cheque No. Start'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label86: Label8 [6]
    Left = 27
    Top = 190
    Width = 89
    Height = 14
    Caption = 'Aged Balances by'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label87: Label8 [7]
    Left = 258
    Top = 188
    Width = 58
    Height = 14
    Caption = 'Age Interval'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label88: Label8 [8]
    Left = 15
    Top = 159
    Width = 101
    Height = 14
    Caption = 'Currency of Invoices'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label89: Label8 [9]
    Left = 208
    Top = 159
    Width = 109
    Height = 14
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Currency of Payments'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label810: Label8 [10]
    Left = 19
    Top = 103
    Width = 97
    Height = 14
    Caption = 'G/L Control Account'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label811: Label8 [11]
    Left = 15
    Top = 245
    Width = 101
    Height = 14
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Print for'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  inherited OkCP1Btn: TButton
    Left = 124
    Top = 429
    TabOrder = 22
  end
  inherited ClsCP1Btn: TButton
    Left = 212
    Top = 429
    TabOrder = 23
  end
  inherited SBSPanel1: TSBSPanel
    Left = 321
    Top = 220
    TabOrder = 17
    inherited Animated1: TAnimated
      Left = 4
    end
  end
  object NomDescF: Text8Pt
    Left = 214
    Top = 73
    Width = 163
    Height = 22
    HelpContext = 40105
    TabStop = False
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 4
    TextId = 0
    ViaSBtn = False
  end
  object Id3CCF: Text8Pt
    Left = 123
    Top = 126
    Width = 43
    Height = 22
    HelpContext = 40014
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 7
    OnExit = Id3CCFExit
    TextId = 0
    ViaSBtn = False
  end
  object Id3DepF: Text8Pt
    Left = 169
    Top = 126
    Width = 42
    Height = 22
    HelpContext = 40014
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
  object CQNo: TCurrencyEdit
    Left = 123
    Top = 214
    Width = 88
    Height = 22
    HelpContext = 40110
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      '0 ')
    MaxLength = 9
    ParentFont = False
    TabOrder = 14
    WantReturns = False
    WordWrap = False
    OnEnter = CQNoEnter
    OnExit = CQNoExit
    AutoSize = False
    BlockNegative = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0 ;###,###,##0-'
    DecPlaces = 0
    ShowCurrency = False
    TextId = 0
    Value = 1E-10
  end
  object AgeX: TSBSComboBox
    Left = 123
    Top = 185
    Width = 89
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
    TabOrder = 12
    Items.Strings = (
      'Days'
      'Weeks'
      'Months')
    MaxListWidth = 0
  end
  object CurrF: TSBSComboBox
    Left = 123
    Top = 155
    Width = 53
    Height = 22
    HelpContext = 40006
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
    OnExit = CurrFExit
    AllowChangeInExit = True
    ExtendedList = True
    MaxListWidth = 90
    Validate = True
  end
  object CurrPF: TSBSComboBox
    Left = 326
    Top = 155
    Width = 53
    Height = 22
    HelpContext = 40107
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
    TabOrder = 11
    OnExit = CurrFExit
    AllowChangeInExit = True
    ExtendedList = True
    MaxListWidth = 90
    Validate = True
  end
  object AgeIntF: TCurrencyEdit
    Left = 326
    Top = 185
    Width = 52
    Height = 22
    HelpContext = 40109
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      '0 ')
    MaxLength = 4
    ParentFont = False
    TabOrder = 13
    WantReturns = False
    WordWrap = False
    AutoSize = False
    BlockNegative = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0 ;###,###,##0-'
    DecPlaces = 0
    ShowCurrency = False
    TextId = 0
    Value = 1E-10
  end
  object ACFF: Text8Pt
    Left = 123
    Top = 73
    Width = 88
    Height = 22
    HelpContext = 40105
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
  object RunF: TCurrencyEdit
    Left = 123
    Top = 14
    Width = 88
    Height = 22
    HelpContext = 40101
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      '0 ')
    MaxLength = 9
    ParentFont = False
    TabOrder = 0
    WantReturns = False
    WordWrap = False
    AutoSize = False
    BlockNegative = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0 ;###,###,##0-'
    DecPlaces = 0
    ShowCurrency = False
    TextId = 0
    Value = 1E-10
  end
  object PayIF: Text8Pt
    Left = 123
    Top = 242
    Width = 88
    Height = 22
    HelpContext = 413
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 15
    TextId = 0
    ViaSBtn = False
  end
  object RPayF: TSBSComboBox
    Left = 123
    Top = 43
    Width = 88
    Height = 22
    HelpContext = 40102
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
    OnExit = RPayFExit
    Items.Strings = (
      'Cheque'
      'BACS'
      '2 Cheque (Alt)'
      '3 Cheque (Alt)')
    MaxListWidth = 90
    Validate = True
  end
  object GLMDC: Text8Pt
    Left = 123
    Top = 99
    Width = 88
    Height = 22
    HelpContext = 40104
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    OnExit = ACFFExit
    TextId = 0
    ViaSBtn = False
  end
  object NomDescF2: Text8Pt
    Left = 214
    Top = 99
    Width = 163
    Height = 22
    HelpContext = 40104
    TabStop = False
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 6
    TextId = 0
    ViaSBtn = False
  end
  object FilterX: TSBSComboBox
    Left = 123
    Top = 242
    Width = 78
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
    TabOrder = 18
    Items.Strings = (
      'All Accounts'
      'Hard Copy '
      'Fax '
      'Email')
    MaxListWidth = 0
  end
  object edtYourRef: Text8Pt
    Left = 215
    Top = 241
    Width = 123
    Height = 22
    HelpContext = 413
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 20
    ParentFont = False
    TabOrder = 19
    Visible = False
    TextId = 0
    ViaSBtn = False
  end
  object UseACC: TCheckBox
    Left = 256
    Top = 129
    Width = 121
    Height = 20
    HelpContext = 40103
    Alignment = taLeftJustify
    Caption = 'Use Account CC/Dep'
    Color = clBtnFace
    ParentColor = False
    TabOrder = 9
  end
  object SetPCQ: TCheckBox
    Left = 244
    Top = 215
    Width = 95
    Height = 20
    HelpContext = 966
    Alignment = taLeftJustify
    Caption = 'Set CQ printing'
    Color = clBtnFace
    ParentColor = False
    TabOrder = 16
  end
  object CBExcep: TCheckBox
    Left = 254
    Top = 15
    Width = 123
    Height = 20
    HelpContext = 1165
    Alignment = taLeftJustify
    Caption = 'Show Exception Log'
    Color = clBtnFace
    ParentColor = False
    TabOrder = 1
    OnClick = IncSDueCBClick
  end
  object grpPPD: TGroupBox
    Left = 4
    Top = 284
    Width = 385
    Height = 77
    Caption = 'Prompt Payment Discount'
    TabOrder = 20
    object lblIntendedPaymentDate: TLabel
      Left = 8
      Top = 48
      Width = 110
      Height = 14
      HelpContext = 2220
      Caption = 'Intended Payment Date'
    end
    object lblExpiryTolerance: TLabel
      Left = 216
      Top = 48
      Width = 80
      Height = 14
      HelpContext = 2219
      Caption = 'Expiry Tolerance'
    end
    object lblExpiryToleranceDays: TLabel
      Left = 348
      Top = 48
      Width = 25
      Height = 14
      HelpContext = 2219
      Caption = 'Days'
    end
    object chkGivePPD: TCheckBox
      Left = 72
      Top = 24
      Width = 65
      Height = 17
      HelpContext = 2221
      Alignment = taLeftJustify
      Caption = 'Give PPD'
      TabOrder = 0
    end
    object edtIntendedPaymentDate: TEditDate
      Left = 124
      Top = 44
      Width = 69
      Height = 22
      HelpContext = 2220
      AutoSelect = False
      EditMask = '00/00/0000;0;'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      MaxLength = 10
      ParentFont = False
      TabOrder = 1
      Placement = cpAbove
    end
    object udExpiryToleranceDays: TUpDown
      Left = 325
      Top = 44
      Width = 16
      Height = 22
      HelpContext = 2219
      Associate = edtExpiryToleranceDays
      Min = 0
      Max = 99
      Position = 90
      TabOrder = 2
      Wrap = False
    end
    object edtExpiryToleranceDays: TCurrencyEdit
      Left = 304
      Top = 44
      Width = 21
      Height = 22
      HelpContext = 2219
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'ARIAL'
      Font.Style = []
      Lines.Strings = (
        '90')
      MaxLength = 2
      ParentFont = False
      TabOrder = 3
      WantReturns = False
      WordWrap = False
      OnKeyPress = edtExpiryToleranceDaysKeyPress
      AutoSize = False
      BlockNegative = True
      BlankOnZero = False
      DisplayFormat = '###,###,##0 ;###,###,##0-'
      DecPlaces = 0
      ShowCurrency = False
      TextId = 0
      Value = 1E-10
    end
  end
  object grpSettlementDiscount: TGroupBox
    Left = 4
    Top = 368
    Width = 385
    Height = 57
    Caption = 'Settlement Discount'
    TabOrder = 21
    object Label812: Label8
      Left = 183
      Top = 27
      Width = 129
      Height = 14
      Caption = 'Days Over Settlement Disc'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object IncSDueCB: TCheckBox
      Left = 7
      Top = 25
      Width = 132
      Height = 20
      HelpContext = 1165
      Alignment = taLeftJustify
      Caption = 'Include Settlement Disc'
      Color = clBtnFace
      ParentColor = False
      TabOrder = 0
      OnClick = IncSDueCBClick
    end
    object SDDOverF: TCurrencyEdit
      Left = 320
      Top = 23
      Width = 52
      Height = 22
      HelpContext = 1166
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        '0 ')
      ParentFont = False
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
      Value = 1E-10
    end
  end
end
