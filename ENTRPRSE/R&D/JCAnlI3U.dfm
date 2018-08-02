object JCAnlI1: TJCAnlI1
  Left = 399
  Top = 161
  HelpContext = 976
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Job Analysis Code Entry'
  ClientHeight = 287
  ClientWidth = 401
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
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
  PixelsPerInch = 96
  TextHeight = 14
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 401
    Height = 287
    ActivePage = TabSheet1
    Align = alClient
    TabIndex = 0
    TabOrder = 2
    OnChange = PageControl1Change
    OnChanging = PageControl1Changing
    object TabSheet1: TTabSheet
      Caption = 'Main'
      object CISPanel1: TSBSBackGroup
        Left = 2
        Top = 170
        Width = 387
        Height = 53
        Caption = 'Apply uplift to costs'
        TextId = 0
      end
      object Label810: Label8
        Left = 39
        Top = 193
        Width = 37
        Height = 14
        Caption = 'Uplift %'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label811: Label8
        Left = 162
        Top = 193
        Width = 109
        Height = 14
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Uplift Control G/L Code'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object SBSPanel1: TSBSPanel
        Left = 2
        Top = 8
        Width = 387
        Height = 157
        BevelInner = bvRaised
        BevelOuter = bvLowered
        TabOrder = 0
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        object Label84: Label8
          Left = 207
          Top = 44
          Width = 67
          Height = 14
          Caption = 'P&&L G/L Code'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label82: Label8
          Left = 6
          Top = 44
          Width = 68
          Height = 14
          Caption = 'Analysis Type'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label85: Label8
          Left = 204
          Top = 76
          Width = 69
          Height = 14
          Caption = ' WIP G/L Code'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label88: Label8
          Left = 212
          Top = 104
          Width = 46
          Height = 14
          Caption = 'Line Type'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label83: Label8
          Left = 29
          Top = 76
          Width = 44
          Height = 14
          Caption = 'Category'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label87: Label8
          Left = 7
          Top = 104
          Width = 69
          Height = 14
          AutoSize = False
          Caption = 'Revenue Type'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          Visible = False
          TextId = 0
        end
        object Label89: Label8
          Left = 4
          Top = 133
          Width = 73
          Height = 14
          AutoSize = False
          Caption = 'Deduct CIS Tax'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label86: Label8
          Left = 180
          Top = 11
          Width = 25
          Height = 14
          Caption = 'Desc'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label81: Label8
          Left = 7
          Top = 12
          Width = 70
          Height = 14
          Caption = 'Analysis Code'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label812: Label8
          Left = 209
          Top = 135
          Width = 60
          Height = 14
          Caption = 'Payroll Code'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object JATCB: TSBSComboBox
          Tag = 1
          Left = 81
          Top = 38
          Width = 120
          Height = 22
          HelpContext = 1116
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
          OnChange = JATCBChange
          MaxListWidth = 0
        end
        object JAWF: Text8Pt
          Tag = 1
          Left = 282
          Top = 38
          Width = 93
          Height = 22
          HelpContext = 923
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 6
          OnExit = JAWFExit
          TextId = 0
          ViaSBtn = False
        end
        object JAPF: Text8Pt
          Tag = 1
          Left = 282
          Top = 70
          Width = 93
          Height = 22
          HelpContext = 938
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 7
          OnExit = JAWFExit
          TextId = 0
          ViaSBtn = False
        end
        object SRLTF: TSBSComboBox
          Tag = 1
          Left = 281
          Top = 100
          Width = 91
          Height = 22
          HelpContext = 276
          Style = csDropDownList
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ItemHeight = 14
          MaxLength = 40
          ParentFont = False
          TabOrder = 8
          MaxListWidth = 75
          Validate = True
        end
        object JACISF: TSBSComboBox
          Tag = 1
          Left = 81
          Top = 129
          Width = 120
          Height = 22
          HelpContext = 1408
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
          MaxListWidth = 0
        end
        object JARevTF: TSBSComboBox
          Tag = 1
          Left = 81
          Top = 100
          Width = 120
          Height = 22
          HelpContext = 1494
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
          Visible = False
          OnEnter = JARevTFEnter
          MaxListWidth = 0
        end
        object JACCB: TSBSComboBox
          Tag = 1
          Left = 81
          Top = 70
          Width = 120
          Height = 22
          HelpContext = 1566
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
          OnChange = JARevTFEnter
          MaxListWidth = 0
        end
        object JAPCF: Text8Pt
          Tag = 1
          Left = 282
          Top = 129
          Width = 93
          Height = 22
          HelpContext = 1495
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          MaxLength = 5
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 9
          TextId = 0
          ViaSBtn = False
        end
        object CSStkCode: Text8Pt
          Tag = 1
          Left = 82
          Top = 9
          Width = 93
          Height = 22
          HelpContext = 976
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
          TabOrder = 0
          OnExit = CSStkCodeExit
          TextId = 0
          ViaSBtn = False
        end
        object JADF: Text8Pt
          Tag = 1
          Left = 208
          Top = 9
          Width = 167
          Height = 22
          HelpContext = 1108
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          MaxLength = 30
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          TextId = 0
          ViaSBtn = False
        end
      end
      object JAUPCF: TCurrencyEdit
        Tag = 1
        Left = 84
        Top = 190
        Width = 69
        Height = 22
        HelpContext = 1409
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          '0.67%-')
        ParentFont = False
        TabOrder = 1
        WantReturns = False
        WordWrap = False
        AutoSize = False
        BlockNegative = False
        BlankOnZero = False
        DisplayFormat = '###,###,##0.00% ;###,###,##0.00%-'
        ShowCurrency = False
        TextId = 0
        Value = -0.666666
      end
      object JAUCF: Text8Pt
        Tag = 1
        Left = 285
        Top = 190
        Width = 93
        Height = 22
        HelpContext = 1410
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        OnExit = JAUCFExit
        TextId = 0
        ViaSBtn = False
      end
    end
    object TabSheet2: TTabSheet
      HelpContext = 1501
      Caption = 'Deductions'
      ImageIndex = 1
      object SBSBackGroup2: TSBSBackGroup
        Left = 2
        Top = 2
        Width = 387
        Height = 167
        TextId = 0
      end
      object Label814: Label8
        Left = 57
        Top = 95
        Width = 54
        Height = 14
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Deduction  '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label821: Label8
        Left = 192
        Top = 62
        Width = 74
        Height = 14
        Caption = 'Deduction Type'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object JACRCB: TBorCheckEx
        Tag = 1
        Left = 14
        Top = 123
        Width = 170
        Height = 20
        HelpContext = 1546
        Caption = 'Calculate before Retention'
        CheckColor = clWindowText
        Color = clBtnFace
        ParentColor = False
        TabOrder = 4
        TabStop = True
        TextId = 0
      end
      object JAPTCB: TSBSComboBox
        Tag = 1
        Left = 269
        Top = 60
        Width = 110
        Height = 22
        HelpContext = 1543
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
        Text = 'Percentage based'
        OnChange = JAPTCBChange
        Items.Strings = (
          'Percentage based'
          'Value based')
        MaxListWidth = 0
      end
      object JAADCB: TSBSComboBox
        Tag = 1
        Left = 213
        Top = 92
        Width = 167
        Height = 22
        HelpContext = 1545
        Style = csDropDownList
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 0
        ParentFont = False
        TabOrder = 3
        MaxListWidth = 0
      end
      object JADedF: TCurrencyEdit
        Tag = 1
        Left = 114
        Top = 92
        Width = 69
        Height = 22
        HelpContext = 1544
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          '-0.67%')
        ParentFont = False
        TabOrder = 2
        WantReturns = False
        WordWrap = False
        AutoSize = False
        BlockNegative = False
        BlankOnZero = False
        DisplayFormat = ' #0.00%;-#0.00%'
        ShowCurrency = False
        TextId = 0
        Value = -0.666666
      end
      object JARCYCB: TBorCheckEx
        Left = 198
        Top = 122
        Width = 178
        Height = 20
        Caption = 'Preserve and Credit on Retention'
        CheckColor = clWindowText
        Color = clBtnFace
        ParentColor = False
        TabOrder = 5
        TabStop = True
        TextId = 0
        Visible = False
      end
      object JACompCB: TSBSComboBox
        Tag = 1
        Left = 16
        Top = 60
        Width = 167
        Height = 22
        HelpContext = 1542
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
        Text = 'Deduct normally'
        OnChange = JACompCBChange
        Items.Strings = (
          'Deduct normally'
          'Calc. after all other Deductions'
          'Contra Deduction')
        MaxListWidth = 0
      end
    end
    object TabSheet3: TTabSheet
      HelpContext = 1509
      Caption = 'Retentions'
      ImageIndex = 2
      object SBSBackGroup3: TSBSBackGroup
        Left = 2
        Top = 2
        Width = 387
        Height = 167
        TextId = 0
      end
      object Label817: Label8
        Left = 9
        Top = 65
        Width = 71
        Height = 14
        Caption = 'Retention Type'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label818: Label8
        Left = 242
        Top = 65
        Width = 64
        Height = 14
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Retention %  '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label819: Label8
        Left = 9
        Top = 100
        Width = 74
        Height = 14
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Expiry Basis  '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label820: Label8
        Left = 214
        Top = 100
        Width = 92
        Height = 14
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Expiry Interval  '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object JARTCB: TSBSComboBox
        Tag = 1
        Left = 83
        Top = 62
        Width = 103
        Height = 22
        HelpContext = 1496
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
        OnChange = JARTCBChange
        MaxListWidth = 0
      end
      object JARVF: TCurrencyEdit
        Tag = 1
        Left = 307
        Top = 62
        Width = 69
        Height = 22
        HelpContext = 1547
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          '0.67%-')
        ParentFont = False
        TabOrder = 1
        WantReturns = False
        WordWrap = False
        AutoSize = False
        BlockNegative = False
        BlankOnZero = False
        DisplayFormat = '###,###,##0.00% ;###,###,##0.00%-'
        ShowCurrency = False
        TextId = 0
        Value = -0.666666
      end
      object JAECB: TSBSComboBox
        Tag = 1
        Left = 83
        Top = 97
        Width = 124
        Height = 22
        HelpContext = 1548
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
        OnChange = JAECBChange
        Items.Strings = (
          'Months'
          'Years'
          'on Practical Application'
          'on Final Application')
        MaxListWidth = 0
      end
      object JAEIF: TCurrencyEdit
        Tag = 1
        Left = 307
        Top = 97
        Width = 69
        Height = 22
        HelpContext = 1549
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
        Value = 1E-10
      end
    end
  end
  object CanCP1Btn: TButton
    Tag = 1
    Left = 202
    Top = 259
    Width = 80
    Height = 21
    HelpContext = 258
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 1
    OnClick = CanCP1BtnClick
  end
  object OkCP1Btn: TButton
    Tag = 1
    Left = 118
    Top = 259
    Width = 80
    Height = 21
    HelpContext = 257
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 0
    OnClick = CanCP1BtnClick
  end
end
