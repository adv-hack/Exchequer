object CustRec3: TCustRec3
  Left = -699
  Top = -193
  Width = 595
  Height = 618
  HelpContext = 16
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  Caption = 'Customer Record v3'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  FormStyle = fsMDIChild
  KeyPreview = True
  OldCreateOrder = True
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
    Left = 4
    Top = 4
    Width = 570
    Height = 493
    ActivePage = JobApplicationsPage
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Images = ImageRepos.MulCtrlImages
    ParentFont = False
    TabIndex = 10
    TabOrder = 0
    OnChange = PageControl1Change
    OnChanging = PageControl1Changing
    object MainPage: TTabSheet
      HelpContext = 16
      Caption = 'Main'
      ImageIndex = -1
      object SBSPanel1: TSBSPanel
        Left = 0
        Top = 0
        Width = 562
        Height = 464
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        object TCMScrollBox: TScrollBox
          Left = 0
          Top = 1
          Width = 457
          Height = 414
          VertScrollBar.Visible = False
          BorderStyle = bsNone
          TabOrder = 0
          object SBSPanel3: TSBSPanel
            Left = 267
            Top = 95
            Width = 171
            Height = 311
            BevelInner = bvRaised
            BevelOuter = bvLowered
            ParentColor = True
            TabOrder = 2
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            object Label82: Label8
              Left = 21
              Top = 30
              Width = 41
              Height = 14
              Caption = 'Payment'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              PopupMenu = PopupMenu1
              TextId = 0
            end
            object Label83: Label8
              Left = 116
              Top = 36
              Width = 24
              Height = 14
              Caption = 'days'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              PopupMenu = PopupMenu1
              TextId = 0
            end
            object Label84: Label8
              Left = 9
              Top = 101
              Width = 53
              Height = 14
              Caption = 'This Period'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              PopupMenu = PopupMenu1
              TextId = 0
            end
            object Label89: Label8
              Left = 18
              Top = 128
              Width = 44
              Height = 14
              Caption = 'This YTD'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              PopupMenu = PopupMenu1
              TextId = 0
            end
            object Label810: Label8
              Left = 17
              Top = 155
              Width = 45
              Height = 14
              Caption = 'Last YTD'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              PopupMenu = PopupMenu1
              TextId = 0
            end
            object Label811: Label8
              Left = 19
              Top = 194
              Width = 42
              Height = 14
              Caption = 'Balance'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
              PopupMenu = PopupMenu1
              TextId = 0
            end
            object Label812: Label8
              Left = 24
              Top = 232
              Width = 37
              Height = 14
              Caption = 'Cr. Limit'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              PopupMenu = PopupMenu1
              TextId = 0
            end
            object Label813: Label8
              Left = 13
              Top = 259
              Width = 49
              Height = 14
              Caption = 'Committed'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              PopupMenu = PopupMenu1
              TextId = 0
            end
            object Label814: Label8
              Left = 34
              Top = 280
              Width = 28
              Height = 14
              Caption = 'Credit'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              PopupMenu = PopupMenu1
              TextId = 0
            end
            object Label815: Label8
              Left = 18
              Top = 292
              Width = 44
              Height = 14
              Caption = 'Available'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              PopupMenu = PopupMenu1
              TextId = 0
            end
            object Label816: Label8
              Left = 32
              Top = 43
              Width = 29
              Height = 14
              Caption = 'Terms'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              PopupMenu = PopupMenu1
              TextId = 0
            end
            object Label818: Label8
              Left = 6
              Top = 63
              Width = 56
              Height = 14
              Caption = 'Oldest Debt'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              PopupMenu = PopupMenu1
              TextId = 0
            end
            object Label819: Label8
              Left = 116
              Top = 63
              Width = 33
              Height = 14
              AutoSize = False
              Caption = 'weeks'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              PopupMenu = PopupMenu1
              TextId = 0
            end
            object Label841: Label8
              Left = 31
              Top = 9
              Width = 31
              Height = 14
              Caption = 'Status'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              PopupMenu = PopupMenu1
              TextId = 0
            end
            object Bevel4: TBevel
              Left = 7
              Top = 220
              Width = 159
              Height = 2
              Shape = bsTopLine
            end
            object Bevel3: TBevel
              Left = 7
              Top = 182
              Width = 159
              Height = 2
              Shape = bsTopLine
            end
            object Bevel2: TBevel
              Left = 7
              Top = 89
              Width = 159
              Height = 2
              Shape = bsTopLine
            end
            object PayTF: TCurrencyEdit
              Tag = 1
              Left = 65
              Top = 33
              Width = 47
              Height = 22
              HelpContext = 73
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
            object CredStatF: TCurrencyEdit
              Tag = 2
              Left = 65
              Top = 60
              Width = 47
              Height = 22
              HelpContext = 97
              TabStop = False
              Color = clWhite
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clNavy
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              Lines.Strings = (
                '0 ')
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
              Value = 1E-10
            end
            object TPrTO: TCurrencyEdit
              Tag = 2
              Left = 65
              Top = 98
              Width = 101
              Height = 22
              TabStop = False
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
              TabOrder = 3
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
            object TYTDTO: TCurrencyEdit
              Tag = 2
              Left = 65
              Top = 125
              Width = 101
              Height = 22
              TabStop = False
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
              TabOrder = 4
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
            object LYTDTO: TCurrencyEdit
              Tag = 2
              Left = 65
              Top = 152
              Width = 101
              Height = 22
              TabStop = False
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
              TabOrder = 5
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
            object CurrBalF: TCurrencyEdit
              Tag = 2
              Left = 65
              Top = 191
              Width = 101
              Height = 22
              TabStop = False
              Color = clWhite
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clNavy
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              Lines.Strings = (
                '0,00 ')
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
              Value = 1E-10
            end
            object CrLimitF: TCurrencyEdit
              Tag = 1
              Left = 65
              Top = 229
              Width = 101
              Height = 22
              HelpContext = 100
              Color = clWhite
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clNavy
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              Lines.Strings = (
                '0,00 ')
              MaxLength = 12
              ParentFont = False
              ReadOnly = True
              TabOrder = 2
              WantReturns = False
              WordWrap = False
              OnExit = PayTFExit
              AutoSize = False
              BlockNegative = False
              BlankOnZero = False
              DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
              ShowCurrency = False
              TextId = 0
              Value = 1E-10
            end
            object CommitLF: TCurrencyEdit
              Tag = 2
              Left = 65
              Top = 256
              Width = 101
              Height = 22
              TabStop = False
              Color = clWhite
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clNavy
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              Lines.Strings = (
                '0,00 ')
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
              Value = 1E-10
            end
            object CredAvailF: TCurrencyEdit
              Tag = 2
              Left = 65
              Top = 283
              Width = 101
              Height = 22
              HelpContext = 99
              TabStop = False
              Color = clWhite
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clNavy
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              Lines.Strings = (
                '0,00 ')
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
              Value = 1E-10
            end
            object StatusF: Text8Pt
              Tag = 2
              Left = 65
              Top = 6
              Width = 101
              Height = 22
              HelpContext = 96
              TabStop = False
              Color = clWhite
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clNavy
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              MaxLength = 25
              ParentFont = False
              ReadOnly = True
              TabOrder = 9
              TextId = 0
              ViaSBtn = False
            end
          end
          object SBSPanel8: TSBSPanel
            Left = 1
            Top = 1
            Width = 437
            Height = 88
            BevelInner = bvRaised
            BevelOuter = bvLowered
            ParentColor = True
            TabOrder = 0
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            object lblCompanyName: Label8
              Left = 10
              Top = 60
              Width = 57
              Height = 14
              Alignment = taRightJustify
              AutoSize = False
              Caption = 'Company'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              PopupMenu = PopupMenu1
              TextId = 0
            end
            object Label85: Label8
              Left = 10
              Top = 8
              Width = 57
              Height = 14
              Alignment = taRightJustify
              AutoSize = False
              Caption = 'Acc No.'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              PopupMenu = PopupMenu1
              TextId = 0
            end
            object Label852: Label8
              Left = 10
              Top = 34
              Width = 57
              Height = 14
              Alignment = taRightJustify
              AutoSize = False
              Caption = 'Alt Ref.'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              PopupMenu = PopupMenu1
              TextId = 0
            end
            object AcShortCodeTxt: TLabel
              Left = 362
              Top = 34
              Width = 68
              Height = 14
              Alignment = taRightJustify
              Caption = '(Short Code: )'
            end
            object CompF: Text8Pt
              Tag = 1
              Left = 71
              Top = 57
              Width = 361
              Height = 22
              HelpContext = 92
              Color = clWhite
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clNavy
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              MaxLength = 45
              ParentFont = False
              ReadOnly = True
              TabOrder = 2
              TextId = 0
              ViaSBtn = False
              GDPREnabled = True
            end
            object ACCodeF: Text8Pt
              Tag = 1
              Left = 71
              Top = 5
              Width = 361
              Height = 22
              HelpContext = 91
              CharCase = ecUpperCase
              Color = clWhite
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clNavy
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              MaxLength = 6
              ParentFont = False
              ReadOnly = True
              TabOrder = 0
              OnEnter = ACCodeFEnter
              OnExit = ACCodeFExit
              TextId = 0
              ViaSBtn = False
            end
            object AltCodeF: Text8Pt
              Tag = 1
              Left = 71
              Top = 31
              Width = 149
              Height = 22
              HelpContext = 1159
              CharCase = ecUpperCase
              Color = clWhite
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clNavy
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              MaxLength = 20
              ParentFont = False
              ReadOnly = True
              TabOrder = 1
              TextId = 0
              ViaSBtn = False
            end
          end
          object SBSPanel2: TSBSPanel
            Left = 1
            Top = 95
            Width = 263
            Height = 311
            BevelInner = bvRaised
            BevelOuter = bvLowered
            ParentColor = True
            TabOrder = 1
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            object Label86: Label8
              Left = 29
              Top = 9
              Width = 37
              Height = 14
              Alignment = taRightJustify
              Caption = 'Contact'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              PopupMenu = PopupMenu1
              TextId = 0
            end
            object Label87: Label8
              Left = 5
              Top = 31
              Width = 73
              Height = 14
              Caption = 'Main Address:-'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              PopupMenu = PopupMenu1
              TextId = 0
            end
            object Label836: Label8
              Left = 10
              Top = 214
              Width = 57
              Height = 14
              Alignment = taRightJustify
              AutoSize = False
              Caption = 'e-Mail'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              PopupMenu = PopupMenu1
              TextId = 0
            end
            object Label81: Label8
              Left = 29
              Top = 183
              Width = 38
              Height = 14
              Caption = 'Country'
              FocusControl = PostCF
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              PopupMenu = PopupMenu1
              TextId = 0
            end
            object lblLine1: TLabel
              Left = 10
              Top = 50
              Width = 57
              Height = 14
              Alignment = taRightJustify
              AutoSize = False
              Caption = 'Line 1'
            end
            object lblLine2: TLabel
              Left = 10
              Top = 72
              Width = 57
              Height = 14
              Alignment = taRightJustify
              AutoSize = False
              Caption = 'Line 2'
            end
            object lblLine3: TLabel
              Left = 10
              Top = 94
              Width = 57
              Height = 14
              Alignment = taRightJustify
              AutoSize = False
              Caption = 'Line 3'
            end
            object lblLine4: TLabel
              Left = 10
              Top = 116
              Width = 57
              Height = 14
              Alignment = taRightJustify
              AutoSize = False
              Caption = 'Town'
            end
            object lblLine5: TLabel
              Left = 10
              Top = 138
              Width = 57
              Height = 14
              Alignment = taRightJustify
              AutoSize = False
              Caption = 'County'
            end
            object Label1: TLabel
              Left = 10
              Top = 160
              Width = 57
              Height = 14
              Alignment = taRightJustify
              AutoSize = False
              Caption = 'Post Code'
            end
            object Label824: Label8
              Left = 10
              Top = 238
              Width = 57
              Height = 14
              Alignment = taRightJustify
              AutoSize = False
              Caption = 'Telephone'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              PopupMenu = PopupMenu1
              TextId = 0
            end
            object Label825: Label8
              Left = 10
              Top = 262
              Width = 57
              Height = 14
              Alignment = taRightJustify
              AutoSize = False
              Caption = 'Fax'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              PopupMenu = PopupMenu1
              TextId = 0
            end
            object Label833: Label8
              Left = 10
              Top = 286
              Width = 57
              Height = 14
              Alignment = taRightJustify
              AutoSize = False
              Caption = 'Mobile'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              PopupMenu = PopupMenu1
              TextId = 0
            end
            object Bevel5: TBevel
              Left = 7
              Top = 205
              Width = 251
              Height = 2
              Shape = bsTopLine
            end
            object ContactF: Text8Pt
              Tag = 1
              Left = 71
              Top = 6
              Width = 187
              Height = 22
              HelpContext = 93
              Color = clWhite
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clNavy
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              MaxLength = 25
              ParentFont = False
              ReadOnly = True
              TabOrder = 0
              TextId = 0
              ViaSBtn = False
              GDPREnabled = True
            end
            object Addr1F: Text8Pt
              Tag = 1
              Left = 71
              Top = 47
              Width = 187
              Height = 22
              HelpContext = 94
              Color = clWhite
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clNavy
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              MaxLength = 30
              ParentFont = False
              ReadOnly = True
              TabOrder = 1
              OnKeyPress = Addr1FKeyPress
              TextId = 0
              ViaSBtn = False
              GDPREnabled = True
            end
            object Addr2F: Text8Pt
              Tag = 1
              Left = 71
              Top = 69
              Width = 187
              Height = 22
              HelpContext = 94
              Color = clWhite
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clNavy
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              MaxLength = 30
              ParentFont = False
              ReadOnly = True
              TabOrder = 2
              OnKeyPress = Addr1FKeyPress
              TextId = 0
              ViaSBtn = False
              GDPREnabled = True
            end
            object Addr3F: Text8Pt
              Tag = 1
              Left = 71
              Top = 91
              Width = 187
              Height = 22
              HelpContext = 94
              Color = clWhite
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clNavy
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              MaxLength = 30
              ParentFont = False
              ReadOnly = True
              TabOrder = 3
              OnKeyPress = Addr1FKeyPress
              TextId = 0
              ViaSBtn = False
              GDPREnabled = True
            end
            object Addr4F: Text8Pt
              Tag = 1
              Left = 71
              Top = 113
              Width = 187
              Height = 22
              HelpContext = 94
              Color = clWhite
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clNavy
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              MaxLength = 30
              ParentFont = False
              ReadOnly = True
              TabOrder = 4
              OnKeyPress = Addr1FKeyPress
              TextId = 0
              ViaSBtn = False
              GDPREnabled = True
            end
            object Addr5F: Text8Pt
              Tag = 1
              Left = 71
              Top = 135
              Width = 187
              Height = 22
              HelpContext = 94
              Color = clWhite
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clNavy
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              MaxLength = 30
              ParentFont = False
              ReadOnly = True
              TabOrder = 5
              OnKeyPress = Addr1FKeyPress
              TextId = 0
              ViaSBtn = False
              GDPREnabled = True
            end
            object PhoneF: Text8Pt
              Tag = 1
              Left = 71
              Top = 235
              Width = 187
              Height = 22
              HelpContext = 95
              Color = clWhite
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clNavy
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              MaxLength = 30
              ParentFont = False
              ReadOnly = True
              TabOrder = 9
              TextId = 0
              ViaSBtn = False
              GDPREnabled = True
            end
            object FaxF: Text8Pt
              Tag = 1
              Left = 71
              Top = 259
              Width = 187
              Height = 22
              HelpContext = 95
              Color = clWhite
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clNavy
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              MaxLength = 30
              ParentFont = False
              ReadOnly = True
              TabOrder = 10
              TextId = 0
              ViaSBtn = False
              GDPREnabled = True
            end
            object MobileF: Text8Pt
              Tag = 1
              Left = 71
              Top = 283
              Width = 187
              Height = 22
              HelpContext = 95
              Color = clWhite
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clNavy
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              MaxLength = 30
              ParentFont = False
              ReadOnly = True
              TabOrder = 11
              TextId = 0
              ViaSBtn = False
              GDPREnabled = True
            end
            object EMailF: Text8Pt
              Tag = 1
              Left = 71
              Top = 211
              Width = 187
              Height = 22
              HelpContext = 1158
              Color = clWhite
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clNavy
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              MaxLength = 100
              ParentFont = False
              ReadOnly = True
              TabOrder = 8
              TextId = 0
              ViaSBtn = False
              GDPREnabled = True
            end
            object PostCF: Text8Pt
              Tag = 1
              Left = 71
              Top = 157
              Width = 92
              Height = 22
              HelpContext = 94
              CharCase = ecUpperCase
              Color = clWhite
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clNavy
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              MaxLength = 20
              ParentFont = False
              ReadOnly = True
              TabOrder = 6
              OnExit = PostCFExit
              TextId = 0
              ViaSBtn = False
              GDPREnabled = True
            end
            object lstAddressCountry: TSBSComboBox
              Tag = 1
              Left = 71
              Top = 179
              Width = 187
              Height = 22
              HelpContext = 2204
              Style = csDropDownList
              Color = clWhite
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clNavy
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ItemHeight = 0
              MaxLength = 3
              ParentFont = False
              TabOrder = 7
              ExtendedList = True
              MaxListWidth = 279
              ReadOnly = True
              Validate = True
            end
          end
        end
      end
    end
    object DefaultsPage: TTabSheet
      HelpContext = 555
      Caption = 'Defaults'
      ImageIndex = -1
      object SBSPanel4: TSBSPanel
        Left = 0
        Top = 0
        Width = 562
        Height = 464
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        object Bevel1: TBevel
          Left = 389
          Top = 2
          Width = 1
          Height = 290
          Style = bsRaised
        end
        object TCDScrollBox: TScrollBox
          Left = 0
          Top = 0
          Width = 451
          Height = 464
          HorzScrollBar.Position = 327
          VertScrollBar.Visible = False
          BorderStyle = bsNone
          TabOrder = 0
          object SBSPanel7: TSBSPanel
            Left = -73
            Top = 1
            Width = 191
            Height = 310
            BevelInner = bvRaised
            BevelOuter = bvLowered
            ParentColor = True
            TabOrder = 1
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            object Label827: Label8
              Left = 17
              Top = 91
              Width = 65
              Height = 14
              Alignment = taRightJustify
              Caption = 'Disc% / Band'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              PopupMenu = PopupMenu1
              TextId = 0
            end
            object Label829: Label8
              Left = 10
              Top = 187
              Width = 72
              Height = 14
              Alignment = taRightJustify
              Caption = 'Sales GL Code'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              PopupMenu = PopupMenu1
              TextId = 0
            end
            object Label831: Label8
              Left = 10
              Top = 236
              Width = 72
              Height = 14
              Alignment = taRightJustify
              AutoSize = False
              Caption = 'Area'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              PopupMenu = PopupMenu1
              TextId = 0
            end
            object Label832: Label8
              Left = 15
              Top = 286
              Width = 67
              Height = 14
              Alignment = taRightJustify
              Caption = 'Account Type'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              PopupMenu = PopupMenu1
              TextId = 0
            end
            object CDRCurrLab: Label8
              Left = 37
              Top = 66
              Width = 45
              Height = 14
              Alignment = taRightJustify
              Caption = 'Currency'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              PopupMenu = PopupMenu1
              TextId = 0
            end
            object CDRCCLab: Label8
              Left = 25
              Top = 115
              Width = 57
              Height = 14
              Alignment = taRightJustify
              Caption = 'Cost Centre'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              PopupMenu = PopupMenu1
              TextId = 0
            end
            object Label842: Label8
              Left = 15
              Top = 211
              Width = 67
              Height = 14
              Alignment = taRightJustify
              Caption = 'Cost GL Code'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              PopupMenu = PopupMenu1
              TextId = 0
            end
            object Label834: Label8
              Left = 21
              Top = 163
              Width = 61
              Height = 14
              Alignment = taRightJustify
              Caption = 'Ctrl GL Code'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              PopupMenu = PopupMenu1
              TextId = 0
            end
            object StatementToLbl: Label8
              Left = 73
              Top = 40
              Width = 12
              Height = 14
              Caption = 'to:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              PopupMenu = PopupMenu1
              TextId = 0
            end
            object DeptLbl: Label8
              Left = 27
              Top = 139
              Width = 55
              Height = 14
              Alignment = taRightJustify
              Caption = 'Department'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              PopupMenu = PopupMenu1
              TextId = 0
            end
            object Label88: Label8
              Left = 10
              Top = 261
              Width = 72
              Height = 14
              Alignment = taRightJustify
              AutoSize = False
              Caption = 'Tag No.'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              PopupMenu = PopupMenu1
              TextId = 0
            end
            object DiscF: Text8Pt
              Tag = 1
              Left = 87
              Top = 88
              Width = 67
              Height = 22
              HelpContext = 23
              Color = clWhite
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clNavy
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              ReadOnly = True
              TabOrder = 3
              TextId = 0
              ViaSBtn = False
            end
            object CCF: Text8Pt
              Tag = 1
              Left = 87
              Top = 112
              Width = 53
              Height = 22
              HelpContext = 109
              Color = clWhite
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clNavy
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              ReadOnly = True
              TabOrder = 4
              OnExit = CCFExit
              TextId = 0
              ViaSBtn = False
            end
            object DNomF: Text8Pt
              Tag = 1
              Left = 87
              Top = 184
              Width = 97
              Height = 22
              HelpContext = 108
              Color = clWhite
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clNavy
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              ReadOnly = True
              TabOrder = 7
              OnExit = DNomFExit
              TextId = 0
              ViaSBtn = False
            end
            object AreaF: Text8Pt
              Tag = 1
              Left = 87
              Top = 233
              Width = 53
              Height = 22
              HelpContext = 110
              Color = clWhite
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clNavy
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              MaxLength = 4
              ParentFont = False
              ReadOnly = True
              TabOrder = 9
              OnExit = AreaFExit
              TextId = 0
              ViaSBtn = False
              OnEntHookEvent = User1FEntHookEvent
            end
            object DepF: Text8Pt
              Tag = 1
              Left = 87
              Top = 136
              Width = 53
              Height = 22
              HelpContext = 109
              Color = clWhite
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clNavy
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              ReadOnly = True
              TabOrder = 5
              OnExit = CCFExit
              TextId = 0
              ViaSBtn = False
            end
            object DCNomF: Text8Pt
              Tag = 1
              Left = 87
              Top = 208
              Width = 97
              Height = 22
              HelpContext = 108
              Color = clWhite
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clNavy
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              ReadOnly = True
              TabOrder = 8
              OnExit = DNomFExit
              TextId = 0
              ViaSBtn = False
            end
            object CurrF: TSBSComboBox
              Tag = 1
              Left = 87
              Top = 62
              Width = 67
              Height = 22
              HelpContext = 111
              Style = csDropDownList
              Color = clWhite
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clNavy
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ItemHeight = 0
              MaxLength = 3
              ParentFont = False
              TabOrder = 2
              ExtendedList = True
              MaxListWidth = 90
              ReadOnly = True
              Validate = True
            end
            object RepF: Text8Pt
              Tag = 1
              Left = 87
              Top = 283
              Width = 97
              Height = 22
              HelpContext = 110
              Color = clWhite
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clNavy
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              MaxLength = 4
              ParentFont = False
              ReadOnly = True
              TabOrder = 11
              OnExit = RepFExit
              TextId = 0
              ViaSBtn = False
              OnEntHookEvent = User1FEntHookEvent
            end
            object DMDCNomF: Text8Pt
              Tag = 1
              Left = 87
              Top = 160
              Width = 97
              Height = 22
              HelpContext = 108
              Color = clWhite
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clNavy
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              ReadOnly = True
              TabOrder = 6
              OnExit = DNomFExit
              TextId = 0
              ViaSBtn = False
            end
            object StaF: Text8Pt
              Tag = 1
              Left = 87
              Top = 37
              Width = 67
              Height = 22
              Hint = 
                'Double click to drill down|Double clicking or using the down but' +
                'ton will drill down to the record for this field. The up button ' +
                'will search for the nearest match.'
              HelpContext = 104
              Color = clWhite
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clNavy
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              ReadOnly = True
              TabOrder = 1
              OnExit = InvTFExit
              TextId = 0
              ViaSBtn = False
              Link_to_Cust = True
              ShowHilight = True
            end
            object TagNF: TCurrencyEdit
              Tag = 1
              Left = 87
              Top = 258
              Width = 43
              Height = 22
              HelpContext = 110
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
              ReadOnly = True
              TabOrder = 10
              WantReturns = False
              WordWrap = False
              AutoSize = False
              BlockNegative = False
              BlankOnZero = True
              DisplayFormat = '###,###,##0 ;###,###,##0-'
              DecPlaces = 0
              ShowCurrency = False
              TextId = 0
              Value = 1E-10
            end
            object PStaF: TCheckBoxEx
              Tag = 1
              Left = 8
              Top = 11
              Width = 92
              Height = 20
              HelpContext = 103
              Alignment = taLeftJustify
              Caption = 'Print Statement'
              Checked = True
              Color = clBtnFace
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentColor = False
              ParentFont = False
              State = cbChecked
              TabOrder = 0
              Modified = False
              ReadOnly = True
            end
          end
          object SBSPanel12: TSBSPanel
            Left = 121
            Top = 1
            Width = 330
            Height = 160
            BevelInner = bvRaised
            BevelOuter = bvLowered
            TabOrder = 5
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            object VATRNoF: Label8
              Left = 76
              Top = 61
              Width = 19
              Height = 14
              Alignment = taRightJustify
              Caption = ' No.'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              PopupMenu = PopupMenu1
              TextId = 0
            end
            object lblDefaultTaxCode: Label8
              Left = 15
              Top = 17
              Width = 82
              Height = 14
              Alignment = taRightJustify
              Caption = 'Default Tax Code'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              PopupMenu = PopupMenu1
              TextId = 0
            end
            object DeliveryTermsLabel: Label8
              Left = 26
              Top = 87
              Width = 71
              Height = 14
              Caption = 'Delivery Terms'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              PopupMenu = PopupMenu1
              TextId = 0
            end
            object ModeOfTransportLabel: Label8
              Left = 8
              Top = 112
              Width = 89
              Height = 14
              Alignment = taRightJustify
              Caption = 'Mode of Transport'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              PopupMenu = PopupMenu1
              TextId = 0
            end
            object chkECMember: TCheckBoxEx
              Tag = 1
              Left = 39
              Top = 37
              Width = 75
              Height = 20
              HelpContext = 107
              Alignment = taLeftJustify
              Caption = 'EC Member'
              Checked = True
              Color = clBtnFace
              ParentColor = False
              PopupMenu = PopupMenu1
              State = cbChecked
              TabOrder = 1
              OnClick = chkECMemberClick
              Modified = False
              ReadOnly = True
            end
            object VATNoF: Text8Pt
              Tag = 1
              Left = 101
              Top = 58
              Width = 138
              Height = 22
              HelpContext = 106
              CharCase = ecUpperCase
              Color = clWhite
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clNavy
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              MaxLength = 20
              ParentFont = False
              ReadOnly = True
              TabOrder = 2
              OnExit = VATNoFExit
              TextId = 0
              ViaSBtn = False
              GDPREnabled = True
            end
            object cbDefaultTaxCode: TSBSComboBox
              Tag = 1
              Left = 101
              Top = 13
              Width = 138
              Height = 22
              HelpContext = 105
              Style = csDropDownList
              Color = clWhite
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clNavy
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ItemHeight = 0
              MaxLength = 1
              ParentFont = False
              TabOrder = 0
              OnClick = cbDefaultTaxCodeExit
              OnExit = cbDefaultTaxCodeExit
              MaxListWidth = 220
              ReadOnly = True
              Validate = True
            end
            object DefaultDeliveryTerms: TSBSComboBox
              Tag = 1
              Left = 101
              Top = 83
              Width = 220
              Height = 22
              Style = csDropDownList
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ItemHeight = 0
              ParentFont = False
              TabOrder = 3
              OnExit = DefaultDeliveryTermsExit
              ExtendedList = True
              MaxListWidth = 200
              ReadOnly = True
            end
            object DefaultModeOfTransport: TSBSComboBox
              Tag = 1
              Left = 101
              Top = 108
              Width = 220
              Height = 22
              Style = csDropDownList
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ItemHeight = 0
              ParentFont = False
              TabOrder = 4
              OnExit = DefaultModeOfTransportExit
              ExtendedList = True
              MaxListWidth = 200
              ReadOnly = True
            end
            object chkDefaultToQR: TCheckBoxEx
              Tag = 1
              Left = 32
              Top = 132
              Width = 82
              Height = 20
              Alignment = taLeftJustify
              Caption = 'Default to QR'
              Color = clBtnFace
              ParentColor = False
              TabOrder = 5
              Modified = False
              ReadOnly = True
            end
          end
          object SBSPanel16: TSBSPanel
            Left = 121
            Top = 163
            Width = 330
            Height = 281
            BevelInner = bvRaised
            BevelOuter = bvLowered
            TabOrder = 6
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            object User1Lab: Label8
              Left = 26
              Top = 10
              Width = 66
              Height = 14
              Alignment = taRightJustify
              AutoSize = False
              Caption = 'UD Field 1'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              PopupMenu = PopupMenu1
              TextId = 0
            end
            object User2Lab: Label8
              Left = 26
              Top = 37
              Width = 66
              Height = 14
              Alignment = taRightJustify
              AutoSize = False
              Caption = 'UD Field 2'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              PopupMenu = PopupMenu1
              TextId = 0
            end
            object User3Lab: Label8
              Left = 26
              Top = 64
              Width = 66
              Height = 14
              Alignment = taRightJustify
              AutoSize = False
              Caption = 'UD Field 3'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              PopupMenu = PopupMenu1
              TextId = 0
            end
            object User4Lab: Label8
              Left = 26
              Top = 91
              Width = 66
              Height = 14
              Alignment = taRightJustify
              AutoSize = False
              Caption = 'UD Field 4'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              PopupMenu = PopupMenu1
              TextId = 0
            end
            object User5Lab: Label8
              Left = 26
              Top = 118
              Width = 66
              Height = 14
              Alignment = taRightJustify
              AutoSize = False
              Caption = 'UD Field 5'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              PopupMenu = PopupMenu1
              TextId = 0
            end
            object User6Lab: Label8
              Left = 26
              Top = 145
              Width = 66
              Height = 14
              Alignment = taRightJustify
              AutoSize = False
              Caption = 'UD Field 6'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              PopupMenu = PopupMenu1
              TextId = 0
            end
            object User7Lab: Label8
              Left = 26
              Top = 172
              Width = 66
              Height = 14
              Alignment = taRightJustify
              AutoSize = False
              Caption = 'UD Field 7'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              PopupMenu = PopupMenu1
              TextId = 0
            end
            object User8Lab: Label8
              Left = 26
              Top = 199
              Width = 66
              Height = 14
              Alignment = taRightJustify
              AutoSize = False
              Caption = 'UD Field 8'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              PopupMenu = PopupMenu1
              TextId = 0
            end
            object User9Lab: Label8
              Left = 26
              Top = 226
              Width = 66
              Height = 14
              Alignment = taRightJustify
              AutoSize = False
              Caption = 'UD Field 9'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              PopupMenu = PopupMenu1
              TextId = 0
            end
            object User10Lab: Label8
              Left = 26
              Top = 253
              Width = 66
              Height = 14
              Alignment = taRightJustify
              AutoSize = False
              Caption = 'UD Field 10'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              PopupMenu = PopupMenu1
              TextId = 0
            end
            object User1F: Text8Pt
              Tag = 1
              Left = 101
              Top = 7
              Width = 220
              Height = 22
              HelpContext = 383
              Color = clWhite
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clNavy
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              MaxLength = 30
              ParentFont = False
              ReadOnly = True
              TabOrder = 0
              OnExit = User1FExit
              TextId = 0
              ViaSBtn = False
              OnEntHookEvent = User1FEntHookEvent
            end
            object User2F: Text8Pt
              Tag = 1
              Left = 101
              Top = 34
              Width = 220
              Height = 22
              HelpContext = 383
              Color = clWhite
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clNavy
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              MaxLength = 30
              ParentFont = False
              ReadOnly = True
              TabOrder = 1
              OnExit = User1FExit
              TextId = 0
              ViaSBtn = False
              OnEntHookEvent = User1FEntHookEvent
            end
            object User3F: Text8Pt
              Tag = 1
              Left = 101
              Top = 61
              Width = 220
              Height = 22
              HelpContext = 383
              Color = clWhite
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clNavy
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              MaxLength = 30
              ParentFont = False
              ReadOnly = True
              TabOrder = 2
              OnExit = User1FExit
              TextId = 0
              ViaSBtn = False
              OnEntHookEvent = User1FEntHookEvent
            end
            object User4F: Text8Pt
              Tag = 1
              Left = 101
              Top = 88
              Width = 220
              Height = 22
              HelpContext = 383
              Color = clWhite
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clNavy
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              MaxLength = 30
              ParentFont = False
              ReadOnly = True
              TabOrder = 3
              OnExit = User1FExit
              TextId = 0
              ViaSBtn = False
              OnEntHookEvent = User1FEntHookEvent
            end
            object User5F: Text8Pt
              Tag = 1
              Left = 101
              Top = 115
              Width = 220
              Height = 22
              HelpContext = 383
              Color = clWhite
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clNavy
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              MaxLength = 30
              ParentFont = False
              ReadOnly = True
              TabOrder = 4
              OnExit = User1FExit
              TextId = 0
              ViaSBtn = False
              OnEntHookEvent = User1FEntHookEvent
            end
            object User6F: Text8Pt
              Tag = 1
              Left = 101
              Top = 142
              Width = 220
              Height = 22
              HelpContext = 383
              Color = clWhite
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clNavy
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              MaxLength = 30
              ParentFont = False
              ReadOnly = True
              TabOrder = 5
              OnExit = User1FExit
              TextId = 0
              ViaSBtn = False
              OnEntHookEvent = User1FEntHookEvent
            end
            object User7F: Text8Pt
              Tag = 1
              Left = 101
              Top = 169
              Width = 220
              Height = 22
              HelpContext = 383
              Color = clWhite
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clNavy
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              MaxLength = 30
              ParentFont = False
              ReadOnly = True
              TabOrder = 6
              OnExit = User1FExit
              TextId = 0
              ViaSBtn = False
              OnEntHookEvent = User1FEntHookEvent
            end
            object User8F: Text8Pt
              Tag = 1
              Left = 101
              Top = 196
              Width = 220
              Height = 22
              HelpContext = 383
              Color = clWhite
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clNavy
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              MaxLength = 30
              ParentFont = False
              ReadOnly = True
              TabOrder = 7
              OnExit = User1FExit
              TextId = 0
              ViaSBtn = False
              OnEntHookEvent = User1FEntHookEvent
            end
            object User9F: Text8Pt
              Tag = 1
              Left = 101
              Top = 223
              Width = 220
              Height = 22
              HelpContext = 383
              Color = clWhite
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clNavy
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              MaxLength = 30
              ParentFont = False
              ReadOnly = True
              TabOrder = 8
              OnExit = User1FExit
              TextId = 0
              ViaSBtn = False
              OnEntHookEvent = User1FEntHookEvent
            end
            object User10F: Text8Pt
              Tag = 1
              Left = 101
              Top = 250
              Width = 220
              Height = 22
              HelpContext = 383
              Color = clWhite
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clNavy
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              MaxLength = 30
              ParentFont = False
              ReadOnly = True
              TabOrder = 9
              OnExit = User1FExit
              TextId = 0
              ViaSBtn = False
              OnEntHookEvent = User1FEntHookEvent
            end
          end
          object SBSPanel17: TSBSPanel
            Left = -326
            Top = 313
            Width = 444
            Height = 57
            BevelInner = bvRaised
            BevelOuter = bvLowered
            TabOrder = 2
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            object Label830: Label8
              Left = 4
              Top = 7
              Width = 44
              Height = 42
              Alignment = taRightJustify
              Caption = 'Trading Terms Message'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              PopupMenu = PopupMenu1
              WordWrap = True
              TextId = 0
            end
            object CTrad1F: Text8Pt
              Tag = 1
              Left = 51
              Top = 7
              Width = 386
              Height = 22
              HelpContext = 543
              Color = clWhite
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clNavy
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              ReadOnly = True
              TabOrder = 0
              TextId = 0
              ViaSBtn = False
            end
            object CTrad2F: Text8Pt
              Tag = 1
              Left = 51
              Top = 29
              Width = 386
              Height = 22
              HelpContext = 543
              Color = clWhite
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clNavy
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              ReadOnly = True
              TabOrder = 1
              TextId = 0
              ViaSBtn = False
            end
          end
          object panOrderPayments: TSBSPanel
            Left = -326
            Top = 372
            Width = 444
            Height = 35
            BevelInner = bvRaised
            BevelOuter = bvLowered
            TabOrder = 3
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            object Label820: Label8
              Left = 218
              Top = 9
              Width = 117
              Height = 14
              HelpContext = 2207
              Alignment = taRightJustify
              Caption = 'Order Payment GL Code'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              PopupMenu = PopupMenu1
              TextId = 0
            end
            object edtOrderPaymentsGLCode: Text8Pt
              Tag = 1
              Left = 340
              Top = 6
              Width = 97
              Height = 22
              HelpContext = 2207
              Color = clWhite
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clNavy
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              ReadOnly = True
              TabOrder = 1
              OnExit = edtOrderPaymentsGLCodeExit
              TextId = 0
              ViaSBtn = False
            end
            object chkAllowOrderPayments: TCheckBoxEx
              Tag = 1
              Left = 6
              Top = 6
              Width = 128
              Height = 20
              HelpContext = 2205
              Alignment = taLeftJustify
              Caption = 'Allow Order Payments'
              Color = clBtnFace
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentColor = False
              ParentFont = False
              TabOrder = 0
              OnClick = chkAllowOrderPaymentsClick
              Modified = False
              ReadOnly = True
            end
          end
          object SBSPanel6: TSBSPanel
            Left = -326
            Top = 1
            Width = 250
            Height = 310
            BevelInner = bvRaised
            BevelOuter = bvLowered
            ParentColor = True
            TabOrder = 0
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            object Label822: Label8
              Left = 10
              Top = 4
              Width = 90
              Height = 14
              Caption = 'Delivery Address:-'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              PopupMenu = PopupMenu1
              TextId = 0
            end
            object Label823: Label8
              Left = 19
              Top = 255
              Width = 45
              Height = 27
              Alignment = taRightJustify
              AutoSize = False
              Caption = 'Their A/C for us'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              PopupMenu = PopupMenu1
              WordWrap = True
              TextId = 0
            end
            object InvoiceToLbl: Label8
              Left = 18
              Top = 286
              Width = 46
              Height = 14
              Alignment = taRightJustify
              Caption = 'Invoice to'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              PopupMenu = PopupMenu1
              TextId = 0
            end
            object ConsFLab: TLabel
              Left = 19
              Top = 187
              Width = 45
              Height = 14
              Alignment = taRightJustify
              AutoSize = False
              Caption = 'Orders'
            end
            object Label826: Label8
              Left = 37
              Top = 211
              Width = 27
              Height = 14
              Alignment = taRightJustify
              Caption = 'Locn.'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              PopupMenu = PopupMenu1
              TextId = 0
            end
            object Label828: Label8
              Left = 19
              Top = 236
              Width = 45
              Height = 14
              Alignment = taRightJustify
              AutoSize = False
              Caption = ' Form Set'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              PopupMenu = PopupMenu1
              TextId = 0
            end
            object Label821: Label8
              Left = 27
              Top = 161
              Width = 38
              Height = 14
              Caption = 'Country'
              FocusControl = PostCF
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              PopupMenu = PopupMenu1
              TextId = 0
            end
            object lblDelLine1: TLabel
              Left = 7
              Top = 22
              Width = 57
              Height = 14
              Alignment = taRightJustify
              AutoSize = False
              Caption = 'Line 1'
            end
            object lblDelLine2: TLabel
              Left = 7
              Top = 45
              Width = 57
              Height = 14
              Alignment = taRightJustify
              AutoSize = False
              Caption = 'Line 2'
            end
            object lblDelLine3: TLabel
              Left = 7
              Top = 68
              Width = 57
              Height = 14
              Alignment = taRightJustify
              AutoSize = False
              Caption = 'Line 3'
            end
            object lblDelLine4: TLabel
              Left = 7
              Top = 91
              Width = 57
              Height = 14
              Alignment = taRightJustify
              AutoSize = False
              Caption = 'Town'
            end
            object lblDelLine5: TLabel
              Left = 7
              Top = 114
              Width = 57
              Height = 14
              Alignment = taRightJustify
              AutoSize = False
              Caption = 'County'
            end
            object Label7: TLabel
              Left = 7
              Top = 137
              Width = 57
              Height = 14
              Alignment = taRightJustify
              AutoSize = False
              Caption = 'Post Code'
            end
            object DAddr1F: Text8Pt
              Tag = 1
              Left = 68
              Top = 19
              Width = 175
              Height = 22
              HelpContext = 94
              Color = clWhite
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clNavy
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              MaxLength = 30
              ParentFont = False
              ReadOnly = True
              TabOrder = 0
              OnKeyPress = DAddr1FKeyPress
              TextId = 0
              ViaSBtn = False
              GDPREnabled = True
            end
            object DAddr2F: Text8Pt
              Tag = 1
              Left = 68
              Top = 42
              Width = 175
              Height = 22
              HelpContext = 94
              Color = clWhite
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clNavy
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              MaxLength = 30
              ParentFont = False
              ReadOnly = True
              TabOrder = 1
              OnKeyPress = DAddr1FKeyPress
              TextId = 0
              ViaSBtn = False
              GDPREnabled = True
            end
            object DAddr3F: Text8Pt
              Tag = 1
              Left = 68
              Top = 65
              Width = 175
              Height = 22
              HelpContext = 94
              Color = clWhite
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clNavy
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              MaxLength = 30
              ParentFont = False
              ReadOnly = True
              TabOrder = 2
              OnKeyPress = DAddr1FKeyPress
              TextId = 0
              ViaSBtn = False
              GDPREnabled = True
            end
            object DAddr4F: Text8Pt
              Tag = 1
              Left = 68
              Top = 88
              Width = 175
              Height = 22
              HelpContext = 94
              Color = clWhite
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clNavy
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              MaxLength = 30
              ParentFont = False
              ReadOnly = True
              TabOrder = 3
              OnKeyPress = DAddr1FKeyPress
              TextId = 0
              ViaSBtn = False
              GDPREnabled = True
            end
            object DAddr5F: Text8Pt
              Tag = 1
              Left = 68
              Top = 111
              Width = 175
              Height = 22
              HelpContext = 94
              Color = clWhite
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clNavy
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              MaxLength = 30
              ParentFont = False
              ReadOnly = True
              TabOrder = 4
              OnKeyPress = DAddr1FKeyPress
              TextId = 0
              ViaSBtn = False
              GDPREnabled = True
            end
            object TOurF: Text8Pt
              Tag = 1
              Left = 68
              Top = 258
              Width = 175
              Height = 22
              HelpContext = 102
              Color = clWhite
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clNavy
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              MaxLength = 10
              ParentFont = False
              ReadOnly = True
              TabOrder = 13
              TextId = 0
              ViaSBtn = False
              GDPREnabled = True
            end
            object InvTF: Text8Pt
              Tag = 1
              Left = 68
              Top = 283
              Width = 71
              Height = 22
              Hint = 
                'Double click to drill down|Double clicking or using the down but' +
                'ton will drill down to the record for this field. The up button ' +
                'will search for the nearest match.'
              HelpContext = 254
              Color = clWhite
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clNavy
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              ReadOnly = True
              TabOrder = 14
              OnExit = InvTFExit
              TextId = 0
              ViaSBtn = False
              Link_to_Cust = True
              ShowHilight = True
            end
            object ConsolOrd: TSBSComboBox
              Tag = 1
              Left = 68
              Top = 183
              Width = 175
              Height = 22
              HelpContext = 618
              Style = csDropDownList
              Color = clWhite
              DropDownCount = 9
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clNavy
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ItemHeight = 14
              ParentFont = False
              TabOrder = 7
              Items.Strings = (
                'Use Default Settings'
                'Consolidate Deliveries'
                'Consolidate Invoices'
                'Cons Del + Invs'
                'Never Cons Deliveries'
                'Never Cons Invoices'
                'Never Del or Invs'
                'Cons Del, Never Invs'
                'Cons Invs, Never Del')
              ExtendedList = True
              MaxListWidth = 178
              ReadOnly = True
              Validate = True
            end
            object DCLocnF: Text8Pt
              Tag = 1
              Left = 68
              Top = 208
              Width = 68
              Height = 22
              HelpContext = 542
              Color = clWhite
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clNavy
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              MaxLength = 6
              ParentFont = False
              ReadOnly = True
              TabOrder = 8
              OnExit = DCLocnFExit
              TextId = 0
              ViaSBtn = False
            end
            object FrmDefF: TCurrencyEdit
              Tag = 1
              Left = 68
              Top = 233
              Width = 28
              Height = 22
              HelpContext = 541
              Color = clWhite
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clNavy
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              Lines.Strings = (
                '0')
              MaxLength = 2
              ParentFont = False
              ReadOnly = True
              TabOrder = 10
              WantReturns = False
              WordWrap = False
              OnChange = FrmDefFChange
              AutoSize = False
              BlockNegative = False
              BlankOnZero = False
              DisplayFormat = '###,###,##0 ;###,###,##0-'
              DecPlaces = 0
              ShowCurrency = False
              TextId = 0
              Value = 1
            end
            object FSetNamF: Text8Pt
              Left = 115
              Top = 233
              Width = 128
              Height = 22
              HelpContext = 541
              TabStop = False
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentColor = True
              ParentFont = False
              ReadOnly = True
              TabOrder = 12
              TextId = 0
              ViaSBtn = False
            end
            object DefUdF: TSBSUpDown
              Tag = 1
              Left = 96
              Top = 233
              Width = 15
              Height = 22
              HelpContext = 541
              Associate = FrmDefF
              ArrowKeys = False
              Enabled = False
              Min = 0
              Max = 99
              Position = 0
              TabOrder = 11
              Thousands = False
              Wrap = True
              OnMouseUp = DefUdFMouseUp
            end
            object edtPostCode: Text8Pt
              Tag = 1
              Left = 68
              Top = 134
              Width = 82
              Height = 22
              HelpContext = 94
              Color = clWhite
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clNavy
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              MaxLength = 30
              ParentFont = False
              ReadOnly = True
              TabOrder = 5
              OnKeyPress = DAddr1FKeyPress
              TextId = 0
              ViaSBtn = False
              GDPREnabled = True
            end
            object lstDeliveryCountry: TSBSComboBox
              Tag = 1
              Left = 68
              Top = 157
              Width = 175
              Height = 22
              HelpContext = 2206
              Style = csDropDownList
              Color = clWhite
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clNavy
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ItemHeight = 0
              MaxLength = 3
              ParentFont = False
              TabOrder = 6
              ExtendedList = True
              MaxListWidth = 279
              ReadOnly = True
              Validate = True
            end
            object AWOF: TCheckBoxEx
              Tag = 1
              Left = 169
              Top = 208
              Width = 74
              Height = 20
              HelpContext = 540
              Alignment = taLeftJustify
              Caption = 'Auto W/Off'
              Color = clBtnFace
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentColor = False
              ParentFont = False
              TabOrder = 9
              Modified = False
              ReadOnly = True
            end
            object HOACF: TCheckBoxEx
              Tag = 1
              Left = 163
              Top = 284
              Width = 80
              Height = 20
              HelpContext = 417
              Alignment = taLeftJustify
              Caption = 'Head Office'
              Color = clBtnFace
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentColor = False
              ParentFont = False
              TabOrder = 15
              Modified = False
              ReadOnly = True
            end
          end
          object panPPD: TSBSPanel
            Left = -326
            Top = 409
            Width = 444
            Height = 35
            HelpContext = 9000
            BevelInner = bvRaised
            BevelOuter = bvLowered
            TabOrder = 4
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            object Label2: TLabel
              Left = 6
              Top = 10
              Width = 19
              Height = 14
              HelpContext = 9000
              Alignment = taRightJustify
              Caption = 'PPD'
            end
            object Label3: TLabel
              Left = 189
              Top = 9
              Width = 47
              Height = 14
              HelpContext = 9000
              Alignment = taRightJustify
              Caption = 'Default %'
            end
            object Label4: TLabel
              Left = 311
              Top = 9
              Width = 25
              Height = 14
              HelpContext = 9000
              Alignment = taRightJustify
              Caption = 'Days'
            end
            object cbPPDOptions: TSBSComboBox
              Tag = 1
              Left = 29
              Top = 6
              Width = 137
              Height = 22
              HelpContext = 9000
              Style = csDropDownList
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clNavy
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ItemHeight = 0
              ParentFont = False
              TabOrder = 0
              OnChange = cbPPDOptionsChange
              MaxListWidth = 0
              ReadOnly = True
            end
            object cePPDPercent: TCurrencyEdit
              Tag = 1
              Left = 239
              Top = 6
              Width = 41
              Height = 22
              HelpContext = 9000
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clNavy
              Font.Height = -11
              Font.Name = 'ARIAL'
              Font.Style = []
              Lines.Strings = (
                '0.00')
              MaxLength = 5
              ParentFont = False
              ReadOnly = True
              TabOrder = 1
              WantReturns = False
              WordWrap = False
              AutoSize = False
              BlockNegative = True
              BlankOnZero = False
              DisplayFormat = '#0.00;'
              ShowCurrency = False
              TextId = 0
              Value = 1E-10
            end
            object cePPDDays: TCurrencyEdit
              Tag = 1
              Left = 340
              Top = 6
              Width = 46
              Height = 22
              HelpContext = 9000
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clNavy
              Font.Height = -11
              Font.Name = 'ARIAL'
              Font.Style = []
              Lines.Strings = (
                '0 ')
              MaxLength = 3
              ParentFont = False
              ReadOnly = True
              TabOrder = 2
              WantReturns = False
              WordWrap = False
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
        end
      end
    end
    object eCommPage: TTabSheet
      HelpContext = 65
      Caption = 'eComm'
      ImageIndex = -1
      object pnlSend: TSBSPanel
        Left = 198
        Top = 180
        Width = 179
        Height = 148
        BevelInner = bvRaised
        BevelOuter = bvLowered
        ParentColor = True
        TabOrder = 2
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        object Label860: Label8
          Left = 33
          Top = 41
          Width = 25
          Height = 14
          Caption = 'Send'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          PopupMenu = PopupMenu1
          TextId = 0
        end
        object Label862: Label8
          Left = 33
          Top = 10
          Width = 25
          Height = 14
          Caption = 'Send'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          PopupMenu = PopupMenu1
          TextId = 0
        end
        object Label863: Label8
          Left = 19
          Top = 53
          Width = 40
          Height = 14
          Caption = 'Invoices'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          PopupMenu = PopupMenu1
          TextId = 0
        end
        object Label865: Label8
          Left = 6
          Top = 21
          Width = 54
          Height = 14
          Caption = 'Statements'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          PopupMenu = PopupMenu1
          TextId = 0
        end
        object cbSendSta: TSBSComboBox
          Tag = 1
          Left = 63
          Top = 13
          Width = 109
          Height = 22
          HelpContext = 1161
          Style = csDropDownList
          Color = clWhite
          DropDownCount = 9
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ItemHeight = 14
          ParentFont = False
          TabOrder = 0
          Items.Strings = (
            'Print Hard Copy'
            'Via Fax'
            'Via email'
            'Fax & Hard Copy'
            'email & Hard Copy')
          MaxListWidth = 178
          ReadOnly = True
          Validate = True
        end
        object cbSendInv: TSBSComboBox
          Tag = 1
          Left = 63
          Top = 44
          Width = 109
          Height = 22
          HelpContext = 8080
          Style = csDropDownList
          Color = clWhite
          DropDownCount = 9
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ItemHeight = 14
          ParentFont = False
          TabOrder = 1
          Items.Strings = (
            'Print Hard Copy'
            'Via Fax'
            'Via email'
            'Fax & Hard Copy'
            'email & Hard Copy'
            'XML eBis')
          MaxListWidth = 178
          ReadOnly = True
          Validate = True
        end
        object emZipF: TSBSComboBox
          Tag = 1
          Left = 8
          Top = 119
          Width = 164
          Height = 22
          HelpContext = 1162
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
          OnChange = emZipFClick
          Items.Strings = (
            'Do not compress attachments'
            'PK-ZIP attachments'
            'EDZ attachments')
          MaxListWidth = 0
          ReadOnly = True
        end
        object emSendRF: TCheckBoxEx
          Tag = 1
          Left = 6
          Top = 70
          Width = 166
          Height = 19
          HelpContext = 1162
          Alignment = taLeftJustify
          Caption = 'Send Reader with next email'
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          TabOrder = 2
          Modified = False
          ReadOnly = True
        end
        object emSendHF: TCheckBoxEx
          Tag = 1
          Left = 6
          Top = 93
          Width = 166
          Height = 18
          HelpContext = 1162
          Alignment = taLeftJustify
          Caption = 'Send HTML with XML'
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          TabOrder = 3
          Modified = False
          ReadOnly = True
        end
      end
      object pnlBankDets: TSBSPanel
        Left = 1
        Top = 1
        Width = 376
        Height = 176
        BevelInner = bvRaised
        BevelOuter = bvLowered
        ParentColor = True
        TabOrder = 0
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        object Label838: Label8
          Left = 10
          Top = 48
          Width = 90
          Height = 14
          Caption = 'Account No / IBAN'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          PopupMenu = PopupMenu1
          TextId = 0
        end
        object Label839: Label8
          Left = 232
          Top = 48
          Width = 73
          Height = 14
          Caption = 'Sort Code / BIC'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          PopupMenu = PopupMenu1
          TextId = 0
        end
        object lblBankRef: Label8
          Left = 10
          Top = 128
          Width = 47
          Height = 14
          Caption = 'Bank Ref.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          PopupMenu = PopupMenu1
          TextId = 0
        end
        object lblPayMethod: Label8
          Left = 10
          Top = 4
          Width = 79
          Height = 14
          Caption = 'Payment Method'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          PopupMenu = PopupMenu1
          TextId = 0
        end
        object lblMandateId: Label8
          Left = 10
          Top = 89
          Width = 111
          Height = 14
          Caption = 'Direct Debit Mandate ID'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          PopupMenu = PopupMenu1
          TextId = 0
        end
        object lblMandateDate: Label8
          Left = 232
          Top = 89
          Width = 66
          Height = 14
          Caption = 'Mandate Date'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object lblDirectDebit: Label8
          Left = 232
          Top = 4
          Width = 55
          Height = 14
          Caption = 'Direct Debit'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object BankAF: Text8Pt
          Tag = 1
          Left = 10
          Top = 62
          Width = 217
          Height = 22
          HelpContext = 460
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          MaxLength = 20
          ParentFont = False
          ReadOnly = True
          TabOrder = 2
          TextId = 0
          ViaSBtn = False
          GDPREnabled = True
        end
        object BankSF: Text8Pt
          Tag = 1
          Left = 232
          Top = 62
          Width = 137
          Height = 22
          HelpContext = 460
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          MaxLength = 15
          ParentFont = False
          ReadOnly = True
          TabOrder = 3
          TextId = 0
          ViaSBtn = False
          GDPREnabled = True
        end
        object BankRF: Text8Pt
          Tag = 1
          Left = 10
          Top = 142
          Width = 217
          Height = 22
          HelpContext = 460
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          MaxLength = 28
          ParentFont = False
          ReadOnly = True
          TabOrder = 6
          TextId = 0
          ViaSBtn = False
          GDPREnabled = True
        end
        object RPayF: TSBSComboBox
          Tag = 1
          Left = 10
          Top = 20
          Width = 117
          Height = 22
          HelpContext = 1559
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
          OnChange = DDModeFEnter
          Items.Strings = (
            'Cheque'
            'BACS'
            '2 Cheque (Alt)'
            '3 Cheque (Alt)')
          MaxListWidth = 90
          ReadOnly = True
          Validate = True
        end
        object DDModeF: TSBSComboBox
          Tag = 1
          Left = 232
          Top = 20
          Width = 138
          Height = 22
          HelpContext = 1559
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
          OnEnter = DDModeFEnter
          Items.Strings = (
            'First Request'
            'On going Request'
            'Represent last Request'
            'Last Request'
            'One-off Request')
          ExtendedList = True
          MaxListWidth = 120
          ReadOnly = True
          Validate = True
        end
        object edtMandateID: Text8Pt
          Left = 10
          Top = 103
          Width = 217
          Height = 22
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
          TextId = 0
          ViaSBtn = False
          GDPREnabled = True
        end
        object edMandateDate: TEditDate
          Left = 232
          Top = 103
          Width = 137
          Height = 22
          AutoSelect = False
          EditMask = '00/00/0000;0;'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          MaxLength = 10
          ParentFont = False
          TabOrder = 5
          Placement = cpAbove
          GDPREnabled = True
          AllowBlank = True
        end
      end
      object pnlCardDets: TSBSPanel
        Left = 1
        Top = 180
        Width = 194
        Height = 148
        HelpContext = 1160
        BevelInner = bvRaised
        BevelOuter = bvLowered
        ParentColor = True
        TabOrder = 1
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        object User14Lab: Label8
          Left = 2
          Top = 95
          Width = 62
          Height = 14
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Name'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          PopupMenu = PopupMenu1
          TextId = 0
        end
        object User11Lab: Label8
          Left = 2
          Top = 11
          Width = 62
          Height = 14
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Card No.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          PopupMenu = PopupMenu1
          TextId = 0
        end
        object User15Lab: Label8
          Left = 2
          Top = 122
          Width = 62
          Height = 14
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Issue'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          PopupMenu = PopupMenu1
          TextId = 0
        end
        object User12Lab: Label8
          Left = 2
          Top = 39
          Width = 62
          Height = 14
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Valid from'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          PopupMenu = PopupMenu1
          TextId = 0
        end
        object User13Lab: Label8
          Left = 2
          Top = 67
          Width = 62
          Height = 14
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Expiry'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          PopupMenu = PopupMenu1
          TextId = 0
        end
        object CCDNameF: Text8Pt
          Tag = 1
          Left = 67
          Top = 92
          Width = 121
          Height = 22
          HelpContext = 1160
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          MaxLength = 50
          ParentFont = False
          ReadOnly = True
          TabOrder = 3
          TextId = 0
          ViaSBtn = False
        end
        object CCDCardNoF: Text8Pt
          Tag = 1
          Left = 67
          Top = 8
          Width = 121
          Height = 22
          HelpContext = 1160
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          MaxLength = 30
          ParentFont = False
          ReadOnly = True
          TabOrder = 0
          TextId = 0
          ViaSBtn = False
        end
        object CCDIssF: Text8Pt
          Tag = 1
          Left = 67
          Top = 119
          Width = 50
          Height = 22
          HelpContext = 1160
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          MaxLength = 4
          ParentFont = False
          ReadOnly = True
          TabOrder = 4
          TextId = 0
          ViaSBtn = False
        end
        object CCDSDateF: TEditDate
          Tag = 1
          Left = 67
          Top = 36
          Width = 75
          Height = 22
          HelpContext = 1160
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
          TabOrder = 1
          Placement = cpAbove
          AllowBlank = True
        end
        object CCDEDateF: TEditDate
          Tag = 1
          Left = 67
          Top = 64
          Width = 75
          Height = 22
          HelpContext = 1160
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
          TabOrder = 2
          Placement = cpAbove
          AllowBlank = True
        end
      end
      object pnlEbus: TSBSPanel
        Left = 1
        Top = 331
        Width = 376
        Height = 36
        BevelInner = bvRaised
        BevelOuter = bvLowered
        TabOrder = 3
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        object Label843: Label8
          Left = 206
          Top = 11
          Width = 78
          Height = 14
          Caption = ' Web Password'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          PopupMenu = PopupMenu1
          TextId = 0
        end
        object emWebPWrdF: Text8Pt
          Tag = 1
          Left = 292
          Top = 7
          Width = 74
          Height = 22
          HelpContext = 1163
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          MaxLength = 20
          ParentFont = False
          ReadOnly = True
          TabOrder = 1
          OnEnter = emWebPWrdFEnter
          TextId = 0
          ViaSBtn = False
          GDPREnabled = True
        end
        object emEbF: TCheckBoxEx
          Tag = 1
          Left = 8
          Top = 9
          Width = 156
          Height = 18
          HelpContext = 1163
          Alignment = taLeftJustify
          Caption = 'Use this A/C for e-Business'
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          TabOrder = 0
          OnClick = emEbFClick
          Modified = False
          ReadOnly = True
        end
      end
    end
    object RolesPage: TTabSheet
      HelpContext = 8100
      Caption = 'Roles'
      ImageIndex = -1
    end
    object NotesPage: TTabSheet
      HelpContext = 66
      Caption = 'Notes'
      ImageIndex = -1
      object TCNScrollBox: TScrollBox
        Left = 2
        Top = 2
        Width = 431
        Height = 460
        VertScrollBar.Visible = False
        TabOrder = 0
        object TNHedPanel: TSBSPanel
          Left = 2
          Top = 3
          Width = 424
          Height = 18
          BevelInner = bvLowered
          BevelOuter = bvNone
          Color = clWhite
          TabOrder = 0
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumnHeader
          object NDateLab: TSBSPanel
            Left = 2
            Top = 2
            Width = 63
            Height = 16
            BevelOuter = bvNone
            Caption = 'Date'
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
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object NDescLab: TSBSPanel
            Left = 67
            Top = 1
            Width = 284
            Height = 16
            BevelOuter = bvNone
            Caption = 'Notes'
            Color = clWhite
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 1
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object NUserLab: TSBSPanel
            Left = 354
            Top = 2
            Width = 68
            Height = 16
            BevelOuter = bvNone
            Caption = 'User'
            Color = clWhite
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 2
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
        end
        object NDatePanel: TSBSPanel
          Left = 2
          Top = 24
          Width = 65
          Height = 414
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
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object NDescPanel: TSBSPanel
          Left = 70
          Top = 24
          Width = 285
          Height = 414
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object NUserPanel: TSBSPanel
          Left = 357
          Top = 24
          Width = 70
          Height = 414
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
      end
      object TCNListBtnPanel: TSBSPanel
        Left = 436
        Top = 28
        Width = 18
        Height = 414
        BevelOuter = bvLowered
        TabOrder = 1
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
      end
    end
    object DiscountsPage: TTabSheet
      HelpContext = 67
      Caption = 'Discounts'
      ImageIndex = -1
      object CDSBox: TScrollBox
        Left = 2
        Top = 2
        Width = 431
        Height = 460
        VertScrollBar.Visible = False
        TabOrder = 0
        object CDHedPanel: TSBSPanel
          Left = 2
          Top = 3
          Width = 568
          Height = 18
          BevelInner = bvLowered
          BevelOuter = bvNone
          Color = clWhite
          TabOrder = 0
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumnHeader
          object CDSLab: TSBSPanel
            Left = 2
            Top = 1
            Width = 88
            Height = 16
            BevelOuter = bvNone
            Caption = 'Stock Code'
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
            OnMouseDown = CDSLabMouseDown
            OnMouseMove = CDSLabMouseMove
            OnMouseUp = CDSPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object CDTLab: TSBSPanel
            Left = 90
            Top = 1
            Width = 34
            Height = 16
            BevelOuter = bvNone
            Caption = 'Type'
            Color = clWhite
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 1
            OnMouseDown = CDSLabMouseDown
            OnMouseMove = CDSLabMouseMove
            OnMouseUp = CDSPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object CDULab: TSBSPanel
            Left = 124
            Top = 1
            Width = 65
            Height = 16
            BevelOuter = bvNone
            Caption = 'U/Price'
            Color = clWhite
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 2
            OnMouseDown = CDSLabMouseDown
            OnMouseMove = CDSLabMouseMove
            OnMouseUp = CDSPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object CDBLab: TSBSPanel
            Left = 189
            Top = 1
            Width = 42
            Height = 16
            BevelOuter = bvNone
            Caption = 'Band'
            Color = clWhite
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 3
            OnMouseDown = CDSLabMouseDown
            OnMouseMove = CDSLabMouseMove
            OnMouseUp = CDSPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object CDDLab: TSBSPanel
            Left = 234
            Top = 1
            Width = 61
            Height = 16
            BevelOuter = bvNone
            Caption = 'Disc%'
            Color = clWhite
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 4
            OnMouseDown = CDSLabMouseDown
            OnMouseMove = CDSLabMouseMove
            OnMouseUp = CDSPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object CDVLab: TSBSPanel
            Left = 296
            Top = 1
            Width = 61
            Height = 16
            BevelOuter = bvNone
            Caption = 'Disc (val)'
            Color = clWhite
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 5
            OnMouseDown = CDSLabMouseDown
            OnMouseMove = CDSLabMouseMove
            OnMouseUp = CDSPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object CDMLab: TSBSPanel
            Left = 361
            Top = 1
            Width = 61
            Height = 16
            BevelOuter = bvNone
            Caption = 'MU/Mg%'
            Color = clWhite
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 6
            OnMouseDown = CDSLabMouseDown
            OnMouseMove = CDSLabMouseMove
            OnMouseUp = CDSPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object CDEFFLab: TSBSPanel
            Left = 426
            Top = 1
            Width = 137
            Height = 16
            BevelOuter = bvNone
            Caption = 'Effective'
            Color = clWhite
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 7
            OnMouseDown = CDSLabMouseDown
            OnMouseMove = CDSLabMouseMove
            OnMouseUp = CDSPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
        end
        object CDSPanel: TSBSPanel
          Left = 3
          Top = 24
          Width = 87
          Height = 414
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
          OnMouseUp = CDSPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object CDTPanel: TSBSPanel
          Left = 92
          Top = 24
          Width = 31
          Height = 414
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          OnMouseUp = CDSPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object CDDPanel: TSBSPanel
          Left = 234
          Top = 24
          Width = 61
          Height = 414
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          OnMouseUp = CDSPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object CDVPanel: TSBSPanel
          Left = 298
          Top = 24
          Width = 61
          Height = 414
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
          OnMouseUp = CDSPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object CDMPanel: TSBSPanel
          Left = 362
          Top = 24
          Width = 61
          Height = 414
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 5
          OnMouseUp = CDSPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object CDUPanel: TSBSPanel
          Left = 126
          Top = 24
          Width = 61
          Height = 414
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 6
          OnMouseUp = CDSPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object CDBPanel: TSBSPanel
          Left = 190
          Top = 24
          Width = 41
          Height = 414
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 7
          OnMouseUp = CDSPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object CDEFFPanel: TSBSPanel
          Left = 426
          Top = 24
          Width = 140
          Height = 414
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 8
          OnMouseUp = CDSPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
      end
      object CDListBtnPanel: TSBSPanel
        Left = 436
        Top = 28
        Width = 18
        Height = 414
        BevelOuter = bvLowered
        TabOrder = 1
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
      end
    end
    object MultiBuyDiscountsPage: TTabSheet
      HelpContext = 8001
      Caption = 'Multi-Buy Discounts'
      ImageIndex = -1
      inline mbdFrame: TMultiBuyDiscountFrame
        Left = 0
        Top = 0
        Width = 562
        Height = 464
        Align = alClient
        TabOrder = 0
        inherited scrMBDList: TScrollBox
          Width = 431
          Height = 460
          inherited mbdHedPanel: TSBSPanel
            inherited mdLabSCode: TSBSPanel
              OnMouseDown = CLORefLabMouseDown
              OnMouseMove = CLORefLabMouseMove
              OnMouseUp = CLORefPanelMouseUp
            end
            inherited mdLabBuyQty: TSBSPanel
              OnMouseDown = CLORefLabMouseDown
              OnMouseMove = CLORefLabMouseMove
              OnMouseUp = CLORefPanelMouseUp
            end
            inherited mdLabFreeQty: TSBSPanel
              OnMouseDown = CLORefLabMouseDown
              OnMouseMove = CLORefLabMouseMove
              OnMouseUp = CLORefPanelMouseUp
            end
            inherited mdLabPurchVal: TSBSPanel
              OnMouseDown = CLORefLabMouseDown
              OnMouseMove = CLORefLabMouseMove
              OnMouseUp = CLORefPanelMouseUp
            end
            inherited mdLabDisc: TSBSPanel
              OnMouseDown = CLORefLabMouseDown
              OnMouseMove = CLORefLabMouseMove
              OnMouseUp = CLORefPanelMouseUp
            end
            inherited mdLabDates: TSBSPanel
              OnMouseDown = CLORefLabMouseDown
              OnMouseMove = CLORefLabMouseMove
              OnMouseUp = CLORefPanelMouseUp
            end
          end
          inherited mdPanSCode: TSBSPanel
            Height = 414
            Font.Name = 'Arial'
            OnMouseUp = CLORefPanelMouseUp
          end
          inherited mdPanBuyQty: TSBSPanel
            Height = 414
            Font.Name = 'Arial'
            OnMouseUp = CLORefPanelMouseUp
          end
          inherited mdPanDisc: TSBSPanel
            Height = 414
            Font.Name = 'Arial'
            OnMouseUp = CLORefPanelMouseUp
          end
          inherited mdPanFreeQty: TSBSPanel
            Height = 414
            Font.Name = 'Arial'
            OnMouseUp = CLORefPanelMouseUp
          end
          inherited mdPanPurchVal: TSBSPanel
            Height = 414
            Font.Name = 'Arial'
            OnMouseUp = CLORefPanelMouseUp
          end
          inherited mdPanDates: TSBSPanel
            Height = 414
            Font.Name = 'Arial'
            OnMouseUp = CLORefPanelMouseUp
          end
        end
        inherited mbdListBtnPanel: TSBSPanel
          Left = 436
          Height = 414
        end
        inherited mnuCopy: TPopupMenu
          Left = 294
          Top = 34
        end
      end
    end
    object LedgerPage: TTabSheet
      HelpContext = 69
      Caption = 'Ledger'
      ImageIndex = -1
      object CLSBox: TScrollBox
        Left = 2
        Top = 2
        Width = 431
        Height = 443
        VertScrollBar.Tracking = True
        VertScrollBar.Visible = False
        TabOrder = 0
        object CLHedPanel: TSBSPanel
          Left = 1
          Top = 3
          Width = 913
          Height = 19
          BevelInner = bvLowered
          BevelOuter = bvNone
          Color = clWhite
          TabOrder = 0
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumnHeader
          object CLORefLab: TSBSPanel
            Left = 2
            Top = 2
            Width = 67
            Height = 14
            BevelOuter = bvNone
            Caption = 'Our Ref'
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
            OnMouseDown = CLORefLabMouseDown
            OnMouseMove = CLORefLabMouseMove
            OnMouseUp = CLORefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object CLDateLab: TSBSPanel
            Left = 72
            Top = 2
            Width = 67
            Height = 14
            BevelOuter = bvNone
            Caption = 'Date'
            Color = clWhite
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 1
            OnMouseDown = CLORefLabMouseDown
            OnMouseMove = CLORefLabMouseMove
            OnMouseUp = CLORefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object CLAmtLab: TSBSPanel
            Left = 142
            Top = 2
            Width = 100
            Height = 14
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = 'Amount Settled'
            Color = clWhite
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 2
            OnMouseDown = CLORefLabMouseDown
            OnMouseMove = CLORefLabMouseMove
            OnMouseUp = CLORefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object CLOSLab: TSBSPanel
            Left = 244
            Top = 2
            Width = 98
            Height = 14
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = 'Outstanding'
            Color = clWhite
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 3
            OnMouseDown = CLORefLabMouseDown
            OnMouseMove = CLORefLabMouseMove
            OnMouseUp = CLORefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object CLTotLab: TSBSPanel
            Left = 344
            Top = 2
            Width = 98
            Height = 14
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = 'Total Value'
            Color = clWhite
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 4
            OnMouseDown = CLORefLabMouseDown
            OnMouseMove = CLORefLabMouseMove
            OnMouseUp = CLORefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object CLYRefLab: TSBSPanel
            Left = 542
            Top = 2
            Width = 68
            Height = 14
            BevelOuter = bvNone
            Caption = 'Your Ref'
            Color = clWhite
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 5
            OnMouseDown = CLORefLabMouseDown
            OnMouseMove = CLORefLabMouseMove
            OnMouseUp = CLORefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object CLDueLab: TSBSPanel
            Left = 614
            Top = 2
            Width = 68
            Height = 14
            BevelOuter = bvNone
            Caption = 'Date Due'
            Color = clWhite
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 6
            OnMouseDown = CLORefLabMouseDown
            OnMouseMove = CLORefLabMouseMove
            OnMouseUp = CLORefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object CLOrigLab: TSBSPanel
            Left = 449
            Top = 3
            Width = 97
            Height = 14
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = 'Original Value  '
            Color = clWhite
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 7
            OnMouseDown = CLORefLabMouseDown
            OnMouseMove = CLORefLabMouseMove
            OnMouseUp = CLORefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object CLStatLab: TSBSPanel
            Left = 689
            Top = 2
            Width = 71
            Height = 14
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = 'Status  '
            Color = clWhite
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 8
            OnMouseDown = CLORefLabMouseDown
            OnMouseMove = CLORefLabMouseMove
            OnMouseUp = CLORefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object panPPDValueHed: TSBSPanel
            Left = 761
            Top = 3
            Width = 71
            Height = 14
            BevelOuter = bvNone
            Caption = 'PPD Value'
            Color = clWhite
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 9
            OnMouseDown = CLORefLabMouseDown
            OnMouseMove = CLORefLabMouseMove
            OnMouseUp = CLORefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object panPPDExpiryHed: TSBSPanel
            Left = 832
            Top = 3
            Width = 80
            Height = 14
            BevelOuter = bvNone
            Caption = 'PPD Expiry'
            Color = clWhite
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 10
            OnMouseDown = CLORefLabMouseDown
            OnMouseMove = CLORefLabMouseMove
            OnMouseUp = CLORefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
        end
        object CLORefPanel: TSBSPanel
          Left = 1
          Top = 25
          Width = 69
          Height = 395
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
          OnMouseUp = CLORefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object CLDatePanel: TSBSPanel
          Left = 73
          Top = 25
          Width = 69
          Height = 395
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          OnMouseUp = CLORefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object CLAMTPanel: TSBSPanel
          Left = 145
          Top = 25
          Width = 98
          Height = 395
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          OnMouseUp = CLORefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object CLOSPAnel: TSBSPanel
          Left = 246
          Top = 25
          Width = 98
          Height = 395
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
          OnMouseUp = CLORefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object CLTotPanel: TSBSPanel
          Left = 347
          Top = 25
          Width = 98
          Height = 395
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 5
          OnMouseUp = CLORefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object CLYRefPanel: TSBSPanel
          Left = 549
          Top = 25
          Width = 69
          Height = 395
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 6
          OnMouseUp = CLORefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object CLDuePanel: TSBSPanel
          Left = 621
          Top = 25
          Width = 69
          Height = 395
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 7
          OnMouseUp = CLORefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object CLOrigPanel: TSBSPanel
          Left = 448
          Top = 25
          Width = 98
          Height = 395
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 8
          OnMouseUp = CLORefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object CLStatPanel: TSBSPanel
          Left = 693
          Top = 25
          Width = 69
          Height = 395
          HelpContext = 617
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 9
          OnMouseUp = CLORefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object panPPDValue: TSBSPanel
          Left = 765
          Top = 25
          Width = 69
          Height = 395
          HelpContext = 617
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 10
          OnMouseUp = CLORefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object panPPDExpiry: TSBSPanel
          Left = 837
          Top = 25
          Width = 73
          Height = 395
          HelpContext = 617
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 11
          OnMouseUp = CLORefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
      end
      object CListBtnPanel: TSBSPanel
        Left = 436
        Top = 28
        Width = 18
        Height = 395
        BevelOuter = bvLowered
        TabOrder = 1
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
      end
      object CLBotPanel: TSBSPanel
        Left = 0
        Top = 446
        Width = 562
        Height = 18
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 2
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        object TotValPanel: TSBSPanel
          Left = 371
          Top = 1
          Width = 123
          Height = 17
          BevelOuter = bvLowered
          TabOrder = 0
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          object Label817: Label8
            Left = 2
            Top = 2
            Width = 25
            Height = 14
            Hint = 
              'Show total value|Shows the total value of the currently selected' +
              ' transaction.'
            Caption = 'Total:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TextId = 0
          end
          object TotLab: Label8
            Left = 28
            Top = 2
            Width = 91
            Height = 14
            Hint = 
              'Show total value|Shows the total value of the currently selected' +
              ' transaction.'
            Alignment = taRightJustify
            AutoSize = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TextId = 0
          end
        end
        object SBSPanel11: TSBSPanel
          Left = 279
          Top = 1
          Width = 89
          Height = 17
          BevelOuter = bvLowered
          TabOrder = 1
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          object DueTit: Label8
            Left = 4
            Top = 2
            Width = 22
            Height = 14
            Hint = 
              'Show due date|Shows the payment due date for the currently selec' +
              'ted transaction.'
            Caption = 'Due:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TextId = 0
          end
          object DueLab: Label8
            Left = 28
            Top = 2
            Width = 59
            Height = 14
            Hint = 
              'Show due date|Shows the payment due date for the currently selec' +
              'ted transaction.'
            AutoSize = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TextId = 0
          end
        end
        object SBSPanel13: TSBSPanel
          Left = 192
          Top = 1
          Width = 84
          Height = 17
          BevelOuter = bvLowered
          TabOrder = 2
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          object StatusTit: Label8
            Left = 4
            Top = 2
            Width = 34
            Height = 14
            Hint = 
              'Show status|Shows the status of the currently selected transacti' +
              'on. An " A!" indicates discount available, a "Y!" indictes disco' +
              'unt taken.'
            Caption = 'Status:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TextId = 0
          end
          object StatusLab: Label8
            Left = 42
            Top = 2
            Width = 38
            Height = 14
            Hint = 
              'Show status|Shows the status of the currently selected transacti' +
              'on. An " A!" indicates discount available, a "Y!" indictes disco' +
              'unt taken.'
            AutoSize = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TextId = 0
          end
        end
        object AllocPanel: TSBSPanel
          Left = 2
          Top = 1
          Width = 170
          Height = 17
          BevelOuter = bvLowered
          TabOrder = 3
          Visible = False
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          object TotTit: Label8
            Left = 4
            Top = 2
            Width = 59
            Height = 14
            Hint = 
              'Show amount currently unallocated|Displays the amount currently ' +
              'unallocated within this ledger. Note unless in the middle of cre' +
              'ating a receipt you will not be allowed to exit until this figur' +
              'e is zero.'
            Caption = 'Unallocated:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TextId = 0
          end
          object UnalLab: Label8
            Left = 62
            Top = 2
            Width = 104
            Height = 14
            Hint = 
              'Show amount currently unallocated|Displays the amount currently ' +
              'unallocated within this ledger. Note unless in the middle of cre' +
              'ating a receipt you will not be allowed to exit until this figur' +
              'e is zero.'
            Alignment = taRightJustify
            AutoSize = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TextId = 0
          end
        end
      end
    end
    object OrdersPage: TTabSheet
      HelpContext = 70
      Caption = 'OrdersPage'
      ImageIndex = -1
      object COSBox: TScrollBox
        Left = 2
        Top = 2
        Width = 431
        Height = 460
        VertScrollBar.Tracking = True
        VertScrollBar.Visible = False
        TabOrder = 0
        object COHedPanel: TSBSPanel
          Left = 1
          Top = 3
          Width = 521
          Height = 19
          BevelInner = bvLowered
          BevelOuter = bvNone
          Color = clWhite
          TabOrder = 0
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumnHeader
          object COORefLab: TSBSPanel
            Left = 2
            Top = 2
            Width = 67
            Height = 14
            BevelOuter = bvNone
            Caption = 'Our Ref'
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
            OnMouseDown = CLORefLabMouseDown
            OnMouseMove = CLORefLabMouseMove
            OnMouseUp = CLORefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object CODateLab: TSBSPanel
            Left = 72
            Top = 2
            Width = 67
            Height = 14
            BevelOuter = bvNone
            Caption = 'Date'
            Color = clWhite
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 1
            OnMouseDown = CLORefLabMouseDown
            OnMouseMove = CLORefLabMouseMove
            OnMouseUp = CLORefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object COAMTLab: TSBSPanel
            Left = 142
            Top = 2
            Width = 100
            Height = 14
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = 'Value   '
            Color = clWhite
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 2
            OnMouseDown = CLORefLabMouseDown
            OnMouseMove = CLORefLabMouseMove
            OnMouseUp = CLORefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object COCosLab: TSBSPanel
            Left = 426
            Top = 2
            Width = 97
            Height = 14
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = 'Cost   '
            Color = clWhite
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 3
            OnMouseDown = CLORefLabMouseDown
            OnMouseMove = CLORefLabMouseMove
            OnMouseUp = CLORefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object CODisLab: TSBSPanel
            Left = 296
            Top = 2
            Width = 32
            Height = 14
            BevelOuter = bvNone
            Caption = 'Status'
            Color = clWhite
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 4
            OnMouseDown = CLORefLabMouseDown
            OnMouseMove = CLORefLabMouseMove
            OnMouseUp = CLORefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object COMarLab: TSBSPanel
            Left = 336
            Top = 2
            Width = 88
            Height = 14
            BevelOuter = bvNone
            Caption = 'Margin'
            Color = clWhite
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 5
            OnMouseDown = CLORefLabMouseDown
            OnMouseMove = CLORefLabMouseMove
            OnMouseUp = CLORefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object COGPLab: TSBSPanel
            Left = 246
            Top = 2
            Width = 45
            Height = 14
            BevelOuter = bvNone
            Caption = '%'
            Color = clWhite
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 6
            OnMouseDown = CLORefLabMouseDown
            OnMouseMove = CLORefLabMouseMove
            OnMouseUp = CLORefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
        end
        object COORefPanel: TSBSPanel
          Left = 1
          Top = 25
          Width = 69
          Height = 414
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
          OnMouseUp = CLORefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object CODatePanel: TSBSPanel
          Left = 73
          Top = 25
          Width = 69
          Height = 414
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          OnMouseUp = CLORefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object COAmtPanel: TSBSPanel
          Left = 145
          Top = 25
          Width = 98
          Height = 414
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          OnMouseUp = CLORefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object COCosPanel: TSBSPanel
          Left = 427
          Top = 25
          Width = 98
          Height = 414
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
          OnMouseUp = CLORefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object CODisPanel: TSBSPanel
          Left = 297
          Top = 25
          Width = 61
          Height = 414
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 5
          OnMouseUp = CLORefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object COMarPanel: TSBSPanel
          Left = 336
          Top = 25
          Width = 88
          Height = 414
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 6
          OnMouseUp = CLORefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object COGPPanel: TSBSPanel
          Left = 246
          Top = 25
          Width = 48
          Height = 414
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 7
          OnMouseUp = CLORefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
      end
      object COListBtnPanel: TSBSPanel
        Left = 436
        Top = 29
        Width = 18
        Height = 414
        BevelOuter = bvLowered
        TabOrder = 1
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
      end
    end
    object WorksOrdersPage: TTabSheet
      HelpContext = 133
      Caption = 'Works Orders'
      ImageIndex = -1
    end
    object JobApplicationsPage: TTabSheet
      HelpContext = 8103
      Caption = 'Job Applications'
      ImageIndex = -1
    end
    object ReturnsPage: TTabSheet
      HelpContext = 8104
      Caption = 'Returns'
      ImageIndex = -1
    end
  end
  object TCMPanel: TSBSPanel
    Left = 465
    Top = 29
    Width = 102
    Height = 462
    BevelOuter = bvNone
    ParentColor = True
    PopupMenu = PopupMenu1
    TabOrder = 1
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
    object OkCP1Btn: TButton
      Tag = 1
      Left = 2
      Top = 3
      Width = 80
      Height = 21
      Hint = 
        'Store the Record|This button allows you to store the current rec' +
        'ord during an add or edit.'
      Caption = '&OK'
      Enabled = False
      ModalResult = 1
      TabOrder = 0
      OnClick = OkCP1BtnClick
    end
    object CanCP1Btn: TButton
      Tag = 1
      Left = 2
      Top = 26
      Width = 80
      Height = 21
      Hint = 
        'Cancel record changes|Cancel any changes to the current record d' +
        'uring an add/edit.'
      Cancel = True
      Caption = '&Cancel'
      Enabled = False
      ModalResult = 2
      TabOrder = 1
      OnClick = OkCP1BtnClick
    end
    object ClsCP1Btn: TButton
      Left = 2
      Top = 49
      Width = 80
      Height = 21
      Hint = 'Close window|Closes the Customer/Supplier account window.'
      HelpContext = 24
      Cancel = True
      Caption = 'C&lose'
      ModalResult = 2
      TabOrder = 2
      OnClick = ClsCP1BtnClick
    end
    object TCMBtnScrollBox: TScrollBox
      Left = 0
      Top = 84
      Width = 105
      Height = 375
      HorzScrollBar.Visible = False
      BorderStyle = bsNone
      TabOrder = 3
      object EditCP1Btn: TButton
        Left = 2
        Top = 25
        Width = 80
        Height = 21
        Hint = 
          'Edit current record|Edit the currently displayed record. Store a' +
          'ny changes with OK, abandon with Cancel.'
        HelpContext = 75
        Caption = '&Edit'
        TabOrder = 1
        OnClick = EditCP1BtnClick
      end
      object DelCP1Btn: TButton
        Left = 2
        Top = 72
        Width = 80
        Height = 21
        Hint = 'Delete record|Delete the currently selected record.'
        HelpContext = 77
        Caption = '&Delete'
        TabOrder = 3
        OnClick = DelCP1BtnClick
      end
      object FindCP1Btn: TButton
        Left = 2
        Top = 96
        Width = 80
        Height = 21
        Hint = 'Find record.|Find a record using the ObjectFind window.'
        HelpContext = 72
        Caption = '&Find'
        TabOrder = 4
        OnClick = FindCP1BtnClick
      end
      object HistCP1Btn: TButton
        Left = 2
        Top = 120
        Width = 80
        Height = 21
        Hint = 
          'Show History balances|Displays the trading history by period, or' +
          ' margin history for Customers.'
        HelpContext = 79
        Caption = '&History'
        TabOrder = 5
        OnClick = HistCP1BtnClick
      end
      object AddCP1Btn: TButton
        Left = 2
        Top = 1
        Width = 80
        Height = 21
        Hint = 
          'Add a new record|Add a new record. Store with OK, abandon with C' +
          'ancel.'
        HelpContext = 76
        Caption = '&Add'
        TabOrder = 0
        OnClick = EditCP1BtnClick
      end
      object MACP1Btn: TButton
        Left = 2
        Top = 337
        Width = 80
        Height = 21
        Hint = 
          'Match current transaction|Displays a list of all transactions al' +
          'located against the currently highlighted transaction.'
        HelpContext = 138
        Caption = '&Match'
        TabOrder = 15
        OnClick = MACP1BtnClick
      end
      object JmpCp1Btn: TButton
        Left = 2
        Top = 361
        Width = 80
        Height = 21
        Hint = 
          'Jump to next unalloacted|Highlights the next unallocated transac' +
          'tion after the current transaction.'
        HelpContext = 139
        Caption = '&Jump'
        TabOrder = 16
        OnClick = JmpCp1BtnClick
      end
      object CopyCP1Btn: TButton
        Left = 2
        Top = 408
        Width = 80
        Height = 21
        Hint = 
          'Copy/Reverse current record|Allows the generation of a copy, or ' +
          'contra entry for the currently selected transaction.'
        HelpContext = 28
        Caption = 'Cop&y'
        TabOrder = 18
        OnClick = CopyCP1BtnClick
      end
      object ViewCP1Btn: TButton
        Left = 2
        Top = 385
        Width = 80
        Height = 21
        Hint = 
          'View current transaction|View the currently selected transaction' +
          ' without editing it, allowing list scanning.'
        HelpContext = 32
        Caption = '&View'
        TabOrder = 17
        OnClick = ViewCP1BtnClick
      end
      object ChkCP1Btn: TButton
        Left = 2
        Top = 452
        Width = 80
        Height = 21
        Hint = 
          'Check current ledger|Recalculates all balances for the currently' +
          ' selected record. Also gives option to unallocate all transactio' +
          'ns within the ledger.'
        HelpContext = 119
        Caption = 'Chec&k'
        TabOrder = 20
        OnClick = ChkCP1BtnClick
      end
      object HldCP1Btn: TButton
        Left = 2
        Top = 313
        Width = 80
        Height = 21
        Hint = 
          'Hold current transaction|Allows the currently selected transacti' +
          'on'#39's status to be changed.'
        HelpContext = 21
        Caption = '&Hold'
        TabOrder = 14
        OnClick = HldCP1BtnClick
      end
      object PrnCP1Btn: TButton
        Left = 2
        Top = 289
        Width = 80
        Height = 21
        Hint = 
          'Print this record|Gives the option to print the currently select' +
          'ed record to screen or printer.'
        HelpContext = 82
        Caption = '&Output'
        TabOrder = 13
        OnClick = PrnCP1BtnClick
      end
      object UACP1Btn: TButton
        Tag = 4
        Left = 2
        Top = 241
        Width = 80
        Height = 21
        Hint = 
          'Unallocate transaction|Unallocate the amount settled for the cur' +
          'rently selected transaction.'
        HelpContext = 137
        Caption = '--> &Unallocate'
        TabOrder = 11
        OnClick = UACP1BtnClick
      end
      object PACP1Btn: TButton
        Tag = 5
        Left = 2
        Top = 217
        Width = 80
        Height = 21
        Hint = 
          'Part allocate transaction|Part allocate a specified amount again' +
          'st the currently selected transaction.'
        HelpContext = 136
        Caption = '<?  &Part Alloc'
        TabOrder = 10
        OnClick = AlCP1BtnClick
      end
      object AlCP1Btn: TButton
        Tag = 3
        Left = 2
        Top = 193
        Width = 80
        Height = 21
        Hint = 
          'Allocate transaction|Allocates the currently selected transactio' +
          'n if there is an amount outstanding.'
        HelpContext = 43
        Caption = '<--    &Allocate'
        TabOrder = 9
        OnClick = AlCP1BtnClick
      end
      object InsCP3Btn: TButton
        Left = 2
        Top = 49
        Width = 80
        Height = 21
        Hint = 
          'Insert a record|Inserts a new record at the current line. Simila' +
          'r to Add.'
        HelpContext = 86
        Caption = '&Insert'
        TabOrder = 2
        OnClick = AddCP3BtnClick
      end
      object GenCP3Btn: TButton
        Left = 2
        Top = 144
        Width = 80
        Height = 21
        Hint = 
          'Switch Note view|Changes the notes view between dated notes and ' +
          'general notes.'
        HelpContext = 134
        Caption = 'S&witch To'
        TabOrder = 7
        OnClick = GenCP3BtnClick
      end
      object CurCP1Btn: TButton
        Left = 2
        Top = 520
        Width = 80
        Height = 21
        Hint = 
          'Change currency view|Allows the current ledger view to be change' +
          'd to another currency.'
        HelpContext = 141
        Caption = '&Currency'
        TabOrder = 23
        OnClick = CurCP1BtnClick
      end
      object LettrBtn: TButton
        Left = 2
        Top = 265
        Width = 80
        Height = 21
        Hint = 
          'Generate a Word document|Links to Word so that a new document ma' +
          'ybe produced, or an exisiting on changed for this account. '
        HelpContext = 81
        Caption = 'Li&nks'
        TabOrder = 12
        OnClick = LettrBtnClick
      end
      object SetCP1Btn: TButton
        Left = 2
        Top = 431
        Width = 80
        Height = 21
        Hint = 
          'Allocate all outstanding transactions|Automaticaly allocates as ' +
          'many outstanding transactions as possible.'
        HelpContext = 140
        Caption = '&Settle'
        TabOrder = 19
        OnClick = SetCP1BtnClick
      end
      object StatCP1Btn: TButton
        Left = 2
        Top = 474
        Width = 80
        Height = 21
        Hint = 
          'Change current status|Allows the status current record to be cha' +
          'nged.'
        HelpContext = 83
        Caption = '&Status'
        TabOrder = 21
        OnClick = StatCP1BtnClick
      end
      object DisCP1Btn: TButton
        Left = 2
        Top = 497
        Width = 80
        Height = 21
        Hint = 
          'Take settlement discount|Allows any available settlement discoun' +
          't to be taken on the currently selected record.'
        HelpContext = 461
        Caption = '&Discount'
        TabOrder = 22
        OnClick = DisCP1BtnClick
      end
      object FiltCP1Btn: TButton
        Left = 2
        Top = 543
        Width = 80
        Height = 21
        Hint = 
          'Change Ledger view|Alter the ledger display to show either all t' +
          'ransactions, or outstanding only transactions.'
        HelpContext = 462
        Caption = 'F&ilter'
        TabOrder = 24
        OnClick = FiltCP1BtnClick
      end
      object StkCCP1Btn: TButton
        Left = 2
        Top = 589
        Width = 80
        Height = 21
        Hint = 
          'View Stock Analysis|Display a list of stock items purchased by t' +
          'his account'
        HelpContext = 810
        Caption = 'Stock Anal&ysis'
        TabOrder = 26
        OnClick = StkCCP1BtnClick
      end
      object TeleSCP1Btn: TButton
        Left = 2
        Top = 612
        Width = 80
        Height = 21
        Hint = 
          'Generate Sales Order|Generate an order, invoice, or quotation fo' +
          'r this account, using the Stock Analysis list.'
        HelpContext = 780
        Caption = '&TeleSales'
        TabOrder = 27
        OnClick = StkCCP1BtnClick
      end
      object AutoCP1Btn: TButton
        Left = 2
        Top = 566
        Width = 80
        Height = 21
        Hint = 
          'Change Ledger view|Alter the ledger display to show either all t' +
          'ransactions, or auto daybook transactions.'
        HelpContext = 764
        Caption = 'Show A&uto'
        TabOrder = 25
        OnClick = AutoCP1BtnClick
      end
      object CISCP1Btn: TButton
        Left = 2
        Top = 635
        Width = 80
        Height = 21
        Hint = 
          'View Sub Contractor Ledger|Display the Sub Contractor Ledger rel' +
          'ating to this supplier.'
        Caption = 'Sub Contracto&r'
        TabOrder = 28
        OnClick = CISCP1BtnClick
      end
      object CustdbBtn1: TSBSButton
        Tag = 1
        Left = 2
        Top = 705
        Width = 80
        Height = 21
        Caption = 'Custom1'
        TabOrder = 31
        OnClick = CustdbBtn1Click
        TextId = 20
      end
      object CustdbBtn2: TSBSButton
        Tag = 2
        Left = 2
        Top = 728
        Width = 80
        Height = 21
        Caption = 'Custom2'
        TabOrder = 32
        OnClick = CustdbBtn1Click
        TextId = 21
      end
      object RetCP1Btn: TButton
        Left = 2
        Top = 658
        Width = 80
        Height = 21
        HelpContext = 1593
        Caption = '&Return'
        TabOrder = 29
        OnClick = RetCP1BtnClick
      end
      object SortCP1Btn: TButton
        Left = 2
        Top = 120
        Width = 80
        Height = 21
        Hint = 
          'Sort View options|Apply or change the column sorting for the lis' +
          't.'
        HelpContext = 8028
        Caption = 'Sort View'
        TabOrder = 6
        OnClick = SortCP1BtnClick
      end
      object CustdbBtn3: TSBSButton
        Tag = 3
        Left = 2
        Top = 751
        Width = 80
        Height = 21
        Caption = 'Custom3'
        TabOrder = 33
        OnClick = CustdbBtn1Click
        TextId = 0
      end
      object CustdbBtn4: TSBSButton
        Tag = 4
        Left = 2
        Top = 774
        Width = 80
        Height = 21
        Caption = 'Custom4'
        TabOrder = 34
        OnClick = CustdbBtn1Click
        TextId = 0
      end
      object CustdbBtn5: TSBSButton
        Tag = 5
        Left = 2
        Top = 797
        Width = 80
        Height = 21
        Caption = 'Custom5'
        TabOrder = 35
        OnClick = CustdbBtn1Click
        TextId = 0
      end
      object CustdbBtn6: TSBSButton
        Tag = 6
        Left = 2
        Top = 820
        Width = 80
        Height = 21
        Caption = 'Custom6'
        TabOrder = 36
        OnClick = CustdbBtn1Click
        TextId = 0
      end
      object btnPPDLedger: TButton
        Left = 2
        Top = 167
        Width = 80
        Height = 21
        Hint = 
          'Display PPD Ledger|Display a list of outstanding transactions wi' +
          'th PPD available'
        HelpContext = 2211
        Caption = 'PPD Led&ger'
        TabOrder = 8
        OnClick = btnPPDLedgerClick
      end
      object btnPIITree: TSBSButton
        Left = 2
        Top = 682
        Width = 80
        Height = 21
		HelpContext = 2312
        Caption = 'PII Tree'
        TabOrder = 30
        OnClick = btnPIITreeClick
        TextId = 0
      end
    end
  end
  object pnlAnonymisationStatus: TPanel
    Left = 0
    Top = 545
    Width = 587
    Height = 42
    BevelOuter = bvNone
    TabOrder = 2
    Visible = False
    object shpNotifyStatus: TShape
      Left = 5
      Top = 0
      Width = 578
      Height = 38
      Brush.Color = clRed
      Shape = stRoundRect
    end
    object lblAnonStatus: TLabel
      Left = 155
      Top = 7
      Width = 240
      Height = 24
      Alignment = taCenter
      Caption = 'Anonymised 30/09/2017'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -21
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
  end
  object PopupMenu1: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 4
    Top = 524
    object Add1: TMenuItem
      Caption = '&Add'
      Hint = 'Add a new record. Store with OK, abandon with Cancel.'
      OnClick = EditCP1BtnClick
    end
    object Edit1: TMenuItem
      Caption = '&Edit'
      Hint = 
        'Edit the currently displayed record. Store any changes with OK, ' +
        'abandon with Cancel.'
      OnClick = EditCP1BtnClick
    end
    object Insert1: TMenuItem
      Caption = '&Insert'
      Hint = 'Inserts a new record at the current line. Similar to Add.'
    end
    object Delete1: TMenuItem
      Caption = '&Delete'
      Hint = 'Delete the currently selected record.'
      OnClick = DelCP1BtnClick
    end
    object Find1: TMenuItem
      Caption = '&Find'
      Hint = 'Find a record using the ObjectFind window.'
      OnClick = FindCP1BtnClick
    end
    object SortView1: TMenuItem
      Caption = 'Sort &View'
      object RefreshView2: TMenuItem
        Caption = '&Refresh View'
        OnClick = RefreshView1Click
      end
      object CloseView2: TMenuItem
        Caption = '&Close View'
        OnClick = CloseView1Click
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object SortViewOptions2: TMenuItem
        Caption = 'Sort View &Options'
        OnClick = SortViewOptions1Click
      end
    end
    object Hist1: TMenuItem
      Caption = '&History'
      Hint = 
        'Displays the trading history by period, or margin history for Cu' +
        'stomers.'
      OnClick = HistCP1BtnClick
    end
    object Switch1: TMenuItem
      Caption = 'S&witch'
      Hint = 'Changes the notes view between dated notes and general notes.'
      OnClick = GenCP3BtnClick
    end
    object mnuoptPPDLedger: TMenuItem
      Caption = 'PP&D Ledger'
      OnClick = btnPPDLedgerClick
    end
    object All1: TMenuItem
      Tag = 3
      Caption = '&Allocate'
      Hint = 
        'Allocates the currently selected trabsaction if there is an amou' +
        'nt outstanding.'
      OnClick = AlCP1BtnClick
    end
    object PartAll1: TMenuItem
      Tag = 5
      Caption = '&Part Allocate'
      Hint = 
        'Part allocate a specified amount against the currently selected ' +
        'transaction.'
      OnClick = AlCP1BtnClick
    end
    object Unall1: TMenuItem
      Tag = 4
      Caption = '&Unallocate'
      Hint = 
        'Unallocate the amount settled for the currently selected transac' +
        'tion.'
      OnClick = UACP1BtnClick
    end
    object Letters1: TMenuItem
      Caption = 'Li&nks'
      Hint = 
        'Links to Word so that a new document maybe produced, or an exisi' +
        'ting on changed for this account. '
      OnClick = LettrBtnClick
    end
    object Output1: TMenuItem
      Caption = '&Output (Print)'
      Hint = 
        'Gives the option to print the currently selected record to scree' +
        'n or printer.'
      OnClick = PrnCP1BtnClick
    end
    object Hold1: TMenuItem
      Caption = '&Hold'
      Hint = 
        'Allows the currently selected transaction'#39's status to be changed' +
        '.'
    end
    object Match1: TMenuItem
      Caption = '&Match'
      Hint = 
        'Displays a list of all transactions allocated against the curren' +
        'tly highlighted transaction.'
      OnClick = MACP1BtnClick
    end
    object Jump1: TMenuItem
      Caption = '&Jump'
      Hint = 
        'Highlights the next unallocated transaction after the current tr' +
        'ansaction.'
      OnClick = JmpCp1BtnClick
    end
    object View1: TMenuItem
      Caption = '&View'
      Hint = 
        'View the currently selected transaction without editing it, allo' +
        'wing list scanning.'
      OnClick = ViewCP1BtnClick
    end
    object Copy1: TMenuItem
      Caption = 'Cop&y'
      Hint = 
        'Allows the generation of a copy, or contra entry for the current' +
        'ly selected transaction.'
    end
    object Settle1: TMenuItem
      Caption = '&Settle'
      Hint = 
        'Automaticaly allocates as many outstanding transactions as possi' +
        'ble.'
      OnClick = SetCP1BtnClick
    end
    object Check1: TMenuItem
      Caption = 'Chec&k'
      Hint = 
        'Recalculates all balances for the currently selected record. Als' +
        'o gives option to unallocate all transactions within the ledger.'
    end
    object Status1: TMenuItem
      Caption = '&Status'
      Hint = 'Allows the status current record to be changed.'
    end
    object Discount1: TMenuItem
      Caption = '&Discount'
      Hint = 
        'Allows any available settlement discount to be taken on the curr' +
        'ently selected record.'
      OnClick = DisCP1BtnClick
    end
    object Currency1: TMenuItem
      Caption = '&Currency'
      Hint = 
        'Allows the current ledger view to be changed to another currency' +
        '.'
      OnClick = CurCP1BtnClick
    end
    object Filter1: TMenuItem
      Caption = 'F&ilter'
      Hint = 
        'Alter the ledger display to show either all transactions, or out' +
        'standing only transactions.'
      OnClick = FiltCP1BtnClick
    end
    object ShowAuto1: TMenuItem
      Caption = 'Show A&uto'
      Hint = 
        'Alter the ledger display to show either all transactions, or Aut' +
        'o daybook transactions.'
      OnClick = AutoCP1BtnClick
    end
    object StockAnalysis1: TMenuItem
      Caption = 'Stock Anal&ysis'
      Hint = 'Display a list of stock items purchased by this account'
      OnClick = StkCCP1BtnClick
    end
    object TeleSales1: TMenuItem
      Caption = '&TeleSales'
      Hint = 
        'Generate an order, invoice, or quotation for this account, using' +
        ' the Stock Analysis list.'
      OnClick = StkCCP1BtnClick
    end
    object CISLedger1: TMenuItem
      Caption = 'Sub Contracto&r Record'
      OnClick = CISCP1BtnClick
    end
    object Return1: TMenuItem
      Caption = '&Return'
      OnClick = RetCP1BtnClick
    end
    object PIITree1: TMenuItem
      Caption = 'PII Tree'
      OnClick = btnPIITreeClick
    end
    object Custom1: TMenuItem
      Tag = 1
      Caption = 'Custom &1'
      Visible = False
      OnClick = CustdbBtn1Click
    end
    object Custom2: TMenuItem
      Tag = 2
      Caption = 'Custom &2'
      Visible = False
      OnClick = CustdbBtn1Click
    end
    object Custom3: TMenuItem
      Tag = 3
      Caption = 'Custom 3'
      OnClick = CustdbBtn1Click
    end
    object Custom4: TMenuItem
      Tag = 4
      Caption = 'Custom 4'
      OnClick = CustdbBtn1Click
    end
    object Custom5: TMenuItem
      Tag = 5
      Caption = 'Custom 5'
      OnClick = CustdbBtn1Click
    end
    object Custom6: TMenuItem
      Tag = 6
      Caption = 'Custom 6'
      OnClick = CustdbBtn1Click
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
  object PopupMenu4: TPopupMenu
    OnPopup = PopupMenu4Popup
    Left = 96
    Top = 524
    object Copy2: TMenuItem
      Tag = 1
      Caption = '&Copy Transaction'
      HelpContext = 28
      Hint = 
        'Generate an exact copy of the currently selected transaction, us' +
        'ing the next transaction number.'
      OnClick = Copy2Click
    end
    object Reverse1: TMenuItem
      Tag = 2
      Caption = '&Reverse/Contra Transaction'
      HelpContext = 28
      Hint = 
        'Generate an exact opposite (Contra)  of the currently selected t' +
        'ransaction, using the next transaction number.'
      OnClick = Copy2Click
    end
  end
  object PopupMenu6: TPopupMenu
    Left = 153
    Top = 524
    object SN1: TMenuItem
      Tag = 1
      Caption = '&See Notes'
      HelpContext = 83
      Hint = 'Set account status as "See Notes".'
      OnClick = SN1Click
    end
    object OH1: TMenuItem
      Tag = 2
      Caption = 'On &Hold'
      HelpContext = 83
      Hint = 
        'Set account status as "On Hold". When set, this account will not' +
        ' be available for selection on transscations.'
      OnClick = SN1Click
    end
    object CL1: TMenuItem
      Tag = 3
      Caption = '&Closed!'
      HelpContext = 83
      Hint = 
        'Set account status as "Closed!". When set, this account will not' +
        ' be available for selection on transscations.'
      OnClick = SN1Click
    end
    object MenuItem3: TMenuItem
      Caption = '-'
    end
    object Op1: TMenuItem
      Caption = '&Open'
      HelpContext = 83
      Hint = 'Set account status as "Open".'
      OnClick = SN1Click
    end
  end
  object PopupMenu2: TPopupMenu
    Left = 36
    Top = 524
    object Bal1: TMenuItem
      Tag = 1
      Caption = '&Balances'
      HelpContext = 79
      Hint = 
        'Shows the balance history by period for the currently selected r' +
        'ecord.'
      OnClick = Bal1Click
    end
    object Profit1: TMenuItem
      Tag = 3
      Caption = '&Profitability'
      HelpContext = 79
      Hint = 
        'Shows the profitablilty history by period for the currently sele' +
        'cted record.'
      OnClick = Bal1Click
    end
  end
  object PopupMenu5: TPopupMenu
    Left = 125
    Top = 524
    object CFrom1: TMenuItem
      Caption = '&From another account'
      HelpContext = 28
      Hint = 'Copy the discount structures from another account record.'
      OnClick = CFrom1Click
    end
    object CTo1: TMenuItem
      Caption = '&To same type accounts'
      HelpContext = 28
      Hint = 
        'Copy the discount structures from this account to all accounts o' +
        'f the same type.'
      OnClick = CTo1Click
    end
  end
  object PopupMenu3: TPopupMenu
    Left = 66
    Top = 524
    object HQ1: TMenuItem
      Tag = 1
      Caption = 'Hold for &Query'
      HelpContext = 21
      Hint = 'Mark currently selected transaction as held for query.'
      OnClick = HQ1Click
    end
    object HU1: TMenuItem
      Tag = 2
      Caption = 'Hold &until allocated'
      HelpContext = 21
      Hint = 
        'Mark currently selected transaction as held until allocated. Use' +
        'full for transactions with settlement discount available.'
      OnClick = HQ1Click
    end
    object HA1: TMenuItem
      Tag = 3
      Caption = '&Authorise'
      HelpContext = 21
      Hint = 'Mark currently selected transaction as authorised for payment.'
      OnClick = HQ1Click
    end
    object MenuItem5: TMenuItem
      Caption = '-'
    end
    object HC1: TMenuItem
      Tag = 5
      Caption = '&Cancel hold'
      HelpContext = 21
      Hint = 'Clear currently selected transaction of any hold status.'
      OnClick = HQ1Click
    end
  end
  object PopupMenu7: TPopupMenu
    Left = 181
    Top = 524
    object Account1: TMenuItem
      Tag = 5
      Caption = '&Transaction Ref'
      OnClick = Account1Click
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object OSOrders1: TMenuItem
      Tag = 1
      Caption = '&O/S Orders'
      OnClick = Account1Click
    end
    object AllOrders1: TMenuItem
      Tag = 2
      Caption = '&All Orders'
      OnClick = Account1Click
    end
    object DeliveryNotes1: TMenuItem
      Tag = 3
      Caption = '&Delivery Notes'
      OnClick = Account1Click
    end
    object N5: TMenuItem
      Caption = '-'
    end
    object NoFillter1: TMenuItem
      Tag = 4
      Caption = '&No Fillter'
      OnClick = Account1Click
    end
  end
  object PopupMenu8: TPopupMenu
    Left = 209
    Top = 524
    object Unal1: TMenuItem
      Tag = 1
      Caption = '&Unallocate individually'
      HelpContext = 83
      OnClick = Unal1Click
    end
    object UnAl2: TMenuItem
      Tag = 2
      Caption = '&Block Unallocate'
      OnClick = Unal1Click
    end
  end
  object EntCustom1: TCustomisation
    DLLId = SysDll_Ent
    Enabled = True
    ExportPath = 'X:\ENTRPRSE\CUSTOM\DEMOHOOK\Daybk1.RC'
    WindowId = 101000
    Left = 494
    Top = 522
  end
  object PopupMenu9: TPopupMenu
    Left = 237
    Top = 524
    object SCCIS1: TMenuItem
      Tag = 1
      Caption = '&CIS Ledger'
      HelpContext = 79
      Hint = 'Display a list of CIS/RCT items relating to this supplier.'
      OnClick = SCCIS1Click
    end
    object SC1: TMenuItem
      Tag = 2
      Caption = '&Sub Contractor Ledger'
      HelpContext = 79
      Hint = 
        'Shows the associated Sub Contractor Ledger for the currently sel' +
        'ected record.'
      OnClick = SC1Click
    end
    object ASC1: TMenuItem
      Tag = 1
      Caption = '&Add Sub Contractor'
      OnClick = SC1Click
    end
  end
  object PopupMenu10: TPopupMenu
    Left = 261
    Top = 524
    object DelDisc1: TMenuItem
      Caption = '&Delete this Discount'
      HelpContext = 28
      Hint = 'Delete the currently highlighted Discount Line'
      OnClick = DelDisc1Click
    end
    object DelDisc2: TMenuItem
      Tag = 1
      Caption = '&Block Delete Discounts'
      HelpContext = 28
      Hint = 
        'Block Delete Discounts Belonging to this Account by Stock Filter' +
        ' or Expiry'
      OnClick = DelDisc1Click
    end
  end
  object SortViewPopupMenu: TPopupMenu
    Left = 318
    Top = 524
    object RefreshView1: TMenuItem
      Caption = '&Refresh View'
      OnClick = RefreshView1Click
    end
    object CloseView1: TMenuItem
      Caption = '&Close View'
      OnClick = CloseView1Click
    end
    object MenuItem1: TMenuItem
      Caption = '-'
    end
    object SortViewOptions1: TMenuItem
      Caption = 'Sort View &Options'
      OnClick = SortViewOptions1Click
    end
    object N6: TMenuItem
      Caption = '-'
    end
    object Cancel1: TMenuItem
      Caption = 'Cancel'
    end
  end
  object mnuSwitchNotes: TPopupMenu
    Left = 289
    Top = 524
    object General1: TMenuItem
      Caption = '&General Notes'
      OnClick = General1Click
    end
    object Dated1: TMenuItem
      Caption = '&Dated Notes'
      OnClick = Dated1Click
    end
    object AuditHistory1: TMenuItem
      Caption = '&Audit History Notes'
      OnClick = AuditHistory1Click
    end
  end
  object WindowExport: TWindowExport
    OnEnableExport = WindowExportEnableExport
    OnExecuteCommand = WindowExportExecuteCommand
    OnGetExportDescription = WindowExportGetExportDescription
    Left = 426
    Top = 523
  end
end
