object Form_PageOptions: TForm_PageOptions
  Left = 415
  Top = 189
  HelpContext = 3500
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Form Options'
  ClientHeight = 347
  ClientWidth = 494
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  Position = poOwnerFormCenter
  Scaled = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  DesignSize = (
    494
    347)
  PixelsPerInch = 96
  TextHeight = 14
  object Button_Ok: TButton
    Left = 409
    Top = 27
    Width = 80
    Height = 21
    Anchors = [akTop, akRight]
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 1
    OnClick = Button_OkClick
  end
  object Button_Cancel: TButton
    Left = 409
    Top = 55
    Width = 80
    Height = 21
    Anchors = [akTop, akRight]
    Cancel = True
    Caption = '&Cancel'
    TabOrder = 2
    OnClick = Button_CancelClick
  end
  object PageControl1: TPageControl
    Left = 5
    Top = 5
    Width = 397
    Height = 338
    ActivePage = TabSh_Printer
    Anchors = [akLeft, akTop, akRight, akBottom]
    MultiLine = True
    TabIndex = 3
    TabOrder = 0
    OnChange = PageControl1Change
    object TabSh_General: TTabSheet
      Caption = 'General'
      object SBSBackGroup14: TSBSBackGroup
        Left = 2
        Top = 0
        Width = 383
        Height = 122
        TextId = 0
      end
      object Label82: Label8
        Left = 11
        Top = 16
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
      object Label83: Label8
        Tag = 1
        Left = 8
        Top = 96
        Width = 59
        Height = 14
        Caption = 'Continuation'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object SBSBackGroup12: TSBSBackGroup
        Tag = 2
        Left = 2
        Top = 175
        Width = 383
        Height = 42
        TextId = 0
      end
      object Label838: Label8
        Tag = 2
        Left = 26
        Top = 190
        Width = 40
        Height = 14
        Caption = 'Purpose'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object SBSPanel4: TSBSPanel
        Left = 2
        Top = 127
        Width = 383
        Height = 48
        BevelInner = bvRaised
        BevelOuter = bvLowered
        Enabled = False
        TabOrder = 0
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        object Label_Font: Label8
          Left = 7
          Top = 6
          Width = 279
          Height = 35
          AutoSize = False
          Caption = 'Default Font'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
      end
      object Memo_Description: TMemo
        Left = 71
        Top = 13
        Width = 307
        Height = 74
        TabOrder = 1
      end
      object Text_Continue: Text8Pt
        Tag = 1
        Left = 71
        Top = 92
        Width = 144
        Height = 22
        TabStop = False
        CharCase = ecUpperCase
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 8
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 3
        OnDblClick = Button_SelectContinueClick
        TextId = 0
        ViaSBtn = False
      end
      object Button_SelectContinue: TButton
        Tag = 1
        Left = 223
        Top = 92
        Width = 80
        Height = 22
        Caption = '&Select'
        TabOrder = 4
        OnClick = Button_SelectContinueClick
      end
      object Button_Font: TButton
        Left = 299
        Top = 132
        Width = 80
        Height = 21
        Caption = '&Font'
        TabOrder = 5
        OnClick = Button_FontClick
      end
      object List_Purpose: TSBSComboBox
        Tag = 2
        Left = 71
        Top = 187
        Width = 232
        Height = 22
        Style = csDropDownList
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 0
        ParentFont = False
        TabOrder = 2
        OnClick = List_PurposeClick
        MaxListWidth = 0
      end
    end
    object TabSh_Size: TTabSheet
      Caption = 'Paper'
      object SBSBackGroup6: TSBSBackGroup
        Left = 282
        Top = -1
        Width = 103
        Height = 70
        Caption = 'Paper Size (mm)'
        TextId = 0
      end
      object Label84: Label8
        Left = 290
        Top = 18
        Width = 40
        Height = 14
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Height'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label85: Label8
        Left = 290
        Top = 43
        Width = 40
        Height = 14
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Width'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object SBSBackGroup7: TSBSBackGroup
        Tag = 1
        Left = 282
        Top = 71
        Width = 103
        Height = 120
        Caption = 'Margins (mm)'
        TextId = 0
      end
      object Label811: Label8
        Tag = 1
        Left = 291
        Top = 91
        Width = 40
        Height = 14
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Top'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label810: Label8
        Tag = 1
        Left = 291
        Top = 116
        Width = 40
        Height = 14
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Bottom'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label813: Label8
        Tag = 1
        Left = 291
        Top = 165
        Width = 40
        Height = 14
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Right'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label812: Label8
        Tag = 1
        Left = 291
        Top = 140
        Width = 40
        Height = 14
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Left'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Image_Paper: TImage
        Left = 0
        Top = 0
        Width = 276
        Height = 306
      end
      object SBSGrp_Orientation: TSBSGroup
        Left = 282
        Top = 194
        Width = 103
        Height = 58
        Caption = 'Paper Orientation'
        Enabled = False
        TabOrder = 6
        AllowReSize = False
        IsGroupBox = True
        TextId = 0
      end
      object Button_LoadPaper: TButton
        Left = 283
        Top = 257
        Width = 101
        Height = 21
        Caption = '&Load Paper'
        TabOrder = 9
        OnClick = Button_LoadPaperClick
      end
      object Button_PrintTest: TButton
        Tag = 1
        Left = 283
        Top = 284
        Width = 101
        Height = 21
        Caption = '&Print Test'
        TabOrder = 10
        OnClick = Button_PrintTestClick
      end
      object BorRadio_Portrait: TBorRadio
        Left = 292
        Top = 208
        Width = 58
        Height = 20
        Align = alRight
        Caption = 'Portrait'
        Checked = True
        TabOrder = 7
        TabStop = True
        TextId = 0
        OnClick = BorRadio_PortraitClick
      end
      object BorRadio_Landscape: TBorRadio
        Left = 292
        Top = 227
        Width = 77
        Height = 20
        Align = alRight
        Caption = 'Landscape'
        TabOrder = 8
        TextId = 0
        OnClick = BorRadio_PortraitClick
      end
      object Ccy_Height: TCurrencyEdit
        Left = 334
        Top = 15
        Width = 41
        Height = 22
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          '0 ')
        MaxLength = 3
        ParentFont = False
        TabOrder = 0
        WantReturns = False
        WordWrap = False
        OnChange = EditVal_HeightChange
        AutoSize = False
        BlockNegative = False
        BlankOnZero = False
        DisplayFormat = '###,###,##0 ;###,###,##0-'
        DecPlaces = 0
        ShowCurrency = False
        TextId = 0
        Value = 1E-10
      end
      object Ccy_Width: TCurrencyEdit
        Left = 334
        Top = 40
        Width = 41
        Height = 22
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
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
        OnChange = EditVal_WidthChange
        AutoSize = False
        BlockNegative = False
        BlankOnZero = False
        DisplayFormat = '###,###,##0 ;###,###,##0-'
        DecPlaces = 0
        ShowCurrency = False
        TextId = 0
        Value = 1E-10
      end
      object Ccy_Top: TCurrencyEdit
        Tag = 1
        Left = 335
        Top = 88
        Width = 41
        Height = 22
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          '0 ')
        MaxLength = 3
        ParentFont = False
        TabOrder = 2
        WantReturns = False
        WordWrap = False
        OnChange = EditVal_TopChange
        AutoSize = False
        BlockNegative = False
        BlankOnZero = False
        DisplayFormat = '###,###,##0 ;###,###,##0-'
        DecPlaces = 0
        ShowCurrency = False
        TextId = 0
        Value = 1E-10
      end
      object Ccy_Bottom: TCurrencyEdit
        Tag = 1
        Left = 335
        Top = 113
        Width = 41
        Height = 22
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          '0 ')
        MaxLength = 3
        ParentFont = False
        TabOrder = 3
        WantReturns = False
        WordWrap = False
        OnChange = EditVal_BottomChange
        AutoSize = False
        BlockNegative = False
        BlankOnZero = False
        DisplayFormat = '###,###,##0 ;###,###,##0-'
        DecPlaces = 0
        ShowCurrency = False
        TextId = 0
        Value = 1E-10
      end
      object Ccy_Left: TCurrencyEdit
        Tag = 1
        Left = 335
        Top = 137
        Width = 41
        Height = 22
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          '0 ')
        MaxLength = 3
        ParentFont = False
        TabOrder = 4
        WantReturns = False
        WordWrap = False
        OnChange = EditVal_LeftChange
        AutoSize = False
        BlockNegative = False
        BlankOnZero = False
        DisplayFormat = '###,###,##0 ;###,###,##0-'
        DecPlaces = 0
        ShowCurrency = False
        TextId = 0
        Value = 1E-10
      end
      object Ccy_Right: TCurrencyEdit
        Tag = 1
        Left = 335
        Top = 162
        Width = 41
        Height = 22
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          '0 ')
        MaxLength = 3
        ParentFont = False
        TabOrder = 5
        WantReturns = False
        WordWrap = False
        OnChange = EditVal_RightChange
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
    object TabSh_Structure: TTabSheet
      Caption = 'Structure'
      TabVisible = False
      object SBSGrp_PageHed: TSBSGroup
        Left = 2
        Top = 7
        Width = 310
        Height = 46
        BevelInner = bvRaised
        BevelOuter = bvLowered
        Enabled = False
        TabOrder = 0
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        object Label86: Label8
          Left = 23
          Top = 25
          Width = 278
          Height = 17
          AutoSize = False
          Caption = 'This section is printed at the top of every page.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
      end
      object SBSGrp_BodyHed: TSBSGroup
        Left = 2
        Top = 56
        Width = 310
        Height = 59
        BevelInner = bvRaised
        BevelOuter = bvLowered
        Enabled = False
        TabOrder = 1
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        object Label87: Label8
          Left = 23
          Top = 25
          Width = 280
          Height = 32
          AutoSize = False
          Caption = 
            'This section is printed at the start of the body and the start o' +
            'f every continuation body on subsequent pages.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
      end
      object SBSGrp_Body: TSBSGroup
        Left = 2
        Top = 120
        Width = 310
        Height = 59
        BevelInner = bvRaised
        BevelOuter = bvLowered
        Enabled = False
        TabOrder = 2
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        object Label88: Label8
          Left = 23
          Top = 25
          Width = 279
          Height = 30
          AutoSize = False
          Caption = 
            'This section would contain a table control for printing rows of ' +
            'information.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
      end
      object SBSGrp_BodyFoot: TSBSGroup
        Left = 2
        Top = 183
        Width = 310
        Height = 45
        BevelInner = bvRaised
        BevelOuter = bvLowered
        Enabled = False
        TabOrder = 3
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        object Label89: Label8
          Left = 23
          Top = 25
          Width = 281
          Height = 17
          AutoSize = False
          Caption = 'This section is printed at the end of the body.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
      end
      object SBSGrp_PageFoot: TSBSGroup
        Left = 2
        Top = 232
        Width = 310
        Height = 45
        BevelInner = bvRaised
        BevelOuter = bvLowered
        Enabled = False
        TabOrder = 4
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        object Label814: Label8
          Left = 23
          Top = 25
          Width = 280
          Height = 16
          AutoSize = False
          Caption = 'This section is printed at the bottom of every page.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
      end
      object BorCheck_PageHead: TBorCheck
        Left = 9
        Top = 11
        Width = 98
        Height = 20
        Align = alRight
        Caption = 'Page Header'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 5
        TabStop = True
        TextId = 0
      end
      object BorCheck_BodyHead: TBorCheck
        Left = 8
        Top = 59
        Width = 98
        Height = 20
        Align = alRight
        Caption = 'Body Header'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 6
        TabStop = True
        TextId = 0
      end
      object BorCheck_Body: TBorCheck
        Left = 8
        Top = 123
        Width = 98
        Height = 20
        Align = alRight
        Caption = 'Body'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 7
        TabStop = True
        TextId = 0
      end
      object BorCheck_BodyFoot: TBorCheck
        Left = 8
        Top = 186
        Width = 98
        Height = 20
        Align = alRight
        Caption = 'Body Footer'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 8
        TabStop = True
        TextId = 0
      end
      object BorCheck_PageFoot: TBorCheck
        Left = 8
        Top = 235
        Width = 98
        Height = 20
        Align = alRight
        Caption = 'Page Footer'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 9
        TabStop = True
        TextId = 0
      end
    end
    object TabSh_Label: TTabSheet
      Caption = 'Labels'
      object SBSBackGroup9: TSBSBackGroup
        Left = 288
        Top = -1
        Width = 97
        Height = 120
        Caption = 'Label 1 (mm)'
        TextId = 0
      end
      object Label831: Label8
        Left = 302
        Top = 19
        Width = 27
        Height = 14
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Top'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label832: Label8
        Left = 300
        Top = 44
        Width = 29
        Height = 14
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Left'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object SBSBackGroup10: TSBSBackGroup
        Left = 288
        Top = 121
        Width = 97
        Height = 70
        Caption = 'Columns'
        TextId = 0
      end
      object Label830: Label8
        Left = 293
        Top = 70
        Width = 36
        Height = 14
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Height'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label833: Label8
        Left = 297
        Top = 95
        Width = 32
        Height = 14
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Width'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label834: Label8
        Left = 296
        Top = 142
        Width = 36
        Height = 14
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'No.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label835: Label8
        Left = 300
        Top = 167
        Width = 32
        Height = 14
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Gap'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object SBSBackGroup11: TSBSBackGroup
        Left = 288
        Top = 192
        Width = 97
        Height = 70
        Caption = 'Rows'
        TextId = 0
      end
      object Label836: Label8
        Left = 296
        Top = 213
        Width = 36
        Height = 14
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'No.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label837: Label8
        Left = 300
        Top = 238
        Width = 32
        Height = 14
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Gap'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Image_Label: TImage
        Left = 0
        Top = 0
        Width = 276
        Height = 306
      end
      object lblTop: TCurrencyEdit
        Left = 334
        Top = 16
        Width = 41
        Height = 22
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          '0 ')
        MaxLength = 3
        ParentFont = False
        TabOrder = 0
        WantReturns = False
        WordWrap = False
        OnExit = lblTopExit
        AutoSize = False
        BlockNegative = False
        BlankOnZero = False
        DisplayFormat = '###,###,##0 ;###,###,##0-'
        DecPlaces = 0
        ShowCurrency = False
        TextId = 0
        Value = 1E-10
      end
      object lblLeft: TCurrencyEdit
        Left = 333
        Top = 41
        Width = 41
        Height = 22
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
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
        OnExit = lblLeftExit
        AutoSize = False
        BlockNegative = False
        BlankOnZero = False
        DisplayFormat = '###,###,##0 ;###,###,##0-'
        DecPlaces = 0
        ShowCurrency = False
        TextId = 0
        Value = 1E-10
      end
      object lblHeight: TCurrencyEdit
        Left = 333
        Top = 66
        Width = 41
        Height = 22
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          '0 ')
        MaxLength = 3
        ParentFont = False
        TabOrder = 2
        WantReturns = False
        WordWrap = False
        OnExit = lblHeightExit
        AutoSize = False
        BlockNegative = False
        BlankOnZero = False
        DisplayFormat = '###,###,##0 ;###,###,##0-'
        DecPlaces = 0
        ShowCurrency = False
        TextId = 0
        Value = 1E-10
      end
      object LblWidth: TCurrencyEdit
        Left = 333
        Top = 92
        Width = 41
        Height = 22
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          '0 ')
        MaxLength = 3
        ParentFont = False
        TabOrder = 3
        WantReturns = False
        WordWrap = False
        OnExit = LblWidthExit
        AutoSize = False
        BlockNegative = False
        BlankOnZero = False
        DisplayFormat = '###,###,##0 ;###,###,##0-'
        DecPlaces = 0
        ShowCurrency = False
        TextId = 0
        Value = 1E-10
      end
      object LblCols: TCurrencyEdit
        Left = 336
        Top = 138
        Width = 41
        Height = 22
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          '0 ')
        MaxLength = 3
        ParentFont = False
        TabOrder = 4
        WantReturns = False
        WordWrap = False
        OnExit = LblColsExit
        AutoSize = False
        BlockNegative = False
        BlankOnZero = False
        DisplayFormat = '###,###,##0 ;###,###,##0-'
        DecPlaces = 0
        ShowCurrency = False
        TextId = 0
        Value = 1E-10
      end
      object lblColGap: TCurrencyEdit
        Left = 336
        Top = 164
        Width = 41
        Height = 22
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          '0 ')
        MaxLength = 3
        ParentFont = False
        TabOrder = 5
        WantReturns = False
        WordWrap = False
        OnExit = lblColGapExit
        AutoSize = False
        BlockNegative = False
        BlankOnZero = False
        DisplayFormat = '###,###,##0 ;###,###,##0-'
        DecPlaces = 0
        ShowCurrency = False
        TextId = 0
        Value = 1E-10
      end
      object PrintLblTest: TButton
        Left = 288
        Top = 266
        Width = 96
        Height = 21
        Caption = '&Print Test'
        TabOrder = 8
        OnClick = PrintLblTestClick
      end
      object lblRows: TCurrencyEdit
        Left = 336
        Top = 209
        Width = 41
        Height = 22
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          '0 ')
        MaxLength = 3
        ParentFont = False
        TabOrder = 6
        WantReturns = False
        WordWrap = False
        OnExit = lblRowsExit
        AutoSize = False
        BlockNegative = False
        BlankOnZero = False
        DisplayFormat = '###,###,##0 ;###,###,##0-'
        DecPlaces = 0
        ShowCurrency = False
        TextId = 0
        Value = 1E-10
      end
      object lblRowGap: TCurrencyEdit
        Left = 336
        Top = 235
        Width = 41
        Height = 22
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          '0 ')
        MaxLength = 3
        ParentFont = False
        TabOrder = 7
        WantReturns = False
        WordWrap = False
        OnExit = lblRowGapExit
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
    object TabSh_Printer: TTabSheet
      Caption = 'Printer'
      object SBSBackGroup8: TSBSBackGroup
        Tag = 1
        Left = 2
        Top = 89
        Width = 383
        Height = 39
        TextId = 0
      end
      object SBSBackGroup5: TSBSBackGroup
        Left = 2
        Top = 0
        Width = 383
        Height = 90
        TextId = 0
      end
      object Label826: Label8
        Tag = 1
        Left = 6
        Top = 103
        Width = 33
        Height = 14
        Caption = 'Copies'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label827: Label8
        Left = 8
        Top = 14
        Width = 31
        Height = 14
        Caption = 'Printer'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label828: Label8
        Left = 12
        Top = 40
        Width = 28
        Height = 14
        Caption = 'Paper'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label829: Label8
        Left = 24
        Top = 64
        Width = 15
        Height = 14
        Caption = 'Bin'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Ccy_Copies: TCurrencyEdit
        Tag = 1
        Left = 44
        Top = 100
        Width = 37
        Height = 22
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
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
        OnChange = Ccy_CopiesChange
        AutoSize = False
        BlockNegative = False
        BlankOnZero = False
        DisplayFormat = '###,###,##0 ;###,###,##0-'
        DecPlaces = 0
        ShowCurrency = False
        TextId = 0
        Value = 1E-10
      end
      object PrintList: TSBSComboBox
        Left = 43
        Top = 11
        Width = 335
        Height = 22
        Style = csDropDownList
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 14
        ParentFont = False
        Sorted = True
        TabOrder = 0
        OnClick = PrintListClick
        MaxListWidth = 180
      end
      object PapersList: TSBSComboBox
        Left = 43
        Top = 36
        Width = 174
        Height = 22
        Style = csDropDownList
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 14
        ParentFont = False
        TabOrder = 1
        MaxListWidth = 180
      end
      object BinsList: TSBSComboBox
        Left = 43
        Top = 61
        Width = 174
        Height = 22
        Style = csDropDownList
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 14
        ParentFont = False
        TabOrder = 2
        MaxListWidth = 180
      end
    end
    object TabSh_Options: TTabSheet
      Caption = 'Options'
      ImageIndex = 6
      object SBSBackGroup13: TSBSBackGroup
        Left = 2
        Top = 146
        Width = 384
        Height = 96
        Caption = 'Stock Adjustments'
        TextId = 0
      end
      object Label839: Label8
        Left = 11
        Top = 162
        Width = 355
        Height = 42
        Caption = 
          'This option allows hidden Bill Of Materials details, created by ' +
          'the Build option, to be shown when printing an ADJ.  This option' +
          ' cannot be used in conjunction with the Serial/Batch/Multi-Bins ' +
          'options above.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        WordWrap = True
        TextId = 0
      end
      object SBSBackGroup3: TSBSBackGroup
        Left = 2
        Top = 0
        Width = 384
        Height = 144
        Caption = 'Serial/Batch/Bin Numbers'
        TextId = 0
      end
      object Label825: Label8
        Left = 17
        Top = 85
        Width = 33
        Height = 14
        Caption = 'Format'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label81: Label8
        Left = 197
        Top = 85
        Width = 52
        Height = 14
        Caption = 'Field Width'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object SBSBackGroup16: TSBSBackGroup
        Left = 2
        Top = 243
        Width = 384
        Height = 39
        Caption = ' Debt Chase Letters '
        TextId = 0
      end
      object Label840: Label8
        Left = 14
        Top = 110
        Width = 360
        Height = 28
        Caption = 
          'Please note that turning on the Serial/Batch/Multi-Bin options w' +
          'ill disable the ADJ Bill of Materials and Transaction Line Sorti' +
          'ng options. '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsItalic]
        ParentFont = False
        WordWrap = True
        TextId = 0
      end
      object lstShowADJBOM: TComboBox
        Left = 27
        Top = 211
        Width = 337
        Height = 22
        Style = csDropDownList
        ItemHeight = 14
        TabOrder = 8
        Items.Strings = (
          '')
      end
      object CcyEdit_SnoWidth: TCurrencyEdit
        Left = 256
        Top = 82
        Width = 47
        Height = 22
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          '0 ')
        MaxLength = 3
        ParentFont = False
        TabOrder = 7
        WantReturns = False
        WordWrap = False
        OnChange = CcyEdit_SnoWidthChange
        AutoSize = False
        BlockNegative = False
        BlankOnZero = False
        DisplayFormat = '###,###,##0 ;###,###,##0-'
        DecPlaces = 0
        ShowCurrency = False
        TextId = 0
        Value = 1E-10
      end
      object cmbSnoFormat: TSBSComboBox
        Left = 61
        Top = 82
        Width = 126
        Height = 22
        Style = csDropDownList
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 14
        ParentFont = False
        TabOrder = 6
        OnClick = cmbSnoFormatClick
        Items.Strings = (
          'Show 1 Per Line'
          'Use Full Line ')
        MaxListWidth = 0
      end
      object BCheck_ShowInSNo: TBorCheckEx
        Left = 150
        Top = 16
        Width = 154
        Height = 20
        Align = alRight
        Caption = 'Show for In Documents'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 3
        TabStop = True
        TextId = 0
      end
      object chkSerialNo: TBorCheck
        Left = 14
        Top = 16
        Width = 105
        Height = 20
        Align = alRight
        Caption = 'Show Serial No'#39's'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 0
        TabStop = True
        TextId = 0
        OnClick = chkSerialNoClick
      end
      object chkBatchNo: TBorCheck
        Left = 14
        Top = 36
        Width = 105
        Height = 20
        Align = alRight
        Caption = 'Show Batch No'#39's'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 1
        TabStop = True
        TextId = 0
        OnClick = chkSerialNoClick
      end
      object chkBins: TBorCheck
        Left = 14
        Top = 56
        Width = 112
        Height = 20
        Align = alRight
        Caption = 'Show Bins'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 2
        TabStop = True
        TextId = 0
        OnClick = chkSerialNoClick
      end
      object chkUseBy: TBorCheckEx
        Left = 150
        Top = 36
        Width = 112
        Height = 20
        Align = alRight
        Caption = 'Show Use By date'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 4
        TabStop = True
        TextId = 0
      end
      object chkStockPriOrder: TBorCheckEx
        Left = 150
        Top = 56
        Width = 151
        Height = 20
        Align = alRight
        Caption = 'StockCode/Priority Order'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 5
        TabStop = True
        TextId = 0
      end
      object chkMarkTHOnDebtLetters: TBorCheck
        Left = 13
        Top = 257
        Width = 291
        Height = 20
        Align = alRight
        Caption = 'Mark Transactions as printed'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 9
        TabStop = True
        TextId = 0
        OnClick = chkSerialNoClick
      end
    end
    object tabshSorting: TTabSheet
      Caption = 'Sorting'
      ImageIndex = 11
      object SBSBackGroup4: TSBSBackGroup
        Left = 2
        Top = 0
        Width = 383
        Height = 128
        TextId = 0
      end
      object Label841: Label8
        Left = 11
        Top = 13
        Width = 367
        Height = 49
        AutoSize = False
        Caption = 
          'This option allows the order of a Transaction'#39's Lines to be chan' +
          'ged when printing a transaction, e.g. Sales Order, Purchase Invo' +
          'ice, or when printing either a Single or Consolidated Picking Li' +
          'st.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        WordWrap = True
        TextId = 0
      end
      object Label842: Label8
        Left = 11
        Top = 60
        Width = 367
        Height = 32
        AutoSize = False
        Caption = 
          'If any of the Serial/Batch/Multi-Bin options are enabled in the ' +
          'Options Tab then they will override this option and use their ow' +
          'n sorting sequence.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        WordWrap = True
        TextId = 0
      end
      object lstSortTransLines: TComboBox
        Left = 23
        Top = 98
        Width = 339
        Height = 22
        Style = csDropDownList
        ItemHeight = 14
        TabOrder = 0
        Items.Strings = (
          '')
      end
    end
    object tabshPickingList: TTabSheet
      Caption = 'Picking List'
      ImageIndex = 10
      object SBSBackGroup2: TSBSBackGroup
        Left = 2
        Top = 0
        Width = 383
        Height = 129
        TextId = 0
      end
      object Label1: TLabel
        Left = 8
        Top = 13
        Width = 357
        Height = 28
        Caption = 
          'These options modify the behaviour of Individual/Single Picking ' +
          'List forms, they have no affect on Consolidated Picking Lists:-'
        WordWrap = True
      end
      object chkPickListDescLines: TBorCheck
        Left = 19
        Top = 43
        Width = 357
        Height = 20
        Align = alRight
        Caption = 'Include additional description lines on Individual Picking Lists'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 0
        TabStop = True
        TextId = 0
        OnClick = chkSerialNoClick
      end
      object chkPickListDescOnly: TBorCheck
        Left = 19
        Top = 63
        Width = 357
        Height = 20
        Align = alRight
        Caption = 'Include Non-Stock Items in Individual Picking Lists'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 1
        TabStop = True
        TextId = 0
        OnClick = chkSerialNoClick
      end
      object chkPickListNewLines: TBorCheck
        Left = 19
        Top = 83
        Width = 357
        Height = 20
        Align = alRight
        Caption = 'Include new lines in Individual Picking Lists'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 2
        TabStop = True
        TextId = 0
        OnClick = chkSerialNoClick
      end
      object chkInclHiddenBoM: TBorCheck
        Left = 19
        Top = 103
        Width = 357
        Height = 20
        Align = alRight
        Caption = 'Include Hidden BoM lines in Individual Picking Lists'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 3
        TabStop = True
        TextId = 0
        OnClick = chkSerialNoClick
      end
    end
    object TabSh_Strings: TTabSheet
      Caption = 'Strings'
      object SBSBackGroup1: TSBSBackGroup
        Left = 2
        Top = 0
        Width = 383
        Height = 275
        TextId = 0
      end
      object Label815: Label8
        Left = 14
        Top = 17
        Width = 9
        Height = 14
        Alignment = taRightJustify
        Caption = '1:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label819: Label8
        Left = 14
        Top = 43
        Width = 9
        Height = 14
        Alignment = taRightJustify
        Caption = '2:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label820: Label8
        Left = 14
        Top = 69
        Width = 9
        Height = 14
        Alignment = taRightJustify
        Caption = '3:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label818: Label8
        Left = 14
        Top = 95
        Width = 9
        Height = 14
        Alignment = taRightJustify
        Caption = '4:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label816: Label8
        Left = 14
        Top = 121
        Width = 9
        Height = 14
        Alignment = taRightJustify
        Caption = '5:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label817: Label8
        Left = 14
        Top = 146
        Width = 9
        Height = 14
        Alignment = taRightJustify
        Caption = '6:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label821: Label8
        Left = 14
        Top = 172
        Width = 9
        Height = 14
        Alignment = taRightJustify
        Caption = '7:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label822: Label8
        Left = 14
        Top = 198
        Width = 9
        Height = 14
        Alignment = taRightJustify
        Caption = '8:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label823: Label8
        Left = 14
        Top = 224
        Width = 9
        Height = 14
        Alignment = taRightJustify
        Caption = '9:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label824: Label8
        Left = 8
        Top = 250
        Width = 15
        Height = 14
        Alignment = taRightJustify
        Caption = '10:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Text_SV1: Text8Pt
        Left = 27
        Top = 14
        Width = 351
        Height = 22
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 30
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        Text = '1:'
        TextId = 0
        ViaSBtn = False
      end
      object Text_SV2: Text8Pt
        Left = 27
        Top = 40
        Width = 351
        Height = 22
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 30
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        Text = '1:'
        TextId = 0
        ViaSBtn = False
      end
      object Text_SV9: Text8Pt
        Left = 27
        Top = 221
        Width = 351
        Height = 22
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 30
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 8
        Text = '1:'
        TextId = 0
        ViaSBtn = False
      end
      object Text_SV8: Text8Pt
        Left = 27
        Top = 195
        Width = 351
        Height = 22
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 30
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 7
        Text = '1:'
        TextId = 0
        ViaSBtn = False
      end
      object Text_SV3: Text8Pt
        Left = 27
        Top = 66
        Width = 351
        Height = 22
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 30
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        Text = '1:'
        TextId = 0
        ViaSBtn = False
      end
      object Text_SV7: Text8Pt
        Left = 27
        Top = 169
        Width = 351
        Height = 22
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 30
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 6
        Text = '1:'
        TextId = 0
        ViaSBtn = False
      end
      object Text_SV6: Text8Pt
        Left = 27
        Top = 143
        Width = 351
        Height = 22
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 30
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 5
        Text = '1:'
        TextId = 0
        ViaSBtn = False
      end
      object Text_SV5: Text8Pt
        Left = 27
        Top = 118
        Width = 351
        Height = 22
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 30
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 4
        Text = '1:'
        TextId = 0
        ViaSBtn = False
      end
      object Text_SV4: Text8Pt
        Left = 27
        Top = 92
        Width = 351
        Height = 22
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 30
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 3
        Text = '1:'
        TextId = 0
        ViaSBtn = False
      end
      object Text_SV10: Text8Pt
        Left = 27
        Top = 247
        Width = 351
        Height = 22
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 30
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 9
        Text = '1:'
        TextId = 0
        ViaSBtn = False
      end
    end
  end
  object FontDialog1: TFontDialog
    HelpContext = 20200
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MinFontSize = 0
    MaxFontSize = 0
    Options = [fdEffects, fdShowHelp]
    Left = 426
    Top = 175
  end
  object OpenDialog: TOpenDialog
    HelpContext = 20000
    Filter = 'Form Designer Forms (*.EFX)|*.EFX|All files|*.*'
    Options = [ofHideReadOnly, ofShowHelp, ofPathMustExist, ofFileMustExist, ofShareAware]
    Left = 424
    Top = 227
  end
end
