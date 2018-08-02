object frmUserProfile: TfrmUserProfile
  Left = 484
  Top = 73
  Width = 581
  Height = 519
  HelpContext = 2310
  Caption = 'User Profile'
  Color = clBtnFace
  Constraints.MinWidth = 581
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  FormStyle = fsMDIChild
  KeyPreview = True
  OldCreateOrder = False
  Position = poOwnerFormCenter
  Scaled = False
  Visible = True
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
    Left = 5
    Top = 6
    Width = 566
    Height = 479
    ActivePage = tabUserProfile
    TabIndex = 0
    TabOrder = 0
    OnChange = PageControl1Change
    object tabUserProfile: TTabSheet
      HelpContext = 2310
      Caption = 'Profile'
      object pnlProfileCont: TPanel
        Left = -2
        Top = -2
        Width = 467
        Height = 451
        BevelOuter = bvNone
        TabOrder = 0
        object pnlMainStatus: TPanel
          Left = 0
          Top = 0
          Width = 467
          Height = 149
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          object lblUserName: Label8
            Left = 16
            Top = 37
            Width = 83
            Height = 14
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'User Name'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TextId = 0
          end
          object lblFullName: Label8
            Left = 16
            Top = 62
            Width = 83
            Height = 14
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'Full Name'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TextId = 0
          end
          object lblUserWinID: Label8
            Left = 16
            Top = 87
            Width = 83
            Height = 14
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'Windows User ID'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TextId = 0
          end
          object lblUserEmail: Label8
            Left = 16
            Top = 112
            Width = 83
            Height = 14
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'Email Address'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TextId = 0
          end
          object lblDomain: Label8
            Left = 320
            Top = 87
            Width = 83
            Height = 14
            Alignment = taRightJustify
            AutoSize = False
            Caption = '(Domain\UserID)'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TextId = 0
          end
          object lblUserStatus: Label8
            Left = 11
            Top = 12
            Width = 88
            Height = 14
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'Status'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TextId = 0
          end
          object lblSecurityHeading: TLabel
            Left = 8
            Top = 135
            Width = 40
            Height = 14
            Caption = 'Security'
          end
          object bvlSecurity: TBevel
            Left = 53
            Top = 142
            Width = 401
            Height = 3
            Shape = bsTopLine
          end
          object edtUserName: Text8Pt
            Tag = 1
            Left = 104
            Top = 33
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
            ShowHint = True
            TabOrder = 1
            OnExit = edtUserNameExit
            TextId = 0
            ViaSBtn = False
          end
          object edtUserFullName: Text8Pt
            Tag = 1
            Left = 104
            Top = 58
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
            ShowHint = True
            TabOrder = 2
            TextId = 0
            ViaSBtn = False
          end
          object edtWinUserID: Text8Pt
            Tag = 1
            Left = 104
            Top = 83
            Width = 211
            Height = 22
            HelpContext = 2307
            Color = clWhite
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 3
            OnExit = edtWinUserIDExit
            TextId = 0
            ViaSBtn = False
          end
          object edtUserEmail: Text8Pt
            Tag = 1
            Left = 104
            Top = 108
            Width = 345
            Height = 22
            HelpContext = 1238
            Color = clWhite
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            MaxLength = 100
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 4
            OnExit = edtUserEmailExit
            TextId = 0
            ViaSBtn = False
          end
          object cboUserStatus: TSBSComboBox
            Tag = 1
            Left = 104
            Top = 8
            Width = 211
            Height = 22
            HelpContext = 2306
            Style = csDropDownList
            Color = clWhite
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ItemHeight = 14
            ItemIndex = 0
            ParentFont = False
            TabOrder = 0
            Text = 'Active'
            Items.Strings = (
              'Active'
              'Suspended')
            MaxListWidth = 250
          end
        end
        object pnlSecurityCont: TPanel
          Left = 0
          Top = 149
          Width = 467
          Height = 136
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 1
          object pnlPwdExp: TPanel
            Left = 0
            Top = 25
            Width = 467
            Height = 30
            Align = alTop
            BevelOuter = bvNone
            TabOrder = 1
            object lblDays: Label8
              Left = 255
              Top = 5
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
            object lblPwdExp: Label8
              Left = 14
              Top = 5
              Width = 83
              Height = 14
              Caption = 'Password Expiry'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              TextId = 0
            end
            object Label81: Label8
              Left = 315
              Top = 5
              Width = 36
              Height = 14
              Caption = 'Expires'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              TextId = 0
            end
            object edtPwdExpDate: TEditDate
              Tag = 1
              Left = 355
              Top = 1
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
              TabOrder = 2
              OnExit = edtPwdExpDateExit
              Placement = cpAbove
              AllowBlank = True
            end
            object cboPasswordExpiry: TSBSComboBox
              Tag = 1
              Left = 104
              Top = 1
              Width = 149
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
              ItemIndex = 0
              ParentFont = False
              TabOrder = 0
              Text = 'Password Never Expires'
              OnChange = cboPasswordExpiryChange
              Items.Strings = (
                'Password Never Expires'
                'Password Expires every'
                'Password Expired')
              MaxListWidth = 0
            end
            object edtPwdExpDays: TCurrencyEdit
              Tag = 1
              Left = 282
              Top = 1
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
              TabOrder = 1
              WantReturns = False
              WordWrap = False
              OnExit = edtPwdExpDaysExit
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
          object pnlSecurityQuestion: TPanel
            Left = 0
            Top = 85
            Width = 467
            Height = 51
            Align = alTop
            BevelOuter = bvNone
            TabOrder = 3
            object lblSecQuestion: Label8
              Left = 10
              Top = 5
              Width = 88
              Height = 14
              Alignment = taRightJustify
              AutoSize = False
              Caption = 'Security Question'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              TextId = 0
            end
            object lblSecAnswer: Label8
              Left = 15
              Top = 32
              Width = 83
              Height = 14
              Alignment = taRightJustify
              AutoSize = False
              Caption = 'Answer'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              TextId = 0
            end
            object cboSecurityQuestion: TSBSComboBox
              Tag = 1
              Left = 104
              Top = 1
              Width = 345
              Height = 22
              HelpContext = 2308
              Style = csDropDownList
              Color = clWhite
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clNavy
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ItemHeight = 14
              ItemIndex = 0
              ParentFont = False
              TabOrder = 0
              Text = 'What was the Make and Model of your first car?'
              Items.Strings = (
                'What was the Make and Model of your first car?'
                'What Town/City were you born in?'
                'What was the name of the first school you attended?'
                'What was the first name of your first boyfriend/girlfriend?'
                'What was the name of your first pet?'
                'What was your mother'#8217's maiden name?')
              MaxListWidth = 250
            end
            object edtSecurityAnswer: Text8Pt
              Tag = 1
              Left = 104
              Top = 28
              Width = 345
              Height = 22
              HelpContext = 2309
              Color = clWhite
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clNavy
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              MaxLength = 100
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              TabOrder = 1
              OnExit = edtSecurityAnswerExit
              TextId = 0
              ViaSBtn = False
            end
          end
          object pnlRandomPwd: TPanel
            Left = 0
            Top = 0
            Width = 467
            Height = 25
            Align = alTop
            BevelOuter = bvNone
            TabOrder = 0
            object lblPwd: Label8
              Left = 47
              Top = 3
              Width = 50
              Height = 14
              Caption = 'Password'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              TextId = 0
            end
            object rbGenRandom: TRadioButton
              Left = 103
              Top = 2
              Width = 189
              Height = 17
              Caption = 'Randomly Generate && Email to user'
              Checked = True
              TabOrder = 0
              TabStop = True
            end
            object rbGenManual: TRadioButton
              Left = 295
              Top = 2
              Width = 150
              Height = 17
              Caption = 'Manually enter password'
              TabOrder = 1
            end
          end
          object pnlAutoLock: TPanel
            Left = 0
            Top = 55
            Width = 467
            Height = 30
            Align = alTop
            BevelOuter = bvNone
            TabOrder = 2
            object lblAfter: Label8
              Left = 120
              Top = 5
              Width = 26
              Height = 14
              Caption = 'after '
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              TextId = 0
            end
            object lblMinInactivity: Label8
              Left = 199
              Top = 5
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
            object edtPwdInactiveTime: TCurrencyEdit
              Tag = 1
              Left = 149
              Top = 1
              Width = 30
              Height = 22
              HelpContext = 1237
              Color = clWhite
              Enabled = False
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clNavy
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              Lines.Strings = (
                '0')
              MaxLength = 3
              ParentFont = False
              TabOrder = 0
              WantReturns = False
              WordWrap = False
              OnExit = edtPwdInactiveTimeExit
              AutoSize = False
              BlockNegative = False
              BlankOnZero = False
              DisplayFormat = '###,###,##0 ;###,###,##0-'
              DecPlaces = 0
              ShowCurrency = False
              TextId = 0
              Value = 999
            end
            object udUserInactivityDuration: TUpDown
              Tag = 1
              Left = 179
              Top = 1
              Width = 16
              Height = 22
              Associate = edtPwdInactiveTime
              Enabled = False
              Min = 0
              Max = 999
              Position = 0
              TabOrder = 1
              Wrap = False
            end
            object chkAutoLock: TCheckBoxEx
              Left = 6
              Top = 4
              Width = 111
              Height = 17
              HelpContext = 1237
              Alignment = taLeftJustify
              Caption = 'Automatically Lock'
              Color = clBtnFace
              ParentColor = False
              TabOrder = 2
              OnClick = chkAutoLockClick
              Modified = False
              ReadOnly = False
            end
          end
        end
        object pnlUserPref: TPanel
          Left = 0
          Top = 285
          Width = 467
          Height = 167
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 2
          object pnlPrinter: TPanel
            Left = 0
            Top = 11
            Width = 467
            Height = 52
            Align = alTop
            BevelOuter = bvNone
            TabOrder = 0
            object lblReportPrinter: Label8
              Left = 33
              Top = 7
              Width = 66
              Height = 14
              Alignment = taRightJustify
              Caption = 'Report Printer'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              TextId = 0
            end
            object lblFormPrinter: Label8
              Left = 40
              Top = 33
              Width = 58
              Height = 14
              Alignment = taRightJustify
              Caption = 'Form Printer'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              TextId = 0
            end
            object cboReportPrinter: TSBSComboBox
              Tag = 1
              Left = 104
              Top = 3
              Width = 345
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
              TabOrder = 0
              MaxListWidth = 250
            end
            object cboFormPrinter: TSBSComboBox
              Tag = 1
              Left = 104
              Top = 29
              Width = 345
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
              TabOrder = 1
              MaxListWidth = 250
            end
          end
          object pnlGLTree: TPanel
            Left = 0
            Top = 63
            Width = 467
            Height = 22
            Align = alTop
            BevelOuter = bvNone
            TabOrder = 1
            object chkShowGLCode: TCheckBoxEx
              Tag = 1
              Left = 104
              Top = 3
              Width = 162
              Height = 17
              HelpContext = 40177
              Caption = 'GL Tree - Show G/L Codes'
              Color = clBtnFace
              ParentColor = False
              TabOrder = 0
              Modified = False
              ReadOnly = False
            end
          end
          object pnlStockTree: TPanel
            Left = 0
            Top = 85
            Width = 467
            Height = 38
            Align = alTop
            BevelOuter = bvNone
            TabOrder = 2
            Visible = False
            object chkShowStockCodes: TCheckBoxEx
              Tag = 1
              Left = 104
              Top = 1
              Width = 192
              Height = 16
              HelpContext = 40178
              Caption = 'Stock Tree - Show Stock Codes'
              Color = clBtnFace
              ParentColor = False
              TabOrder = 0
              Modified = False
              ReadOnly = False
            end
            object chkShowProdTypes: TCheckBoxEx
              Tag = 1
              Left = 104
              Top = 20
              Width = 206
              Height = 16
              HelpContext = 40179
              Caption = 'Stock Tree - Show Product Types'
              Color = clBtnFace
              ParentColor = False
              TabOrder = 1
              Modified = False
              ReadOnly = False
            end
          end
          object pnlUserPrefHeading: TPanel
            Left = 0
            Top = 0
            Width = 467
            Height = 11
            Align = alTop
            BevelOuter = bvNone
            TabOrder = 4
            object lblTaxCodeTitle: TLabel
              Left = 6
              Top = -1
              Width = 86
              Height = 14
              Caption = 'User Preferences'
            end
            object bvlUserPref: TBevel
              Left = 95
              Top = 5
              Width = 361
              Height = 3
              Shape = bsTopLine
            end
          end
          object pnlGDPR: TPanel
            Left = 0
            Top = 123
            Width = 467
            Height = 39
            Align = alTop
            BevelOuter = bvNone
            TabOrder = 3
            object spGDPR: TShape
              Left = 120
              Top = 18
              Width = 7
              Height = 21
              Brush.Color = 35821
              Pen.Color = clBtnShadow
              Pen.Style = psClear
            end
            object chkHighlightPIIFields: TCheckBoxEx
              Tag = 1
              Left = 104
              Top = 1
              Width = 192
              Height = 16
              HelpContext = 2313
              Caption = 'GDPR - Highlight PII Fields'
              Color = clBtnFace
              ParentColor = False
              TabOrder = 0
              OnClick = chkHighlightPIIFieldsClick
              Modified = False
              ReadOnly = False
            end
            object btnEditColour: TButton
              Tag = 6
              Left = 128
              Top = 18
              Width = 80
              Height = 21
              Hint = 'Edit GDPR highlight colour'
              HelpContext = 2313
              Caption = 'Edit Colour'
              ParentShowHint = False
              ShowHint = True
              TabOrder = 1
              OnClick = btnEditColourClick
            end
          end
        end
      end
    end
    object tabUserDefaults: TTabSheet
      Caption = 'Defaults'
      ImageIndex = 3
      object pnlDefaultsCont: TPanel
        Left = -1
        Top = -2
        Width = 464
        Height = 438
        BevelOuter = bvNone
        TabOrder = 0
        object pnlTraders: TPanel
          Left = 0
          Top = 0
          Width = 464
          Height = 82
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          object lblCustSRICap: Label8
            Left = 26
            Top = 26
            Width = 73
            Height = 14
            Alignment = taRightJustify
            Caption = 'Customer (SRI)'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TextId = 0
          end
          object lblSuppPPICap: Label8
            Left = 35
            Top = 53
            Width = 64
            Height = 14
            Caption = 'Supplier (PPI)'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TextId = 0
          end
          object lblTraders: TLabel
            Left = 9
            Top = 5
            Width = 38
            Height = 14
            Caption = 'Traders'
          end
          object bvlTraders: TBevel
            Left = 51
            Top = 12
            Width = 402
            Height = 3
            Shape = bsTopLine
          end
          object lblCustSRI: Label8
            Left = 186
            Top = 26
            Width = 109
            Height = 14
            Caption = '( Trader name here... )'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TextId = 0
          end
          object lblSuppPPI: Label8
            Left = 186
            Top = 53
            Width = 109
            Height = 14
            Caption = '( Trader name here... )'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TextId = 0
          end
          object txtCustomerList: Text8Pt
            Tag = 1
            Left = 104
            Top = 22
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
            ShowHint = True
            TabOrder = 0
            OnExit = txtCustomerListExit
            TextId = 0
            ViaSBtn = False
            Link_to_Cust = True
            ShowHilight = True
          end
          object txtSupplierList: Text8Pt
            Tag = 1
            Left = 104
            Top = 49
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
            ShowHint = True
            TabOrder = 1
            OnExit = txtCustomerListExit
            TextId = 0
            ViaSBtn = False
            Link_to_Cust = True
            ShowHilight = True
          end
        end
        object pnlAuthorisation: TPanel
          Left = 0
          Top = 82
          Width = 464
          Height = 76
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 1
          object lblMaxSales: Label8
            Left = 48
            Top = 21
            Width = 50
            Height = 14
            Caption = 'Max Sales'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TextId = 0
          end
          object lblMaxPurch: Label8
            Left = 29
            Top = 48
            Width = 69
            Height = 14
            Caption = 'Max Purchase'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TextId = 0
          end
          object lblAuthLevel: TLabel
            Left = 8
            Top = 0
            Width = 99
            Height = 14
            Caption = 'Authorisation Levels'
          end
          object bvlAuthLevel: TBevel
            Left = 110
            Top = 7
            Width = 345
            Height = 3
            Shape = bsTopLine
          end
          object edtMaxSales: TCurrencyEdit
            Tag = 1
            Left = 104
            Top = 17
            Width = 87
            Height = 22
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
            TabOrder = 0
            WantReturns = False
            WordWrap = False
            AutoSize = False
            BlockNegative = True
            BlankOnZero = False
            DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
            ShowCurrency = True
            TextId = 0
            Value = 1E-10
          end
          object edtMaxPurch: TCurrencyEdit
            Tag = 1
            Left = 104
            Top = 44
            Width = 87
            Height = 22
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
            TabOrder = 1
            WantReturns = False
            WordWrap = False
            AutoSize = False
            BlockNegative = True
            BlankOnZero = False
            DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
            ShowCurrency = True
            TextId = 0
            Value = 1E-10
          end
        end
        object pnlBankGLCode: TPanel
          Left = 0
          Top = 158
          Width = 464
          Height = 72
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 2
          object lblSales: Label8
            Left = 70
            Top = 20
            Width = 27
            Height = 14
            Caption = 'Sales'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TextId = 0
          end
          object lblPurch: Label8
            Left = 51
            Top = 45
            Width = 46
            Height = 14
            Caption = 'Purchase'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TextId = 0
          end
          object lblBankGL: TLabel
            Left = 8
            Top = -1
            Width = 75
            Height = 14
            Caption = 'Bank GL Codes'
          end
          object bvlBankGL: TBevel
            Left = 87
            Top = 6
            Width = 370
            Height = 3
            Shape = bsTopLine
          end
          object lblSalesGL: Label8
            Left = 181
            Top = 20
            Width = 119
            Height = 14
            Caption = '( GL Description here... )'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TextId = 0
          end
          object lblPurchGL: Label8
            Left = 181
            Top = 46
            Width = 119
            Height = 14
            Caption = '( GL Description here... )'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TextId = 0
          end
          object edtBankGLSales: Text8Pt
            Tag = 1
            Left = 104
            Top = 16
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
            ShowHint = True
            TabOrder = 0
            OnExit = edtBankGLSalesExit
            TextId = 0
            ViaSBtn = False
          end
          object edtBankGLPurch: Text8Pt
            Tag = 1
            Left = 104
            Top = 42
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
            ShowHint = True
            TabOrder = 1
            OnExit = edtBankGLSalesExit
            TextId = 0
            ViaSBtn = False
          end
        end
        object pnlCCDept: TPanel
          Left = 0
          Top = 230
          Width = 464
          Height = 103
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 3
          object lblCCDef: Label8
            Left = 3
            Top = 26
            Width = 94
            Height = 14
            Alignment = taRightJustify
            Caption = 'Default Cost Centre'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TextId = 0
          end
          object lblCCDepRules: Label8
            Left = 29
            Top = 81
            Width = 68
            Height = 14
            Alignment = taRightJustify
            Caption = 'Selection Rule'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TextId = 0
          end
          object lblCCDepSec: TLabel
            Left = 3
            Top = 2
            Width = 148
            Height = 14
            Caption = 'Cost Centres and Departments'
          end
          object bvlCCDepSec: TBevel
            Left = 153
            Top = 9
            Width = 305
            Height = 3
            Shape = bsTopLine
          end
          object lblDepDef: Label8
            Left = 5
            Top = 53
            Width = 92
            Height = 14
            Alignment = taRightJustify
            Caption = 'Default Department'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TextId = 0
          end
          object lblCCDec: Label8
            Left = 148
            Top = 26
            Width = 162
            Height = 14
            Caption = '( Cost Centre Description here... )'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TextId = 0
          end
          object lblDepDes: Label8
            Left = 148
            Top = 53
            Width = 160
            Height = 14
            Caption = '( Department Description here... )'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TextId = 0
          end
          object txtDefaultCC: Text8Pt
            Tag = 1
            Left = 104
            Top = 22
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
            ShowHint = True
            TabOrder = 0
            OnExit = txtDefaultCCExit
            TextId = 0
            ViaSBtn = False
          end
          object txtDefaultDept: Text8Pt
            Tag = 1
            Left = 104
            Top = 49
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
            ShowHint = True
            TabOrder = 1
            OnExit = txtDefaultCCExit
            TextId = 0
            ViaSBtn = False
          end
          object cboSelRuleCCDept: TSBSComboBox
            Tag = 1
            Left = 104
            Top = 77
            Width = 199
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
            ItemIndex = 0
            ParentFont = False
            TabOrder = 2
            Text = 'Stock, Account, Operator'
            Items.Strings = (
              'Stock, Account, Operator'
              'Account, Stock, Operator'
              'Operator, Account, Stock'
              'Operator, Stock, Account')
            MaxListWidth = 170
          end
        end
        object pnlLocations: TPanel
          Left = 0
          Top = 333
          Width = 464
          Height = 87
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 4
          object lblDefLocation: Label8
            Left = 21
            Top = 26
            Width = 78
            Height = 14
            Alignment = taRightJustify
            Caption = 'Default Location'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TextId = 0
          end
          object lblLocRules: Label8
            Left = 30
            Top = 55
            Width = 68
            Height = 14
            Alignment = taRightJustify
            Caption = 'Selection Rule'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TextId = 0
          end
          object lblLocationSec: TLabel
            Left = 11
            Top = 2
            Width = 47
            Height = 14
            Caption = 'Locations'
          end
          object bvlLocationSec: TBevel
            Left = 61
            Top = 10
            Width = 399
            Height = 3
            Shape = bsTopLine
          end
          object lblLocationDes: Label8
            Left = 153
            Top = 26
            Width = 119
            Height = 14
            Caption = '( Location Name here... )'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TextId = 0
          end
          object txtDefaultLoc: Text8Pt
            Tag = 1
            Left = 104
            Top = 22
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
            ShowHint = True
            TabOrder = 0
            OnExit = txtDefaultLocExit
            TextId = 0
            ViaSBtn = False
          end
          object cboSelRuleLoc: TSBSComboBox
            Tag = 1
            Left = 104
            Top = 51
            Width = 199
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
            ItemIndex = 0
            ParentFont = False
            TabOrder = 1
            Text = 'Account, Stock, Operator'
            Items.Strings = (
              'Account, Stock, Operator'
              'Stock, Account, Operator'
              'Operator, Account, Stock'
              'Operator, Stock, Account')
            MaxListWidth = 170
          end
        end
      end
    end
    object tabAccessSettings: TTabSheet
      Caption = 'Access Settings'
      ImageIndex = 1
      object pnlRightAccessSettings: TPanel
        Left = 459
        Top = 0
        Width = 99
        Height = 450
        Align = alRight
        BevelOuter = bvNone
        TabOrder = 0
      end
      object pnlMainAccessSettings: TPanel
        Left = 0
        Top = 0
        Width = 459
        Height = 450
        Align = alClient
        Alignment = taLeftJustify
        BevelOuter = bvNone
        TabOrder = 1
        object NLOLine: TSBSOutlineB
          Left = 0
          Top = 42
          Width = 459
          Height = 388
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
          PopupMenu = PopupMenu1
          ScrollBars = ssVertical
          ShowValCol = 1
          OnUpdateNode = NLOLineUpdateNode
          OnNodeChkHotSpot = NLOLineNodeChkHotSpot
          TreeColor = clNavy
          Data = {3F00}
        end
        object pnlImageHolder: TPanel
          Left = 0
          Top = 430
          Width = 459
          Height = 20
          Align = alBottom
          BevelOuter = bvNone
          TabOrder = 1
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
        object pnlAdvToolBar: TPanel
          Left = 0
          Top = 0
          Width = 459
          Height = 42
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 2
          object AdvToolBar1: TAdvToolBar
            Left = 2
            Top = 2
            Width = 358
            Height = 38
            AllowFloating = True
            AutoSize = False
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
            ParentStyler = False
            ParentOptionPicture = True
            ToolBarIndex = -1
            object FullExBtn: TAdvGlowButton
              Left = 2
              Top = 2
              Width = 40
              Height = 38
              Align = alLeft
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
              Height = 38
              Align = alLeft
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
      end
    end
    object tabSignatures: TTabSheet
      Caption = 'Signatures'
      ImageIndex = 2
      object pnlMainSig: TPanel
        Left = 0
        Top = 0
        Width = 459
        Height = 434
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        object pnlEmailSig: TPanel
          Left = 0
          Top = 0
          Width = 459
          Height = 209
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          object pnlEmailSigCaption: TPanel
            Left = 0
            Top = 0
            Width = 459
            Height = 19
            Align = alTop
            BevelOuter = bvNone
            TabOrder = 0
            object lblEmailSignature: TLabel
              Left = 4
              Top = 2
              Width = 73
              Height = 14
              Caption = 'Email Signature'
            end
            object bvlEmailSig: TBevel
              Left = 80
              Top = 9
              Width = 371
              Height = 3
              Shape = bsTopLine
            end
          end
          object memEmailSig: TMemo
            Left = 0
            Top = 19
            Width = 459
            Height = 190
            Align = alClient
            Color = clWhite
            Font.Charset = ANSI_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 1
          end
        end
        object pnlFaxSig: TPanel
          Left = 0
          Top = 209
          Width = 459
          Height = 225
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 1
          object pnlFaxSigCaption: TPanel
            Left = 0
            Top = 0
            Width = 459
            Height = 20
            Align = alTop
            BevelOuter = bvNone
            TabOrder = 0
            object lblFaxSignature: TLabel
              Left = 4
              Top = 2
              Width = 67
              Height = 14
              Caption = 'Fax Signature'
            end
            object bvlFaxSignature: TBevel
              Left = 75
              Top = 9
              Width = 376
              Height = 3
              Shape = bsTopLine
            end
          end
          object memFaxSig: TMemo
            Left = 0
            Top = 20
            Width = 459
            Height = 205
            Align = alClient
            Color = clWhite
            Font.Charset = ANSI_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 1
          end
        end
      end
      object pnlRightSig: TPanel
        Left = 459
        Top = 0
        Width = 99
        Height = 434
        Align = alRight
        BevelOuter = bvNone
        TabOrder = 1
      end
    end
  end
  object pnlButton: TPanel
    Left = 469
    Top = 32
    Width = 97
    Height = 249
    BevelOuter = bvNone
    TabOrder = 2
    DesignSize = (
      97
      249)
    object btnOK: TButton
      Tag = 1
      Left = 8
      Top = 6
      Width = 80
      Height = 21
      HelpContext = 257
      Anchors = [akTop, akRight]
      Caption = '&OK'
      ModalResult = 1
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = btnOKClick
    end
    object btnCancel: TButton
      Tag = 1
      Left = 8
      Top = 30
      Width = 80
      Height = 21
      HelpContext = 258
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = '&Cancel'
      ModalResult = 2
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = btnCancelClick
    end
    object pnlAccessSettingBtn: TPanel
      Left = 0
      Top = 53
      Width = 97
      Height = 196
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 2
      object btnInteractive: TButton
        Tag = 5
        Left = 8
        Top = 27
        Width = 80
        Height = 21
        Hint = 
          'Simulate the settings of another User|Apply the settings of the ' +
          'currently highlighted user to the live system.'
        HelpContext = 398
        Caption = '&Interactive'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnClick = btnInteractiveClick
      end
      object btnExpandlevel: TButton
        Tag = 1
        Left = 8
        Top = 51
        Width = 80
        Height = 21
        Hint = 
          'Expand current level |Expands the currently highlighted level an' +
          'd all its sub levels'
        Caption = '&Expand level'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        OnClick = btnExpandlevelClick
      end
      object btnCollapsLevel: TButton
        Left = 8
        Top = 75
        Width = 80
        Height = 21
        Hint = 
          'Collapse current level |Collapses the currently highlighted leve' +
          'l and all its sub levels'
        Caption = '&Collapse Level'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        OnClick = btnCollapsLevelClick
      end
      object btnSetLevelYes: TButton
        Tag = 6
        Left = 8
        Top = 99
        Width = 80
        Height = 21
        Hint = 
          'Set current level to Yes|Sets the currently highlighted level an' +
          'd all its sub levels to Yes'
        Caption = 'Set Level &Yes'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 3
        OnClick = btnSetLevelYesClick
      end
      object btnSetLevelNo: TButton
        Tag = 6
        Left = 8
        Top = 123
        Width = 80
        Height = 21
        Hint = 
          'Set current level to No|Sets the currently highlighted level and' +
          ' all its sub levels to No'
        Caption = 'Set Level &No'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 4
        OnClick = btnSetLevelNoClick
      end
      object btnFind: TButton
        Tag = 5
        Left = 8
        Top = 3
        Width = 80
        Height = 21
        Hint = 
          'Find Password option|Searches the password tree to find a passwo' +
          'rd'
        HelpContext = 398
        Caption = '&Find'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 5
        OnClick = btnFindClick
      end
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 481
    Top = 65532
    object mnuInteractive: TMenuItem
      Caption = '&Interactive'
      HelpContext = 398
      Hint = 
        'Apply the settings of the currently highlighted user to the live' +
        ' system.'
      OnClick = btnInteractiveClick
    end
    object mnuFind: TMenuItem
      Caption = '&Find'
      OnClick = btnFindClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object mnuExpandLevel: TMenuItem
      Tag = 1
      Caption = '&Expand Level'
      OnClick = btnExpandlevelClick
    end
    object mnuCollapseLevel: TMenuItem
      Caption = '&Collapse Level'
      OnClick = btnCollapsLevelClick
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object mnuSetYes: TMenuItem
      Caption = 'Set Level &Yes'
      OnClick = btnSetLevelYesClick
    end
    object mnuSetNo: TMenuItem
      Caption = 'SetLevel &No'
      OnClick = btnSetLevelNoClick
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
    Left = 290
    Top = 65533
  end
  object ColorDialog: TColorDialog
    Ctl3D = True
    Left = 376
  end
end
