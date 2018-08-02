object StkWarn: TStkWarn
  Left = 370
  Top = 254
  HelpContext = 719
  ActiveControl = OkCP1Btn
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Warning - Insufficient Stock: '
  ClientHeight = 207
  ClientWidth = 400
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  Scaled = False
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnKeyPress = OkCP1BtnKeyPress
  OnResize = FormResize
  DesignSize = (
    400
    207)
  PixelsPerInch = 96
  TextHeight = 14
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 400
    Height = 207
    ActivePage = StkLevelsPage
    Align = alClient
    TabIndex = 0
    TabOrder = 0
    OnChange = PageControl1Change
    object StkLevelsPage: TTabSheet
      Caption = 'Stock Levels'
      DesignSize = (
        392
        178)
      object Image1: TImage
        Left = 10
        Top = 8
        Width = 53
        Height = 78
        OnDblClick = Id4QOFDblClick
      end
      object Pan1: TSBSBackGroup
        Left = 79
        Top = 1
        Width = 153
        Height = 150
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        TextId = 0
      end
      object Label831: Label8
        Left = 100
        Top = 16
        Width = 38
        Height = 14
        Caption = 'In Stock'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label833: Label8
        Left = 93
        Top = 45
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
      object Label834: Label8
        Left = 83
        Top = 73
        Width = 55
        Height = 14
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Alloc. WOR'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Pan2: TSBSBackGroup
        Left = 236
        Top = 1
        Width = 150
        Height = 150
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        TextId = 0
      end
      object Label835: Label8
        Left = 240
        Top = 45
        Width = 54
        Height = 14
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Need'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label81: Label8
        Left = 249
        Top = 73
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
      object PickLab: Label8
        Left = 259
        Top = 16
        Width = 34
        Height = 14
        Caption = 'Picked '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Visible = False
        TextId = 0
      end
      object Label82: Label8
        Left = 83
        Top = 100
        Width = 55
        Height = 14
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Iss. WOR'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label83: Label8
        Left = 83
        Top = 126
        Width = 55
        Height = 14
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Free Stock'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label84: Label8
        Left = 240
        Top = 101
        Width = 55
        Height = 14
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Pickd WOR'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Id4QOF: TCurrencyEdit
        Tag = 2
        Left = 141
        Top = 15
        Width = 80
        Height = 22
        Hint = 
          'Double click to drill down|Double clicking will drill down to th' +
          'e main record for this field.'
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
        TabOrder = 0
        WantReturns = False
        WordWrap = False
        OnDblClick = Id4QOFDblClick
        AutoSize = False
        BlockNegative = False
        BlankOnZero = False
        DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
        ShowCurrency = False
        TextId = 0
        Value = 1E-10
      end
      object Id4QAF: TCurrencyEdit
        Tag = 2
        Left = 141
        Top = 43
        Width = 80
        Height = 22
        Hint = 
          'Double click to drill down|Double clicking will drill down to th' +
          'e main record for this field.'
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
        TabOrder = 1
        WantReturns = False
        WordWrap = False
        OnDblClick = Id4QOFDblClick
        AutoSize = False
        BlockNegative = False
        BlankOnZero = False
        DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
        ShowCurrency = False
        TextId = 0
        Value = 1E-10
      end
      object Id4QAWF: TCurrencyEdit
        Tag = 2
        Left = 141
        Top = 71
        Width = 80
        Height = 22
        Hint = 
          'Double click to drill down|Double clicking will drill down to th' +
          'e main record for this field.'
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
        TabOrder = 2
        WantReturns = False
        WordWrap = False
        OnDblClick = Id4QOFDblClick
        AutoSize = False
        BlockNegative = False
        BlankOnZero = False
        DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
        ShowCurrency = False
        TextId = 0
        Value = 1E-10
      end
      object Id4QOSF: TCurrencyEdit
        Tag = 2
        Left = 298
        Top = 71
        Width = 80
        Height = 22
        Hint = 
          'Double click to drill down|Double clicking will drill down to th' +
          'e main record for this field.'
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
        TabOrder = 7
        WantReturns = False
        WordWrap = False
        OnDblClick = Id4QOFDblClick
        AutoSize = False
        BlockNegative = False
        BlankOnZero = False
        DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
        ShowCurrency = False
        TextId = 0
        Value = 1E-10
      end
      object Id4QNF: TCurrencyEdit
        Tag = 2
        Left = 298
        Top = 43
        Width = 80
        Height = 22
        Hint = 
          'Double click to drill down|Double clicking will drill down to th' +
          'e main record for this field.'
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
        TabOrder = 6
        WantReturns = False
        WordWrap = False
        OnDblClick = Id4QOFDblClick
        AutoSize = False
        BlockNegative = False
        BlankOnZero = False
        DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
        ShowCurrency = False
        TextId = 0
        Value = 1E-10
      end
      object Id4QPF: TCurrencyEdit
        Tag = 2
        Left = 298
        Top = 15
        Width = 80
        Height = 22
        Hint = 
          'Double click to drill down|Double clicking will drill down to th' +
          'e main record for this field.'
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
        Visible = False
        WantReturns = False
        WordWrap = False
        OnDblClick = Id4QOFDblClick
        AutoSize = False
        BlockNegative = False
        BlankOnZero = False
        DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
        ShowCurrency = False
        TextId = 0
        Value = 1E-10
      end
      object LocBtn: TButton
        Tag = 1
        Left = 222
        Top = 156
        Width = 80
        Height = 21
        Anchors = [akRight, akBottom]
        Caption = '&Location'
        Default = True
        ModalResult = 6
        TabOrder = 9
        Visible = False
        OnClick = LocBtnClick
        OnKeyPress = OkCP1BtnKeyPress
      end
      object Id4QIWF: TCurrencyEdit
        Tag = 2
        Left = 141
        Top = 98
        Width = 80
        Height = 22
        Hint = 
          'Double click to drill down|Double clicking will drill down to th' +
          'e main record for this field.'
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
        OnDblClick = Id4QOFDblClick
        AutoSize = False
        BlockNegative = False
        BlankOnZero = False
        DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
        ShowCurrency = False
        TextId = 0
        Value = 1E-10
      end
      object Id4QFF: TCurrencyEdit
        Tag = 2
        Left = 141
        Top = 124
        Width = 80
        Height = 22
        Hint = 
          'Double click to drill down|Double clicking will drill down to th' +
          'e main record for this field.'
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
        OnDblClick = Id4QOFDblClick
        AutoSize = False
        BlockNegative = False
        BlankOnZero = False
        DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
        ShowCurrency = False
        TextId = 0
        Value = 1E-10
      end
      object Id4QPWF: TCurrencyEdit
        Tag = 2
        Left = 298
        Top = 99
        Width = 80
        Height = 22
        Hint = 
          'Double click to drill down|Double clicking will drill down to th' +
          'e main record for this field.'
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
        TabOrder = 8
        WantReturns = False
        WordWrap = False
        OnDblClick = Id4QOFDblClick
        AutoSize = False
        BlockNegative = False
        BlankOnZero = False
        DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
        ShowCurrency = False
        TextId = 0
        Value = 1E-10
      end
    end
    object AgeingPage: TTabSheet
      Caption = 'Allocation Ageing'
      object Panel1: TPanel
        Left = 2
        Top = 2
        Width = 388
        Height = 119
        BevelInner = bvRaised
        BevelOuter = bvLowered
        TabOrder = 0
        object A1Lab: TLabel
          Left = 76
          Top = 4
          Width = 32
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = '1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object A2Lab: TLabel
          Left = 143
          Top = 4
          Width = 32
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = '2'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object A4Lab: TLabel
          Left = 210
          Top = 4
          Width = 32
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = '3'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object A5Lab: TLabel
          Left = 275
          Top = 4
          Width = 32
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = '4'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object A6Lab: TLabel
          Left = 340
          Top = 4
          Width = 32
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = '5+'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label6: TLabel
          Left = 3
          Top = 29
          Width = 51
          Height = 14
          Caption = 'Allocated'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label7: TLabel
          Left = 4
          Top = 52
          Width = 50
          Height = 14
          Caption = 'On Order'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object AgeLab: TLabel
          Left = 7
          Top = 4
          Width = 46
          Height = 13
          AutoSize = False
          Caption = 'Months'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Bevel1: TBevel
          Left = 0
          Top = 18
          Width = 388
          Height = 2
        end
        object Label1: TLabel
          Left = 8
          Top = 75
          Width = 45
          Height = 14
          Alignment = taRightJustify
          Caption = 'Bld WOR'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object A1F: TCurrencyEdit
          Tag = 2
          Left = 54
          Top = 24
          Width = 65
          Height = 21
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
          TabOrder = 0
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
        object A2F: TCurrencyEdit
          Tag = 2
          Left = 120
          Top = 24
          Width = 65
          Height = 21
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
          TabOrder = 1
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
        object A3F: TCurrencyEdit
          Tag = 2
          Left = 186
          Top = 24
          Width = 65
          Height = 21
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
        object A4F: TCurrencyEdit
          Tag = 2
          Left = 252
          Top = 24
          Width = 65
          Height = 21
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
        object A5F: TCurrencyEdit
          Tag = 2
          Left = 318
          Top = 24
          Width = 65
          Height = 21
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
        object O1F: TCurrencyEdit
          Tag = 2
          Left = 54
          Top = 47
          Width = 65
          Height = 21
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
        object O2F: TCurrencyEdit
          Tag = 2
          Left = 120
          Top = 47
          Width = 65
          Height = 21
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
        object O3F: TCurrencyEdit
          Tag = 2
          Left = 186
          Top = 47
          Width = 65
          Height = 21
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
        object O4F: TCurrencyEdit
          Tag = 2
          Left = 252
          Top = 47
          Width = 65
          Height = 21
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
        object O5F: TCurrencyEdit
          Tag = 2
          Left = 318
          Top = 47
          Width = 65
          Height = 21
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
          TabOrder = 9
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
        object W1F: TCurrencyEdit
          Tag = 2
          Left = 54
          Top = 70
          Width = 65
          Height = 21
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
        object W2F: TCurrencyEdit
          Tag = 2
          Left = 120
          Top = 70
          Width = 65
          Height = 21
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
        object W3F: TCurrencyEdit
          Tag = 2
          Left = 186
          Top = 70
          Width = 65
          Height = 21
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
        object W4F: TCurrencyEdit
          Tag = 2
          Left = 252
          Top = 70
          Width = 65
          Height = 21
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
          TabOrder = 13
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
        object W5F: TCurrencyEdit
          Tag = 2
          Left = 318
          Top = 70
          Width = 65
          Height = 21
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
          TabOrder = 14
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
      end
    end
    object BinPage: TTabSheet
      Caption = 'Bin Availability'
      ImageIndex = 2
      object ODOLine: TSBSOutlineB
        Left = 0
        Top = 0
        Width = 299
        Height = 176
        OnExpand = ODOLineExpand
        Options = []
        ItemHeight = 17
        ItemSpace = 8
        BarColor = clHighlight
        BarTextColor = clHighlightText
        HLBarColor = clBlack
        HLBarTextColor = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Color = clWhite
        TabOrder = 0
        ItemSeparator = '\'
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
          080000000000000100001F2E00001F2E000000010000000000007673B6001D17
          EA001816ED001C16EC00251FED00201AF0002724EB002420EF002620EE002A26
          EB002B2FEC002E2FEC003C36E4003F3BE2003D3FE2003B3DEE002E32F0003D36
          F000373EF000403AE200433FE2003C47EF003742F1003842F1003C48F5005B56
          D3005D58D100645FC300726DC6006763D2006066D7006E6AD200716DD300726E
          D300736ED300736FD300706CD500716DD500726ED5007470D3007672D3004749
          E300454EE3004641EE004944EE004D48EE00504BE400524DEF00524FEF004B51
          E3004951E4004A53E4004F52E400555DE500565EE5005C5EE400525BE800535B
          E800404CF2004D48F1005652F3005556F3005955F0005B57F0005B57F3005A56
          F6005B57F6005C58F0005F5BF0005D59F3005F5CF300605BF000605CF3006360
          E7006560F1006762F1006763F4006D6AF1006D6BF2006D6FF200726DF100716D
          F5006F72F2007773F200767BF6007E7AF300FF00FF00959399008386F7008F8F
          F4008A8EF800918EF5009195F5009295F5009A98F900B3B1FA00C0BFF900C3C3
          FD00D6D5FB00D2D2FE00D8D6FB00D8D7FB00D7D8FC00DAD9FC00DBD9FC00DDDC
          FC00DEDDFC00E4E3FD00ECEBFD00EEEDFD00EDECFE00F2F1FE00F3F2FE00F6F6
          FE00F8F7FF00FFFFFF0000000000000000000000000000000000000000000000
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
          0000000000000000000000000000000000000000000000000000565656565656
          5656565656565656565656565656565656565656565656565656565657575757
          5757575757575757565656571B0C13140E3437323536381E5756565719050802
          3D61635A163A1839575656571A040130687373715D153A36575656571A032F67
          73737373715C1735575656571D3B60736F72736D73705433575656571F51646C
          5B627359666E582A575656572140534D2C65734F0F5212315756565721453F3E
          4B6A734E0B0A102957565657214544434A6973500906070D5756565721454443
          476B73552D2B112E57565657254245453C5E5F4C484641495756565700242122
          202728202123261C575656565757575757575757575757575656}
        PictureLeaf4.Data = {
          36050000424D3605000000000000360400002800000010000000100000000100
          080000000000000100001F2E00001F2E00000001000000000000201F23002322
          26002524280027262A002B2A2E002C2B2F002C2C2F002D2C30002E2D31002F2E
          310031303400333235003433360035343700353538003635390039383C003B3A
          3D003C3B3E003E3D40003F3E4100444346004746490048474A0049484B004B4A
          4D004E4D50004F4E510052515400535255005353560054535600565558005756
          590057565A0058575A0059585B005A595C005C5B5E0067666900676769006867
          6A006B6A6C006C6C6E006D6C6F0073727500777678007C7B7D007D7C7E00807F
          8100857D8600FF00FF008281830084838500848486008585870086858700898A
          8B008C8B8D0093929300959496009F9E9F00A4A3A300A4A3A400A7A6A800AAA9
          AB00B2B1B200B3B3B400B8B7B900B9B9BA00C3C3C300C9C8C900CCCBCB00CECF
          CF00CFCFCF00D0CFCF00D1CFCF00D0D0CF00D3D2D200D3D3D200D3D3D300D4D4
          D400D5D4D400D6D6D600D9D8D800DADAD900DBD9DA00DDDCDD00E1DFE000E1E0
          E000E7E6E600E8E6E700E9E7E700EDEDED00EEEDEE00EEEEEE00EFEFEE00F0F0
          F000F1F0F000F4F4F400F5F7F500F6F6F600F7F6F600FAFAFA00FBFAFA00FBFB
          FB00FCFCFC00FEFEFE00FFFFFF00000000000000000000000000000000000000
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
          0000000000000000000000000000000000000000000000000000333333333333
          3333333333333333333333333333333333333333333333333333333335353535
          3535353535353535333333354F4B4C4C4B4B4B4D4B4B4B543533333549483E13
          082F3F1400183D5235333335514A3A06071524020A0517563533333555534223
          1927051A37150059353333355857452E303C1F11250B135B353333355A47280A
          121C3B1805214160353333355F1E04162C0D1B40464E5C653533333563082936
          2A2009446161626A3533333567012239381D05436664656C353333356B310E0C
          260F2B506869676C353333356C5D2D1003215E6A6B6B6B6C353333346C6C6C6C
          6C6C6C6C6C6C6C6C353333333232323232323232323232323333}
        PictureLeaf5.Data = {
          36050000424D3605000000000000360400002800000010000000100000000100
          080000000000000100001F2E00001F2E00000001000000000000BA730800C485
          2900C48B3600BE884500B1835000BD926600C6914500C7975400CA9A5400D6A5
          5B00D7A96500D9AF6F00D9AF7000DAB17300DBB37700DBB37800DBB47A00DBB5
          7C00DCB57D00DCB67D00DCB67F00DCB77F00352DED00FF00FF008E7DCC008E7E
          CF00B48F8000D1AC8C00CDB08F00DCB78000DCB88100DCB88200DDB98300DDB4
          9800E3BD8400CCB5B900E4C08A00E7C38E00E6C59400E7C89B00EACA9800E8C9
          9C00E8C99D00EBCC9E00EACFA800EAD0AA00EBD1AC00F1D6AD00F1D7AF00EBD4
          B200ECD5B500ECD6B500ECD6B600ECD7B900ECD8B900ECD8BA00EDD9BB00EDDA
          BD00F2D9B300A693C400AA9CD700B6A8D5009288E400948EEF00ADA7EC00BAB2
          E900AEAAF400C1AFC900C5AFC800CEBAC500C5B8DB00D2C5DA00F2DFC300F5E0
          C200F2E1C700F3E1C800F3E4CF00F6E5CD00F4E4CE00F7EAD700F9EAD600F9EA
          D700F7EAD900F9EAD800F9EDDD00FAEEDD00FAEEDE00D4CBE700FAEFE000FAF0
          E200FBF2E600FAF2E700FCF3E700FCF5EB00FCF5EC00FCF6EE00FDF7F000FDF8
          F100FDF8F200FDF9F300FDF9F400FDFAF600FEFBF800FEFCF800FEFCF900FEFC
          FA00FEFCFB00FEFDFB00FEFDFC00FFFEFD00FFFFFE0000000000000000000000
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
          0000000000000000000000000000000000000000000000000000171717171717
          1717171717171717171717171717171717171717171717171717171701010101
          010101010101010117171701252F2F545C58534D492F2F28011717013B183B48
          100E0D0B27220909011717013A2F2F59605E5A56502F2F30011717013C193B4A
          1412100E2C22090A011717014743234F383533314B28242A0117170157464552
          393836344E2B292D01171701403E3D4C1E1D151332260C0F01171701645D5563
          6D6A676563515C6201171701423F415B201F1E1D372E1115011717016C666168
          6E6D6C69675F656B01171701000000000000020706081A030117170121212121
          21211B04051C1644011717170101010101010101010101011717}
        ParentFont = False
        ScrollBars = ssVertical
        ShowValCol = 0
        TreeColor = clGray
        Data = {9F01}
      end
    end
    object EquivPage: TTabSheet
      Caption = 'Equivalents'
      ImageIndex = 3
      DesignSize = (
        392
        178)
      object ODOLine2: TSBSOutlineB
        Left = 0
        Top = 0
        Width = 299
        Height = 176
        OnExpand = ODOLine2Expand
        Options = []
        ItemHeight = 17
        ItemSpace = 8
        BarColor = clHighlight
        BarTextColor = clHighlightText
        HLBarColor = clBlack
        HLBarTextColor = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Color = clWhite
        TabOrder = 0
        OnClick = ODOLine2Click
        ItemSeparator = '\'
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
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00DDDDDDDDDDDD
          DDDDD888888888888DDDD8888888888880DDD8888788888880DDD8887F888888
          80DDD807FFFFFF7880DDD8807F0000F880DDD888078880F880DDD888808880F8
          80DDD888888880F880DDD8888888808880DDD8888888888880DDD88888888888
          80DDDD000000000000DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD}
        PictureLeaf4.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          0400000000008000000000000000000000001000000010000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00222222022222
          2222222200B0022222222220B3B3B022222222203BBB30022222220BBB0BBB00
          222222203BBB308022222220B3B3B0802222222200B007770222222220088707
          802222222220077700222222220700808022222220FFF0000222222227F0F702
          2222222220FFF002222222222207080222222222222000222222}
        PictureLeaf5.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          0400000000008000000000000000000000001000000010000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00666666666666
          6666666666666666666666666666666666666FFFF8FFFF8FFFF66F55F8F08F8F
          00F66FFFF8FFFF8FFFF66F55F8F88F8F08F66FFFF8FFFF8FFFF66F55F8F80F8F
          00F66FFFF8FFFF8FFFF66F888888888888866FFFF8FFFF8FFFF66F11F8F44FFF
          44F66FFFFFFFFFFFFFF666666666666666666666666666666666}
        ParentFont = False
        ScrollBars = ssVertical
        ShowValCol = 0
        TreeColor = clGray
        Data = {9F01}
      end
      object FreezeBtn: TButton
        Tag = 1
        Left = 305
        Top = 129
        Width = 80
        Height = 21
        Anchors = [akRight, akBottom]
        Cancel = True
        Caption = '&Freeze'
        Default = True
        TabOrder = 1
        Visible = False
        OnClick = FreezeBtnClick
      end
    end
  end
  object OkCP1Btn: TButton
    Tag = 1
    Left = 309
    Top = 181
    Width = 80
    Height = 21
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = '&OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
    OnClick = OkCP1BtnClick
    OnKeyPress = OkCP1BtnKeyPress
  end
end
