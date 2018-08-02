object HistWin: THistWin
  Left = -570
  Top = -194
  Width = 572
  Height = 434
  HelpContext = 180
  Caption = 'History by Period'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  KeyPreview = True
  OldCreateOrder = True
  PopupMenu = PopupMenu1
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
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 2
    Top = 2
    Width = 542
    Height = 383
    ActivePage = NHDrCrPage
    TabIndex = 0
    TabOrder = 0
    OnChange = PageControl1Change
    OnChanging = PageControl1Changing
    object NHDrCrPage: TTabSheet
      Caption = 'Debit/Credit'
      DesignSize = (
        534
        355)
      object NHSBox: TScrollBox
        Left = 2
        Top = 5
        Width = 402
        Height = 332
        VertScrollBar.Visible = False
        TabOrder = 0
        object NHPrPanel: TSBSPanel
          Left = 6
          Top = 23
          Width = 61
          Height = 216
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          OnMouseUp = NHPrPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object NHHedPanel: TSBSPanel
          Left = 6
          Top = 3
          Width = 499
          Height = 17
          BevelInner = bvLowered
          BevelOuter = bvNone
          Color = clWhite
          TabOrder = 1
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumnHeader
          object NHCrLab: TSBSPanel
            Left = 173
            Top = 3
            Width = 107
            Height = 13
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = 'Credit    '
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
            OnMouseDown = NHPrLabMouseDown
            OnMouseMove = NHPrLabMouseMove
            OnMouseUp = NHPrPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object NHPrLab: TSBSPanel
            Left = 6
            Top = 3
            Width = 53
            Height = 13
            BevelOuter = bvNone
            Caption = 'Period'
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
            OnMouseDown = NHPrLabMouseDown
            OnMouseMove = NHPrLabMouseMove
            OnMouseUp = NHPrPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object NHDrLab: TSBSPanel
            Left = 63
            Top = 3
            Width = 108
            Height = 13
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = 'Debit    '
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
            OnMouseDown = NHPrLabMouseDown
            OnMouseMove = NHPrLabMouseMove
            OnMouseUp = NHPrPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object NHBalLab: TSBSPanel
            Left = 281
            Top = 3
            Width = 106
            Height = 13
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = 'Balance  '
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
            OnMouseDown = NHPrLabMouseDown
            OnMouseMove = NHPrLabMouseMove
            OnMouseUp = NHPrPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object NHUseLab: TSBSPanel
            Left = 391
            Top = 2
            Width = 106
            Height = 13
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = 'Usage     '
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
            OnMouseDown = NHPrLabMouseDown
            OnMouseMove = NHPrLabMouseMove
            OnMouseUp = NHPrPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
        end
        object NHDrPanel: TSBSPanel
          Left = 71
          Top = 23
          Width = 106
          Height = 216
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
          OnMouseUp = NHPrPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object NHCrPanel: TSBSPanel
          Left = 180
          Top = 23
          Width = 106
          Height = 216
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
          OnMouseUp = NHPrPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object NHBalPanel: TSBSPanel
          Left = 289
          Top = 23
          Width = 106
          Height = 216
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
          OnMouseUp = NHPrPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object NHUsePanel: TSBSPanel
          Left = 398
          Top = 23
          Width = 106
          Height = 216
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
          OnMouseUp = NHPrPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
      end
      object NHListBtnPanel: TSBSPanel
        Left = 408
        Top = 30
        Width = 18
        Height = 306
        Anchors = [akLeft, akTop, akBottom]
        BevelOuter = bvLowered
        TabOrder = 1
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
      end
    end
    object BudVarPage: TTabSheet
      HelpContext = 185
      Caption = 'Budget/Variance'
      object NBSBox: TScrollBox
        Left = 2
        Top = 5
        Width = 402
        Height = 340
        VertScrollBar.Visible = False
        TabOrder = 0
        object NBPrPanel: TSBSPanel
          Left = 6
          Top = 23
          Width = 61
          Height = 216
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          OnMouseUp = NHPrPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object NBHedPanel: TSBSPanel
          Left = 6
          Top = 3
          Width = 499
          Height = 17
          BevelInner = bvLowered
          BevelOuter = bvNone
          Color = clWhite
          TabOrder = 1
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumnHeader
          object NBBudLab: TSBSPanel
            Left = 173
            Top = 3
            Width = 107
            Height = 13
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = 'Budget  '
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
            OnMouseDown = NHPrLabMouseDown
            OnMouseMove = NHPrLabMouseMove
            OnMouseUp = NHPrPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object NBPrLab: TSBSPanel
            Left = 6
            Top = 3
            Width = 53
            Height = 13
            BevelOuter = bvNone
            Caption = 'Period'
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
            OnMouseDown = NHPrLabMouseDown
            OnMouseMove = NHPrLabMouseMove
            OnMouseUp = NHPrPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object NBBalLab: TSBSPanel
            Left = 63
            Top = 3
            Width = 108
            Height = 13
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = 'Balance  '
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
            OnMouseDown = NHPrLabMouseDown
            OnMouseMove = NHPrLabMouseMove
            OnMouseUp = NHPrPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object NBVarLab: TSBSPanel
            Left = 390
            Top = 3
            Width = 106
            Height = 13
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = 'Variance  '
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
            OnMouseDown = NHPrLabMouseDown
            OnMouseMove = NHPrLabMouseMove
            OnMouseUp = NHPrPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object NBBud2Lab: TSBSPanel
            Left = 280
            Top = 3
            Width = 106
            Height = 13
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = 'Revised Budget'
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
            OnMouseDown = NHPrLabMouseDown
            OnMouseMove = NHPrLabMouseMove
            OnMouseUp = NHPrPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
        end
        object NBBalPanel: TSBSPanel
          Left = 71
          Top = 23
          Width = 106
          Height = 216
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
          OnMouseUp = NHPrPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object NBBudPanel: TSBSPanel
          Left = 180
          Top = 23
          Width = 106
          Height = 216
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
          OnMouseUp = NHPrPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object NBVarPanel: TSBSPanel
          Left = 398
          Top = 23
          Width = 106
          Height = 216
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
          OnMouseUp = NHPrPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object NBBud2Panel: TSBSPanel
          Left = 289
          Top = 23
          Width = 106
          Height = 216
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
          OnMouseUp = NHPrPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
      end
    end
    object GraphPage: TTabSheet
      HelpContext = 182
      Caption = 'Graph'
      object GTitPanel: TSBSPanel
        Left = 0
        Top = 341
        Width = 534
        Height = 14
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 1
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        object GraphTit: Label8
          Left = 4
          Top = -3
          Width = 395
          Height = 21
          Alignment = taCenter
          AutoSize = False
          Caption = 'Graph'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TextId = 0
        end
      end
      object GraphPanel: TSBSPanel
        Left = 268
        Top = 2
        Width = 157
        Height = 227
        BevelInner = bvRaised
        BevelOuter = bvNone
        TabOrder = 0
        Visible = False
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        object Label81: Label8
          Left = 80
          Top = 2
          Width = 31
          Height = 14
          Caption = 'Series'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object CumLab: Label8
          Left = 6
          Top = 2
          Width = 52
          Height = 14
          Caption = 'Cumulative'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object InvChk: TBorCheck
          Left = 21
          Top = 122
          Width = 109
          Height = 20
          Align = alRight
          Caption = ' Invert Values'
          CheckColor = clWindowText
          Color = clBtnFace
          Checked = True
          ParentColor = False
          State = cbChecked
          TabOrder = 0
          TextId = 0
          OnClick = C1ModeBoxChange
        end
        object C1Chk: TBorCheck
          Left = 10
          Top = 16
          Width = 25
          Height = 20
          CheckColor = clWindowText
          Color = clBtnFace
          Checked = True
          ParentColor = False
          State = cbChecked
          TabOrder = 1
          TextId = 0
          OnClick = C1ModeBoxChange
        end
        object C2Chk: TBorCheck
          Left = 16
          Top = 41
          Width = 19
          Height = 20
          CheckColor = clWindowText
          Color = clBtnFace
          Checked = True
          ParentColor = False
          State = cbChecked
          TabOrder = 2
          TextId = 0
          OnClick = C1ModeBoxChange
        end
        object C2ModeBox: TSBSComboBox
          Left = 43
          Top = 41
          Width = 108
          Height = 22
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ItemHeight = 14
          ParentFont = False
          TabOrder = 3
          OnChange = C1ModeBoxChange
          Items.Strings = (
            'None'
            'Actual This Year '
            'Actual Last Year '
            'Budget This Year'
            'Budget Last Year'
            'Credit This Year'
            'Credit Last Year'
            'Debit This Year'
            'Debit Last Year')
          MaxListWidth = 0
        end
        object C1ModeBox: TSBSComboBox
          Left = 43
          Top = 16
          Width = 108
          Height = 22
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ItemHeight = 14
          ParentFont = False
          TabOrder = 4
          OnChange = C1ModeBoxChange
          Items.Strings = (
            'None'
            'Actual This Year '
            'Actual Last Year '
            'Budget This Year'
            'Budget Last Year'
            'Credit This Year'
            'Credit Last Year'
            'Debit This Year'
            'Debit Last Year')
          MaxListWidth = 0
        end
        object C3ModeBox: TSBSComboBox
          Left = 43
          Top = 67
          Width = 108
          Height = 22
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ItemHeight = 14
          ParentFont = False
          TabOrder = 5
          OnChange = C1ModeBoxChange
          Items.Strings = (
            'None'
            'Actual This Year '
            'Actual Last Year '
            'Budget This Year'
            'Budget Last Year'
            'Credit This Year'
            'Credit Last Year'
            'Debit This Year'
            'Debit Last Year')
          MaxListWidth = 0
        end
        object C4ModeBox: TSBSComboBox
          Left = 43
          Top = 92
          Width = 108
          Height = 22
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ItemHeight = 14
          ParentFont = False
          TabOrder = 6
          OnChange = C1ModeBoxChange
          Items.Strings = (
            'None'
            'Actual This Year '
            'Actual Last Year '
            'Budget This Year'
            'Budget Last Year'
            'Credit This Year'
            'Credit Last Year'
            'Debit This Year'
            'Debit Last Year')
          MaxListWidth = 0
        end
        object C3Chk: TBorCheck
          Left = 16
          Top = 66
          Width = 19
          Height = 20
          CheckColor = clWindowText
          Color = clBtnFace
          Checked = True
          ParentColor = False
          State = cbChecked
          TabOrder = 7
          TextId = 0
          OnClick = C1ModeBoxChange
        end
        object C4Chk: TBorCheck
          Left = 11
          Top = 91
          Width = 24
          Height = 20
          CheckColor = clWindowText
          Color = clBtnFace
          Checked = True
          ParentColor = False
          State = cbChecked
          TabOrder = 8
          TextId = 0
          OnClick = C1ModeBoxChange
        end
        object Q4Chk: TBorCheck
          Left = 21
          Top = 166
          Width = 125
          Height = 20
          Align = alNone
          Caption = ' Show periods 7 to 12'
          CheckColor = clWindowText
          Color = clBtnFace
          Checked = True
          ParentColor = False
          State = cbChecked
          TabOrder = 9
          TextId = 0
          OnClick = C1ModeBoxChange
        end
        object Q1Chk: TBorCheck
          Left = 21
          Top = 144
          Width = 120
          Height = 20
          Align = alRight
          Caption = ' Show periods 1 to 6'
          CheckColor = clWindowText
          Color = clBtnFace
          Checked = True
          ParentColor = False
          State = cbChecked
          TabOrder = 10
          TextId = 0
          OnClick = C1ModeBoxChange
        end
        object Q5Chk: TBorCheck
          Left = 21
          Top = 190
          Width = 125
          Height = 20
          Align = alNone
          Caption = ' Values in thousands'
          CheckColor = clWindowText
          Color = clBtnFace
          Checked = True
          ParentColor = False
          State = cbChecked
          TabOrder = 11
          TextId = 0
          OnClick = C1ModeBoxChange
        end
      end
    end
  end
  object NHBtnPanel: TSBSPanel
    Left = 434
    Top = 26
    Width = 102
    Height = 263
    BevelOuter = bvNone
    TabOrder = 1
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
    object NHBSBox: TScrollBox
      Left = 0
      Top = 125
      Width = 99
      Height = 131
      HorzScrollBar.Visible = False
      BorderStyle = bsNone
      Color = clBtnFace
      ParentColor = False
      TabOrder = 0
      object EditnhBtn: TButton
        Left = 2
        Top = 25
        Width = 80
        Height = 21
        HelpContext = 184
        Caption = '&Edit'
        TabOrder = 0
        OnClick = EditnhBtnClick
      end
      object FillnhBtn: TButton
        Left = 2
        Top = 49
        Width = 80
        Height = 21
        HelpContext = 183
        Caption = '&Fill'
        TabOrder = 1
        OnClick = FillnhBtnClick
      end
      object SetUpnhBtn: TButton
        Left = 2
        Top = 73
        Width = 80
        Height = 21
        HelpContext = 181
        Caption = '&Set-Up'
        TabOrder = 2
        OnClick = SetUpnhBtnClick
      end
      object ProfilenhBtn: TButton
        Left = 2
        Top = 97
        Width = 80
        Height = 21
        HelpContext = 181
        Caption = '&Profile'
        TabOrder = 3
        OnClick = ProfilenhBtnClick
      end
      object btnRevisions: TButton
        Left = 2
        Top = 1
        Width = 80
        Height = 21
        HelpContext = 40183
        Caption = '&Rev History'
        TabOrder = 4
        OnClick = btnRevisionsClick
      end
    end
    object Clsnh1Btn: TButton
      Left = 2
      Top = 3
      Width = 80
      Height = 21
      Cancel = True
      Caption = 'C&lose'
      ModalResult = 2
      TabOrder = 1
      OnClick = Clsnh1BtnClick
    end
  end
  object PopupMenu1: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 225
    Top = 83
    object RevHistory1: TMenuItem
      Caption = '&Rev History'
      OnClick = btnRevisionsClick
    end
    object Edit1: TMenuItem
      Caption = '&Edit'
      OnClick = EditnhBtnClick
    end
    object Fill1: TMenuItem
      Caption = '&Fill'
      OnClick = FillnhBtnClick
    end
    object SetUp1: TMenuItem
      Caption = '&Set-Up'
      OnClick = SetUpnhBtnClick
    end
    object Profile1: TMenuItem
      Caption = '&Profile'
      OnClick = ProfilenhBtnClick
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
    OnPopup = PopupMenu1Popup
    Left = 340
    Top = 97
    object Enter1: TMenuItem
      Caption = '&Enter Year Budget && Split'
      HelpContext = 181
      OnClick = Enter1Click
    end
    object CopyL1: TMenuItem
      Tag = 2
      Caption = 'Copy Last-Yr &Budget && Adjust'
      HelpContext = 181
      OnClick = o
    end
    object CopyL2: TMenuItem
      Tag = 3
      Caption = 'Copy Last-Yr &Actual && Adjust'
      HelpContext = 181
      OnClick = o
    end
    object Update1: TMenuItem
      Caption = '&Update all Heading Budgets'
      HelpContext = 181
      OnClick = Update1Click
    end
    object RollUp1: TMenuItem
      Caption = '&Roll Up CC/Dep Budgets'
      Visible = False
      OnClick = RollUp1Click
    end
  end
  object PopupMenu3: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 238
    Top = 164
    object MenuItem1: TMenuItem
      Caption = '&Enter Year Profile Ratio && Split'
      HelpContext = 181
      OnClick = Enter1Click
    end
    object MenuItem2: TMenuItem
      Tag = 2
      Caption = '&Copy Last-Yr Profile && Adjust'
      HelpContext = 181
      OnClick = o
    end
    object MenuItem4: TMenuItem
      Caption = '&Update Sub Heading Profiles'
      HelpContext = 181
      OnClick = MenuItem4Click
    end
  end
  object PopupMenu4: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 331
    Top = 155
    object MenuItem3: TMenuItem
      Tag = 1
      Caption = '&Original Budget'
      HelpContext = 181
      OnClick = MenuItem3Click
    end
    object MenuItem5: TMenuItem
      Tag = 2
      Caption = '&Revised Budget'
      HelpContext = 181
      OnClick = MenuItem3Click
    end
  end
  object WindowExport: TWindowExport
    OnEnableExport = WindowExportEnableExport
    OnExecuteCommand = WindowExportExecuteCommand
    OnGetExportDescription = WindowExportGetExportDescription
    Left = 41
    Top = 67
  end
end
