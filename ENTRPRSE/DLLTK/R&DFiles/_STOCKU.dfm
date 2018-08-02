object StockRec: TStockRec
  Left = 282
  Top = 131
  Width = 566
  Height = 362
  HelpContext = 179
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  Caption = 'Stock Record'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  Position = poDefault
  Scaled = False
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
    Left = 0
    Top = 2
    Width = 558
    Height = 335
    ActivePage = Defaults
    TabIndex = 1
    TabOrder = 0
    OnChange = PageControl1Change
    OnChanging = PageControl1Changing
    object Main: TTabSheet
      HelpContext = 179
      Caption = 'Main'
      object TCMScrollBox: TScrollBox
        Left = -2
        Top = 0
        Width = 437
        Height = 305
        VertScrollBar.Visible = False
        BorderStyle = bsNone
        TabOrder = 0
        object SBSBackGroup1: TSBSBackGroup
          Left = 5
          Top = 2
          Width = 268
          Height = 145
          Caption = 'Stock Code/Description'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          TextId = 0
        end
        object Label85: Label8
          Left = 174
          Top = 27
          Width = 24
          Height = 14
          Caption = 'Type'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object SBSBackGroup2: TSBSBackGroup
          Left = 5
          Top = 149
          Width = 268
          Height = 143
          TextId = 0
        end
        object Label828: Label8
          Left = 28
          Top = 196
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
        object Label829: Label8
          Left = 33
          Top = 220
          Width = 22
          Height = 14
          Caption = 'Cost'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label830: Label8
          Left = 12
          Top = 245
          Width = 43
          Height = 14
          Caption = 'Re-order'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object SBSBackGroup3: TSBSBackGroup
          Left = 278
          Top = 245
          Width = 141
          Height = 47
          TextId = 0
        end
        object ValLab: Label8
          Left = 10
          Top = 263
          Width = 45
          Height = 14
          Caption = 'Valuation'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object ValLab2: Label8
          Left = 20
          Top = 276
          Width = 35
          Height = 14
          Caption = 'Method'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object SBSBackGroup4: TSBSBackGroup
          Left = 278
          Top = 2
          Width = 141
          Height = 241
          TextId = 0
        end
        object Label836: Label8
          Left = 304
          Top = 90
          Width = 26
          Height = 14
          Caption = 'In Stk'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label837: Label8
          Left = 285
          Top = 148
          Width = 45
          Height = 14
          Caption = 'Allocated'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label838: Label8
          Left = 281
          Top = 176
          Width = 49
          Height = 14
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Free Stk'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label834: Label8
          Left = 285
          Top = 216
          Width = 45
          Height = 14
          Caption = 'On Order'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label835: Label8
          Left = 289
          Top = 119
          Width = 41
          Height = 14
          Caption = '(Posted)'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label827: Label8
          Left = 296
          Top = 21
          Width = 34
          Height = 14
          Caption = 'Min Stk'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label831: Label8
          Left = 292
          Top = 51
          Width = 38
          Height = 14
          Caption = 'Max Stk'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Bevel1: TBevel
          Left = 290
          Top = 76
          Width = 122
          Height = 2
        end
        object Bevel2: TBevel
          Left = 288
          Top = 202
          Width = 123
          Height = 2
        end
        object Label832: Label8
          Left = 10
          Top = 166
          Width = 45
          Height = 14
          Caption = 'Priced by'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label1: TLabel
          Left = 284
          Top = 259
          Width = 103
          Height = 26
          Alignment = taRightJustify
          Caption = 'Show stock levels as sales units (packs)'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          WordWrap = True
        end
        object Label818: Label8
          Left = 207
          Top = 194
          Width = 24
          Height = 14
          Caption = 'More'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object SROOF: TCurrencyEdit
          Left = 332
          Top = 211
          Width = 80
          Height = 22
          HelpContext = 195
          TabStop = False
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Lines.Strings = (
            '0.00 ')
          ParentFont = False
          ReadOnly = True
          TabOrder = 17
          WantReturns = False
          WordWrap = False
          AutoSize = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
          ShowCurrency = False
          TextId = 0
          Value = 1E-10
        end
        object SRCF: Text8Pt
          Tag = 1
          Left = 13
          Top = 23
          Width = 153
          Height = 22
          HelpContext = 188
          Color = clGreen
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ReadOnly = True
          ShowHint = True
          TabOrder = 0
          OnExit = SRCFExit
          TextId = 0
          ViaSBtn = False
        end
        object SRSBox1: TScrollBox
          Left = 13
          Top = 49
          Width = 246
          Height = 95
          HelpContext = 162
          HorzScrollBar.Visible = False
          Ctl3D = True
          ParentCtl3D = False
          TabOrder = 2
          OnExit = SRSBox1Exit
          object Label812: Label8
            Left = 218
            Top = 6
            Width = 6
            Height = 14
            Caption = '1'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TextId = 0
          end
          object Label813: Label8
            Left = 218
            Top = 28
            Width = 6
            Height = 14
            Caption = '2'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TextId = 0
          end
          object Label814: Label8
            Left = 218
            Top = 52
            Width = 6
            Height = 14
            Caption = '3'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TextId = 0
          end
          object Label815: Label8
            Left = 218
            Top = 75
            Width = 6
            Height = 14
            Caption = '4'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TextId = 0
          end
          object Label816: Label8
            Left = 218
            Top = 98
            Width = 6
            Height = 14
            Caption = '5'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TextId = 0
          end
          object Label817: Label8
            Left = 218
            Top = 120
            Width = 6
            Height = 14
            Caption = '6'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TextId = 0
          end
          object SRD1F: Text8Pt
            Tag = 1
            Left = -2
            Top = 2
            Width = 218
            Height = 22
            AutoSize = False
            Color = clGreen
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWhite
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            MaxLength = 50
            ParentFont = False
            ParentShowHint = False
            ReadOnly = True
            ShowHint = True
            TabOrder = 0
            OnKeyPress = SRD1FKeyPress
            TextId = 0
            ViaSBtn = False
          end
          object SRD2F: Text8Pt
            Tag = 1
            Left = -2
            Top = 25
            Width = 218
            Height = 22
            AutoSize = False
            Color = clGreen
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWhite
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            MaxLength = 50
            ParentFont = False
            ParentShowHint = False
            ReadOnly = True
            ShowHint = True
            TabOrder = 1
            OnKeyPress = SRD1FKeyPress
            TextId = 0
            ViaSBtn = False
          end
          object SRD3F: Text8Pt
            Tag = 1
            Left = -2
            Top = 48
            Width = 218
            Height = 22
            AutoSize = False
            Color = clGreen
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWhite
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            MaxLength = 50
            ParentFont = False
            ParentShowHint = False
            ReadOnly = True
            ShowHint = True
            TabOrder = 2
            OnKeyPress = SRD1FKeyPress
            TextId = 0
            ViaSBtn = False
          end
          object SRD4F: Text8Pt
            Tag = 1
            Left = -2
            Top = 71
            Width = 218
            Height = 22
            AutoSize = False
            Color = clGreen
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWhite
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            MaxLength = 50
            ParentFont = False
            ParentShowHint = False
            ReadOnly = True
            ShowHint = True
            TabOrder = 3
            OnKeyPress = SRD1FKeyPress
            TextId = 0
            ViaSBtn = False
          end
          object SRD5F: Text8Pt
            Tag = 1
            Left = -2
            Top = 94
            Width = 218
            Height = 22
            AutoSize = False
            Color = clGreen
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWhite
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            MaxLength = 50
            ParentFont = False
            ParentShowHint = False
            ReadOnly = True
            ShowHint = True
            TabOrder = 4
            OnKeyPress = SRD1FKeyPress
            TextId = 0
            ViaSBtn = False
          end
          object SRD6F: Text8Pt
            Tag = 1
            Left = -2
            Top = 117
            Width = 218
            Height = 22
            AutoSize = False
            Color = clGreen
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWhite
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            MaxLength = 50
            ParentFont = False
            ParentShowHint = False
            ReadOnly = True
            ShowHint = True
            TabOrder = 5
            OnKeyPress = SRD1FKeyPress
            TextId = 0
            ViaSBtn = False
          end
        end
        object SRISF: TCurrencyEdit
          Left = 332
          Top = 85
          Width = 80
          Height = 22
          HelpContext = 195
          TabStop = False
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Lines.Strings = (
            '0.00 ')
          ParentFont = False
          ReadOnly = True
          TabOrder = 13
          WantReturns = False
          WordWrap = False
          AutoSize = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
          ShowCurrency = False
          TextId = 0
          Value = 1E-10
        end
        object SRPOF: TCurrencyEdit
          Left = 332
          Top = 114
          Width = 80
          Height = 22
          HelpContext = 195
          TabStop = False
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Lines.Strings = (
            '0.00 ')
          ParentFont = False
          ReadOnly = True
          TabOrder = 14
          WantReturns = False
          WordWrap = False
          AutoSize = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
          ShowCurrency = False
          TextId = 0
          Value = 1E-10
        end
        object SRALF: TCurrencyEdit
          Left = 332
          Top = 143
          Width = 80
          Height = 22
          HelpContext = 195
          TabStop = False
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Lines.Strings = (
            '0.00 ')
          ParentFont = False
          ReadOnly = True
          TabOrder = 15
          WantReturns = False
          WordWrap = False
          AutoSize = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
          ShowCurrency = False
          TextId = 0
          Value = 1E-10
        end
        object SRFRF: TCurrencyEdit
          Left = 332
          Top = 171
          Width = 80
          Height = 22
          HelpContext = 195
          TabStop = False
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Lines.Strings = (
            '0.00 ')
          ParentFont = False
          ReadOnly = True
          TabOrder = 16
          WantReturns = False
          WordWrap = False
          AutoSize = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
          ShowCurrency = False
          TextId = 0
          Value = 1E-10
        end
        object SRCPF: TCurrencyEdit
          Tag = 1
          Left = 107
          Top = 215
          Width = 95
          Height = 22
          HelpContext = 191
          Color = clGreen
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Lines.Strings = (
            '0.00 ')
          ParentFont = False
          ReadOnly = True
          TabOrder = 6
          WantReturns = False
          WordWrap = False
          AutoSize = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
          ShowCurrency = False
          TextId = 0
          Value = 1E-10
        end
        object SRRPF: TCurrencyEdit
          Tag = 1
          Left = 107
          Top = 240
          Width = 95
          Height = 22
          HelpContext = 192
          Color = clGreen
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Lines.Strings = (
            '0.00 ')
          ParentFont = False
          ReadOnly = True
          TabOrder = 8
          WantReturns = False
          WordWrap = False
          AutoSize = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
          ShowCurrency = False
          TextId = 0
          Value = 1E-10
        end
        object SRTF: TSBSComboBox
          Tag = 1
          Left = 202
          Top = 23
          Width = 57
          Height = 22
          HelpContext = 161
          Color = clGreen
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ItemHeight = 14
          ParentFont = False
          TabOrder = 1
          OnEnter = SRTFEnter
          OnExit = SRTFExit
          ExtendedList = True
          MaxListWidth = 90
          ReadOnly = True
          Validate = True
        end
        object SRCPCF: TSBSComboBox
          Tag = 1
          Left = 57
          Top = 215
          Width = 48
          Height = 22
          HelpContext = 191
          Color = clGreen
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ItemHeight = 14
          MaxLength = 3
          ParentFont = False
          TabOrder = 5
          ExtendedList = True
          MaxListWidth = 115
          ReadOnly = True
          Validate = True
        end
        object SRRPCF: TSBSComboBox
          Tag = 1
          Left = 57
          Top = 240
          Width = 48
          Height = 22
          HelpContext = 192
          Color = clGreen
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ItemHeight = 14
          MaxLength = 3
          ParentFont = False
          TabOrder = 7
          ExtendedList = True
          MaxListWidth = 115
          ReadOnly = True
          Validate = True
        end
        object SRMIF: TCurrencyEdit
          Tag = 1
          Left = 332
          Top = 18
          Width = 80
          Height = 22
          HelpContext = 194
          Color = clGreen
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
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
          OnEnter = SRMIFEnter
          OnExit = SRMIFExit
          AutoSize = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
          ShowCurrency = False
          TextId = 0
          Value = 1E-10
        end
        object SRMXF: TCurrencyEdit
          Tag = 1
          Left = 332
          Top = 47
          Width = 80
          Height = 22
          HelpContext = 194
          Color = clGreen
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Lines.Strings = (
            '0.00 ')
          ParentFont = False
          ReadOnly = True
          TabOrder = 12
          WantReturns = False
          WordWrap = False
          OnEnter = SRMXFEnter
          OnExit = SRMXFExit
          AutoSize = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
          ShowCurrency = False
          TextId = 0
          Value = 1E-10
        end
        object SRVMF: TSBSComboBox
          Tag = 1
          Left = 57
          Top = 265
          Width = 117
          Height = 22
          HelpContext = 193
          Color = clGreen
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ItemHeight = 14
          ParentFont = False
          TabOrder = 9
          OnExit = SRVMFExit
          MaxListWidth = 77
          ReadOnly = True
          Validate = True
        end
        object SRPComboF: TSBSComboBox
          Tag = 1
          Left = 57
          Top = 163
          Width = 186
          Height = 22
          HelpContext = 189
          Color = clGreen
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ItemHeight = 14
          ParentFont = False
          TabOrder = 3
          OnExit = SRVMFExit
          MaxListWidth = 77
          ReadOnly = True
          Validate = True
        end
        object SRSPF: TBorCheck
          Tag = 1
          Left = 394
          Top = 261
          Width = 16
          Height = 20
          HelpContext = 544
          Align = alRight
          Color = clBtnFace
          Enabled = False
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
        object EditSPBtn: TSBSButton
          Left = 235
          Top = 190
          Width = 31
          Height = 21
          Caption = '>>'
          TabOrder = 19
          OnClick = EditSPBtnClick
          TextId = 0
        end
        object SRSP1F: TCurrencyEdit
          Tag = 1
          Left = 57
          Top = 190
          Width = 95
          Height = 22
          Color = clGreen
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
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
          OnDblClick = EditSPBtnClick
          OnExit = SRSP1FExit
          AutoSize = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
          ShowCurrency = True
          TextId = 0
          Value = 1E-10
        end
        object SRGP1: TCurrencyEdit
          Tag = 1
          Left = 153
          Top = 190
          Width = 49
          Height = 22
          Color = clGreen
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Lines.Strings = (
            '1.0 ')
          ParentFont = False
          ReadOnly = True
          TabOrder = 20
          WantReturns = False
          WordWrap = False
          AutoSize = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.0 ;###,###,##0.0-'
          DecPlaces = 1
          ShowCurrency = False
          TextId = 0
          Value = 1
        end
        object SRMBF: TBorCheck
          Tag = 1
          Left = 177
          Top = 264
          Width = 91
          Height = 20
          HelpContext = 1459
          Caption = 'Use Multi Bins'
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
      end
    end
    object Defaults: TTabSheet
      HelpContext = 196
      Caption = 'Defaults'
      object SBSBackGroup6: TSBSBackGroup
        Left = 4
        Top = 136
        Width = 426
        Height = 167
        TextId = 0
      end
      object SBSBackGroup7: TSBSBackGroup
        Left = 234
        Top = -3
        Width = 196
        Height = 141
        TextId = 0
      end
      object SBSBackGroup5: TSBSBackGroup
        Left = 4
        Top = -3
        Width = 227
        Height = 141
        TextId = 0
      end
      object Label88: Label8
        Left = 14
        Top = 13
        Width = 65
        Height = 14
        Caption = 'Pref. Supplier'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label89: Label8
        Left = 35
        Top = 38
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
      object CCLab: Label8
        Left = 43
        Top = 63
        Width = 36
        Height = 14
        Caption = 'CC/Dep'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label839: Label8
        Left = 261
        Top = 16
        Width = 81
        Height = 14
        Caption = 'Unit of Stock Qty'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label840: Label8
        Left = 287
        Top = 41
        Width = 55
        Height = 14
        Caption = 'Unit of Sale'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label841: Label8
        Left = 262
        Top = 66
        Width = 80
        Height = 14
        Caption = 'Unit of Purchase'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label842: Label8
        Left = 259
        Top = 91
        Width = 84
        Height = 14
        Caption = 'Sales Units/Stock'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label843: Label8
        Left = 258
        Top = 116
        Width = 85
        Height = 14
        Caption = 'Purch Units/Stock'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label811: Label8
        Left = 33
        Top = 112
        Width = 45
        Height = 14
        Caption = 'Bar Code'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label810: Label8
        Left = 13
        Top = 87
        Width = 65
        Height = 14
        Caption = 'Location / Bin'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label81: Label8
        Left = 89
        Top = 151
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
      object Label82: Label8
        Left = 51
        Top = 177
        Width = 65
        Height = 14
        Caption = 'Cost of Sales'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label83: Label8
        Left = 9
        Top = 202
        Width = 109
        Height = 14
        Caption = 'Closing Stk/ Write Offs'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label84: Label8
        Left = 58
        Top = 228
        Width = 58
        Height = 14
        Caption = 'Stock Value'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object WIPLab: Label8
        Left = 11
        Top = 253
        Width = 105
        Height = 14
        Caption = 'BoM / Finished Goods'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object JALab: Label8
        Left = 15
        Top = 278
        Width = 101
        Height = 14
        Caption = 'Job Costing Analysis'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object SRGSF: Text8Pt
        Tag = 1
        Left = 119
        Top = 148
        Width = 102
        Height = 22
        HelpContext = 201
        AutoSize = False
        Color = clGreen
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ReadOnly = True
        ShowHint = True
        TabOrder = 7
        OnExit = SRGSFExit
        TextId = 0
        ViaSBtn = False
      end
      object SRGCF: Text8Pt
        Tag = 1
        Left = 119
        Top = 173
        Width = 102
        Height = 22
        HelpContext = 202
        AutoSize = False
        Color = clGreen
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ReadOnly = True
        ShowHint = True
        TabOrder = 9
        OnExit = SRGSFExit
        TextId = 0
        ViaSBtn = False
      end
      object SRGVF: Text8Pt
        Tag = 1
        Left = 119
        Top = 223
        Width = 102
        Height = 22
        HelpContext = 204
        AutoSize = False
        Color = clGreen
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ReadOnly = True
        ShowHint = True
        TabOrder = 13
        OnExit = SRGSFExit
        TextId = 0
        ViaSBtn = False
      end
      object SRGWF: Text8Pt
        Tag = 1
        Left = 119
        Top = 198
        Width = 102
        Height = 22
        HelpContext = 203
        AutoSize = False
        Color = clGreen
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ReadOnly = True
        ShowHint = True
        TabOrder = 11
        OnExit = SRGSFExit
        TextId = 0
        ViaSBtn = False
      end
      object SRGPF: Text8Pt
        Tag = 1
        Left = 119
        Top = 248
        Width = 102
        Height = 22
        HelpContext = 205
        AutoSize = False
        Color = clGreen
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ReadOnly = True
        ShowHint = True
        TabOrder = 15
        OnExit = SRGSFExit
        TextId = 0
        ViaSBtn = False
      end
      object SRDepF: Text8Pt
        Tag = 1
        Left = 154
        Top = 59
        Width = 68
        Height = 22
        HelpContext = 199
        AutoSize = False
        Color = clGreen
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ReadOnly = True
        ShowHint = True
        TabOrder = 3
        OnExit = SRCCFExit
        TextId = 0
        ViaSBtn = False
      end
      object SRCCF: Text8Pt
        Tag = 1
        Left = 83
        Top = 59
        Width = 68
        Height = 22
        HelpContext = 199
        AutoSize = False
        Color = clGreen
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ReadOnly = True
        ShowHint = True
        TabOrder = 2
        OnExit = SRCCFExit
        TextId = 0
        ViaSBtn = False
      end
      object SRJAF: Text8Pt
        Tag = 1
        Left = 119
        Top = 273
        Width = 102
        Height = 22
        HelpContext = 208
        AutoSize = False
        Color = clGreen
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ReadOnly = True
        ShowHint = True
        TabOrder = 17
        OnExit = SRJAFExit
        TextId = 0
        ViaSBtn = False
      end
      object SRFSF: Text8Pt
        Tag = 1
        Left = 83
        Top = 9
        Width = 78
        Height = 22
        Hint = 
          'Double click to drill down|Double clicking or using the down but' +
          'ton will drill down to the record for this field. The up button ' +
          'will search for the nearest match.'
        HelpContext = 198
        AutoSize = False
        Color = clGreen
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ReadOnly = True
        ShowHint = True
        TabOrder = 0
        OnExit = SRFSFExit
        TextId = 0
        ViaSBtn = False
        Link_to_Cust = True
        ShowHilight = True
      end
      object SRACF: Text8Pt
        Tag = 1
        Left = 83
        Top = 34
        Width = 139
        Height = 22
        HelpContext = 197
        AutoSize = False
        Color = clGreen
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ReadOnly = True
        ShowHint = True
        TabOrder = 1
        TextId = 0
        ViaSBtn = False
      end
      object SRBLF: TExMaskEdit
        Tag = 1
        Left = 154
        Top = 84
        Width = 68
        Height = 22
        HelpContext = 200
        AutoSize = False
        CharCase = ecUpperCase
        Color = clGreen
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ReadOnly = True
        ShowHint = True
        TabOrder = 5
        OnEnter = SRBLFEnter
        TextId = 0
        ViaSBtn = False
        OnMaskError = SRBLFMaskError
        OnSetFocusBack = SRBLFSetFocusBack
      end
      object SRUQF: Text8Pt
        Tag = 1
        Left = 346
        Top = 10
        Width = 75
        Height = 22
        HelpContext = 210
        AutoSize = False
        Color = clGreen
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ReadOnly = True
        ShowHint = True
        TabOrder = 19
        OnChange = SRUQFChange
        TextId = 0
        ViaSBtn = False
      end
      object SRUSF: Text8Pt
        Tag = 1
        Left = 346
        Top = 35
        Width = 75
        Height = 22
        HelpContext = 211
        AutoSize = False
        Color = clGreen
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ReadOnly = True
        ShowHint = True
        TabOrder = 20
        OnChange = SRUQFChange
        TextId = 0
        ViaSBtn = False
      end
      object SRUPF: Text8Pt
        Tag = 1
        Left = 346
        Top = 60
        Width = 75
        Height = 22
        HelpContext = 212
        AutoSize = False
        Color = clGreen
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ReadOnly = True
        ShowHint = True
        TabOrder = 21
        TextId = 0
        ViaSBtn = False
      end
      object SRSUF: TCurrencyEdit
        Tag = 1
        Left = 346
        Top = 85
        Width = 75
        Height = 22
        HelpContext = 213
        Color = clGreen
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          '0.0000 ')
        ParentFont = False
        ReadOnly = True
        TabOrder = 22
        WantReturns = False
        WordWrap = False
        AutoSize = False
        BlankOnZero = False
        DisplayFormat = '###,###,##0.0000 ;###,###,##0.0000-'
        DecPlaces = 4
        ShowCurrency = False
        TextId = 0
        Value = 1E-10
      end
      object SRPUF: TCurrencyEdit
        Tag = 1
        Left = 346
        Top = 110
        Width = 75
        Height = 22
        HelpContext = 214
        Color = clGreen
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          '0.0000 ')
        ParentFont = False
        ReadOnly = True
        TabOrder = 23
        WantReturns = False
        WordWrap = False
        OnExit = SRPUFExit
        AutoSize = False
        BlankOnZero = False
        DisplayFormat = '###,###,##0.0000 ;###,###,##0.0000-'
        DecPlaces = 4
        ShowCurrency = False
        TextId = 0
        Value = 1E-10
      end
      object SRBCF: Text8Pt
        Tag = 1
        Left = 83
        Top = 109
        Width = 139
        Height = 22
        HelpContext = 200
        AutoSize = False
        CharCase = ecUpperCase
        Color = clGreen
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
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
      object SRLocF: Text8Pt
        Tag = 1
        Left = 83
        Top = 84
        Width = 68
        Height = 22
        HelpContext = 911
        AutoSize = False
        Color = clGreen
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ReadOnly = True
        ShowHint = True
        TabOrder = 4
        OnExit = SRLocFExit
        TextId = 0
        ViaSBtn = False
      end
      object SGLDF: Text8Pt
        Left = 225
        Top = 148
        Width = 196
        Height = 22
        HelpContext = 201
        TabStop = False
        AutoSize = False
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
        TabOrder = 8
        OnExit = SRGSFExit
        TextId = 0
        ViaSBtn = False
      end
      object CGLDF: Text8Pt
        Left = 225
        Top = 173
        Width = 196
        Height = 22
        HelpContext = 201
        TabStop = False
        AutoSize = False
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
        TabOrder = 10
        OnExit = SRGSFExit
        TextId = 0
        ViaSBtn = False
      end
      object WGLDF: Text8Pt
        Left = 225
        Top = 198
        Width = 196
        Height = 22
        HelpContext = 201
        TabStop = False
        AutoSize = False
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
        TabOrder = 12
        OnExit = SRGSFExit
        TextId = 0
        ViaSBtn = False
      end
      object KGLDF: Text8Pt
        Left = 225
        Top = 223
        Width = 196
        Height = 22
        HelpContext = 201
        TabStop = False
        AutoSize = False
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
        TabOrder = 14
        OnExit = SRGSFExit
        TextId = 0
        ViaSBtn = False
      end
      object FGLDF: Text8Pt
        Left = 225
        Top = 248
        Width = 196
        Height = 22
        HelpContext = 201
        TabStop = False
        AutoSize = False
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
        TabOrder = 16
        OnExit = SRGSFExit
        TextId = 0
        ViaSBtn = False
      end
      object JADF: Text8Pt
        Left = 225
        Top = 273
        Width = 196
        Height = 22
        HelpContext = 201
        TabStop = False
        AutoSize = False
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
        TabOrder = 18
        OnExit = SRGSFExit
        TextId = 0
        ViaSBtn = False
      end
    end
    object Def2Page: TTabSheet
      HelpContext = 22
      Caption = 'VAT/Web'
      ImageIndex = 8
      object SBSBackGroup9: TSBSBackGroup
        Left = 241
        Top = 0
        Width = 197
        Height = 147
        TextId = 0
      end
      object SBSBackGroup8: TSBSBackGroup
        Left = 6
        Top = 0
        Width = 231
        Height = 303
        TextId = 0
      end
      object VATLab: Label8
        Left = 30
        Top = 94
        Width = 91
        Height = 14
        Alignment = taRightJustify
        AutoSize = False
        Caption = ' Rate'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object UD1Lab: Label8
        Left = 245
        Top = 44
        Width = 80
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
        TextId = 0
      end
      object UD2Lab: Label8
        Left = 245
        Top = 71
        Width = 80
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
        TextId = 0
      end
      object Label833: Label8
        Left = 279
        Top = 17
        Width = 44
        Height = 14
        Caption = 'LineType'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object UD3Lab: Label8
        Left = 244
        Top = 97
        Width = 80
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
        TextId = 0
      end
      object UD4Lab: Label8
        Left = 244
        Top = 124
        Width = 80
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
        TextId = 0
      end
      object Label849: Label8
        Left = 41
        Top = 119
        Width = 80
        Height = 14
        Caption = 'Commodity Code'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label850: Label8
        Left = 22
        Top = 144
        Width = 99
        Height = 14
        Caption = 'SSD Unit Description'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label851: Label8
        Left = 11
        Top = 171
        Width = 110
        Height = 14
        Caption = 'Stock Units in SSD Unit'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label852: Label8
        Left = 13
        Top = 197
        Width = 108
        Height = 14
        Caption = 'Sales Unit Weight (Kg)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label853: Label8
        Left = 12
        Top = 222
        Width = 109
        Height = 14
        Caption = 'Purch Unit Weight (Kg)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label847: Label8
        Left = 51
        Top = 242
        Width = 70
        Height = 28
        Alignment = taRightJustify
        Caption = 'Intrastat State Uplift'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        WordWrap = True
        TextId = 0
      end
      object Label848: Label8
        Left = 38
        Top = 271
        Width = 83
        Height = 28
        Alignment = taRightJustify
        Caption = 'Intrastat Country of Origin'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        WordWrap = True
        TextId = 0
      end
      object Label826: Label8
        Left = 46
        Top = 35
        Width = 76
        Height = 14
        Caption = ' Web Catalogue'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label844: Label8
        Left = 48
        Top = 61
        Width = 73
        Height = 14
        Caption = 'Image Filename'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Bevel9: TBevel
        Left = 12
        Top = 83
        Width = 216
        Height = 2
      end
      object SRLTF: TSBSComboBox
        Tag = 1
        Left = 328
        Top = 14
        Width = 68
        Height = 22
        HelpContext = 276
        Color = clGreen
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 14
        MaxLength = 40
        ParentFont = False
        TabOrder = 11
        ExtendedList = True
        MaxListWidth = 75
        ReadOnly = True
        Validate = True
      end
      object SRVCF: TSBSComboBox
        Tag = 1
        Left = 126
        Top = 89
        Width = 38
        Height = 22
        HelpContext = 206
        Color = clGreen
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 14
        MaxLength = 1
        ParentFont = False
        TabOrder = 3
        OnExit = SRVCFExit
        ExtendedList = True
        MaxListWidth = 95
        ReadOnly = True
        Validate = True
      end
      object UD1F: Text8Pt
        Tag = 1
        Left = 328
        Top = 40
        Width = 100
        Height = 22
        HelpContext = 209
        AutoSize = False
        Color = clGreen
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ReadOnly = True
        ShowHint = True
        TabOrder = 12
        OnExit = UD1FExit
        TextId = 0
        ViaSBtn = False
        OnEntHookEvent = UD1FEntHookEvent
      end
      object UD2F: Text8Pt
        Tag = 1
        Left = 328
        Top = 66
        Width = 100
        Height = 22
        HelpContext = 209
        AutoSize = False
        Color = clGreen
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ReadOnly = True
        ShowHint = True
        TabOrder = 13
        OnExit = UD1FExit
        TextId = 0
        ViaSBtn = False
        OnEntHookEvent = UD1FEntHookEvent
      end
      object UD3F: Text8Pt
        Tag = 1
        Left = 328
        Top = 92
        Width = 100
        Height = 22
        HelpContext = 209
        AutoSize = False
        Color = clGreen
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ReadOnly = True
        ShowHint = True
        TabOrder = 14
        OnExit = UD1FExit
        TextId = 0
        ViaSBtn = False
        OnEntHookEvent = UD1FEntHookEvent
      end
      object UD4F: Text8Pt
        Tag = 1
        Left = 328
        Top = 118
        Width = 100
        Height = 22
        HelpContext = 209
        AutoSize = False
        Color = clGreen
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ReadOnly = True
        ShowHint = True
        TabOrder = 15
        OnExit = UD1FExit
        TextId = 0
        ViaSBtn = False
        OnEntHookEvent = UD1FEntHookEvent
      end
      object emWebF: TBorCheck
        Tag = 1
        Left = 26
        Top = 8
        Width = 116
        Height = 20
        HelpContext = 1172
        Caption = 'Include on Web '
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
        TextId = 0
      end
      object CCodeF: Text8Pt
        Tag = 1
        Left = 126
        Top = 115
        Width = 102
        Height = 22
        HelpContext = 207
        CharCase = ecUpperCase
        Color = clGreen
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 8
        ParentFont = False
        ParentShowHint = False
        ReadOnly = True
        ShowHint = True
        TabOrder = 4
        TextId = 0
        ViaSBtn = False
      end
      object SSUDF: Text8Pt
        Tag = 1
        Left = 126
        Top = 141
        Width = 102
        Height = 22
        HelpContext = 207
        Color = clGreen
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 10
        ParentFont = False
        ParentShowHint = False
        ReadOnly = True
        ShowHint = True
        TabOrder = 5
        TextId = 0
        ViaSBtn = False
      end
      object SSDUF: TCurrencyEdit
        Tag = 1
        Left = 126
        Top = 167
        Width = 102
        Height = 22
        HelpContext = 207
        Color = clGreen
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          '0.67-')
        ParentFont = False
        ReadOnly = True
        TabOrder = 6
        WantReturns = False
        WordWrap = False
        AutoSize = False
        BlankOnZero = False
        DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
        ShowCurrency = False
        TextId = 0
        Value = -0.666666
      end
      object SWF: TCurrencyEdit
        Tag = 1
        Left = 126
        Top = 193
        Width = 102
        Height = 22
        HelpContext = 207
        Color = clGreen
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          '0.67-')
        ParentFont = False
        ReadOnly = True
        TabOrder = 7
        WantReturns = False
        WordWrap = False
        AutoSize = False
        BlankOnZero = False
        DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
        ShowCurrency = False
        TextId = 0
        Value = -0.666666
      end
      object PWF: TCurrencyEdit
        Tag = 1
        Left = 126
        Top = 219
        Width = 102
        Height = 22
        HelpContext = 207
        Color = clGreen
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          '0.67-')
        ParentFont = False
        ReadOnly = True
        TabOrder = 8
        WantReturns = False
        WordWrap = False
        AutoSize = False
        BlankOnZero = False
        DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
        ShowCurrency = False
        TextId = 0
        Value = -0.666666
      end
      object SRSUP: TCurrencyEdit
        Tag = 1
        Left = 126
        Top = 246
        Width = 49
        Height = 22
        HelpContext = 74
        Color = clGreen
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          '1.0 ')
        ParentFont = False
        ReadOnly = True
        TabOrder = 9
        WantReturns = False
        WordWrap = False
        AutoSize = False
        BlankOnZero = False
        DisplayFormat = '###,###,##0.0 ;###,###,##0.0-'
        DecPlaces = 1
        ShowCurrency = False
        TextId = 0
        Value = 1
      end
      object SRCOF: Text8Pt
        Tag = 1
        Left = 126
        Top = 273
        Width = 102
        Height = 22
        HelpContext = 74
        AutoSize = False
        Color = clGreen
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 5
        ParentFont = False
        ParentShowHint = False
        ReadOnly = True
        ShowHint = True
        TabOrder = 10
        TextId = 0
        ViaSBtn = False
      end
      object WebCatF: Text8Pt
        Tag = 1
        Left = 126
        Top = 31
        Width = 102
        Height = 22
        HelpContext = 1173
        CharCase = ecUpperCase
        Color = clGreen
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 8
        ParentFont = False
        ParentShowHint = False
        ReadOnly = True
        ShowHint = True
        TabOrder = 1
        TextId = 0
        ViaSBtn = False
      end
      object WebImgF: Text8Pt
        Tag = 1
        Left = 126
        Top = 57
        Width = 102
        Height = 22
        HelpContext = 1174
        Color = clGreen
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
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
    end
    object WOPPage: TTabSheet
      HelpContext = 1267
      Caption = 'WOP'
      ImageIndex = 10
      object SBSBackGroup11: TSBSBackGroup
        Left = 2
        Top = 4
        Width = 426
        Height = 105
        TextId = 0
      end
      object SBSBackGroup10: TSBSBackGroup
        Left = 2
        Top = 111
        Width = 219
        Height = 111
        TextId = 0
      end
      object Label854: Label8
        Left = 6
        Top = 196
        Width = 99
        Height = 14
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Picked on WOR'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label845: Label8
        Left = 8
        Top = 157
        Width = 99
        Height = 14
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Issued to WOR'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label846: Label8
        Left = 6
        Top = 130
        Width = 102
        Height = 14
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Allocated to WOR'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label855: Label8
        Left = 34
        Top = 81
        Width = 73
        Height = 14
        Alignment = taRightJustify
        Caption = 'Issued WIP G/L'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label856: Label8
        Left = 7
        Top = 30
        Width = 102
        Height = 14
        AutoSize = False
        Caption = 'Prod./Assembly Time'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Bevel10: TBevel
        Left = 18
        Top = 182
        Width = 195
        Height = 2
      end
      object Label857: Label8
        Left = 12
        Top = 56
        Width = 97
        Height = 14
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Re-order Lead Time'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label858: Label8
        Left = 165
        Top = 56
        Width = 27
        Height = 14
        Caption = ' days'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label859: Label8
        Left = 112
        Top = 12
        Width = 27
        Height = 14
        Caption = ' days'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label860: Label8
        Left = 167
        Top = 12
        Width = 19
        Height = 14
        Caption = ' hrs'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label861: Label8
        Left = 212
        Top = 12
        Width = 22
        Height = 14
        Caption = 'mins'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label862: Label8
        Left = 223
        Top = 56
        Width = 111
        Height = 14
        Alignment = taRightJustify
        Caption = 'Min. economic build qty'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object SRPWF: TCurrencyEdit
        Left = 111
        Top = 191
        Width = 102
        Height = 22
        HelpContext = 1270
        TabStop = False
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
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
        BlankOnZero = False
        DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
        ShowCurrency = False
        TextId = 0
        Value = 1E-10
      end
      object SRIWF: TCurrencyEdit
        Left = 111
        Top = 152
        Width = 102
        Height = 22
        HelpContext = 1270
        TabStop = False
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
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
        BlankOnZero = False
        DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
        ShowCurrency = False
        TextId = 0
        Value = 1E-10
      end
      object SRAWF: TCurrencyEdit
        Left = 111
        Top = 126
        Width = 102
        Height = 22
        HelpContext = 1270
        TabStop = False
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          '0.00 ')
        ParentFont = False
        ReadOnly = True
        TabOrder = 12
        WantReturns = False
        WordWrap = False
        AutoSize = False
        BlankOnZero = False
        DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
        ShowCurrency = False
        TextId = 0
        Value = 1E-10
      end
      object SRGIF: Text8Pt
        Tag = 1
        Left = 111
        Top = 77
        Width = 102
        Height = 22
        HelpContext = 1222
        AutoSize = False
        Color = clGreen
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ReadOnly = True
        ShowHint = True
        TabOrder = 13
        OnExit = SRGSFExit
        TextId = 0
        ViaSBtn = False
      end
      object FGLIF: Text8Pt
        Left = 217
        Top = 77
        Width = 196
        Height = 22
        HelpContext = 1222
        TabStop = False
        AutoSize = False
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
        TabOrder = 14
        TextId = 0
        ViaSBtn = False
      end
      object SRROLTF: TCurrencyEdit
        Tag = 1
        Left = 111
        Top = 52
        Width = 38
        Height = 22
        HelpContext = 1268
        Color = clGreen
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          '0')
        MaxLength = 3
        ParentFont = False
        ReadOnly = True
        TabOrder = 7
        WantReturns = False
        WordWrap = False
        AutoSize = False
        BlankOnZero = False
        DisplayFormat = '###,###,##0 ;###,###,##0-'
        DecPlaces = 0
        ShowCurrency = False
        TextId = 0
        Value = 1E-10
      end
      object SRASSDF: TCurrencyEdit
        Tag = 1
        Left = 111
        Top = 26
        Width = 38
        Height = 22
        HelpContext = 1265
        Color = clGreen
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          '0')
        MaxLength = 3
        ParentFont = False
        ReadOnly = True
        TabOrder = 0
        WantReturns = False
        WordWrap = False
        AutoSize = False
        BlankOnZero = False
        DisplayFormat = '###,###,##0 ;###,###,##0-'
        DecPlaces = 0
        ShowCurrency = False
        TextId = 0
        Value = 1
      end
      object DefUdF: TSBSUpDown
        Tag = 1
        Left = 149
        Top = 26
        Width = 15
        Height = 22
        HelpContext = 541
        Associate = SRASSDF
        ArrowKeys = False
        Enabled = False
        Min = 0
        Max = 999
        Position = 0
        TabOrder = 1
        Thousands = False
        Wrap = True
        OnMouseUp = DefUdFMouseUp
      end
      object SRASSHF: TCurrencyEdit
        Tag = 1
        Left = 166
        Top = 26
        Width = 28
        Height = 22
        HelpContext = 1265
        Color = clGreen
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          '0')
        MaxLength = 2
        ParentFont = False
        ReadOnly = True
        TabOrder = 2
        WantReturns = False
        WordWrap = False
        AutoSize = False
        BlankOnZero = False
        DisplayFormat = '###,###,##0 ;###,###,##0-'
        DecPlaces = 0
        ShowCurrency = False
        TextId = 0
        Value = 1
      end
      object SBSUpDown1: TSBSUpDown
        Tag = 1
        Left = 194
        Top = 26
        Width = 15
        Height = 22
        HelpContext = 541
        Associate = SRASSHF
        ArrowKeys = False
        Enabled = False
        Min = 0
        Max = 23
        Position = 0
        TabOrder = 3
        Thousands = False
        Wrap = True
        OnMouseUp = DefUdFMouseUp
      end
      object SRASSMF: TCurrencyEdit
        Tag = 1
        Left = 211
        Top = 26
        Width = 28
        Height = 22
        HelpContext = 1265
        Color = clGreen
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          '0')
        MaxLength = 2
        ParentFont = False
        ReadOnly = True
        TabOrder = 4
        WantReturns = False
        WordWrap = False
        AutoSize = False
        BlankOnZero = False
        DisplayFormat = '###,###,##0 ;###,###,##0-'
        DecPlaces = 0
        ShowCurrency = False
        TextId = 0
        Value = 1
      end
      object SBSUpDown2: TSBSUpDown
        Tag = 1
        Left = 239
        Top = 26
        Width = 15
        Height = 22
        HelpContext = 541
        Associate = SRASSMF
        ArrowKeys = False
        Enabled = False
        Min = 0
        Max = 59
        Position = 0
        TabOrder = 5
        Thousands = False
        Wrap = True
        OnMouseUp = DefUdFMouseUp
      end
      object SBSUpDown3: TSBSUpDown
        Tag = 1
        Left = 149
        Top = 52
        Width = 15
        Height = 22
        HelpContext = 541
        Associate = SRROLTF
        ArrowKeys = False
        Enabled = False
        Min = 0
        Max = 999
        Position = 0
        TabOrder = 8
        Thousands = False
        Wrap = True
        OnMouseUp = DefUdFMouseUp
      end
      object CBCalcProdT: TBorCheck
        Tag = 1
        Left = 264
        Top = 27
        Width = 146
        Height = 20
        HelpContext = 1266
        Caption = 'Auto Calculate Prod. Time'
        Color = clBtnFace
        Enabled = False
        ParentColor = False
        TabOrder = 6
        TextId = 0
      end
      object SRMEBQF: TCurrencyEdit
        Tag = 1
        Left = 337
        Top = 52
        Width = 75
        Height = 22
        HelpContext = 1269
        Color = clGreen
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          '0.0000 ')
        ParentFont = False
        ReadOnly = True
        TabOrder = 9
        WantReturns = False
        WordWrap = False
        AutoSize = False
        BlankOnZero = False
        DisplayFormat = '###,###,##0.0000 ;###,###,##0.0000-'
        DecPlaces = 4
        ShowCurrency = False
        TextId = 0
        Value = 1E-10
      end
    end
    object RetPage: TTabSheet
      Caption = 'Returns'
      ImageIndex = 11
      object SBSBackGroup12: TSBSBackGroup
        Left = 2
        Top = 4
        Width = 426
        Height = 128
        Caption = 'Warranty && G/L'
        TextId = 0
      end
      object SBSBackGroup13: TSBSBackGroup
        Left = 2
        Top = 186
        Width = 219
        Height = 74
        TextId = 0
      end
      object Label820: Label8
        Left = 8
        Top = 232
        Width = 99
        Height = 14
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Purchase Returned'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label821: Label8
        Left = 6
        Top = 205
        Width = 102
        Height = 14
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Sales Returned '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label822: Label8
        Left = 25
        Top = 81
        Width = 82
        Height = 14
        Alignment = taRightJustify
        Caption = 'Sales Return G/L'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label823: Label8
        Left = 7
        Top = 30
        Width = 102
        Height = 14
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Sales Warranty  '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label824: Label8
        Left = 7
        Top = 54
        Width = 102
        Height = 14
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Manufact. Warranty  '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object SBSBackGroup14: TSBSBackGroup
        Left = 2
        Top = 135
        Width = 427
        Height = 48
        Caption = 'Restock'
        TextId = 0
      end
      object Label825: Label8
        Left = 28
        Top = 151
        Width = 77
        Height = 14
        Caption = 'Restock Charge'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label864: Label8
        Left = 6
        Top = 107
        Width = 101
        Height = 14
        Alignment = taRightJustify
        Caption = 'Purchase Return G/L'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object SRRPRF: TCurrencyEdit
        Left = 111
        Top = 227
        Width = 102
        Height = 22
        HelpContext = 1270
        TabStop = False
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          '0.00 ')
        ParentFont = False
        ReadOnly = True
        TabOrder = 12
        WantReturns = False
        WordWrap = False
        AutoSize = False
        BlankOnZero = False
        DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
        ShowCurrency = False
        TextId = 0
        Value = 1E-10
      end
      object SRRSRF: TCurrencyEdit
        Left = 111
        Top = 201
        Width = 102
        Height = 22
        HelpContext = 1270
        TabStop = False
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
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
        BlankOnZero = False
        DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
        ShowCurrency = False
        TextId = 0
        Value = 1E-10
      end
      object SRRGLF: Text8Pt
        Tag = 1
        Left = 111
        Top = 77
        Width = 102
        Height = 22
        HelpContext = 1222
        AutoSize = False
        Color = clGreen
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ReadOnly = True
        ShowHint = True
        TabOrder = 6
        OnExit = SRGSFExit
        TextId = 0
        ViaSBtn = False
      end
      object SRRGLDF: Text8Pt
        Left = 218
        Top = 77
        Width = 196
        Height = 22
        HelpContext = 1222
        TabStop = False
        AutoSize = False
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
        TabOrder = 7
        TextId = 0
        ViaSBtn = False
      end
      object SRRSWDF: TCurrencyEdit
        Tag = 1
        Left = 111
        Top = 26
        Width = 38
        Height = 22
        HelpContext = 1265
        Color = clGreen
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          '0')
        MaxLength = 2
        ParentFont = False
        ReadOnly = True
        TabOrder = 0
        WantReturns = False
        WordWrap = False
        AutoSize = False
        BlankOnZero = False
        DisplayFormat = '###,###,##0 ;###,###,##0-'
        DecPlaces = 0
        ShowCurrency = False
        TextId = 0
        Value = 1
      end
      object SBSUpDown4: TSBSUpDown
        Tag = 1
        Left = 149
        Top = 26
        Width = 15
        Height = 22
        HelpContext = 541
        Associate = SRRSWDF
        ArrowKeys = False
        Enabled = False
        Min = 0
        Max = 255
        Position = 0
        TabOrder = 1
        Thousands = False
        Wrap = True
        OnMouseUp = DefUdFMouseUp
      end
      object SRRMWDF: TCurrencyEdit
        Tag = 1
        Left = 111
        Top = 52
        Width = 38
        Height = 22
        HelpContext = 1265
        Color = clGreen
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          '0')
        MaxLength = 2
        ParentFont = False
        ReadOnly = True
        TabOrder = 3
        WantReturns = False
        WordWrap = False
        AutoSize = False
        BlankOnZero = False
        DisplayFormat = '###,###,##0 ;###,###,##0-'
        DecPlaces = 0
        ShowCurrency = False
        TextId = 0
        Value = 1
      end
      object SBSUpDown5: TSBSUpDown
        Tag = 1
        Left = 149
        Top = 52
        Width = 15
        Height = 22
        HelpContext = 541
        Associate = SRRMWDF
        ArrowKeys = False
        Enabled = False
        Min = 0
        Max = 255
        Position = 0
        TabOrder = 4
        Thousands = False
        Wrap = True
        OnMouseUp = DefUdFMouseUp
      end
      object SRRSWMF: TSBSComboBox
        Tag = 1
        Left = 168
        Top = 26
        Width = 68
        Height = 22
        HelpContext = 276
        Color = clGreen
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 14
        ItemIndex = 0
        MaxLength = 40
        ParentFont = False
        TabOrder = 2
        Text = 'Days'
        Items.Strings = (
          'Days'
          'Weeks'
          'Months'
          'Years')
        MaxListWidth = 75
        ReadOnly = True
        Validate = True
      end
      object SRRSMMF: TSBSComboBox
        Tag = 1
        Left = 168
        Top = 52
        Width = 68
        Height = 22
        HelpContext = 276
        Color = clGreen
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 14
        ItemIndex = 0
        MaxLength = 40
        ParentFont = False
        TabOrder = 5
        Text = 'Days'
        Items.Strings = (
          'Days'
          'Weeks'
          'Months'
          'Years')
        MaxListWidth = 75
        ReadOnly = True
        Validate = True
      end
      object SRRRCF: TCurrencyEdit
        Tag = 1
        Left = 111
        Top = 148
        Width = 102
        Height = 22
        HelpContext = 207
        Color = clGreen
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          '0.67%-')
        ParentFont = False
        ReadOnly = True
        TabOrder = 10
        WantReturns = False
        WordWrap = False
        AutoSize = False
        BlankOnZero = False
        DisplayFormat = '###,###,##0.00% ;###,###,##0.00%-'
        ShowCurrency = False
        TextId = 0
        Value = -0.666666
      end
      object SRRPGLF: Text8Pt
        Tag = 1
        Left = 111
        Top = 103
        Width = 102
        Height = 22
        HelpContext = 1222
        AutoSize = False
        Color = clGreen
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ReadOnly = True
        ShowHint = True
        TabOrder = 8
        OnExit = SRGSFExit
        TextId = 0
        ViaSBtn = False
      end
      object SRRGLPDF: Text8Pt
        Left = 218
        Top = 103
        Width = 196
        Height = 22
        HelpContext = 1222
        TabStop = False
        AutoSize = False
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
        TabOrder = 9
        TextId = 0
        ViaSBtn = False
      end
    end
    object Notes: TTabSheet
      HelpContext = 438
      Caption = 'Notes'
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
          Caption = 'TNHedPanel'
          TabOrder = 0
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          object NDateLab: TSBSPanel
            Left = 2
            Top = 2
            Width = 65
            Height = 16
            BevelOuter = bvNone
            Caption = 'Date'
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
          end
          object NDescLab: TSBSPanel
            Left = 67
            Top = 2
            Width = 266
            Height = 16
            BevelOuter = bvNone
            Caption = 'Notes'
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
          end
          object NUserLab: TSBSPanel
            Left = 337
            Top = 2
            Width = 66
            Height = 16
            BevelOuter = bvNone
            Caption = 'User'
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
          end
        end
        object NDatePanel: TSBSPanel
          Left = 2
          Top = 26
          Width = 65
          Height = 243
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clOlive
          TabOrder = 1
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
        end
        object NDescPanel: TSBSPanel
          Left = 70
          Top = 26
          Width = 265
          Height = 243
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clOlive
          TabOrder = 2
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
        end
        object NUserPanel: TSBSPanel
          Left = 338
          Top = 26
          Width = 70
          Height = 243
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clOlive
          TabOrder = 3
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
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
    object QtyBreaks: TTabSheet
      Caption = 'Qty Breaks'
      object QBSBox: TScrollBox
        Left = 3
        Top = 3
        Width = 414
        Height = 291
        VertScrollBar.Visible = False
        TabOrder = 0
        object QBHedPanel: TSBSPanel
          Left = 2
          Top = 3
          Width = 583
          Height = 18
          BevelInner = bvLowered
          BevelOuter = bvNone
          TabOrder = 0
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          object QBFLab: TSBSPanel
            Left = 2
            Top = 1
            Width = 53
            Height = 16
            BevelOuter = bvNone
            Caption = 'From'
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 0
            OnMouseDown = SNoLabMouseDown
            OnMouseMove = SNoLabMouseMove
            OnMouseUp = SNoPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
          end
          object QBYLab: TSBSPanel
            Left = 115
            Top = 1
            Width = 34
            Height = 16
            BevelOuter = bvNone
            Caption = 'Type'
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 1
            OnMouseDown = SNoLabMouseDown
            OnMouseMove = SNoLabMouseMove
            OnMouseUp = SNoPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
          end
          object QBULab: TSBSPanel
            Left = 149
            Top = 1
            Width = 65
            Height = 16
            BevelOuter = bvNone
            Caption = 'U/Price'
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 2
            OnMouseDown = SNoLabMouseDown
            OnMouseMove = SNoLabMouseMove
            OnMouseUp = SNoPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
          end
          object QBBLab: TSBSPanel
            Left = 214
            Top = 1
            Width = 42
            Height = 16
            BevelOuter = bvNone
            Caption = 'Band'
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 3
            OnMouseDown = SNoLabMouseDown
            OnMouseMove = SNoLabMouseMove
            OnMouseUp = SNoPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
          end
          object QBDLab: TSBSPanel
            Left = 259
            Top = 1
            Width = 61
            Height = 16
            BevelOuter = bvNone
            Caption = 'Disc%'
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 4
            OnMouseDown = SNoLabMouseDown
            OnMouseMove = SNoLabMouseMove
            OnMouseUp = SNoPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
          end
          object QBVLab: TSBSPanel
            Left = 321
            Top = 1
            Width = 61
            Height = 16
            BevelOuter = bvNone
            Caption = 'Disc (val)'
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 5
            OnMouseDown = SNoLabMouseDown
            OnMouseMove = SNoLabMouseMove
            OnMouseUp = SNoPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
          end
          object QBMLab: TSBSPanel
            Left = 386
            Top = 1
            Width = 61
            Height = 16
            BevelOuter = bvNone
            Caption = 'MU/Mg%'
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 6
            OnMouseDown = SNoLabMouseDown
            OnMouseMove = SNoLabMouseMove
            OnMouseUp = SNoPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
          end
          object QBTLab: TSBSPanel
            Left = 60
            Top = 2
            Width = 53
            Height = 15
            BevelOuter = bvNone
            Caption = 'To'
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 7
            OnMouseDown = SNoLabMouseDown
            OnMouseMove = SNoLabMouseMove
            OnMouseUp = SNoPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
          end
          object QBEffLab: TSBSPanel
            Left = 447
            Top = 1
            Width = 131
            Height = 16
            BevelOuter = bvNone
            Caption = 'Effective'
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 8
            OnMouseDown = SNoLabMouseDown
            OnMouseMove = SNoLabMouseMove
            OnMouseUp = SNoPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
          end
        end
        object QBFPanel: TSBSPanel
          Left = 2
          Top = 24
          Width = 55
          Height = 245
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clAqua
          TabOrder = 1
          OnMouseUp = SNoPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
        end
        object QBYPanel: TSBSPanel
          Left = 118
          Top = 24
          Width = 31
          Height = 245
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clAqua
          TabOrder = 2
          OnMouseUp = SNoPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
        end
        object QBDPanel: TSBSPanel
          Left = 260
          Top = 24
          Width = 61
          Height = 245
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clAqua
          TabOrder = 3
          OnMouseUp = SNoPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
        end
        object QBVPanel: TSBSPanel
          Left = 324
          Top = 24
          Width = 61
          Height = 245
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clAqua
          TabOrder = 4
          OnMouseUp = SNoPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
        end
        object QBMPanel: TSBSPanel
          Left = 388
          Top = 24
          Width = 61
          Height = 245
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clAqua
          TabOrder = 5
          OnMouseUp = SNoPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
        end
        object QBUPanel: TSBSPanel
          Left = 152
          Top = 24
          Width = 61
          Height = 245
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clAqua
          TabOrder = 6
          OnMouseUp = SNoPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
        end
        object QBBPAnel: TSBSPanel
          Left = 216
          Top = 24
          Width = 41
          Height = 245
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clAqua
          TabOrder = 7
          OnMouseUp = SNoPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
        end
        object QBTPanel: TSBSPanel
          Left = 60
          Top = 24
          Width = 55
          Height = 245
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clAqua
          TabOrder = 8
          OnMouseUp = SNoPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
        end
        object QBEffPanel: TSBSPanel
          Left = 451
          Top = 24
          Width = 131
          Height = 245
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clAqua
          TabOrder = 9
          OnMouseUp = SNoPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
        end
      end
    end
    object Ledger: TTabSheet
      HelpContext = 219
      Caption = 'Ledger'
      object CLSBox: TScrollBox
        Left = 3
        Top = 3
        Width = 414
        Height = 291
        HorzScrollBar.Position = 361
        VertScrollBar.Tracking = True
        VertScrollBar.Visible = False
        TabOrder = 0
        object CLHedPanel: TSBSPanel
          Left = -359
          Top = 3
          Width = 769
          Height = 19
          BevelInner = bvLowered
          BevelOuter = bvNone
          TabOrder = 0
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          object CLORefLab: TSBSPanel
            Left = 2
            Top = 2
            Width = 31
            Height = 14
            BevelOuter = bvNone
            Caption = 'Ref'
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
          end
          object CLDateLab: TSBSPanel
            Left = 36
            Top = 2
            Width = 67
            Height = 14
            BevelOuter = bvNone
            Caption = 'Date'
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
          end
          object CLUPLab: TSBSPanel
            Left = 657
            Top = 2
            Width = 80
            Height = 14
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = 'Unit Price  '
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
          end
          object CLOOLab: TSBSPanel
            Left = 347
            Top = 2
            Width = 59
            Height = 14
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = 'On Order '
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
          end
          object CLQOLab: TSBSPanel
            Left = 224
            Top = 2
            Width = 59
            Height = 14
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = 'Qty Out  '
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
          end
          object CLALLab: TSBSPanel
            Left = 285
            Top = 2
            Width = 60
            Height = 14
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = 'Allocated '
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
          end
          object CLQILab: TSBSPanel
            Left = 162
            Top = 2
            Width = 59
            Height = 14
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = 'Qty In  '
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
          end
          object CLACLab: TSBSPanel
            Left = 107
            Top = 2
            Width = 52
            Height = 14
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = 'A/C Code '
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
          end
          object CLAWLab: TSBSPanel
            Left = 411
            Top = 2
            Width = 60
            Height = 14
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = ' Alloc WOR '
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
          end
          object CLIWLab: TSBSPanel
            Left = 473
            Top = 2
            Width = 59
            Height = 14
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = 'Issud WOR'
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
          end
          object CLSRLab: TSBSPanel
            Left = 534
            Top = 2
            Width = 60
            Height = 14
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = 'Sales Ret. '
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
          end
          object CLPRLab: TSBSPanel
            Left = 596
            Top = 2
            Width = 59
            Height = 14
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = 'Purch Ret. '
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 11
            OnMouseDown = CLORefLabMouseDown
            OnMouseMove = CLORefLabMouseMove
            OnMouseUp = CLORefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
          end
        end
        object CLORefPanel: TSBSPanel
          Left = -359
          Top = 25
          Width = 33
          Height = 245
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clTeal
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clYellow
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          OnMouseUp = CLORefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
        end
        object CLDatePanel: TSBSPanel
          Left = -324
          Top = 25
          Width = 69
          Height = 245
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clTeal
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clYellow
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          OnMouseUp = CLORefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
        end
        object CLUPPanel: TSBSPanel
          Left = 299
          Top = 25
          Width = 83
          Height = 245
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clTeal
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clYellow
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          OnMouseUp = CLORefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
        end
        object CLOOPanel: TSBSPanel
          Left = -11
          Top = 25
          Width = 60
          Height = 245
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clTeal
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clYellow
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
          OnMouseUp = CLORefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
        end
        object CLQOPanel: TSBSPanel
          Left = -135
          Top = 25
          Width = 60
          Height = 245
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clTeal
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clYellow
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 5
          OnMouseUp = CLORefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
        end
        object CLALPanel: TSBSPanel
          Left = -73
          Top = 25
          Width = 60
          Height = 245
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clTeal
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clYellow
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 6
          OnMouseUp = CLORefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
        end
        object CLQIPanel: TSBSPanel
          Left = -197
          Top = 25
          Width = 60
          Height = 245
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clTeal
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clYellow
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 7
          OnMouseUp = CLORefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
        end
        object CLAcPanel: TSBSPanel
          Left = -253
          Top = 25
          Width = 54
          Height = 245
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clTeal
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clYellow
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 8
          OnMouseUp = CLORefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
        end
        object CLAWPanel: TSBSPanel
          Left = 51
          Top = 25
          Width = 60
          Height = 245
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clTeal
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clYellow
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 9
          OnMouseUp = CLORefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
        end
        object CLIWPanel: TSBSPanel
          Left = 113
          Top = 25
          Width = 60
          Height = 245
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clTeal
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clYellow
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 10
          OnMouseUp = CLORefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
        end
        object CLSRPanel: TSBSPanel
          Left = 175
          Top = 25
          Width = 60
          Height = 245
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clTeal
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clYellow
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 11
          OnMouseUp = CLORefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
        end
        object CLPRPanel: TSBSPanel
          Left = 237
          Top = 25
          Width = 60
          Height = 245
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clTeal
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clYellow
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 12
          OnMouseUp = CLORefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
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
    object ValPage: TTabSheet
      HelpContext = 218
      Caption = 'Value'
      object VSBox: TScrollBox
        Left = 3
        Top = 3
        Width = 414
        Height = 291
        VertScrollBar.Tracking = True
        VertScrollBar.Visible = False
        TabOrder = 0
        object ValHedPanel: TSBSPanel
          Left = 2
          Top = 3
          Width = 463
          Height = 19
          BevelInner = bvLowered
          BevelOuter = bvNone
          TabOrder = 0
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          object VOLab: TSBSPanel
            Left = 2
            Top = 2
            Width = 31
            Height = 14
            BevelOuter = bvNone
            Caption = 'Ref'
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 0
            OnMouseDown = SNoLabMouseDown
            OnMouseMove = SNoLabMouseMove
            OnMouseUp = SNoPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
          end
          object VDLab: TSBSPanel
            Left = 72
            Top = 2
            Width = 67
            Height = 14
            BevelOuter = bvNone
            Caption = 'Date'
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 1
            OnMouseDown = SNoLabMouseDown
            OnMouseMove = SNoLabMouseMove
            OnMouseUp = SNoPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
          end
          object VILab: TSBSPanel
            Left = 260
            Top = 2
            Width = 59
            Height = 14
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = 'In Stk  '
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 2
            OnMouseDown = SNoLabMouseDown
            OnMouseMove = SNoLabMouseMove
            OnMouseUp = SNoPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
          end
          object VULab: TSBSPanel
            Left = 321
            Top = 2
            Width = 82
            Height = 14
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = 'Unit Cost '
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 3
            OnMouseDown = SNoLabMouseDown
            OnMouseMove = SNoLabMouseMove
            OnMouseUp = SNoPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
          end
          object VQLab: TSBSPanel
            Left = 198
            Top = 2
            Width = 59
            Height = 14
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = 'Qty '
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 4
            OnMouseDown = SNoLabMouseDown
            OnMouseMove = SNoLabMouseMove
            OnMouseUp = SNoPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
          end
          object VALab: TSBSPanel
            Left = 143
            Top = 2
            Width = 52
            Height = 14
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = 'A/C Code '
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 5
            OnMouseDown = SNoLabMouseDown
            OnMouseMove = SNoLabMouseMove
            OnMouseUp = SNoPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
          end
          object VLocLab: TSBSPanel
            Left = 408
            Top = 2
            Width = 49
            Height = 14
            BevelOuter = bvNone
            Caption = 'Location'
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 6
            OnMouseDown = SNoLabMouseDown
            OnMouseMove = SNoLabMouseMove
            OnMouseUp = SNoPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
          end
        end
        object VOPanel: TSBSPanel
          Left = 2
          Top = 25
          Width = 71
          Height = 245
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clTeal
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clYellow
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          OnMouseUp = SNoPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
        end
        object VDPanel: TSBSPanel
          Left = 75
          Top = 25
          Width = 69
          Height = 245
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clTeal
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clYellow
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          OnMouseUp = SNoPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
        end
        object VUPAnel: TSBSPanel
          Left = 326
          Top = 25
          Width = 83
          Height = 245
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clTeal
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clYellow
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          OnMouseUp = SNoPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
        end
        object VIPanel: TSBSPanel
          Left = 264
          Top = 25
          Width = 60
          Height = 245
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clTeal
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clYellow
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
          OnMouseUp = SNoPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
        end
        object VQPanel: TSBSPanel
          Left = 202
          Top = 25
          Width = 60
          Height = 245
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clTeal
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clYellow
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 5
          OnMouseUp = SNoPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
        end
        object VAPanel: TSBSPanel
          Left = 146
          Top = 25
          Width = 54
          Height = 245
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clTeal
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clYellow
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 6
          OnMouseUp = SNoPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
        end
        object VLocPanel: TSBSPanel
          Left = 411
          Top = 25
          Width = 50
          Height = 245
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clTeal
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clYellow
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 7
          OnMouseUp = SNoPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
        end
      end
    end
    object BOMPage: TTabSheet
      HelpContext = 217
      Caption = 'Build'
      PopupMenu = PopupMenu3
      object Bevel3: TBevel
        Left = 2
        Top = 38
        Width = 423
        Height = 2
      end
      object Bevel4: TBevel
        Left = 2
        Top = 4
        Width = 423
        Height = 2
      end
      object Bevel5: TBevel
        Left = 67
        Top = 6
        Width = 2
        Height = 32
      end
      object Bevel6: TBevel
        Left = 423
        Top = 5
        Width = 2
        Height = 34
      end
      object Bevel8: TBevel
        Left = 2
        Top = 6
        Width = 2
        Height = 32
      end
      object Label86: Label8
        Left = 162
        Top = 16
        Width = 41
        Height = 14
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'GP% : '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label87: Label8
        Left = 269
        Top = 16
        Width = 22
        Height = 14
        Caption = 'Cost'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object FullExBtn: TSpeedButton
        Left = 7
        Top = 8
        Width = 28
        Height = 28
        Hint = 'Expand All|Opens all folders in the stock tree'
        Flat = True
        Glyph.Data = {
          7E010000424D7E01000000000000760000002800000016000000160000000100
          0400000000000801000000000000000000001000000010000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00111111111111
          0111111111001111111111111011111111001111111100000001FFFF11001111
          111101111011F00F11001111111101110111FFFF11001111111101111111F00F
          11001111111101110111FFFF1100111111110111101111111100111111110000
          0001FFFF11001111111101111011F00F11001111111101110111FFFF11001111
          111101111111F00F11001000000000000111FFFF110010033333333330111111
          110010B03333333333011111110010FB0333333333301111110010BFB0000000
          00001111110010FBFBFBFBFBF0111111110010BFBFBFBFBFB0111111110010FB
          FB00000000111111110011000011111111111111110011111111111111111111
          1100}
        ParentShowHint = False
        ShowHint = True
        OnClick = FullExBtnClick
      end
      object FullColBtn: TSpeedButton
        Left = 36
        Top = 8
        Width = 28
        Height = 28
        Hint = 
          'Collapse All|Closes all folders in the Stock Tree to the top-lev' +
          'el'
        Flat = True
        Glyph.Data = {
          7E010000424D7E01000000000000760000002800000016000000160000000100
          0400000000000801000000000000000000001000000010000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00111111111111
          1111111111001111111111111111111111001111110000000111FFFF11001111
          110111111111F00F11001111110111111111FFFF11001111110111111111F00F
          11001111010101110111FFFF1100111110001110111111111100111111011100
          0001FFFF11001111111111101111F00F11001111111111110111FFFF11001111
          111111111111F00F11001000000000000111FFFF110010FBFBFBFBFBF0111111
          110010BFBFBFBFBFB0111111110010FBFBFBFBFBF0111111110010BFBFBFBFBF
          B0111111110010FBFBFBFBFBF0111111110010BFBFBFBFBFB0111111110010FB
          FB00000000111111110011000011111111111111110011111111111111111111
          1100}
        ParentShowHint = False
        ShowHint = True
        OnClick = FullExBtnClick
      end
      object NLDPanel: TPanel
        Left = 3
        Top = 48
        Width = 308
        Height = 19
        Alignment = taLeftJustify
        BevelOuter = bvLowered
        Caption = 'Contains'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        object Image5: TImage
          Left = 176
          Top = 2
          Width = 15
          Height = 15
          AutoSize = True
          Picture.Data = {
            07544269746D6170EE000000424DEE0000000000000076000000280000000F00
            00000F0000000100040000000000780000000000000000000000100000000000
            000000000000000080000080000000808000800000008000800080800000C0C0
            C000808080000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
            FF00DDDDDDDDDDDDDDD0DDDDDDDDDDDDDDD0DD00000000000DD0DD0FFFFFFFFF
            0DD0DD0FFF0FFFFF0DD0DD0FF000FFFF0DD0DD0F00000FFF0DD0DD0F00F000FF
            0DD0DD0F0FFF000F0DD0DD0FFFFFF00F0DD0DD0FFFFFFF0F0DD0DD0FFFFFFFFF
            0DD0DD00000000000DD0DDDDDDDDDDDDDDD0DDDDDDDDDDDDDDD0}
          Transparent = True
        end
        object Label863: Label8
          Left = 196
          Top = 2
          Width = 111
          Height = 14
          Caption = 'Shows Free Issue item'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
      end
      object NLCrPanel: TPanel
        Left = 314
        Top = 48
        Width = 72
        Height = 19
        Alignment = taRightJustify
        BevelOuter = bvLowered
        Caption = 'Qty'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
      end
      object NLDrPanel: TPanel
        Left = 389
        Top = 48
        Width = 109
        Height = 19
        Alignment = taRightJustify
        BevelOuter = bvLowered
        Caption = 'Cost'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
      end
      object ClsI1Btn: TButton
        Left = 436
        Top = 13
        Width = 80
        Height = 21
        Cancel = True
        Caption = '&Close'
        ModalResult = 2
        TabOrder = 4
        OnClick = ClsCP1BtnClick
      end
      object NLOLine: TSBSOutlineB
        Left = 3
        Top = 70
        Width = 522
        Height = 194
        OnExpand = NLOLineExpand
        Options = [ooDrawTreeRoot]
        ItemHeight = 16
        ItemSpace = 6
        BarColor = clHighlight
        BarTextColor = clHighlightText
        HLBarColor = clBlack
        HLBarTextColor = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clYellow
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Color = clGreen
        TabOrder = 6
        ItemSeparator = '\'
        PicturePlus.Data = {
          EE000000424DEE0000000000000076000000280000000F0000000F0000000100
          0400000000007800000000000000000000001000000000000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00DDDDDDDDDDDD
          DDD0DDDDDDDDDDDDDDD0DD00000000000DD0DD0FFFFFFFFF0DD0DD0FFF0FFFFF
          0DD0DD0FF000FFFF0DD0DD0F00000FFF0DD0DD0F00F000FF0DD0DD0F0FFF000F
          0DD0DD0FFFFFF00F0DD0DD0FFFFFFF0F0DD0DD0FFFFFFFFF0DD0DD0000000000
          0DD0DDDDDDDDDDDDDDD0DDDDDDDDDDDDDDD0}
        PictureMinus.Data = {
          EE000000424DEE0000000000000076000000280000000F0000000F0000000100
          0400000000007800000000000000000000001000000000000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00DDDDDDDDDDDD
          DDD0DDDDDDDDDDDDDDD0DD00000000000DD0DD0FFFFFFFFF0DD0DD0FFFFFFFFF
          0DD0DD0FFFFFFFFF0DD0DD0FFFFFFFFF0DD0DD0FFFFFFFFF0DD0DD0FFFFFFFFF
          0DD0DD0FFFFFFFFF0DD0DD0FFFFFFFFF0DD0DD0FFFFFFFFF0DD0DD0000000000
          0DD0DDDDDDDDDDDDDDD0DDDDDDDDDDDDDDD0}
        PictureOpen.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          0400000000008000000000000000000000001000000010000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00DDDDDDDDDDDD
          DDDDDDDDDDDDDDDDDDDDDDD0000000000000DD33333333333300DD3F7B7B7777
          8300D3FBF7F7B7778030D3FFBFBF7B7730303FFBFB7BF7B808803FBFBFBF7B78
          08803333333333338F80D3FBFBFBFBFBFB80D3FFBFBFBFFFFF80D3FBFBFBF333
          333DDD3FFFFF3DDDDDDDDDD33333DDDDDDDDDDDDDDDDDDDDDDDD}
        PictureClosed.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          0400000000008000000000000000000000001000000010000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00DDDDDDDDDDDD
          DDDDDDDDDDDDDDDDDDDDDD00000000000000D388888888888880D3F7B7B7B7B7
          7780D3FFBF7B7B7B7780D3FBFBFBB7B7B780D3FFBFBF7B7B7B80D3FBFBFBFBB7
          B780D3FFBFBFBF7B7B80D3FBFBFBFBFBB780D3FFFFFFFFFFFB80D38888888333
          333DDD3FBFBB30DDDDDDDDD333330DDDDDDDDDDDDDDDDDDDDDDD}
        PictureLeaf.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          0400000000008000000000000000000000001000000010000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00222222222222
          2222222222222222222222222222222222222222220222222222222200B00222
          22222220B3B3B022222222203BBB30022222220BBB0BBB00222222203BBB3030
          22222220B3B3B0802222222200B0030822222222200808022222222222200022
          2222222222222222222222222222222222222222222222222222}
        PictureLeaf2.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          0400000000008000000000000000000000001000000010000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00222222222222
          2222878787878787878777777777777777778788888888888888778FFFFFFFFF
          FFFF878F0F0F008F800F778F0F0F0F0F0FFF878F000F000F0FFF778F0F0F0F0F
          0FFF878F808F008F800F778FFFFFFFFFFFFF8777777777777777777777777777
          7777878787878787878722222222222222222222222222222222}
        ParentFont = False
        PopupMenu = PopupMenu3
        ScrollBars = ssVertical
        ShowValCol = 2
        OnNeedValue = NLOLineNeedValue
        OnUpdateNode = NLOLineUpdateNode
        TreeColor = clWhite
        Data = {3F00}
      end
      object SBSPanel5: TSBSPanel
        Left = 0
        Top = 272
        Width = 550
        Height = 34
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 8
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        object Bevel7: TBevel
          Left = 3
          Top = 4
          Width = 522
          Height = 2
        end
        object BOMTimeLab: Label8
          Left = 322
          Top = 13
          Width = 22
          Height = 14
          Caption = 'Time'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Panel4: TPanel
          Left = 3
          Top = 11
          Width = 67
          Height = 20
          Alignment = taRightJustify
          BevelOuter = bvLowered
          Caption = 'Stock Code: '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
        object Panel5: TPanel
          Left = 72
          Top = 11
          Width = 158
          Height = 20
          Alignment = taLeftJustify
          BevelOuter = bvLowered
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
        end
        object OptBtn: TButton
          Left = 445
          Top = 11
          Width = 80
          Height = 21
          Caption = '&Options'
          TabOrder = 3
          OnClick = OptBtnClick
        end
        object YTDCombo: TSBSComboBox
          Tag = 1
          Left = 238
          Top = 10
          Width = 80
          Height = 22
          HelpContext = 553
          Color = clGreen
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ItemHeight = 14
          ParentFont = False
          TabOrder = 2
          OnChange = YTDChkClick
          Items.Strings = (
            'All kitting options disabled'
            'Sales Transactions explode components (Kit)'
            'Purchase Transactions explode components'
            'Both Sales & Purchase explode components')
          ExtendedList = True
          MaxListWidth = 220
        end
        object BOMTimePanel: TPanel
          Left = 348
          Top = 11
          Width = 90
          Height = 20
          Alignment = taLeftJustify
          BevelOuter = bvLowered
          TabOrder = 4
        end
      end
      object GPLab: TPanel
        Left = 205
        Top = 12
        Width = 54
        Height = 20
        Alignment = taRightJustify
        BevelOuter = bvLowered
        TabOrder = 5
      end
      object CostLab: TPanel
        Left = 296
        Top = 12
        Width = 124
        Height = 20
        Alignment = taRightJustify
        BevelOuter = bvLowered
        TabOrder = 7
      end
      object PriceChk: TBorCheck
        Left = 117
        Top = 13
        Width = 41
        Height = 20
        HelpContext = 557
        Caption = '%Price'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 3
        TabStop = True
        TextId = 0
        OnClick = YTDChkClick
      end
    end
    object SerPage: TTabSheet
      HelpContext = 218
      Caption = 'Serial'
      object SNSBox: TScrollBox
        Left = 3
        Top = 3
        Width = 414
        Height = 291
        VertScrollBar.Tracking = True
        VertScrollBar.Visible = False
        TabOrder = 0
        object SNHedPanel: TSBSPanel
          Left = 2
          Top = 3
          Width = 628
          Height = 19
          BevelInner = bvLowered
          BevelOuter = bvNone
          TabOrder = 0
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          object SNoLab: TSBSPanel
            Left = 2
            Top = 2
            Width = 117
            Height = 14
            BevelOuter = bvNone
            Caption = 'Serial Number'
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 0
            OnMouseDown = SNoLabMouseDown
            OnMouseMove = SNoLabMouseMove
            OnMouseUp = SNoPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
          end
          object OutLab: TSBSPanel
            Left = 278
            Top = 2
            Width = 81
            Height = 14
            BevelOuter = bvNone
            Caption = 'Out Doc.'
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 1
            OnMouseDown = SNoLabMouseDown
            OnMouseMove = SNoLabMouseMove
            OnMouseUp = SNoPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
          end
          object ODLab: TSBSPanel
            Left = 358
            Top = 2
            Width = 69
            Height = 14
            BevelOuter = bvNone
            Caption = 'Out Date'
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 2
            OnMouseDown = SNoLabMouseDown
            OnMouseMove = SNoLabMouseMove
            OnMouseUp = SNoPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
          end
          object InLab: TSBSPanel
            Left = 201
            Top = 2
            Width = 76
            Height = 14
            BevelOuter = bvNone
            Caption = 'In Doc.'
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 3
            OnMouseDown = SNoLabMouseDown
            OnMouseMove = SNoLabMouseMove
            OnMouseUp = SNoPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
          end
          object BNoLab: TSBSPanel
            Left = 119
            Top = 2
            Width = 80
            Height = 14
            BevelOuter = bvNone
            Caption = 'Batch No.'
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 4
            OnMouseDown = SNoLabMouseDown
            OnMouseMove = SNoLabMouseMove
            OnMouseUp = SNoPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
          end
          object InLocLab: TSBSPanel
            Left = 429
            Top = 2
            Width = 51
            Height = 14
            BevelOuter = bvNone
            Caption = 'In Locn'
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 5
            OnMouseDown = SNoLabMouseDown
            OnMouseMove = SNoLabMouseMove
            OnMouseUp = SNoPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
          end
          object OutLocLab: TSBSPanel
            Left = 481
            Top = 2
            Width = 51
            Height = 14
            BevelOuter = bvNone
            Caption = 'Out Locn'
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 6
            OnMouseDown = SNoLabMouseDown
            OnMouseMove = SNoLabMouseMove
            OnMouseUp = SNoPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
          end
          object StkCodeLab: TSBSPanel
            Left = 531
            Top = 2
            Width = 94
            Height = 14
            BevelOuter = bvNone
            Caption = 'Stock Code'
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 7
            OnMouseDown = SNoLabMouseDown
            OnMouseMove = SNoLabMouseMove
            OnMouseUp = SNoPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
          end
        end
        object OutPanel: TSBSPanel
          Left = 282
          Top = 25
          Width = 77
          Height = 245
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clTeal
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clYellow
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          OnMouseUp = SNoPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
        end
        object ODPanel: TSBSPanel
          Left = 361
          Top = 25
          Width = 69
          Height = 245
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clTeal
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clYellow
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          OnMouseUp = SNoPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
        end
        object SNoPanel: TSBSPanel
          Left = 2
          Top = 25
          Width = 119
          Height = 245
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clTeal
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clYellow
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          OnMouseUp = SNoPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
        end
        object BNoPanel: TSBSPanel
          Left = 123
          Top = 25
          Width = 78
          Height = 245
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clTeal
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clYellow
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
          OnMouseUp = SNoPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
        end
        object InPanel: TSBSPanel
          Left = 203
          Top = 25
          Width = 77
          Height = 245
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clTeal
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clYellow
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 5
          OnMouseUp = SNoPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
        end
        object InLocPanel: TSBSPanel
          Left = 432
          Top = 25
          Width = 50
          Height = 245
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clTeal
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clYellow
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 6
          OnMouseUp = SNoPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
        end
        object OutLocPanel: TSBSPanel
          Left = 484
          Top = 25
          Width = 50
          Height = 245
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clTeal
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clYellow
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 7
          OnMouseUp = SNoPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
        end
        object StkCodePanel: TSBSPanel
          Left = 536
          Top = 25
          Width = 94
          Height = 245
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clTeal
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clYellow
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 8
          OnMouseUp = SNoPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
        end
      end
    end
    object BinPage: TTabSheet
      HelpContext = 1458
      Caption = 'Bins'
      ImageIndex = 10
      object MBSBox: TScrollBox
        Left = 3
        Top = 3
        Width = 414
        Height = 291
        VertScrollBar.Tracking = True
        VertScrollBar.Visible = False
        TabOrder = 0
        object MBHedPanel: TSBSPanel
          Left = 2
          Top = 3
          Width = 655
          Height = 19
          BevelInner = bvLowered
          BevelOuter = bvNone
          TabOrder = 0
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          object MBCLab: TSBSPanel
            Left = 2
            Top = 2
            Width = 80
            Height = 14
            BevelOuter = bvNone
            Caption = 'Bin Code'
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 0
            OnMouseDown = SNoLabMouseDown
            OnMouseMove = SNoLabMouseMove
            OnMouseUp = SNoPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
          end
          object MBILab: TSBSPanel
            Left = 255
            Top = 2
            Width = 81
            Height = 14
            BevelOuter = bvNone
            Caption = 'In Doc.'
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 1
            OnMouseDown = SNoLabMouseDown
            OnMouseMove = SNoLabMouseMove
            OnMouseUp = SNoPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
          end
          object MBOLab: TSBSPanel
            Left = 335
            Top = 2
            Width = 77
            Height = 14
            BevelOuter = bvNone
            Caption = 'Out Doc.'
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 2
            OnMouseDown = SNoLabMouseDown
            OnMouseMove = SNoLabMouseMove
            OnMouseUp = SNoPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
          end
          object MBDLab: TSBSPanel
            Left = 186
            Top = 2
            Width = 76
            Height = 14
            BevelOuter = bvNone
            Caption = 'Date'
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 3
            OnMouseDown = SNoLabMouseDown
            OnMouseMove = SNoLabMouseMove
            OnMouseUp = SNoPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
          end
          object MBQLab: TSBSPanel
            Left = 77
            Top = 2
            Width = 107
            Height = 14
            BevelOuter = bvNone
            Caption = 'Qty'
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 4
            OnMouseDown = SNoLabMouseDown
            OnMouseMove = SNoLabMouseMove
            OnMouseUp = SNoPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
          end
          object MBLLab: TSBSPanel
            Left = 414
            Top = 2
            Width = 51
            Height = 14
            BevelOuter = bvNone
            Caption = 'Locn'
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 5
            OnMouseDown = SNoLabMouseDown
            OnMouseMove = SNoLabMouseMove
            OnMouseUp = SNoPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
          end
          object MBTLab: TSBSPanel
            Left = 466
            Top = 2
            Width = 88
            Height = 14
            BevelOuter = bvNone
            Caption = 'Auto Pick Mode'
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 6
            OnMouseDown = SNoLabMouseDown
            OnMouseMove = SNoLabMouseMove
            OnMouseUp = SNoPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
          end
          object MBKLab: TSBSPanel
            Left = 558
            Top = 2
            Width = 94
            Height = 14
            BevelOuter = bvNone
            Caption = 'Stock Code'
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 7
            OnMouseDown = SNoLabMouseDown
            OnMouseMove = SNoLabMouseMove
            OnMouseUp = SNoPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
          end
        end
        object MBIPanel: TSBSPanel
          Left = 260
          Top = 25
          Width = 77
          Height = 245
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clTeal
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clYellow
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          OnMouseUp = SNoPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
        end
        object MBOPanel: TSBSPanel
          Left = 339
          Top = 25
          Width = 77
          Height = 245
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clTeal
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clYellow
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          OnMouseUp = SNoPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
        end
        object MBCPanel: TSBSPanel
          Left = 2
          Top = 25
          Width = 78
          Height = 245
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clTeal
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clYellow
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          OnMouseUp = SNoPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
        end
        object MBQPanel: TSBSPanel
          Left = 82
          Top = 25
          Width = 105
          Height = 245
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clTeal
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clYellow
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
          OnMouseUp = SNoPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
        end
        object MBDPanel: TSBSPanel
          Left = 189
          Top = 25
          Width = 69
          Height = 245
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clTeal
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clYellow
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 5
          OnMouseUp = SNoPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
        end
        object MBLPanel: TSBSPanel
          Left = 418
          Top = 25
          Width = 50
          Height = 245
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clTeal
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clYellow
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 6
          OnMouseUp = SNoPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
        end
        object MBTPanel: TSBSPanel
          Left = 470
          Top = 25
          Width = 86
          Height = 245
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clTeal
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clYellow
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 7
          OnMouseUp = SNoPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
        end
        object MBKPanel: TSBSPanel
          Left = 558
          Top = 25
          Width = 99
          Height = 245
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clTeal
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clYellow
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 8
          OnMouseUp = SNoPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
        end
      end
    end
  end
  object TCMPanel: TSBSPanel
    Left = 446
    Top = 29
    Width = 102
    Height = 287
    BevelOuter = bvNone
    BorderStyle = bsSingle
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
      HelpContext = 259
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
        HelpContext = 164
        Caption = '&History'
        TabOrder = 5
        OnClick = HistCP1BtnClick
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
      object ChkCP1Btn: TButton
        Left = 2
        Top = 237
        Width = 80
        Height = 21
        HelpContext = 187
        Caption = 'Chec&k'
        TabOrder = 10
        OnClick = ChkCP1BtnClick
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
        Caption = '&Switch'
        TabOrder = 6
        OnClick = GenCP3BtnClick
      end
      object UCP1Btn: TButton
        Left = 2
        Top = 260
        Width = 80
        Height = 21
        Caption = '&Use'
        TabOrder = 11
        OnClick = UCP1BtnClick
      end
      object LnkCp1Btn: TButton
        Left = 2
        Top = 329
        Width = 80
        Height = 21
        Hint = 
          'Link to additional information|Displays a list of any additional' +
          ' information attached to this Stock Record.'
        Caption = 'Lin&ks'
        TabOrder = 13
        OnClick = LnkCp1BtnClick
      end
      object NteCP1Btn: TButton
        Left = 2
        Top = 352
        Width = 80
        Height = 21
        Hint = 'Access Note Pad|Displays any notes attached to this record.'
        HelpContext = 88
        Caption = '&Notes'
        TabOrder = 14
        OnClick = NteCP1BtnClick
      end
      object Altdb1Btn: TButton
        Left = 2
        Top = 306
        Width = 80
        Height = 21
        Hint = 
          'Show alternative codes|This option displays a list of alternativ' +
          'e codes available for the highlighted stock item.'
        HelpContext = 596
        Caption = 'Al&t Codes'
        TabOrder = 12
        OnClick = Altdb1BtnClick
      end
      object StkCuBtn1: TSBSButton
        Left = 2
        Top = 375
        Width = 80
        Height = 21
        Caption = 'Custom1'
        TabOrder = 15
        OnClick = StkCuBtn1Click
        TextId = 1
      end
      object StkCuBtn2: TSBSButton
        Left = 2
        Top = 398
        Width = 80
        Height = 21
        Caption = 'Custom2'
        TabOrder = 16
        OnClick = StkCuBtn1Click
        TextId = 11
      end
      object RetCP1Btn: TButton
        Left = 2
        Top = 283
        Width = 80
        Height = 21
        Caption = '&Return'
        TabOrder = 17
        OnClick = RetCP1BtnClick
      end
    end
  end
  object PopupMenu1: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 439
    Top = 13
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
      Caption = '&History'
      OnClick = HistCP1BtnClick
    end
    object Switch1: TMenuItem
      Caption = 'S&witch'
      OnClick = GenCP3BtnClick
    end
    object Print1: TMenuItem
      Caption = '&Print'
    end
    object View1: TMenuItem
      Caption = '&View'
      OnClick = ViewCP1BtnClick
    end
    object Copy1: TMenuItem
      Caption = 'Cop&y'
      OnClick = CopyCP1BtnClick
    end
    object Check1: TMenuItem
      Caption = 'Chec&k'
      OnClick = ChkCP1BtnClick
    end
    object Use1: TMenuItem
      Caption = '&Use'
      OnClick = UCP1BtnClick
    end
    object Return1: TMenuItem
      Caption = '&Return'
      OnClick = RetCP1BtnClick
    end
    object AltCodes1: TMenuItem
      Caption = 'Al&t Codes'
      OnClick = Altdb1BtnClick
    end
    object Links1: TMenuItem
      Caption = 'Lin&ks'
      Hint = 
        'Displays a list of any additional information attached to this S' +
        'tock Record.'
      OnClick = LnkCp1BtnClick
    end
    object Notes1: TMenuItem
      Caption = '&Notes'
      OnClick = NteCP1BtnClick
    end
    object Custom1: TMenuItem
      Caption = 'Custom Btn 1'
      OnClick = StkCuBtn1Click
    end
    object Custom2: TMenuItem
      Caption = 'Custom Btn 2'
      OnClick = StkCuBtn1Click
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
    Left = 464
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
    OnPopup = PopupMenu3Popup
    Left = 485
    Top = 65535
    object MIRec: TMenuItem
      Caption = '&Records'
      object Edit2: TMenuItem
        Tag = 2
        Caption = '&Edit'
        HelpContext = 220
        OnClick = Edit2Click
      end
      object Add2: TMenuItem
        Tag = 1
        Caption = '&Add'
        HelpContext = 225
        OnClick = Edit2Click
      end
      object Insert2: TMenuItem
        Tag = 4
        Caption = '&Insert'
        HelpContext = 308
        OnClick = Edit2Click
      end
      object Del2: TMenuItem
        Tag = 3
        Caption = '&Delete'
        HelpContext = 224
        OnClick = Edit2Click
      end
      object Check2: TMenuItem
        Caption = 'Chec&k'
        HelpContext = 430
        OnClick = Check2Click
      end
    end
    object WUsed2: TMenuItem
      Caption = '&Where Used'
      HelpContext = 223
      OnClick = WUsed2Click
    end
    object Build1: TMenuItem
      Caption = '&Build'
      HelpContext = 449
      Visible = False
      OnClick = WUsed2Click
    end
    object Links2: TMenuItem
      Caption = '&Links'
      OnClick = LnkCp1BtnClick
    end
    object Expand1: TMenuItem
      Caption = '&Expand'
      object MIETL: TMenuItem
        Tag = 1
        Caption = '&This Level'
        HelpContext = 167
        OnClick = MIEALClick
      end
      object MIEAL: TMenuItem
        Tag = 2
        Caption = '&All Levels'
        HelpContext = 168
        OnClick = MIEALClick
      end
      object EntireGeneralLedger1: TMenuItem
        Tag = 3
        Caption = '&Entire BOM Ledger'
        HelpContext = 169
        OnClick = MIEALClick
      end
    end
    object MIColl: TMenuItem
      Caption = '&Collapse'
      object MICTL: TMenuItem
        Tag = 4
        Caption = '&This Level'
        HelpContext = 170
        OnClick = MIEALClick
      end
      object EntireGeneralLedger2: TMenuItem
        Tag = 5
        Caption = '&Entire BOM Ledger'
        HelpContext = 171
        OnClick = MIEALClick
      end
    end
    object Custom3: TMenuItem
      Caption = 'Custom Btn 1'
      OnClick = StkCuBtn1Click
    end
    object Custom4: TMenuItem
      Caption = 'Custom Btn 2'
      OnClick = StkCuBtn1Click
    end
    object MenuItem5: TMenuItem
      Caption = '-'
    end
    object Pop1: TMenuItem
      Caption = '&Properties'
      HelpContext = 65
      Hint = 'Access Colour & Font settings'
      OnClick = PropFlgClick
    end
    object MenuItem7: TMenuItem
      Caption = '-'
    end
    object Save1: TMenuItem
      Caption = '&Save Coordinates'
      HelpContext = 177
      Hint = 'Make the current window settings permanent'
      OnClick = StoreCoordFlgClick
    end
    object N3: TMenuItem
      Caption = '-'
      Enabled = False
      Visible = False
    end
  end
  object PopupMenu4: TPopupMenu
    OnPopup = PopupMenu3Popup
    Left = 511
    Top = 65535
    object SN1: TMenuItem
      Tag = 1
      Caption = '&Serial Number'
      OnClick = SN1Click
    end
    object BN1: TMenuItem
      Tag = 2
      Caption = '&Batch Number'
      OnClick = SN1Click
    end
    object DN1: TMenuItem
      Tag = 3
      Caption = '&Document Number'
      OnClick = SN1Click
    end
  end
  object PopupMenu5: TPopupMenu
    OnPopup = PopupMenu5Popup
    Left = 526
    object ID1: TMenuItem
      Tag = 1
      Caption = '&In Document'
      OnClick = ID1Click
    end
    object OD1: TMenuItem
      Tag = 2
      Caption = '&Out Document'
      OnClick = ID1Click
    end
    object SnoSo1: TMenuItem
      Tag = 3
      Caption = '&Sales Order'
      Visible = False
      OnClick = ID1Click
    end
    object SnoPo1: TMenuItem
      Tag = 4
      Caption = '&Purchase Order'
      Visible = False
      OnClick = ID1Click
    end
    object StockRecord1: TMenuItem
      Tag = 5
      Caption = 'Stoc&k Record'
      OnClick = StockRecord1Click
    end
  end
  object PopupMenu6: TPopupMenu
    OnPopup = PopupMenu3Popup
    Left = 541
    Top = 65535
    object CFrom1: TMenuItem
      Caption = '&From another stock record'
      HelpContext = 131
      OnClick = CFrom1Click
    end
    object CTo1: TMenuItem
      Caption = '&To all lower levels'
      HelpContext = 131
      OnClick = CTo1Click
    end
  end
  object PopupMenu7: TPopupMenu
    Left = 552
    Top = 1
    object Account1: TMenuItem
      Tag = 16
      Caption = '&Account'
      OnClick = Account1Click
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object SalesOrdersOS1: TMenuItem
      Tag = 1
      Caption = '&Sales Orders O/S'
      OnClick = Account1Click
    end
    object PurchOrdersOS1: TMenuItem
      Tag = 2
      Caption = '&Purch Orders O/S'
      OnClick = Account1Click
    end
    object OSOrders1: TMenuItem
      Tag = 3
      Caption = '&All O/S Orders'
      OnClick = Account1Click
    end
    object PickedOrders1: TMenuItem
      Tag = 4
      Caption = '&Picked Orders'
      OnClick = Account1Click
    end
    object SalesOrders1: TMenuItem
      Tag = 5
      Caption = '&Sales Orders'
      OnClick = Account1Click
    end
    object PurchOrders1: TMenuItem
      Tag = 6
      Caption = '&Purch Orders'
      OnClick = Account1Click
    end
    object WorksOrders1: TMenuItem
      Tag = 17
      Caption = '&Works Orders'
      OnClick = Account1Click
    end
    object AllOrders1: TMenuItem
      Tag = 7
      Caption = '&All Orders'
      OnClick = Account1Click
    end
    object SalesDeliveryNote1: TMenuItem
      Tag = 8
      Caption = '&Sales Delivery Note'
      OnClick = Account1Click
    end
    object PurchDeliveryNote1: TMenuItem
      Tag = 9
      Caption = '&Purch Delivery Note'
      OnClick = Account1Click
    end
    object DeliveryNotes1: TMenuItem
      Tag = 10
      Caption = '&All Delivery Notes'
      OnClick = Account1Click
    end
    object RetSRN1: TMenuItem
      Tag = 19
      Caption = 'Sales &Return'
      OnClick = Account1Click
    end
    object RetPRN1: TMenuItem
      Tag = 20
      Caption = 'Purchase Ret&urn'
      OnClick = Account1Click
    end
    object RetALL1: TMenuItem
      Tag = 21
      Caption = '&All Returns'
      OnClick = Account1Click
    end
    object SalesTransactions1: TMenuItem
      Tag = 11
      Caption = '&Sales Transactions'
      OnClick = Account1Click
    end
    object PurchTransactions1: TMenuItem
      Tag = 12
      Caption = '&Purch Transactions'
      OnClick = Account1Click
    end
    object AdjTransactions1: TMenuItem
      Tag = 13
      Caption = 'Ad&j Transactions'
      OnClick = Account1Click
    end
    object Transactions1: TMenuItem
      Tag = 14
      Caption = '&All Transactions'
      OnClick = Account1Click
    end
    object N5: TMenuItem
      Caption = '-'
    end
    object NoFillter1: TMenuItem
      Tag = 15
      Caption = '&No Fillter'
      OnClick = Account1Click
    end
  end
  object EntCustom3: TCustomisation
    DLLId = SysDll_Ent
    Enabled = True
    ExportPath = 'c:\mh.RC'
    WindowId = 103001
    Left = 388
    Top = 12
  end
  object PopupMenu10: TPopupMenu
    Left = 409
    Top = 5
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
  object PopupMenu8: TPopupMenu
    OnPopup = PopupMenu8Popup
    Left = 372
    object RetId1: TMenuItem
      Tag = 1
      Caption = '&In Document'
      OnClick = RetId1Click
    end
    object RetOd1: TMenuItem
      Tag = 2
      Caption = '&Out Document'
      OnClick = RetId1Click
    end
  end
end
