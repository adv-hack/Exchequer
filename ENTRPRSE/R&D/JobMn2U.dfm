object JobRec: TJobRec
  Left = -625
  Top = -218
  Width = 568
  Height = 427
  HelpContext = 916
  Caption = 'Job Record'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  FormStyle = fsMDIChild
  KeyPreview = True
  OldCreateOrder = True
  Position = poDefault
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
  object Label83: Label8
    Left = 294
    Top = 17
    Width = 59
    Height = 14
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'User Def 1 '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label84: Label8
    Left = 294
    Top = 43
    Width = 59
    Height = 14
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'User Def 2 '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label86: Label8
    Left = 294
    Top = 69
    Width = 59
    Height = 14
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'User Def 3 '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label87: Label8
    Left = 294
    Top = 95
    Width = 56
    Height = 14
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'User Def 4'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object PageControl1: TPageControl
    Left = 1
    Top = 0
    Width = 555
    Height = 351
    ActivePage = Ledger
    Images = ImageRepos.MulCtrlImages
    TabIndex = 2
    TabOrder = 0
    OnChange = PageControl1Change
    OnChanging = PageControl1Changing
    object Main: TTabSheet
      HelpContext = 916
      Caption = 'Main'
      ImageIndex = -1
      object TCMScrollBox: TScrollBox
        Left = -2
        Top = 0
        Width = 439
        Height = 319
        VertScrollBar.Visible = False
        BorderStyle = bsNone
        TabOrder = 0
        object SBSBackGroup1: TSBSBackGroup
          Left = 3
          Top = 0
          Width = 275
          Height = 129
          Caption = 'Job Code/Description'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          TextId = 0
        end
        object SBSBackGroup2: TSBSBackGroup
          Left = 3
          Top = 129
          Width = 275
          Height = 174
          TextId = 0
        end
        object Label828: Label8
          Left = 27
          Top = 147
          Width = 43
          Height = 14
          Caption = 'Job Type'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label829: Label8
          Left = 34
          Top = 200
          Width = 37
          Height = 14
          Caption = 'Contact'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label830: Label8
          Left = 9
          Top = 254
          Width = 61
          Height = 14
          Caption = 'Charge Type'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object SBSBackGroup4: TSBSBackGroup
          Left = 281
          Top = 1
          Width = 149
          Height = 302
          TextId = 0
        end
        object Label827: Label8
          Left = 9
          Top = 281
          Width = 62
          Height = 14
          Caption = 'Price Quoted'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label831: Label8
          Left = 288
          Top = 22
          Width = 48
          Height = 14
          Alignment = taRightJustify
          Caption = 'Start Date'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label85: Label8
          Left = 29
          Top = 20
          Width = 42
          Height = 14
          Caption = 'Job Folio'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label812: Label8
          Left = 26
          Top = 45
          Width = 45
          Height = 14
          Caption = 'Job Code'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label813: Label8
          Left = 27
          Top = 74
          Width = 44
          Height = 14
          Caption = 'Alt. Code'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label814: Label8
          Left = 17
          Top = 102
          Width = 54
          Height = 14
          Caption = 'Description'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label815: Label8
          Left = 25
          Top = 174
          Width = 46
          Height = 14
          Caption = 'Customer'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label816: Label8
          Left = 9
          Top = 227
          Width = 62
          Height = 14
          Caption = 'Job Manager'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label817: Label8
          Left = 284
          Top = 49
          Width = 52
          Height = 14
          Alignment = taRightJustify
          Caption = 'Completion'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label818: Label8
          Left = 297
          Top = 77
          Width = 39
          Height = 14
          Alignment = taRightJustify
          Caption = 'Revised'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Bevel1: TBevel
          Left = 289
          Top = 104
          Width = 134
          Height = 2
        end
        object Label819: Label8
          Left = 285
          Top = 147
          Width = 51
          Height = 14
          Alignment = taRightJustify
          Caption = 'Job Status'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label820: Label8
          Left = 291
          Top = 175
          Width = 45
          Height = 14
          Alignment = taRightJustify
          Caption = 'SOR Ref.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object SBSBackGroup3: TSBSBackGroup
          Left = 433
          Top = 1
          Width = 336
          Height = 302
          TextId = 0
        end
        object Label82: Label8
          Left = 285
          Top = 121
          Width = 51
          Height = 14
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'QS Code '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object User1Lab: Label8
          Left = 438
          Top = 17
          Width = 56
          Height = 14
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'User Def 1 '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object User2Lab: Label8
          Left = 438
          Top = 42
          Width = 56
          Height = 14
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'User Def 2 '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object User3Lab: Label8
          Left = 438
          Top = 68
          Width = 56
          Height = 14
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'User Def 3 '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object User4Lab: Label8
          Left = 438
          Top = 93
          Width = 56
          Height = 14
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'User Def 4'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label81: Label8
          Left = 285
          Top = 280
          Width = 40
          Height = 14
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Curr'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object CCLbl: Label8
          Left = 287
          Top = 201
          Width = 49
          Height = 14
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'CC'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object User5Lab: Label8
          Left = 438
          Top = 119
          Width = 56
          Height = 14
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'User Def 5'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object User6Lab: Label8
          Left = 438
          Top = 145
          Width = 56
          Height = 14
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'User Def 6'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object User7Lab: Label8
          Left = 438
          Top = 171
          Width = 56
          Height = 14
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'User Def 7'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object User8Lab: Label8
          Left = 438
          Top = 197
          Width = 56
          Height = 14
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'User Def 8'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object User9Lab: Label8
          Left = 438
          Top = 223
          Width = 56
          Height = 14
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'User Def 9'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object User10Lab: Label8
          Left = 438
          Top = 248
          Width = 60
          Height = 14
          AutoSize = False
          Caption = 'User Def 10'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object DeptLbl: Label8
          Left = 307
          Top = 227
          Width = 29
          Height = 14
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Dept'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object VATLbl: TLabel
          Left = 316
          Top = 252
          Width = 20
          Height = 14
          Alignment = taRightJustify
          Caption = 'VAT'
        end
        object JFolF: Text8Pt
          Left = 75
          Top = 18
          Width = 114
          Height = 22
          HelpContext = 831
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
          TabOrder = 0
          TextId = 0
          ViaSBtn = False
        end
        object SRVMF: TSBSComboBox
          Tag = 1
          Left = 75
          Top = 251
          Width = 146
          Height = 22
          HelpContext = 839
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
          MaxListWidth = 77
          ReadOnly = True
          Validate = True
        end
        object SRCF: Text8Pt
          Tag = 1
          Left = 75
          Top = 45
          Width = 114
          Height = 22
          HelpContext = 832
          Color = clWhite
          EditMask = '>cccccccccc;0;_'
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
          TabOrder = 1
          OnEnter = SRCFEnter
          OnExit = SRCFExit
          TextId = 0
          ViaSBtn = False
        end
        object JacF: Text8Pt
          Tag = 1
          Left = 75
          Top = 72
          Width = 114
          Height = 22
          HelpContext = 833
          Color = clWhite
          EditMask = '>cccccccccc;0;_'
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
          TabOrder = 2
          TextId = 0
          ViaSBtn = False
        end
        object JDeF: Text8Pt
          Tag = 1
          Left = 75
          Top = 99
          Width = 195
          Height = 22
          HelpContext = 834
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          MaxLength = 30
          ParentFont = False
          ParentShowHint = False
          ReadOnly = True
          ShowHint = True
          TabOrder = 3
          TextId = 0
          ViaSBtn = False
          GDPREnabled = True
        end
        object JTyF: Text8Pt
          Tag = 1
          Left = 75
          Top = 143
          Width = 35
          Height = 22
          HelpContext = 835
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
          TabOrder = 4
          OnExit = JTyFExit
          TextId = 0
          ViaSBtn = False
        end
        object JTDF: Text8Pt
          Left = 139
          Top = 143
          Width = 131
          Height = 22
          HelpContext = 835
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
          TabOrder = 5
          TextId = 0
          ViaSBtn = False
        end
        object JACCF: Text8Pt
          Tag = 1
          Left = 75
          Top = 170
          Width = 59
          Height = 22
          Hint = 
            'Double click to drill down|Double clicking or using the down but' +
            'ton will drill down to the record for this field. The up button ' +
            'will search for the nearest match.'
          HelpContext = 836
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
          TabOrder = 6
          OnExit = JACCFExit
          TextId = 0
          ViaSBtn = False
          Link_to_Cust = True
          ShowHilight = True
        end
        object JACDF: Text8Pt
          Left = 139
          Top = 170
          Width = 131
          Height = 22
          HelpContext = 836
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
          TabOrder = 7
          OnDblClick = JACDFDblClick
          TextId = 0
          ViaSBtn = False
          GDPREnabled = True
        end
        object JCOF: Text8Pt
          Tag = 1
          Left = 75
          Top = 197
          Width = 195
          Height = 22
          HelpContext = 837
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          MaxLength = 25
          ParentFont = False
          ParentShowHint = False
          ReadOnly = True
          ShowHint = True
          TabOrder = 8
          OnDblClick = JACDFDblClick
          TextId = 0
          ViaSBtn = False
          GDPREnabled = True
        end
        object JMGF: Text8Pt
          Tag = 1
          Left = 75
          Top = 224
          Width = 195
          Height = 22
          HelpContext = 838
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          MaxLength = 25
          ParentFont = False
          ParentShowHint = False
          ReadOnly = True
          ShowHint = True
          TabOrder = 9
          OnExit = JMGFExit
          TextId = 0
          ViaSBtn = False
          GDPREnabled = True
        end
        object SRSPC1F: TSBSComboBox
          Tag = 1
          Left = 75
          Top = 278
          Width = 48
          Height = 22
          HelpContext = 1006
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
          ExtendedList = True
          MaxListWidth = 90
          ReadOnly = True
          Validate = True
        end
        object SRSP1F: TCurrencyEdit
          Tag = 1
          Left = 126
          Top = 278
          Width = 95
          Height = 22
          HelpContext = 1006
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Lines.Strings = (
            '0.00 ')
          MaxLength = 13
          ParentFont = False
          ReadOnly = True
          TabOrder = 12
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
        object JSDF: TEditDate
          Tag = 1
          Left = 340
          Top = 18
          Width = 81
          Height = 22
          HelpContext = 840
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
          TabOrder = 13
          Placement = cpAbove
          AllowBlank = True
        end
        object JFDF: TEditDate
          Tag = 1
          Left = 340
          Top = 45
          Width = 81
          Height = 22
          HelpContext = 840
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
          TabOrder = 14
          Placement = cpAbove
          AllowBlank = True
        end
        object JRDF: TEditDate
          Tag = 1
          Left = 340
          Top = 72
          Width = 81
          Height = 22
          HelpContext = 840
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
          TabOrder = 15
          Placement = cpAbove
          AllowBlank = True
        end
        object JSTF: Text8Pt
          Tag = 1
          Left = 340
          Top = 143
          Width = 81
          Height = 22
          HelpContext = 841
          TabStop = False
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
          TextId = 0
          ViaSBtn = False
        end
        object JSOF: Text8Pt
          Tag = 1
          Left = 340
          Top = 170
          Width = 81
          Height = 22
          HelpContext = 970
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          MaxLength = 9
          ParentFont = False
          ParentShowHint = False
          ReadOnly = True
          ShowHint = True
          TabOrder = 18
          OnDblClick = JSOFDblClick
          OnExit = JSOFExit
          TextId = 0
          ViaSBtn = False
        end
        object JQSCodeF: Text8Pt
          Tag = 1
          Left = 340
          Top = 117
          Width = 81
          Height = 22
          HelpContext = 1538
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          MaxLength = 20
          ParentFont = False
          ParentShowHint = False
          ReadOnly = True
          ShowHint = True
          TabOrder = 16
          OnExit = JUD1FExit
          TextId = 0
          ViaSBtn = False
          OnEntHookEvent = JUD1FEntHookEvent
        end
        object JUD1F: Text8Pt
          Tag = 1
          Left = 498
          Top = 12
          Width = 176
          Height = 22
          HelpContext = 383
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          MaxLength = 20
          ParentFont = False
          ParentShowHint = False
          ReadOnly = True
          ShowHint = True
          TabOrder = 23
          OnExit = JUD1FExit
          TextId = 0
          ViaSBtn = False
          OnEntHookEvent = JUD1FEntHookEvent
        end
        object JUD3F: Text8Pt
          Tag = 1
          Left = 498
          Top = 64
          Width = 176
          Height = 22
          HelpContext = 383
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          MaxLength = 20
          ParentFont = False
          ParentShowHint = False
          ReadOnly = True
          ShowHint = True
          TabOrder = 25
          OnExit = JUD1FExit
          TextId = 0
          ViaSBtn = False
          OnEntHookEvent = JUD1FEntHookEvent
        end
        object JUD4F: Text8Pt
          Tag = 1
          Left = 498
          Top = 90
          Width = 176
          Height = 22
          HelpContext = 383
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          MaxLength = 20
          ParentFont = False
          ParentShowHint = False
          ReadOnly = True
          ShowHint = True
          TabOrder = 26
          OnExit = JUD1FExit
          TextId = 0
          ViaSBtn = False
          OnEntHookEvent = JUD1FEntHookEvent
        end
        object JUD2F: Text8Pt
          Tag = 1
          Left = 498
          Top = 38
          Width = 176
          Height = 22
          HelpContext = 383
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          MaxLength = 20
          ParentFont = False
          ParentShowHint = False
          ReadOnly = True
          ShowHint = True
          TabOrder = 24
          OnExit = JUD1FExit
          TextId = 0
          ViaSBtn = False
          OnEntHookEvent = JUD1FEntHookEvent
        end
        object CurrF: TSBSComboBox
          Tag = 1
          Left = 329
          Top = 275
          Width = 93
          Height = 22
          HelpContext = 1068
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
          TabOrder = 22
          TabStop = False
          ExtendedList = True
          MaxListWidth = 90
          ReadOnly = True
          Validate = True
        end
        object T2VATF: TSBSComboBox
          Tag = 1
          Left = 340
          Top = 249
          Width = 40
          Height = 22
          HelpContext = 1152
          Style = csDropDownList
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ItemHeight = 14
          MaxLength = 1
          ParentFont = False
          TabOrder = 21
          TabStop = False
          AllowChangeInExit = True
          ExtendedList = True
          MaxListWidth = 75
          ReadOnly = True
          Validate = True
        end
        object Id3CCF: Text8Pt
          Tag = 1
          Left = 340
          Top = 197
          Width = 46
          Height = 22
          HelpContext = 8067
          TabStop = False
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
          TabOrder = 19
          OnExit = Id3CCFExit
          TextId = 0
          ViaSBtn = False
        end
        object Id3DepF: Text8Pt
          Tag = 1
          Left = 340
          Top = 223
          Width = 46
          Height = 22
          HelpContext = 8068
          TabStop = False
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
          TabOrder = 20
          OnExit = Id3CCFExit
          TextId = 0
          ViaSBtn = False
        end
        object JUD5F: Text8Pt
          Tag = 1
          Left = 498
          Top = 116
          Width = 262
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
          ParentShowHint = False
          ReadOnly = True
          ShowHint = True
          TabOrder = 27
          OnExit = JUD1FExit
          TextId = 0
          ViaSBtn = False
          OnEntHookEvent = JUD1FEntHookEvent
        end
        object JUD6F: Text8Pt
          Tag = 1
          Left = 498
          Top = 142
          Width = 262
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
          ParentShowHint = False
          ReadOnly = True
          ShowHint = True
          TabOrder = 28
          OnExit = JUD1FExit
          TextId = 0
          ViaSBtn = False
          OnEntHookEvent = JUD1FEntHookEvent
        end
        object JUD7F: Text8Pt
          Tag = 1
          Left = 498
          Top = 168
          Width = 262
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
          ParentShowHint = False
          ReadOnly = True
          ShowHint = True
          TabOrder = 29
          OnExit = JUD1FExit
          TextId = 0
          ViaSBtn = False
          OnEntHookEvent = JUD1FEntHookEvent
        end
        object JUD10F: Text8Pt
          Tag = 1
          Left = 498
          Top = 246
          Width = 262
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
          ParentShowHint = False
          ReadOnly = True
          ShowHint = True
          TabOrder = 32
          OnExit = JUD1FExit
          TextId = 0
          ViaSBtn = False
          OnEntHookEvent = JUD1FEntHookEvent
        end
        object JUD9F: Text8Pt
          Tag = 1
          Left = 498
          Top = 220
          Width = 262
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
          ParentShowHint = False
          ReadOnly = True
          ShowHint = True
          TabOrder = 31
          OnExit = JUD1FExit
          TextId = 0
          ViaSBtn = False
          OnEntHookEvent = JUD1FEntHookEvent
        end
        object JUD8F: Text8Pt
          Tag = 1
          Left = 498
          Top = 194
          Width = 262
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
          ParentShowHint = False
          ReadOnly = True
          ShowHint = True
          TabOrder = 30
          OnExit = JUD1FExit
          TextId = 0
          ViaSBtn = False
          OnEntHookEvent = JUD1FEntHookEvent
        end
      end
    end
    object Notes: TTabSheet
      HelpContext = 844
      Caption = 'Notes'
      ImageIndex = -1
      object TCNScrollBox: TScrollBox
        Left = 3
        Top = 3
        Width = 414
        Height = 291
        VertScrollBar.Visible = False
        TabOrder = 0
        object TNHedPanel: TSBSPanel
          Left = 2
          Top = 3
          Width = 412
          Height = 19
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
            Width = 65
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
            Top = 2
            Width = 266
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
            Left = 337
            Top = 2
            Width = 66
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
          Top = 26
          Width = 65
          Height = 243
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
          Top = 26
          Width = 265
          Height = 243
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
          Left = 338
          Top = 26
          Width = 70
          Height = 243
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
        Left = 421
        Top = 30
        Width = 18
        Height = 240
        BevelOuter = bvLowered
        TabOrder = 1
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
      end
    end
    object Ledger: TTabSheet
      HelpContext = 975
      Caption = 'Ledger'
      ImageIndex = -1
      object CLSBox: TScrollBox
        Left = 3
        Top = 3
        Width = 414
        Height = 291
        VertScrollBar.Tracking = True
        VertScrollBar.Visible = False
        TabOrder = 0
        object CLHedPanel: TSBSPanel
          Left = 2
          Top = 3
          Width = 610
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
            Width = 45
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
            Left = 81
            Top = 2
            Width = 60
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
          object CLOOLab: TSBSPanel
            Left = 360
            Top = 2
            Width = 82
            Height = 14
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = 'Charge  '
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
          object CLQOLab: TSBSPanel
            Left = 231
            Top = 2
            Width = 43
            Height = 14
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = 'Hrs/Qty'
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
          object CLALLab: TSBSPanel
            Left = 275
            Top = 2
            Width = 82
            Height = 14
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = 'Cost  '
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
          object CLACLab: TSBSPanel
            Left = 142
            Top = 2
            Width = 88
            Height = 14
            BevelOuter = bvNone
            Caption = 'Analysis'
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
          object CLUPLab: TSBSPanel
            Left = 445
            Top = 2
            Width = 82
            Height = 14
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = 'Uplift  '
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
          object CLACCLab: TSBSPanel
            Left = 530
            Top = 2
            Width = 66
            Height = 14
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = 'A/C Code'
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
        end
        object CLORefPanel: TSBSPanel
          Left = 3
          Top = 25
          Width = 78
          Height = 245
          HelpContext = 142
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
          Left = 83
          Top = 25
          Width = 60
          Height = 245
          HelpContext = 143
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
        object CLOOPanel: TSBSPanel
          Left = 362
          Top = 25
          Width = 84
          Height = 245
          HelpContext = 979
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
        object CLQOPanel: TSBSPanel
          Left = 234
          Top = 25
          Width = 43
          Height = 245
          HelpContext = 977
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
        object CLALPanel: TSBSPanel
          Left = 279
          Top = 25
          Width = 81
          Height = 245
          HelpContext = 978
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
        object CLAcPanel: TSBSPanel
          Left = 145
          Top = 25
          Width = 87
          Height = 245
          HelpContext = 976
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
        object CLUPPanel: TSBSPanel
          Left = 448
          Top = 25
          Width = 84
          Height = 245
          HelpContext = 979
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
        object CLACCPanel: TSBSPanel
          Left = 534
          Top = 24
          Width = 67
          Height = 245
          HelpContext = 1574
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
      end
      object CListBtnPanel: TSBSPanel
        Left = 421
        Top = 30
        Width = 18
        Height = 240
        BevelOuter = bvLowered
        TabOrder = 1
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
      end
    end
    object Reten: TTabSheet
      HelpContext = 943
      Caption = 'Purchase Retentions'
      ImageIndex = -1
      object RTSBox: TScrollBox
        Left = 3
        Top = 3
        Width = 414
        Height = 291
        VertScrollBar.Tracking = True
        VertScrollBar.Visible = False
        TabOrder = 0
        object RTHedPanel: TSBSPanel
          Left = 2
          Top = 3
          Width = 407
          Height = 19
          BevelInner = bvLowered
          BevelOuter = bvNone
          Color = clWhite
          TabOrder = 0
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumnHeader
          object RTACLab: TSBSPanel
            Left = 2
            Top = 2
            Width = 54
            Height = 14
            BevelOuter = bvNone
            Caption = 'A/C Code'
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
          object RTDTLab: TSBSPanel
            Left = 136
            Top = 2
            Width = 60
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
          object RTEXLab: TSBSPanel
            Left = 199
            Top = 2
            Width = 64
            Height = 14
            BevelOuter = bvNone
            Caption = 'Expires'
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
          object RTAMLab: TSBSPanel
            Left = 265
            Top = 2
            Width = 90
            Height = 14
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = 'Retention Amount'
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
          object RTORefLab: TSBSPanel
            Left = 59
            Top = 2
            Width = 76
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
            TabOrder = 4
            OnMouseDown = CLORefLabMouseDown
            OnMouseMove = CLORefLabMouseMove
            OnMouseUp = CLORefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object RTStLab: TSBSPanel
            Left = 358
            Top = 2
            Width = 50
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
            TabOrder = 5
            OnMouseDown = CLORefLabMouseDown
            OnMouseMove = CLORefLabMouseMove
            OnMouseUp = CLORefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
        end
        object RTACPanel: TSBSPanel
          Left = 3
          Top = 25
          Width = 57
          Height = 245
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
        object RTDTPanel: TSBSPanel
          Left = 139
          Top = 25
          Width = 60
          Height = 245
          HelpContext = 143
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
        object RTExPanel: TSBSPanel
          Left = 201
          Top = 25
          Width = 65
          Height = 245
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
        object RTAMPanel: TSBSPanel
          Left = 268
          Top = 25
          Width = 90
          Height = 245
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
        object RTORefPanel: TSBSPanel
          Left = 62
          Top = 25
          Width = 75
          Height = 245
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
        object RTSTPanel: TSBSPanel
          Left = 360
          Top = 25
          Width = 50
          Height = 245
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
      end
    end
    object SalReten: TTabSheet
      HelpContext = 943
      Caption = 'Sales Retentions'
      ImageIndex = -1
    end
    object SubTerm: TTabSheet
      Caption = 'Sub Contract Terms'
      ImageIndex = -1
    end
    object PApps: TTabSheet
      Caption = 'Spare'
      ImageIndex = -1
    end
    object Apps: TTabSheet
      Caption = 'Sales Terms'
      ImageIndex = -1
    end
  end
  object TCMPanel: TSBSPanel
    Left = 446
    Top = 29
    Width = 102
    Height = 287
    BevelOuter = bvNone
    PopupMenu = PopupMenu1
    TabOrder = 1
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
    object I1StatLab: Label8
      Left = 3
      Top = 3
      Width = 95
      Height = 49
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
    object OkCP1Btn: TButton
      Tag = 1
      Left = 2
      Top = 3
      Width = 80
      Height = 21
      HelpContext = 257
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
      HelpContext = 258
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
      HelpContext = 843
      Cancel = True
      Caption = 'C&lose'
      ModalResult = 2
      TabOrder = 2
      OnClick = ClsCP1BtnClick
    end
    object TCMBtnScrollBox: TScrollBox
      Left = 0
      Top = 84
      Width = 99
      Height = 199
      HorzScrollBar.Visible = False
      BorderStyle = bsNone
      TabOrder = 3
      object EditCP1Btn: TButton
        Left = 2
        Top = 25
        Width = 80
        Height = 21
        HelpContext = 155
        Caption = '&Edit'
        TabOrder = 1
        OnClick = EditCP1BtnClick
      end
      object DelCP1Btn: TButton
        Left = 2
        Top = 72
        Width = 80
        Height = 21
        HelpContext = 159
        Caption = '&Delete'
        TabOrder = 3
        OnClick = DelCP1BtnClick
      end
      object FindCP1Btn: TButton
        Left = 2
        Top = 96
        Width = 80
        Height = 21
        HelpContext = 165
        Caption = '&Find'
        TabOrder = 4
        OnClick = FindCP1BtnClick
      end
      object HistCP1Btn: TButton
        Left = 2
        Top = 120
        Width = 80
        Height = 21
        HelpContext = 1506
        Caption = '&Terms'
        TabOrder = 5
        OnClick = HistCP1BtnClick
      end
      object CopyCP1Btn: TButton
        Left = 2
        Top = 214
        Width = 80
        Height = 21
        HelpContext = 186
        Caption = 'Cop&y'
        TabOrder = 9
        OnClick = CopyCP1BtnClick
      end
      object ViewCP1Btn: TButton
        Left = 2
        Top = 191
        Width = 80
        Height = 21
        HelpContext = 154
        Caption = '&View'
        TabOrder = 8
        OnClick = ViewCP1BtnClick
      end
      object PrnCP1Btn: TButton
        Left = 2
        Top = 168
        Width = 80
        Height = 21
        HelpContext = 163
        Caption = '&Print'
        TabOrder = 7
        OnClick = PrnCP1BtnClick
      end
      object InsCP1Btn: TButton
        Left = 2
        Top = 49
        Width = 80
        Height = 21
        HelpContext = 86
        Caption = '&Insert'
        TabOrder = 2
        OnClick = EditCP1BtnClick
      end
      object GenCP3Btn: TButton
        Left = 2
        Top = 144
        Width = 80
        Height = 21
        HelpContext = 90
        Caption = '&Switch To'
        TabOrder = 6
        OnClick = GenCP3BtnClick
      end
      object LnkCp1Btn: TButton
        Left = 2
        Top = 237
        Width = 80
        Height = 21
        Hint = 
          'Link to additional information|Displays a list of any additional' +
          ' information attached to this Stock Record.'
        Caption = 'Lin&ks'
        TabOrder = 10
        OnClick = LnkCp1BtnClick
      end
      object ChkCP1Btn: TButton
        Left = 2
        Top = 284
        Width = 80
        Height = 21
        Hint = 'Recalculate Job Posted Total|Recalculate Job Posted Totals'
        HelpContext = 88
        Caption = 'C&heck'
        TabOrder = 12
        OnClick = ChkCP1BtnClick
      end
      object AddCP1Btn: TButton
        Left = 2
        Top = 1
        Width = 80
        Height = 21
        HelpContext = 156
        Caption = '&Add'
        TabOrder = 0
        OnClick = EditCP1BtnClick
      end
      object StatCp1Btn: TButton
        Left = 2
        Top = 307
        Width = 80
        Height = 21
        Hint = 
          'Change Job Status|Allows the Job Status to be changed from activ' +
          'e (open) to Completed/Closed'
        HelpContext = 841
        Caption = 'Stat&us'
        TabOrder = 13
        OnClick = StatCp1BtnClick
      end
      object CustdbBtn1: TSBSButton
        Tag = 1
        Left = 2
        Top = 353
        Width = 80
        Height = 21
        Caption = 'Custom1'
        TabOrder = 15
        OnClick = CustdbBtn1Click
        TextId = 1
      end
      object CustdbBtn2: TSBSButton
        Tag = 2
        Left = 2
        Top = 376
        Width = 80
        Height = 21
        Caption = 'Custom2'
        TabOrder = 16
        OnClick = CustdbBtn1Click
        TextId = 2
      end
      object TRCP1Btn: TButton
        Left = 2
        Top = 330
        Width = 80
        Height = 21
        Hint = 
          'Access Job Specific Time Rates|Displays any Time Rates attached ' +
          'to this record.'
        HelpContext = 841
        Caption = 'Time &Rates'
        TabOrder = 14
        OnClick = TRCP1BtnClick
      end
      object SortViewBtn: TButton
        Left = 2
        Top = 261
        Width = 80
        Height = 21
        Hint = 
          'Sort View options|Apply or change the column sorting for the lis' +
          't.'
        HelpContext = 8028
        Caption = 'Sort Vie&w'
        TabOrder = 11
        OnClick = SortViewBtnClick
      end
      object CustdbBtn3: TSBSButton
        Tag = 3
        Left = 2
        Top = 399
        Width = 80
        Height = 21
        Caption = 'Custom3'
        TabOrder = 17
        OnClick = CustdbBtn1Click
        TextId = 0
      end
      object CustdbBtn4: TSBSButton
        Tag = 4
        Left = 2
        Top = 422
        Width = 80
        Height = 21
        Caption = 'Custom4'
        TabOrder = 18
        OnClick = CustdbBtn1Click
        TextId = 0
      end
      object CustdbBtn5: TSBSButton
        Tag = 5
        Left = 2
        Top = 445
        Width = 80
        Height = 21
        Caption = 'Custom5'
        TabOrder = 19
        OnClick = CustdbBtn1Click
        TextId = 0
      end
      object CustdbBtn6: TSBSButton
        Tag = 6
        Left = 2
        Top = 468
        Width = 80
        Height = 21
        Caption = 'Custom6'
        TabOrder = 20
        OnClick = CustdbBtn1Click
        TextId = 0
      end
    end
  end
  object pnlAnonymisationStatus: TPanel
    Left = -27
    Top = 356
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
    Left = 192
    Top = 64
    object Add1: TMenuItem
      Caption = '&Add'
      OnClick = EditCP1BtnClick
    end
    object Edit1: TMenuItem
      Caption = '&Edit'
      OnClick = EditCP1BtnClick
    end
    object Insert1: TMenuItem
      Caption = '&Insert'
      OnClick = EditCP1BtnClick
    end
    object Delete1: TMenuItem
      Caption = '&Delete'
      OnClick = DelCP1BtnClick
    end
    object Find1: TMenuItem
      Caption = '&Find'
      OnClick = FindCP1BtnClick
    end
    object Hist1: TMenuItem
      Caption = '&Terms'
    end
    object Switch1: TMenuItem
      Caption = 'S&witch'
      OnClick = GenCP3BtnClick
    end
    object Print1: TMenuItem
      Caption = '&Print'
      OnClick = PrnCP1BtnClick
    end
    object View1: TMenuItem
      Caption = '&View'
      OnClick = ViewCP1BtnClick
    end
    object Copy1: TMenuItem
      Caption = 'Cop&y'
      OnClick = CopyCP1BtnClick
    end
    object Links1: TMenuItem
      Caption = 'Lin&ks'
      Hint = 
        'Displays a list of any additional information attached to this S' +
        'tock Record.'
      OnClick = LnkCp1BtnClick
    end
    object SortView1: TMenuItem
      Caption = 'Sort Vie&w'
      Hint = 
        'Sort View options|Apply or change the column sorting for the lis' +
        't.'
      object RefreshView2: TMenuItem
        Caption = '&Refresh View'
        OnClick = RefreshView1Click
      end
      object CloseView2: TMenuItem
        Caption = '&Close View'
        OnClick = CloseView1Click
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object SortViewOptions2: TMenuItem
        Caption = 'Sort View &Options'
        OnClick = SortViewOptions1Click
      end
    end
    object Notes1: TMenuItem
      Caption = 'C&heck'
      OnClick = ChkCP1BtnClick
    end
    object Status1: TMenuItem
      Caption = 'Stat&us'
    end
    object imeRates1: TMenuItem
      Caption = 'Time &Rates'
      OnClick = TRCP1BtnClick
    end
    object Custom1: TMenuItem
      Tag = 1
      Caption = 'Custom1'
      OnClick = CustdbBtn1Click
    end
    object Custom2: TMenuItem
      Tag = 2
      Caption = 'Custom2'
      OnClick = CustdbBtn1Click
    end
    object Custom3: TMenuItem
      Tag = 3
      Caption = 'Custom3'
      OnClick = CustdbBtn1Click
    end
    object Custom4: TMenuItem
      Tag = 4
      Caption = 'Custom4'
      OnClick = CustdbBtn1Click
    end
    object Custom5: TMenuItem
      Tag = 5
      Caption = 'Custom5'
      OnClick = CustdbBtn1Click
    end
    object Custom6: TMenuItem
      Tag = 6
      Caption = 'Custom6'
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
  object PopupMenu2: TPopupMenu
    Left = 220
    Top = 64
    object Copy2: TMenuItem
      Tag = 1
      Caption = '&Copy Transaction'
      HelpContext = 28
      OnClick = Copy2Click
    end
    object Reverse1: TMenuItem
      Tag = 2
      Caption = '&Reverse/Contra Transaction'
      HelpContext = 28
      OnClick = Copy2Click
    end
  end
  object PopupMenu3: TPopupMenu
    Left = 248
    Top = 64
    object Quotation1: TMenuItem
      Tag = 1
      Caption = '&Quotation'
      OnClick = Quotation1Click
    end
    object Active1: TMenuItem
      Tag = 2
      Caption = '&Active'
      OnClick = Quotation1Click
    end
    object Suspended1: TMenuItem
      Tag = 3
      Caption = '&Suspended'
      OnClick = Quotation1Click
    end
    object Completed1: TMenuItem
      Tag = 4
      Caption = '&Completed'
      OnClick = Quotation1Click
    end
    object Closed1: TMenuItem
      Tag = 5
      Caption = 'C&losed'
      OnClick = Quotation1Click
    end
  end
  object SBSPopupMenu1: TSBSPopupMenu
    Left = 192
    Top = 92
    object ViewR1: TMenuItem
      Caption = 'View &Credit Note'
      OnClick = ViewR1Click
    end
    object ViewR2: TMenuItem
      Tag = 1
      Caption = '&Original Invoice'
      OnClick = ViewR1Click
    end
  end
  object EntCustom1: TCustomisation
    DLLId = SysDll_Ent
    Enabled = True
    ExportPath = 'JobRec'
    WindowId = 105000
    Left = 248
    Top = 120
  end
  object SBSPopupMenu2: TSBSPopupMenu
    OnPopup = SBSPopupMenu2Popup
    Left = 220
    Top = 92
    object PTMI1: TMenuItem
      Caption = '&Purchase Terms'
      OnClick = PTMI1Click
    end
    object RPTMI1: TMenuItem
      Caption = '&Remove Purchase Terms'
      OnClick = RPTMI1Click
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object STMI1: TMenuItem
      Tag = 1
      Caption = '&Sales Terms'
      OnClick = PTMI1Click
    end
    object RSTMI1: TMenuItem
      Tag = 1
      Caption = 'R&emove Sales Terms'
      OnClick = RPTMI1Click
    end
  end
  object SBSPopupMenu3: TSBSPopupMenu
    OnPopup = SBSPopupMenu3Popup
    Left = 248
    Top = 92
    object Chk1: TMenuItem
      Tag = 41
      Caption = '&Check Job Totals'
      OnClick = Chk1Click
    end
    object Chk2: TMenuItem
      Tag = 43
      Caption = '&Verify Job Actuals'
      OnClick = Chk1Click
    end
    object Chk3: TMenuItem
      Tag = 42
      Caption = '&Reset Job Actuals'
      OnClick = Chk1Click
    end
  end
  object SortViewPopupMenu: TPopupMenu
    Left = 220
    Top = 120
    object RefreshView1: TMenuItem
      Caption = 'Refresh View'
      OnClick = RefreshView1Click
    end
    object CloseView1: TMenuItem
      Caption = 'Close View'
      OnClick = CloseView1Click
    end
    object N5: TMenuItem
      Caption = '-'
    end
    object SortViewOptions1: TMenuItem
      Caption = 'Sort View Options'
      OnClick = SortViewOptions1Click
    end
  end
  object PMenu_Notes: TPopupMenu
    Left = 192
    Top = 120
    object MenItem_General: TMenuItem
      Caption = '&General Notes'
      OnClick = MenItem_GeneralClick
    end
    object MenItem_Dated: TMenuItem
      Caption = '&Dated Notes'
      OnClick = MenItem_DatedClick
    end
    object MenItem_Audit: TMenuItem
      Caption = '&Audit History Notes'
      OnClick = MenItem_AuditClick
    end
  end
  object WindowExport: TWindowExport
    OnEnableExport = WindowExportEnableExport
    OnExecuteCommand = WindowExportExecuteCommand
    OnGetExportDescription = WindowExportGetExportDescription
    Left = 245
    Top = 254
  end
end
