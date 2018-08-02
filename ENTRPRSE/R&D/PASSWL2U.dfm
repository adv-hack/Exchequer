object PwordList2: TPwordList2
  Left = 372
  Top = 138
  Width = 691
  Height = 569
  HelpContext = 389
  Caption = 'Password Settings'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  FormStyle = fsMDIChild
  KeyPreview = True
  OldCreateOrder = True
  PopupMenu = PopupMenu1
  Position = poDefault
  Scaled = False
  ShowHint = True
  Visible = True
  OnActivate = FormActivate
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 14
  object PageControl1: TPageControl
    Left = 2
    Top = 1
    Width = 667
    Height = 524
    ActivePage = ItemPage
    TabIndex = 0
    TabOrder = 0
    OnChange = PageControl1Change
    OnChanging = PageControl1Changing
    object ItemPage: TTabSheet
      Caption = 'Properties'
      object D1SBox: TScrollBox
        Left = 5
        Top = 5
        Width = 74
        Height = 493
        HelpContext = 391
        HorzScrollBar.Visible = False
        VertScrollBar.Visible = False
        TabOrder = 0
        object D1HedPanel: TSBSPanel
          Left = 3
          Top = 4
          Width = 65
          Height = 17
          BevelInner = bvLowered
          BevelOuter = bvNone
          TabOrder = 0
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          object UNLab: TSBSPanel
            Left = 4
            Top = 2
            Width = 60
            Height = 13
            Alignment = taLeftJustify
            BevelOuter = bvNone
            Caption = 'User Name'
            Color = clWhite
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 0
            OnMouseDown = UNLabMouseDown
            OnMouseMove = UNLabMouseMove
            OnMouseUp = UNLabMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
        end
        object UNPanel: TSBSPanel
          Left = 3
          Top = 23
          Width = 65
          Height = 464
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          OnClick = UNPanelClick
          OnMouseUp = UNLabMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
      end
      object PListBtnPanel: TSBSPanel
        Left = 82
        Top = 28
        Width = 18
        Height = 467
        BevelOuter = bvLowered
        TabOrder = 1
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
      end
      object D3SBox: TScrollBox
        Left = 102
        Top = 5
        Width = 447
        Height = 493
        HelpContext = 392
        HorzScrollBar.Visible = False
        VertScrollBar.Visible = False
        BorderStyle = bsNone
        Ctl3D = True
        ParentCtl3D = False
        PopupMenu = PopupMenu1
        TabOrder = 2
        object SBSBackGroup2: TSBSBackGroup
          Left = 4
          Top = 155
          Width = 437
          Height = 202
          Caption = 'Defaults'
          TextId = 0
        end
        object SBSBackGroup3: TSBSBackGroup
          Left = 4
          Top = 426
          Width = 437
          Height = 60
          TextId = 0
        end
        object SBSBackGroup1: TSBSBackGroup
          Left = 4
          Top = -4
          Width = 437
          Height = 115
          TextId = 0
        end
        object Label81: Label8
          Left = 12
          Top = 12
          Width = 59
          Height = 14
          Caption = 'User Name :'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label82: Label8
          Left = 156
          Top = 12
          Width = 56
          Height = 14
          Caption = 'Password :'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label811: Label8
          Left = 61
          Top = 176
          Width = 79
          Height = 14
          Alignment = taRightJustify
          Caption = 'Customer (SRI) :'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label83: Label8
          Left = 230
          Top = 61
          Width = 25
          Height = 14
          Caption = 'Days'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label85: Label8
          Left = 17
          Top = 202
          Width = 122
          Height = 14
          Caption = 'Max Sales Authorisation :'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label86: Label8
          Left = 15
          Top = 229
          Width = 123
          Height = 14
          Caption = 'Max Purch Authorisation :'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label87: Label8
          Left = 18
          Top = 255
          Width = 121
          Height = 14
          Caption = 'Cost Centre/Department :'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label88: Label8
          Left = 92
          Top = 280
          Width = 47
          Height = 14
          Caption = 'Location :'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label89: Label8
          Left = 32
          Top = 304
          Width = 108
          Height = 14
          Caption = 'Sales Bank G/L Code :'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label828: Label8
          Left = 13
          Top = 443
          Width = 75
          Height = 14
          Caption = 'Report Printer : '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label829: Label8
          Left = 14
          Top = 465
          Width = 70
          Height = 14
          Caption = 'Forms Printer :'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object SRCGLLab: Label8
          Left = 220
          Top = 304
          Width = 209
          Height = 14
          AutoSize = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TextId = 0
        end
        object PPYGLLab: Label8
          Left = 220
          Top = 327
          Width = 209
          Height = 14
          AutoSize = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TextId = 0
        end
        object Label813: Label8
          Left = 79
          Top = 86
          Width = 137
          Height = 14
          Caption = 'Automatically Lock out after '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label814: Label8
          Left = 253
          Top = 86
          Width = 97
          Height = 14
          Caption = 'minutes of inactivity.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label812: Label8
          Left = 18
          Top = 37
          Width = 52
          Height = 14
          Caption = 'Full Name :'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object SBSBackGroup4: TSBSBackGroup
          Left = 4
          Top = 111
          Width = 437
          Height = 44
          Caption = 'Email'
          TextId = 0
        end
        object Label810: Label8
          Left = 12
          Top = 328
          Width = 127
          Height = 14
          Caption = 'Purchase Bank G/L Code :'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label817: Label8
          Left = 232
          Top = 255
          Width = 33
          Height = 14
          Caption = 'Rules :'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label818: Label8
          Left = 232
          Top = 280
          Width = 33
          Height = 14
          Caption = 'Rules :'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label819: Label8
          Left = 24
          Top = 60
          Width = 46
          Height = 14
          Caption = 'Security :'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label820: Label8
          Left = 230
          Top = 176
          Width = 70
          Height = 14
          Caption = 'Supplier (PPI) :'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object SBSBackGroup5: TSBSBackGroup
          Left = 4
          Top = 358
          Width = 437
          Height = 69
          Caption = 'Options'
          TextId = 0
        end
        object Label821: Label8
          Left = 12
          Top = 380
          Width = 100
          Height = 14
          Caption = 'General Ledger Tree'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Bevel1: TBevel
          Left = 168
          Top = 372
          Width = 9
          Height = 49
          Shape = bsRightLine
        end
        object Label822: Label8
          Left = 188
          Top = 380
          Width = 52
          Height = 14
          Caption = 'Stock Tree'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object SCodeF: Text8Pt
          Tag = 1
          Left = 77
          Top = 8
          Width = 70
          Height = 22
          HelpContext = 1233
          CharCase = ecUpperCase
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          MaxLength = 10
          ParentFont = False
          ParentShowHint = False
          ReadOnly = True
          ShowHint = True
          TabOrder = 0
          OnExit = SCodeFExit
          TextId = 0
          ViaSBtn = False
        end
        object DescF: Text8Pt
          Tag = 1
          Left = 217
          Top = 8
          Width = 70
          Height = 22
          HelpContext = 1234
          CharCase = ecUpperCase
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          MaxLength = 8
          ParentFont = False
          ParentShowHint = False
          PasswordChar = 'x'
          ReadOnly = True
          ShowHint = True
          TabOrder = 1
          OnEnter = DescFEnter
          OnExit = DescFExit
          TextId = 0
          ViaSBtn = False
        end
        object DSRIF: Text8Pt
          Tag = 1
          Left = 143
          Top = 172
          Width = 78
          Height = 22
          Hint = 
            'Double click to drill down|Double clicking or using the down but' +
            'ton will drill down to the record for this field. The up button ' +
            'will search for the nearest match.'
          HelpContext = 1239
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ReadOnly = True
          ShowHint = True
          TabOrder = 8
          OnExit = DSRIFExit
          TextId = 0
          ViaSBtn = False
          Link_to_Cust = True
          ShowHilight = True
        end
        object DPPIF: Text8Pt
          Tag = 1
          Left = 305
          Top = 172
          Width = 74
          Height = 22
          Hint = 
            'Double click to drill down|Double clicking or using the down but' +
            'ton will drill down to the record for this field. The up button ' +
            'will search for the nearest match.'
          HelpContext = 1239
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ReadOnly = True
          ShowHint = True
          TabOrder = 9
          OnExit = DSRIFExit
          TextId = 0
          ViaSBtn = False
          Link_to_Cust = True
          ShowHilight = True
        end
        object PWExDateF: TEditDate
          Tag = 1
          Left = 294
          Top = 58
          Width = 70
          Height = 22
          HelpContext = 1236
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
          ReadOnly = True
          TabOrder = 5
          Placement = cpAbove
          AllowBlank = True
        end
        object PWModeCBF: TSBSComboBox
          Tag = 1
          Left = 77
          Top = 58
          Width = 145
          Height = 22
          HelpContext = 1236
          Style = csDropDownList
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ItemHeight = 14
          ParentFont = False
          TabOrder = 3
          OnChange = PWModeCBFChange
          Items.Strings = (
            'Password Never Expires'
            'Password Expires every'
            'Password Expired')
          MaxListWidth = 0
          ReadOnly = True
        end
        object PWEDaysF: TCurrencyEdit
          Tag = 1
          Left = 257
          Top = 58
          Width = 31
          Height = 22
          HelpContext = 1236
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Lines.Strings = (
            '0 ')
          MaxLength = 3
          ParentFont = False
          ReadOnly = True
          TabOrder = 4
          WantReturns = False
          WordWrap = False
          OnExit = PWEDaysFExit
          AutoSize = False
          BlockNegative = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0 ;###,###,##0-'
          DecPlaces = 0
          ShowCurrency = False
          TextId = 0
          Value = 1E-10
        end
        object MaxSAF: TCurrencyEdit
          Tag = 1
          Left = 143
          Top = 196
          Width = 87
          Height = 25
          HelpContext = 1240
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Lines.Strings = (
            '0.00 ')
          ParentFont = False
          ReadOnly = True
          TabOrder = 10
          WantReturns = False
          WordWrap = False
          AutoSize = False
          BlockNegative = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
          ShowCurrency = False
          TextId = 0
          Value = 1E-10
        end
        object MaxPAF: TCurrencyEdit
          Tag = 1
          Left = 143
          Top = 223
          Width = 87
          Height = 25
          HelpContext = 1240
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Lines.Strings = (
            '0.00 ')
          ParentFont = False
          ReadOnly = True
          TabOrder = 11
          WantReturns = False
          WordWrap = False
          AutoSize = False
          BlockNegative = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
          ShowCurrency = False
          TextId = 0
          Value = 1E-10
        end
        object CCF: Text8Pt
          Tag = 1
          Left = 143
          Top = 251
          Width = 42
          Height = 22
          HelpContext = 1241
          CharCase = ecUpperCase
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ReadOnly = True
          ShowHint = True
          TabOrder = 12
          OnChange = PWModeCBFChange
          OnExit = CCFExit
          TextId = 0
          ViaSBtn = False
        end
        object DepF: Text8Pt
          Tag = 1
          Left = 187
          Top = 251
          Width = 42
          Height = 22
          HelpContext = 1241
          CharCase = ecUpperCase
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ReadOnly = True
          ShowHint = True
          TabOrder = 13
          OnChange = PWModeCBFChange
          OnExit = CCFExit
          TextId = 0
          ViaSBtn = False
        end
        object LocF: Text8Pt
          Tag = 1
          Left = 143
          Top = 276
          Width = 42
          Height = 22
          HelpContext = 1242
          CharCase = ecUpperCase
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ReadOnly = True
          ShowHint = True
          TabOrder = 15
          OnChange = PWModeCBFChange
          OnExit = LocFExit
          TextId = 0
          ViaSBtn = False
        end
        object SBankGLF: Text8Pt
          Tag = 1
          Left = 143
          Top = 300
          Width = 72
          Height = 22
          HelpContext = 1243
          CharCase = ecUpperCase
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ReadOnly = True
          ShowHint = True
          TabOrder = 17
          OnExit = SBankGLFExit
          TextId = 0
          ViaSBtn = False
        end
        object PBankGLF: Text8Pt
          Tag = 1
          Left = 143
          Top = 324
          Width = 72
          Height = 22
          HelpContext = 1243
          CharCase = ecUpperCase
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ReadOnly = True
          ShowHint = True
          TabOrder = 18
          OnExit = SBankGLFExit
          TextId = 0
          ViaSBtn = False
        end
        object DefRPrn: TSBSComboBox
          Tag = 1
          Left = 91
          Top = 436
          Width = 202
          Height = 22
          HelpContext = 1244
          Style = csDropDownList
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ItemHeight = 14
          ParentFont = False
          TabOrder = 22
          Items.Strings = (
            'None'
            'Automatic'
            'Manual')
          ExtendedList = True
          MaxListWidth = 250
          ReadOnly = True
        end
        object DefFPrn: TSBSComboBox
          Tag = 1
          Left = 91
          Top = 460
          Width = 202
          Height = 22
          HelpContext = 1244
          Style = csDropDownList
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ItemHeight = 14
          ParentFont = False
          TabOrder = 23
          Items.Strings = (
            'None'
            'Automatic'
            'Manual')
          ExtendedList = True
          MaxListWidth = 250
          ReadOnly = True
        end
        object CCDRulesCB: TSBSComboBox
          Tag = 1
          Left = 268
          Top = 251
          Width = 157
          Height = 22
          HelpContext = 1241
          Style = csDropDownList
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ItemHeight = 14
          ParentFont = False
          TabOrder = 14
          Items.Strings = (
            'Stock, Account, Operator'
            'Account, Stock, Operator'
            'Operator, Account, Stock'
            'Operator, Stock, Account')
          ExtendedList = True
          MaxListWidth = 170
          ReadOnly = True
        end
        object LOCRulesCB: TSBSComboBox
          Tag = 1
          Left = 268
          Top = 276
          Width = 157
          Height = 22
          HelpContext = 1242
          Style = csDropDownList
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ItemHeight = 14
          ParentFont = False
          TabOrder = 16
          Items.Strings = (
            'Account, Stock, Operator'
            'Stock, Account, Operator'
            'Operator, Account, Stock'
            'Operator, Stock, Account')
          ExtendedList = True
          MaxListWidth = 170
          ReadOnly = True
        end
        object PWALogF: TCurrencyEdit
          Tag = 1
          Left = 220
          Top = 83
          Width = 31
          Height = 22
          HelpContext = 1237
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Lines.Strings = (
            '0 ')
          MaxLength = 3
          ParentFont = False
          ReadOnly = True
          TabOrder = 6
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
        object FullNameF: Text8Pt
          Tag = 1
          Left = 77
          Top = 33
          Width = 211
          Height = 22
          HelpContext = 1235
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          MaxLength = 50
          ParentFont = False
          ParentShowHint = False
          ReadOnly = True
          ShowHint = True
          TabOrder = 2
          TextId = 0
          ViaSBtn = False
        end
        object PWEmlF: Text8Pt
          Tag = 1
          Left = 13
          Top = 126
          Width = 420
          Height = 22
          HelpContext = 1238
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ReadOnly = True
          ShowHint = True
          TabOrder = 7
          TextId = 0
          ViaSBtn = False
        end
        object TBorCh_ShowGLCode: TBorCheck
          Tag = 1
          Left = 55
          Top = 399
          Width = 104
          Height = 20
          HelpContext = 40177
          Caption = 'Show G/L Code :'
          CheckColor = clWindowText
          Color = clBtnFace
          Enabled = False
          ParentColor = False
          TabOrder = 19
          TabStop = True
          TextId = 0
        end
        object TBorCh_ShowStockCode: TBorCheck
          Tag = 1
          Left = 189
          Top = 399
          Width = 110
          Height = 20
          HelpContext = 40178
          Caption = 'Show Stock Code :'
          CheckColor = clWindowText
          Color = clBtnFace
          Enabled = False
          ParentColor = False
          TabOrder = 20
          TabStop = True
          TextId = 0
          Visible = False
        end
        object TBorCh_ShowProductType: TBorCheck
          Tag = 1
          Left = 309
          Top = 399
          Width = 120
          Height = 20
          HelpContext = 40179
          Caption = 'Show Product Type :'
          CheckColor = clWindowText
          Color = clBtnFace
          Enabled = False
          ParentColor = False
          TabOrder = 21
          TabStop = True
          TextId = 0
          Visible = False
        end
      end
    end
    object AccessPage: TTabSheet
      Caption = 'Access Settings'
      ImageIndex = 1
      object D2SBox: TScrollBox
        Left = 6
        Top = 5
        Width = 539
        Height = 484
        HelpContext = 392
        HorzScrollBar.Visible = False
        VertScrollBar.Visible = False
        TabOrder = 0
        object NLOLine: TSBSOutlineB
          Left = 0
          Top = 59
          Width = 535
          Height = 401
          OnExpand = NLOLineExpand
          Options = []
          ItemHeight = 18
          ItemSpace = 10
          Align = alClient
          BarColor = clHighlight
          BarTextColor = clHighlightText
          HLBarColor = clBlack
          HLBarTextColor = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Color = clWhite
          TabOrder = 0
          ItemSeparator = '\'
          PicturePlus.Data = {
            36050000424D3605000000000000360400002800000010000000100000000100
            080000000000000100001F2E00001F2E00000001000000000000A5570D00AA61
            1A00B06A2700B06A2800BF854D00C0864E00C0885100CB9A6B00D7AB6A00CFA2
            7500FF00FF00D6AE8800DAB58F00DBB69200DBB89600E1C3A700E4C5A500E4C6
            A500EBD4BB00ECD6BF00F2D7B000F3DAB600F3DDBC00F3DFC700F1DFCD00F4E0
            C200F5E0C300F5E2C700F6E3C800F4E2CB00F6E5CD00F6E5CE00F7E6CE00F8E8
            D300F8E8D400F7E9DA00F9EAD800F9EBD900FAEDDD00FAEEDE00FBF0E200FBF1
            E400FCF3E700FCF3E800FCF5EC00FCF6ED00FCF6EE00FDF8F100FDF8F200FDFA
            F600FEFAF600FEFCF900FEFCFA00FFFEFD00FFFEFE00FFFFFF00000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            00000000000000000000000000000000000000000000000000000A0A0A0A0A0A
            0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A080808
            080808080808080A0A0A0A0A08282624211E1B19161514080A0A0A0A082A2826
            10171E1B191615080A0A0A0A082C2A0D0004211E1C1916080A0A0A0A082F2C06
            010011211F1C1A080A0A0A0A08312F0F0B07021D221F1C080A0A0A0A0833312F
            2D230305252220080A0A0A0A083534312F2D1300092522080A0A0A0A08373534
            312F2D0E000C25080A0A0A0A083737363431302D181227080A0A0A0A08373737
            363432302E2B29080A0A0A0A0A080808080808080808080A0A0A0A0A0A0A0A0A
            0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A}
          PictureMinus.Data = {
            36050000424D3605000000000000360400002800000010000000100000000100
            080000000000000100001F2E00001F2E00000001000000000000D7AB6A00FF00
            FF00F2D7B000F3DAB600F3DDBC00F4E0C200F5E0C300F5E2C700F6E3C800F6E5
            CD00F6E5CE00F7E6CE00F8E8D300F8E8D400F9EAD800F9EBD800F9EBD900FAED
            DD00FAEEDE00FBF0E200FBF0E300FBF1E300FBF1E400FCF3E700FCF3E800FCF5
            EC00FCF5ED00FCF6ED00FCF6EE00FDF8F100FDF8F200FDFAF600FEFAF600FEFC
            F900FEFCFA00FFFEFD00FFFEFE00FFFFFF000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000010101010101
            0101010101010101010101010101010101010101010101010101010101000000
            0000000000000001010101010013110E0C090705040302000101010100171311
            0E0C0907050403000101010100191713110E0C090805040001010101001D1917
            14110F0C0A08060001010101001F1D1A1814110F0D0A08000101010100211F1D
            1B181411100D0B00010101010023221F1D1B181412100D000101010100252322
            1F1D1B18151210000101010100252524221F1E1B181512000101010100252525
            2422201E1C181600010101010100000000000000000000010101010101010101
            0101010101010101010101010101010101010101010101010101}
          PictureOpen.Data = {
            36030000424D3603000000000000360000002800000010000000100000000100
            18000000000000030000202E0000202E00000000000000000000FF00FFFF00FF
            FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
            FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
            00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
            FF00FF7473767473767473767473767473767473767473767473767473767473
            76747376747376747376FF00FFFF00FF1382D71382D71382D71382D71382D713
            82D71382D71382D71382D71382D71382D71382D71382D7747376FF00FF1382D7
            1382D737C8FD2ABFFC19B3FB1AAEFA1BAAFA1BAAFA1AACFA1AB1FB18B6FC17BD
            FD1382D71382D7747376FF00FF1382D750D0FE52CBFD53C5FC4DBDFB32ADF91D
            A0F81DA0F81CA4F91BABFA19B2FB17BAFC1382D71382D77473761382D71382D7
            51CEFE52C8FC53C1FB55BBFB56B5F949ABF8269DF71DA1F81BA9FA19B1FB18BA
            FC1382D71382D77473761382D752C8FD51CDFE53C6FC54C0FB55BAFB56B5FA57
            B3F956B6FA44B4FA30B3FA24B7FB1382D71382D71382D77473761382D750D0FE
            51CEFE52C8FC53C3FB54BEFB55BBFB55BAFB55BCFB54C0FB53C5FC52CBFD1382
            D750D0FE1382D77473761382D750D0FE50CFFE51CCFD52C7FC53C4FC53C2FB53
            C2FB53C4FC52C7FC51CCFD50CFFE1382D750D0FE1382D77473761382D71382D7
            1382D71382D71382D71382D71382D71382D71382D71382D71382D71382D71382
            D744BEFB1382D7747376FF00FFFF00FF1382D750D0FE50CEFE51CAFD53C6FC53
            C3FC53C2FC53C2FC53C5FC52C9FD50CDFE50D0FE1382D7747376FF00FFFF00FF
            1382D73AA9F93AA9F93AA8F83AA7F81382D71382D71382D71382D71382D71382
            D71382D71382D7FF00FFFF00FFFF00FF1382D71382D71382D71382D71382D713
            82D7E312FEFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
            FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
            FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
            00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
          PictureClosed.Data = {
            36030000424D3603000000000000360000002800000010000000100000000100
            18000000000000030000202E0000202E00000000000000000000FF00FFFF00FF
            FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
            FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
            00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
            FF00FF7473767473767473767473767473767473767473767473767473767473
            76747376747376FF00FFFF00FFFF00FF1382D71382D71382D71382D71382D713
            82D71382D71382D71382D71382D71382D71382D7747376FF00FFFF00FF1382D7
            1DC2FD16BFFD17BAFC19B5FB19B2FB1AB0FB1AB1FB19B4FB18B9FC16BEFD16C0
            FD1382D7747376FF00FFFF00FF1382D750D0FE4ACAFD36BEFC1EAFFA1BAAF91C
            A8F91BA9F91AADFA19B2FB18BAFC16C0FD1382D7747376FF00FFFF00FF1382D7
            50CFFE52CAFD53C4FB51BDFB2FAAF91E9FF81DA1F81CA6F91AAEFA18B6FB16BD
            FD1382D7747376FF00FFFF00FF1382D750CEFE52C8FD53C1FB55BBFB56B5FA42
            A8F8229DF71DA2F81BAAFA19B3FB17BBFD1382D7747376FF00FFFF00FF1382D7
            50CEFE52C7FD53C1FB55BBFB56B5FA57B1F953B2F939ADF922ADFA19B2FB17BB
            FD1382D7747376FF00FFFF00FF1382D750CEFE52C9FD53C2FC54BDFB56B8FA56
            B6FA56B7FA55BBFB53C1FB47C3FC3BC7FD1382D7747376FF00FFFF00FF1382D7
            50CFFE51CBFD53C6FC53C1FB54BDFB55BCFB54BDFB53C0FB53C4FC51CAFD50CF
            FE1382D7747376FF00FFFF00FF1382D750D0FE50CEFE51CAFD53C6FC53C3FC53
            C2FC53C2FC53C5FC52C9FD50CDFE50D0FE1382D7747376FF00FFFF00FF1382D7
            3AA9F93AA9F93AA8F83AA7F81382D71382D71382D71382D71382D71382D71382
            D71382D7FF00FFFF00FFFF00FFFF00FF1382D71382D71382D71382D71382D7FF
            00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
            FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
            FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
            00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
          PictureLeaf.Data = {
            36050000424D3605000000000000360400002800000010000000100000000100
            080000000000000100001F2E00001F2E00000001000000000000444444004545
            45004D4D4D005050500053535300545454005C5C5C005F5F5F00636363006464
            6400686868006B6B6B006C6C6C007473760075757500767676007D7D7D00FF00
            FF008181810083838300848484008B8B8B008C8C8C008E8E8E00929292009595
            9500979797009A9A9A009B9B9B009D9D9D00A0A0A000A1A1A100A4A4A400A6A6
            A600A8A8A800ABABAB00ACACAC00B0B0B000B1B1B100B6B6B600B8B8B800BBBB
            BB00C0C0C000C8C8C800D1D1D100DADADA00E1E1E100E5E5E500ECECEC00F0F0
            F000FDFDFD00FFFFFF0000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000110D0D0D0D0D
            0D0D0D0D0D0D0D0D0D110D33333333333333333333333333330D0D3333333312
            2833333333333333330D0D3333332C17160B172B33333333330D0D3333331813
            1C1B1E180E1A2A33330D0D333333101B1914191D24252333330D0D33332E0F1E
            202503231D212D33330D0D33331019211E03171F22263333330D0D3333081821
            2123252026203333330D0D33332F0129151828211B303333330D0D3333190733
            332E0A1827333333330D0D33332106313333052532333333330D0D3333330C00
            0203063333333333330D0D33333333250904303333333333330D0D3333333333
            3333333333333333330D110D0D0D0D0D0D0D0D0D0D0D0D0D0D11}
          PictureLeaf2.Data = {
            36050000424D3605000000000000360400002800000010000000100000000100
            080000000000000100001F2E00001F2E000000010000000000003E3E3E004B4B
            4B004C4C4C00505050005353530054545400636363006B6B6B006D6D6D007473
            7600767676007E7E7E00FF00FF00838383008484840087878700888888008B8B
            8B008E8E8E009292920095959500979797009A9A9A009B9B9B009D9D9D00A0A0
            A000A1A1A100A4A4A400A6A6A600A8A8A800ABABAB00ACACAC00B1B1B100B4B4
            B400B6B6B600B8B8B800BBBBBB00C7C7C700C8C8C800CCCCCC00CECECE00D3D3
            D300DEDEDE00E5E5E500F4F4F400F9F9F900FFFFFF0000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            00000000000000000000000000000000000000000000000000000C0909090909
            0909090909090909090C092E2E2E2E2E2E2E2E2E2E2E2E2E2E09092E2E2E180A
            0B1C2A2E2E2E2E2E2E09092E2E2E0D0E14150B0721292E2E2E09092E2E2C0F10
            131D1C20131A2E2E2E09092E2E1A1214191C041F201B2E2E2E09092E2E0A151B
            1E03211C22272E2E2E09092E2E07191C181E1B1E1B2E2E2E2E09092E2E271215
            1D1D1E1B162E2E2E2E09092E2E2E2E2E28171119262E2E2E2E09092E2E2E2E2E
            2E12062E2E2E2E2E2E09092E2E2E2E2E2E080F2E2E2E00232E09092E2E2E2E2E
            2E25050B2B0B022D2E09092E2E2E2E2E2E2E240B01051F2E2E09092E2E2E2E2E
            2E2E2E2E2E2E2E2E2E090C09090909090909090909090909090C}
          ParentFont = False
          ScrollBars = ssVertical
          ShowValCol = 1
          OnUpdateNode = NLOLineUpdateNode
          OnNodeChkHotSpot = NLOLineNodeChkHotSpot
          TreeColor = clNavy
          Data = {3F00}
        end
        object AdvDockPanel1: TAdvDockPanel
          Left = 0
          Top = 0
          Width = 535
          Height = 59
          MinimumSize = 3
          LockHeight = False
          Persistence.Location = plRegistry
          Persistence.Enabled = False
          ToolBarStyler = AdvToolBarOfficeStyler1
          UseRunTimeHeight = False
          Version = '2.9.0.0'
          object AdvToolBar1: TAdvToolBar
            Left = 3
            Top = 1
            Width = 529
            Height = 44
            AllowFloating = True
            CaptionFont.Charset = DEFAULT_CHARSET
            CaptionFont.Color = clWindowText
            CaptionFont.Height = -11
            CaptionFont.Name = 'MS Sans Serif'
            CaptionFont.Style = []
            CompactImageIndex = -1
            ShowRightHandle = False
            ShowClose = False
            ShowOptionIndicator = False
            FullSize = True
            TextAutoOptionMenu = 'Add or Remove Buttons'
            TextOptionMenu = 'Options'
            ToolBarStyler = AdvToolBarOfficeStyler1
            ParentOptionPicture = True
            ToolBarIndex = -1
            object AdvToolBarSeparator1: TAdvToolBarSeparator
              Left = 82
              Top = 2
              Width = 10
              Height = 40
              LineColor = clBtnShadow
            end
            object Label84: Label8
              Left = 92
              Top = 2
              Width = 291
              Height = 38
              AutoSize = False
              Caption = 'Access Settings for : '
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -13
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
              Layout = tlCenter
              TextId = 0
            end
            object FullExBtn: TAdvGlowButton
              Left = 2
              Top = 2
              Width = 40
              Height = 40
              FocusType = ftHot
              Picture.Data = {
                89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
                F40000024D4944415458C3ED554D4F1351143DAFD32160491735A535468DAD0B
                3E0CB04237EAC40A62DC109AAE49E3C618E20F006DCA7FE00F3476035121240D
                35152DA0623421F8917601F603BF9044DA149A5A3AD3E7A2A64C07C7DAF8C6C6
                C8D94C72DF7D73CFBBE7BD738103FCEF20CAC085C1400C142735AA179B9FBA6A
                970774FB52B42B0E00366540576F09F4CA8073A84BD382F3535508B4755AFE6A
                07EA2EC101017DB58417EF32180F7D545DEFB11931DC77543B02A7AC4D18EE55
                2F606AE6B5ED80C9C0A3C7CED74F0225D6BEE4107CB5A5BA6EB736E14AA7E9DF
                B984FB86512856A05A16ECB5F1842981AD6C016B1BB9BD576137626367152F3F
                CC20995E81582C00002CCD769CB6389079B0C479BDDE223302F267EABBDE8AC5
                841F4BEB93A050FDCD131071606E68EE2B73099EAD4F602171676FAE985BD162
                3097865062513EF39F37643861F6E66C5ECF4ADBCFDBAB5848FA2B62AE0E27CE
                9F38F78340BF5CF9B379A3740BC06D664EB8FC2900505AC3ED273784C7C21833
                274CA65F97DBEEEA700200DACD6DE53C8F300A00886C467137721F004CFC7BBE
                9B9913EEEC96CCA9C5602EB75D8E8A58A4F49124728499113572876ADEC3715C
                86D92B9878E3413CB55C11F308A3E5935FF2F52BB7EC4A346F61D6812E6B5FAD
                167C2FEC0EA7F5D5ACF2B741412E462F8708E0284BBD19552B9E122919F9A911
                FD091C3EC76152D40728C1995F9C3C054A061FBA836100E05812884FC773C707
                8EF939F01208BA0134CA96454A302D51E27CE40EAEA8CE0256704DBAB85436DB
                0E9D64A120D96F62C3DBA7D766B69579DF01872AC9F8B2F38F7A000000004945
                4E44AE426082}
              Position = bpLeft
              ShowDisabled = False
              TabOrder = 0
              OnClick = FullExBtnClick
              Appearance.BorderColor = clBtnFace
              Appearance.BorderColorHot = clHighlight
              Appearance.BorderColorDown = clHighlight
              Appearance.BorderColorChecked = clBlack
              Appearance.Color = clBtnFace
              Appearance.ColorTo = clBtnFace
              Appearance.ColorChecked = 12179676
              Appearance.ColorCheckedTo = 12179676
              Appearance.ColorDisabled = 15921906
              Appearance.ColorDisabledTo = 15921906
              Appearance.ColorDown = 11899524
              Appearance.ColorDownTo = 11899524
              Appearance.ColorHot = 15717318
              Appearance.ColorHotTo = 15717318
              Appearance.ColorMirror = clBtnFace
              Appearance.ColorMirrorTo = clBtnFace
              Appearance.ColorMirrorHot = 15717318
              Appearance.ColorMirrorHotTo = 15717318
              Appearance.ColorMirrorDown = 11899524
              Appearance.ColorMirrorDownTo = 11899524
              Appearance.ColorMirrorChecked = 12179676
              Appearance.ColorMirrorCheckedTo = 12179676
              Appearance.ColorMirrorDisabled = 11974326
              Appearance.ColorMirrorDisabledTo = 15921906
              Appearance.GradientHot = ggVertical
              Appearance.GradientMirrorHot = ggVertical
              Appearance.GradientDown = ggVertical
              Appearance.GradientMirrorDown = ggVertical
              Appearance.GradientChecked = ggVertical
            end
            object FullColBtn: TAdvGlowButton
              Left = 42
              Top = 2
              Width = 40
              Height = 40
              FocusType = ftHot
              Picture.Data = {
                89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
                F4000002014944415458C3ED554D4B1B51143D77924127A3410362C48834294A
                BB507111152C06C542B12B450A5DD47D71E72F107F81A53B2994EE4D74111162
                70820A318552C18F2E3464614B5BD058ED24928C795D0856271D92D037063177
                F7CEBD8F7339E7BEFB804ADCF7203D30301A8C83E181497CF14860C4731D10F2
                4ACC230700B71E10CA6D81550F8C4D749A4A18091468E05147E3AD2A50760B2A
                0D580B15C40E4EF136F4D530EF75DB31F9B4D9BC061E3A254C0E1B13386A4473
                1570C822BC1EB17C16E863FF471ACB5BC786798F53C2B30EC7DD19C2BCCF2814
                CF32330987DD22FD9705FA3856B3D8FF9ECEC35F2AB3A8DBFB08D2320000B5A5
                0DBB536FF82BA07FA6ABCE35B8963E008C1949BE2E87634F4CB1C0157C8F9685
                B982750C88D686637D5C87B026B107D7E2BB6207AFF76CB06786EB2674AEFA41
                2C57FCF4137BCD7CBE696E9BD0FEE5D3152607234055F53FEBD3AFC690FB7608
                008E9498EAE2B609C55F47A5FB76C19AB8CD404E924BBF63C1A9955703BF5BDB
                51B7B379F9E647068AB992D1B2D92D6E0AFCEC7F5EEA0E9EAF573E9F10AF0618
                40EAA03704C2100090CD06964AFDE5BB7E26242D9AD02D29D1043705086039C2
                0B103601DC20BF712624198451498926B8FF86F670EC48D66C3E46980670A24B
                6BC4C86FD184EEDA95A862B88AB959323E6E5193878F01AD5160A4AAE7E276C3
                C6C699BEEE0FE615ABCB2648E3690000000049454E44AE426082}
              Position = bpRight
              ShowDisabled = False
              TabOrder = 1
              OnClick = FullColBtnClick
              Appearance.BorderColor = clBtnFace
              Appearance.BorderColorHot = clHighlight
              Appearance.BorderColorDown = clHighlight
              Appearance.BorderColorChecked = clBlack
              Appearance.Color = clBtnFace
              Appearance.ColorTo = clBtnFace
              Appearance.ColorChecked = 12179676
              Appearance.ColorCheckedTo = 12179676
              Appearance.ColorDisabled = 15921906
              Appearance.ColorDisabledTo = 15921906
              Appearance.ColorDown = 11899524
              Appearance.ColorDownTo = 11899524
              Appearance.ColorHot = 15717318
              Appearance.ColorHotTo = 15717318
              Appearance.ColorMirror = clBtnFace
              Appearance.ColorMirrorTo = clBtnFace
              Appearance.ColorMirrorHot = 15717318
              Appearance.ColorMirrorHotTo = 15717318
              Appearance.ColorMirrorDown = 11899524
              Appearance.ColorMirrorDownTo = 11899524
              Appearance.ColorMirrorChecked = 12179676
              Appearance.ColorMirrorCheckedTo = 12179676
              Appearance.ColorMirrorDisabled = 11974326
              Appearance.ColorMirrorDisabledTo = 15921906
              Appearance.GradientHot = ggVertical
              Appearance.GradientMirrorHot = ggVertical
              Appearance.GradientDown = ggVertical
              Appearance.GradientMirrorDown = ggVertical
              Appearance.GradientChecked = ggVertical
            end
          end
        end
        object Panel1: TPanel
          Left = 0
          Top = 460
          Width = 535
          Height = 20
          Align = alBottom
          BevelOuter = bvNone
          TabOrder = 2
          object Image5: TImage
            Left = 5
            Top = 2
            Width = 16
            Height = 16
            AutoSize = True
            Picture.Data = {
              07544269746D617036050000424D360500000000000036040000280000001000
              0000100000000100080000000000000100001F2E00001F2E0000000100000000
              0000A5570D00AA611A00B06A2700B06A2800BF854D00C0864E00C0885100CB9A
              6B00D7AB6A00CFA27500FF00FF00D6AE8800DAB58F00DBB69200DBB89600E1C3
              A700E4C5A500E4C6A500EBD4BB00ECD6BF00F2D7B000F3DAB600F3DDBC00F3DF
              C700F1DFCD00F4E0C200F5E0C300F5E2C700F6E3C800F4E2CB00F6E5CD00F6E5
              CE00F7E6CE00F8E8D300F8E8D400F7E9DA00F9EAD800F9EBD900FAEDDD00FAEE
              DE00FBF0E200FBF1E400FCF3E700FCF3E800FCF5EC00FCF6ED00FCF6EE00FDF8
              F100FDF8F200FDFAF600FEFAF600FEFCF900FEFCFA00FFFEFD00FFFEFE00FFFF
              FF00000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              00000A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A
              0A0A0A0A0A080808080808080808080A0A0A0A0A08282624211E1B1916151408
              0A0A0A0A082A282610171E1B191615080A0A0A0A082C2A0D0004211E1C191608
              0A0A0A0A082F2C06010011211F1C1A080A0A0A0A08312F0F0B07021D221F1C08
              0A0A0A0A0833312F2D230305252220080A0A0A0A083534312F2D130009252208
              0A0A0A0A08373534312F2D0E000C25080A0A0A0A083737363431302D18122708
              0A0A0A0A08373737363432302E2B29080A0A0A0A0A080808080808080808080A
              0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A
              0A0A}
            Transparent = True
          end
          object Label826: Label8
            Left = 25
            Top = 4
            Width = 102
            Height = 14
            Caption = 'Tick to allow access.'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TextId = 0
          end
        end
      end
    end
    object SigPage: TTabSheet
      Caption = 'Signatures'
      ImageIndex = 2
      object Label815: Label8
        Left = 4
        Top = 7
        Width = 86
        Height = 22
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Email Signature:-'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label816: Label8
        Left = 1
        Top = 243
        Width = 81
        Height = 22
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Fax Signature:-'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object emailUserLab: Label8
        Left = 95
        Top = 7
        Width = 309
        Height = 22
        AutoSize = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold, fsItalic]
        ParentFont = False
        TextId = 0
      end
      object FaxUserLab: Label8
        Left = 85
        Top = 198
        Width = 309
        Height = 22
        AutoSize = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold, fsItalic]
        ParentFont = False
        TextId = 0
      end
      object memEmailSig: TMemo
        Left = 2
        Top = 27
        Width = 543
        Height = 208
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          'Mark Higginson'
          'Email: mhigginson@exchequer.com http://www.exchequer.com'
          
            'Exchequer Software Ltd, Exchequer Grange, Wootton Gardens, Bourn' +
            'emouth, '
          'BH1 '
          '1PW, UK.'
          
            'Tel: +44 (0)1202 298008 Helpline: +44 (0)1202 292299 Fax: +44 (0' +
            ')1202 298001'
          '')
        ParentFont = False
        ReadOnly = True
        TabOrder = 0
      end
      object memFaxSig: TMemo
        Left = 1
        Top = 263
        Width = 544
        Height = 226
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          'Memo1')
        ParentFont = False
        ReadOnly = True
        TabOrder = 1
      end
    end
  end
  object PBtnPanel: TSBSPanel
    Left = 562
    Top = 27
    Width = 102
    Height = 493
    BevelOuter = bvNone
    TabOrder = 1
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
    object P1BSBox: TScrollBox
      Left = 0
      Top = 83
      Width = 99
      Height = 270
      HorzScrollBar.Visible = False
      BorderStyle = bsNone
      Color = clBtnFace
      ParentColor = False
      TabOrder = 3
      object AddBtn: TButton
        Tag = 1
        Left = 2
        Top = 1
        Width = 80
        Height = 21
        Hint = 
          'Setup a New User|Creates a new user record and password, setting' +
          ' all password options to '#39'No'#39'.'
        HelpContext = 393
        Caption = '&Add User'
        TabOrder = 0
        OnClick = AddBtnClick
      end
      object EditBtn: TButton
        Tag = 2
        Left = 2
        Top = 25
        Width = 80
        Height = 21
        Hint = 
          'Edit a user record|Allows the settings for the currently highlig' +
          'hted user to be changed.'
        HelpContext = 397
        Caption = '&Edit'
        TabOrder = 1
        OnClick = AddBtnClick
      end
      object DelBtn: TButton
        Tag = 3
        Left = 2
        Top = 49
        Width = 80
        Height = 21
        Hint = 'Delete User|Deletes the currently highlighted user.'
        HelpContext = 396
        Caption = '&Delete'
        TabOrder = 2
        OnClick = AddBtnClick
      end
      object CopyBtn: TButton
        Tag = 5
        Left = 2
        Top = 73
        Width = 80
        Height = 21
        Hint = 
          'Copy current record into a new User|Copies the currently highlig' +
          'hted user details into a new user record.'
        HelpContext = 395
        Caption = 'Cop&y'
        TabOrder = 3
        OnClick = AddBtnClick
      end
      object InterBtn: TButton
        Tag = 5
        Left = 2
        Top = 97
        Width = 80
        Height = 21
        Hint = 
          'Simulate the settings of another User|Apply the settings of the ' +
          'currently highlighted user to the live system.'
        HelpContext = 398
        Caption = '&Interactive'
        TabOrder = 4
        OnClick = InterBtnClick
      end
      object ResetCBtn: TButton
        Tag = 6
        Left = 2
        Top = 121
        Width = 80
        Height = 21
        Hint = 
          'Reset all custom settings|Resets all custom colours and position' +
          's for the currently highlighted user.'
        HelpContext = 1245
        Caption = '&Reset Custom'
        TabOrder = 5
        OnClick = AddBtnClick
      end
      object FindBtn: TButton
        Tag = 6
        Left = 2
        Top = 145
        Width = 80
        Height = 21
        Hint = 
          'Find Password option|Searches the password tree to find a passwo' +
          'rd'
        Caption = '&Find'
        TabOrder = 6
        OnClick = SN1Click
      end
      object SetYesBtn: TButton
        Tag = 6
        Left = 2
        Top = 217
        Width = 80
        Height = 21
        Hint = 
          'Set current level to Yes|Sets the currently highlighted level an' +
          'd all its sub levels to Yes'
        Caption = 'Set Level &Yes'
        TabOrder = 9
        OnClick = BN2Click
      end
      object SetNoBtn: TButton
        Tag = 6
        Left = 2
        Top = 241
        Width = 80
        Height = 21
        Hint = 
          'Set current level to No|Sets the currently highlighted level and' +
          ' all its sub levels to No'
        Caption = 'Set Level &No'
        TabOrder = 10
        OnClick = BN2Click
      end
      object btnExpand: TButton
        Tag = 1
        Left = 2
        Top = 169
        Width = 80
        Height = 21
        Hint = 
          'Expand current level |Expands the currently highlighted level an' +
          'd all its sub levels'
        Caption = '&Expand level'
        TabOrder = 7
        OnClick = Collapse1Click
      end
      object btnCollapse: TButton
        Left = 2
        Top = 193
        Width = 80
        Height = 21
        Hint = 
          'Collapse current level |Collapses the currently highlighted leve' +
          'l and all its sub levels'
        Caption = '&Collapse Level'
        TabOrder = 8
        OnClick = Collapse1Click
      end
      object PrintBtn: TButton
        Tag = 6
        Left = 2
        Top = 265
        Width = 80
        Height = 21
        Hint = 
          'PrintPassword options|Prints the password settings for the curre' +
          'ntly highlighted user.'
        HelpContext = 1246
        Caption = '&Print'
        TabOrder = 11
        OnClick = PrintBtnClick
      end
    end
    object Clsd1Btn: TButton
      Left = 2
      Top = 50
      Width = 80
      Height = 21
      HelpContext = 24
      Cancel = True
      Caption = 'C&lose'
      ModalResult = 2
      TabOrder = 2
      OnClick = Clsd1BtnClick
    end
    object OkCP1Btn: TButton
      Tag = 1
      Left = 2
      Top = 4
      Width = 80
      Height = 21
      HelpContext = 257
      Caption = '&OK'
      Enabled = False
      ModalResult = 1
      TabOrder = 0
      OnClick = CanCP1BtnClick
    end
    object CanCP1Btn: TButton
      Tag = 1
      Left = 2
      Top = 26
      Width = 80
      Height = 21
      HelpContext = 258
      Cancel = True
      Caption = '&Cancel'
      Enabled = False
      ModalResult = 2
      TabOrder = 1
      OnClick = CanCP1BtnClick
    end
  end
  object PopupMenu1: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 492
    Top = 3
    object Add1: TMenuItem
      Tag = 1
      Caption = '&Add User'
      OnClick = AddBtnClick
    end
    object Edit1: TMenuItem
      Tag = 2
      Caption = '&Edit'
      OnClick = AddBtnClick
    end
    object Delete1: TMenuItem
      Tag = 3
      Caption = '&Delete'
      OnClick = AddBtnClick
    end
    object Copy1: TMenuItem
      Tag = 5
      Caption = 'Cop&y'
      OnClick = AddBtnClick
    end
    object Interactive1: TMenuItem
      Caption = '&Interactive'
      HelpContext = 398
      Hint = 
        'Apply the settings of the currently highlighted user to the live' +
        ' system.'
      OnClick = InterBtnClick
    end
    object ResetCustom1: TMenuItem
      Tag = 6
      Caption = '&Reset Custom'
      Hint = 
        'Resets all custom colours and positions for the currently highli' +
        'ghted user.'
      OnClick = AddBtnClick
    end
    object Find1: TMenuItem
      Caption = '&Find'
      OnClick = SN1Click
    end
    object ExpandLevel1: TMenuItem
      Tag = 1
      Caption = '&Expand Level'
      OnClick = Collapse1Click
    end
    object CollapseLevel1: TMenuItem
      Caption = '&Collapse Level'
      OnClick = Collapse1Click
    end
    object BN1: TMenuItem
      Caption = 'Set Level &Yes'
      OnClick = BN2Click
    end
    object DN1: TMenuItem
      Caption = 'SetLevel &No'
      OnClick = BN2Click
    end
    object Print1: TMenuItem
      Caption = '&Print'
      OnClick = PrintBtnClick
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object PropFlg: TMenuItem
      Caption = '&Properties'
      HelpContext = 65
      Hint = 'Access Colour & Font settings'
      OnClick = PropFlgClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object StoreCoordFlg: TMenuItem
      Caption = '&Save Coordinates'
      HelpContext = 177
      Hint = 'Make the current window settings permanent'
      OnClick = StoreCoordFlgClick
    end
  end
  object AdvToolBarOfficeStyler1: TAdvToolBarOfficeStyler
    Style = bsCustom
    BorderColorHot = clHighlight
    ButtonAppearance.Color = clBtnFace
    ButtonAppearance.ColorTo = clBtnFace
    ButtonAppearance.ColorChecked = clBtnFace
    ButtonAppearance.ColorCheckedTo = 5812223
    ButtonAppearance.ColorDown = 11899524
    ButtonAppearance.ColorDownTo = 9556991
    ButtonAppearance.ColorHot = 15717318
    ButtonAppearance.ColorHotTo = 9556223
    ButtonAppearance.BorderDownColor = clNavy
    ButtonAppearance.BorderHotColor = clNavy
    ButtonAppearance.BorderCheckedColor = clNavy
    ButtonAppearance.CaptionFont.Charset = DEFAULT_CHARSET
    ButtonAppearance.CaptionFont.Color = clWindowText
    ButtonAppearance.CaptionFont.Height = -11
    ButtonAppearance.CaptionFont.Name = 'Segoe UI'
    ButtonAppearance.CaptionFont.Style = []
    CaptionAppearance.CaptionColor = clHighlight
    CaptionAppearance.CaptionColorTo = clHighlight
    CaptionAppearance.CaptionBorderColor = clHighlight
    CaptionAppearance.CaptionColorHot = clHighlight
    CaptionAppearance.CaptionColorHotTo = clHighlight
    CaptionAppearance.CaptionTextColorHot = clBlack
    CaptionFont.Charset = DEFAULT_CHARSET
    CaptionFont.Color = clWindowText
    CaptionFont.Height = -11
    CaptionFont.Name = 'Segoe UI'
    CaptionFont.Style = []
    ContainerAppearance.LineColor = clBtnShadow
    ContainerAppearance.Line3D = True
    Color.Color = clBtnFace
    Color.ColorTo = clBtnFace
    Color.Direction = gdVertical
    ColorHot.Color = 15717318
    ColorHot.ColorTo = 15717318
    ColorHot.Direction = gdVertical
    CompactGlowButtonAppearance.BorderColor = 12179676
    CompactGlowButtonAppearance.BorderColorHot = clHighlight
    CompactGlowButtonAppearance.BorderColorDown = clHighlight
    CompactGlowButtonAppearance.BorderColorChecked = clBlack
    CompactGlowButtonAppearance.Color = 15653832
    CompactGlowButtonAppearance.ColorTo = 12179676
    CompactGlowButtonAppearance.ColorChecked = 12179676
    CompactGlowButtonAppearance.ColorCheckedTo = 12179676
    CompactGlowButtonAppearance.ColorDisabled = 15921906
    CompactGlowButtonAppearance.ColorDisabledTo = 15921906
    CompactGlowButtonAppearance.ColorDown = 11899524
    CompactGlowButtonAppearance.ColorDownTo = 11899524
    CompactGlowButtonAppearance.ColorHot = 15717318
    CompactGlowButtonAppearance.ColorHotTo = 15717318
    CompactGlowButtonAppearance.ColorMirror = 12179676
    CompactGlowButtonAppearance.ColorMirrorTo = 12179676
    CompactGlowButtonAppearance.ColorMirrorHot = 15717318
    CompactGlowButtonAppearance.ColorMirrorHotTo = 15717318
    CompactGlowButtonAppearance.ColorMirrorDown = 11899524
    CompactGlowButtonAppearance.ColorMirrorDownTo = 11899524
    CompactGlowButtonAppearance.ColorMirrorChecked = 12179676
    CompactGlowButtonAppearance.ColorMirrorCheckedTo = 12179676
    CompactGlowButtonAppearance.ColorMirrorDisabled = 11974326
    CompactGlowButtonAppearance.ColorMirrorDisabledTo = 15921906
    CompactGlowButtonAppearance.GradientHot = ggVertical
    CompactGlowButtonAppearance.GradientMirrorHot = ggVertical
    CompactGlowButtonAppearance.GradientDown = ggVertical
    CompactGlowButtonAppearance.GradientMirrorDown = ggVertical
    CompactGlowButtonAppearance.GradientChecked = ggVertical
    DockColor.Color = clBtnFace
    DockColor.ColorTo = clBtnFace
    DockColor.Direction = gdHorizontal
    DockColor.Steps = 128
    DragGripStyle = dsNone
    FloatingWindowBorderColor = clHighlight
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Segoe UI'
    Font.Style = []
    GlowButtonAppearance.BorderColor = clBtnFace
    GlowButtonAppearance.BorderColorHot = clHighlight
    GlowButtonAppearance.BorderColorDown = clHighlight
    GlowButtonAppearance.BorderColorChecked = clBlack
    GlowButtonAppearance.Color = clBtnFace
    GlowButtonAppearance.ColorTo = clBtnFace
    GlowButtonAppearance.ColorChecked = 12179676
    GlowButtonAppearance.ColorCheckedTo = 12179676
    GlowButtonAppearance.ColorDisabled = 15921906
    GlowButtonAppearance.ColorDisabledTo = 15921906
    GlowButtonAppearance.ColorDown = 11899524
    GlowButtonAppearance.ColorDownTo = 11899524
    GlowButtonAppearance.ColorHot = 15717318
    GlowButtonAppearance.ColorHotTo = 15717318
    GlowButtonAppearance.ColorMirror = clBtnFace
    GlowButtonAppearance.ColorMirrorTo = clBtnFace
    GlowButtonAppearance.ColorMirrorHot = 15717318
    GlowButtonAppearance.ColorMirrorHotTo = 15717318
    GlowButtonAppearance.ColorMirrorDown = 11899524
    GlowButtonAppearance.ColorMirrorDownTo = 11899524
    GlowButtonAppearance.ColorMirrorChecked = 12179676
    GlowButtonAppearance.ColorMirrorCheckedTo = 12179676
    GlowButtonAppearance.ColorMirrorDisabled = 11974326
    GlowButtonAppearance.ColorMirrorDisabledTo = 15921906
    GlowButtonAppearance.GradientHot = ggVertical
    GlowButtonAppearance.GradientMirrorHot = ggVertical
    GlowButtonAppearance.GradientDown = ggVertical
    GlowButtonAppearance.GradientMirrorDown = ggVertical
    GlowButtonAppearance.GradientChecked = ggVertical
    GroupAppearance.BorderColor = clHighlight
    GroupAppearance.Color = 15717318
    GroupAppearance.ColorTo = 15717318
    GroupAppearance.ColorMirror = 15717318
    GroupAppearance.ColorMirrorTo = 15717318
    GroupAppearance.Font.Charset = DEFAULT_CHARSET
    GroupAppearance.Font.Color = clWindowText
    GroupAppearance.Font.Height = -11
    GroupAppearance.Font.Name = 'Segoe UI'
    GroupAppearance.Font.Style = []
    GroupAppearance.Gradient = ggVertical
    GroupAppearance.GradientMirror = ggVertical
    GroupAppearance.TextColor = clBlack
    GroupAppearance.CaptionAppearance.CaptionColor = 15915714
    GroupAppearance.CaptionAppearance.CaptionColorTo = 15915714
    GroupAppearance.CaptionAppearance.CaptionTextColor = clBlack
    GroupAppearance.CaptionAppearance.CaptionColorHot = 15915714
    GroupAppearance.CaptionAppearance.CaptionColorHotTo = 15915714
    GroupAppearance.CaptionAppearance.CaptionTextColorHot = clBlack
    GroupAppearance.PageAppearance.BorderColor = clBlack
    GroupAppearance.PageAppearance.Color = 15717318
    GroupAppearance.PageAppearance.ColorTo = clBtnFace
    GroupAppearance.PageAppearance.ColorMirror = clBtnFace
    GroupAppearance.PageAppearance.ColorMirrorTo = clBtnFace
    GroupAppearance.PageAppearance.Gradient = ggVertical
    GroupAppearance.PageAppearance.GradientMirror = ggVertical
    GroupAppearance.TabAppearance.BorderColor = clHighlight
    GroupAppearance.TabAppearance.BorderColorHot = clHighlight
    GroupAppearance.TabAppearance.BorderColorSelected = clBlack
    GroupAppearance.TabAppearance.BorderColorSelectedHot = clHighlight
    GroupAppearance.TabAppearance.BorderColorDisabled = clNone
    GroupAppearance.TabAppearance.BorderColorDown = clNone
    GroupAppearance.TabAppearance.Color = clBtnFace
    GroupAppearance.TabAppearance.ColorTo = clWhite
    GroupAppearance.TabAppearance.ColorSelected = 15717318
    GroupAppearance.TabAppearance.ColorSelectedTo = 15717318
    GroupAppearance.TabAppearance.ColorDisabled = clNone
    GroupAppearance.TabAppearance.ColorDisabledTo = clNone
    GroupAppearance.TabAppearance.ColorHot = 15717318
    GroupAppearance.TabAppearance.ColorHotTo = 15717318
    GroupAppearance.TabAppearance.ColorMirror = clWhite
    GroupAppearance.TabAppearance.ColorMirrorTo = clWhite
    GroupAppearance.TabAppearance.ColorMirrorHot = 15717318
    GroupAppearance.TabAppearance.ColorMirrorHotTo = 15717318
    GroupAppearance.TabAppearance.ColorMirrorSelected = 15717318
    GroupAppearance.TabAppearance.ColorMirrorSelectedTo = 15717318
    GroupAppearance.TabAppearance.ColorMirrorDisabled = clNone
    GroupAppearance.TabAppearance.ColorMirrorDisabledTo = clNone
    GroupAppearance.TabAppearance.Font.Charset = DEFAULT_CHARSET
    GroupAppearance.TabAppearance.Font.Color = clWindowText
    GroupAppearance.TabAppearance.Font.Height = -11
    GroupAppearance.TabAppearance.Font.Name = 'Tahoma'
    GroupAppearance.TabAppearance.Font.Style = []
    GroupAppearance.TabAppearance.Gradient = ggVertical
    GroupAppearance.TabAppearance.GradientMirror = ggVertical
    GroupAppearance.TabAppearance.GradientHot = ggVertical
    GroupAppearance.TabAppearance.GradientMirrorHot = ggVertical
    GroupAppearance.TabAppearance.GradientSelected = ggVertical
    GroupAppearance.TabAppearance.GradientMirrorSelected = ggVertical
    GroupAppearance.TabAppearance.GradientDisabled = ggVertical
    GroupAppearance.TabAppearance.GradientMirrorDisabled = ggVertical
    GroupAppearance.TabAppearance.TextColor = clBlack
    GroupAppearance.TabAppearance.TextColorHot = clBlack
    GroupAppearance.TabAppearance.TextColorSelected = clBlack
    GroupAppearance.TabAppearance.TextColorDisabled = clWhite
    GroupAppearance.ToolBarAppearance.BorderColor = clBlack
    GroupAppearance.ToolBarAppearance.BorderColorHot = clHighlight
    GroupAppearance.ToolBarAppearance.Color.Color = clBtnFace
    GroupAppearance.ToolBarAppearance.Color.ColorTo = clBtnFace
    GroupAppearance.ToolBarAppearance.Color.Direction = gdHorizontal
    GroupAppearance.ToolBarAppearance.ColorHot.Color = 15717318
    GroupAppearance.ToolBarAppearance.ColorHot.ColorTo = 15717318
    GroupAppearance.ToolBarAppearance.ColorHot.Direction = gdHorizontal
    PageAppearance.BorderColor = clBlack
    PageAppearance.Color = clBtnFace
    PageAppearance.ColorTo = clBtnFace
    PageAppearance.ColorMirror = clBtnFace
    PageAppearance.ColorMirrorTo = clBtnFace
    PageAppearance.Gradient = ggVertical
    PageAppearance.GradientMirror = ggVertical
    PagerCaption.BorderColor = clBlack
    PagerCaption.Color = clBtnFace
    PagerCaption.ColorTo = clBtnFace
    PagerCaption.ColorMirror = clBtnFace
    PagerCaption.ColorMirrorTo = clBtnFace
    PagerCaption.Gradient = ggVertical
    PagerCaption.GradientMirror = ggVertical
    PagerCaption.TextColor = clBlue
    PagerCaption.Font.Charset = DEFAULT_CHARSET
    PagerCaption.Font.Color = clWindowText
    PagerCaption.Font.Height = -11
    PagerCaption.Font.Name = 'Segoe UI'
    PagerCaption.Font.Style = []
    QATAppearance.BorderColor = clGray
    QATAppearance.Color = clBtnFace
    QATAppearance.ColorTo = clBtnFace
    QATAppearance.FullSizeBorderColor = clGray
    QATAppearance.FullSizeColor = clBtnFace
    QATAppearance.FullSizeColorTo = clBtnFace
    RightHandleColor = clBtnFace
    RightHandleColorTo = clNone
    RightHandleColorHot = 15717318
    RightHandleColorHotTo = clNone
    RightHandleColorDown = 11899524
    RightHandleColorDownTo = clNone
    TabAppearance.BorderColor = clNone
    TabAppearance.BorderColorHot = clHighlight
    TabAppearance.BorderColorSelected = clBlack
    TabAppearance.BorderColorSelectedHot = clHighlight
    TabAppearance.BorderColorDisabled = clNone
    TabAppearance.BorderColorDown = clNone
    TabAppearance.Color = clBtnFace
    TabAppearance.ColorTo = clWhite
    TabAppearance.ColorSelected = clWhite
    TabAppearance.ColorSelectedTo = clBtnFace
    TabAppearance.ColorDisabled = clWhite
    TabAppearance.ColorDisabledTo = clSilver
    TabAppearance.ColorHot = 15717318
    TabAppearance.ColorHotTo = 15717318
    TabAppearance.ColorMirror = clWhite
    TabAppearance.ColorMirrorTo = clWhite
    TabAppearance.ColorMirrorHot = 15717318
    TabAppearance.ColorMirrorHotTo = 15717318
    TabAppearance.ColorMirrorSelected = clBtnFace
    TabAppearance.ColorMirrorSelectedTo = clBtnFace
    TabAppearance.ColorMirrorDisabled = clWhite
    TabAppearance.ColorMirrorDisabledTo = clSilver
    TabAppearance.Font.Charset = DEFAULT_CHARSET
    TabAppearance.Font.Color = clWindowText
    TabAppearance.Font.Height = -11
    TabAppearance.Font.Name = 'Segoe UI'
    TabAppearance.Font.Style = []
    TabAppearance.Gradient = ggVertical
    TabAppearance.GradientMirror = ggVertical
    TabAppearance.GradientHot = ggVertical
    TabAppearance.GradientMirrorHot = ggVertical
    TabAppearance.GradientSelected = ggVertical
    TabAppearance.GradientMirrorSelected = ggVertical
    TabAppearance.GradientDisabled = ggVertical
    TabAppearance.GradientMirrorDisabled = ggVertical
    TabAppearance.TextColor = clBlack
    TabAppearance.TextColorHot = clBlack
    TabAppearance.TextColorSelected = clBlack
    TabAppearance.TextColorDisabled = clGray
    TabAppearance.BackGround.Color = clBtnFace
    TabAppearance.BackGround.ColorTo = clBtnFace
    TabAppearance.BackGround.Direction = gdHorizontal
    Left = 463
    Top = 3
  end
end
