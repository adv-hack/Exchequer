object SysSet: TSysSet
  Left = 500
  Top = 154
  HelpContext = 49
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'System Setup'
  ClientHeight = 370
  ClientWidth = 471
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
  Visible = True
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 14
  object PageControl1: TPageControl
    Left = 2
    Top = 2
    Width = 467
    Height = 366
    ActivePage = Switches
    TabIndex = 1
    TabOrder = 0
    OnChange = PageControl1Change
    OnChanging = PageControl1Changing
    object Company: TTabSheet
      HelpContext = 49
      Caption = 'Company'
      object ScrollBox1: TScrollBox
        Left = 0
        Top = -4
        Width = 459
        Height = 341
        HelpContext = 49
        VertScrollBar.Visible = False
        BorderStyle = bsNone
        TabOrder = 0
        object SBSBackGroup4: TSBSBackGroup
          Left = 216
          Top = 79
          Width = 237
          Height = 97
          TextId = 0
        end
        object SBSBackGroup1: TSBSBackGroup
          Left = 4
          Top = 1
          Width = 208
          Height = 318
          TextId = 0
        end
        object Label87: Label8
          Left = 16
          Top = 10
          Width = 140
          Height = 14
          Caption = 'Company Name and Address'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label86: Label8
          Left = 17
          Top = 123
          Width = 91
          Height = 14
          Caption = 'Telephone and Fax'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object VATRegLab: Label8
          Left = 17
          Top = 190
          Width = 22
          Height = 14
          Caption = ' Reg'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label82: Label8
          Left = 17
          Top = 231
          Width = 66
          Height = 14
          Caption = 'Country Code'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label88: Label8
          Left = 101
          Top = 232
          Width = 94
          Height = 14
          Caption = 'Financial Year Start'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label89: Label8
          Left = 17
          Top = 274
          Width = 73
          Height = 14
          Caption = 'Periods in Year'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label813: Label8
          Left = 102
          Top = 274
          Width = 73
          Height = 14
          Caption = 'Last Audit Date'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object SBSBackGroup2: TSBSBackGroup
          Left = 215
          Top = 1
          Width = 237
          Height = 80
          TextId = 0
        end
        object Label85: Label8
          Left = 233
          Top = 22
          Width = 111
          Height = 14
          Caption = 'Payment Terms (days):'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object VATLab1: Label8
          Left = 231
          Top = 48
          Width = 116
          Height = 14
          Alignment = taRightJustify
          AutoSize = False
          Caption = ' Code:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label811: Label8
          Left = 230
          Top = 108
          Width = 115
          Height = 14
          Caption = 'Direct Customer (SRI'#39's):'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label812: Label8
          Left = 241
          Top = 136
          Width = 106
          Height = 14
          Caption = 'Direct Supplier (PPI'#39's):'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object SBSBackGroup3: TSBSBackGroup
          Left = 215
          Top = 176
          Width = 237
          Height = 119
          TextId = 0
        end
        object Label819: Label8
          Left = 302
          Top = 192
          Width = 102
          Height = 14
          Caption = 'overdue for 1st letter'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label814: Label8
          Left = 324
          Top = 218
          Width = 37
          Height = 14
          AutoSize = False
          Caption = 'o/due ='
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label84: Label8
          Left = 229
          Top = 218
          Width = 28
          Height = 14
          Caption = 'Up to:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label817: Label8
          Left = 229
          Top = 244
          Width = 28
          Height = 14
          Caption = 'Up to:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label818: Label8
          Left = 229
          Top = 270
          Width = 28
          Height = 14
          Caption = 'Up to:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object SBSBackGroup8: TSBSBackGroup
          Left = 456
          Top = 1
          Width = 313
          Height = 176
          TextId = 0
        end
        object Label837: Label8
          Left = 297
          Top = 218
          Width = 23
          Height = 14
          AutoSize = False
          Caption = ' wks'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label815: Label8
          Left = 324
          Top = 244
          Width = 37
          Height = 14
          AutoSize = False
          Caption = 'o/due ='
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label816: Label8
          Left = 297
          Top = 244
          Width = 23
          Height = 14
          AutoSize = False
          Caption = ' wks'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label838: Label8
          Left = 324
          Top = 270
          Width = 37
          Height = 14
          AutoSize = False
          Caption = 'o/due ='
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label839: Label8
          Left = 297
          Top = 270
          Width = 23
          Height = 14
          AutoSize = False
          Caption = ' wks'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object SBSBackGroup5: TSBSBackGroup
          Left = 567
          Top = 180
          Width = 0
          Height = 0
          TextId = 0
        end
        object SBSBackGroup9: TSBSBackGroup
          Left = 456
          Top = 176
          Width = 315
          Height = 92
          TextId = 0
        end
        object Label810: Label8
          Left = 468
          Top = 14
          Width = 54
          Height = 14
          Caption = 'Bank Name'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label820: Label8
          Left = 468
          Top = 54
          Width = 90
          Height = 14
          Caption = 'Account No / IBAN'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label821: Label8
          Left = 468
          Top = 94
          Width = 73
          Height = 14
          Caption = 'Sort Code / BIC'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label822: Label8
          Left = 468
          Top = 134
          Width = 20
          Height = 14
          Caption = 'Ref.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object ScrollBox2: TScrollBox
          Left = 16
          Top = 26
          Width = 189
          Height = 93
          HelpContext = 311
          HorzScrollBar.Visible = False
          TabOrder = 0
          OnExit = ScrollBox2Exit
          object Addr1F: Text8Pt
            Tag = 1
            Left = 2
            Top = 26
            Width = 187
            Height = 22
            HelpContext = 311
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
            TabOrder = 1
            TextId = 0
            ViaSBtn = False
          end
          object Addr2F: Text8Pt
            Tag = 1
            Left = 2
            Top = 50
            Width = 187
            Height = 22
            HelpContext = 311
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
            TabOrder = 2
            TextId = 0
            ViaSBtn = False
          end
          object Addr3F: Text8Pt
            Tag = 1
            Left = 2
            Top = 74
            Width = 187
            Height = 22
            HelpContext = 311
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
          end
          object Addr4F: Text8Pt
            Tag = 1
            Left = 2
            Top = 98
            Width = 187
            Height = 22
            HelpContext = 311
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
            TabOrder = 4
            TextId = 0
            ViaSBtn = False
          end
          object Addr5F: Text8Pt
            Tag = 1
            Left = 2
            Top = 124
            Width = 187
            Height = 22
            HelpContext = 311
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
            TabOrder = 5
            TextId = 0
            ViaSBtn = False
          end
          object CompanyF: Text8Pt
            Left = 2
            Top = 2
            Width = 187
            Height = 22
            HelpContext = 311
            Color = clWhite
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            MaxLength = 45
            ParentFont = False
            ParentShowHint = False
            ReadOnly = True
            ShowHint = True
            TabOrder = 0
            TextId = 0
            ViaSBtn = False
          end
        end
        object PhoneF: Text8Pt
          Tag = 1
          Left = 17
          Top = 139
          Width = 187
          Height = 22
          HelpContext = 312
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          MaxLength = 15
          ParentFont = False
          ParentShowHint = False
          ReadOnly = True
          ShowHint = True
          TabOrder = 1
          TextId = 0
          ViaSBtn = False
        end
        object FaxF: Text8Pt
          Tag = 1
          Left = 17
          Top = 164
          Width = 187
          Height = 22
          HelpContext = 312
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          MaxLength = 15
          ParentFont = False
          ParentShowHint = False
          ReadOnly = True
          ShowHint = True
          TabOrder = 2
          TextId = 0
          ViaSBtn = False
        end
        object VRegF: Text8Pt
          Tag = 1
          Left = 17
          Top = 205
          Width = 187
          Height = 22
          HelpContext = 313
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
          TabOrder = 3
          TextId = 0
          ViaSBtn = False
        end
        object FinYrF: TEditDate
          Tag = 1
          Left = 102
          Top = 246
          Width = 102
          Height = 22
          HelpContext = 315
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
        end
        object LADF: TEditDate
          Tag = 1
          Left = 102
          Top = 288
          Width = 102
          Height = 22
          HelpContext = 317
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
          TabOrder = 7
          Placement = cpAbove
        end
        object PIF: TCurrencyEdit
          Tag = 1
          Left = 18
          Top = 288
          Width = 55
          Height = 22
          HelpContext = 316
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
          TabOrder = 6
          WantReturns = False
          WordWrap = False
          OnKeyPress = PIFKeyPress
          AutoSize = False
          BlockNegative = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0 ;###,###,##0-'
          DecPlaces = 0
          ShowCurrency = False
          TextId = 0
          Value = 1E-10
        end
        object PTermF: TCurrencyEdit
          Tag = 1
          Left = 350
          Top = 20
          Width = 55
          Height = 22
          HelpContext = 319
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
          TabOrder = 8
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
        object TTermF: TBorCheck
          Tag = 1
          Left = 460
          Top = 188
          Width = 182
          Height = 20
          Caption = 'Default Trading Terms Message:'
          CheckColor = clWindowText
          Color = clBtnFace
          Enabled = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          TabOrder = 20
          TabStop = True
          TextId = 0
        end
        object TCF: TSBSComboBox
          Tag = 1
          Left = 350
          Top = 46
          Width = 53
          Height = 22
          HelpContext = 321
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
          TabOrder = 9
          ExtendedList = True
          MaxListWidth = 75
          ReadOnly = True
          Validate = True
        end
        object DSRIF: Text8Pt
          Tag = 1
          Left = 349
          Top = 106
          Width = 88
          Height = 22
          Hint = 
            'Double click to drill down|Double clicking or using the down but' +
            'ton will drill down to the record for this field. The up button ' +
            'will search for the nearest match.'
          HelpContext = 322
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
          TabOrder = 10
          OnExit = DSRIFExit
          TextId = 0
          ViaSBtn = False
          Link_to_Cust = True
          ShowHilight = True
        end
        object DPPIF: Text8Pt
          Tag = 1
          Left = 349
          Top = 131
          Width = 88
          Height = 22
          Hint = 
            'Double click to drill down|Double clicking or using the down but' +
            'ton will drill down to the record for this field. The up button ' +
            'will search for the nearest match.'
          HelpContext = 322
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
          TabOrder = 11
          OnExit = DSRIFExit
          TextId = 0
          ViaSBtn = False
          Link_to_Cust = True
          ShowHilight = True
        end
        object MODF: TCurrencyEdit
          Tag = 1
          Left = 406
          Top = 188
          Width = 35
          Height = 22
          HelpContext = 323
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
          TabOrder = 13
          WantReturns = False
          WordWrap = False
          OnExit = MODFExit
          AutoSize = False
          BlockNegative = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0 ;###,###,##0-'
          DecPlaces = 0
          ShowCurrency = False
          TextId = 0
          Value = 1E-10
        end
        object W1F: Text8Pt
          Left = 362
          Top = 214
          Width = 79
          Height = 22
          HelpContext = 324
          TabStop = False
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ReadOnly = True
          ShowHint = True
          TabOrder = 15
          TextId = 0
          ViaSBtn = False
        end
        object W2F: Text8Pt
          Left = 362
          Top = 240
          Width = 79
          Height = 22
          HelpContext = 324
          TabStop = False
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
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
        object W3F: Text8Pt
          Left = 362
          Top = 266
          Width = 79
          Height = 22
          HelpContext = 324
          TabStop = False
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ReadOnly = True
          ShowHint = True
          TabOrder = 19
          TextId = 0
          ViaSBtn = False
        end
        object B3F: TCurrencyEdit
          Tag = 1
          Left = 260
          Top = 266
          Width = 35
          Height = 22
          HelpContext = 324
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
          TabOrder = 18
          WantReturns = False
          WordWrap = False
          OnExit = MODFExit
          AutoSize = False
          BlockNegative = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0 ;###,###,##0-'
          DecPlaces = 0
          ShowCurrency = False
          TextId = 0
          Value = 1E-10
        end
        object B2F: TCurrencyEdit
          Tag = 1
          Left = 260
          Top = 240
          Width = 35
          Height = 22
          HelpContext = 324
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
          TabOrder = 16
          WantReturns = False
          WordWrap = False
          OnExit = MODFExit
          AutoSize = False
          BlockNegative = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0 ;###,###,##0-'
          DecPlaces = 0
          ShowCurrency = False
          TextId = 0
          Value = 1E-10
        end
        object B1F: TCurrencyEdit
          Tag = 1
          Left = 260
          Top = 214
          Width = 35
          Height = 22
          HelpContext = 324
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
          TabOrder = 14
          WantReturns = False
          WordWrap = False
          OnExit = MODFExit
          AutoSize = False
          BlockNegative = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0 ;###,###,##0-'
          DecPlaces = 0
          ShowCurrency = False
          TextId = 0
          Value = 1E-10
        end
        object CCodeF: TSBSComboBox
          Left = 18
          Top = 246
          Width = 75
          Height = 22
          HelpContext = 314
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ItemHeight = 14
          MaxLength = 1
          ParentFont = False
          TabOrder = 4
          Items.Strings = (
            'Australia (STX)  /061'
            'New Zealand (GST) /064'
            'Singapore (GST) /065'
            'South Africa (VAT) /027'
            'United Kingdom (VAT) /044'
            'Ireland (VAT) /353')
          ExtendedList = True
          MaxListWidth = 130
          ReadOnly = True
          Validate = True
        end
        object DebML: TSBSComboBox
          Tag = 1
          Left = 228
          Top = 188
          Width = 68
          Height = 22
          HelpContext = 538
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
          OnChange = DebMLExit
          Items.Strings = (
            'Weeks Single'
            'Days Single'
            'Weeks Escalating'
            'Days Escalating'
            'Weeks Multiple'
            'Days Multiple')
          ExtendedList = True
          MaxListWidth = 90
        end
        object TT1: Text8Pt
          Tag = 1
          Left = 468
          Top = 211
          Width = 295
          Height = 22
          HelpContext = 325
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          MaxLength = 80
          ParentFont = False
          ParentShowHint = False
          ReadOnly = True
          ShowHint = True
          TabOrder = 21
          TextId = 0
          ViaSBtn = False
        end
        object TT2: Text8Pt
          Tag = 1
          Left = 468
          Top = 236
          Width = 295
          Height = 22
          HelpContext = 325
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          MaxLength = 80
          ParentFont = False
          ParentShowHint = False
          ReadOnly = True
          ShowHint = True
          TabOrder = 22
          TextId = 0
          ViaSBtn = False
        end
        object BNF: Text8Pt
          Tag = 1
          Left = 468
          Top = 27
          Width = 282
          Height = 22
          HelpContext = 325
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
          TabOrder = 23
          TextId = 0
          ViaSBtn = False
        end
        object BAF: Text8Pt
          Tag = 1
          Left = 468
          Top = 67
          Width = 282
          Height = 22
          HelpContext = 325
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          MaxLength = 35
          ParentFont = False
          ParentShowHint = False
          ReadOnly = True
          ShowHint = True
          TabOrder = 24
          TextId = 0
          ViaSBtn = False
        end
        object BSF: Text8Pt
          Tag = 1
          Left = 468
          Top = 107
          Width = 178
          Height = 22
          HelpContext = 325
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          MaxLength = 15
          ParentFont = False
          ParentShowHint = False
          ReadOnly = True
          ShowHint = True
          TabOrder = 25
          TextId = 0
          ViaSBtn = False
        end
        object BRF: Text8Pt
          Tag = 1
          Left = 468
          Top = 148
          Width = 281
          Height = 22
          HelpContext = 325
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          MaxLength = 28
          ParentFont = False
          ParentShowHint = False
          ReadOnly = True
          ShowHint = True
          TabOrder = 26
          TextId = 0
          ViaSBtn = False
        end
      end
    end
    object Switches: TTabSheet
      HelpContext = 326
      Caption = 'System/GL/Currency'
      object Bevel1: TBevel
        Left = 230
        Top = 2
        Width = 2
        Height = 319
      end
      object ConsLab: TLabel
        Left = 237
        Top = 6
        Width = 157
        Height = 14
        Caption = 'Currency Consolidation Method:-'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label840: Label8
        Left = 236
        Top = 80
        Width = 138
        Height = 14
        Caption = 'Allocation/CurrVar Tolerance'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label841: Label8
        Left = 235
        Top = 105
        Width = 141
        Height = 14
        Caption = 'Currency Variance Tolerance'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Bevel3: TBevel
        Left = 9
        Top = 146
        Width = 214
        Height = 2
        Shape = bsTopLine
      end
      object Bevel4: TBevel
        Left = 9
        Top = 188
        Width = 214
        Height = 2
        Shape = bsTopLine
      end
      object CurVLab: Label8
        Left = 254
        Top = 52
        Width = 124
        Height = 14
        Alignment = taRightJustify
        AutoSize = False
        Caption = ' Returns'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label828: Label8
        Left = 236
        Top = 247
        Width = 103
        Height = 14
        Caption = 'Default Report Printer'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label829: Label8
        Left = 237
        Top = 272
        Width = 101
        Height = 14
        Caption = 'Default Forms Printer'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Bevel9: TBevel
        Left = 239
        Top = 233
        Width = 216
        Height = 2
        Shape = bsTopLine
      end
      object lblECThreshold: Label8
        Left = 281
        Top = 188
        Width = 94
        Height = 14
        HelpContext = 8050
        Alignment = taRightJustify
        Caption = 'EC Sales Threshold'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Bevel19: TBevel
        Left = 239
        Top = 177
        Width = 216
        Height = 2
        Shape = bsTopLine
      end
      object lblCurrImpTol: Label8
        Left = 248
        Top = 130
        Width = 127
        Height = 14
        Caption = 'Currency Import Tolerance'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object ACF: TBorCheck
        Tag = 1
        Left = 7
        Top = 234
        Width = 211
        Height = 20
        HelpContext = 342
        Align = alRight
        Caption = 'Auto-clear Payments/Receipts in bank'
        CheckColor = clWindowText
        Color = clBtnFace
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 12
        TabStop = True
        TextId = 0
      end
      object ECF: TBorCheck
        Tag = 1
        Left = 7
        Top = 6
        Width = 211
        Height = 20
        HelpContext = 329
        Align = alRight
        Caption = 'External Customer Records'
        CheckColor = clWindowText
        Color = clBtnFace
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 0
        TabStop = True
        TextId = 0
      end
      object ESF: TBorCheck
        Tag = 1
        Left = 7
        Top = 39
        Width = 211
        Height = 20
        HelpContext = 331
        Align = alRight
        Caption = 'External SIN Generation'
        CheckColor = clWindowText
        Color = clBtnFace
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 2
        TabStop = True
        TextId = 0
      end
      object NTF: TBorCheck
        Tag = 1
        Left = 7
        Top = 23
        Width = 211
        Height = 20
        HelpContext = 330
        Align = alRight
        Caption = 'Numeric Trader Codes'
        CheckColor = clWindowText
        Color = clBtnFace
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 1
        TabStop = True
        TextId = 0
      end
      object DPF: TBorCheck
        Tag = 1
        Left = 7
        Top = 149
        Width = 211
        Height = 20
        HelpContext = 338
        Align = alRight
        Caption = 'Disable posting to previous periods'
        CheckColor = clWindowText
        Color = clBtnFace
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 8
        TabStop = True
        TextId = 0
      end
      object UPF: TBorCheck
        Tag = 1
        Left = 7
        Top = 107
        Width = 211
        Height = 20
        HelpContext = 336
        Align = alRight
        Caption = 'Use Passwords'
        CheckColor = clWindowText
        Color = clBtnFace
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 6
        TabStop = True
        TextId = 0
      end
      object HUF: TBorCheck
        Tag = 1
        Left = 7
        Top = 124
        Width = 211
        Height = 20
        HelpContext = 337
        Align = alRight
        Caption = 'Hide unauthorised options'
        CheckColor = clWindowText
        Color = clBtnFace
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 7
        TabStop = True
        TextId = 0
      end
      object SPF: TBorCheck
        Tag = 1
        Left = 7
        Top = 166
        Width = 211
        Height = 20
        HelpContext = 339
        Align = alRight
        Caption = 'Set Period relative to Date'
        CheckColor = clWindowText
        Color = clBtnFace
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 9
        TabStop = True
        TextId = 0
      end
      object UCCF: TBorCheck
        Tag = 1
        Left = 7
        Top = 191
        Width = 211
        Height = 20
        HelpContext = 335
        Align = alRight
        Caption = 'Use Cost Centres and Departments'
        CheckColor = clWindowText
        Color = clBtnFace
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 10
        TabStop = True
        TextId = 0
        OnClick = UCCFClick
      end
      object UEF: TBorCheck
        Tag = 1
        Left = 7
        Top = 56
        Width = 211
        Height = 20
        HelpContext = 332
        Align = alRight
        Caption = 'Use Exchequer (DOS) Keys'
        CheckColor = clWindowText
        Color = clBtnFace
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 3
        TabStop = True
        TextId = 0
      end
      object CMF: TBorCheck
        Tag = 1
        Left = 7
        Top = 90
        Width = 219
        Height = 20
        HelpContext = 334
        Align = alRight
        Caption = 'Conserve memory (slower performance)'
        CheckColor = clWindowText
        Color = clBtnFace
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 5
        TabStop = True
        TextId = 0
      end
      object HEF: TBorCheck
        Tag = 1
        Left = 7
        Top = 73
        Width = 211
        Height = 20
        HelpContext = 333
        Align = alRight
        Caption = 'Hide Exchequer Logo'
        CheckColor = clWindowText
        Color = clBtnFace
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 4
        TabStop = True
        TextId = 0
      end
      object CRF: TBorRadio
        Tag = 1
        Left = 274
        Top = 20
        Width = 95
        Height = 20
        HelpContext = 374
        Caption = 'Company Rate'
        CheckColor = clWindowText
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        GroupIndex = 1
        ParentFont = False
        TabOrder = 14
        TabStop = True
        TextId = 0
        OnClick = CRFClick
      end
      object DRF: TBorRadio
        Tag = 1
        Left = 378
        Top = 20
        Width = 71
        Height = 20
        HelpContext = 374
        Caption = 'Daily Rate'
        CheckColor = clWindowText
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        GroupIndex = 1
        ParentFont = False
        TabOrder = 15
        TabStop = True
        TextId = 0
        OnClick = CRFClick
      end
      object TolML: TSBSComboBox
        Tag = 1
        Left = 380
        Top = 75
        Width = 74
        Height = 22
        HelpContext = 734
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
        TabOrder = 17
        OnChange = TolMLChange
        Items.Strings = (
          'Disabled'
          'Fixed Value'
          'Percentage')
        MaxListWidth = 90
        Validate = True
      end
      object TolF: TCurrencyEdit
        Tag = 1
        Left = 380
        Top = 101
        Width = 74
        Height = 22
        HelpContext = 734
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          '0.00 ')
        ParentFont = False
        TabOrder = 18
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
      object CurVF: TSBSComboBox
        Tag = 1
        Left = 380
        Top = 49
        Width = 74
        Height = 22
        HelpContext = 379
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
        TabOrder = 16
        OnExit = CurVFExit
        ExtendedList = True
        MaxListWidth = 90
        Validate = True
      end
      object SLF: TBorCheck
        Tag = 1
        Left = 7
        Top = 252
        Width = 211
        Height = 20
        HelpContext = 341
        Align = alRight
        Caption = 'Split Line Discounts in G/L when posting'
        CheckColor = clWindowText
        Color = clBtnFace
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 13
        TabStop = True
        TextId = 0
      end
      object DefRPrn: TSBSComboBox
        Tag = 1
        Left = 342
        Top = 243
        Width = 112
        Height = 22
        HelpContext = 732
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
      end
      object DefFPrn: TSBSComboBox
        Tag = 1
        Left = 342
        Top = 267
        Width = 112
        Height = 22
        HelpContext = 733
        Style = csDropDownList
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 14
        ParentFont = False
        TabOrder = 24
        Items.Strings = (
          'None'
          'Automatic'
          'Manual')
        ExtendedList = True
        MaxListWidth = 250
      end
      object BUCCF: TSBSComboBox
        Tag = 1
        Left = 7
        Top = 212
        Width = 218
        Height = 22
        HelpContext = 335
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
        Items.Strings = (
          'No Budgeting by Cost Centre/Department'
          'Budget by Cost Centre or Department only'
          'Budget by CC, Dept & CC+Dept Combined')
        MaxListWidth = 77
        Validate = True
      end
      object UGLCCB: TBorCheck
        Tag = 1
        Left = 242
        Top = 151
        Width = 211
        Height = 20
        Align = alRight
        Caption = 'Enforce G/L Classes'
        CheckColor = clWindowText
        Color = clBtnFace
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 20
        TabStop = True
        TextId = 0
      end
      object ceECThreshold: TCurrencyEdit
        Tag = 1
        Left = 380
        Top = 184
        Width = 74
        Height = 22
        HelpContext = 8050
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          '0.00 ')
        ParentFont = False
        TabOrder = 21
        WantReturns = False
        WordWrap = False
        OnKeyPress = ceECThresholdKeyPress
        AutoSize = False
        BlockNegative = False
        BlankOnZero = False
        DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
        ShowCurrency = False
        TextId = 0
        Value = 1E-10
      end
      object chkECServices: TBorCheck
        Tag = 1
        Left = 242
        Top = 209
        Width = 211
        Height = 20
        HelpContext = 8051
        Align = alRight
        Caption = 'Enable EC Services Support'
        CheckColor = clWindowText
        Color = clBtnFace
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 22
        TabStop = True
        TextId = 0
      end
      object eCurrImportTol: TCurrencyEdit
        Tag = 1
        Left = 380
        Top = 127
        Width = 74
        Height = 22
        HelpContext = 734
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          '0.00%')
        ParentFont = False
        TabOrder = 19
        WantReturns = False
        WordWrap = False
        OnExit = eCurrImportTolExit
        AutoSize = False
        BlockNegative = True
        BlankOnZero = False
        DisplayFormat = '##0.00%;##0.00%-'
        ShowCurrency = False
        TextId = 0
        Value = 1E-10
      end
    end
    object SLPLPage: TTabSheet
      HelpContext = 1034
      Caption = 'SL/PL'
      object Label823: Label8
        Left = 273
        Top = 177
        Width = 107
        Height = 14
        Caption = 'Decimal places on Qty'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label824: Label8
        Left = 241
        Top = 154
        Width = 138
        Height = 14
        Caption = 'Decimal places on Sale Price'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label825: Label8
        Left = 240
        Top = 129
        Width = 139
        Height = 14
        Caption = 'Decimal places on Cost Price'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Bevel5: TBevel
        Left = 228
        Top = 2
        Width = 2
        Height = 319
      end
      object Bevel6: TBevel
        Left = 4
        Top = 80
        Width = 214
        Height = 2
        Shape = bsTopLine
      end
      object Bevel7: TBevel
        Left = 4
        Top = 147
        Width = 214
        Height = 2
        Shape = bsTopLine
      end
      object Bevel8: TBevel
        Left = 4
        Top = 228
        Width = 214
        Height = 2
        Shape = bsTopLine
      end
      object Bevel10: TBevel
        Left = 240
        Top = 120
        Width = 214
        Height = 2
        Shape = bsTopLine
      end
      object AMFLab: Label8
        Left = 276
        Top = 69
        Width = 102
        Height = 14
        Caption = 'Authorisation Method'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label876: Label8
        Left = 120
        Top = 125
        Width = 97
        Height = 14
        Caption = 'Age by Invoice Date'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Bevel20: TBevel
        Left = 240
        Top = 92
        Width = 214
        Height = 2
        Shape = bsTopLine
      end
      object DEQF: TCurrencyEdit
        Tag = 1
        Left = 383
        Top = 174
        Width = 43
        Height = 22
        HelpContext = 378
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          '0 ')
        MaxLength = 1
        ParentFont = False
        TabOrder = 22
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
      object DESPF: TCurrencyEdit
        Tag = 1
        Left = 383
        Top = 150
        Width = 43
        Height = 22
        HelpContext = 377
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          '0 ')
        MaxLength = 1
        ParentFont = False
        TabOrder = 21
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
      object DecPF: TCurrencyEdit
        Tag = 1
        Left = 383
        Top = 126
        Width = 43
        Height = 22
        HelpContext = 376
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          '0 ')
        MaxLength = 1
        ParentFont = False
        TabOrder = 20
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
      object UCF: TBorCheck
        Tag = 1
        Left = 2
        Top = 6
        Width = 211
        Height = 20
        HelpContext = 345
        Align = alRight
        Caption = 'Use Credit Limit Check'
        CheckColor = clWindowText
        Color = clBtnFace
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 0
        TabStop = True
        TextId = 0
        OnClick = UCFClick
      end
      object USF: TBorCheck
        Tag = 1
        Left = 2
        Top = 23
        Width = 211
        Height = 20
        HelpContext = 346
        Align = alRight
        Caption = 'Use Credit Status Check'
        CheckColor = clWindowText
        Color = clBtnFace
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 1
        TabStop = True
        TextId = 0
      end
      object IOF: TBorCheck
        Tag = 1
        Left = 2
        Top = 40
        Width = 211
        Height = 20
        HelpContext = 347
        Align = alRight
        Caption = 'If over Credit Limit, put '#39'on stop'#39
        CheckColor = clWindowText
        Color = clBtnFace
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 2
        TabStop = True
        TextId = 0
      end
      object COF: TBorCheck
        Tag = 1
        Left = 2
        Top = 58
        Width = 211
        Height = 20
        HelpContext = 348
        Align = alRight
        Caption = 'Calc '#39'Oldest Debt'#39' when leaving ledger'
        CheckColor = clWindowText
        Color = clBtnFace
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 3
        TabStop = True
        TextId = 0
      end
      object INF: TBorCheck
        Tag = 1
        Left = 2
        Top = 84
        Width = 211
        Height = 20
        HelpContext = 350
        Align = alRight
        Caption = 'Include '#39'Not Due'#39' items on statement'
        CheckColor = clWindowText
        Color = clBtnFace
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 4
        TabStop = True
        TextId = 0
      end
      object ATF: TBorCheck
        Tag = 1
        Left = 2
        Top = 102
        Width = 211
        Height = 20
        HelpContext = 351
        Align = alRight
        Caption = 'Add to notes when statement is printed'
        CheckColor = clWindowText
        Color = clBtnFace
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 5
        TabStop = True
        TextId = 0
      end
      object SQF: TBorCheck
        Tag = 1
        Left = 2
        Top = 152
        Width = 211
        Height = 20
        HelpContext = 353
        Align = alRight
        Caption = 'Keep SQU/PQU'#39's date when converted'
        CheckColor = clWindowText
        Color = clBtnFace
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 7
        TabStop = True
        TextId = 0
      end
      object SRICntF: TBorCheck
        Tag = 1
        Left = 2
        Top = 170
        Width = 211
        Height = 20
        HelpContext = 638
        Align = alRight
        Caption = 'SRI/PPI to have own "Our Ref" count'
        CheckColor = clWindowText
        Color = clBtnFace
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 8
        TabStop = True
        TextId = 0
      end
      object PTF: TBorCheck
        Tag = 1
        Left = 2
        Top = 232
        Width = 211
        Height = 20
        HelpContext = 354
        Align = alRight
        Caption = 'Prompt to print sales receipts'
        CheckColor = clWindowText
        Color = clBtnFace
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 11
        TabStop = True
        TextId = 0
      end
      object URF: TBorCheck
        Tag = 1
        Left = 2
        Top = 251
        Width = 211
        Height = 20
        HelpContext = 355
        Align = alRight
        Caption = 'Use sales receipts '#39'Pay-In Ref'#39
        CheckColor = clWindowText
        Color = clBtnFace
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 12
        TabStop = True
        TextId = 0
      end
      object AC2F: TBorCheck
        Tag = 1
        Left = 2
        Top = 269
        Width = 211
        Height = 20
        HelpContext = 356
        Align = alRight
        Caption = 'Automatic Cheque Numbers'
        CheckColor = clWindowText
        Color = clBtnFace
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 13
        TabStop = True
        TextId = 0
      end
      object SMF: TBorCheck
        Tag = 1
        Left = 2
        Top = 287
        Width = 225
        Height = 20
        HelpContext = 357
        Align = alRight
        Caption = 'Stop manual entry of PPY'#39's '
        CheckColor = clWindowText
        Color = clBtnFace
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 14
        TabStop = True
        TextId = 0
      end
      object DTF: TBorCheck
        Tag = 1
        Left = 238
        Top = 42
        Width = 211
        Height = 20
        HelpContext = 344
        Align = alRight
        Caption = 'Default to % discounts'
        CheckColor = clWindowText
        Color = clBtnFace
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 17
        TabStop = True
        TextId = 0
      end
      object UTF: TBorCheck
        Tag = 1
        Left = 238
        Top = 24
        Width = 216
        Height = 20
        HelpContext = 340
        Align = alRight
        Caption = 'Update trader balances after posting'
        CheckColor = clWindowText
        Color = clBtnFace
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 16
        TabStop = True
        TextId = 0
      end
      object FBF: TBorCheck
        Tag = 1
        Left = 238
        Top = 6
        Width = 211
        Height = 20
        HelpContext = 343
        Align = alRight
        Caption = 'Force Batch totals to balance'
        CheckColor = clWindowText
        Color = clBtnFace
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 15
        TabStop = True
        TextId = 0
      end
      object DYrf: TBorCheck
        Tag = 1
        Left = 2
        Top = 188
        Width = 211
        Height = 20
        HelpContext = 547
        Align = alRight
        Caption = ' Warn if Duplicate "Your Ref" is entered'
        CheckColor = clWindowText
        Color = clBtnFace
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 9
        TabStop = True
        TextId = 0
      end
      object PYRF: TBorCheck
        Tag = 1
        Left = 2
        Top = 207
        Width = 211
        Height = 20
        HelpContext = 1035
        Align = alRight
        Caption = 'Protect "Your Ref" in SPOP'
        CheckColor = clWindowText
        Color = clBtnFace
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 10
        TabStop = True
        TextId = 0
        OnClick = PYRFClick
      end
      object AMF: TSBSComboBox
        Tag = 1
        Left = 382
        Top = 65
        Width = 74
        Height = 22
        HelpContext = 381
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
          'None'
          'Automatic'
          'Manual')
        MaxListWidth = 0
      end
      object AgeByCB: TSBSComboBox
        Tag = 1
        Left = 2
        Top = 120
        Width = 109
        Height = 22
        HelpContext = 352
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
        Items.Strings = (
          'Do Not'
          'Sales Ledger'
          'Purchase Ledger'
          'Sales & Purchase')
        MaxListWidth = 0
      end
      object chkEnableConsumers: TBorCheck
        Tag = 1
        Left = 238
        Top = 96
        Width = 211
        Height = 20
        HelpContext = 8095
        Align = alRight
        Caption = 'Enable Consumers for Sales'
        CheckColor = clWindowText
        Color = clBtnFace
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 19
        TabStop = True
        TextId = 0
        OnMouseUp = chkEnableConsumersMouseUp
      end
    end
    object tabshPPD: TTabSheet
      HelpContext = 2200
      Caption = 'SL/PL PPD'
      ImageIndex = 7
      object Label875: Label8
        Left = 22
        Top = 24
        Width = 70
        Height = 14
        Caption = 'Days to Expiry'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label874: Label8
        Left = 49
        Top = 45
        Width = 15
        Height = 14
        Alignment = taCenter
        Caption = '< 0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label873: Label8
        Left = 110
        Top = 24
        Width = 95
        Height = 14
        Caption = 'Expiry Date Colours'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label83: Label8
        Left = 3
        Top = 2
        Width = 132
        Height = 14
        Caption = 'PPD Status Indicator - Days'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Bevel21: TBevel
        Left = 137
        Top = 10
        Width = 316
        Height = 2
        Shape = bsTopLine
      end
      object edtExpiredColour: TEdit
        Left = 107
        Top = 42
        Width = 129
        Height = 22
        TabStop = False
        Color = cl3DLight
        ReadOnly = True
        TabOrder = 4
        Text = 'Expired'
      end
      object edtRedDaysColour: TEdit
        Left = 107
        Top = 66
        Width = 129
        Height = 22
        TabStop = False
        Color = clRed
        Font.Charset = ANSI_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ReadOnly = True
        TabOrder = 6
        Text = '0 - 5 Days (inclusive)'
      end
      object edtAmberDaysColour: TEdit
        Left = 107
        Top = 90
        Width = 129
        Height = 22
        TabStop = False
        Color = clYellow
        ReadOnly = True
        TabOrder = 8
        Text = '6 - 15 Days (inclusive)'
      end
      object edtGreenDaysColour: TEdit
        Left = 107
        Top = 114
        Width = 129
        Height = 22
        TabStop = False
        Color = clLime
        ReadOnly = True
        TabOrder = 10
        Text = '16+ Days'
      end
      object btnGreenDaysColour: TButton
        Left = 238
        Top = 114
        Width = 80
        Height = 21
        Caption = 'Edit Colour'
        TabOrder = 11
        OnClick = btnGreenDaysColourClick
      end
      object btnAmberDaysColour: TButton
        Left = 238
        Top = 90
        Width = 80
        Height = 21
        Caption = 'Edit Colour'
        TabOrder = 9
        OnClick = btnAmberDaysColourClick
      end
      object btnRedDaysColour: TButton
        Left = 238
        Top = 66
        Width = 80
        Height = 21
        Caption = 'Edit Colour'
        TabOrder = 7
        OnClick = btnRedDaysColourClick
      end
      object btnExpiredColour: TButton
        Left = 238
        Top = 42
        Width = 80
        Height = 21
        Caption = 'Edit Colour'
        TabOrder = 5
        OnClick = btnExpiredColourClick
      end
      object udAmberDays: TUpDown
        Left = 71
        Top = 90
        Width = 16
        Height = 22
        Associate = edtAmberDays
        Min = 1
        Max = 999
        Position = 1
        TabOrder = 3
        Wrap = False
        OnClick = udRedDaysClick
      end
      object udRedDays: TUpDown
        Left = 71
        Top = 66
        Width = 16
        Height = 22
        Associate = edtRedDays
        Min = 0
        Max = 999
        Position = 0
        TabOrder = 1
        Wrap = False
        OnClick = udRedDaysClick
      end
      object edtRedDays: TEdit
        Tag = 1
        Left = 39
        Top = 66
        Width = 32
        Height = 22
        TabOrder = 0
        Text = '0'
        OnChange = edtRedDaysChange
        OnExit = edtRedDaysExit
      end
      object edtAmberDays: TEdit
        Tag = 1
        Left = 39
        Top = 90
        Width = 32
        Height = 22
        TabOrder = 2
        Text = '1'
        OnChange = edtAmberDaysChange
        OnExit = edtAmberDaysExit
      end
    end
    object StkPage: TTabSheet
      HelpContext = 327
      Caption = 'Stock/SPOP'
      object EMLLab: Label8
        Left = 5
        Top = 32
        Width = 72
        Height = 14
        AutoSize = False
        Caption = 'Multi Location'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object DefVFLab: Label8
        Left = 7
        Top = 9
        Width = 132
        Height = 14
        Caption = 'Default Stock Value method'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Bevel2: TBevel
        Left = 228
        Top = 2
        Width = 2
        Height = 319
      end
      object Bevel11: TBevel
        Left = 4
        Top = 151
        Width = 214
        Height = 2
        Shape = bsTopLine
      end
      object Bevel12: TBevel
        Left = 4
        Top = 197
        Width = 214
        Height = 2
        Shape = bsTopLine
      end
      object Bevel13: TBevel
        Left = 4
        Top = 262
        Width = 214
        Height = 2
        Shape = bsTopLine
      end
      object Bevel14: TBevel
        Left = 239
        Top = 139
        Width = 214
        Height = 2
        Shape = bsTopLine
      end
      object Label827: Label8
        Left = 240
        Top = 117
        Width = 72
        Height = 14
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Bin Code Mask'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        PopupMenu = PopupMenu1
        TextId = 0
      end
      object Bevel17: TBevel
        Left = 239
        Top = 66
        Width = 214
        Height = 2
        Shape = bsTopLine
      end
      object bevUseOverrideLocations: TBevel
        Left = 239
        Top = 186
        Width = 214
        Height = 2
        Shape = bsTopLine
      end
      object bevIncludeVatInCB: TBevel
        Left = 239
        Top = 214
        Width = 214
        Height = 2
        Shape = bsTopLine
      end
      object bevEnableOrderPayments: TBevel
        Left = 239
        Top = 242
        Width = 214
        Height = 2
        Shape = bsTopLine
      end
      object DIF: TBorCheck
        Tag = 1
        Left = 6
        Top = 75
        Width = 211
        Height = 20
        HelpContext = 361
        Align = alRight
        Caption = 'Display '#39'Insufficient Stock'#39' warning'
        CheckColor = clWindowText
        Color = clBtnFace
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 3
        TabStop = True
        TextId = 0
      end
      object QSF: TBorCheck
        Tag = 1
        Left = 6
        Top = 201
        Width = 211
        Height = 20
        HelpContext = 362
        Align = alRight
        Caption = 'Quotes (SQU/PQU) to allocate Stock'
        CheckColor = clWindowText
        Color = clBtnFace
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 9
        TabStop = True
        TextId = 0
      end
      object DUF: TBorCheck
        Tag = 1
        Left = 6
        Top = 111
        Width = 211
        Height = 20
        HelpContext = 363
        Align = alRight
        Caption = 'Display '#39'Update Build Costs'#39' reminder'
        CheckColor = clWindowText
        Color = clBtnFace
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 5
        TabStop = True
        TextId = 0
      end
      object ASF: TBorCheck
        Tag = 1
        Left = 6
        Top = 129
        Width = 211
        Height = 20
        HelpContext = 364
        Align = alRight
        Caption = 'Analyse sales of '#39'Desc Only'#39' stock'
        CheckColor = clWindowText
        Color = clBtnFace
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 6
        TabStop = True
        TextId = 0
      end
      object USSDF: TBorCheck
        Tag = 1
        Left = 6
        Top = 93
        Width = 211
        Height = 20
        HelpContext = 365
        Align = alRight
        Caption = 'Use EC SSD/Intrastat fields'
        CheckColor = clWindowText
        Color = clBtnFace
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 4
        TabStop = True
        TextId = 0
      end
      object EMLF: TSBSComboBox
        Tag = 1
        Left = 80
        Top = 31
        Width = 138
        Height = 22
        HelpContext = 729
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
        OnChange = EMLFChange
        Items.Strings = (
          'Disabled'
          'Enabled '
          'Use for Delivery Address')
        MaxListWidth = 77
        Validate = True
      end
      object SHSSF: TBorCheck
        Tag = 1
        Left = 6
        Top = 155
        Width = 211
        Height = 20
        HelpContext = 368
        Align = alRight
        Caption = 'Set BOM Component Ser.No'#39's on Sales'
        CheckColor = clWindowText
        Color = clBtnFace
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 7
        TabStop = True
        TextId = 0
      end
      object SP2F: TBorCheck
        Tag = 1
        Left = 238
        Top = 2
        Width = 217
        Height = 20
        HelpContext = 731
        Align = alRight
        Caption = 'Show price bands as Margins (not M/Up)'
        CheckColor = clWindowText
        Color = clBtnFace
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 15
        TabStop = True
        TextId = 0
      end
      object LSF: TBorCheck
        Tag = 1
        Left = 6
        Top = 57
        Width = 211
        Height = 20
        HelpContext = 367
        Align = alRight
        Caption = 'Live Stock/Cost of Sales valuation'
        CheckColor = clWindowText
        Color = clBtnFace
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 2
        TabStop = True
        TextId = 0
        OnClick = LSFClick
      end
      object DCF: TBorCheck
        Tag = 1
        Left = 6
        Top = 173
        Width = 211
        Height = 20
        HelpContext = 368
        Align = alRight
        Caption = 'Deduct components if no BOM'#39's in stock'
        CheckColor = clWindowText
        Color = clBtnFace
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 8
        TabStop = True
        TextId = 0
      end
      object FSF: TBorCheck
        Tag = 1
        Left = 6
        Top = 219
        Width = 211
        Height = 20
        HelpContext = 369
        Align = alRight
        Caption = 'Free Stock to exclude sales orders'
        CheckColor = clWindowText
        Color = clBtnFace
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 10
        TabStop = True
        TextId = 0
      end
      object APICK: TBorCheck
        Tag = 1
        Left = 6
        Top = 237
        Width = 211
        Height = 20
        HelpContext = 735
        Align = alRight
        Caption = 'Orders to allocate stock when picked'
        CheckColor = clWindowText
        Color = clBtnFace
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 11
        TabStop = True
        TextId = 0
      end
      object MUF: TBorCheck
        Tag = 1
        Left = 238
        Top = 21
        Width = 211
        Height = 20
        HelpContext = 370
        Align = alRight
        Caption = 'Manually update Re-Order Cost'
        CheckColor = clWindowText
        Color = clBtnFace
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 16
        TabStop = True
        TextId = 0
      end
      object STF: TBorCheck
        Tag = 1
        Left = 6
        Top = 268
        Width = 211
        Height = 20
        HelpContext = 371
        Align = alRight
        Caption = 'SDN'#39's to only show '#39'picked'#39' items'
        CheckColor = clWindowText
        Color = clBtnFace
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 12
        TabStop = True
        TextId = 0
      end
      object UP2F: TBorCheck
        Tag = 1
        Left = 6
        Top = 286
        Width = 211
        Height = 20
        HelpContext = 372
        Align = alRight
        Caption = 'Use '#39'Pack Qty'#39' multiplier on transactions'
        CheckColor = clWindowText
        Color = clBtnFace
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 13
        TabStop = True
        TextId = 0
      end
      object DEFVF: TSBSComboBox
        Tag = 1
        Left = 144
        Top = 6
        Width = 74
        Height = 22
        HelpContext = 380
        Style = csDropDownList
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 0
        ParentFont = False
        TabOrder = 0
        OnEnter = DEFVFEnter
        OnExit = DEFVFExit
        ExtendedList = True
        MaxListWidth = 135
      end
      object SDNTPF: TBorCheck
        Tag = 1
        Left = 6
        Top = 305
        Width = 211
        Height = 20
        HelpContext = 1179
        Align = alRight
        Caption = 'SDN Date is Tax Point Date'
        CheckColor = clWindowText
        Color = clBtnFace
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 14
        TabStop = True
        TextId = 0
      end
      object APUpLF: TBorCheck
        Left = 238
        Top = 40
        Width = 211
        Height = 20
        HelpContext = 1212
        Align = alRight
        Caption = 'Auto Post Uplift to Uplift Control Account'
        CheckColor = clWindowText
        Color = clBtnFace
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 17
        TabStop = True
        TextId = 0
      end
      object RetBinHF: TBorCheck
        Left = 238
        Top = 71
        Width = 211
        Height = 20
        HelpContext = 1453
        Align = alRight
        Caption = 'Retain Bin History'
        CheckColor = clWindowText
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 18
        TabStop = True
        TextId = 0
      end
      object FiltSBLocF: TBorCheck
        Left = 238
        Top = 90
        Width = 211
        Height = 20
        HelpContext = 1454
        Align = alRight
        Caption = 'Filter Serial/Batch/Bin Pick List by Loc'
        CheckColor = clWindowText
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 19
        TabStop = True
        TextId = 0
      end
      object BinMaskF: Text8Pt
        Tag = 1
        Left = 319
        Top = 112
        Width = 80
        Height = 22
        HelpContext = 1455
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
        TabOrder = 20
        OnExit = BinMaskFExit
        TextId = 0
        ViaSBtn = False
      end
      object chkUseTTD: TBorCheck
        Left = 238
        Top = 143
        Width = 211
        Height = 20
        HelpContext = 8000
        Align = alRight
        Caption = 'Use Transaction Total Discounts'
        CheckColor = clWindowText
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 21
        TabStop = True
        TextId = 0
      end
      object chkUseVBD: TBorCheck
        Left = 238
        Top = 162
        Width = 211
        Height = 20
        HelpContext = 8017
        Align = alRight
        Caption = 'Use Value Based Discounts'
        CheckColor = clWindowText
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 22
        TabStop = True
        TextId = 0
      end
      object chkUseOverrideLocations: TBorCheck
        Left = 238
        Top = 190
        Width = 211
        Height = 20
        HelpContext = 40163
        Align = alRight
        Caption = 'Use Override Location on Purchases'
        CheckColor = clWindowText
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 23
        TabStop = True
        TextId = 0
      end
      object chkIncludeVatInCB: TBorCheck
        Left = 238
        Top = 218
        Width = 193
        Height = 20
        HelpContext = 40180
        Align = alRight
        Caption = 'Include VAT in Committed Balances'
        CheckColor = clWindowText
        Color = clBtnFace
        ParentColor = False
        TabOrder = 24
        TabStop = True
        TextId = 0
        OnClick = chkIncludeVatInCBClick
      end
      object chkEnableOrderPayments: TBorCheck
        Left = 238
        Top = 246
        Width = 193
        Height = 20
        HelpContext = 9001
        Align = alRight
        Caption = 'Enable Order Payments'
        CheckColor = clWindowText
        Color = clBtnFace
        ParentColor = False
        TabOrder = 25
        TabStop = True
        TextId = 0
        OnClick = chkEnableOrderPaymentsClick
      end
    end
    object JCPage: TTabSheet
      HelpContext = 1090
      Caption = 'Job Costing'
      object Bevel15: TBevel
        Left = 3
        Top = 185
        Width = 218
        Height = 3
        Shape = bsBottomLine
      end
      object Bevel16: TBevel
        Left = 228
        Top = 2
        Width = 2
        Height = 319
      end
      object Label855: Label8
        Left = 2
        Top = 62
        Width = 72
        Height = 14
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'PPI Supp. A/C'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        PopupMenu = PopupMenu1
        TextId = 0
      end
      object Label856: Label8
        Left = 274
        Top = 4
        Width = 140
        Height = 14
        Caption = 'Summary Category Titles'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TextId = 0
      end
      object JWF: TBorCheck
        Tag = 1
        Left = 4
        Top = 16
        Width = 211
        Height = 20
        HelpContext = 1117
        Align = alRight
        Caption = ' Warn if over budget entering PIN'
        CheckColor = clWindowText
        Color = clBtnFace
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 0
        TabStop = True
        TextId = 0
      end
      object JUPF: TBorCheck
        Tag = 1
        Left = 4
        Top = 36
        Width = 211
        Height = 20
        HelpContext = 1118
        Align = alRight
        Caption = ' Use PPIs (not NOMs) for Time Sheets'
        CheckColor = clWindowText
        Color = clBtnFace
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 1
        TabStop = True
        TextId = 0
      end
      object JSBF: TBorCheck
        Tag = 1
        Left = 4
        Top = 79
        Width = 211
        Height = 20
        HelpContext = 1119
        Align = alRight
        Caption = 'Split Job Budgets by Period'
        CheckColor = clWindowText
        Color = clBtnFace
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 3
        TabStop = True
        TextId = 0
      end
      object JPSF: Text8Pt
        Tag = 1
        Left = 81
        Top = 57
        Width = 80
        Height = 22
        HelpContext = 1118
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
        TabOrder = 2
        OnExit = DSRIFExit
        TextId = 0
        ViaSBtn = False
      end
      object ScrollBox3: TScrollBox
        Left = 230
        Top = 20
        Width = 229
        Height = 273
        TabOrder = 8
        object Label845: Label8
          Left = 42
          Top = 5
          Width = 43
          Height = 14
          Alignment = taRightJustify
          Caption = 'Revenue'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          PopupMenu = PopupMenu1
          TextId = 0
        end
        object Label846: Label8
          Left = 51
          Top = 29
          Width = 34
          Height = 14
          Alignment = taRightJustify
          Caption = 'Labour'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          PopupMenu = PopupMenu1
          TextId = 0
        end
        object Label847: Label8
          Left = 3
          Top = 79
          Width = 82
          Height = 14
          Alignment = taRightJustify
          Caption = 'Direct Expense 1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          PopupMenu = PopupMenu1
          TextId = 0
        end
        object Label848: Label8
          Left = 3
          Top = 106
          Width = 82
          Height = 14
          Alignment = taRightJustify
          Caption = 'Direct Expense 2'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          PopupMenu = PopupMenu1
          TextId = 0
        end
        object Label849: Label8
          Left = 23
          Top = 130
          Width = 62
          Height = 14
          Alignment = taRightJustify
          Caption = 'Stock Issues'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          PopupMenu = PopupMenu1
          TextId = 0
        end
        object Label850: Label8
          Left = 31
          Top = 178
          Width = 54
          Height = 14
          Alignment = taRightJustify
          Caption = 'Overheads'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          PopupMenu = PopupMenu1
          TextId = 0
        end
        object Label851: Label8
          Left = 43
          Top = 229
          Width = 42
          Height = 14
          Alignment = taRightJustify
          Caption = 'Receipts'
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
          Left = -1
          Top = 254
          Width = 86
          Height = 14
          Alignment = taRightJustify
          Caption = ' Work in Progress'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          PopupMenu = PopupMenu1
          TextId = 0
        end
        object Label853: Label8
          Left = 15
          Top = 280
          Width = 70
          Height = 14
          Alignment = taRightJustify
          Caption = 'Retentions S/L'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          PopupMenu = PopupMenu1
          TextId = 0
        end
        object Label854: Label8
          Left = 14
          Top = 306
          Width = 69
          Height = 14
          Alignment = taRightJustify
          Caption = 'Retentions P/L'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          PopupMenu = PopupMenu1
          TextId = 0
        end
        object Label830: Label8
          Left = 1
          Top = 56
          Width = 84
          Height = 14
          Alignment = taRightJustify
          Caption = 'Sub Cont. Labour'
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
          Left = 32
          Top = 156
          Width = 52
          Height = 14
          Alignment = taRightJustify
          Caption = 'Materials 2'
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
          Left = 21
          Top = 206
          Width = 63
          Height = 14
          Alignment = taRightJustify
          Caption = 'Overheads 2'
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
          Left = 13
          Top = 408
          Width = 74
          Height = 14
          Alignment = taRightJustify
          Caption = 'Purchase Apps'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          PopupMenu = PopupMenu1
          TextId = 0
        end
        object Label835: Label8
          Left = 32
          Top = 384
          Width = 55
          Height = 14
          Alignment = taRightJustify
          Caption = 'Sales Apps'
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
          Left = 6
          Top = 332
          Width = 78
          Height = 14
          Alignment = taRightJustify
          Caption = 'Sale Deductions'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          PopupMenu = PopupMenu1
          TextId = 0
        end
        object Label864: Label8
          Left = 0
          Top = 358
          Width = 85
          Height = 14
          Alignment = taRightJustify
          Caption = 'Purch Deductions'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          PopupMenu = PopupMenu1
          TextId = 0
        end
        object JC1F: Text8Pt
          Tag = 1
          Left = 91
          Top = 3
          Width = 117
          Height = 22
          HelpContext = 925
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
          TabOrder = 0
          TextId = 0
          ViaSBtn = False
        end
        object JC2F: Text8Pt
          Tag = 1
          Left = 91
          Top = 28
          Width = 117
          Height = 22
          HelpContext = 925
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
          TabOrder = 1
          TextId = 0
          ViaSBtn = False
        end
        object JC3F: Text8Pt
          Tag = 1
          Left = 91
          Top = 78
          Width = 117
          Height = 22
          HelpContext = 925
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
          TabOrder = 3
          TextId = 0
          ViaSBtn = False
        end
        object JC4F: Text8Pt
          Tag = 1
          Left = 91
          Top = 103
          Width = 117
          Height = 22
          HelpContext = 925
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
          TabOrder = 4
          TextId = 0
          ViaSBtn = False
        end
        object JC5F: Text8Pt
          Tag = 1
          Left = 91
          Top = 128
          Width = 117
          Height = 22
          HelpContext = 925
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
          TabOrder = 5
          TextId = 0
          ViaSBtn = False
        end
        object JC6F: Text8Pt
          Tag = 1
          Left = 91
          Top = 178
          Width = 117
          Height = 22
          HelpContext = 925
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
          TabOrder = 7
          TextId = 0
          ViaSBtn = False
        end
        object JC7F: Text8Pt
          Tag = 1
          Left = 91
          Top = 228
          Width = 117
          Height = 22
          HelpContext = 925
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
          TabOrder = 9
          TextId = 0
          ViaSBtn = False
        end
        object JC8F: Text8Pt
          Tag = 1
          Left = 91
          Top = 253
          Width = 117
          Height = 22
          HelpContext = 925
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
          TabOrder = 10
          TextId = 0
          ViaSBtn = False
        end
        object JC9F: Text8Pt
          Tag = 1
          Left = 91
          Top = 278
          Width = 117
          Height = 22
          HelpContext = 925
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
          TabOrder = 11
          TextId = 0
          ViaSBtn = False
        end
        object JC10F: Text8Pt
          Tag = 1
          Left = 91
          Top = 303
          Width = 117
          Height = 22
          HelpContext = 925
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
          TabOrder = 12
          TextId = 0
          ViaSBtn = False
        end
        object JC11F: Text8Pt
          Tag = 1
          Left = 91
          Top = 53
          Width = 117
          Height = 22
          HelpContext = 925
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
          TabOrder = 2
          TextId = 0
          ViaSBtn = False
        end
        object JC12F: Text8Pt
          Tag = 1
          Left = 91
          Top = 153
          Width = 117
          Height = 22
          HelpContext = 925
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
          TabOrder = 6
          TextId = 0
          ViaSBtn = False
        end
        object JC13F: Text8Pt
          Tag = 1
          Left = 91
          Top = 203
          Width = 117
          Height = 22
          HelpContext = 925
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
          TabOrder = 8
          TextId = 0
          ViaSBtn = False
        end
        object JC16F: Text8Pt
          Tag = 1
          Left = 91
          Top = 403
          Width = 117
          Height = 22
          HelpContext = 925
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
          TextId = 0
          ViaSBtn = False
        end
        object JC15F: Text8Pt
          Tag = 1
          Left = 91
          Top = 378
          Width = 117
          Height = 22
          HelpContext = 925
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
          TabOrder = 15
          TextId = 0
          ViaSBtn = False
        end
        object JC14F: Text8Pt
          Tag = 1
          Left = 91
          Top = 328
          Width = 117
          Height = 22
          HelpContext = 925
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
          TabOrder = 13
          TextId = 0
          ViaSBtn = False
        end
        object JC17F: Text8Pt
          Tag = 1
          Left = 91
          Top = 353
          Width = 117
          Height = 22
          HelpContext = 925
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
          TabOrder = 14
          TextId = 0
          ViaSBtn = False
        end
      end
      object JSPCF: TBorCheck
        Tag = 1
        Left = 4
        Top = 100
        Width = 219
        Height = 20
        HelpContext = 1571
        Align = alRight
        Caption = 'Include unposted purchases in committed'
        CheckColor = clWindowText
        Color = clBtnFace
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 4
        TabStop = True
        TextId = 0
      end
      object JAPYRF: TBorCheck
        Tag = 1
        Left = 4
        Top = 121
        Width = 219
        Height = 20
        HelpContext = 1572
        Align = alRight
        Caption = 'Protect Application "Your Ref"'
        CheckColor = clWindowText
        Color = clBtnFace
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 5
        TabStop = True
        TextId = 0
        OnClick = JAPYRFClick
      end
      object JAIDF: TBorCheck
        Tag = 1
        Left = 4
        Top = 141
        Width = 219
        Height = 20
        HelpContext = 1573
        Align = alRight
        Caption = 'Use Application Date for Invoice'
        CheckColor = clWindowText
        Color = clBtnFace
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 6
        TabStop = True
        TextId = 0
      end
      object JADACF: TBorCheck
        Tag = 1
        Left = 4
        Top = 163
        Width = 219
        Height = 20
        HelpContext = 1660
        Align = alRight
        Caption = 'Delay Application committed until certified'
        CheckColor = clWindowText
        Color = clBtnFace
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 7
        TabStop = True
        TextId = 0
      end
    end
    object WOPPage: TTabSheet
      HelpContext = 1356
      Caption = 'WOP'
      ImageIndex = 7
      object Label866: Label8
        Left = 5
        Top = 60
        Width = 226
        Height = 14
        AutoSize = False
        Caption = ' When copying Stock notes to a Works Order'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object CBWWIPF: TBorCheck
        Tag = 1
        Left = 4
        Top = 36
        Width = 149
        Height = 20
        HelpContext = 1263
        Align = alRight
        Caption = 'Disable Work in Progress'
        CheckColor = clWindowText
        Color = clBtnFace
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 1
        TabStop = True
        TextId = 0
      end
      object CBWAF: TBorCheck
        Tag = 1
        Left = 4
        Top = 12
        Width = 211
        Height = 20
        HelpContext = 1262
        Align = alRight
        Caption = 'Orders to allocate stock when picked'
        CheckColor = clWindowText
        Color = clBtnFace
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 0
        TabStop = True
        TextId = 0
      end
      object CBWSCMF: TSBSComboBox
        Tag = 1
        Left = 4
        Top = 79
        Width = 193
        Height = 22
        HelpContext = 1264
        Style = csDropDownList
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 14
        ParentFont = False
        TabOrder = 2
        Items.Strings = (
          'Copy both Dated & General Notes'
          'Copy General Notes Only'
          'Copy Dated Notes Only')
        MaxListWidth = 77
        Validate = True
      end
    end
    object FaxEPage: TTabSheet
      HelpContext = 1131
      Caption = 'Fax/Email'
      object SBSBackGroup10: TSBSBackGroup
        Left = 5
        Top = 1
        Width = 448
        Height = 152
        Caption = 'Email Setup'
        TextId = 0
      end
      object SBSBackGroup11: TSBSBackGroup
        Left = 5
        Top = 158
        Width = 448
        Height = 126
        Caption = 'Faxing Setup'
        TextId = 0
      end
      object Label81: Label8
        Left = 13
        Top = 26
        Width = 90
        Height = 14
        AutoSize = False
        Caption = 'Your Email Name '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label842: Label8
        Left = 10
        Top = 50
        Width = 95
        Height = 14
        AutoSize = False
        Caption = 'Your Email Address'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label843: Label8
        Left = 13
        Top = 74
        Width = 90
        Height = 14
        AutoSize = False
        Caption = 'SMTP Server Addr'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label844: Label8
        Left = 12
        Top = 99
        Width = 70
        Height = 14
        Caption = 'Default Priority'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label857: Label8
        Left = 13
        Top = 123
        Width = 89
        Height = 14
        Caption = 'Attachment Printer'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label858: Label8
        Left = 13
        Top = 184
        Width = 84
        Height = 14
        Caption = 'Fax Printer Driver'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label859: Label8
        Left = 13
        Top = 206
        Width = 90
        Height = 14
        AutoSize = False
        Caption = 'Fax From Name '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label860: Label8
        Left = 10
        Top = 230
        Width = 95
        Height = 14
        AutoSize = False
        Caption = ' Fax From Tel. No.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label861: Label8
        Left = 229
        Top = 122
        Width = 102
        Height = 14
        Caption = 'Attachment Method   '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label862: Label8
        Left = 13
        Top = 254
        Width = 90
        Height = 14
        AutoSize = False
        Caption = 'Fax Interface Path'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label863: Label8
        Left = 229
        Top = 184
        Width = 87
        Height = 14
        Caption = '             Fax Using'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object EmNameF: Text8Pt
        Tag = 1
        Left = 108
        Top = 24
        Width = 336
        Height = 22
        HelpContext = 1132
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 255
        ParentFont = False
        ParentShowHint = False
        ReadOnly = True
        ShowHint = True
        TabOrder = 0
        TextId = 0
        ViaSBtn = False
      end
      object EmAddF: Text8Pt
        Tag = 1
        Left = 108
        Top = 48
        Width = 336
        Height = 22
        HelpContext = 1133
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 255
        ParentFont = False
        ParentShowHint = False
        ReadOnly = True
        ShowHint = True
        TabOrder = 1
        TextId = 0
        ViaSBtn = False
      end
      object SMTPF: Text8Pt
        Tag = 1
        Left = 108
        Top = 72
        Width = 336
        Height = 22
        HelpContext = 1134
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 255
        ParentFont = False
        ParentShowHint = False
        ReadOnly = True
        ShowHint = True
        TabOrder = 2
        TextId = 0
        ViaSBtn = False
      end
      object EDIEMPF: TSBSComboBox
        Tag = 1
        Left = 108
        Top = 96
        Width = 110
        Height = 21
        HelpContext = 1135
        Style = csDropDownList
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ItemHeight = 13
        ParentFont = False
        TabOrder = 3
        Items.Strings = (
          'Low'
          'Normal'
          'High')
        MaxListWidth = 0
      end
      object EMAPIChk: TBorCheck
        Left = 224
        Top = 97
        Width = 135
        Height = 20
        HelpContext = 1136
        Caption = 'Use MAPI to send Email'
        CheckColor = clWindowText
        Color = clBtnFace
        ParentColor = False
        TabOrder = 4
        TabStop = True
        TextId = 0
      end
      object DefEPrn: TSBSComboBox
        Tag = 1
        Left = 108
        Top = 119
        Width = 110
        Height = 22
        HelpContext = 1208
        Style = csDropDownList
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 14
        ParentFont = False
        TabOrder = 5
        Items.Strings = (
          'None'
          'Automatic'
          'Manual')
        ExtendedList = True
        MaxListWidth = 250
      end
      object DefFaxPrn: TSBSComboBox
        Tag = 1
        Left = 108
        Top = 180
        Width = 110
        Height = 22
        HelpContext = 1182
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
          'None'
          'Automatic'
          'Manual')
        ExtendedList = True
        MaxListWidth = 250
      end
      object FxFromF: Text8Pt
        Tag = 1
        Left = 108
        Top = 204
        Width = 175
        Height = 22
        HelpContext = 1184
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 40
        ParentFont = False
        ParentShowHint = False
        ReadOnly = True
        ShowHint = True
        TabOrder = 9
        TextId = 0
        ViaSBtn = False
      end
      object FxFrTelF: Text8Pt
        Tag = 1
        Left = 108
        Top = 228
        Width = 145
        Height = 22
        HelpContext = 1185
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
        TabOrder = 10
        TextId = 0
        ViaSBtn = False
      end
      object EDIEMAMF: TSBSComboBox
        Tag = 1
        Left = 335
        Top = 119
        Width = 110
        Height = 22
        HelpContext = 1208
        Style = csDropDownList
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 14
        ParentFont = False
        TabOrder = 6
        Items.Strings = (
          'Internal EDF Format'
          'Adobe Acrobat PDF'
          'Internal PDF Format')
        MaxListWidth = 0
      end
      object FxDllPathF: Text8Pt
        Tag = 1
        Left = 108
        Top = 252
        Width = 175
        Height = 22
        HelpContext = 1186
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 40
        ParentFont = False
        ParentShowHint = False
        ReadOnly = True
        ShowHint = True
        TabOrder = 11
        OnDblClick = FxPathBtnClick
        OnExit = FxDllPathFExit
        TextId = 0
        ViaSBtn = False
      end
      object FxPathBtn: TButton
        Left = 286
        Top = 252
        Width = 15
        Height = 22
        HelpContext = 1186
        Caption = '...'
        TabOrder = 12
        OnClick = FxPathBtnClick
      end
      object FMapiChk: TSBSComboBox
        Tag = 1
        Left = 325
        Top = 180
        Width = 120
        Height = 22
        HelpContext = 1182
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
        OnChange = FMAPIChkClick
        Items.Strings = (
          'Exchequer eComms'
          'MAPI'
          'Third Party Fax')
        MaxListWidth = 0
      end
    end
    object SigPage: TTabSheet
      HelpContext = 2300
      Caption = 'Company Signature'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ImageIndex = 8
      ParentFont = False
      object pnlSig: TPanel
        Left = 0
        Top = 0
        Width = 459
        Height = 337
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        object lblEmailSig: TLabel
          Left = 10
          Top = 3
          Width = 73
          Height = 14
          Caption = 'Email Signature'
        end
        object lblFaxSig: TLabel
          Left = 10
          Top = 148
          Width = 67
          Height = 14
          Caption = 'Fax Signature'
        end
        object bvl1: TBevel
          Left = 87
          Top = 10
          Width = 368
          Height = 2
        end
        object bvl2: TBevel
          Left = 81
          Top = 155
          Width = 373
          Height = 2
        end
        object memEmailSig: TMemo
          Left = 4
          Top = 19
          Width = 451
          Height = 127
          Font.Charset = ANSI_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Lines.Strings = (
            '')
          ParentFont = False
          TabOrder = 0
        end
        object memFaxSig: TMemo
          Left = 4
          Top = 164
          Width = 451
          Height = 127
          Font.Charset = ANSI_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Lines.Strings = (
            '')
          ParentFont = False
          TabOrder = 1
        end
      end
    end
  end
  object OkCP1Btn: TButton
    Tag = 1
    Left = 291
    Top = 322
    Width = 80
    Height = 21
    Caption = '&OK'
    Enabled = False
    ModalResult = 1
    TabOrder = 1
    OnClick = OkCP1BtnClick
  end
  object CanCP1Btn: TButton
    Tag = 1
    Left = 377
    Top = 322
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 2
    OnClick = OkCP1BtnClick
  end
  object PopupMenu1: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 230
    Top = 309
    object ExportSettings1: TMenuItem
      Caption = '&Export Settings'
      OnClick = ExportSettings1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object PropFlg: TMenuItem
      Caption = '&Properties'
      Hint = 'Access Colour & Font settings'
      OnClick = PropFlgClick
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object StoreCoordFlg: TMenuItem
      Caption = '&Save Coordinates'
      Hint = 'Make the current window settings permanent'
      OnClick = StoreCoordFlgClick
    end
  end
end
