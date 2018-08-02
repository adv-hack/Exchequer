object RecepForm: TRecepForm
  Left = 381
  Top = 183
  Width = 648
  Height = 393
  HelpContext = 236
  VertScrollBar.Tracking = True
  Caption = 'Payment/Receipt'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  FormStyle = fsStayOnTop
  KeyPreview = True
  OldCreateOrder = True
  Position = poDefault
  Scaled = False
  ShowHint = True
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
    Left = 1
    Top = 0
    Width = 627
    Height = 353
    ActivePage = RecepPage
    TabIndex = 0
    TabOrder = 0
    object RecepPage: TTabSheet
      Caption = 'Receipt'
      object R1SBox: TScrollBox
        Left = 2
        Top = 118
        Width = 493
        Height = 184
        HelpContext = 405
        VertScrollBar.Tracking = True
        VertScrollBar.Visible = False
        TabOrder = 0
        object R1HedPanel: TSBSPanel
          Left = 2
          Top = 2
          Width = 509
          Height = 17
          BevelInner = bvLowered
          BevelOuter = bvNone
          TabOrder = 0
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumnHeader
          object R1NomLab: TSBSPanel
            Left = 1
            Top = 3
            Width = 53
            Height = 13
            BevelOuter = bvNone
            Caption = 'G/L Code'
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
          object R1NomD2Lab: TSBSPanel
            Left = 54
            Top = 3
            Width = 102
            Height = 13
            BevelOuter = bvNone
            Caption = 'G/L Description'
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
          object R1ChqLab: TSBSPanel
            Left = 156
            Top = 3
            Width = 86
            Height = 13
            BevelOuter = bvNone
            Caption = 'Cheque No.'
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
          object R1PayLab: TSBSPanel
            Left = 245
            Top = 3
            Width = 86
            Height = 13
            BevelOuter = bvNone
            Caption = 'Amount'
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 3
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object R1BaseLab: TSBSPanel
            Left = 334
            Top = 3
            Width = 87
            Height = 13
            BevelOuter = bvNone
            Caption = 'Base Equiv.'
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 4
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object R1PayInLab: TSBSPanel
            Left = 422
            Top = 3
            Width = 85
            Height = 13
            BevelOuter = bvNone
            Caption = 'Pay-In Ref'
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 5
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
        end
        object R1PayPanel: TSBSPanel
          Left = 246
          Top = 22
          Width = 88
          Height = 140
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
        object R1NomPanel: TSBSPanel
          Left = 3
          Top = 22
          Width = 54
          Height = 140
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
        object R1NomD2Panel: TSBSPanel
          Left = 57
          Top = 22
          Width = 100
          Height = 140
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
        object R1BasePanel: TSBSPanel
          Left = 335
          Top = 22
          Width = 89
          Height = 140
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
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object R1ChqPanel: TSBSPanel
          Left = 158
          Top = 22
          Width = 87
          Height = 140
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
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object R1PayInPanel: TSBSPanel
          Left = 425
          Top = 22
          Width = 87
          Height = 140
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
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
      end
      object R1ListBtnPanel: TSBSPanel
        Left = 497
        Top = 141
        Width = 18
        Height = 141
        BevelOuter = bvLowered
        PopupMenu = PopupMenu1
        TabOrder = 1
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
      end
      object SBSPanel1: TSBSPanel
        Left = 0
        Top = 302
        Width = 619
        Height = 22
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 2
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        object SBSPanel4: TSBSPanel
          Left = 274
          Top = 5
          Width = 179
          Height = 17
          HelpContext = 407
          BevelOuter = bvLowered
          ParentColor = True
          TabOrder = 0
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          object ReqdTit: Label8
            Left = 3
            Top = 2
            Width = 85
            Height = 14
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'Base Equiv Reqd:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TextId = 0
          end
          object ReqdLab: Label8
            Left = 91
            Top = 2
            Width = 86
            Height = 14
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
        object VarPanel: TSBSPanel
          Left = 121
          Top = 5
          Width = 150
          Height = 17
          BevelOuter = bvLowered
          ParentColor = True
          TabOrder = 1
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          object VarTit: Label8
            Left = 3
            Top = 2
            Width = 46
            Height = 14
            Caption = 'Variance:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TextId = 0
          end
          object VarLab: Label8
            Left = 52
            Top = 2
            Width = 95
            Height = 14
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
        object CCPanel: TSBSPanel
          Left = 0
          Top = 5
          Width = 118
          Height = 17
          HelpContext = 414
          BevelOuter = bvLowered
          ParentColor = True
          TabOrder = 2
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          object CCTit: Label8
            Left = 3
            Top = 2
            Width = 17
            Height = 14
            Caption = 'CC:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TextId = 0
          end
          object DepTit: Label8
            Left = 57
            Top = 2
            Width = 22
            Height = 14
            Caption = 'Dep:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TextId = 0
          end
          object CCLab: Label8
            Left = 23
            Top = 2
            Width = 30
            Height = 14
            AutoSize = False
            Caption = 'AAA'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TextId = 0
          end
          object DepLab: Label8
            Left = 81
            Top = 2
            Width = 30
            Height = 14
            AutoSize = False
            Caption = 'AAA'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TextId = 0
          end
        end
        object DiscPanel: TSBSPanel
          Left = 456
          Top = 5
          Width = 150
          Height = 17
          BevelOuter = bvLowered
          ParentColor = True
          TabOrder = 3
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          object Label81: Label8
            Left = 3
            Top = 2
            Width = 48
            Height = 14
            Caption = 'Discount :'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TextId = 0
          end
          object DiscLab: Label8
            Left = 52
            Top = 2
            Width = 95
            Height = 14
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
  end
  object R1BtnPanel: TSBSPanel
    Left = 521
    Top = 129
    Width = 101
    Height = 197
    BevelOuter = bvNone
    BorderStyle = bsSingle
    PopupMenu = PopupMenu1
    TabOrder = 1
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
    object R1StatLab: Label8
      Left = 3
      Top = 3
      Width = 95
      Height = 49
      Alignment = taCenter
      AutoSize = False
      Caption = 'R1StatLab'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object R1BSBox: TScrollBox
      Left = 0
      Top = 35
      Width = 98
      Height = 156
      HorzScrollBar.Tracking = True
      HorzScrollBar.Visible = False
      VertScrollBar.Tracking = True
      BorderStyle = bsNone
      PopupMenu = PopupMenu1
      TabOrder = 0
      object btnViewLine: TButton
        Left = 2
        Top = 37
        Width = 80
        Height = 21
        Hint = 
          'Add new line|Choosing this option allows you to Add a new line w' +
          'hich will be placed at the end of the receipt/payment.'
        HelpContext = 260
        Caption = '&View'
        TabOrder = 0
        OnClick = btnViewLineClick
      end
      object ClsR1Btn: TButton
        Left = 2
        Top = 4
        Width = 80
        Height = 21
        HelpContext = 259
        Cancel = True
        Caption = 'C&lose'
        ModalResult = 2
        TabOrder = 1
        OnClick = ClsR1BtnClick
      end
    end
  end
  object R1FPanel: TSBSPanel
    Left = 8
    Top = 24
    Width = 374
    Height = 112
    BevelInner = bvRaised
    BevelOuter = bvLowered
    PopupMenu = PopupMenu1
    TabOrder = 2
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
    object Label817: Label8
      Left = 11
      Top = 11
      Width = 38
      Height = 14
      Caption = 'Our Ref'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Label84: Label8
      Left = 8
      Top = 62
      Width = 41
      Height = 14
      Caption = 'Date/Per'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Label87: Label8
      Left = 5
      Top = 36
      Width = 43
      Height = 14
      Caption = 'Your Ref'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object R1CurrLab: Label8
      Left = 216
      Top = 10
      Width = 45
      Height = 14
      Caption = 'Currency'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Label82: Label8
      Left = 224
      Top = 62
      Width = 37
      Height = 14
      Caption = 'Amount'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object R1XRateLab: Label8
      Left = 209
      Top = 36
      Width = 52
      Height = 14
      Caption = 'Exch. Rate'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object R1Base2Lab: Label8
      Left = 204
      Top = 89
      Width = 56
      Height = 14
      Caption = 'Base Equiv.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object R1OrefF: Text8Pt
      Left = 51
      Top = 6
      Width = 74
      Height = 22
      HelpContext = 142
      TabStop = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentColor = True
      ParentFont = False
      ReadOnly = True
      TabOrder = 9
      Text = 'SRC000080'
      TextId = 0
      ViaSBtn = False
    end
    object R1OpoF: Text8Pt
      Left = 128
      Top = 6
      Width = 64
      Height = 22
      HelpContext = 241
      TabStop = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentColor = True
      ParentFont = False
      ReadOnly = True
      TabOrder = 8
      Text = 'Sally'
      TextId = 0
      ViaSBtn = False
    end
    object R1TDateF: TEditDate
      Tag = 1
      Left = 50
      Top = 57
      Width = 74
      Height = 22
      HelpContext = 143
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
    end
    object R1TPerF: TEditPeriod
      Tag = 1
      Left = 127
      Top = 57
      Width = 65
      Height = 22
      HelpContext = 239
      AutoSelect = False
      Color = clWhite
      EditMask = '00/0000;0;'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      MaxLength = 7
      ParentFont = False
      ReadOnly = True
      TabOrder = 2
      Text = 'mmyyyy'
      Placement = cpAbove
      EPeriod = 1
      EYear = 1996
      ViewMask = '000/0000;0;'
      OnShowPeriod = R1TPerFShowPeriod
    end
    object R1YrefF: Text8Pt
      Tag = 1
      Left = 50
      Top = 31
      Width = 142
      Height = 22
      HelpContext = 240
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
    object R1RValF: TCurrencyEdit
      Tag = 1
      Left = 263
      Top = 58
      Width = 100
      Height = 22
      HelpContext = 402
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
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
      BlockNegative = False
      BlankOnZero = False
      DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
      ShowCurrency = False
      TextId = 0
      Value = 1E-10
    end
    object R1XRateF: TCurrencyEdit
      Tag = 1
      Left = 263
      Top = 32
      Width = 100
      Height = 22
      HelpContext = 403
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        '0.000000 ')
      ParentFont = False
      ReadOnly = True
      TabOrder = 5
      WantReturns = False
      WordWrap = False
      AutoSize = False
      BlockNegative = False
      BlankOnZero = False
      DisplayFormat = '###,###,##0.000000 ;###,###,##0.000000-'
      DecPlaces = 6
      ShowCurrency = False
      TextId = 0
      Value = 1E-10
    end
    object R1CurrF: TSBSComboBox
      Tag = 1
      Left = 263
      Top = 6
      Width = 100
      Height = 22
      HelpContext = 242
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ItemHeight = 14
      MaxLength = 3
      ParentFont = False
      TabOrder = 4
      ExtendedList = True
      MaxListWidth = 120
      ReadOnly = True
      Validate = True
    end
    object R1BaseF: TCurrencyEdit
      Left = 263
      Top = 84
      Width = 100
      Height = 22
      HelpContext = 404
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        '0.00 ')
      ParentColor = True
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
    object TransExtForm1: TSBSExtendedForm
      Left = 4
      Top = 78
      Width = 199
      Height = 30
      HelpContext = 1169
      HorzScrollBar.Visible = False
      VertScrollBar.Visible = False
      AutoScroll = False
      BorderStyle = bsNone
      TabOrder = 3
      ArrowPos = alTop
      ArrowX = 92
      ArrowY = 6
      OrigHeight = 30
      OrigWidth = 199
      ExpandedWidth = 302
      ExpandedHeight = 163
      OrigTabOrder = 3
      ShowHorzSB = True
      ShowVertSB = True
      OrigParent = R1FPanel
      NewParent = Owner
      FocusFirst = R1AccF
      FocusLast = THUD4F
      TabPrev = R1TPerF
      TabNext = R1CurrF
      object UDF1L: Label8
        Left = 7
        Top = 41
        Width = 57
        Height = 14
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
      object UDF3L: Label8
        Left = 7
        Top = 65
        Width = 57
        Height = 14
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
      object UDF2L: Label8
        Left = 151
        Top = 41
        Width = 57
        Height = 14
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
      object UDF4L: Label8
        Left = 151
        Top = 65
        Width = 58
        Height = 14
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
      object Label88: Label8
        Left = 1
        Top = 11
        Width = 43
        Height = 14
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'AC/Ctrl '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object UDF5L: Label8
        Left = 7
        Top = 89
        Width = 57
        Height = 14
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
      object UDF6L: Label8
        Left = 151
        Top = 89
        Width = 57
        Height = 14
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
      object UDF7L: Label8
        Left = 7
        Top = 113
        Width = 57
        Height = 14
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
      object UDF9L: Label8
        Left = 7
        Top = 137
        Width = 57
        Height = 14
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
      object UDF8L: Label8
        Left = 151
        Top = 113
        Width = 57
        Height = 14
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
      object UDF10L: Label8
        Left = 151
        Top = 137
        Width = 57
        Height = 14
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
      object THUD1F: Text8Pt
        Tag = 1
        Left = 66
        Top = 37
        Width = 82
        Height = 22
        HelpContext = 283
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
        TextId = 0
        ViaSBtn = False
      end
      object THUD3F: Text8Pt
        Tag = 1
        Left = 66
        Top = 61
        Width = 82
        Height = 22
        HelpContext = 283
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
        TextId = 0
        ViaSBtn = False
      end
      object THUD4F: Text8Pt
        Tag = 1
        Left = 211
        Top = 61
        Width = 82
        Height = 22
        HelpContext = 283
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
        TextId = 0
        ViaSBtn = False
      end
      object THUD2F: Text8Pt
        Tag = 1
        Left = 211
        Top = 37
        Width = 82
        Height = 22
        HelpContext = 283
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
        TextId = 0
        ViaSBtn = False
      end
      object R1AccF: Text8Pt
        Tag = 1
        Left = 45
        Top = 8
        Width = 74
        Height = 22
        Hint = 
          'Double click to drill down|Double clicking or using the down but' +
          'ton will drill down to the record for this field. The up button ' +
          'will search for the nearest match.'
        HelpContext = 238
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
        ShowHilight = True
      end
      object DMDCNomF: Text8Pt
        Tag = 1
        Left = 122
        Top = 8
        Width = 65
        Height = 22
        HelpContext = 551
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 10
        ParentFont = False
        ReadOnly = True
        TabOrder = 1
        TextId = 0
        ViaSBtn = False
      end
      object THUD5F: Text8Pt
        Tag = 1
        Left = 66
        Top = 85
        Width = 82
        Height = 22
        HelpContext = 283
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
        TextId = 0
        ViaSBtn = False
      end
      object THUD7F: Text8Pt
        Tag = 1
        Left = 66
        Top = 109
        Width = 82
        Height = 22
        HelpContext = 283
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
        TextId = 0
        ViaSBtn = False
      end
      object THUD9F: Text8Pt
        Tag = 1
        Left = 66
        Top = 133
        Width = 82
        Height = 22
        HelpContext = 283
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
      end
      object THUD6F: Text8Pt
        Tag = 1
        Left = 211
        Top = 85
        Width = 82
        Height = 22
        HelpContext = 283
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
        TextId = 0
        ViaSBtn = False
      end
      object THUD8F: Text8Pt
        Tag = 1
        Left = 211
        Top = 109
        Width = 82
        Height = 22
        HelpContext = 283
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
      end
      object THUD10F: Text8Pt
        Tag = 1
        Left = 211
        Top = 133
        Width = 82
        Height = 22
        HelpContext = 283
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
      end
    end
  end
  object SBSPanel2: TSBSPanel
    Left = 386
    Top = 24
    Width = 235
    Height = 101
    BevelInner = bvLowered
    BevelOuter = bvLowered
    Color = clPurple
    TabOrder = 3
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
    object R1AddrF: TMemo
      Left = 2
      Top = 2
      Width = 231
      Height = 97
      HelpContext = 230
      Align = alClient
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      PopupMenu = PopupMenu1
      ReadOnly = True
      TabOrder = 0
      WantReturns = False
    end
  end
  object PopupMenu1: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 544
    Top = 47
    object Add1: TMenuItem
      Caption = '&Add'
      Hint = 
        'Choosing this option allows you to Add a new line which will be ' +
        'placed at the end of the receipt/payment.'
    end
    object Edit1: TMenuItem
      Tag = 1
      Caption = '&Edit'
      Hint = 
        'Choosing this option allows you to edit the currently highlighte' +
        'd line.'
      Visible = False
    end
    object Delete1: TMenuItem
      Caption = '&Delete'
      Hint = 
        'Choosing this option allows you to delete the currently highligh' +
        'ted line.'
    end
    object Insert1: TMenuItem
      Caption = '&Insert'
      Hint = 
        'Choosing this option allows you to Insert a new line before the ' +
        'currently highlighted line.'
    end
    object Switch1: TMenuItem
      Caption = '&Switch'
      Hint = 
        'Switches the display of the notepad between dated notepad, & gen' +
        'eral notepad.'
    end
    object Defaults1: TMenuItem
      Caption = 'Defa&ults'
      Hint = 
        'Allows a default bank account to be used with all Receipt/Paymen' +
        'ts'
    end
    object Cleared1: TMenuItem
      Caption = '&Status'
      Hint = 
        'Alternates the last column to display the bank cleared status/pa' +
        'y-In reference of the currently highlighted line.'
    end
    object Check1: TMenuItem
      Caption = 'Chec&k'
    end
    object Links1: TMenuItem
      Caption = 'Lin&ks'
      Hint = 
        'Displays a list of any additional information attached to this t' +
        'ransaction.'
    end
    object Pay1: TMenuItem
      Caption = '&Pay Details'
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
    object N3: TMenuItem
      Caption = '-'
      Enabled = False
      Visible = False
    end
  end
end
