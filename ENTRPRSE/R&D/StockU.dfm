object StockRec: TStockRec
  Left = -720
  Top = -254
  Width = 578
  Height = 639
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
  FormStyle = fsMDIChild
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
    Left = 2
    Top = 3
    Width = 558
    Height = 368
    ActivePage = Main
    TabIndex = 0
    TabOrder = 0
    OnChange = PageControl1Change
    OnChanging = PageControl1Changing
    object Main: TTabSheet
      HelpContext = 179
      Caption = 'Main'
      ImageIndex = -1
      object TCMScrollBox: TScrollBox
        Left = -2
        Top = 0
        Width = 437
        Height = 341
        VertScrollBar.Visible = False
        BorderStyle = bsNone
        TabOrder = 0
        object SBSBackGroup2: TSBSBackGroup
          Left = 5
          Top = 194
          Width = 268
          Height = 142
          TextId = 0
        end
        object SBSBackGroup1: TSBSBackGroup
          Left = 5
          Top = 2
          Width = 268
          Height = 194
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
          Top = 21
          Width = 23
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
        object Label828: Label8
          Left = 28
          Top = 237
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
          Top = 261
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
          Top = 286
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
          Top = 289
          Width = 141
          Height = 47
          TextId = 0
        end
        object ValLab: Label8
          Left = 10
          Top = 304
          Width = 44
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
          Top = 317
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
          Top = 44
          Width = 141
          Height = 246
          TextId = 0
        end
        object Label836: Label8
          Left = 304
          Top = 133
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
          Top = 193
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
          Top = 222
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
          Top = 262
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
          Top = 163
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
          Top = 63
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
          Top = 94
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
          Top = 119
          Width = 122
          Height = 2
        end
        object Bevel2: TBevel
          Left = 288
          Top = 247
          Width = 123
          Height = 2
        end
        object Label832: Label8
          Left = 10
          Top = 209
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
          Left = 283
          Top = 301
          Width = 104
          Height = 28
          Alignment = taRightJustify
          Caption = 'Show stock levels as sales units (packs)'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          WordWrap = True
        end
        object Label818: Label8
          Left = 207
          Top = 235
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
        object SRGLab: Label8
          Left = 12
          Top = 50
          Width = 83
          Height = 14
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Stock Group'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          Visible = False
          TextId = 0
        end
        object SBSBckGrpStkGrp: TSBSBackGroup
          Left = 278
          Top = 2
          Width = 141
          Height = 43
          Caption = 'Stock Group'
          TextId = 0
        end
        object lblStkGrp: TLabel
          Left = 289
          Top = 21
          Width = 117
          Height = 14
          AutoSize = False
          Caption = 'StockGroupCode'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          Layout = tlCenter
        end
        object SROOF: TCurrencyEdit
          Left = 332
          Top = 257
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
          TabOrder = 19
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
        object SRCF: Text8Pt
          Tag = 1
          Left = 12
          Top = 18
          Width = 158
          Height = 22
          HelpContext = 188
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
          TabOrder = 0
          OnExit = SRCFExit
          TextId = 0
          ViaSBtn = False
        end
        object SRSBox1: TScrollBox
          Left = 12
          Top = 43
          Width = 253
          Height = 145
          HelpContext = 162
          HorzScrollBar.Visible = False
          Ctl3D = True
          ParentCtl3D = False
          TabOrder = 2
          OnExit = SRSBox1Exit
          object SRD1F: Text8Pt
            Tag = 1
            Left = 2
            Top = 2
            Width = 245
            Height = 22
            AutoSize = False
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
            TabOrder = 0
            OnKeyPress = SRD1FKeyPress
            TextId = 0
            ViaSBtn = False
          end
          object SRD2F: Text8Pt
            Tag = 1
            Left = 2
            Top = 25
            Width = 245
            Height = 22
            AutoSize = False
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
            TabOrder = 1
            OnKeyPress = SRD1FKeyPress
            TextId = 0
            ViaSBtn = False
          end
          object SRD3F: Text8Pt
            Tag = 1
            Left = 2
            Top = 48
            Width = 245
            Height = 22
            AutoSize = False
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
            OnKeyPress = SRD1FKeyPress
            TextId = 0
            ViaSBtn = False
          end
          object SRD4F: Text8Pt
            Tag = 1
            Left = 2
            Top = 71
            Width = 245
            Height = 22
            AutoSize = False
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
            TabOrder = 3
            OnKeyPress = SRD1FKeyPress
            TextId = 0
            ViaSBtn = False
          end
          object SRD5F: Text8Pt
            Tag = 1
            Left = 2
            Top = 94
            Width = 245
            Height = 22
            AutoSize = False
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
            TabOrder = 4
            OnKeyPress = SRD1FKeyPress
            TextId = 0
            ViaSBtn = False
          end
          object SRD6F: Text8Pt
            Tag = 1
            Left = 2
            Top = 117
            Width = 245
            Height = 22
            AutoSize = False
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
            TabOrder = 5
            OnKeyPress = SRD1FKeyPress
            TextId = 0
            ViaSBtn = False
          end
        end
        object SRISF: TCurrencyEdit
          Left = 332
          Top = 128
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
          BlockNegative = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
          ShowCurrency = False
          TextId = 0
          Value = 1E-10
        end
        object SRPOF: TCurrencyEdit
          Left = 332
          Top = 158
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
          BlockNegative = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
          ShowCurrency = False
          TextId = 0
          Value = 1E-10
        end
        object SRALF: TCurrencyEdit
          Left = 332
          Top = 188
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
          BlockNegative = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
          ShowCurrency = False
          TextId = 0
          Value = 1E-10
        end
        object SRFRF: TCurrencyEdit
          Left = 332
          Top = 217
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
        object SRCPF: TCurrencyEdit
          Tag = 1
          Left = 107
          Top = 256
          Width = 95
          Height = 22
          HelpContext = 191
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
        object SRRPF: TCurrencyEdit
          Tag = 1
          Left = 107
          Top = 281
          Width = 95
          Height = 22
          HelpContext = 192
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
        object SRTF: TSBSComboBox
          Tag = 1
          Left = 201
          Top = 17
          Width = 64
          Height = 22
          HelpContext = 161
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
          OnChange = SRTFChange
          OnEnter = SRTFEnter
          OnExit = SRTFExit
          AllowChangeInExit = True
          ExtendedList = True
          MaxListWidth = 90
          ReadOnly = True
          Validate = True
        end
        object SRCPCF: TSBSComboBox
          Tag = 1
          Left = 57
          Top = 256
          Width = 48
          Height = 22
          HelpContext = 191
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
          TabOrder = 7
          ExtendedList = True
          MaxListWidth = 115
          ReadOnly = True
          Validate = True
        end
        object SRRPCF: TSBSComboBox
          Tag = 1
          Left = 57
          Top = 281
          Width = 48
          Height = 22
          HelpContext = 192
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
          TabOrder = 9
          ExtendedList = True
          MaxListWidth = 115
          ReadOnly = True
          Validate = True
        end
        object SRMIF: TCurrencyEdit
          Tag = 1
          Left = 332
          Top = 60
          Width = 80
          Height = 22
          HelpContext = 194
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
          TabOrder = 13
          WantReturns = False
          WordWrap = False
          OnEnter = SRMIFEnter
          OnExit = SRMIFExit
          AutoSize = False
          BlockNegative = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
          ShowCurrency = False
          TextId = 0
          Value = 1E-10
        end
        object SRMXF: TCurrencyEdit
          Tag = 1
          Left = 332
          Top = 90
          Width = 80
          Height = 22
          HelpContext = 194
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
          TabOrder = 14
          WantReturns = False
          WordWrap = False
          OnEnter = SRMXFEnter
          OnExit = SRMXFExit
          AutoSize = False
          BlockNegative = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
          ShowCurrency = False
          TextId = 0
          Value = 1E-10
        end
        object SRVMF: TSBSComboBox
          Tag = 1
          Left = 57
          Top = 306
          Width = 117
          Height = 22
          HelpContext = 193
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
          OnExit = SRVMFExit
          MaxListWidth = 77
          ReadOnly = True
          Validate = True
        end
        object SRPComboF: TSBSComboBox
          Tag = 1
          Left = 57
          Top = 206
          Width = 208
          Height = 22
          HelpContext = 189
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
          OnExit = SRVMFExit
          MaxListWidth = 77
          ReadOnly = True
          Validate = True
        end
        object EditSPBtn: TSBSButton
          Left = 234
          Top = 231
          Width = 32
          Height = 21
          Caption = '>>'
          TabOrder = 6
          OnClick = EditSPBtnClick
          TextId = 0
        end
        object SRSP1F: TCurrencyEdit
          Tag = 1
          Left = 57
          Top = 231
          Width = 95
          Height = 22
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
          OnDblClick = EditSPBtnClick
          OnExit = SRSP1FExit
          AutoSize = False
          BlockNegative = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
          ShowCurrency = True
          TextId = 0
          Value = 1E-10
        end
        object SRGP1: TCurrencyEdit
          Tag = 1
          Left = 153
          Top = 231
          Width = 49
          Height = 22
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Lines.Strings = (
            '1.0 ')
          ParentFont = False
          ReadOnly = True
          TabOrder = 5
          WantReturns = False
          WordWrap = False
          AutoSize = False
          BlockNegative = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.0 ;###,###,##0.0-'
          DecPlaces = 1
          ShowCurrency = False
          TextId = 0
          Value = 1
        end
        object SRMBF: TCheckBoxEx
          Tag = 1
          Left = 177
          Top = 307
          Width = 91
          Height = 20
          HelpContext = 1459
          Caption = 'Use Multi Bins'
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          TabOrder = 12
          Modified = False
          ReadOnly = True
        end
        object SRSPF: TCheckBoxEx
          Tag = 1
          Left = 394
          Top = 306
          Width = 16
          Height = 20
          HelpContext = 544
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          TabOrder = 20
          Modified = False
          ReadOnly = True
        end
      end
    end
    object Defaults: TTabSheet
      HelpContext = 196
      Caption = 'Defaults'
      ImageIndex = -1
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
        Alignment = taRightJustify
        AutoSize = False
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
        Width = 57
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
        Width = 100
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
        OnEnter = SRFSFEnter
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
        OnEnter = SRFSFEnter
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
        OnEnter = SRFSFEnter
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
        OnEnter = SRFSFEnter
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
        OnEnter = SRFSFEnter
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
        TabOrder = 3
        OnEnter = SRFSFEnter
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
        OnEnter = SRFSFEnter
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
        OnEnter = SRFSFEnter
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
        TabOrder = 0
        OnEnter = SRFSFEnter
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
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          '0.0000 ')
        MaxLength = 15
        ParentFont = False
        ReadOnly = True
        TabOrder = 22
        WantReturns = False
        WordWrap = False
        AutoSize = False
        BlockNegative = False
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
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          '0.0000 ')
        MaxLength = 15
        ParentFont = False
        ReadOnly = True
        TabOrder = 23
        WantReturns = False
        WordWrap = False
        OnExit = SRPUFExit
        AutoSize = False
        BlockNegative = False
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
      object SRLocF: Text8Pt
        Tag = 1
        Left = 83
        Top = 84
        Width = 68
        Height = 22
        HelpContext = 911
        AutoSize = False
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
        OnEnter = SRFSFEnter
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
        TextId = 0
        ViaSBtn = False
      end
    end
    object tabshTax: TTabSheet
      Caption = 'Tax'
      ImageIndex = 13
      object panECServices: TPanel
        Left = 0
        Top = 175
        Width = 437
        Height = 45
        BevelOuter = bvNone
        TabOrder = 2
        object lblECServiceTitle: TLabel
          Left = 8
          Top = 10
          Width = 104
          Height = 14
          Caption = 'EC Services Settings '
        end
        object bevECService: TBevel
          Left = 113
          Top = 17
          Width = 319
          Height = 9
          Shape = bsTopLine
        end
        object chkECService: TCheckBoxEx
          Tag = 1
          Left = 65
          Top = 24
          Width = 71
          Height = 20
          HelpContext = 8105
          Alignment = taLeftJustify
          Caption = 'EC Service'
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          TabOrder = 0
          Modified = False
          ReadOnly = True
        end
      end
      object panIntrastatSettings: TPanel
        Left = 0
        Top = 44
        Width = 437
        Height = 131
        BevelOuter = bvNone
        TabOrder = 1
        object lblIntrastatSettingsTitle: TLabel
          Left = 8
          Top = 10
          Width = 84
          Height = 14
          Caption = 'Intrastat Settings '
        end
        object bevIntrastatSettingsTitle: TBevel
          Left = 93
          Top = 17
          Width = 339
          Height = 9
          Shape = bsTopLine
        end
        object Label849: Label8
          Left = 6
          Top = 30
          Width = 112
          Height = 14
          Alignment = taRightJustify
          Caption = 'Commodity/TARIC Code'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label850: Label8
          Left = 19
          Top = 56
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
          Left = 8
          Top = 82
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
          Left = 10
          Top = 108
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
          Left = 222
          Top = 30
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
          Left = 252
          Top = 56
          Width = 79
          Height = 14
          Alignment = taRightJustify
          Caption = 'Uplift Dispatch%'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label848: Label8
          Left = 249
          Top = 108
          Width = 82
          Height = 14
          Alignment = taRightJustify
          Caption = 'Country of Origin'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          WordWrap = True
          TextId = 0
        end
        object Label819: Label8
          Left = 257
          Top = 82
          Width = 74
          Height = 14
          Alignment = taRightJustify
          Caption = 'Uplift Arrivals%'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object CCodeF: Text8Pt
          Tag = 1
          Left = 123
          Top = 27
          Width = 90
          Height = 22
          HelpContext = 207
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
          TextId = 0
          ViaSBtn = False
        end
        object SSUDF: Text8Pt
          Tag = 1
          Left = 123
          Top = 53
          Width = 90
          Height = 22
          HelpContext = 207
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
          TabOrder = 1
          TextId = 0
          ViaSBtn = False
        end
        object SSDUF: TCurrencyEdit
          Tag = 1
          Left = 123
          Top = 79
          Width = 90
          Height = 22
          HelpContext = 207
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
          TabOrder = 2
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
        object SWF: TCurrencyEdit
          Tag = 1
          Left = 123
          Top = 105
          Width = 90
          Height = 22
          HelpContext = 207
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
        object PWF: TCurrencyEdit
          Tag = 1
          Left = 336
          Top = 27
          Width = 90
          Height = 22
          HelpContext = 207
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
          TabOrder = 4
          WantReturns = False
          WordWrap = False
          OnExit = PWFExit
          AutoSize = False
          BlockNegative = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
          ShowCurrency = False
          TextId = 0
          Value = 1E-10
        end
        object SRSUP: TCurrencyEdit
          Tag = 1
          Left = 336
          Top = 53
          Width = 49
          Height = 22
          HelpContext = 74
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Lines.Strings = (
            '0.0 ')
          MaxLength = 12
          ParentFont = False
          ReadOnly = True
          TabOrder = 5
          WantReturns = False
          WordWrap = False
          AutoSize = False
          BlockNegative = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.0 ;###,###,##0.0-'
          DecPlaces = 1
          ShowCurrency = False
          TextId = 0
          Value = 1E-10
        end
        object ccyIntrastatArrivalsPerc: TCurrencyEdit
          Tag = 1
          Left = 336
          Top = 79
          Width = 49
          Height = 22
          HelpContext = 74
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Lines.Strings = (
            '0.0 ')
          MaxLength = 12
          ParentFont = False
          ReadOnly = True
          TabOrder = 6
          Visible = False
          WantReturns = False
          WordWrap = False
          AutoSize = False
          BlockNegative = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.0 ;###,###,##0.0-'
          DecPlaces = 1
          ShowCurrency = False
          TextId = 0
          Value = 1E-10
        end
        object SRCOF: Text8Pt
          Tag = 1
          Left = 336
          Top = 105
          Width = 90
          Height = 22
          HelpContext = 74
          AutoSize = False
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          MaxLength = 5
          ParentFont = False
          ParentShowHint = False
          ReadOnly = True
          ShowHint = True
          TabOrder = 7
          OnExit = SRCOFExit
          TextId = 0
          ViaSBtn = False
        end
      end
      object panTaxCodes: TPanel
        Left = 0
        Top = 0
        Width = 437
        Height = 47
        BevelOuter = bvNone
        TabOrder = 0
        object lblTaxCodeTitle: TLabel
          Left = 8
          Top = 2
          Width = 51
          Height = 14
          Caption = 'Tax Codes'
        end
        object Bevel5: TBevel
          Left = 63
          Top = 9
          Width = 369
          Height = 9
          Shape = bsTopLine
        end
        object lblDefaultTaxCode: Label8
          Left = 8
          Top = 23
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
          TextId = 0
        end
        object cbTaxCode: TSBSComboBox
          Tag = 1
          Left = 95
          Top = 19
          Width = 118
          Height = 22
          HelpContext = 206
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
          OnClick = cbTaxCodeExit
          OnExit = cbTaxCodeExit
          MaxListWidth = 176
          ReadOnly = True
          Validate = True
        end
      end
    end
    object Def2Page: TTabSheet
      HelpContext = 22
      Caption = 'Web / User'
      ImageIndex = -1
      object UD1Lab: Label8
        Left = 0
        Top = 167
        Width = 85
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
        Left = 0
        Top = 193
        Width = 85
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
      object lblLineType: Label8
        Left = 42
        Top = 116
        Width = 43
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
        Left = 0
        Top = 219
        Width = 85
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
        Left = 0
        Top = 245
        Width = 85
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
      object Label826: Label8
        Left = 9
        Top = 40
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
        Left = 12
        Top = 66
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
      object UD5Lab: Label8
        Left = 0
        Top = 271
        Width = 85
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
        TextId = 0
      end
      object UD6Lab: Label8
        Left = 217
        Top = 167
        Width = 80
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
        TextId = 0
      end
      object UD7Lab: Label8
        Left = 217
        Top = 193
        Width = 80
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
        TextId = 0
      end
      object UD8Lab: Label8
        Left = 217
        Top = 219
        Width = 80
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
        TextId = 0
      end
      object UD9Lab: Label8
        Left = 217
        Top = 245
        Width = 80
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
        TextId = 0
      end
      object UD10Lab: Label8
        Left = 217
        Top = 271
        Width = 80
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
        TextId = 0
      end
      object lblWebSettingsTitle: TLabel
        Left = 8
        Top = 2
        Width = 64
        Height = 14
        Caption = 'Web Settings'
      end
      object bevWebSettingsTitle: TBevel
        Left = 76
        Top = 9
        Width = 356
        Height = 9
        Shape = bsTopLine
      end
      object lblDefaultLineTypeTitle: TLabel
        Left = 8
        Top = 96
        Width = 83
        Height = 14
        Caption = 'Default Line Type'
      end
      object bevDefaultLineTypeTitle: TBevel
        Left = 95
        Top = 103
        Width = 337
        Height = 9
        Shape = bsTopLine
      end
      object lblUserDefinedFieldsTitle: TLabel
        Left = 8
        Top = 147
        Width = 94
        Height = 14
        Caption = 'User Defined Fields'
      end
      object bevUserDefinedFieldsTitle: TBevel
        Left = 106
        Top = 154
        Width = 326
        Height = 9
        Shape = bsTopLine
      end
      object SRLTF: TSBSComboBox
        Tag = 1
        Left = 90
        Top = 113
        Width = 100
        Height = 22
        HelpContext = 276
        Style = csDropDownList
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 0
        MaxLength = 40
        ParentFont = False
        TabOrder = 3
        ExtendedList = True
        MaxListWidth = 75
        ReadOnly = True
        Validate = True
      end
      object UD1F: Text8Pt
        Tag = 1
        Left = 90
        Top = 164
        Width = 125
        Height = 22
        HelpContext = 209
        AutoSize = False
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
        OnExit = UD1FExit
        TextId = 0
        ViaSBtn = False
        OnEntHookEvent = UD1FEntHookEvent
      end
      object UD2F: Text8Pt
        Tag = 1
        Left = 90
        Top = 190
        Width = 125
        Height = 22
        HelpContext = 209
        AutoSize = False
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
        OnExit = UD1FExit
        TextId = 0
        ViaSBtn = False
        OnEntHookEvent = UD1FEntHookEvent
      end
      object UD3F: Text8Pt
        Tag = 1
        Left = 90
        Top = 216
        Width = 125
        Height = 22
        HelpContext = 209
        AutoSize = False
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
        TabOrder = 6
        OnExit = UD1FExit
        TextId = 0
        ViaSBtn = False
        OnEntHookEvent = UD1FEntHookEvent
      end
      object UD4F: Text8Pt
        Tag = 1
        Left = 90
        Top = 242
        Width = 125
        Height = 22
        HelpContext = 209
        AutoSize = False
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
        TabOrder = 7
        OnExit = UD1FExit
        TextId = 0
        ViaSBtn = False
        OnEntHookEvent = UD1FEntHookEvent
      end
      object WebCatF: Text8Pt
        Tag = 1
        Left = 90
        Top = 36
        Width = 142
        Height = 22
        HelpContext = 1173
        CharCase = ecUpperCase
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
      object WebImgF: Text8Pt
        Tag = 1
        Left = 90
        Top = 62
        Width = 213
        Height = 22
        HelpContext = 1174
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
      object UD5F: Text8Pt
        Tag = 1
        Left = 90
        Top = 268
        Width = 125
        Height = 22
        HelpContext = 209
        AutoSize = False
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
        TabOrder = 8
        OnExit = UD1FExit
        TextId = 0
        ViaSBtn = False
        OnEntHookEvent = UD1FEntHookEvent
      end
      object UD6F: Text8Pt
        Tag = 1
        Left = 302
        Top = 164
        Width = 125
        Height = 22
        HelpContext = 209
        AutoSize = False
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
        TabOrder = 9
        OnExit = UD1FExit
        TextId = 0
        ViaSBtn = False
        OnEntHookEvent = UD1FEntHookEvent
      end
      object UD7F: Text8Pt
        Tag = 1
        Left = 302
        Top = 190
        Width = 125
        Height = 22
        HelpContext = 209
        AutoSize = False
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
        TabOrder = 10
        OnExit = UD1FExit
        TextId = 0
        ViaSBtn = False
        OnEntHookEvent = UD1FEntHookEvent
      end
      object UD8F: Text8Pt
        Tag = 1
        Left = 302
        Top = 216
        Width = 125
        Height = 22
        HelpContext = 209
        AutoSize = False
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
        TabOrder = 11
        OnExit = UD1FExit
        TextId = 0
        ViaSBtn = False
        OnEntHookEvent = UD1FEntHookEvent
      end
      object UD9F: Text8Pt
        Tag = 1
        Left = 302
        Top = 242
        Width = 125
        Height = 22
        HelpContext = 209
        AutoSize = False
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
        TabOrder = 12
        OnExit = UD1FExit
        TextId = 0
        ViaSBtn = False
        OnEntHookEvent = UD1FEntHookEvent
      end
      object UD10F: Text8Pt
        Tag = 1
        Left = 302
        Top = 268
        Width = 125
        Height = 22
        HelpContext = 209
        AutoSize = False
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
        TabOrder = 13
        OnExit = UD1FExit
        TextId = 0
        ViaSBtn = False
        OnEntHookEvent = UD1FEntHookEvent
      end
      object emWebF: TCheckBoxEx
        Tag = 1
        Left = 11
        Top = 16
        Width = 92
        Height = 20
        HelpContext = 1172
        TabStop = False
        Alignment = taLeftJustify
        Caption = 'Include on Web '
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 0
        Modified = False
        ReadOnly = True
      end
    end
    object WOPPage: TTabSheet
      HelpContext = 1267
      Caption = 'WOP'
      ImageIndex = -1
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
        BlockNegative = False
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
        BlockNegative = False
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
        BlockNegative = False
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
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
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
        OnChange = SRROLTFChange
        AutoSize = False
        BlockNegative = False
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
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
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
        OnChange = SRASSDFChange
        AutoSize = False
        BlockNegative = False
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
        TabOrder = 2
        WantReturns = False
        WordWrap = False
        OnChange = SRASSHFChange
        AutoSize = False
        BlockNegative = False
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
        TabOrder = 4
        WantReturns = False
        WordWrap = False
        OnChange = SRASSMFChange
        AutoSize = False
        BlockNegative = False
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
      object SRMEBQF: TCurrencyEdit
        Tag = 1
        Left = 337
        Top = 52
        Width = 75
        Height = 22
        HelpContext = 1269
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          '0.0000 ')
        MaxLength = 15
        ParentFont = False
        ReadOnly = True
        TabOrder = 9
        WantReturns = False
        WordWrap = False
        AutoSize = False
        BlockNegative = False
        BlankOnZero = False
        DisplayFormat = '###,###,##0.0000 ;###,###,##0.0000-'
        DecPlaces = 4
        ShowCurrency = False
        TextId = 0
        Value = 1E-10
      end
      object CBCalcProdT: TCheckBoxEx
        Tag = 1
        Left = 264
        Top = 27
        Width = 146
        Height = 20
        HelpContext = 1266
        TabStop = False
        Alignment = taLeftJustify
        Caption = 'Auto Calculate Prod. Time'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 6
        Modified = False
        ReadOnly = True
      end
    end
    object RetPage: TTabSheet
      HelpContext = 1591
      Caption = 'Returns'
      ImageIndex = -1
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
        Width = 426
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
        HelpContext = 1590
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
        BlockNegative = False
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
        HelpContext = 1590
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
        BlockNegative = False
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
        HelpContext = 1587
        AutoSize = False
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
        OnEnter = SRFSFEnter
        OnExit = SRGSFExit
        TextId = 0
        ViaSBtn = False
      end
      object SRRGLDF: Text8Pt
        Left = 218
        Top = 77
        Width = 196
        Height = 22
        HelpContext = 1587
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
        HelpContext = 1585
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
        Value = 1
      end
      object SBSUpDown4: TSBSUpDown
        Tag = 1
        Left = 149
        Top = 26
        Width = 15
        Height = 22
        HelpContext = 1585
        Associate = SRRSWDF
        ArrowKeys = False
        Enabled = False
        Min = 0
        Max = 99
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
        HelpContext = 1585
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
        TabOrder = 3
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
      object SBSUpDown5: TSBSUpDown
        Tag = 1
        Left = 149
        Top = 52
        Width = 15
        Height = 22
        HelpContext = 1585
        Associate = SRRMWDF
        ArrowKeys = False
        Enabled = False
        Min = 0
        Max = 99
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
        HelpContext = 1585
        Style = csDropDownList
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
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
        HelpContext = 1585
        Style = csDropDownList
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
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
      object SRRPGLF: Text8Pt
        Tag = 1
        Left = 111
        Top = 103
        Width = 102
        Height = 22
        HelpContext = 1588
        AutoSize = False
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
        OnEnter = SRFSFEnter
        OnExit = SRGSFExit
        TextId = 0
        ViaSBtn = False
      end
      object SRRGLPDF: Text8Pt
        Left = 218
        Top = 103
        Width = 196
        Height = 22
        HelpContext = 1588
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
        TextId = 0
        ViaSBtn = False
      end
      object SRRRCF: Text8Pt
        Tag = 1
        Left = 111
        Top = 148
        Width = 102
        Height = 22
        HelpContext = 1589
        AutoSize = False
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
        OnExit = SRRRCFExit
        TextId = 0
        ViaSBtn = False
      end
    end
    object Notes: TTabSheet
      HelpContext = 438
      Caption = 'Notes'
      ImageIndex = -1
      object TCNScrollBox: TScrollBox
        Left = 3
        Top = 3
        Width = 414
        Height = 334
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
          Height = 288
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
          Height = 288
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
          Height = 288
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
        Height = 290
        BevelOuter = bvLowered
        TabOrder = 1
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
      end
    end
    object QtyBreaks: TTabSheet
      Caption = 'Qty Breaks'
      ImageIndex = -1
      object QBSBox: TScrollBox
        Left = 3
        Top = 3
        Width = 414
        Height = 332
        VertScrollBar.Visible = False
        TabOrder = 0
        object QBHedPanel: TSBSPanel
          Left = 2
          Top = 3
          Width = 583
          Height = 18
          BevelInner = bvLowered
          BevelOuter = bvNone
          Color = clWhite
          TabOrder = 0
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumnHeader
          object QBFLab: TSBSPanel
            Left = 2
            Top = 1
            Width = 53
            Height = 16
            BevelOuter = bvNone
            Caption = 'From'
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
            OnMouseDown = SNoLabMouseDown
            OnMouseMove = SNoLabMouseMove
            OnMouseUp = SNoPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object QBYLab: TSBSPanel
            Left = 115
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
            OnMouseDown = SNoLabMouseDown
            OnMouseMove = SNoLabMouseMove
            OnMouseUp = SNoPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object QBULab: TSBSPanel
            Left = 149
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
            OnMouseDown = SNoLabMouseDown
            OnMouseMove = SNoLabMouseMove
            OnMouseUp = SNoPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object QBBLab: TSBSPanel
            Left = 214
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
            OnMouseDown = SNoLabMouseDown
            OnMouseMove = SNoLabMouseMove
            OnMouseUp = SNoPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object QBDLab: TSBSPanel
            Left = 259
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
            OnMouseDown = SNoLabMouseDown
            OnMouseMove = SNoLabMouseMove
            OnMouseUp = SNoPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object QBVLab: TSBSPanel
            Left = 321
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
            OnMouseDown = SNoLabMouseDown
            OnMouseMove = SNoLabMouseMove
            OnMouseUp = SNoPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object QBMLab: TSBSPanel
            Left = 386
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
            OnMouseDown = SNoLabMouseDown
            OnMouseMove = SNoLabMouseMove
            OnMouseUp = SNoPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object QBTLab: TSBSPanel
            Left = 60
            Top = 2
            Width = 53
            Height = 15
            BevelOuter = bvNone
            Caption = 'To'
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
            OnMouseDown = SNoLabMouseDown
            OnMouseMove = SNoLabMouseMove
            OnMouseUp = SNoPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object QBEffLab: TSBSPanel
            Left = 447
            Top = 1
            Width = 131
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
            TabOrder = 8
            OnMouseDown = SNoLabMouseDown
            OnMouseMove = SNoLabMouseMove
            OnMouseUp = SNoPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
        end
        object QBFPanel: TSBSPanel
          Left = 2
          Top = 24
          Width = 55
          Height = 288
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
          OnMouseUp = SNoPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object QBYPanel: TSBSPanel
          Left = 118
          Top = 24
          Width = 31
          Height = 288
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
          OnMouseUp = SNoPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object QBDPanel: TSBSPanel
          Left = 260
          Top = 24
          Width = 61
          Height = 288
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
          OnMouseUp = SNoPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object QBVPanel: TSBSPanel
          Left = 324
          Top = 24
          Width = 61
          Height = 288
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
          OnMouseUp = SNoPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object QBMPanel: TSBSPanel
          Left = 388
          Top = 24
          Width = 61
          Height = 288
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
          OnMouseUp = SNoPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object QBUPanel: TSBSPanel
          Left = 152
          Top = 24
          Width = 61
          Height = 288
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
          OnMouseUp = SNoPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object QBBPAnel: TSBSPanel
          Left = 216
          Top = 24
          Width = 41
          Height = 288
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
          OnMouseUp = SNoPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object QBTPanel: TSBSPanel
          Left = 60
          Top = 24
          Width = 55
          Height = 288
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
          OnMouseUp = SNoPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object QBEffPanel: TSBSPanel
          Left = 451
          Top = 24
          Width = 131
          Height = 288
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
          OnMouseUp = SNoPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
      end
    end
    object tabMultiBuy: TTabSheet
      HelpContext = 8010
      Caption = 'Multi-Buy Discounts'
      ImageIndex = -1
      inline mbdFrame: TMultiBuyDiscountFrame
        Left = 0
        Top = 0
        Width = 433
        Height = 327
        TabOrder = 0
        inherited scrMBDList: TScrollBox
          Left = 3
          Top = 3
          Width = 375
          Height = 320
          inherited mdPanSCode: TSBSPanel
            Font.Name = 'Arial'
            OnMouseUp = CLORefPanelMouseUp
          end
          inherited mdPanBuyQty: TSBSPanel
            Font.Name = 'Arial'
            OnMouseUp = CLORefPanelMouseUp
          end
          inherited mdPanDisc: TSBSPanel
            Font.Name = 'Arial'
            OnMouseUp = CLORefPanelMouseUp
          end
          inherited mdPanFreeQty: TSBSPanel
            Font.Name = 'Arial'
            OnMouseUp = CLORefPanelMouseUp
          end
          inherited mdPanPurchVal: TSBSPanel
            Font.Name = 'Arial'
            OnMouseUp = CLORefPanelMouseUp
          end
          inherited mdPanDates: TSBSPanel
            Font.Name = 'Arial'
            OnMouseUp = CLORefPanelMouseUp
          end
        end
        inherited mbdListBtnPanel: TSBSPanel
          Left = 384
          Top = 28
          Height = 270
        end
      end
    end
    object Ledger: TTabSheet
      HelpContext = 219
      Caption = 'Ledger'
      ImageIndex = -1
      object CLSBox: TScrollBox
        Left = 3
        Top = 3
        Width = 414
        Height = 334
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
          Color = clWhite
          TabOrder = 0
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumnHeader
          object CLORefLab: TSBSPanel
            Left = 2
            Top = 2
            Width = 31
            Height = 14
            BevelOuter = bvNone
            Caption = 'Ref'
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
            Left = 36
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
          object CLUPLab: TSBSPanel
            Left = 657
            Top = 2
            Width = 80
            Height = 14
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = 'Unit Price  '
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
          object CLOOLab: TSBSPanel
            Left = 347
            Top = 2
            Width = 59
            Height = 14
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = 'On Order '
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
          object CLQOLab: TSBSPanel
            Left = 224
            Top = 2
            Width = 59
            Height = 14
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = 'Qty Out  '
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
          object CLALLab: TSBSPanel
            Left = 285
            Top = 2
            Width = 60
            Height = 14
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = 'Allocated '
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
          object CLQILab: TSBSPanel
            Left = 162
            Top = 2
            Width = 59
            Height = 14
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = 'Qty In  '
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
          object CLACLab: TSBSPanel
            Left = 107
            Top = 2
            Width = 52
            Height = 14
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = 'A/C Code '
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
          object CLAWLab: TSBSPanel
            Left = 411
            Top = 2
            Width = 60
            Height = 14
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = ' Alloc WOR '
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
          object CLIWLab: TSBSPanel
            Left = 473
            Top = 2
            Width = 59
            Height = 14
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = 'Issud WOR'
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
          object CLSRLab: TSBSPanel
            Left = 534
            Top = 2
            Width = 60
            Height = 14
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = 'Sales Ret. '
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
          object CLPRLab: TSBSPanel
            Left = 596
            Top = 2
            Width = 59
            Height = 14
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = 'Purch Ret. '
            Color = clWhite
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
            Purpose = puBtrListColumnHeader
          end
        end
        object CLORefPanel: TSBSPanel
          Left = -359
          Top = 25
          Width = 33
          Height = 288
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
          Left = -324
          Top = 25
          Width = 69
          Height = 288
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
        object CLUPPanel: TSBSPanel
          Left = 299
          Top = 25
          Width = 83
          Height = 288
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
        object CLOOPanel: TSBSPanel
          Left = -11
          Top = 25
          Width = 60
          Height = 288
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
        object CLQOPanel: TSBSPanel
          Left = -135
          Top = 25
          Width = 60
          Height = 288
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
        object CLALPanel: TSBSPanel
          Left = -73
          Top = 25
          Width = 60
          Height = 288
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
        object CLQIPanel: TSBSPanel
          Left = -197
          Top = 25
          Width = 60
          Height = 288
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
        object CLAcPanel: TSBSPanel
          Left = -253
          Top = 25
          Width = 54
          Height = 288
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
        object CLAWPanel: TSBSPanel
          Left = 51
          Top = 25
          Width = 60
          Height = 288
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
        object CLIWPanel: TSBSPanel
          Left = 113
          Top = 25
          Width = 60
          Height = 288
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
        object CLSRPanel: TSBSPanel
          Left = 175
          Top = 25
          Width = 60
          Height = 288
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
        object CLPRPanel: TSBSPanel
          Left = 237
          Top = 25
          Width = 60
          Height = 288
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 12
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
        Height = 290
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
      ImageIndex = -1
      object VSBox: TScrollBox
        Left = 3
        Top = 3
        Width = 414
        Height = 333
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
          Color = clWhite
          TabOrder = 0
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumnHeader
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
            OnMouseDown = SNoLabMouseDown
            OnMouseMove = SNoLabMouseMove
            OnMouseUp = SNoPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object VILab: TSBSPanel
            Left = 260
            Top = 2
            Width = 59
            Height = 14
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = 'In Stk  '
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
            OnMouseDown = SNoLabMouseDown
            OnMouseMove = SNoLabMouseMove
            OnMouseUp = SNoPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object VULab: TSBSPanel
            Left = 321
            Top = 2
            Width = 82
            Height = 14
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = 'Unit Cost '
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
            OnMouseDown = SNoLabMouseDown
            OnMouseMove = SNoLabMouseMove
            OnMouseUp = SNoPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object VQLab: TSBSPanel
            Left = 198
            Top = 2
            Width = 59
            Height = 14
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = 'Qty '
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
            OnMouseDown = SNoLabMouseDown
            OnMouseMove = SNoLabMouseMove
            OnMouseUp = SNoPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object VALab: TSBSPanel
            Left = 143
            Top = 2
            Width = 52
            Height = 14
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = 'A/C Code '
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
            OnMouseDown = SNoLabMouseDown
            OnMouseMove = SNoLabMouseMove
            OnMouseUp = SNoPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object VLocLab: TSBSPanel
            Left = 408
            Top = 2
            Width = 49
            Height = 14
            BevelOuter = bvNone
            Caption = 'Location'
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
            OnMouseDown = SNoLabMouseDown
            OnMouseMove = SNoLabMouseMove
            OnMouseUp = SNoPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
        end
        object VOPanel: TSBSPanel
          Left = 2
          Top = 25
          Width = 71
          Height = 288
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
          OnMouseUp = SNoPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object VDPanel: TSBSPanel
          Left = 75
          Top = 25
          Width = 69
          Height = 288
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
          OnMouseUp = SNoPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object VUPAnel: TSBSPanel
          Left = 326
          Top = 25
          Width = 83
          Height = 288
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
          OnMouseUp = SNoPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object VIPanel: TSBSPanel
          Left = 264
          Top = 25
          Width = 60
          Height = 288
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
          OnMouseUp = SNoPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object VQPanel: TSBSPanel
          Left = 202
          Top = 25
          Width = 60
          Height = 288
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
          OnMouseUp = SNoPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object VAPanel: TSBSPanel
          Left = 146
          Top = 25
          Width = 54
          Height = 288
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
          OnMouseUp = SNoPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object VLocPanel: TSBSPanel
          Left = 411
          Top = 25
          Width = 50
          Height = 288
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
          OnMouseUp = SNoPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
      end
    end
    object BOMPage: TTabSheet
      HelpContext = 217
      Caption = 'Build'
      ImageIndex = -1
      PopupMenu = PopupMenu3
      object NLDPanel: TPanel
        Left = 3
        Top = 51
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
        TabOrder = 1
        object Image5: TImage
          Left = 176
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
        Top = 51
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
        TabOrder = 2
      end
      object NLDrPanel: TPanel
        Left = 389
        Top = 51
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
        TabOrder = 3
      end
      object NLOLine: TSBSOutlineB
        Left = 2
        Top = 73
        Width = 522
        Height = 221
        OnExpand = NLOLineExpand
        Options = [ooDrawTreeRoot]
        ItemHeight = 16
        ItemSpace = 6
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
          080000000000000100001F2E00001F2E00000001000000000000201F23002322
          26002423270029282C002A292D002B2A2D002C2B2F002D2C30002F2E31003130
          3400323134003534370038373A0039383C003F3E41003F3E4200403F42004140
          430044434600454447004746490047464A0048474B0049484B004C4C4F005251
          5400535255005454560055555700565558005A595C005A5A5D005D5C5F005F5E
          61005F5F6100666668006C6B6E00727173007170740072717400747375007978
          7A007E7C7F00857D8600FF00FF00828183008483850089888A008C8B8D008D8C
          8E008F8E8F00919092009B9B9C009F9FA000A1A1A100A0A0A200A8A7A900ABAB
          AB00ACABAD00B1B0B100B1B0B200B6B5B600B7B6B600C3C3C400C8C7C700CAC9
          CA00CACACB00CCCCCB00CDCCCC00CECFCF00D0CFCF00D1CFCF00D0D0CF00D1D1
          D000D1D1D100D3D3D200D4D4D400D5D4D400D9D8D800DADAD900DBD9DA00DADA
          DA00DEDDDD00DEDEDE00DFDEDE00E1DFE000E1E0E000E7E6E600E8E6E700EBEA
          EA00EEEEEE00EFEFEE00F4F4F400F6F6F600F8F8F800FAFAFA00FCFCFC00FEFE
          FE00FEFFFE00FFFFFF0000000000000000000000000000000000000000000000
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
          00000000000000000000000000000000000000000000000000002C2C2C2C2C2C
          2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2E2E2E2E
          2E2E2E2E2E2E2E2E2C2C2C2E4B464747464646484646464E2E2C2C2E45444336
          0D202F092940444D2E2C2C2E4C4A3E2200000000083949502E2C2C2E4F340E03
          001E250B011732562E2C2C2E551400071C27513D0C0004582E2C2C2E573B001D
          521B0B331200285B2E2C2C2E5A31001A5921113A24002A5D2E2C2C2E5C190006
          30235442100005602E2C2C2E5F41260A0013280F021837632E2C2C2E615F5A1F
          0000000017535E632E2C2C2E6361623F163538153C6161632E2C2C2D63636363
          63636363636363632E2C2C2C2B2B2B2B2B2B2B2B2B2B2B2B2C2C}
        PictureLeaf2.Data = {
          36050000424D3605000000000000360400002800000010000000100000000100
          080000000000000100001F2E00001F2E00000001000000000000823000008A3C
          0E008A3D0F0093481C0093491D0093491E00934A1F00934A2000934B2100A363
          3E00A3654000AC6E4800AC704D00AC725000BC866500C5906F00C5937300C595
          7700C59A7F00CD9C7D00FF00FF008281830084838500CDA18600CDA99300D5AE
          9500D5B49F00DEBBA400DEBEA900DEC1AF00E6C0A600FFDBC000FFDDC400FFE1
          CA00FFE4D000FFE9D800FFEDDF00FFF1E700FFF6EF00FFF9F500FFFDFB00FFFF
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
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000141414141414
          1414141414141414141414141414141414141414141414141414161616161616
          16161616161616161616161F1F1F1F1F1F1F1F1F1F1F1F1F1F16162020202020
          2020202020202020201616212121212121212121212121212116161E000F2222
          0F001E0300000013221616230B000000000B230410230E01231616241B001917
          001B2405112411022416162525090C09092525060000001C25161626261D0000
          1A26260712260A0D261616272727080827272708000000182716162828282828
          2828282828282828281616292929292929292929292929292916152929292929
          2929292929292929291616161616161616161616161616161616}
        ParentFont = False
        PopupMenu = PopupMenu3
        ScrollBars = ssVertical
        ShowValCol = 2
        OnNeedValue = NLOLineNeedValue
        OnUpdateNode = NLOLineUpdateNode
        TreeColor = clNavy
        Data = {3F00}
      end
      object SBSPanel5: TSBSPanel
        Left = 0
        Top = 305
        Width = 550
        Height = 34
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 4
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
          Width = 227
          Height = 20
          Alignment = taRightJustify
          BevelOuter = bvLowered
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          object lblStockCode: Label8
            Left = 8
            Top = 3
            Width = 213
            Height = 14
            AutoSize = False
            Caption = 'Stock Code: '
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TextId = 0
          end
        end
        object OptBtn: TButton
          Left = 445
          Top = 11
          Width = 80
          Height = 21
          Caption = '&Options'
          TabOrder = 2
          OnClick = OptBtnClick
        end
        object YTDCombo: TSBSComboBox
          Tag = 1
          Left = 238
          Top = 10
          Width = 80
          Height = 22
          HelpContext = 553
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
          TabOrder = 3
        end
      end
      object AdvDockPanel: TAdvDockPanel
        Left = 0
        Top = 0
        Width = 550
        Height = 46
        MinimumSize = 3
        LockHeight = False
        Persistence.Location = plRegistry
        Persistence.Enabled = False
        ToolBarStyler = AdvStyler
        UseRunTimeHeight = True
        Version = '2.9.0.0'
        object AdvToolBar: TAdvToolBar
          Left = 3
          Top = 1
          Width = 544
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
          ToolBarStyler = AdvStyler
          ParentOptionPicture = True
          ToolBarIndex = -1
          object AdvToolBarSeparator1: TAdvToolBarSeparator
            Left = 82
            Top = 2
            Width = 10
            Height = 40
            LineColor = clBtnShadow
          end
          object AdvToolBarSeparator2: TAdvToolBarSeparator
            Left = 405
            Top = 2
            Width = 10
            Height = 40
            LineColor = clBtnShadow
          end
          object FullExBtn: TAdvGlowButton
            Left = 2
            Top = 2
            Width = 40
            Height = 40
            Hint = 'Expand All|Opens all folders in the job tree'
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
            TabStop = True
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
            Hint = 'Collapse All|Closes all folders in the job tree to the top-level'
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
            TabStop = True
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
          object Panel7: TPanel
            Left = 415
            Top = 2
            Width = 80
            Height = 38
            BevelOuter = bvNone
            TabOrder = 3
            object ClsI1Btn: TButton
              Left = 0
              Top = 10
              Width = 80
              Height = 21
              Cancel = True
              Caption = '&Close'
              ModalResult = 2
              TabOrder = 0
              OnClick = ClsCP1BtnClick
            end
          end
          object Panel8: TPanel
            Left = 92
            Top = 2
            Width = 313
            Height = 38
            BevelOuter = bvNone
            TabOrder = 2
            object Label86: Label8
              Left = 48
              Top = 14
              Width = 41
              Height = 14
              Alignment = taRightJustify
              AutoSize = False
              Caption = 'GP% : '
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              TextId = 0
            end
            object Label87: Label8
              Left = 155
              Top = 14
              Width = 22
              Height = 14
              Caption = 'Cost'
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              TextId = 0
            end
            object GPLab: TPanel
              Left = 91
              Top = 11
              Width = 54
              Height = 20
              Alignment = taRightJustify
              BevelOuter = bvLowered
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              TabOrder = 1
            end
            object CostLab: TPanel
              Left = 182
              Top = 10
              Width = 124
              Height = 20
              Alignment = taRightJustify
              BevelOuter = bvLowered
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              TabOrder = 2
            end
            object PriceChk: TCheckBoxEx
              Left = -1
              Top = 11
              Width = 45
              Height = 20
              HelpContext = 557
              Alignment = taLeftJustify
              Caption = 'Price'
              Color = clBtnFace
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentColor = False
              ParentFont = False
              TabOrder = 0
              OnClick = YTDChkClick
              Modified = False
              ReadOnly = False
            end
          end
        end
      end
    end
    object SerPage: TTabSheet
      HelpContext = 218
      Caption = 'Serial'
      ImageIndex = -1
      object SNSBox: TScrollBox
        Left = 3
        Top = 3
        Width = 414
        Height = 334
        HorzScrollBar.Position = 220
        VertScrollBar.Tracking = True
        VertScrollBar.Visible = False
        TabOrder = 0
        object SNHedPanel: TSBSPanel
          Left = -218
          Top = 3
          Width = 628
          Height = 19
          BevelInner = bvLowered
          BevelOuter = bvNone
          Color = clWhite
          TabOrder = 0
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumnHeader
          object SNoLab: TSBSPanel
            Left = 2
            Top = 2
            Width = 117
            Height = 14
            BevelOuter = bvNone
            Caption = 'Serial Number'
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
            OnMouseDown = SNoLabMouseDown
            OnMouseMove = SNoLabMouseMove
            OnMouseUp = SNoPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object OutLab: TSBSPanel
            Left = 278
            Top = 2
            Width = 81
            Height = 14
            BevelOuter = bvNone
            Caption = 'Out Doc.'
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
            OnMouseDown = SNoLabMouseDown
            OnMouseMove = SNoLabMouseMove
            OnMouseUp = SNoPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object ODLab: TSBSPanel
            Left = 358
            Top = 2
            Width = 69
            Height = 14
            BevelOuter = bvNone
            Caption = 'Out Date'
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
            OnMouseDown = SNoLabMouseDown
            OnMouseMove = SNoLabMouseMove
            OnMouseUp = SNoPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object InLab: TSBSPanel
            Left = 201
            Top = 2
            Width = 76
            Height = 14
            BevelOuter = bvNone
            Caption = 'In Doc.'
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
            OnMouseDown = SNoLabMouseDown
            OnMouseMove = SNoLabMouseMove
            OnMouseUp = SNoPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object BNoLab: TSBSPanel
            Left = 119
            Top = 2
            Width = 80
            Height = 14
            BevelOuter = bvNone
            Caption = 'Batch No.'
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
            OnMouseDown = SNoLabMouseDown
            OnMouseMove = SNoLabMouseMove
            OnMouseUp = SNoPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object InLocLab: TSBSPanel
            Left = 429
            Top = 2
            Width = 51
            Height = 14
            BevelOuter = bvNone
            Caption = 'In Locn'
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
            OnMouseDown = SNoLabMouseDown
            OnMouseMove = SNoLabMouseMove
            OnMouseUp = SNoPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object OutLocLab: TSBSPanel
            Left = 481
            Top = 2
            Width = 51
            Height = 14
            BevelOuter = bvNone
            Caption = 'Out Locn'
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
            OnMouseDown = SNoLabMouseDown
            OnMouseMove = SNoLabMouseMove
            OnMouseUp = SNoPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object StkCodeLab: TSBSPanel
            Left = 531
            Top = 2
            Width = 94
            Height = 14
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
            TabOrder = 7
            OnMouseDown = SNoLabMouseDown
            OnMouseMove = SNoLabMouseMove
            OnMouseUp = SNoPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
        end
        object OutPanel: TSBSPanel
          Left = 62
          Top = 25
          Width = 77
          Height = 289
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
          OnMouseUp = SNoPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object ODPanel: TSBSPanel
          Left = 141
          Top = 25
          Width = 69
          Height = 289
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
          OnMouseUp = SNoPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object SNoPanel: TSBSPanel
          Left = -218
          Top = 25
          Width = 119
          Height = 289
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
          OnMouseUp = SNoPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object BNoPanel: TSBSPanel
          Left = -97
          Top = 25
          Width = 78
          Height = 289
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
          OnMouseUp = SNoPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object InPanel: TSBSPanel
          Left = -17
          Top = 25
          Width = 77
          Height = 289
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
          OnMouseUp = SNoPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object InLocPanel: TSBSPanel
          Left = 212
          Top = 25
          Width = 50
          Height = 289
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
          OnMouseUp = SNoPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object OutLocPanel: TSBSPanel
          Left = 264
          Top = 25
          Width = 50
          Height = 289
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
          OnMouseUp = SNoPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object StkCodePanel: TSBSPanel
          Left = 316
          Top = 25
          Width = 94
          Height = 289
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
          OnMouseUp = SNoPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
      end
    end
    object BinPage: TTabSheet
      HelpContext = 1458
      Caption = 'Bins'
      ImageIndex = -1
      object MBSBox: TScrollBox
        Left = 3
        Top = 3
        Width = 414
        Height = 335
        HorzScrollBar.Position = 215
        VertScrollBar.Tracking = True
        VertScrollBar.Visible = False
        TabOrder = 0
        object MBHedPanel: TSBSPanel
          Left = -213
          Top = 3
          Width = 655
          Height = 19
          BevelInner = bvLowered
          BevelOuter = bvNone
          Color = clWhite
          TabOrder = 0
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumnHeader
          object MBCLab: TSBSPanel
            Left = 2
            Top = 2
            Width = 80
            Height = 14
            BevelOuter = bvNone
            Caption = 'Bin Code'
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
            OnMouseDown = SNoLabMouseDown
            OnMouseMove = SNoLabMouseMove
            OnMouseUp = SNoPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object MBILab: TSBSPanel
            Left = 255
            Top = 2
            Width = 81
            Height = 14
            BevelOuter = bvNone
            Caption = 'In Doc.'
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
            OnMouseDown = SNoLabMouseDown
            OnMouseMove = SNoLabMouseMove
            OnMouseUp = SNoPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object MBOLab: TSBSPanel
            Left = 335
            Top = 2
            Width = 77
            Height = 14
            BevelOuter = bvNone
            Caption = 'Out Doc.'
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
            OnMouseDown = SNoLabMouseDown
            OnMouseMove = SNoLabMouseMove
            OnMouseUp = SNoPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object MBDLab: TSBSPanel
            Left = 186
            Top = 2
            Width = 76
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
            TabOrder = 3
            OnMouseDown = SNoLabMouseDown
            OnMouseMove = SNoLabMouseMove
            OnMouseUp = SNoPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object MBQLab: TSBSPanel
            Left = 77
            Top = 2
            Width = 107
            Height = 14
            BevelOuter = bvNone
            Caption = 'Qty'
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
            OnMouseDown = SNoLabMouseDown
            OnMouseMove = SNoLabMouseMove
            OnMouseUp = SNoPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object MBLLab: TSBSPanel
            Left = 414
            Top = 2
            Width = 51
            Height = 14
            BevelOuter = bvNone
            Caption = 'Locn'
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
            OnMouseDown = SNoLabMouseDown
            OnMouseMove = SNoLabMouseMove
            OnMouseUp = SNoPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object MBTLab: TSBSPanel
            Left = 466
            Top = 2
            Width = 88
            Height = 14
            BevelOuter = bvNone
            Caption = 'Auto Pick Mode'
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
            OnMouseDown = SNoLabMouseDown
            OnMouseMove = SNoLabMouseMove
            OnMouseUp = SNoPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object MBKLab: TSBSPanel
            Left = 558
            Top = 2
            Width = 94
            Height = 14
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
            TabOrder = 7
            OnMouseDown = SNoLabMouseDown
            OnMouseMove = SNoLabMouseMove
            OnMouseUp = SNoPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
        end
        object MBIPanel: TSBSPanel
          Left = 45
          Top = 25
          Width = 77
          Height = 289
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
          OnMouseUp = SNoPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object MBOPanel: TSBSPanel
          Left = 124
          Top = 25
          Width = 77
          Height = 289
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
          OnMouseUp = SNoPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object MBCPanel: TSBSPanel
          Left = -213
          Top = 25
          Width = 78
          Height = 289
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
          OnMouseUp = SNoPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object MBQPanel: TSBSPanel
          Left = -133
          Top = 25
          Width = 105
          Height = 289
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
          OnMouseUp = SNoPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object MBDPanel: TSBSPanel
          Left = -26
          Top = 25
          Width = 69
          Height = 289
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
          OnMouseUp = SNoPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object MBLPanel: TSBSPanel
          Left = 203
          Top = 25
          Width = 50
          Height = 289
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
          OnMouseUp = SNoPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object MBTPanel: TSBSPanel
          Left = 255
          Top = 25
          Width = 86
          Height = 289
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
          OnMouseUp = SNoPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object MBKPanel: TSBSPanel
          Left = 343
          Top = 25
          Width = 99
          Height = 289
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
          OnMouseUp = SNoPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
      end
    end
  end
  object TCMPanel: TSBSPanel
    Left = 446
    Top = 30
    Width = 106
    Height = 338
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
      Width = 105
      Height = 248
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
        Top = 144
        Width = 80
        Height = 21
        HelpContext = 164
        Caption = '&History'
        TabOrder = 6
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
        Top = 238
        Width = 80
        Height = 21
        HelpContext = 186
        Caption = 'Cop&y'
        TabOrder = 10
        OnClick = CopyCP1BtnClick
      end
      object ViewCP1Btn: TButton
        Left = 2
        Top = 215
        Width = 80
        Height = 21
        HelpContext = 154
        Caption = '&View'
        TabOrder = 9
        OnClick = ViewCP1BtnClick
      end
      object ChkCP1Btn: TButton
        Left = 2
        Top = 261
        Width = 80
        Height = 21
        HelpContext = 187
        Caption = 'Chec&k'
        TabOrder = 11
        OnClick = ChkCP1BtnClick
      end
      object PrnCP1Btn: TButton
        Left = 2
        Top = 192
        Width = 80
        Height = 21
        HelpContext = 163
        Caption = '&Print'
        TabOrder = 8
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
        Top = 168
        Width = 80
        Height = 21
        HelpContext = 90
        Caption = '&Switch To'
        TabOrder = 7
        OnClick = GenCP3BtnClick
      end
      object UCP1Btn: TButton
        Left = 2
        Top = 284
        Width = 80
        Height = 21
        Caption = '&Use'
        TabOrder = 12
        OnClick = UCP1BtnClick
      end
      object LnkCp1Btn: TButton
        Left = 2
        Top = 353
        Width = 80
        Height = 21
        Hint = 
          'Link to additional information|Displays a list of any additional' +
          ' information attached to this Stock Record.'
        HelpContext = 81
        Caption = 'Lin&ks'
        TabOrder = 15
        OnClick = LnkCp1BtnClick
      end
      object NteCP1Btn: TButton
        Left = 2
        Top = 376
        Width = 80
        Height = 21
        Hint = 'Access Note Pad|Displays any notes attached to this record.'
        HelpContext = 88
        Caption = '&Notes'
        TabOrder = 16
        OnClick = NteCP1BtnClick
      end
      object Altdb1Btn: TButton
        Left = 2
        Top = 330
        Width = 80
        Height = 21
        Hint = 
          'Show alternative codes|This option displays a list of alternativ' +
          'e codes available for the highlighted stock item.'
        HelpContext = 596
        Caption = 'Al&t Codes'
        TabOrder = 14
        OnClick = Altdb1BtnClick
      end
      object StkCuBtn1: TSBSButton
        Tag = 1
        Left = 2
        Top = 399
        Width = 80
        Height = 21
        Caption = 'Custom1'
        TabOrder = 17
        OnClick = StkCuBtn1Click
        TextId = 1
      end
      object StkCuBtn2: TSBSButton
        Tag = 2
        Left = 2
        Top = 422
        Width = 80
        Height = 21
        Caption = 'Custom2'
        TabOrder = 18
        OnClick = StkCuBtn1Click
        TextId = 11
      end
      object RetCP1Btn: TButton
        Left = 2
        Top = 307
        Width = 80
        Height = 21
        HelpContext = 1593
        Caption = '&Return'
        TabOrder = 13
        OnClick = RetCP1BtnClick
      end
      object SortViewBtn: TButton
        Left = 2
        Top = 120
        Width = 80
        Height = 21
        HelpContext = 8028
        Caption = 'Sort &View'
        TabOrder = 5
        OnClick = SortViewBtnClick
      end
      object StkCuBtn3: TSBSButton
        Tag = 3
        Left = 2
        Top = 445
        Width = 80
        Height = 21
        Caption = 'Custom3'
        TabOrder = 19
        OnClick = StkCuBtn1Click
        TextId = 0
      end
      object StkCuBtn4: TSBSButton
        Tag = 4
        Left = 2
        Top = 468
        Width = 80
        Height = 21
        Caption = 'Custom4'
        TabOrder = 20
        OnClick = StkCuBtn1Click
        TextId = 0
      end
      object StkCuBtn5: TSBSButton
        Tag = 5
        Left = 2
        Top = 491
        Width = 80
        Height = 21
        Caption = 'Custom5'
        TabOrder = 21
        OnClick = StkCuBtn1Click
        TextId = 0
      end
      object StkCuBtn6: TSBSButton
        Tag = 6
        Left = 2
        Top = 514
        Width = 80
        Height = 21
        Caption = 'Custom6'
        TabOrder = 22
        OnClick = StkCuBtn1Click
        TextId = 0
      end
    end
  end
  object PopupMenu1: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 21
    Top = 412
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
      object N6: TMenuItem
        Caption = '-'
      end
      object SortViewOptions2: TMenuItem
        Caption = 'Sort View &Options'
        OnClick = SortViewOptions1Click
      end
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
      Tag = 1
      Caption = 'Custom Btn 1'
      OnClick = StkCuBtn1Click
    end
    object Custom2: TMenuItem
      Tag = 2
      Caption = 'Custom Btn 2'
      OnClick = StkCuBtn1Click
    end
    object Custom5: TMenuItem
      Tag = 3
      Caption = 'Custom Btn 3'
      OnClick = StkCuBtn1Click
    end
    object Custom6: TMenuItem
      Tag = 4
      Caption = 'Custom Btn 4'
      OnClick = StkCuBtn1Click
    end
    object Custom7: TMenuItem
      Tag = 5
      Caption = 'Custom Btn 5'
      OnClick = StkCuBtn1Click
    end
    object Custom8: TMenuItem
      Tag = 6
      Caption = 'Custom Btn 6'
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
    Left = 91
    Top = 412
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
    Left = 161
    Top = 412
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
      Tag = 1
      Caption = 'Custom Btn 1'
      OnClick = StkCuBtn1Click
    end
    object Custom4: TMenuItem
      Tag = 2
      Caption = 'Custom Btn 2'
      OnClick = StkCuBtn1Click
    end
    object Custom9: TMenuItem
      Tag = 3
      Caption = 'Custom Btn 3'
      OnClick = StkCuBtn1Click
    end
    object Custom10: TMenuItem
      Tag = 4
      Caption = 'Custom Btn 4'
      OnClick = StkCuBtn1Click
    end
    object Custom11: TMenuItem
      Tag = 5
      Caption = 'Custom Btn 5'
      OnClick = StkCuBtn1Click
    end
    object Custom12: TMenuItem
      Tag = 6
      Caption = 'Custom Btn 6'
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
    Left = 231
    Top = 412
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
    Left = 301
    Top = 412
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
    object ReadOnlyView1: TMenuItem
      Caption = 'Serial/Batch Record'
      OnClick = ReadOnlyView1Click
    end
  end
  object PopupMenu6: TPopupMenu
    OnPopup = PopupMenu3Popup
    Left = 371
    Top = 412
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
    Left = 441
    Top = 412
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
    Left = 441
    Top = 465
  end
  object PopupMenu10: TPopupMenu
    Left = 21
    Top = 465
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
    Left = 512
    Top = 412
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
  object AdvStyler: TAdvToolBarOfficeStyler
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
    Left = 514
    Top = 465
  end
  object SortViewPopupMenu: TPopupMenu
    Left = 230
    Top = 465
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
  end
  object PMenu_Notes: TPopupMenu
    Left = 91
    Top = 465
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
    Left = 24
    Top = 533
  end
end
