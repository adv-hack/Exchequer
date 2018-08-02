object frmDashboard: TfrmDashboard
  Left = 157
  Top = 160
  Width = 1123
  Height = 637
  HelpContext = 2
  Caption = 'IRIS Enterprise Software - Dashboard'
  Color = 16774371
  Constraints.MinHeight = 500
  Constraints.MinWidth = 790
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  HelpFile = 'ClientSync.hlp'
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 14
  object advDockdashTop: TAdvDockPanel
    Left = 0
    Top = 0
    Width = 1115
    Height = 70
    MinimumSize = 2
    LockHeight = False
    Persistence.Location = plRegistry
    Persistence.Enabled = False
    ToolBarStyler = AdvToolBarStyler
    UseRunTimeHeight = False
    Version = '2.7.0.0'
    DesignSize = (
      1115
      70)
    object imgError: TImage
      Left = 766
      Top = 2
      Width = 24
      Height = 24
      Cursor = crHandPoint
      Hint = 'An error has just occurred'
      Anchors = [akLeft, akTop, akRight, akBottom]
      AutoSize = True
      Center = True
      ParentShowHint = False
      Picture.Data = {
        07544269746D617096010000424D960100000000000076000000280000001800
        000018000000010004000000000020010000120B0000120B0000100000000000
        0000000000000000800000800000008080008000000080008000808000008080
        8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
        FF00DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD666DDDDDDDDDDDDDDDDDDDD68F
        86DDDDDDDDDDDDDDDDDD68FFF86DDDDDDDDDDDDDDDD68F944F86DDDDDDDDDDDD
        DD68F99994F86DDDDDDDDDDDD68F9999994F86DDDDDDDDDD68F999FFFF94F86D
        DDDDDDD68F99999FF9994F86DDDDDD68F999999FF99994F86DDDD68F9999999F
        F999994F86DDD6FF9999999FF999999FF6DDD68FE999999FF999999F86DDDD68
        FE9999FFF99994F86DDDDDD68FE9999999994F86DDDDDDDD68FE999FF994F86D
        DDDDDDDDD68FE99FF94F8CDDDDDDDDDDDD68FE9994F8CDDDDDDDDDDDDDD68FE9
        4F86DDDDDDDDDDDDDDDD68FFF86DDDDDDDDDDDDDDDDDD68F86DDDDDDDDDDDDDD
        DDDDDD666DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD
        DDDD}
      ShowHint = True
      Transparent = True
      Visible = False
      OnDblClick = imgErrorDblClick
    end
    object advToolMenu: TAdvToolBar
      Left = 3
      Top = 1
      Width = 89
      Height = 26
      AllowFloating = False
      AutoOptionMenu = True
      Locked = True
      CaptionFont.Charset = ANSI_CHARSET
      CaptionFont.Color = clWindowText
      CaptionFont.Height = -11
      CaptionFont.Name = 'Arial'
      CaptionFont.Style = []
      CompactImageIndex = -1
      ShowRightHandle = False
      ShowClose = False
      ShowOptionIndicator = False
      TextAutoOptionMenu = 'Add or Remove Buttons'
      TextOptionMenu = 'Options'
      ToolBarStyler = AdvToolBarStyler
      Menu = advMainMenu
      ParentOptionPicture = True
      ToolBarIndex = -1
    end
    object tlbFile: TAdvToolBar
      Left = 3
      Top = 28
      Width = 220
      Height = 28
      AllowFloating = False
      CaptionFont.Charset = ANSI_CHARSET
      CaptionFont.Color = clWindowText
      CaptionFont.Height = -11
      CaptionFont.Name = 'Arial'
      CaptionFont.Style = []
      CompactImageIndex = -1
      ShowRightHandle = False
      ShowClose = False
      ShowOptionIndicator = False
      DockableTo = [daLeft, daTop, daBottom]
      TextAutoOptionMenu = 'Add or Remove Buttons'
      TextOptionMenu = 'Options'
      ToolBarStyler = AdvToolBarStyler
      Images = imgDashBoard
      ParentOptionPicture = True
      ShowHint = False
      ToolBarIndex = -1
      object btnNew: TAdvToolBarButton
        Left = 2
        Top = 2
        Width = 51
        Height = 24
        Appearance.CaptionFont.Charset = DEFAULT_CHARSET
        Appearance.CaptionFont.Color = clWindowText
        Appearance.CaptionFont.Height = -11
        Appearance.CaptionFont.Name = 'MS Sans Serif'
        Appearance.CaptionFont.Style = []
        Caption = '&New'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ImageIndex = 0
        ParentFont = False
        Position = daTop
        Shaded = False
        ShowCaption = True
        Version = '2.7.0.0'
        OnClick = btnNewClick
      end
      object AdvToolBarSeparator1: TAdvToolBarSeparator
        Left = 53
        Top = 2
        Width = 10
        Height = 24
        LineColor = clBtnShadow
      end
      object AdvToolBarSeparator2: TAdvToolBarSeparator
        Left = 127
        Top = 2
        Width = 10
        Height = 24
        LineColor = clBtnShadow
      end
      object btnCheckMail: TAdvToolBarButton
        Left = 137
        Top = 2
        Width = 79
        Height = 24
        Action = actCheckMailNow
        Appearance.CaptionFont.Charset = DEFAULT_CHARSET
        Appearance.CaptionFont.Color = clWindowText
        Appearance.CaptionFont.Height = -11
        Appearance.CaptionFont.Name = 'MS Sans Serif'
        Appearance.CaptionFont.Style = []
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ImageIndex = 8
        ParentFont = False
        Position = daTop
        ShowCaption = True
        Version = '2.7.0.0'
      end
      object btnSystem: TAdvToolBarButton
        Left = 63
        Top = 2
        Width = 64
        Height = 24
        Appearance.CaptionFont.Charset = DEFAULT_CHARSET
        Appearance.CaptionFont.Color = clWindowText
        Appearance.CaptionFont.Height = -11
        Appearance.CaptionFont.Name = 'MS Sans Serif'
        Appearance.CaptionFont.Style = []
        Caption = 'S&ystem'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ImageIndex = 5
        ParentFont = False
        Position = daTop
        Shaded = False
        ShowCaption = True
        Version = '2.7.0.0'
        OnClick = btnSystemClick
      end
    end
    object tlbNew: TAdvToolBar
      Left = 225
      Top = 28
      Width = 828
      Height = 28
      AllowFloating = False
      Locked = True
      CaptionFont.Charset = ANSI_CHARSET
      CaptionFont.Color = clWindowText
      CaptionFont.Height = -11
      CaptionFont.Name = 'Arial'
      CaptionFont.Style = []
      CompactImageIndex = -1
      ShowRightHandle = False
      ShowClose = False
      ShowOptionIndicator = False
      DockableTo = [daLeft, daTop, daBottom]
      TextAutoOptionMenu = 'Add or Remove Buttons'
      TextOptionMenu = 'Options'
      ToolBarStyler = AdvToolBarStyler
      ParentOptionPicture = True
      ShowHint = False
      ToolBarIndex = -1
      object btnRequestDripfeed: TAdvToolBarButton
        Left = 2
        Top = 2
        Width = 70
        Height = 24
        Action = actLinkRequest
        Appearance.CaptionFont.Charset = DEFAULT_CHARSET
        Appearance.CaptionFont.Color = clWindowText
        Appearance.CaptionFont.Height = -11
        Appearance.CaptionFont.Name = 'MS Sans Serif'
        Appearance.CaptionFont.Style = []
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        Position = daTop
        ShowCaption = True
        Version = '2.7.0.0'
      end
      object btnBulkExport: TAdvToolBarButton
        Left = 72
        Top = 2
        Width = 62
        Height = 24
        Action = actBulkExport
        Appearance.CaptionFont.Charset = DEFAULT_CHARSET
        Appearance.CaptionFont.Color = clWindowText
        Appearance.CaptionFont.Height = -11
        Appearance.CaptionFont.Name = 'MS Sans Serif'
        Appearance.CaptionFont.Style = []
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        Position = daTop
        ShowCaption = True
        Version = '2.7.0.0'
      end
      object btnDripFeed: TAdvToolBarButton
        Left = 134
        Top = 2
        Width = 64
        Height = 24
        Action = actUpdateLink
        Appearance.CaptionFont.Charset = DEFAULT_CHARSET
        Appearance.CaptionFont.Color = clWindowText
        Appearance.CaptionFont.Height = -11
        Appearance.CaptionFont.Name = 'MS Sans Serif'
        Appearance.CaptionFont.Style = []
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        Position = daTop
        ShowCaption = True
        Version = '2.7.0.0'
      end
      object btnEndofDripFeed: TAdvToolBarButton
        Left = 283
        Top = 2
        Width = 48
        Height = 24
        Action = actEndLink
        Appearance.CaptionFont.Charset = DEFAULT_CHARSET
        Appearance.CaptionFont.Color = clWindowText
        Appearance.CaptionFont.Height = -11
        Appearance.CaptionFont.Name = 'MS Sans Serif'
        Appearance.CaptionFont.Style = []
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        Position = daTop
        ShowCaption = True
        Version = '2.7.0.0'
      end
      object btnDeleteCompany: TAdvToolBarButton
        Left = 527
        Top = 2
        Width = 86
        Height = 24
        Action = actDeleteCompany
        Appearance.CaptionFont.Charset = DEFAULT_CHARSET
        Appearance.CaptionFont.Color = clWindowText
        Appearance.CaptionFont.Height = -11
        Appearance.CaptionFont.Name = 'MS Sans Serif'
        Appearance.CaptionFont.Style = []
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        Position = daTop
        ShowCaption = True
        Version = '2.7.0.0'
      end
      object btnActivateCompany: TAdvToolBarButton
        Left = 431
        Top = 2
        Width = 96
        Height = 24
        Action = actActivateCompany
        Appearance.CaptionFont.Charset = DEFAULT_CHARSET
        Appearance.CaptionFont.Color = clWindowText
        Appearance.CaptionFont.Height = -11
        Appearance.CaptionFont.Name = 'MS Sans Serif'
        Appearance.CaptionFont.Style = []
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        Position = daTop
        ShowCaption = True
        Version = '2.7.0.0'
      end
      object btnRecreate: TAdvToolBarButton
        Left = 331
        Top = 2
        Width = 100
        Height = 24
        Action = actRecreate
        Appearance.CaptionFont.Charset = DEFAULT_CHARSET
        Appearance.CaptionFont.Color = clWindowText
        Appearance.CaptionFont.Height = -11
        Appearance.CaptionFont.Name = 'MS Sans Serif'
        Appearance.CaptionFont.Style = []
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        Position = daTop
        ShowCaption = True
        Version = '2.7.0.0'
      end
      object btnAddSchedule: TAdvToolBarButton
        Left = 198
        Top = 2
        Width = 85
        Height = 24
        Action = actAddSchedule
        Appearance.CaptionFont.Charset = DEFAULT_CHARSET
        Appearance.CaptionFont.Color = clWindowText
        Appearance.CaptionFont.Height = -11
        Appearance.CaptionFont.Name = 'MS Sans Serif'
        Appearance.CaptionFont.Style = []
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        Position = daTop
        ShowCaption = True
        Version = '2.7.0.0'
      end
      object btnMore: TAdvToolBarMenuButton
        Left = 768
        Top = 2
        Width = 56
        Height = 24
        Appearance.CaptionFont.Charset = DEFAULT_CHARSET
        Appearance.CaptionFont.Color = clWindowText
        Appearance.CaptionFont.Height = -11
        Appearance.CaptionFont.Name = 'MS Sans Serif'
        Appearance.CaptionFont.Style = []
        DropDownButton = True
        DropDownMenu = ppmMore
        DropDownSplit = False
        Caption = '&More...'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        Position = daTop
        ShowCaption = True
        Version = '2.7.0.0'
      end
      object btnSubContractorVerification: TAdvToolBarButton
        Left = 613
        Top = 2
        Width = 155
        Height = 24
        Action = actSubContractorVerification
        Appearance.CaptionFont.Charset = DEFAULT_CHARSET
        Appearance.CaptionFont.Color = clWindowText
        Appearance.CaptionFont.Height = -11
        Appearance.CaptionFont.Name = 'MS Sans Serif'
        Appearance.CaptionFont.Style = []
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ImageIndex = 6
        ParentFont = False
        Position = daTop
        ShowCaption = True
        Version = '2.7.0.0'
      end
    end
  end
  object advDockDashRight: TAdvDockPanel
    Left = 1100
    Top = 70
    Width = 15
    Height = 501
    Align = daRight
    MinimumSize = 1
    LockHeight = False
    Persistence.Location = plRegistry
    Persistence.Enabled = False
    ToolBarStyler = AdvToolBarStyler
    UseRunTimeHeight = False
    Version = '2.7.0.0'
  end
  object advDockDashBotton: TAdvDockPanel
    Left = 0
    Top = 571
    Width = 1115
    Height = 13
    Align = daBottom
    MinimumSize = 1
    LockHeight = False
    Persistence.Location = plRegistry
    Persistence.Enabled = False
    ToolBarStyler = AdvToolBarStyler
    UseRunTimeHeight = False
    Version = '2.7.0.0'
  end
  object advDockDashLeft: TAdvDockPanel
    Left = 0
    Top = 70
    Width = 15
    Height = 501
    Align = daLeft
    MinimumSize = 1
    LockHeight = False
    Persistence.Location = plRegistry
    Persistence.Enabled = False
    ToolBarStyler = AdvToolBarStyler
    UseRunTimeHeight = False
    Version = '2.7.0.0'
  end
  object advPanelBackgroud: TAdvPanel
    Left = 15
    Top = 70
    Width = 1085
    Height = 501
    Align = alClient
    BevelOuter = bvNone
    Color = 16445929
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 7485192
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    UseDockManager = True
    Version = '1.7.6.0'
    AutoHideChildren = False
    BorderColor = 16765615
    Caption.Color = 16773091
    Caption.ColorTo = 16765615
    Caption.Font.Charset = DEFAULT_CHARSET
    Caption.Font.Color = clBlack
    Caption.Font.Height = -11
    Caption.Font.Name = 'MS Sans Serif'
    Caption.Font.Style = []
    Caption.GradientDirection = gdVertical
    Caption.Indent = 2
    Caption.ShadeLight = 255
    CollapsColor = clHighlight
    CollapsDelay = 0
    ColorTo = 15587527
    ColorMirror = 15587527
    ColorMirrorTo = 16773863
    ShadowColor = clBlack
    ShadowOffset = 0
    StatusBar.BorderColor = 16765615
    StatusBar.BorderStyle = bsSingle
    StatusBar.Font.Charset = DEFAULT_CHARSET
    StatusBar.Font.Color = 7485192
    StatusBar.Font.Height = -11
    StatusBar.Font.Name = 'Tahoma'
    StatusBar.Font.Style = []
    StatusBar.Color = 16245715
    StatusBar.ColorTo = 16109747
    StatusBar.GradientDirection = gdVertical
    Styler = AdvPanelStyler
    FullHeight = 0
    object Splitter: TAdvSplitter
      Left = 245
      Top = 0
      Width = 4
      Height = 501
      Cursor = crHSplit
      Beveled = True
      Color = 15587527
      ParentColor = False
      Appearance.BorderColor = clNone
      Appearance.BorderColorHot = clNone
      Appearance.Color = 16773091
      Appearance.ColorTo = 16765615
      Appearance.ColorHot = 16773091
      Appearance.ColorHotTo = 16765615
      GripStyle = sgDots
    end
    object advPanelNav: TAdvPanel
      Left = 0
      Top = 0
      Width = 245
      Height = 501
      Align = alLeft
      BevelInner = bvLowered
      Color = 16445929
      Constraints.MaxWidth = 500
      Constraints.MinWidth = 245
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 7485192
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      UseDockManager = True
      Version = '1.7.6.0'
      AutoHideChildren = False
      BorderColor = 16765615
      Caption.Color = 16773091
      Caption.ColorTo = 16765615
      Caption.Font.Charset = DEFAULT_CHARSET
      Caption.Font.Color = clBlack
      Caption.Font.Height = -11
      Caption.Font.Name = 'MS Sans Serif'
      Caption.Font.Style = []
      Caption.GradientDirection = gdVertical
      Caption.Indent = 2
      Caption.ShadeLight = 255
      CollapsColor = clHighlight
      CollapsDelay = 0
      ColorTo = 15587527
      ColorMirror = 15587527
      ColorMirrorTo = 16773863
      ShadowColor = clBlack
      ShadowOffset = 0
      StatusBar.BorderColor = 16765615
      StatusBar.BorderStyle = bsSingle
      StatusBar.Font.Charset = DEFAULT_CHARSET
      StatusBar.Font.Color = 7485192
      StatusBar.Font.Height = -11
      StatusBar.Font.Name = 'Tahoma'
      StatusBar.Font.Style = []
      StatusBar.Color = 16245715
      StatusBar.ColorTo = 16109747
      StatusBar.GradientDirection = gdVertical
      FullHeight = 0
      object advNav: TAdvNavBar
        Left = 2
        Top = 2
        Width = 241
        Height = 497
        Align = alClient
        ActiveColor = 11196927
        ActiveColorTo = 7257087
        ActiveMirrorColor = 4370174
        ActiveMirrorColorTo = 8053246
        ActiveTabIndex = 2
        BorderColor = 16765615
        CaptionColor = 16773091
        CaptionColorTo = 16765615
        CaptionFont.Charset = DEFAULT_CHARSET
        CaptionFont.Color = 7485192
        CaptionFont.Height = -15
        CaptionFont.Name = 'Tahoma'
        CaptionFont.Style = [fsBold]
        CollapsedCaption = 'Collapsed'
        CollapsedHoverColor = 8053246
        CollapsedDownColor = 5021693
        DefaultGradientDirection = gdVertical
        DefaultTabColor = 16773091
        DefaultTabColorTo = 16768452
        DefaultTabMirrorColor = 16765357
        DefaultTabMirrorColorTo = 16767936
        DownTabColor = 7778289
        DownTabColorTo = 4296947
        DownTabMirrorColor = 946929
        DownTabMirrorColorTo = 5021693
        Font.Charset = ANSI_CHARSET
        Font.Color = 7485192
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        HoverTabColor = 15465983
        HoverTabColorTo = 11332863
        HoverTabMirrorColor = 5888767
        HoverTabMirrorColorTo = 10807807
        HoverTextColor = 7485192
        Images = imgNavBarBig
        PopupIndicator = False
        SectionColor = 16772317
        SectionColorTo = 16772317
        ShowHint = False
        SmallImages = imgTabSmall
        SplitterPosition = 3
        SplitterColor = 16773091
        SplitterColorTo = 16765615
        Style = esOffice2007Luna
        Version = '1.5.1.1'
        OnChange = advNavChange
        OnPanelActivate = advNavPanelActivate
        object advNavHistory: TAdvNavBarPanel
          Left = 1
          Top = 27
          Width = 239
          Height = 335
          Hint = 'History'
          Caption = 'Hist&ory'
          Color = clWhite
          ImageIndex = 1
          PanelIndex = 1
          Sections = <>
          object tvHistory: THTMLTreeview
            Left = 0
            Top = 0
            Width = 239
            Height = 335
            ControlStyle = csWinXP
            ControlColor = clRed
            HTMLImages = imgBox
            ItemHeight = 16
            SelectionColor = clHighlight
            SelectionFontColor = clHighlightText
            SelectionNFColor = clSilver
            SelectionNFFontColor = clBlack
            URLColor = clBlue
            HintColor = clNone
            Align = alClient
            BorderStyle = bsNone
            Color = 16640730
            Ctl3D = False
            Font.Charset = ANSI_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            HideSelection = False
            Indent = 19
            ParentCtl3D = False
            ParentFont = False
            ParentShowHint = False
            PopupMenu = ppmRebuild
            ShowHint = False
            ShowLines = False
            StateImages = imgBox
            TabOrder = 0
            OnChange = tvCompChange
            OnClick = tvCompClick
            OnEnter = tvBoxEnter
            Version = '1.1.1.1'
          end
        end
        object advNavArchive: TAdvNavBarPanel
          Left = 1
          Top = 27
          Width = 239
          Height = 335
          Hint = 'Archive'
          Caption = 'Archi&ve'
          Color = clWhite
          ImageIndex = 0
          PanelIndex = 0
          Sections = <>
          object tvArchive: THTMLTreeview
            Left = 0
            Top = 0
            Width = 239
            Height = 335
            ControlStyle = csWinXP
            ControlColor = clRed
            HTMLImages = imgBox
            ItemHeight = 16
            SelectionColor = clHighlight
            SelectionFontColor = clHighlightText
            SelectionNFColor = clSilver
            SelectionNFFontColor = clBlack
            URLColor = clBlue
            HintColor = clNone
            Align = alClient
            RowSelect = True
            BorderStyle = bsNone
            Color = 16640730
            Ctl3D = False
            Font.Charset = ANSI_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            HideSelection = False
            Indent = 19
            ParentCtl3D = False
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            ShowLines = False
            SortType = stText
            StateImages = imgBox
            TabOrder = 0
            OnChange = tvCompChange
            OnClick = tvCompClick
            OnEnter = tvBoxEnter
            Version = '1.1.1.1'
          end
        end
        object AdvNavLink: TAdvNavBarPanel
          Left = 1
          Top = 27
          Width = 239
          Height = 335
          Hint = 'Dripfeed'
          Caption = 'Linked Com&panies'
          Color = 16640730
          ColorTo = 14986888
          Font.Charset = ANSI_CHARSET
          Font.Color = 7485192
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ImageIndex = 2
          PanelIndex = 2
          Sections = <
            item
              Caption = 'Mail'
              Control = tvBox
              Height = 81
            end
            item
              Caption = 'Companies'
              Control = tvComp
              Height = 360
            end>
          OnResize = AdvNavLinkResize
          object tvBox: THTMLTreeview
            Left = 0
            Top = 17
            Width = 239
            Height = 64
            ControlStyle = csWinXP
            ControlColor = clRed
            HTMLImages = imgBox
            ItemHeight = 16
            SelectionColor = clHighlight
            SelectionFontColor = clHighlightText
            SelectionNFColor = clSilver
            SelectionNFFontColor = clBlack
            URLColor = clBlue
            HintColor = clNone
            RowSelect = True
            BorderStyle = bsNone
            Color = 16640730
            Ctl3D = False
            Font.Charset = ANSI_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            HideSelection = False
            Indent = 20
            ParentCtl3D = False
            ParentFont = False
            ParentShowHint = False
            ShowHint = False
            ShowLines = False
            StateImages = imgBox
            TabOrder = 0
            OnChange = tvBoxChange
            OnDragDrop = tvBoxDragDrop
            OnDragOver = tvBoxDragOver
            OnEnter = tvBoxEnter
            Version = '1.1.1.1'
          end
          object tvComp: THTMLTreeview
            Left = 0
            Top = 98
            Width = 239
            Height = 237
            ControlStyle = csWinXP
            ControlColor = clRed
            HTMLImages = imgBox
            ItemHeight = 16
            SelectionColor = clHighlight
            SelectionFontColor = clHighlightText
            SelectionNFColor = clSilver
            SelectionNFFontColor = clBlack
            URLColor = clBlue
            HintColor = clNone
            Align = alBottom
            RowSelect = True
            BorderStyle = bsNone
            Color = 16640730
            Ctl3D = False
            Font.Charset = ANSI_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            HideSelection = False
            Indent = 19
            ParentCtl3D = False
            ParentFont = False
            ParentShowHint = False
            PopupMenu = ppmNew
            ShowHint = False
            ShowLines = False
            SortType = stText
            StateImages = imgBox
            TabOrder = 1
            OnChange = tvCompChange
            OnEnter = tvBoxEnter
            Version = '1.1.1.1'
          end
        end
      end
    end
    object advEventLog: TAdvPanel
      Left = 0
      Top = 501
      Width = 1085
      Height = 0
      Align = alBottom
      BevelOuter = bvNone
      Color = 16640730
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      UseDockManager = True
      Version = '1.7.6.0'
      BorderColor = 16640730
      Caption.Color = clHighlight
      Caption.ColorTo = clNone
      Caption.Font.Charset = DEFAULT_CHARSET
      Caption.Font.Color = clHighlightText
      Caption.Font.Height = -11
      Caption.Font.Name = 'MS Sans Serif'
      Caption.Font.Style = []
      ColorTo = 14986888
      StatusBar.Font.Charset = DEFAULT_CHARSET
      StatusBar.Font.Color = clWindowText
      StatusBar.Font.Height = -11
      StatusBar.Font.Name = 'Tahoma'
      StatusBar.Font.Style = []
      FullHeight = 0
      object advGridLog: TDBAdvGrid
        Left = 0
        Top = 0
        Width = 1085
        Height = 0
        Cursor = crDefault
        TabStop = False
        Align = alClient
        ColCount = 4
        Ctl3D = True
        DefaultRowHeight = 22
        RowCount = 2
        FixedRows = 1
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing]
        ParentCtl3D = False
        PopupMenu = ppmIcelog
        ScrollBars = ssVertical
        TabOrder = 0
        GridLineColor = 15062992
        HintColor = 15653832
        HTMLHint = True
        ActiveCellFont.Charset = DEFAULT_CHARSET
        ActiveCellFont.Color = clWindowText
        ActiveCellFont.Height = -11
        ActiveCellFont.Name = 'Tahoma'
        ActiveCellFont.Style = [fsBold]
        ActiveCellColor = 10344697
        ActiveCellColorTo = 6210033
        Balloon.BackgroundColor = 15653832
        Balloon.Enable = True
        Balloon.TextColor = 7485192
        ControlLook.FixedGradientFrom = 16513526
        ControlLook.FixedGradientTo = 15260626
        EnableHTML = False
        EnhTextSize = True
        Filter = <>
        FixedColWidth = 20
        FixedRowHeight = 22
        FixedFont.Charset = DEFAULT_CHARSET
        FixedFont.Color = clWindowText
        FixedFont.Height = -11
        FixedFont.Name = 'Tahoma'
        FixedFont.Style = [fsBold]
        FloatFormat = '%.2f'
        Grouping.HeaderColor = 14059353
        Grouping.HeaderColorTo = 9648131
        Grouping.HeaderTextColor = clWhite
        Grouping.HeaderUnderline = True
        Grouping.SummaryColor = 16440004
        Grouping.SummaryColorTo = 16105376
        Navigation.EditSelectAll = False
        Navigation.CopyHTMLTagsToClipboard = False
        Navigation.SkipFixedCells = False
        PrintSettings.DateFormat = 'dd/mm/yyyy'
        PrintSettings.Font.Charset = DEFAULT_CHARSET
        PrintSettings.Font.Color = clWindowText
        PrintSettings.Font.Height = -11
        PrintSettings.Font.Name = 'MS Sans Serif'
        PrintSettings.Font.Style = []
        PrintSettings.FixedFont.Charset = DEFAULT_CHARSET
        PrintSettings.FixedFont.Color = clWindowText
        PrintSettings.FixedFont.Height = -11
        PrintSettings.FixedFont.Name = 'MS Sans Serif'
        PrintSettings.FixedFont.Style = []
        PrintSettings.HeaderFont.Charset = DEFAULT_CHARSET
        PrintSettings.HeaderFont.Color = clWindowText
        PrintSettings.HeaderFont.Height = -11
        PrintSettings.HeaderFont.Name = 'MS Sans Serif'
        PrintSettings.HeaderFont.Style = []
        PrintSettings.FooterFont.Charset = DEFAULT_CHARSET
        PrintSettings.FooterFont.Color = clWindowText
        PrintSettings.FooterFont.Height = -11
        PrintSettings.FooterFont.Name = 'MS Sans Serif'
        PrintSettings.FooterFont.Style = []
        PrintSettings.PageNumSep = '/'
        SearchFooter.Color = 16773091
        SearchFooter.ColorTo = 16765615
        SearchFooter.FindNextCaption = 'Find next'
        SearchFooter.FindPrevCaption = 'Find previous'
        SearchFooter.Font.Charset = DEFAULT_CHARSET
        SearchFooter.Font.Color = clWindowText
        SearchFooter.Font.Height = -11
        SearchFooter.Font.Name = 'MS Sans Serif'
        SearchFooter.Font.Style = []
        SearchFooter.HighLightCaption = 'Highlight'
        SearchFooter.HintClose = 'Close'
        SearchFooter.HintFindNext = 'Find next occurence'
        SearchFooter.HintFindPrev = 'Find previous occurence'
        SearchFooter.HintHighlight = 'Highlight occurences'
        SearchFooter.MatchCaseCaption = 'Match case'
        SelectionColor = 6210033
        SelectionColorTo = 1414638
        Version = '2.1.1.9'
        WordWrap = False
        AutoCreateColumns = True
        AutoRemoveColumns = False
        Columns = <
          item
            Borders = []
            BorderPen.Color = clSilver
            CheckFalse = 'N'
            CheckTrue = 'Y'
            Color = clWindow
            FieldName = 'Id'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            Header = 'Id'
            HeaderFont.Charset = DEFAULT_CHARSET
            HeaderFont.Color = clWindowText
            HeaderFont.Height = -11
            HeaderFont.Name = 'MS Sans Serif'
            HeaderFont.Style = []
            PrintBorders = [cbTop, cbLeft, cbRight, cbBottom]
            PrintFont.Charset = DEFAULT_CHARSET
            PrintFont.Color = clWindowText
            PrintFont.Height = -11
            PrintFont.Name = 'MS Sans Serif'
            PrintFont.Style = []
            Width = 20
          end
          item
            AutoMaxSize = 750
            Borders = []
            BorderPen.Color = clSilver
            CheckFalse = 'N'
            CheckTrue = 'Y'
            Color = clWindow
            Editor = edNone
            FieldName = 'Description'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            Header = 'Description'
            HeaderFont.Charset = DEFAULT_CHARSET
            HeaderFont.Color = clWindowText
            HeaderFont.Height = -11
            HeaderFont.Name = 'Tahoma'
            HeaderFont.Style = []
            MaxSize = 750
            PrintBorders = [cbTop, cbLeft, cbRight, cbBottom]
            PrintFont.Charset = DEFAULT_CHARSET
            PrintFont.Color = clWindowText
            PrintFont.Height = -11
            PrintFont.Name = 'Tahoma'
            PrintFont.Style = []
            Width = 750
          end
          item
            Borders = []
            BorderPen.Color = clSilver
            CheckFalse = 'N'
            CheckTrue = 'Y'
            Color = clWindow
            FieldName = 'LastUpdate'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            Header = 'Date and Time'
            HeaderFont.Charset = DEFAULT_CHARSET
            HeaderFont.Color = clWindowText
            HeaderFont.Height = -11
            HeaderFont.Name = 'Tahoma'
            HeaderFont.Style = []
            PrintBorders = [cbTop, cbLeft, cbRight, cbBottom]
            PrintFont.Charset = DEFAULT_CHARSET
            PrintFont.Color = clWindowText
            PrintFont.Height = -11
            PrintFont.Name = 'Tahoma'
            PrintFont.Style = []
            Width = 120
          end
          item
            Borders = []
            BorderPen.Color = clSilver
            CheckFalse = 'N'
            CheckTrue = 'Y'
            Color = clWindow
            FieldName = 'Location'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            Header = 'Location'
            HeaderFont.Charset = DEFAULT_CHARSET
            HeaderFont.Color = clWindowText
            HeaderFont.Height = -11
            HeaderFont.Name = 'Tahoma'
            HeaderFont.Style = []
            PrintBorders = [cbTop, cbLeft, cbRight, cbBottom]
            PrintFont.Charset = DEFAULT_CHARSET
            PrintFont.Color = clWindowText
            PrintFont.Height = -11
            PrintFont.Name = 'Tahoma'
            PrintFont.Style = []
            Width = 120
          end>
        DataSource = dsLog
        RefreshOnDelete = True
        RefreshOnInsert = True
        ShowMemoFields = True
        ShowDesignHelper = False
        ShowUnicode = False
        ColWidths = (
          20
          750
          120
          120)
      end
    end
    object tpDashboard: TAdvToolPanelTab
      Left = 816
      Top = 0
      Width = 269
      Height = 501
      AutoDock = False
      AutoOpenCloseSpeed = aocFast
      Color = 16774371
      ColorTo = 15587784
      Font.Charset = ANSI_CHARSET
      Font.Color = 7485192
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      Position = ppRight
      SlideSpeed = ssInstant
      Style = esOffice2007Luna
      TabBorderColor = 16765615
      TabColor = 16773091
      TabColorTo = 16765615
      TabHoverColor = 14483455
      TabHoverColorTo = 6013175
      Version = '1.4.2.0'
      OnTabSlideInDone = tpDashboardTabSlideInDone
      object tpCompany: TAdvToolPanel
        Left = 0
        Top = 0
        Width = 246
        Height = 501
        AllowDocking = False
        BackgroundTransparent = False
        BackGroundPosition = bpTopLeft
        BevelInner = bvLowered
        Button3D = False
        HoverButtonColor = 14483455
        HoverButtonColorTo = 6013175
        DownButtonColor = 557032
        DownButtonColorTo = 8182519
        CaptionButton = False
        Color = 16774371
        ColorTo = 15587784
        GradientDirection = gdVertical
        DockDots = True
        CanSize = False
        Caption = 'Company Info'
        CaptionGradientDirection = gdVertical
        FocusCaptionFontColor = 7485192
        FocusCaptionColor = 12316415
        FocusCaptionColorTo = 7920383
        NoFocusCaptionFontColor = 7485192
        NoFocusCaptionColor = 16773091
        NoFocusCaptionColorTo = 16765615
        OpenWidth = 270
        CloseHint = 'Close panel'
        LockHint = 'Lock panel'
        UnlockHint = 'Unlock panel'
        Sections = <>
        SectionLayout.CaptionColor = 16635575
        SectionLayout.CaptionColorTo = 13146742
        SectionLayout.CaptionFontColor = clBlack
        SectionLayout.CaptionRounded = False
        SectionLayout.Corners = scRectangle
        SectionLayout.BackGroundColor = 16248798
        SectionLayout.BackGroundColorTo = 16242365
        SectionLayout.BorderColor = 16765615
        SectionLayout.BorderWidth = 1
        SectionLayout.CaptionGradientDir = gdVertical
        SectionLayout.BackGroundGradientDir = gdVertical
        SectionLayout.Indent = 4
        SectionLayout.Spacing = 4
        SectionLayout.ItemFontColor = 11876608
        SectionLayout.ItemHoverTextColor = 11876608
        SectionLayout.ItemHoverUnderline = True
        SectionLayout.UnderLineCaption = False
        ShowCaptionBorder = False
        ShowClose = False
        Style = esOffice2007Luna
        Version = '1.4.2.0'
        object btnCompBulkExport: TAdvGlowButton
          Left = 2
          Top = 337
          Width = 242
          Height = 27
          Align = alBottom
          Action = actBulkExport
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          FocusType = ftHot
          ParentFont = False
          TabOrder = 2
          Appearance.BorderColor = 14727579
          Appearance.BorderColorHot = 10079963
          Appearance.BorderColorDown = 4548219
          Appearance.BorderColorChecked = 4548219
          Appearance.Color = 15653832
          Appearance.ColorTo = 16178633
          Appearance.ColorChecked = 11918331
          Appearance.ColorCheckedTo = 7915518
          Appearance.ColorDisabled = 15653832
          Appearance.ColorDisabledTo = 16178633
          Appearance.ColorDown = 7778289
          Appearance.ColorDownTo = 4296947
          Appearance.ColorHot = 15465983
          Appearance.ColorHotTo = 11332863
          Appearance.ColorMirror = 15586496
          Appearance.ColorMirrorTo = 16245200
          Appearance.ColorMirrorHot = 5888767
          Appearance.ColorMirrorHotTo = 10807807
          Appearance.ColorMirrorDown = 946929
          Appearance.ColorMirrorDownTo = 5021693
          Appearance.ColorMirrorChecked = 10480637
          Appearance.ColorMirrorCheckedTo = 5682430
          Appearance.ColorMirrorDisabled = 15653832
          Appearance.ColorMirrorDisabledTo = 16178633
          Appearance.GradientHot = ggVertical
          Appearance.GradientMirrorHot = ggVertical
          Appearance.GradientDown = ggVertical
          Appearance.GradientMirrorDown = ggVertical
          Appearance.GradientChecked = ggVertical
        end
        object btnCompEndDripfeed: TAdvGlowButton
          Left = 2
          Top = 418
          Width = 242
          Height = 27
          Align = alBottom
          Action = actEndLink
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          FocusType = ftHot
          ParentFont = False
          TabOrder = 5
          Appearance.BorderColor = 14727579
          Appearance.BorderColorHot = 10079963
          Appearance.BorderColorDown = 4548219
          Appearance.BorderColorChecked = 4548219
          Appearance.Color = 15653832
          Appearance.ColorTo = 16178633
          Appearance.ColorChecked = 11918331
          Appearance.ColorCheckedTo = 7915518
          Appearance.ColorDisabled = 15653832
          Appearance.ColorDisabledTo = 16178633
          Appearance.ColorDown = 7778289
          Appearance.ColorDownTo = 4296947
          Appearance.ColorHot = 15465983
          Appearance.ColorHotTo = 11332863
          Appearance.ColorMirror = 15586496
          Appearance.ColorMirrorTo = 16245200
          Appearance.ColorMirrorHot = 5888767
          Appearance.ColorMirrorHotTo = 10807807
          Appearance.ColorMirrorDown = 946929
          Appearance.ColorMirrorDownTo = 5021693
          Appearance.ColorMirrorChecked = 10480637
          Appearance.ColorMirrorCheckedTo = 5682430
          Appearance.ColorMirrorDisabled = 15653832
          Appearance.ColorMirrorDisabledTo = 16178633
          Appearance.GradientHot = ggVertical
          Appearance.GradientMirrorHot = ggVertical
          Appearance.GradientDown = ggVertical
          Appearance.GradientMirrorDown = ggVertical
          Appearance.GradientChecked = ggVertical
        end
        object btnCompDripFeed: TAdvGlowButton
          Left = 2
          Top = 364
          Width = 242
          Height = 27
          Align = alBottom
          Action = actUpdateLink
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          FocusType = ftHot
          ParentFont = False
          TabOrder = 3
          Appearance.BorderColor = 14727579
          Appearance.BorderColorHot = 10079963
          Appearance.BorderColorDown = 4548219
          Appearance.BorderColorChecked = 4548219
          Appearance.Color = 15653832
          Appearance.ColorTo = 16178633
          Appearance.ColorChecked = 11918331
          Appearance.ColorCheckedTo = 7915518
          Appearance.ColorDisabled = 15653832
          Appearance.ColorDisabledTo = 16178633
          Appearance.ColorDown = 7778289
          Appearance.ColorDownTo = 4296947
          Appearance.ColorHot = 15465983
          Appearance.ColorHotTo = 11332863
          Appearance.ColorMirror = 15586496
          Appearance.ColorMirrorTo = 16245200
          Appearance.ColorMirrorHot = 5888767
          Appearance.ColorMirrorHotTo = 10807807
          Appearance.ColorMirrorDown = 946929
          Appearance.ColorMirrorDownTo = 5021693
          Appearance.ColorMirrorChecked = 10480637
          Appearance.ColorMirrorCheckedTo = 5682430
          Appearance.ColorMirrorDisabled = 15653832
          Appearance.ColorMirrorDisabledTo = 16178633
          Appearance.GradientHot = ggVertical
          Appearance.GradientMirrorHot = ggVertical
          Appearance.GradientDown = ggVertical
          Appearance.GradientMirrorDown = ggVertical
          Appearance.GradientChecked = ggVertical
        end
        object btnCompDripFeedReq: TAdvGlowButton
          Left = 2
          Top = 310
          Width = 242
          Height = 27
          Align = alBottom
          Action = actLinkRequest
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          FocusType = ftHot
          ParentFont = False
          TabOrder = 1
          Appearance.BorderColor = 14727579
          Appearance.BorderColorHot = 10079963
          Appearance.BorderColorDown = 4548219
          Appearance.BorderColorChecked = 4548219
          Appearance.Color = 15653832
          Appearance.ColorTo = 16178633
          Appearance.ColorChecked = 11918331
          Appearance.ColorCheckedTo = 7915518
          Appearance.ColorDisabled = 15653832
          Appearance.ColorDisabledTo = 16178633
          Appearance.ColorDown = 7778289
          Appearance.ColorDownTo = 4296947
          Appearance.ColorHot = 15465983
          Appearance.ColorHotTo = 11332863
          Appearance.ColorMirror = 15586496
          Appearance.ColorMirrorTo = 16245200
          Appearance.ColorMirrorHot = 5888767
          Appearance.ColorMirrorHotTo = 10807807
          Appearance.ColorMirrorDown = 946929
          Appearance.ColorMirrorDownTo = 5021693
          Appearance.ColorMirrorChecked = 10480637
          Appearance.ColorMirrorCheckedTo = 5682430
          Appearance.ColorMirrorDisabled = 15653832
          Appearance.ColorMirrorDisabledTo = 16178633
          Appearance.GradientHot = ggVertical
          Appearance.GradientMirrorHot = ggVertical
          Appearance.GradientDown = ggVertical
          Appearance.GradientMirrorDown = ggVertical
          Appearance.GradientChecked = ggVertical
        end
        object btnCompAddDripFeed: TAdvGlowButton
          Left = 2
          Top = 391
          Width = 242
          Height = 27
          Align = alBottom
          Action = actAddSchedule
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          FocusType = ftHot
          ParentFont = False
          TabOrder = 4
          Appearance.BorderColor = 14727579
          Appearance.BorderColorHot = 10079963
          Appearance.BorderColorDown = 4548219
          Appearance.BorderColorChecked = 4548219
          Appearance.Color = 15653832
          Appearance.ColorTo = 16178633
          Appearance.ColorChecked = 11918331
          Appearance.ColorCheckedTo = 7915518
          Appearance.ColorDisabled = 15653832
          Appearance.ColorDisabledTo = 16178633
          Appearance.ColorDown = 7778289
          Appearance.ColorDownTo = 4296947
          Appearance.ColorHot = 15465983
          Appearance.ColorHotTo = 11332863
          Appearance.ColorMirror = 15586496
          Appearance.ColorMirrorTo = 16245200
          Appearance.ColorMirrorHot = 5888767
          Appearance.ColorMirrorHotTo = 10807807
          Appearance.ColorMirrorDown = 946929
          Appearance.ColorMirrorDownTo = 5021693
          Appearance.ColorMirrorChecked = 10480637
          Appearance.ColorMirrorCheckedTo = 5682430
          Appearance.ColorMirrorDisabled = 15653832
          Appearance.ColorMirrorDisabledTo = 16178633
          Appearance.GradientHot = ggVertical
          Appearance.GradientMirrorHot = ggVertical
          Appearance.GradientDown = ggVertical
          Appearance.GradientMirrorDown = ggVertical
          Appearance.GradientChecked = ggVertical
        end
        object lbCompStatus: THTMListBox
          Left = 2
          Top = 25
          Width = 242
          Height = 285
          TabStop = False
          Align = alClient
          Ctl3D = False
          Ellipsis = False
          Font.Charset = ANSI_CHARSET
          Font.Color = 7485192
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ItemHeight = 14
          Multiline = False
          ParentCtl3D = False
          SelectionFontColor = clHighlightText
          ShadowOffset = 1
          ShowSelection = True
          Sorted = False
          SortWithHTML = False
          TabOrder = 0
          Version = '1.9.1.1'
        end
        object btnCompMore: TAdvGlowButton
          Left = 2
          Top = 472
          Width = 242
          Height = 27
          Align = alBottom
          Caption = '&More...'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          FocusType = ftHot
          ParentFont = False
          TabOrder = 7
          Appearance.BorderColor = 14727579
          Appearance.BorderColorHot = 10079963
          Appearance.BorderColorDown = 4548219
          Appearance.BorderColorChecked = 4548219
          Appearance.Color = 15653832
          Appearance.ColorTo = 16178633
          Appearance.ColorChecked = 11918331
          Appearance.ColorCheckedTo = 7915518
          Appearance.ColorDisabled = 15653832
          Appearance.ColorDisabledTo = 16178633
          Appearance.ColorDown = 7778289
          Appearance.ColorDownTo = 4296947
          Appearance.ColorHot = 15465983
          Appearance.ColorHotTo = 11332863
          Appearance.ColorMirror = 15586496
          Appearance.ColorMirrorTo = 16245200
          Appearance.ColorMirrorHot = 5888767
          Appearance.ColorMirrorHotTo = 10807807
          Appearance.ColorMirrorDown = 946929
          Appearance.ColorMirrorDownTo = 5021693
          Appearance.ColorMirrorChecked = 10480637
          Appearance.ColorMirrorCheckedTo = 5682430
          Appearance.ColorMirrorDisabled = 15653832
          Appearance.ColorMirrorDisabledTo = 16178633
          Appearance.GradientHot = ggVertical
          Appearance.GradientMirrorHot = ggVertical
          Appearance.GradientDown = ggVertical
          Appearance.GradientMirrorDown = ggVertical
          Appearance.GradientChecked = ggVertical
          DropDownButton = True
          DropDownSplit = False
          DropDownMenu = ppmMore
        end
        object btnCompSubcontractorVerification: TAdvGlowButton
          Left = 2
          Top = 445
          Width = 242
          Height = 27
          Align = alBottom
          Action = actSubContractorVerification
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ImageIndex = 6
          FocusType = ftHot
          ParentFont = False
          TabOrder = 6
          Appearance.BorderColor = 14727579
          Appearance.BorderColorHot = 10079963
          Appearance.BorderColorDown = 4548219
          Appearance.BorderColorChecked = 4548219
          Appearance.Color = 15653832
          Appearance.ColorTo = 16178633
          Appearance.ColorChecked = 11918331
          Appearance.ColorCheckedTo = 7915518
          Appearance.ColorDisabled = 15653832
          Appearance.ColorDisabledTo = 16178633
          Appearance.ColorDown = 7778289
          Appearance.ColorDownTo = 4296947
          Appearance.ColorHot = 15465983
          Appearance.ColorHotTo = 11332863
          Appearance.ColorMirror = 15586496
          Appearance.ColorMirrorTo = 16245200
          Appearance.ColorMirrorHot = 5888767
          Appearance.ColorMirrorHotTo = 10807807
          Appearance.ColorMirrorDown = 946929
          Appearance.ColorMirrorDownTo = 5021693
          Appearance.ColorMirrorChecked = 10480637
          Appearance.ColorMirrorCheckedTo = 5682430
          Appearance.ColorMirrorDisabled = 15653832
          Appearance.ColorMirrorDisabledTo = 16178633
          Appearance.GradientHot = ggVertical
          Appearance.GradientMirrorHot = ggVertical
          Appearance.GradientDown = ggVertical
          Appearance.GradientMirrorDown = ggVertical
          Appearance.GradientChecked = ggVertical
        end
      end
    end
    object sbMail: TAdvScrollBox
      Left = 249
      Top = 0
      Width = 567
      Height = 501
      Align = alClient
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 3
      object lblNoItem: TLabel
        Left = 0
        Top = 0
        Width = 565
        Height = 16
        Align = alTop
        Alignment = taCenter
        Caption = 'There are no items to show in this view'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
    end
  end
  object sbDash: TAdvOfficeStatusBar
    Left = 0
    Top = 584
    Width = 1115
    Height = 19
    AnchorHint = False
    Panels = <
      item
        Alignment = taCenter
        DateFormat = 'mm/dd/yyyy'
        Progress.BackGround = clBtnFace
        Progress.Indication = piPercentage
        Progress.Min = 0
        Progress.Max = 100
        Progress.Position = 0
        Progress.Level0Color = clLime
        Progress.Level0ColorTo = 14811105
        Progress.Level1Color = clYellow
        Progress.Level1ColorTo = 13303807
        Progress.Level2Color = 5483007
        Progress.Level2ColorTo = 11064319
        Progress.Level3Color = clRed
        Progress.Level3ColorTo = 13290239
        Progress.Level1Perc = 70
        Progress.Level2Perc = 90
        Progress.BorderColor = clBlack
        Progress.ShowBorder = False
        Progress.Stacked = False
        Style = psText
        TimeFormat = 'hh:mm:ss'
        Width = 75
        AppearanceStyle = psLight
      end
      item
        Alignment = taCenter
        DateFormat = 'mm/dd/yyyy'
        Progress.BackGround = clBtnFace
        Progress.Indication = piPercentage
        Progress.Min = 0
        Progress.Max = 100
        Progress.Position = 0
        Progress.Level0Color = clLime
        Progress.Level0ColorTo = 14811105
        Progress.Level1Color = clYellow
        Progress.Level1ColorTo = 13303807
        Progress.Level2Color = 5483007
        Progress.Level2ColorTo = 11064319
        Progress.Level3Color = clRed
        Progress.Level3ColorTo = 13290239
        Progress.Level1Perc = 70
        Progress.Level2Perc = 90
        Progress.BorderColor = clBlack
        Progress.ShowBorder = False
        Progress.Stacked = False
        Style = psText
        TimeFormat = 'hh:mm:ss'
        Width = 150
        AppearanceStyle = psLight
      end
      item
        Alignment = taCenter
        DateFormat = 'dd/mm/yyyy'
        Progress.BackGround = clBtnFace
        Progress.Indication = piPercentage
        Progress.Min = 0
        Progress.Max = 100
        Progress.Position = 0
        Progress.Level0Color = clLime
        Progress.Level0ColorTo = 14811105
        Progress.Level1Color = clYellow
        Progress.Level1ColorTo = 13303807
        Progress.Level2Color = 5483007
        Progress.Level2ColorTo = 11064319
        Progress.Level3Color = clRed
        Progress.Level3ColorTo = 13290239
        Progress.Level1Perc = 70
        Progress.Level2Perc = 90
        Progress.BorderColor = clBlack
        Progress.ShowBorder = False
        Progress.Stacked = False
        Style = psDate
        Text = '01/02/2007'
        TimeFormat = 'hh:mm:ss'
        Width = 90
        AppearanceStyle = psLight
      end
      item
        Alignment = taCenter
        DateFormat = 'mm/dd/yyyy'
        Progress.BackGround = clBtnFace
        Progress.Indication = piPercentage
        Progress.Min = 0
        Progress.Max = 100
        Progress.Position = 0
        Progress.Level0Color = clLime
        Progress.Level0ColorTo = 14811105
        Progress.Level1Color = clYellow
        Progress.Level1ColorTo = 13303807
        Progress.Level2Color = 5483007
        Progress.Level2ColorTo = 11064319
        Progress.Level3Color = clRed
        Progress.Level3ColorTo = 13290239
        Progress.Level1Perc = 70
        Progress.Level2Perc = 90
        Progress.BorderColor = clBlack
        Progress.ShowBorder = False
        Progress.Stacked = False
        Style = psTime
        Text = '14:55:54'
        TimeFormat = 'hh:mm:ss'
        Width = 80
        AppearanceStyle = psLight
      end
      item
        Alignment = taCenter
        DateFormat = 'mm/dd/yyyy'
        Progress.BackGround = clBtnFace
        Progress.Indication = piPercentage
        Progress.Min = 0
        Progress.Max = 100
        Progress.Position = 0
        Progress.Level0Color = clLime
        Progress.Level0ColorTo = 14811105
        Progress.Level1Color = clYellow
        Progress.Level1ColorTo = 13303807
        Progress.Level2Color = 5483007
        Progress.Level2ColorTo = 11064319
        Progress.Level3Color = clRed
        Progress.Level3ColorTo = 13290239
        Progress.Level1Perc = 70
        Progress.Level2Perc = 90
        Progress.BorderColor = clBlack
        Progress.ShowBorder = False
        Progress.Stacked = False
        TimeFormat = 'hh:mm:ss'
        Width = 100
        AppearanceStyle = psLight
      end
      item
        Alignment = taCenter
        DateFormat = 'mm/dd/yyyy'
        Progress.BackGround = clBtnFace
        Progress.Indication = piPercentage
        Progress.Min = 0
        Progress.Max = 100
        Progress.Position = 0
        Progress.Level0Color = clLime
        Progress.Level0ColorTo = 14811105
        Progress.Level1Color = clYellow
        Progress.Level1ColorTo = 13303807
        Progress.Level2Color = 5483007
        Progress.Level2ColorTo = 11064319
        Progress.Level3Color = clRed
        Progress.Level3ColorTo = 13290239
        Progress.Level1Perc = 70
        Progress.Level2Perc = 90
        Progress.BorderColor = clBlack
        Progress.ShowBorder = False
        Progress.Stacked = False
        TimeFormat = 'hh:mm:ss'
        Width = 110
        AppearanceStyle = psLight
      end
      item
        Alignment = taCenter
        DateFormat = 'mm/dd/yyyy'
        Progress.BackGround = clBtnFace
        Progress.Indication = piPercentage
        Progress.Min = 0
        Progress.Max = 100
        Progress.Position = 0
        Progress.Level0Color = clLime
        Progress.Level0ColorTo = 14811105
        Progress.Level1Color = clYellow
        Progress.Level1ColorTo = 13303807
        Progress.Level2Color = 5483007
        Progress.Level2ColorTo = 11064319
        Progress.Level3Color = clRed
        Progress.Level3ColorTo = 13290239
        Progress.Level1Perc = 70
        Progress.Level2Perc = 90
        Progress.BorderColor = clBlack
        Progress.ShowBorder = False
        Progress.Stacked = False
        TimeFormat = 'hh:mm:ss'
        Width = 100
        AppearanceStyle = psLight
      end>
    SimplePanel = False
    URLColor = clBlue
    Styler = SbStyler
    OnPanelRightClick = sbDashPanelRightClick
    Version = '1.1.1.0'
  end
  object advMainMenu: TAdvMainMenu
    MenuStyler = AdvMenuStyler
    Version = '2.5.0.0'
    Left = 368
    Top = 452
    object mnuFile: TMenuItem
      Caption = '&File'
      object mnuNew: TMenuItem
        Caption = '&New'
        OnClick = ppmCompanyPopup
        object mnuRequestSync: TMenuItem
          Action = actLinkRequest
        end
        object BulkExport1: TMenuItem
          Action = actBulkExport
        end
        object Dripfeed1: TMenuItem
          Action = actUpdateLink
        end
        object DripfeedScheduledTask1: TMenuItem
          Action = actAddSchedule
        end
        object EndofDripfeed3: TMenuItem
          Action = actEndLink
        end
        object RecreateCompany1: TMenuItem
          Action = actRecreate
        end
        object ActivateCompany1: TMenuItem
          Action = actActivateCompany
        end
        object DeleteCompany1: TMenuItem
          Action = actDeleteCompany
        end
        object SubcontractorVerification1: TMenuItem
          Action = actSubContractorVerification
        end
        object N22: TMenuItem
          Caption = '-'
        end
        object mnuFileMore: TMenuItem
          Caption = 'More...'
          object CancelDripfeed4: TMenuItem
            Action = actCancelLink
          end
          object N9: TMenuItem
            Caption = '-'
          end
          object DeactivateCompany3: TMenuItem
            Action = actDeactivateComp
          end
          object RefreshCompanies3: TMenuItem
            Action = actRefreshCompany
          end
        end
      end
      object mnuSystem: TMenuItem
        Caption = 'S&ystem'
        object mnuComp: TMenuItem
          Action = actNewCompany
        end
        object N5: TMenuItem
          Caption = '-'
        end
        object mnuUser: TMenuItem
          Action = actUserLogin
        end
        object mnuUserPermissions: TMenuItem
          Action = actUserPermission
        end
        object mnuEmailContacts: TMenuItem
          Action = actContacts
        end
        object mnuUpdateManagerPassword: TMenuItem
          Action = actUpdateManagerPassword
        end
        object N40: TMenuItem
          Caption = '-'
          ImageIndex = 3
        end
        object mnuConfiguration: TMenuItem
          Action = ActConfiguration
        end
      end
      object N11: TMenuItem
        Caption = '-'
      end
      object mnuInbox: TMenuItem
        Caption = 'Inbox'
        OnClick = mnuInboxClick
        object SelectAll1: TMenuItem
          Action = actSelectAllInbox
        end
        object N17: TMenuItem
          Caption = '-'
        end
        object Accept1: TMenuItem
          Action = actAccept
        end
        object Deny1: TMenuItem
          Action = actDeny
        end
        object N13: TMenuItem
          Caption = '-'
        end
        object Import1: TMenuItem
          Action = actImport
        end
        object N14: TMenuItem
          Caption = '-'
        end
        object Delete1: TMenuItem
          Action = actDeleteInbox
        end
        object N8: TMenuItem
          Caption = '-'
        end
        object Preview1: TMenuItem
          Action = actInboxPreview
        end
      end
      object mnuOutbox: TMenuItem
        Caption = 'Outbox'
        OnClick = mnuInboxClick
        object SelectAll2: TMenuItem
          Action = actSelectAllOutbox
        end
        object N18: TMenuItem
          Caption = '-'
        end
        object mnuDeleteOutbox: TMenuItem
          Action = actDeleteOutbox
        end
        object Resend1: TMenuItem
          Action = actResend
        end
        object N12: TMenuItem
          Caption = '-'
        end
        object mnuViewSchedule: TMenuItem
          Action = actViewSchedule
        end
        object mnuChangeSchedule: TMenuItem
          Action = actChangeSchedule
        end
        object mnuRemoveSchedule: TMenuItem
          Action = actRemoveSchedule
        end
        object N20: TMenuItem
          Caption = '-'
        end
        object ViewCISResponse1: TMenuItem
          Action = actViewCISResponse
        end
        object actOutboxPreview1: TMenuItem
          Action = actOutboxPreview
        end
      end
      object DeletedFailed1: TMenuItem
        Caption = 'Deleted/Failed'
        OnClick = mnuInboxClick
        object SelectAll3: TMenuItem
          Action = actSelectAllRecycle
        end
        object N19: TMenuItem
          Caption = '-'
        end
        object Delete2: TMenuItem
          Action = actDeleteRecycle
        end
        object actRecycleRestore1: TMenuItem
          Action = actRecycleRestore
        end
        object N21: TMenuItem
          Caption = '-'
        end
        object Preview2: TMenuItem
          Action = actRecyclePreview
        end
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object mnuExit: TMenuItem
        Action = actClose
      end
    end
    object mnuView: TMenuItem
      Caption = 'View'
      object mnuEventLog: TMenuItem
        Action = actLogView
      end
      object ClearEventLog1: TMenuItem
        Action = actClearEventLog
      end
      object N16: TMenuItem
        Caption = '-'
      end
      object mnuReadingPane: TMenuItem
        AutoCheck = True
        Caption = 'Reading Pa&ne'
        OnClick = mnuReadingPaneClick
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object mnuReminderWindow: TMenuItem
        Action = actReminder
      end
    end
    object mnuHelp: TMenuItem
      Caption = 'Help'
      object mnuHelpContents: TMenuItem
        Caption = 'Help Contents'
        ShortCut = 112
        OnClick = mnuHelpContentsClick
      end
      object N15: TMenuItem
        Caption = '-'
      end
      object About1: TMenuItem
        Action = actAbout
      end
    end
  end
  object alDashboard: TActionList
    Images = imgDashBoard
    Left = 338
    Top = 452
    object actArchive: TAction
      Category = 'New'
      Caption = 'Arc&hive'
      Enabled = False
      ImageIndex = 3
      ShortCut = 32840
      Visible = False
    end
    object actAddSchedule: TAction
      Category = 'New'
      Caption = '&Scheduled Task'
      ShortCut = 32851
      OnExecute = actAddScheduleExecute
    end
    object actUserLogin: TAction
      Category = 'System'
      Caption = '&User Logins'
      ImageIndex = 6
      ShortCut = 32853
      OnExecute = actUserLoginExecute
    end
    object actNewCompany: TAction
      Category = 'System'
      Caption = 'New Co&mpany'
      Enabled = False
      Visible = False
      OnExecute = actNewCompanyExecute
    end
    object ActConfiguration: TAction
      Category = 'System'
      Caption = 'Confi&guration'
      ShortCut = 32839
      OnExecute = ActConfigurationExecute
    end
    object actLinkRequest: TAction
      Category = 'New'
      Caption = 'Link &Request'
      ShortCut = 32850
      OnExecute = actLinkRequestExecute
    end
    object actClose: TAction
      Caption = 'Close'
      ShortCut = 32835
      OnExecute = actCloseExecute
    end
    object actUserPermission: TAction
      Category = 'System'
      Caption = 'User &Permissions'
      Enabled = False
      ShortCut = 32845
      Visible = False
    end
    object actRefreshCompany: TAction
      Category = 'New'
      Caption = 'Refresh Companies'
      ShortCut = 32885
      OnExecute = actRefreshCompanyExecute
    end
    object actContacts: TAction
      Category = 'System'
      Caption = 'E-Mail Con&tacts'
      ImageIndex = 2
      ShortCut = 32852
      OnExecute = actContactsExecute
    end
    object actUpdateLink: TAction
      Category = 'New'
      Caption = 'Up&date Link'
      ShortCut = 32836
      OnExecute = actUpdateLinkExecute
    end
    object actBulkExport: TAction
      Category = 'New'
      Caption = '&Bulk Export'
      ShortCut = 32834
      OnExecute = actBulkExportExecute
    end
    object actRecreate: TAction
      Category = 'Company'
      Caption = 'Recre&ate Company'
      ShortCut = 32833
      OnExecute = actRecreateExecute
    end
    object actEndLink: TAction
      Category = 'New'
      Caption = '&End Link'
      ShortCut = 32837
      OnExecute = actEndLinkExecute
    end
    object actCheckMailNow: TAction
      Category = 'Mail'
      Caption = 'Check Mail'
      ImageIndex = 8
      ShortCut = 116
      OnExecute = actCheckMailNowExecute
    end
    object actCheckDSRStatus: TAction
      Category = 'DSR'
      Caption = 'Check Service Status'
      ShortCut = 32884
      OnExecute = actCheckDSRStatusExecute
    end
    object actStartDSRService: TAction
      Category = 'DSR'
      Caption = 'Start Service'
      ShortCut = 49235
      OnExecute = actStartDSRServiceExecute
    end
    object actStopDSRService: TAction
      Category = 'DSR'
      Caption = 'Stop Service'
      ShortCut = 49222
      OnExecute = actStopDSRServiceExecute
    end
    object actAbout: TAction
      Category = 'Help'
      Caption = 'About'
      OnExecute = actAboutExecute
    end
    object actUpdateManagerPassword: TAction
      Category = 'System'
      Caption = 'Update Manager Pass&word...'
      ShortCut = 32855
      OnExecute = actUpdateManagerPasswordExecute
    end
    object actDeactivateComp: TAction
      Category = 'New'
      Caption = 'Deactivate Company'
      ShortCut = 49220
      OnExecute = actDeactivateCompExecute
    end
    object actDeleteCompany: TAction
      Category = 'Company'
      Caption = 'Delete Company'
      ShortCut = 49221
      OnExecute = actDeleteCompanyExecute
    end
    object actActivateCompany: TAction
      Category = 'Company'
      Caption = 'Activate Company'
      ShortCut = 49217
      OnExecute = actActivateCompanyExecute
    end
    object actLogView: TAction
      Caption = 'Event Log'
      ShortCut = 32844
      OnExecute = actLogViewExecute
    end
    object actReminder: TAction
      Caption = 'Reminder Window'
      OnExecute = actReminderExecute
    end
    object actDeleteInbox: TAction
      Category = 'Inbox'
      Caption = 'Delete'
      ImageIndex = 9
      OnExecute = actRemoveScheduleExecute
    end
    object actImport: TAction
      Category = 'Inbox'
      Caption = 'Import'
      ImageIndex = 11
      OnExecute = actRemoveScheduleExecute
    end
    object actDeny: TAction
      Category = 'Inbox'
      Caption = 'Deny'
      OnExecute = actRemoveScheduleExecute
    end
    object actAccept: TAction
      Category = 'Inbox'
      Caption = 'Accept'
      OnExecute = actRemoveScheduleExecute
    end
    object actRemoveSchedule: TAction
      Category = 'Outbox'
      Caption = 'Remove Schedule'
      OnExecute = actRemoveScheduleExecute
    end
    object actViewSchedule: TAction
      Category = 'Outbox'
      Caption = 'View Schedule'
      OnExecute = actRemoveScheduleExecute
    end
    object actChangeSchedule: TAction
      Category = 'Outbox'
      Caption = 'Change Schedule'
      OnExecute = actRemoveScheduleExecute
    end
    object actDeleteOutbox: TAction
      Category = 'Outbox'
      Caption = 'Delete'
      ImageIndex = 9
      OnExecute = actRemoveScheduleExecute
    end
    object actClearEventLog: TAction
      Caption = 'Clear Event Log'
      OnExecute = actClearEventLogExecute
    end
    object actSelectAllInbox: TAction
      Category = 'Inbox'
      Caption = 'Select All'
      OnExecute = actRemoveScheduleExecute
    end
    object actSelectAllOutbox: TAction
      Category = 'Outbox'
      Caption = 'Select All'
      OnExecute = actRemoveScheduleExecute
    end
    object actDeleteRecycle: TAction
      Category = 'Recycle'
      Caption = 'Delete'
      ImageIndex = 9
      OnExecute = actRemoveScheduleExecute
    end
    object actSelectAllRecycle: TAction
      Category = 'Recycle'
      Caption = 'Select All'
      OnExecute = actRemoveScheduleExecute
    end
    object actCancelLink: TAction
      Category = 'New'
      Caption = 'Cancel Link'
      OnExecute = actCancelLinkExecute
    end
    object actInboxPreview: TAction
      Category = 'Inbox'
      Caption = 'Preview'
      OnExecute = actRemoveScheduleExecute
    end
    object actOutboxPreview: TAction
      Category = 'Outbox'
      Caption = 'Preview'
      OnExecute = actRemoveScheduleExecute
    end
    object actRecyclePreview: TAction
      Category = 'Recycle'
      Caption = 'Preview'
      OnExecute = actRemoveScheduleExecute
    end
    object actViewCISResponse: TAction
      Category = 'Outbox'
      Caption = 'Check CIS Response'
      OnExecute = actRemoveScheduleExecute
    end
    object actRecycleRestore: TAction
      Category = 'Recycle'
      Caption = 'Restore'
      OnExecute = actRemoveScheduleExecute
    end
    object actResend: TAction
      Category = 'Outbox'
      Caption = 'Resend'
      ImageIndex = 7
      OnExecute = actRemoveScheduleExecute
    end
    object actSubContractorVerification: TAction
      Category = 'New'
      Caption = 'Subcontractor Verification'
      ImageIndex = 6
      OnExecute = actSubContractorVerificationExecute
    end
  end
  object imgDashBoard: TImageList
    Left = 338
    Top = 396
    Bitmap = {
      494C01010C000E00040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000004000000001002000000000000040
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
      000000000000000000000000000000000000000000000073C6000073C6000073
      BD00AD948400634A3100634A3100634A3100634A3100634A3100634A3100634A
      3100634A3100634A3100634A3100634A31000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000039739C008C8C94009C7363006BCE
      FF00BDA59400F7F7F700DEDEDE00DED6CE00DECEC600DEC6B500DEBDAD00DEB5
      A500DEB59C00DEAD9400DEAD9400634A31000000000000000000A5A5A5005252
      5200949494000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000087BCE0073CEFF00E7FFFF00DEF7
      FF00BDAD9C00FFFFFF00FFFFFF00D6C6B500D6BDAD00D6B5A500CEAD9C00CEA5
      9400C69C8C00F7D6BD00DEAD9400634A310000000000000000006B6B6B001010
      10004A4A4A00ADADAD0000000000000000000000000000000000000000000000
      000073737300A5A5A50000000000000000000000000000000000000000000000
      000000000000000000006B738C004A5AA500314AAD001039BD00314AA5003952
      A5005A638C000000000000000000000000000000000000000000BDA594006342
      3100634A3100634A3100634A3100634A3100634A3100634A3100634A3100634A
      3100634A31006B4A39000000000000000000427BA5008C949400A57B6300E7F7
      FF00C6AD9C00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFF7EF00FFEFE700FFE7
      DE00FFDED600F7DEC600DEB59C00634A31000000000000000000949494001010
      1000212121007B7B7B0000000000000000000000000000000000000000000000
      000039393900B5B5B50000000000000000000000000000000000000000000000
      000000000000425AAD00294AB5001842B5002142A50021213900293984002131
      94001031AD0042529C0000000000000000000000000000000000B5A59400FFF7
      EF00E7DED600E7D6CE00E7D6C600DECEBD00DEC6BD00DEC6BD00D6BDB500D6BD
      AD00D6BDAD006B4A390000000000000000001084CE007BCEFF00EFFFFF00E7F7
      FF00C6AD9C00FFFFFF00FFFFFF00D6C6B500D6BDAD00D6B5A500CEAD9C00CEA5
      9400C6A58C00FFDED600DEBDA500634A31000000000000000000000000006363
      63002121210042424200B5B5B500000000000000000000000000000000004A4A
      4A006B6B6B000000000000000000000000000000000063636300636363000000
      00004A63AD00294ABD003952BD008C8CA500CEAD940084736B00D69C7B009C6B
      73004A396B001831A50042529C00000000000000000000000000BDAD9C00FFF7
      F700FFF7F700FFF7EF00FFF7EF00FFEFE700FFEFE700FFEFDE00FFEFDE00FFEF
      DE00D6BDAD006B4A39000000000000000000427BA50094949400A57B63007BB5
      DE00C6B5A500FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFF7
      F700FFEFE7004A63FF001831F700634A31000000000000000000000000000000
      000042424200212121005A5A5A000000000000000000000000006B6B6B003939
      390000000000000000000000000000000000000000000000000000000000636B
      9C002952CE005A63A500BDADAD00F7CEA500F7CE9C00CEB59400F7D6A500FFCE
      AD00C6848C00393173001839A5005A638C000000000000000000C6B5A500FFFF
      FF00DEC6BD00D6C6B500FFF7EF00CEB5A500CEB5A500FFEFE700CEAD9C00CEAD
      9C00DEC6B5006B4A390000000000000000001084D60084D6FF00EFFFFF004A94
      CE00CEB5A500FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFF7F7006B84FF005263F700634A31000000000000000000000000000000
      000000000000424242002121210063636300B5B5B5005A5A5A00313131008C8C
      8C00000000000000000000000000000000006B6B6B006B6B6B00000000004263
      BD003152CE006B7BC600FFEFD600F7E7CE00F7D6BD00F7CEB500F7DEB500FFDE
      B500FFCEAD00735A8C0029398C003952A5000000000000000000CEB5A500FFFF
      FF00FFFFFF00FFFFF700FFFFF700FFF7EF00FFF7EF00FFF7E700FFEFE700FFEF
      E700DECEBD006B4A39000000000000000000AD948400735A42007B6B5A00947B
      7300CEB5A500FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00CEC6DE00C6BDDE006B4A39000000000000000000000000000000
      0000000000000000000042424200313131003131310031313100424242000000
      000000000000000000000000000000000000000000000000000000000000315A
      D6004A63BD00C6BDCE00FFF7E700FFF7EF00FFE7D600F7DECE00FFE7CE00F7DE
      B500F7CEA500C69C8C0021318C002142AD000000000000000000CEB5A500FFFF
      FF00DECEC600DECEBD00FFFFF700D6BDAD00D6C6B500FFF7EF00D6BDAD00CEB5
      A500E7D6C6006B4A39000000000000000000BDA59400F7F7F700E7DEDE00DED6
      CE00CEB5A500CEB5A500CEB5A500CEB5A500C6B5A500C6AD9C00C6AD9C00BDAD
      9C00BDA59C00BDA59400BDA59400AD9484000000000000000000000000000000
      00000000000000000000B5B5B500313131003939390042424200000000000000
      000000000000000000000000000000000000000000006B6B6B00000000002152
      EF00313963008C8C9400CECEC600FFF7F700FFF7EF00212121004A424200635A
      52009C846B00AD9C9400212129001039BD000000000000000000CEB5A500FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFF700FFFFF700FFF7F700FFF7EF00FFF7
      EF00E7D6CE006B4A39000000000000000000BDAD9C00FFFFFF00FFFFFF00D6C6
      B500B5A5A500A5A5A5009C9C9C009494940094949400F7D6BD00DEAD94008C73
      6300297BBD00D6F7FF0063C6FF00006BBD000000000000000000000000000000
      000000000000C6C6C6005A5A5A003131310039393900393939005A5A5A000000
      000000000000000000000000000000000000000000000000000000000000315A
      DE004263D600A5B5DE00FFFFF700FFFFFF00FFFFFF004A4A4A00B5AD9C00DEC6
      AD00F7CEAD00BD9C940021399C002142B5000000000000000000CEB5A500FFFF
      FF00DECEC600DECEC600FFFFFF00DEC6BD00DEC6BD00FFFFF700D6C6B500D6C6
      B500EFE7DE006B4A39000000000000000000C6AD9C00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFF7EF00FFEFE700FFE7DE00FFDED600F7DEC600DEB59C007B63
      52006BADD600A57B63008C8C9400396B94000000000000000000000000000000
      00009C9C9C00424242004242420084848400C6C6C60084848400424242007B7B
      7B00000000000000000000000000000000007373730073737300000000004A63
      C6003963DE00738CDE00FFFFFF00FFFFFF00FFFFFF0063636300EFE7DE00FFEF
      DE00FFDEBD008C7B9C002142A5003952A5000000000000000000CEB5A500FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFF700FFFF
      F700FFF7EF006B4A39000000000000000000C6AD9C00FFFFFF00FFFFFF00D6C6
      B500D6BDAD00D6B5A500CEAD9C00CEA59400C6A58C00FFDED600DEB5A5006B52
      4200DEF7FF00DEF7FF006BCEFF00006BBD000000000000000000BDBDBD007373
      730042424200424242007B7B7B00000000000000000000000000737373004242
      42007B7B7B000000000000000000000000000000000000000000000000006373
      A500315AEF00426BDE0094ADEF00FFFFFF00FFFFFF009C9C9400FFF7EF00FFEF
      DE00BDB5BD004252A5001842C6005A6B94000000000000000000EFAD8C00EFAD
      8C00EFAD8C00EFA57B00EF9C7300E78C6300E7845200E77B4200E7733900E773
      3900E7733900CE6331000000000000000000C6B5A500FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFF7F700FFEFE7004A63FF001831F700634A
      3100E7F7FF00A57B63008C8C940039739C0000000000A5A5A500737373003131
      310042424200949494000000000000000000000000000000000000000000BDBD
      BD00525252007B7B7B0000000000000000000000000073737300737373000000
      00004A6BBD00315AE7004A6BDE007B94E700D6D6EF00B5ADAD00EFE7D600949C
      C6005263A500214AC600425AAD00000000000000000000000000EFAD8C00FFC6
      A500FFBD9C00FFBD9C00FFB59400FFB58C00FFAD8400FFA57B00F7A57300F79C
      6B00F7946B00D66B39000000000000000000CEB5A500FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFF7F7006B84FF005263F700634A
      3100E7FFFF00E7F7FF006BCEFF000073C60000000000A5A5A500424242004A4A
      4A00B5B5B5000000000000000000000000000000000000000000000000000000
      0000000000009C9C9C0000000000000000000000000000000000000000000000
      0000000000005A6BB5004263D6004263DE005A73C600424A6B004263D600395A
      C600214AD6004A63AD0000000000000000000000000000000000EFAD8C00EFAD
      8C00EFAD8C00EFAD8C00EFA58400EF9C7300E7946B00E78C6300E7845200E77B
      4A00E7734200E77339000000000000000000CEB5A500FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00CEC6DE00C6BDDE00634A
      310073CEFF009C7363008C8C940039739C00000000000000000073737300BDBD
      BD00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000006373A5004A63C600315ADE002152EF00315ADE004263
      BD00636B9C000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000CEB5A500CEB5A500CEB5A500CEB5
      A500C6B5A500C6AD9C00C6AD9C00BDAD9C00BDA59C00BDA59400BDA59400AD94
      8400087BCE00087BCE00087BC6000873C6000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000006B5A52006B5A52006352
      42005A4239000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000AD948400634A3100634A3100634A3100634A3100634A3100634A3100634A
      3100634A3100634A3100634A3100634A31000000000000000000000000000000
      00000000000000000000000000008C7363008C736300D6A58C0094736300EFA5
      8400C6947300634A3900635239000000000000000000000000006B524200634A
      3900634A31006B4A390073634A006B524200634A3100634A3100634A3100634A
      3100634A3100000000000000000000000000000000009C6B4A00844221007B39
      18007B3910007B31080073310800733108007331080073310800733108007331
      080073310800733108007331080000000000735A4200735A4200735A42000000
      0000BDA59400F7F7F700DEDEDE00DED6CE00DECEC600DEC6B500DEBDAD00DEB5
      A500DEB59C00DEAD9400DEAD9400634A31000000000000000000000000000000
      00000000000000000000000000008C736B009C8C7B00F7DECE00DEC6B500F7CE
      BD00F7BDA500AD7B6300635239000000000000000000BDAD9C00F7EFEF00E7D6
      D600E7CEC600DEC6B500948CB500D6BDB500D6B5A500D6B5A500D6AD9400D6AD
      9400CE9C8C00634A31000000000000000000000000009C6B5200FFFFFF00FFFF
      FF00CECED600185AAD00004AAD0000429C00003994000039840000317B00BDA5
      9C00E7C6AD00DEBDAD0073310800000000000000000000000000000000000000
      0000BDAD9C00FFFFFF00FFFFFF00D6C6B500D6BDAD00D6B5A500CEAD9C00CEA5
      9400C69C8C00F7D6BD00DEAD9400634A31000000000000000000000000000000
      0000000000000000000084736B00E7CEDE00FFF7F700FFEFE700F7E7DE00F7D6
      C600EFC6AD00F7BD9C00C69473005A42390000000000BDAD9C00FFF7EF00F7EF
      EF00F7EFE700214ABD001029BD006B73CE00EFD6C600EFD6C600EFCEBD00EFCE
      BD00D6AD9400634A31000000000000000000000000009C735200FFFFFF00FFFF
      FF001052B500317BD6004A8CE7004284DE0000429C00186BDE00084AA5000029
      6B00E7C6BD00E7C6B5007331080000000000735A4200735A4200735A42000000
      0000C6AD9C00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFF7EF00FFEFE700FFE7
      DE00FFDED600F7DEC600DEB59C00634A3100000000001884B500107BAD00187B
      AD003194BD006BADCE008C7B7300F7F7F700FFFFFF00EFEFE70084736B00A594
      8400B59C8C00CEA58C00DE9C7B006B4A4A0000000000BDAD9C00FFF7EF00D6D6
      E700214ABD002952EF002942DE001029BD009C9CC600EFD6C600EFD6C600DEC6
      B500D6AD9400634A3100000000000000000000000000A5735A00FFFFFF00FFFF
      FF00185ABD0084ADE7005A94E70000429C00186BE700004AB500186BE700104A
      A500EFCEC600E7CEBD0073310800000000000000000000000000000000000000
      0000C6AD9C00FFFFFF00FFFFFF00D6C6B500D6BDAD00D6B5A500CEAD9C00CEA5
      9400C6A58C00FFDED600DEBDA500634A31001884B5004AB5E7002184BD009CF7
      F70084D6F700B5E7F700A5949400BDB5AD00F7F7EF00FFF7F7007B6B63006B5A
      4A008C7B6B00947B6B00CE9C7B00634A420000000000C6AD9C00FFF7F700214A
      BD002952F7006B7BFF00526BF700425AE700214ABD00D6CED600EFD6CE00E7CE
      C600D6AD9400634A3100000000000000000000000000A57B6300FFFFFF00FFFF
      FF00B5C6CE001052AD00185AB500CED6DE00FFFFF7000052BD0000428C00C6BD
      BD00EFDECE00EFD6C6007331080000000000735A4200735A4200735A42000000
      0000C6B5A500FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFF7
      F700FFEFE7004A63FF001831F700634A3100218CBD005AC6F700218CBD009CFF
      FF0084E7FF00BDEFFF00ADB5AD00F7F7EF00FFFFFF00FFFFFF00F7F7EF008473
      63007B635A00E7BDAD00E7BDA500734A5A0000000000C6AD9C00FFFFF7008C94
      FF007B94FF007B94FF00D6D6E7007B8CEF00425AE7004A52B500EFD6CE00EFD6
      CE00D6B5A500634A3900000000000000000000000000AD846B00FFFFFF00FFFF
      FF00F7F7F700CED6D60063636B005252520063636300004AA500B5B5BD00F7EF
      E700F7E7DE00EFDED60073310800000000000000000000000000000000000000
      0000CEB5A500FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFF7F7006B84FF005263F700634A3100298CC60063CEFF002994C6009CFF
      FF008CEFFF00B5F7FF00C6E7E700B5B5AD009C948C00FFFFFF00D6CEC600E7DE
      D6006B5A4A0084736300846B5A000000000000000000CEB5A500FFFFFF00E7E7
      FF00C6C6F700F7EFEF00F7EFE700DEDEE7007B8CEF00294AD6006363B500EFDE
      D600DEC6B5007B5A4200000000000000000000000000B58C7300FFFFFF00FFFF
      FF00C6C6C60000000000C6C6C600A5A5A50084848400525252009C9C9C00FFF7
      EF00F7EFE700F7E7DE007331080000000000AD948400735A4200735A4200735A
      4200CEB5A500FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00CEC6DE00C6BDDE006B4A3900298CC60063CEFF00319CCE00C6FF
      FF009CF7FF00ADF7FF00D6F7F700BDBDBD00BDBDB500F7F7F700ADA59C00FFEF
      EF00C6B5AD006B5A4A0073736B000000000000000000CEB5A500FFFFFF00FFFF
      FF00FFFFF700FFF7F700FFF7EF00F7EFE700EFE7E7007384F700294AD600948C
      B500E7CEC60084735A00000000000000000000000000B5947B00FFFFFF00FFFF
      FF003939390029292900D6D6D600C6C6C600A5A5A5008484840063636300FFF7
      F700FFF7EF00F7EFE7007331080000000000BDA59400F7F7F700E7DEDE00DED6
      CE00CEB5A500CEB5A500CEB5A500CEB5A500C6B5A500C6AD9C00C6AD9C00BDAD
      9C00BDA59C00BDA59400BDA59400AD9484002994C6006BD6FF0042A5CE00DEFF
      FF00A5FFFF00A5FFFF00C6FFFF00D6FFFF00CEEFE700B5B5AD008C7B73007B73
      630073635200B5C6C6005AA5C6000000000000000000CEBDAD00FFFFFF00FFFF
      FF00FFFFFF00FFF7F700FFF7F700F7EFEF00EFE7E700F7E7E7007B8CEF00294A
      D600948CB5009C8C7B00000000000000000000000000BD948400FFFFFF00FFFF
      FF00525252004A4A4A00B5B5B500D6D6D600C6C6C600A5A5A50073737300FFFF
      FF00FFFFF700FFF7F7007331080000000000BDAD9C00FFFFFF00FFFFFF00D6C6
      B500B5A5A500A5A5A5009C9C9C009494940094949400F7D6BD00DEAD9400735A
      4200000000000000000000000000000000002994C6007BE7FF003194C600FFFF
      FF00FFFFFF00F7FFFF00F7FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00F7FFFF00EFF7FF003994BD000000000000000000CEBDAD00FFFFFF00FFFF
      FF00849CAD00638C9C00638C9C005A848C005A848C005A848C008CADB5008C9C
      EF00294AD600AD9C8C00000000000000000000000000BD9C8400FFFFFF00FFFF
      FF007B7B7B00636363005A5A5A006B6B6B005A5A5A00C6C6C60084848400FFFF
      FF00FFFFFF00FFFFFF007B31080000000000C6AD9C00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFF7EF00FFEFE700FFE7DE00FFDED600F7DEC600DEB59C00735A
      420000000000735A4200735A4200735A42003194CE0084EFFF0084E7FF002994
      C6002994C600218CBD00218CBD00218CBD00218CBD002184BD001884B500187B
      B5002184B5002984B5002184B5000000000000000000D6BDB500FFFFFF00FFFF
      FF008CADB50094DEE7009CE7F7007BD6EF0063C6DE00529CB5006B7B8400EFE7
      DE00EFD6CE00AD9C8C00000000000000000000000000C6A58C00FFFFFF00FFFF
      FF00C6C6C6006B6B6B0084848400A5A5A5008C8C8C0052525200ADADAD00FFFF
      FF00FFFFFF00FFFFFF007B39100000000000C6AD9C00FFFFFF00FFFFFF00D6C6
      B500D6BDAD00D6B5A500CEAD9C00CEA59400C6A58C00FFDED600DEB5A5006B52
      420000000000000000000000000000000000319CCE0094F7FF008CF7FF008CF7
      FF008CF7FF008CF7FF008CF7FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00107BAD0000000000000000000000000000000000DEC6B500FFFFFF00FFFF
      FF00F7FFFF007BA5B500ADADAD009C8C7B0073C6D6004A738400F7EFEF00EFE7
      DE00EFE7DE0084735A00000000000000000000000000C6A59400FFFFFF00FFFF
      FF00F7F7F700BDBDBD008C8C8C008C8C8C0084848400B5B5B500F7F7F700FFFF
      FF00FFFFFF00FFFFFF007B39180000000000C6B5A500FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFF7F700FFEFE7004A63FF001831F700634A
      310000000000735A4200735A4200735A4200319CCE00F7F7FF009CFFFF009CFF
      FF009CFFFF009CFFFF00F7F7F700218CBD002184BD001884B5001884B5001884
      B500187BB5000000000000000000000000000000000000000000DEC6B500D6BD
      B500CEBDAD007BA5B500ADE7EF009CE7F70094DEE70042637300BDAD9C00BDAD
      9C00BDAD9C0000000000000000000000000000000000CEAD9400FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF008442210000000000CEB5A500FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFF7F7006B84FF005263F700634A
      31000000000000000000000000000000000000000000319CCE00F7F7FF00FFFF
      FF00FFFFFF00F7F7F700298CC600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084BDC6007BA5B5006B94A50000000000000000000000
      00000000000000000000000000000000000000000000CEAD9400CEAD9400C6A5
      9400C6A58C00BD9C8400BD948400B5947B00B58C7300AD846B00A57B6300A573
      5A009C7352009C6B52009C6B4A0000000000CEB5A500FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00CEC6DE00C6BDDE00634A
      310000000000735A4200735A4200735A42000000000000000000319CCE00319C
      CE003194CE002994C60000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000CEB5A500CEB5A500CEB5A500CEB5
      A500C6B5A500C6AD9C00C6AD9C00BDAD9C00BDA59C00BDA59400BDA59400AD94
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B5A59400634A3100634A3100634A
      3100634A3100634A3100634A3100634A3100634A310000000000000000000000
      000000000000000000000000000000000000BDA59400634A3100634A3100634A
      3100634A3900634A3100634A3100634A3100634A3100634A3100634A3100634A
      3100634A3100634A3100634A3100634A31000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000846B5200846B5A00846B
      5A00846B5200846B520084635200735A4200735242006B523900634A31006B52
      420000000000000000000000000000000000B5A59400FFFFFF00EFE7DE00EFDE
      D600E7DED600E7D6CE00DECEBD00D6C6BD00634A310000000000000000000000
      000000000000000000000000000000000000BDA59400DEB5A500C69C8400B58C
      6B00DEB5A500CEA58C00B58C7300DEB5A500C69C8400B58C6B00DEB5A500C69C
      8400B58C6B00D6AD8C00BD9C7B00634A3100B5A59400CEBDAD00B5524200A539
      39007B1829005A3921005A3921009C8484007B634A00634A3100634A3100634A
      3100634A3100634A3100634A3100634A31009C847300FFEFE700E7D6CE00DEC6
      BD00CEB5A500BDAD9C00BDA59400BDA59400B5A58C00B59C8C009C8C7B008C73
      6300634A3900000000000000000000000000B5A59400FFFFFF00EFB59C00E7B5
      9400DEAD9400D6A59400CEA58C00D6C6BD00634A3100634A3100634A3100634A
      3100634A3100634A3100634A3100634A3100C6AD9C00FFFFFF00FFFFFF00C69C
      7B00FFFFFF00FFFFF700C69C7B00FFF7EF00FFF7EF00BD947B00FFEFDE00FFEF
      E700C69C7B00FFE7CE00D6BDAD00634A3100B5A59400B5735A00FF9C7300FFBD
      9400A5393900CE6B3100A53939005A392100E7C6AD00DEBDA500DEBDA500DEBD
      A500DEB59C00E7AD9400E7AD9400634A3100A5847300FFFFFF00FFF7EF00FFEF
      E700FFEFE700FFE7DE00F7DECE00F7D6BD00F7CEB500EFC6A500F7BD9400AD94
      8400735242006B4A39000000000000000000BDA59400FFFFFF00FFFFFF00FFF7
      F700F7EFEF00EFE7DE00EFDED600D6C6BD00634A3100E7CEBD00DEC6B500DEBD
      AD00D6B5A500D6AD9400CEA58C00634A3100C6AD9C00FFFFFF00FFFFFF00CEA5
      8400FFFFFF00FFFFFF00CEA58400FFF7EF00FFF7EF00CEA58400FFEFE700FFEF
      DE00CEA58400FFE7D600D6BDAD00634A3100BDA59400B58C7B00F7C6AD00F79C
      6300A5393900CE6B3100CE6B31006B4A39002963290031393100D6C6B500F7D6
      C600F7D6C600F7D6C600DEB59C00634A3100A58C7B0000000000000000000000
      000000000000FFFFFF00FFFFF700FFEFEF00F7E7DE00F7E7DE00F7D6C600BDA5
      94007B6352006B5239006B52420000000000C6AD9C00FFFFFF00EFB59C00E7B5
      9400DEAD9400D6A59400CEA58C00D6C6BD00634A3100F7EFE700F7E7DE00EFDE
      D600EFD6C600E7CEBD00D6AD9400634A3100C6AD9C00D6AD9400C69C7B00B58C
      6B00CEA58400BD947B00B58C6B00CEA58400BD947B000842EF000031D6000031
      D6000029BD00CEA58400BD947B00634A3100BDAD9C00EFDECE00BD947B00E794
      7B00FFBD9400B5524200A5393900ADD6AD0039AD4A0039AD4A0031393100DEBD
      A500BD947B00BD947B00DEB59C00634A3100AD9C8C00A58C7B00A58C7B00A58C
      7B00A58C7B009C8473009C8473009C847300947B6B0084847B008C7B6B00947B
      6B00947B6300735A4A006B5242006B524200C6B5A500FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00F7EFE700DED6D600D6C6BD00634A3100C6B5AD00F7EFE700F7E7
      DE00EFDED600EFD6C600D6B5A500634A3100CEB5A500FFFFFF00FFFFFF00BD94
      7B00FFFFFF00FFFFFF00BD947B00FFFFFF00FFF7F700215AF700FFF7F700FFF7
      EF000031D600FFE7DE00D6C6B500634A3100BDAD9C00FFFFF700FFFFF7006363
      6300636B6B008C735A00BDE7BD0039AD4A004AC6630039AD4A0031733900F7D6
      C600F7D6C600F7D6C600DEBDA500634A3100000000008C9CA500BDF7FF00ADEF
      FF009CEFFF0084DEFF0073D6F70063CEF70052C6EF0039B5E7001894C600526B
      730094847B008C73630073524200634A3900CEBDAD00FFFFFF00EFB59C00E7B5
      9400DEAD9400B5A59400634A3100634A3100634A3100D6C6BD00D6CEC600F7EF
      E700F7E7DE00EFDED600DEBDAD00634A3100CEB5A500FFFFFF00FFFFFF00CEA5
      8400FFFFFF00FFFFFF00CEA58400FFFFFF00FFFFFF004A7BF700FFFFFF00FFF7
      F7000031D600FFEFE700D6C6B500634A3100C6ADA500FFFFF70031393100C6C6
      C600ADADAD00636B6B009CAD9C0094CE940039AD4A005A8C5200C6C6C600C694
      8C00BD947B00BD947B00DEBDA500634A3100000000008C9CAD00C6F7FF00B5EF
      FF00ADEFFF0094E7FF0084DEFF0073D6FF005ACEF7004ABDEF0021A5D6004A73
      8400398CAD00947B6B00846B5A0073524200D6BDAD00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00BDA59400D6C6BD00634A3100E7DEDE00FFFFFF00FFFFF700FFF7
      EF001842D60021429C00DEC6B500634A3100CEB5A500D6AD9400C69C7B00B58C
      6B00CEA58400BD947B00B58C6B00CEA58400BD947B007394FF004A7BF700215A
      F7000842EF00CEA58400C69C7B00634A3100CEB5A500F7F7F70052525200D6D6
      D600C6C6C600A5A59C007B7B7B006B635A005A8C5200D6D6D600FFEFDE00F7E7
      DE00F7E7D600F7E7D600D6BDB500634A3100000000008CA5AD00C6F7FF00BDF7
      FF00BDF7FF00ADF7FF00A5EFFF0094E7FF0084DEFF0073D6FF0052C6FF005A84
      94001894C600526B730084736300846B5A00DEC6B500FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00C6B5A500634A3100E7DEDE000000000000000000FFFFFF00FFF7
      F700395AF7001842D600E7CEBD00634A3100CEB5A500FFFFFF00FFFFFF00BD94
      7B00FFFFFF00FFFFFF00BD947B00FFFFFF00FFFFFF00BD947B00FFFFFF00FFF7
      F700BD947B00FFF7EF00E7DED600634A3900CEB5AD00FFF7F7005A5A5A007B7B
      7B0084848400CECECE009C949400ADADAD005A5A5A006B6B6B00FFB59400F7AD
      8400F7A57300F79C7300D6C6B500634A3100000000008CA5AD008CA5AD008CA5
      AD008C9CAD008C9CAD008CA5AD00849CA500849CA500849CA50084A5B5007BD6
      F700189CD6004A738400318CAD0084736300DEC6B500DEC6B500D6BDAD00D6BD
      AD00CEBDAD00CEB5A500EFE7DE0000000000000000000000000000000000FFFF
      FF00FFF7F700FFF7EF00F7EFE700634A3100CEB5A500FFFFFF00FFFFFF00CEA5
      8400FFFFFF00FFFFFF00CEA58400FFFFFF00FFFFFF00CEA58400FFFFFF00FFFF
      FF00CEA58400FFF7EF00FFF7EF00634A3100CEBDAD00FFFFFF0063636300C6C6
      C6008C8C8C004A4A4A0073737300C6C6C600B5B5B50073737300FFF7EF00FFF7
      EF00FFEFE700FFEFE700D6C6BD006B4A3900000000008CA5AD00B5E7EF00BDF7
      FF0094E7F7008CA5AD00ADD6DE00ADF7FF00A5EFFF008CE7FF0084DEFF007BDE
      FF0052C6FF005A7B8C001894C60042636B00000000000000000000000000C6AD
      A500EFDECE00EFDECE00EFDECE00EFDECE00E7D6CE00E7CEC600E7C6BD00DEBD
      AD00DEB5A500D6AD9C00D6AD9400AD948C00EFAD8C00EFAD8C00EFA58400EFA5
      8400E7A57B00E79C7300E79C7300E7946B00E78C6300E78C5A00E7845200E77B
      4A00E77B4200E7733900DE733900CE6B3900D6BDB500FFFFFF00FFFFFF007373
      7300636363004A4A4A007B7B7B008C8C8C00D6D6D6009CAD9C00FFFFF700FFF7
      F700FFF7EF00FFF7EF00CEC6C600735A420000000000000000008CA5AD008CA5
      AD0094ADBD00A5C6CE008CA5AD008C9CAD008CA5AD00849CA500849CA500849C
      A50084A5B5007BCEF700189CD6004A7384000000000000000000000000000000
      0000CEB5AD00F7EFEF00FFFFFF00FFF7F700FFF7EF00F7EFE700F7E7DE00F7DE
      D600EFDECE00EFD6CE00B59C8C0000000000EFAD8C00FFEFE700FFEFE700FFEF
      E700FFEFDE00FFEFDE00FFE7DE00FFAD8400FFAD8400F7A57B00F7A57B00F7A5
      7B00F7A57B00F7A57B00F79C7300CE6B3900D6C6B500FFFFFF00FFFFFF00FFFF
      FF00FFFFFF006B636B00C6C6C6008C8C8C004A4A4A006B736B00FFFFFF00FFFF
      FF00FFFFF700FFFFF700FFFFFF007B634A000000000000000000000000008CA5
      AD00B5E7EF00B5EFFF0094E7F70094ADB500ADD6DE00ADF7FF00A5EFFF0094E7
      FF0084DEFF007BDEFF0052C6FF005A7B8C000000000000000000000000000000
      000000000000CEB5AD00F7EFEF0000000000FFFFFF00FFF7F700F7EFEF00F7EF
      E700EFD6CE00B59C8C000000000000000000EFAD8C00EFA58400EFA58400E7A5
      7B00E79C7300E79C7300E7946B00DE8C6300DE845A00DE845A00D6734A00D673
      4A00D6734A00CE6B3900CE6B3900CE6B3900D6C6B500D6C6B500D6BDB500D6BD
      B500CEBDAD00DED6CE007373630052524A006B635A00D6CEC600BDA59400BDA5
      9400B5A59400B5A59400B5A59400B5A594000000000000000000000000000000
      00008CA5AD008CA5AD0094B5BD00A5C6CE008C9CAD008C9CAD008CA5AD00849C
      A500849CA5008494A5008494A500000000000000000000000000000000000000
      00000000000000000000CEB5AD00F7EFEF0000000000FFFFFF00FFFFF700F7EF
      EF00B59C9400000000000000000000000000A5A5A500000000008C8C8C000000
      00008C8C8C00000000008C8C8C00000000008C8C8C00000000006B736B000000
      000063636300FFFFFF0063635200D6D6D6000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008CA5AD00B5E7EF00B5EFFF0094E7F7008CA5AD00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000C6ADA500C6ADA500C6ADA500C6AD9C00C6AD
      9C00000000000000000000000000000000000000000018211800E7E7E7001821
      1800E7E7E70018211800EFE7E70018211800D6D6D60018211800D6D6D6001821
      1800EFEFEF0018211800E7E7E700A5A5A5000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000008CA5AD008CA5AD008CA5AD0000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000400000000100010000000000000200000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000008000FFFFFFFFFFFF0000C7FFFFFFFFFF
      0000C3F3FC07C0030000C3F3F803C0030000E1E79001C0030000F1CFE000C003
      0000F80F2000C0030000FC1FE000C0030000FC3FA000C0030000F81FE000C003
      0000F00F2000C0030000C1C7E000C003000083E39001C003000087FBF803C003
      0000CFFFFC07FFFF0000FFFFFFFFFFFFFF87FFFFFFFFF000FE01C00780011000
      FE0180038001F000FC00800380011000800080038001F0000000800380011000
      000080038001F00000018003800100000001800380010000000180038001000F
      0001800380010008000180038001000F00078003800100080007C0078001000F
      81FFFC7F80010008C3FFFFFFFFFF000FFFFFFFFFFFFFFFFF007F0000FFFF800F
      007F000000000007000000000000000300000000000078010000000000000000
      00000000000080000000000000008000000000000000800000C0000000008000
      01E0000000008000E00000000000C000F00100000000E000F90300000000F001
      FC875550FFFFF83FFE0F8000FFFFFC7F00000000000000000000000000000000
      000000000000}
  end
  object AdvMenuStyler: TAdvMenuOfficeStyler
    AutoThemeAdapt = False
    Style = osOffice2007Luna
    Background.Position = bpCenter
    Background.Color = 16185078
    Background.ColorTo = 16185078
    IconBar.Color = 15658729
    IconBar.ColorTo = 15658729
    IconBar.CheckBorder = clNavy
    IconBar.RadioBorder = clNavy
    IconBar.SeparatorColor = 12961221
    SelectedItem.Color = 15465983
    SelectedItem.ColorTo = 11267071
    SelectedItem.ColorMirror = 6936319
    SelectedItem.ColorMirrorTo = 9889023
    SelectedItem.BorderColor = 10079963
    SelectedItem.Font.Charset = DEFAULT_CHARSET
    SelectedItem.Font.Color = clWindowText
    SelectedItem.Font.Height = -11
    SelectedItem.Font.Name = 'Tahoma'
    SelectedItem.Font.Style = []
    SelectedItem.CheckBorder = clNavy
    SelectedItem.RadioBorder = clNavy
    RootItem.Color = 15915714
    RootItem.ColorTo = 15784385
    RootItem.GradientDirection = gdVertical
    RootItem.Font.Charset = DEFAULT_CHARSET
    RootItem.Font.Color = clMenuText
    RootItem.Font.Height = -11
    RootItem.Font.Name = 'Tahoma'
    RootItem.Font.Style = []
    RootItem.SelectedColor = 7778289
    RootItem.SelectedColorTo = 4296947
    RootItem.SelectedColorMirror = 946929
    RootItem.SelectedColorMirrorTo = 5021693
    RootItem.SelectedBorderColor = 4548219
    RootItem.HoverColor = 15465983
    RootItem.HoverColorTo = 11267071
    RootItem.HoverColorMirror = 6936319
    RootItem.HoverColorMirrorTo = 9889023
    RootItem.HoverBorderColor = 10079963
    Glyphs.SubMenu.Data = {
      5A000000424D5A000000000000003E0000002800000004000000070000000100
      0100000000001C0000000000000000000000020000000200000000000000FFFF
      FF0070000000300000001000000000000000100000003000000070000000}
    Glyphs.Check.Data = {
      7E000000424D7E000000000000003E0000002800000010000000100000000100
      010000000000400000000000000000000000020000000200000000000000FFFF
      FF00FFFF0000FFFF0000FFFF0000FFFF0000FDFF0000F8FF0000F07F0000F23F
      0000F71F0000FF8F0000FFCF0000FFEF0000FFFF0000FFFF0000FFFF0000FFFF
      0000}
    Glyphs.Radio.Data = {
      7E000000424D7E000000000000003E0000002800000010000000100000000100
      010000000000400000000000000000000000020000000200000000000000FFFF
      FF00FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FC3F0000F81F0000F81F
      0000F81F0000F81F0000FC3F0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000}
    SideBar.Font.Charset = DEFAULT_CHARSET
    SideBar.Font.Color = clWhite
    SideBar.Font.Height = -19
    SideBar.Font.Name = 'Tahoma'
    SideBar.Font.Style = [fsBold, fsItalic]
    SideBar.Image.Position = bpCenter
    SideBar.Background.Position = bpCenter
    SideBar.SplitterColorTo = clBlack
    Separator.Color = 12961221
    Separator.GradientType = gtBoth
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMenuText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    MenuBorderColor = clSilver
    Left = 368
    Top = 424
  end
  object AdvToolBarStyler: TAdvToolBarOfficeStyler
    Style = bsOffice2007Luna
    AdvMenuStyler = AdvMenuStyler
    BorderColor = 14668485
    BorderColorHot = 14731181
    ButtonAppearance.Color = 15524577
    ButtonAppearance.ColorTo = 11769496
    ButtonAppearance.ColorChecked = 9229823
    ButtonAppearance.ColorCheckedTo = 5812223
    ButtonAppearance.ColorDown = 5149182
    ButtonAppearance.ColorDownTo = 9556991
    ButtonAppearance.ColorHot = 13432063
    ButtonAppearance.ColorHotTo = 9556223
    ButtonAppearance.BorderDownColor = 7293771
    ButtonAppearance.BorderHotColor = 7293771
    ButtonAppearance.BorderCheckedColor = 7293771
    ButtonAppearance.CaptionFont.Charset = ANSI_CHARSET
    ButtonAppearance.CaptionFont.Color = clWindowText
    ButtonAppearance.CaptionFont.Height = -11
    ButtonAppearance.CaptionFont.Name = 'Arial'
    ButtonAppearance.CaptionFont.Style = []
    CaptionAppearance.CaptionColor = 15915714
    CaptionAppearance.CaptionColorTo = 15784385
    CaptionAppearance.CaptionTextColor = 11168318
    CaptionAppearance.CaptionBorderColor = 13021361
    CaptionAppearance.CaptionColorHot = 16769224
    CaptionAppearance.CaptionColorHotTo = 16772566
    CaptionAppearance.CaptionTextColorHot = 11168318
    CaptionFont.Charset = DEFAULT_CHARSET
    CaptionFont.Color = clWindowText
    CaptionFont.Height = -11
    CaptionFont.Name = 'MS Sans Serif'
    CaptionFont.Style = []
    ContainerAppearance.LineColor = clBtnShadow
    ContainerAppearance.Line3D = True
    Color.Color = 15587527
    Color.ColorTo = 16181721
    Color.Direction = gdVertical
    ColorHot.Color = 16773606
    ColorHot.ColorTo = 16444126
    ColorHot.Direction = gdVertical
    CompactGlowButtonAppearance.BorderColor = 14727579
    CompactGlowButtonAppearance.BorderColorHot = 15193781
    CompactGlowButtonAppearance.BorderColorDown = 12034958
    CompactGlowButtonAppearance.BorderColorChecked = 12034958
    CompactGlowButtonAppearance.Color = 15653832
    CompactGlowButtonAppearance.ColorTo = 16178633
    CompactGlowButtonAppearance.ColorChecked = 14599853
    CompactGlowButtonAppearance.ColorCheckedTo = 13544844
    CompactGlowButtonAppearance.ColorDisabled = 15921906
    CompactGlowButtonAppearance.ColorDisabledTo = 15921906
    CompactGlowButtonAppearance.ColorDown = 14599853
    CompactGlowButtonAppearance.ColorDownTo = 13544844
    CompactGlowButtonAppearance.ColorHot = 16250863
    CompactGlowButtonAppearance.ColorHotTo = 16246742
    CompactGlowButtonAppearance.ColorMirror = 15586496
    CompactGlowButtonAppearance.ColorMirrorTo = 16245200
    CompactGlowButtonAppearance.ColorMirrorHot = 16247491
    CompactGlowButtonAppearance.ColorMirrorHotTo = 16246742
    CompactGlowButtonAppearance.ColorMirrorDown = 16766645
    CompactGlowButtonAppearance.ColorMirrorDownTo = 13014131
    CompactGlowButtonAppearance.ColorMirrorChecked = 16766645
    CompactGlowButtonAppearance.ColorMirrorCheckedTo = 13014131
    CompactGlowButtonAppearance.ColorMirrorDisabled = 11974326
    CompactGlowButtonAppearance.ColorMirrorDisabledTo = 15921906
    CompactGlowButtonAppearance.GradientHot = ggVertical
    CompactGlowButtonAppearance.GradientMirrorHot = ggVertical
    CompactGlowButtonAppearance.GradientDown = ggVertical
    CompactGlowButtonAppearance.GradientMirrorDown = ggVertical
    CompactGlowButtonAppearance.GradientChecked = ggVertical
    DockColor.Color = 15587527
    DockColor.ColorTo = 16445929
    DockColor.Direction = gdHorizontal
    DockColor.Steps = 128
    DragGripStyle = dsNone
    FloatingWindowBorderColor = 14922381
    FloatingWindowBorderWidth = 1
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    GlowButtonAppearance.BorderColor = 14727579
    GlowButtonAppearance.BorderColorHot = 10079963
    GlowButtonAppearance.BorderColorDown = 4548219
    GlowButtonAppearance.BorderColorChecked = 4548219
    GlowButtonAppearance.Color = 15653832
    GlowButtonAppearance.ColorTo = 16178633
    GlowButtonAppearance.ColorChecked = 11918331
    GlowButtonAppearance.ColorCheckedTo = 7915518
    GlowButtonAppearance.ColorDisabled = 15921906
    GlowButtonAppearance.ColorDisabledTo = 15921906
    GlowButtonAppearance.ColorDown = 7778289
    GlowButtonAppearance.ColorDownTo = 4296947
    GlowButtonAppearance.ColorHot = 15465983
    GlowButtonAppearance.ColorHotTo = 11332863
    GlowButtonAppearance.ColorMirror = 15586496
    GlowButtonAppearance.ColorMirrorTo = 16245200
    GlowButtonAppearance.ColorMirrorHot = 5888767
    GlowButtonAppearance.ColorMirrorHotTo = 10807807
    GlowButtonAppearance.ColorMirrorDown = 946929
    GlowButtonAppearance.ColorMirrorDownTo = 5021693
    GlowButtonAppearance.ColorMirrorChecked = 10480637
    GlowButtonAppearance.ColorMirrorCheckedTo = 5682430
    GlowButtonAppearance.ColorMirrorDisabled = 11974326
    GlowButtonAppearance.ColorMirrorDisabledTo = 15921906
    GlowButtonAppearance.GradientHot = ggVertical
    GlowButtonAppearance.GradientMirrorHot = ggVertical
    GlowButtonAppearance.GradientDown = ggVertical
    GlowButtonAppearance.GradientMirrorDown = ggVertical
    GlowButtonAppearance.GradientChecked = ggVertical
    GroupAppearance.BorderColor = 12763842
    GroupAppearance.Color = 15851212
    GroupAppearance.ColorTo = 14213857
    GroupAppearance.ColorMirror = 14213857
    GroupAppearance.ColorMirrorTo = 10871273
    GroupAppearance.Font.Charset = DEFAULT_CHARSET
    GroupAppearance.Font.Color = clWindowText
    GroupAppearance.Font.Height = -11
    GroupAppearance.Font.Name = 'Tahoma'
    GroupAppearance.Font.Style = []
    GroupAppearance.Gradient = ggVertical
    GroupAppearance.GradientMirror = ggVertical
    GroupAppearance.TextColor = 9126421
    GroupAppearance.CaptionAppearance.CaptionColor = 15915714
    GroupAppearance.CaptionAppearance.CaptionColorTo = 15784385
    GroupAppearance.CaptionAppearance.CaptionTextColor = 11168318
    GroupAppearance.CaptionAppearance.CaptionColorHot = 16769224
    GroupAppearance.CaptionAppearance.CaptionColorHotTo = 16772566
    GroupAppearance.CaptionAppearance.CaptionTextColorHot = 11168318
    GroupAppearance.PageAppearance.BorderColor = 12763842
    GroupAppearance.PageAppearance.Color = 14086910
    GroupAppearance.PageAppearance.ColorTo = 16382457
    GroupAppearance.PageAppearance.ColorMirror = 16382457
    GroupAppearance.PageAppearance.ColorMirrorTo = 16382457
    GroupAppearance.PageAppearance.Gradient = ggVertical
    GroupAppearance.PageAppearance.GradientMirror = ggVertical
    GroupAppearance.TabAppearance.BorderColor = 10534860
    GroupAppearance.TabAppearance.BorderColorHot = 10534860
    GroupAppearance.TabAppearance.BorderColorSelected = 10534860
    GroupAppearance.TabAppearance.BorderColorSelectedHot = 10534860
    GroupAppearance.TabAppearance.BorderColorDisabled = clNone
    GroupAppearance.TabAppearance.BorderColorDown = clNone
    GroupAppearance.TabAppearance.Color = clBtnFace
    GroupAppearance.TabAppearance.ColorTo = clWhite
    GroupAppearance.TabAppearance.ColorSelected = 10412027
    GroupAppearance.TabAppearance.ColorSelectedTo = 12249340
    GroupAppearance.TabAppearance.ColorDisabled = clNone
    GroupAppearance.TabAppearance.ColorDisabledTo = clNone
    GroupAppearance.TabAppearance.ColorHot = 14542308
    GroupAppearance.TabAppearance.ColorHotTo = 16768709
    GroupAppearance.TabAppearance.ColorMirror = clWhite
    GroupAppearance.TabAppearance.ColorMirrorTo = clWhite
    GroupAppearance.TabAppearance.ColorMirrorHot = 14016477
    GroupAppearance.TabAppearance.ColorMirrorHotTo = 10736609
    GroupAppearance.TabAppearance.ColorMirrorSelected = 12249340
    GroupAppearance.TabAppearance.ColorMirrorSelectedTo = 13955581
    GroupAppearance.TabAppearance.ColorMirrorDisabled = clNone
    GroupAppearance.TabAppearance.ColorMirrorDisabledTo = clNone
    GroupAppearance.TabAppearance.Font.Charset = DEFAULT_CHARSET
    GroupAppearance.TabAppearance.Font.Color = clWindowText
    GroupAppearance.TabAppearance.Font.Height = -11
    GroupAppearance.TabAppearance.Font.Name = 'Tahoma'
    GroupAppearance.TabAppearance.Font.Style = []
    GroupAppearance.TabAppearance.Gradient = ggRadial
    GroupAppearance.TabAppearance.GradientMirror = ggRadial
    GroupAppearance.TabAppearance.GradientHot = ggVertical
    GroupAppearance.TabAppearance.GradientMirrorHot = ggVertical
    GroupAppearance.TabAppearance.GradientSelected = ggVertical
    GroupAppearance.TabAppearance.GradientMirrorSelected = ggVertical
    GroupAppearance.TabAppearance.GradientDisabled = ggVertical
    GroupAppearance.TabAppearance.GradientMirrorDisabled = ggVertical
    GroupAppearance.TabAppearance.TextColor = 9126421
    GroupAppearance.TabAppearance.TextColorHot = 9126421
    GroupAppearance.TabAppearance.TextColorSelected = 9126421
    GroupAppearance.TabAppearance.TextColorDisabled = clWhite
    GroupAppearance.ToolBarAppearance.BorderColor = 13423059
    GroupAppearance.ToolBarAppearance.BorderColorHot = 13092807
    GroupAppearance.ToolBarAppearance.Color.Color = 15530237
    GroupAppearance.ToolBarAppearance.Color.ColorTo = 16382457
    GroupAppearance.ToolBarAppearance.Color.Direction = gdHorizontal
    GroupAppearance.ToolBarAppearance.ColorHot.Color = 15660277
    GroupAppearance.ToolBarAppearance.ColorHot.ColorTo = 16645114
    GroupAppearance.ToolBarAppearance.ColorHot.Direction = gdHorizontal
    PageAppearance.BorderColor = 14922381
    PageAppearance.Color = 16445929
    PageAppearance.ColorTo = 15587527
    PageAppearance.ColorMirror = 15587527
    PageAppearance.ColorMirrorTo = 16773863
    PageAppearance.Gradient = ggVertical
    PageAppearance.GradientMirror = ggVertical
    PagerCaption.BorderColor = 15780526
    PagerCaption.Color = 15525858
    PagerCaption.ColorTo = 15590878
    PagerCaption.ColorMirror = 15524312
    PagerCaption.ColorMirrorTo = 15723487
    PagerCaption.Gradient = ggVertical
    PagerCaption.GradientMirror = ggVertical
    PagerCaption.TextColor = clBlue
    PagerCaption.Font.Charset = DEFAULT_CHARSET
    PagerCaption.Font.Color = clWindowText
    PagerCaption.Font.Height = -11
    PagerCaption.Font.Name = 'Tahoma'
    PagerCaption.Font.Style = []
    QATAppearance.BorderColor = 11708063
    QATAppearance.Color = 16313052
    QATAppearance.ColorTo = 16313052
    QATAppearance.FullSizeBorderColor = 13476222
    QATAppearance.FullSizeColor = 15584690
    QATAppearance.FullSizeColorTo = 15386026
    RightHandleColor = 14668485
    RightHandleColorTo = 14731181
    RightHandleColorHot = 13891839
    RightHandleColorHotTo = 7782911
    RightHandleColorDown = 557032
    RightHandleColorDownTo = 8182519
    TabAppearance.BorderColor = clNone
    TabAppearance.BorderColorHot = 15383705
    TabAppearance.BorderColorSelected = 14922381
    TabAppearance.BorderColorSelectedHot = 6343929
    TabAppearance.BorderColorDisabled = clNone
    TabAppearance.BorderColorDown = clNone
    TabAppearance.Color = clBtnFace
    TabAppearance.ColorTo = clWhite
    TabAppearance.ColorSelected = 16709360
    TabAppearance.ColorSelectedTo = 16445929
    TabAppearance.ColorDisabled = clWhite
    TabAppearance.ColorDisabledTo = clSilver
    TabAppearance.ColorHot = 14542308
    TabAppearance.ColorHotTo = 16768709
    TabAppearance.ColorMirror = clWhite
    TabAppearance.ColorMirrorTo = clWhite
    TabAppearance.ColorMirrorHot = 14016477
    TabAppearance.ColorMirrorHotTo = 10736609
    TabAppearance.ColorMirrorSelected = 16445929
    TabAppearance.ColorMirrorSelectedTo = 16181984
    TabAppearance.ColorMirrorDisabled = clWhite
    TabAppearance.ColorMirrorDisabledTo = clSilver
    TabAppearance.Font.Charset = DEFAULT_CHARSET
    TabAppearance.Font.Color = clWindowText
    TabAppearance.Font.Height = -11
    TabAppearance.Font.Name = 'Tahoma'
    TabAppearance.Font.Style = []
    TabAppearance.Gradient = ggVertical
    TabAppearance.GradientMirror = ggVertical
    TabAppearance.GradientHot = ggRadial
    TabAppearance.GradientMirrorHot = ggVertical
    TabAppearance.GradientSelected = ggVertical
    TabAppearance.GradientMirrorSelected = ggVertical
    TabAppearance.GradientDisabled = ggVertical
    TabAppearance.GradientMirrorDisabled = ggVertical
    TabAppearance.TextColor = 9126421
    TabAppearance.TextColorHot = 9126421
    TabAppearance.TextColorSelected = 9126421
    TabAppearance.TextColorDisabled = clGray
    TabAppearance.BackGround.Color = 16767935
    TabAppearance.BackGround.ColorTo = clNone
    TabAppearance.BackGround.Direction = gdVertical
    Left = 338
    Top = 422
  end
  object ppmNew: TAdvPopupMenu
    AutoHotkeys = maManual
    OnPopup = ppmCompanyPopup
    MenuStyler = AdvMenuStyler
    Version = '2.5.0.0'
    Left = 592
    Top = 168
    object RequestDripfeed1: TMenuItem
      Action = actLinkRequest
    end
    object BulkExport2: TMenuItem
      Action = actBulkExport
    end
    object Dripfeed2: TMenuItem
      Action = actUpdateLink
    end
    object DripfeedScheduledTask2: TMenuItem
      Action = actAddSchedule
    end
    object EndofDripfeed1: TMenuItem
      Action = actEndLink
    end
    object RecreateCompany2: TMenuItem
      Action = actRecreate
    end
    object ActivateCompany2: TMenuItem
      Action = actActivateCompany
    end
    object DeleteCompany2: TMenuItem
      Action = actDeleteCompany
    end
    object SubcontractorVerification2: TMenuItem
      Action = actSubContractorVerification
    end
    object N24: TMenuItem
      Caption = '-'
    end
    object mnuCompMore: TMenuItem
      Caption = 'More...'
      object CancelDripfeed1: TMenuItem
        Action = actCancelLink
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object DeactivateCompany4: TMenuItem
        Action = actDeactivateComp
      end
      object RefreshCompanies4: TMenuItem
        Action = actRefreshCompany
      end
    end
  end
  object imgBox: TImageList
    Left = 310
    Top = 396
    Bitmap = {
      494C010108000900040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000003000000001002000000000000030
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
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C6E7F70052BDE70039A5CE0063ADC600A5CEDE0000000000000000000000
      00000000000000000000000000000000000000000000846B5200846B5A00846B
      5A00846B5200846B520084635200735A4200735242006B523900634A31006B52
      4200000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000523931004A392900000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000073635200423121004231210042312100523931005239310063524A00ADA5
      94000000000000000000000000000000000000000000000000000000000084CE
      EF005AC6EF0073DEFF004AC6F70042BDE70039ADD600529CAD007BA5AD000000
      0000000000000000000000000000000000009C847300FFEFE700E7D6CE00DEC6
      BD00CEB5A500BDAD9C00BDA59400BDA59400B5A58C00B59C8C009C8C7B008C73
      6300634A39000000000000000000000000000000000000000000000000000000
      000000000000000000004A31290063524200BD8C7300DEAD8C00845A42000000
      000000000000000000000000000000000000000000000000000000000000B59C
      9400E7CEB500FFF7D600FFFFE700FFF7D600FFEFC600FFDEA500F7D6B500735A
      4A000000000000000000000000000000000000000000C6E7F7008CD6F70073D6
      FF007BDEFF0073DEFF0052C6F70042BDF70031B5EF00317B94004A5A5A00637B
      7B0052A5C6008CC6D6000000000000000000A5847300FFFFFF00FFF7EF00FFEF
      E700FFEFE700FFE7DE00F7DECE00F7D6BD00F7CEB500EFC6A500F7BD9400AD94
      8400735242006B4A390000000000000000000000000000000000000000000000
      00004A39290073635200CEAD9400FFCEB500FFCEAD00FFCEAD00735A52000000
      000000000000000000000000000000000000000000000000000000000000A58C
      8400FFFFFF00FFFFFF00FFFFF700FFF7E700FFF7D600FFEFC600FFE7C600846B
      5200BDADA500000000000000000000000000B5E7F70073CEF7008CE7FF0084E7
      FF0084E7FF007BDEFF0052C6F70042C6F70039BDEF00318CAD004A5252004A5A
      5A00299CC600299CCE003994BD00BDDEE700A58C7B0000000000000000000000
      000000000000FFFFFF00FFFFF700FFEFEF00F7E7DE00F7E7DE00F7D6C600BDA5
      94007B6352006B5239006B5242000000000000000000000000004A3929004A31
      2100E7D6C600FFE7D600FFE7CE00FFDEC600FFD6BD00FFD6B500EFC6AD00B594
      7B0000000000000000000000000000000000000000000000000000000000B5AD
      A500F7FFE70073BD630000630000004A0000004A000031944200F7DEB500B594
      7300947B73000000000000000000000000005AC6EF0094E7FF0094E7FF0094E7
      FF0094E7FF0084DEFF0052C6F70042C6F70039BDEF0031ADDE0031738400316B
      730029A5D60029A5DE00299CC6009CC6D600AD9C8C00A58C7B00A58C7B00A58C
      7B00A58C7B009C8473009C8473009C847300947B6B0084847B008C7B6B00947B
      6B00947B6300735A4A006B5242006B524200000000004A392900F7F7F700FFFF
      FF00FFF7EF00FFEFE700FFEFDE00FFE7D600FFE7D600FFE7D600FFE7CE00CEB5
      A500000000000000000000000000000000000000000000000000BDADA500E7DE
      D600D6F7D600219C2100E7D6D600FFFFFF00B5C6940010732100C6CE9400E7BD
      A50063524A0000000000000000000000000063CEEF009CEFFF009CEFFF009CEF
      FF0094DEEF008CADB5007394A5004ABDEF0042BDF70031B5EF0031B5EF0031AD
      EF0029ADE70029A5DE00299CCE009CC6D600000000008C9CA500BDF7FF00ADEF
      FF009CEFFF0084DEFF0073D6F70063CEF70052C6EF0039B5E7001894C600526B
      730094847B008C73630073524200634A39000000000084736B00000000000000
      0000FFFFFF00FFF7F700FFEFE700738494007384940073849400738494007384
      9400738494007384940031394A00000000000000000000000000A58C8400F7F7
      F700F7FFF70084DE8400219C2100FFFFFF003184310010731000FFE7C600F7D6
      B500634A31000000000000000000000000006BCEEF009CEFFF009CE7FF008CC6
      C60084A5A5009CA5A5008C9494006B9CA50039B5E7005294AD004AADD60031B5
      EF0031ADE70031ADDE00299CCE009CC6D600000000008C9CAD00C6F7FF00B5EF
      FF00ADEFFF0094E7FF0084DEFF0073D6FF005ACEF7004ABDEF0021A5D6004A73
      8400398CAD00947B6B00846B5A007352420000000000A5948C00E7E7E700EFEF
      EF00EFEFEF00FFFFF700FFF7F70084949C00FFF7EF00D6C6B500008CCE005263
      7300CEAD9C00CEAD9C0042526300000000000000000000000000B59C9400FFFF
      FF00FFFFFF00FFFFFF0021C62100006B000000631000C6E7A500FFF7D600FFE7
      B500736352000000000000000000000000006BC6E7008CC6D6008CA5AD009CAD
      AD00A5ADAD009CA5A5008C949400848C8C0063A5BD005A94A500849C9C0042AD
      DE0042A5CE004A9CC60029A5D6009CC6D600000000008CA5AD00C6F7FF00BDF7
      FF00BDF7FF00ADF7FF00A5EFFF0094E7FF0084DEFF0073D6FF0052C6FF005A84
      94001894C600526B730084736300846B5A0000000000000000004A4242002121
      210039393900B5B5B500FFFFF7008C9CA500FFFFF700F7EFEF0008ADEF003942
      5200F7D6C600CEAD9C00526B7B000000000000000000BDADA500C6B5B500FFFF
      FF00FFFFFF00FFFFFF00E7FFD60010B5100094DE9400FFFFF700FFF7D600FFEF
      C600A58C730094847B0000000000000000009CBDC6008C949400A5ADAD00A5AD
      AD009CA5A500949C9C008C949400848C8C007B8484007B848400949C9C007394
      A500529CBD00738C940039A5CE009CC6D600000000008CA5AD008CA5AD008CA5
      AD008C9CAD008C9CAD008CA5AD00849CA500849CA500849CA50084A5B5007BD6
      F700189CD6004A738400318CAD00847363000000000063636300E7CEBD00F7CE
      AD00D6AD9C00847B7B00CECECE008CA5AD0000000000F7F7F700088CC600186B
      8C00FFDECE00CEB5A500637B8C000000000000000000A58C8400E7D6D600FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFE700FFF7E700FFF7
      D600D6B59400736352000000000000000000000000009CA5A50094A5A5009CA5
      A500949C9C008C8C8C00848484007B8484008C94940094949400848484007B7B
      7B0073848C008C8C8C005294AD00A5C6CE00000000008CA5AD00B5E7EF00BDF7
      FF0094E7F7008CA5AD00ADD6DE00ADF7FF00A5EFFF008CE7FF0084DEFF007BDE
      FF0052C6FF005A7B8C001894C60042636B00847B7B00D6CECE00FFF7EF00FFE7
      D600FFD6BD00D6BDB5000094D600008CCE007BBDD60000000000FFFFF700FFF7
      EF00FFE7DE00BDBDBD0042526300216B940000000000A58C8400F7F7F700FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFF700FFF7E700FFF7
      E700F7D6B5005A4A390000000000000000000000000000000000A5ADAD00949C
      9C0084848400848C8C008C949400949494007B7B7B007B7B7B008C949400949C
      9C008C9494007B848400848C8C00CED6D60000000000000000008CA5AD008CA5
      AD0094ADBD00A5C6CE008CA5AD008C9CAD008CA5AD00849CA500849CA500849C
      A50084A5B5007BCEF700189CD6004A7384009C9C9C00FFFFF700FFFFF7002121
      210021212100F7D6C60010B5EF009CE7F700008CCE007BBDD60000000000FFFF
      F700BDCED60042526300A5EFF70000A5E70000000000A58C8400A58C8400A594
      8400948C8400A5948400A5948400A5948400A5948400A5948400A58C8400A58C
      840073635200524231000000000000000000000000000000000000000000CECE
      CE0000000000BDBDBD0084848400737B7B009C9C9C009C9C9C008C8C8C007B84
      84005A8C9400ADBDC60000000000000000000000000000000000000000008CA5
      AD00B5E7EF00B5EFFF0094E7F70094ADB500ADD6DE00ADF7FF00A5EFFF0094E7
      FF0084DEFF007BDEFF0052C6FF005A7B8C009C9C9C00F7F7F700FFFFFF003939
      3900FFF7EF00CEC6BD0063848C0029BDF7009CEFF700008CCE007BBDD600BDD6
      DE0042526300A5EFF70000A5E7000000000000000000C6B5A5008C7B73008473
      6300B5A59400E7DED600F7F7F700FFFFF700FFFFFF00FFFFFF00F7F7F700D6CE
      C600E7D6D6007B6B630000000000000000000000000000000000000000000000
      00000000000000000000C6C6C60000000000BDBDBD008484840084A5A50063C6
      E70039A5C600CEE7EF0000000000000000000000000000000000000000000000
      00008CA5AD008CA5AD0094B5BD00A5C6CE008C9CAD008C9CAD008CA5AD00849C
      A500849CA5008494A5008494A500000000000000000094949400F7F7F700FFF7
      F700DED6D60042424200D6C6BD00CEDEE70029BDF7009CEFF700008CCE004252
      6300A5EFF700007BCE00082994000000000000000000000000009C948400A594
      7B00C6C6C600F7F7F700FFFFFF00FFFFFF00FFFFFF00FFFFFF00E7E7E700D6C6
      C60094846B000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000009CDEEF0063CE
      F70031A5CE00CEE7EF0000000000000000000000000000000000000000000000
      0000000000008CA5AD00B5E7EF00B5EFFF0094E7F7008CA5AD00000000000000
      0000000000000000000000000000000000000000000000000000949494008C8C
      8C00847B7B000000000000000000000000000000000029BDF700A5EFFF00A5EF
      F70000A5E7000839BD000831B50000000000000000000000000000000000A5A5
      940094847B00947B730094847300947B7300947B730084736300735A42007363
      5200000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000009CDEEF0052BD
      E700319CC600CEE7EF0000000000000000000000000000000000000000000000
      000000000000000000008CA5AD008CA5AD008CA5AD0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000021BDF70000A5
      E700000000001052FF00104AEF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000004AA5
      C6006BB5CE000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F7F7F700DEDEDE00D6D6
      D600D6D6D600D6D6D600D6D6D600D6D6D600D6D6D600D6D6D600D6D6D600D6D6
      D600D6D6D600DEDEDE00F7F7F7000000000000000000F7F7F700DEDEDE00D6D6
      D600D6D6D600D6D6D600D6D6D600D6D6D600D6D6D600D6D6D600D6D6D600D6D6
      D600D6D6D600D6D6D600DEDEDE00F7F7F70000000000000000000000000084AD
      C6005273840042739400316B8400316B840031638400315A7300315A7300315A
      7300315A7300315263003152630031526300000000000000000000000000C6AD
      9400735A420073524200634A3100634A3100634A3100634A3100634A3100634A
      3100634A3100634A3100634A3100634A3100F7F7F700C6C6C6008C8C8C007373
      7300737373007373730073737300737373007373730073737300737373007373
      7300737373008C8C8C00C6C6C600F7F7F700F7F7F700CECECE00848484006B6B
      6B006B6B6B006B6B6B006B6B6B006B6B6B006B6B6B006B6B6B006B6B6B006B6B
      6B006B6B6B006B6B6B0084848400CECECE0000000000000000000000000084AD
      C600D6FFFF00A5EFFF0084E7F70084DEF70073D6F70073D6F70073CEF70073CE
      F70073CEF70063CEF70063C6F70031526300000000000000000000000000C6AD
      9400FFF7F700F7EFE700E7D6D600E7DED600E7D6C600E7D6C600E7CEC600E7B5
      9400E7CEB500E7CEB500E7CEB500634A3100DEDEDE000873A5000873A5000873
      A5000873A5000873A5000873A5000873A5000873A5000873A5000873A5000873
      A5000873A500636363008C8C8C00DEDEDE00DEDEDE001884B5001884B500187B
      B500107BAD00107BAD001073AD000873A5000873A500086BA500006B9C00006B
      9C00006B9C0000639C004A4A4A008484840000000000000000000000000084AD
      C600C6EFF700B5F7FF0094EFFF0094EFFF0094EFFF0094EFFF0094EFFF0094EF
      FF0094EFFF0084E7FF0063BDE70031526300000000000000000000000000C6AD
      A500FFFFFF00C6846300FFF7F700FFF7F700FFF7F700FFF7F700FFEFE700C66B
      4200F7E7D600FFEFE700E7CEB500634A3100189CC600189CC6009CFFFF006BD6
      FF006BD6FF006BD6FF006BD6FF006BD6FF006BD6FF006BD6FF006BD6FF006BD6
      FF00299CBD000873A50073737300D6D6D6002184BD0063CEFF002184BD009CFF
      FF006BD6FF006BD6FF006BD6FF006BD6FF006BD6FF006BD6FF006BD6FF006BD6
      FF0039A5D6009CFFFF0000639C006B6B6B00738C9400737B84006373730084B5
      C60084BDD60094E7F70094F7FF0094EFFF0084E7FF0073E7FF0084E7FF0084E7
      FF0094EFFF0073DEF700428CB500425A6300738C9400737B840063737300C6AD
      A500FFFFFF00B5634200E7B5A500FFF7F700FFF7F700FFF7F700FFF7F700C66B
      4200D67B5200F7E7D600E7CEB500634A3100189CC600189CC6007BE7F7009CFF
      FF007BE7FF007BE7FF007BE7FF007BE7FF007BE7FF007BE7FF007BE7FF007BDE
      FF0042B5DE00187B9C0063636300BDBDBD00218CBD0063CEFF00218CBD009CFF
      FF007BE7FF007BE7FF007BE7FF007BE7FF007BE7FF007BE7FF007BE7FF007BE7
      FF0042ADDE009CFFFF00006B9C006B6B6B00738C9400A5E7F70073D6F70094B5
      C600B5EFF70063BDD60084E7FF0073E7F70052B5E70031A5D6003194C60073D6
      F70073DEF700429CC60063C6E700425A7300738C9400A5E7F70073D6F700C6B5
      A500FFFFFF00E7BDA500E7846300E7845200E77B5200D6734200D66B3100D66B
      3100F7946300C6734200E7C6B500634A3100189CC60021A5CE0042BDD6009CFF
      FF0084EFFF0084EFFF0084EFFF0084EFFF0084EFFF0084EFFF0084EFFF0084E7
      FF0042BDEF00189CC600636363008C8C8C00298CC60063CEFF002994C6009CFF
      FF0084EFFF0084EFFF0084EFFF0084EFFF0084EFFF0084EFFF0084EFFF0084EF
      FF004AB5E7009CFFFF00006B9C006B6B6B00848C9400B5EFF70094E7FF0094BD
      D600D6FFFF00A5E7F70073CEF70052B5E70084DEF70084E7FF0084E7F70042A5
      C60052C6E70084E7F70073CEF70042637300848C9400B5EFF70094E7FF00C6B5
      A500FFFFFF00F7E7D600E7BDA500E7AD9400E7A58400F79C7300F7946300FFB5
      8400FFB59400E7A57300D6845200634A3100189CC60042B5E70021A5CE00A5FF
      FF0094F7FF0094F7FF0094F7FF0094F7FF0094F7FF0094F7FF0094F7FF0094F7
      FF0052BDE7005ABDCE000873A50073737300298CC60063CEFF00319CCE009CFF
      FF0094F7FF0094F7FF0094F7FF0094F7FF0094F7FF0094F7FF0094F7FF0094F7
      FF0052BDEF009CFFFF00006B9C006B6B6B008494A500B5EFF700A5EFFF0094C6
      D600D6FFFF0094E7F70063BDE70084E7F700A5F7FF0094EFFF0094EFFF0094E7
      FF0052ADD60084E7F70073D6F700426373008494A500B5EFF700A5EFFF00D6B5
      A500FFFFFF00FFFFFF00F7E7D600F7DED600E7C6B500E7AD9400D6947300E794
      6300F7AD8400D6846300E7BDA500634A3100189CC60073D6FF00189CC6008CF7
      F7009CFFFF009CFFFF009CFFFF009CFFFF009CFFFF009CFFFF009CFFFF009CFF
      FF005AC6FF0094FFFF00187B9C00737373002994C6006BD6FF00319CCE009CFF
      FF009CFFFF009CFFFF009CFFFF009CFFFF009CFFFF009CFFFF009CFFFF009CFF
      FF0063C6FF009CFFFF00086BA5006B6B6B008494A500B5F7FF00B5F7FF0094C6
      D600C6F7FF0063C6E70094E7F700A5F7FF00A5F7FF00A5F7FF00A5F7FF0094EF
      FF0094E7FF0052A5C60063C6E700526B73008494A500B5F7FF00B5F7FF00D6BD
      A500FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFF7F700FFF7F700E794
      6300D6947300FFEFE700F7DED600634A3100189CC60084D6FF00189CC6006BBD
      DE000000000000000000F7FFFF00000000000000000000000000000000000000
      000084E7FF0000000000187BA5008C8C8C002994C6007BE7FF002994C6000000
      0000000000000000000000000000000000000000000000000000000000000000
      000084E7FF00000000000873A5008C8C8C00849CA500C6F7FF00B5EFF70094CE
      D600A5E7F700E7FFFF00E7FFFF00E7FFFF00E7FFFF00E7FFFF00E7FFFF00D6FF
      FF00D6FFFF00B5F7FF00429CC60052738400849CA500C6F7FF00B5EFF700D6BD
      A500FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00D694
      7300FFFFFF00FFFFFF00FFF7F70063524200189CC60084EFFF0052C6E700189C
      C600189CC600189CC600189CC600189CC600189CC600189CC600189CC600189C
      C600189CC600189CC600188CB500C6C6C6003194CE0084EFFF0084E7FF002994
      C6002994C6002994C6002994C6002994C6002994C600298CC600218CBD002184
      BD001884B5001884B5001884B500DEDEDE00849CA500C6F7FF00B5F7FF0094CE
      D60094CED60094CED60094CED60094C6D60094C6D60094BDD60094BDC60084B5
      C60084B5C60084ADC60084ADC60084ADC600849CA500C6F7FF00B5F7FF00D6BD
      A500D6BDA500D6BDA500C6B5A500C6B5A500C6B5A500C6ADA500C6ADA500C6AD
      A500C6AD9400C6AD9400C6AD9400C6AD9400189CC6009CF7FF008CF7FF008CF7
      FF008CF7FF008CF7FF008CF7FF00000000000000000000000000000000000000
      0000189CC600187B9C00C6C6C600F7F7F700319CCE0094F7FF008CF7FF008CF7
      FF008CF7FF008CF7FF008CF7FF00000000000000000000000000000000000000
      0000107BAD008C8C8C00DEDEDE000000000094A5A500C6F7FF00B5F7FF00B5F7
      FF00B5EFF700A5EFFF0094E7FF0094E7FF0084E7FF0073D6FF0063D6F70052C6
      F70052BDF700219CD600637384000000000094A5A500C6F7FF00B5F7FF00B5F7
      FF00B5EFF700A5EFFF0094E7FF0094E7FF0084E7FF0073D6FF0063D6F70052C6
      F70052BDF700219CD6006373840000000000189CC600000000009CFFFF009CFF
      FF009CFFFF009CFFFF0000000000189CC600189CC600189CC600189CC600189C
      C600189CC600DEDEDE00F7F7F70000000000319CCE00000000009CFFFF009CFF
      FF009CFFFF009CFFFF0000000000218CBD002184BD001884B5001884B5001884
      B500187BB500DEDEDE00F7F7F7000000000094A5B500C6F7FF00C6F7FF00C6F7
      FF00C6F7FF00B5F7FF00B5F7FF00A5EFFF0094E7FF0094E7FF0084DEFF0073D6
      FF0073CEF70063BDF700637384000000000094A5B500C6F7FF00C6F7FF00C6F7
      FF00C6F7FF00B5F7FF00B5F7FF00A5EFFF0094E7FF0094E7FF0084DEFF0073D6
      FF0073CEF70063BDF70063738400000000000000000021A5CE00000000000000
      00000000000000000000189CC600C6C6C600F7F7F70000000000000000000000
      00000000000000000000000000000000000000000000319CCE00000000000000
      00000000000000000000298CC600CECECE00F7F7F70000000000000000000000
      00000000000000000000000000000000000094A5B50094A5B50094A5B50094A5
      B50094A5B50094A5B50094A5A500949CA500849CA500849CA500849CA500849C
      A500849CA5008494A500000000000000000094A5B50094A5B50094A5B50094A5
      B50094A5B50094A5B50094A5A500949CA500849CA500849CA500849CA500849C
      A500849CA5008494A5000000000000000000000000000000000021A5CE0021A5
      CE0021A5CE0021A5CE00DEDEDE00F7F7F7000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000319CCE00319C
      CE003194CE002994C600DEDEDE00F7F7F7000000000000000000000000000000
      00000000000000000000000000000000000094ADB500B5EFF700B5F7FF00B5F7
      FF00B5EFF70094E7F70094A5B500000000000000000000000000000000000000
      00000000000000000000000000000000000094ADB500B5EFF700B5F7FF00B5F7
      FF00B5EFF70094E7F70094A5B500000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000094ADB50094ADB50094AD
      B50094ADB50094ADB50000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000094ADB50094ADB50094AD
      B50094ADB50094ADB50000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000300000000100010000000000800100000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FFFFFFFFFFFFF07F800FFF3FF00FE01F
      0007FC1FE00F80030003F01FE00700007801C00FE00700000000800FC0070000
      8000B001C007000080008001C00700008000C001800300008000808180038000
      800000408003C000C00000208003E803E00000018003FD03F0018001C007FFC3
      F83FC781E00FFFC3FC7FFFC9FFFFFFE7FFFFFFFFFFFFFFFF80018000E000E000
      00000000E000E00000000000E000E00000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000DF41FF400000000
      000000000000000001F001F1000100014201420100010001BC7FBC7F00030003
      C0FFC0FF01FF01FFFFFFFFFF83FF83FF00000000000000000000000000000000
      000000000000}
  end
  object imgNavBarBig: TImageList
    Height = 32
    Width = 32
    Left = 366
    Top = 396
    Bitmap = {
      494C010103000400040020002000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000800000002000000001002000000000000040
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000052BDE70021A5D6002184A500429CB50052BDE700000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00009C9CFF006B6BFF008484F700BDBDF7000000000000000000000000000000
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
      000021A5D60042BDE7006BD6FF0052C6F70039ADD6002994B5002184A5002184
      A50052BDE7000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000BDBDFF00A5A5
      FF00ADADFF009C9CFF008C8CFF007373FF007B7BD6009494C600000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000B5A59400846B52007352
      4200846B6300846B6300846B5A00846B5A00846B520084634A00846B5200846B
      5200846B52007B634A00735A42006B523900735A42007352420073524200634A
      3100634A31006B5239009C8C7B00BDADA5000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000052BDE70021A5
      D6005ACEF7007BDEFF0073D6FF004AC6F7004AC6F70042BDEF0039B5DE0039AD
      D60042A5BD004A84940073ADAD00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000B5B5FF00ADADFF00BDBD
      FF00BDBDFF00A5A5FF009494FF008484FF005A5ABD0052526B00737384007B7B
      EF00ADADF7000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C6B5A500BDA58C00E7DECE00DED6
      C600CEC6BD00CEBDB500CEB5AD00CEAD9C00C6A59400BD9C8C00AD948C00AD9C
      8400AD947B00AD947B00AD8C7B00A58C7B009C8C7B00A58C7B009C8C7B009C84
      73008C736B008C7363007352420094847300B5A59C0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000021A5D60042BDE7007BDE
      FF007BDEFF007BDEFF0073DEFF004AC6F7004AC6F70042C6F70039BDEF0031B5
      EF0021A5CE00315A5A0021636300316363005A8C8C008CADAD00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000CECEFF00ADADFF00BDBDFF00BDBDFF00BDBD
      FF00BDBDFF009C9CFF009494FF008C8CFF005252D6004A4A5200525263005A5A
      FF005A5AFF006363F70000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000A58C7300D6BDAD00FFFFF700F7EF
      E700E7DEDE00DED6CE00E7CEC600DEBDAD00D6BDAD00C6AD9C00C6ADA500BDAD
      9C00C6AD9400C6A58C00C6A59400BD9C9400B5A59400B5A59400B5A59400AD94
      8C00A58C84009C7B730094736300735A42008C7B6B00ADA59400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000052BDE70021A5D60084E7FF007BDEFF007BDE
      FF007BDEFF007BDEFF0073DEFF0052C6F7004AC6F70042C6F70042BDF70031B5
      EF0029ADE700397384004A5A5A0052636300636B6B005A7373002994C6002184
      A50052BDE7000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000BD522100000000000000
      00000000000000000000000000009494FF00C6C6FF00C6C6FF00C6C6FF00C6C6
      FF00BDBDFF009C9CFF009494FF008C8CFF007373FF005A5AAD00525294006B6B
      FF006B6BFF005A5AFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000947B6300D6C6B500FFFFFF00FFFF
      FF00FFF7EF00FFEFE700FFE7DE00F7DED600EFCEBD00E7C6BD00DEC6BD00DEC6
      B500D6C6AD00D6BDA500DEBDA500D6B5A500DEBDA500D6BD9C00DEB59C00DEAD
      9400D6A58C00C69C8400A5847300735A42006B5A42008C7B6B00B5A59C000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000031ADDE0052BDE7009CEFFF008CE7FF007BDEFF007BDE
      FF007BDEFF007BDEFF007BDEFF004AC6F7004AC6F70042C6F70042BDF70031B5
      EF0031B5EF00424A4A00525A5A00525A5A005A6363004A63630029A5D600299C
      C6003194AD002184A50052BDE700000000000000000000000000000000000000
      00000000000000000000000000000000000000000000BD633900AD3900000000
      00000000000000000000000000009C9CFF00C6C6FF00C6C6FF00C6C6FF00C6C6
      FF009C9CC6008C8CB5008C8CFF008C8CFF008484FF008C8CFF007B7BFF007B7B
      FF005A5AFF005A5AFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000A58C7300CEC6BD00FFFFFF00FFFF
      FF00FFFFFF00FFF7F700FFEFE700FFEFE700FFEFDE00F7DED600F7D6D600EFD6
      CE00E7D6BD00E7CEBD00EFCEBD00E7C6B500F7CEB500F7C6AD00F7C6A500FFBD
      9C00F7BD9400DEAD8C00B59C84008C735A00735A42006B5239009C8C7B00BDAD
      A500000000000000000000000000000000000000000000000000000000000000
      00000000000042B5E7006BCEF70094EFFF0094E7FF008CE7FF008CE7FF008CE7
      FF0084E7FF007BDEFF007BDEFF0052C6FF004AC6F7004AC6F70042BDF70039BD
      EF0031B5EF0031849C00394A4A0052525200525A5A003152520029A5DE0029A5
      D60029A5D600299CC6002184A5002184A5000000000000000000000000000000
      00000000000000000000EF946B00C64A180094290000AD421000E7733900B518
      00000000000000000000000000009C9CFF00C6C6FF00BDBDFF00ADADE7009494
      B5009CA5AD0094949C008484BD008484FF006B6BCE007373FF007B7BFF007B7B
      FF005A5AFF005A5AFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000009C846B00D6CEC600FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFF700FFF7F700FFFFF700FFF7F700FFF7
      EF00F7EFE700F7E7DE00F7E7D600F7DED600FFDEC600F7DEC600FFD6BD00FFD6
      B500FFDEB500EFCEA500C6AD940094846B007B634A00634229007B634A009C84
      7B00BDB5A5000000000000000000000000000000000000000000000000000000
      000029ADDE007BDEF70094EFFF0094E7FF009CEFFF0094E7FF0094E7FF0094E7
      FF0084E7FF007BDEFF007BDEFF0052C6FF004AC6F7004AC6F70042C6F70042BD
      F70031B5EF0039A5D600395A5A00394A4A0042525200314A4A0029ADE70029A5
      DE0029A5D600299CCE00299CCE002184A5000000000000000000000000000000
      0000FFAD7B00A5290000A5290000CE5A2900E7632100F76B3100F7844A00FF8C
      4A00F78C520000000000000000009494FF00A5A5F7009C9CBD00A5A5B500A5A5
      AD009C9CA50094949C00848C8C008484DE007B7BC6008C8CAD009494FF006363
      FF006363F7006363FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000A58C7300CEC6B500FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      F700FFF7EF00FFF7EF00FFF7F700FFEFE700F7E7DE00F7E7D600F7E7D600F7E7
      D600F7DEC600E7C6AD00C6AD94009C846B00846B520073524200735242006B52
      420094847300ADA5940000000000000000000000000000000000000000000000
      000031ADDE009CEFFF009CEFFF009CEFFF0094EFFF0094E7FF009CEFFF0094E7
      FF0094EFFF008CE7FF0084E7FF0052C6FF004AC6F70042C6F70042BDF70039BD
      EF0039BDEF0031B5EF002994AD002984940031636B00318CB50029ADE70029AD
      E70029ADDE0029A5D600299CCE002184A500000000000000000000000000DEA5
      84009C210000EF733900FF945A00FF946300FF9C6300FFA57B00F7CEB500FFCE
      AD00EFBD9C000000000000000000A5A5D60094949C00ADADB500ADADB500A5A5
      AD009C9C9C008C949400848C8C007B8484007B848C00949C9C008C8CBD006B6B
      EF007B7BA5006B6BFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000A58C6B00BDAD9400FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      F700FFFFF700FFF7EF00FFF7F700F7EFEF00F7E7DE00EFEFE700F7EFE700F7E7
      D600F7DEC600E7C6AD00B59484009C846B008C735200735A4A006B5242006342
      3100634A31007B635200A5948400000000000000000000000000000000000000
      000042B5E7009CEFFF009CEFFF009CEFFF009CEFFF009CEFFF009CEFFF009CEF
      FF009CEFFF0094E7FF008C9C9C007B8C8C004AC6F70042C6F70042C6F70042BD
      F70039BDEF0031B5EF0031B5EF0031B5EF0031B5EF0031ADE70029ADE70029AD
      E70029A5DE0029A5D600299CCE002184A5000000000000000000000000009C18
      0000FF9C5A00FFAD7B00FFB58C00F7BD9400FFD6BD00FFB59400FFBD9C00EFBD
      9C00000000000000000000000000000000009C9CA5009C9CA500A5A5AD009494
      9C008C8C9400848484007B8484008C9494009494940084848C007B7B7B007B7B
      9C008C8C8C007B7BCE0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000AD948400A5948400A59484009C94
      7B00A5948400A58C8400A58C8400A5848400A58C8400A58C7B00A58C7300A584
      6B00A5847300A57B7300A58473009C846B009484730084847B0084848400847B
      7B00947B730094737300947B7300947B6B00947B63007B6B520073635200735A
      4A007B5A4A0073524200846B5A00AD9C94000000000000000000000000000000
      000039B5E7009CEFFF009CEFFF009CEFFF009CEFFF009CEFFF009CEFFF009CEF
      FF0094C6CE008C9C9C00849494007B8484009C9C9C0042C6EF0042BDF70042BD
      F70039B5EF0031B5EF0031B5EF0031B5EF0031B5EF0031B5EF0031ADE70029AD
      E70029ADDE0029A5D600299CCE002184A5000000000000000000FFB59C00E763
      2100F7AD8400DEC6B500000000000000000000000000FFA57300F7BD9C000000
      00000000000000000000000000000000000000000000A5A5AD009C9C9C008484
      8400848C8C008C949400949494007B7B7B007B7B7B008C8C94009C9C9C008C8C
      94008484840084848C0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000A5948C008C847B00949C
      9400A5B5AD00A5BDB5009CADAD009CADB50094ADAD008CA5AD0084A5A5007B9C
      A5007B949C0073949C0073949C006B94A5006394A500528CA500528CA5004A84
      9C004A7B8C00526B7B006B6B6B008C736B009C846B00947B6300846B5A007B63
      4A0073524200634A3100524229006B5A42000000000000000000000000000000
      000042B5E7009CEFFF009CEFFF009CEFFF009CEFFF009CEFFF0094DEDE007394
      9400739C9C009CA5A5009CA5A500949C9C00848C8C007B9C9C0042BDEF0039BD
      EF0031B5EF006B73730063B5D60031B5EF0031B5EF0031B5EF0031B5EF0031AD
      E70029ADDE0029A5DE00299CCE002184A5000000000000000000FF9C6B00FF94
      5A000000000000000000000000000000000000000000FFB58C00000000000000
      0000000000000000000000000000000000000000000000000000CECECE000000
      0000BDBDBD0084848400737B7B009C9C9C009C9C9C008C8C8C0084848C007373
      B500B5B5CE000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000949CA500C6FF
      FF00C6FFFF00C6FFFF00B5F7FF00ADEFFF00A5EFFF0094E7FF0084E7FF0073DE
      F70073D6F7006BCEEF0063CEF7005AC6F70052C6F7004ABDEF0042B5E70029AD
      DE00189CC6002184A500526B730073737300948C84009C8C7300947B63008463
      4A00735A420063523900635242005A4A42000000000000000000000000000000
      000042B5E7009CEFFF009CEFFF009CEFFF009CEFFF00A5CECE00738C8C00949C
      9C009CADAD00A5ADAD00949C9C00949C9C008C9494007B84840073A5AD0031B5
      EF0031B5EF0063848400949C9C0031B5EF0031B5EF0031B5EF0031B5EF0052AD
      CE0029ADE70029ADDE0029A5CE002184A5000000000000000000F79C6B00FF94
      6300000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C6C6C60000000000BDBDBD00848484009494BD00A5A5FF007373
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000008C9CAD00C6FF
      FF00C6FFFF00C6FFFF00B5FFFF00ADFFFF00A5FFFF0094F7FF0084EFFF0073E7
      FF006BE7FF0063DEFF005AD6FF0052D6FF004ACEFF004AC6FF0039B5F70018AD
      EF00089CCE00108CB5004A6B730052738C006B8C9C008C8C8C009C846B009473
      5A0073634A006B52420063523900634A39000000000000000000000000000000
      000039B5DE009CEFFF009CEFFF008CC6CE00738C8C008C949400ADB5B500ADB5
      B500A5ADAD009CA5A500949C9C00949C9C008C949400848484007B84840052AD
      D60031B5EF0073848400848C8C0094A5A50031B5EF0031B5EF0031B5EF006B73
      730031ADE70031ADDE0029A5D6002184A5000000000000000000DEADA500FF9C
      6300000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000A5A5FF006363
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000094A5B500C6FF
      FF00C6FFFF00BDFFFF00B5F7FF00B5F7FF00B5F7FF00A5EFFF0094EFFF0084E7
      FF0084E7FF007BDEFF0073DEFF006BD6F70063CEF7005AC6F70052BDF70031B5
      EF0021A5D6002994BD004A6B7B00398CAD00398CB5006B8C9C0094847300947B
      63008473630073634A00735A42006B5239000000000000000000000000000000
      000063BDDE008CB5B5006B7B7B00848C8C009CA5A500ADB5B500A5ADAD00A5AD
      AD009CA5A500949C9C00949C9C008C9494008C9494008C8C8C00848C8C008C94
      94006BB5C600737B7B008C9C9C00848C8C00ADB5B50031B5EF0031B5EF007384
      84007B949C0031ADE70031A5D6002184A500000000000000000000000000E729
      1000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000008C8CFF005A5A
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000094A5B500C6FF
      FF00C6FFFF00CEFFFF00BDFFFF00C6FFFF00C6FFFF00B5FFFF00A5F7FF009CF7
      FF0094EFFF008CEFFF0084EFFF007BE7FF0073DEFF006BD6FF0063CEFF0042CE
      FF0031BDEF0039ADDE004A6B7B0042A5CE00299CCE004284A500737373008C73
      5A008C735A00846B52007B63520073634A000000000000000000000000000000
      00007BCEE7006B7B7B0094949400ADADAD00ADB5B500ADB5B500A5ADAD00A5A5
      A5009CA5A5009CA5A500949C9C008C949400848C8C008C8C8C007B8484007B7B
      7B006B6B6B006B6B6B00A5ADAD00949C9C007B84840052ADC60039B5E700737B
      7B00848C8C004AADD60029A5D6002184A500000000000000000000000000BD9C
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007B7BFF007384
      F70000000000FFB5840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000094A5B500C6FF
      FF00C6FFFF00C6FFFF00C6F7FF00C6EFFF00C6F7FF00BDF7FF00B5F7FF00ADEF
      FF00A5EFFF009CEFFF0094EFFF008CE7FF0084E7FF007BDEFF0073D6FF005AD6
      FF0052CEFF004AB5E7005A7B8C004ABDE70029A5D600297BA500526B73006B63
      5A008473630084735A0084736300847363000000000000000000000000000000
      000000000000A5B5B500737B7B009C9C9C00A5ADAD00A5ADBD00A5ADAD009CA5
      A5009C9C9C00949C9C008C9494008C949400848C8C00848484005A6363006B6B
      6B00ADADAD009C9C9C009C9C9C00848484008C8C8C007B7B7B004AA5BD007B84
      8400848C8C008C949400299CD6002184A5000000000000000000000000000000
      000000000000C6E7F70052BDE70039A5CE0063ADC600A5CEDE00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF73180000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000094A5B500C6FF
      FF00C6FFFF00C6FFFF00C6F7FF00C6EFFF00C6F7FF00BDF7FF00B5F7FF00ADEF
      FF00A5EFFF009CEFFF0094EFFF008CE7FF0084E7FF007BDEFF0073D6FF005AD6
      FF0052CEFF0063BDDE006394A50052CEF70039B5E7002184AD00426B73004A73
      84005A7B8400737B73008C73630094735A00000000000000000000109C003152
      C6000000000000000000A5A5A500848C8C00949C9C00949CCE00949CCE00949C
      9C00949494008C9494007B848400848484006B6B6B006B6B6B00ADADAD009CA5
      A5009C9C9C00848484007B8484008C8C8C007373730073737300737373008C94
      94008C9494008C8C8C00319CBD00297373000000000000000000000000000000
      000084CEEF005AC6EF0073DEFF004AC6F70042BDE70039ADD600529CAD007BA5
      AD00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000F7AD8400F7BDA500000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000094A5B5008494
      A50094A5B50094A5B50094A5B50094A5B50094A5B50094A5B50094A5B50094A5
      B50094A5B5008C9CAD00849CA5007B949C00849CA50084949C00849CA500849C
      A500849CA50084A5B50084CEE70063DEFF004AC6F700318CB500527384003994
      B500298CB500527B8C00847363008C6B5200000000006373CE004263E7002142
      D6002942AD009C94CE0000000000A5A5A5008494DE002939C6001839CE002142
      BD00848CB500848C8C006B6B6B006B6B6B00ADB5B5009CA5A500949494007B7B
      7B007B8484008C8C8C006B6B6B0073737300A5ADAD00949C9C00949C9C009494
      94008C8C8C008C8C8C00738484006B7373000000000000000000C6E7F7008CD6
      F70073D6FF007BDEFF0073DEFF0052C6F70042BDF70031B5EF00317B94004A5A
      5A00637B7B0052A5C6008CC6D600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000F7AD8C00F76B2100000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000B5C6CE008CAD
      BD00B5EFF700C6F7FF00C6F7FF00ADF7FF0094E7F7008CA5B5009CBDCE00ADEF
      F700B5EFFF00B5F7FF00ADF7FF00A5EFFF009CE7FF0094E7FF0084E7FF0084E7
      FF0084DEFF008CDEFF0084E7FF0063DEFF0052CEFF0042A5CE00526B7B0042A5
      CE00188CC600317B9C005A6363005A635A00000000005A6BBD00527BF700315A
      F700395AE700393994006B6B8C00000000005A52CE00294AEF00184AF7001042
      F7002131AD00A5ADB500ADADAD00A5A5A5008C8C8C008C8C8C00848484007373
      73006B6B6B0073737300B5B5B500A5A5A500949C9C008C8C8C00848C8C007B84
      84006B6B6B00737373009C9C9C00B5BDBD0000000000B5E7F70073CEF7008CE7
      FF0084E7FF0084E7FF007BDEFF0052C6F70042C6F70039BDEF00318CAD004A52
      52004A5A5A00299CC600299CCE003994BD000000000000000000000000000000
      0000000000000000000000000000C69C8C000000000000000000000000000000
      000000000000FF9C6300FF946300000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000009CB5
      C6009CCED600ADD6E700B5DEEF00A5E7F70094CEE7008CADBD00A5C6D600ADE7
      EF00ADEFF700B5EFFF00B5F7FF00ADF7FF00A5EFFF009CE7FF0094E7FF0084E7
      FF0084E7FF0084DEFF0084DEFF006BDEFF005ACEFF005AB5DE005A7384004ABD
      E70031ADD600297B9C004263730000000000000000004263B500527BF7003963
      F7004263F7004263F7001842C6002131AD00394ACE00315AEF001852EF001042
      FF001039DE005A73CE00848484008C8C8C007B7B7B00737373006B6B6B00A5AD
      AD00B5BDBD00A5A5A50094949400949C9C008C9494007B7B7B00737B7B005284
      84009C9C9C00000000000000000000000000000000005AC6EF0094E7FF0094E7
      FF0094E7FF0094E7FF0084DEFF0052C6F70042C6F70039BDEF0031ADDE003173
      8400316B730029A5D60029A5DE00299CC6000000000000000000000000000000
      000000000000000000009C523900B55A29000000000000000000D6C6BD00DEAD
      8C00FF8C5200FF9C7300FFA57B00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C6CE
      D60094A5B500949CAD0094A5B5008CA5B50094B5C60094B5C600A5D6E700A5E7
      F700A5EFFF00A5EFFF00A5EFFF00A5EFFF009CE7FF0094E7FF0084E7FF0084E7
      FF0084DEFF0084DEFF006BDEFF005ACEFF006BB5D6007BB5CE0063849C0052D6
      FF0042C6EF00187B9C0039637B0000000000000000008484BD006B84E700527B
      F7004A6BF7004A73EF005273EF000042BD003163EF00315AE7003163E700395A
      DE00424A730000000000B5B5B500848484006B737300737373008C8C8C00B5B5
      B5009C9C9C008C9494007B8484006B6B6B006B6B6B006B94940042ADD6002184
      A500000000000000000000000000000000000000000063CEEF009CEFFF009CEF
      FF009CEFFF0094DEEF008CADB5007394A5004ABDEF0042BDF70031B5EF0031B5
      EF0031ADEF0029ADE70029A5DE00299CCE000000000000000000000000000000
      0000000000008C4A42008C210000BD522100E7632100E76B2900FF7B3900FF8C
      5200FF8C5200FF9C6B00EFB59400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000094A5B5008494A50094A5B50094A5B50094A5B50094A5
      B50094A5B50094A5B50094A5B50094A5B50094A5B5008C9CAD00849CA5007B94
      9C00849CA50084949C00849CA500849CA500849CA50084ADB50084CEE7005ADE
      FF0042C6EF002984A500527384000000000000000000000000007384B500526B
      C6006373E700526BEF00426BEF00396BFF00426BF7003963E70029319C007373
      AD00000000000000000000000000BDBDBD00ADADAD0000000000000000008C8C
      8C008C8C8C006B6B6B006B6B6B0084A5A5007BDEFF004AC6F70042ADD6002184
      A50000000000000000000000000000000000000000006BCEEF009CEFFF009CE7
      FF008CC6C60084A5A5009CA5A5008C9494006B9CA50039B5E7005294AD004AAD
      D60031B5EF0031ADE70031ADDE00299CCE000000000000000000000000000000
      0000BD735200C6310000F79C6300EF632900D64A1000EF5A2900F7733900FF84
      4A00FFA57300FFBD940000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000C6CED60094B5C600B5EFF700BDF7FF00B5F7FF00A5F7
      FF0094EFF7008CADB5009CBDCE00ADE7F700B5EFFF00B5F7FF00ADF7FF00A5EF
      FF009CEFFF0094EFFF0084E7FF0084E7FF0084DEFF0084DEFF0063DEFF0063E7
      FF0052D6FF00318CB5004A6B8400000000000000000000000000000000009CA5
      E7005A5ABD00526BF7003963EF003963EF004A73F700526BEF004A4ADE000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B009C9C9C000000000042B5E7007BDEFF004AC6F70042ADD6002184
      A50000000000000000000000000000000000000000006BC6E7008CC6D6008CA5
      AD009CADAD00A5ADAD009CA5A5008C949400848C8C0063A5BD005A94A500849C
      9C0042ADDE0042A5CE004A9CC60029A5D6000000000000000000000000000000
      0000FFAD7B00FFCEAD00F7C6AD00FFC6A500FFBD9C00FFBD9400FFB58C00FFB5
      8C00FFB58C000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000A5BDCE009CCED600A5D6DE00A5D6E7009CDE
      EF008CD6E7008CADBD00A5D6E700ADEFFF00ADEFFF00ADEFFF00ADF7FF00ADF7
      FF00A5EFFF009CEFFF0094EFFF0084E7FF0084E7FF0084DEFF0084DEFF0063DE
      FF005AD6FF00529CC600637B9400000000000000000000000000000000000000
      00002942A5004263EF00426BE7003963E7004A6BF700426BE7004A5ABD000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000042B5E7007BDEFF004AC6F70042ADD6002184
      A50000000000000000000000000000000000000000009CBDC6008C949400A5AD
      AD00A5ADAD009CA5A500949C9C008C949400848C8C007B8484007B848400949C
      9C007394A500529CBD00738C940039A5CE000000000000000000000000000000
      000000000000FFB58C00FFC6AD00EFCEBD00FFA57300FFC69C00EFBDA5000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000C6CED60094A5B5008494A50094A5B5008CA5
      B50094B5C60094BDC600A5C6CE00ADDEEF00ADE7F700ADEFFF00ADEFFF00A5EF
      FF00A5EFFF009CEFFF0094EFFF0084E7FF0084E7FF0084DEFF0084DEFF0063DE
      FF005AD6FF0073A5BD0094A5B500000000000000000000000000000000007B8C
      D600395ADE003163FF002963EF003952B5005273E7004A6BDE003152CE008C94
      DE00000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000042B5E7007BDEFF004AC6F70039A5D6002184
      A5000000000000000000000000000000000000000000000000009CA5A50094A5
      A5009CA5A500949C9C008C8C8C00848484007B8484008C949400949494008484
      84007B7B7B0073848C008C8C8C005294AD000000000000000000000000000000
      00000000000000000000FFBD9400FF9C73000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000094A5B5008494
      A50094A5B50094A5B50094A5B50094A5B50094A5B50094A5B50094A5B50094A5
      B50094A5B5008C9CAD00849CA5007B949C00849CA500849CA500849CA500738C
      9C00849CA500ADBDBD0000000000000000000000000000000000848CB5004263
      D600426BEF003163F700294ADE004A4A84004A5ABD004A6BD6004A6BE7004252
      BD00848CC6000000000000000000000000000000000000000000000000000000
      000000000000000000000000000042B5E70063C6E70039B5E70042A5CE002184
      A50000000000000000000000000000000000000000000000000000000000A5AD
      AD00949C9C0084848400848C8C008C949400949494007B7B7B007B7B7B008C94
      9400949C9C008C9494007B848400848C8C000000000000000000000000000000
      0000000000000000000000000000FFB58C000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000C6CED60094B5
      C600B5EFF700BDF7FF00B5F7FF00A5F7FF0094E7F70084A5B500C6CED6000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007B8CCE004263
      DE00426BEF00426BF7005263DE00000000007373C600395AD600395ADE00526B
      EF004A52C6009CA5C60000000000000000000000000000000000000000000000
      000000000000000000000000000063BDDE002184A5002184A5002184A5007BB5
      C600000000000000000000000000000000000000000000000000000000000000
      0000CECECE0000000000BDBDBD0084848400737B7B009C9C9C009C9C9C008C8C
      8C007B8484005A8C9400ADBDC600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000ADC6
      CE00A5D6DE00A5DEE700A5DEE7009CDEE70094CEDE008CADBD00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000008494BD004A6B
      E7004A6BEF003152D600949CC60000000000000000005A6BC6003152CE003952
      D600636BD60063639C0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000006BC6DE006BC6DE006BC6DE000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000C6C6C60000000000BDBDBD008484840084A5
      A50063C6E70039A5C60000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C6CE
      D60094A5B500849CA50094ADB500849CA50094A5B500C6CED600000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000635A
      730042397B006363AD00000000000000000000000000000000004A63A5004252
      A500293152009C9CBD0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000063CEF70031A5CE0000000000000000000000000000000000000000000000
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
      000000000000000000000000000000000000000000000000000000000000949C
      D600000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000052BDE700319CC60000000000000000000000000000000000000000000000
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
      00004AA5C6006BB5CE0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000080000000200000000100010000000000000200000000000000000000
      000000000000000000000000FFFFFF00FFFFFFFFFFF83FFFFFFFF0FF00000000
      FFFFFFFFFFF007FFFFFFC03F00000000800000FFFFC001FFFFFF800700000000
      0000007FFF80003FFFFE0003000000000000003FFE000007FFBE000300000000
      0000001FFC000001FF9E0003000000000000000FF8000000FC0E000300000000
      00000007F0000000F00600030000000000000003F0000000E006000300000000
      00000001F0000000E00F00030000000000000000F0000000C39F800300000000
      80000000F0000000CFBFD00700000000C0000000F0000000CFFFFA0F00000000
      C0000000F0000000CFFFFFCF00000000C0000000F0000000EFFFFFCF00000000
      C0000000F0000000EFFFFFCB00000000C0000000F8000000F83FFFFB00000000
      C0000000CC000000F00FFFF900000000C000000082000000C001FFF900000000
      C0000000810000008000FEF900000000E0000001800000078000FCC100000000
      E00000018004000F8000F80100000000FC000001C00E600F8000F00300000000
      FC000001E01FF20F8000F00700000000FE000001F01FFE0F8000F81F00000000
      FE000001E00FFE0FC000FCFF00000000FFC00003C007FE0FE000FEFF00000000
      FFC01FFFC103FE0FF401FFFF00000000FFE03FFFC183FF1FFE83FFFF00000000
      FFE03FFFE3C3FFFFFFF3FFFF00000000FFFFFFFFFFEFFFFFFFF3FFFF00000000
      FFFFFFFFFFFFFFFFFFF3FFFF0000000000000000000000000000000000000000
      000000000000}
  end
  object tmEventLog: TTimer
    Enabled = False
    Interval = 8000
    OnTimer = tmEventLogTimer
    Left = 436
    Top = 328
  end
  object ppmIcelog: TPopupMenu
    Left = 466
    Top = 328
    object mnuViewLocation: TMenuItem
      Caption = 'View Location'
      OnClick = mnuViewLocationClick
    end
  end
  object ppmRebuild: TAdvPopupMenu
    OnPopup = ppmRebuildPopup
    MenuStyler = AdvMenuStyler
    Version = '2.5.0.0'
    Left = 650
    Top = 170
    object RecreateCompany3: TMenuItem
      Action = actRecreate
    end
    object ActivateCompany3: TMenuItem
      Action = actActivateCompany
    end
    object DeleteCompany3: TMenuItem
      Action = actDeleteCompany
    end
    object N23: TMenuItem
      Caption = '-'
    end
    object More1: TMenuItem
      Caption = 'More...'
      object RefreshCompanies1: TMenuItem
        Action = actRefreshCompany
      end
    end
  end
  object dsLog: TDataSource
    DataSet = qryLog
    Left = 376
    Top = 328
  end
  object qryLog: TADOQuery
    CacheSize = 100
    CursorType = ctStatic
    Parameters = <>
    Prepared = True
    SQL.Strings = (
      'select * from icelog order by lastupdate desc')
    Left = 406
    Top = 328
    object qryLogId: TAutoIncField
      FieldName = 'Id'
      ReadOnly = True
    end
    object qryLogDescription: TStringField
      FieldName = 'Description'
      Size = 255
    end
    object qryLogLocation: TStringField
      DisplayWidth = 100
      FieldName = 'Location'
      Visible = False
      Size = 64
    end
    object qryLogLastUpdate: TDateTimeField
      DisplayLabel = 'Last Update'
      DisplayWidth = 65
      FieldName = 'LastUpdate'
    end
  end
  object ppmStatusBar: TAdvPopupMenu
    MenuStyler = AdvMenuStyler
    Version = '2.5.0.0'
    Left = 680
    Top = 170
    object mnuCheckDSRStatus: TMenuItem
      Action = actCheckDSRStatus
    end
    object mnuStartDSRService: TMenuItem
      Action = actStartDSRService
    end
    object mnuStopDSRService: TMenuItem
      Action = actStopDSRService
    end
  end
  object tmStart: TTimer
    Enabled = False
    Interval = 100
    OnTimer = tmStartTimer
    Left = 630
    Top = 250
  end
  object appEvents: TApplicationEvents
    OnException = appEventsException
    Left = 310
    Top = 452
  end
  object imgTabSmall: TImageList
    Left = 310
    Top = 424
    Bitmap = {
      494C010103000400040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000005AB5D60042B5DE0042A5CE0073A5B500000000000000
      000000000000000000000000000000000000000000000000000000000000BD9C
      7B00D68C4A00D6843900DE8C5A00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000BDADA500AD9C8C00A5948C00A58C
      84009C846B0094846B00947B63008C735A008C735A00846B5A007B634A009484
      7300000000000000000000000000000000000000000000000000000000000000
      00009CBDC6004ABDE70073DEFF0063CEFF0042C6F70039B5E700398C9C00638C
      8C006B848400000000000000000000000000A57B4A0000000000C6946B00E7A5
      6300DE944A00CE946300D6A57300AD845A000000000000000000000000009C9C
      DE00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B5A58C00FFFFF700EFE7DE00EFD6
      C600DEBDAD00CEB5AD00CEB59C00CEAD9C00C6AD9C00C6A59400B5948400846B
      52008C7B6B0000000000000000000000000000000000000000000000000063BD
      DE0073D6F7007BDEFF007BDEFF0063D6FF004AC6F70039BDEF003184A500525A
      5A004A6363002194BD005AA5BD0000000000A57B4A00C6946B00DEB59400CEA5
      7B00CEBDA5000000000000000000BDAD9C0000000000B5B5EF00B5B5FF009494
      FF007373E70084849C0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000BDA59400FFFFFF00FFFFFF00FFF7
      EF00FFEFE700F7E7DE00EFDECE00EFD6C600F7D6BD00F7CEAD00EFC69C00A58C
      73006B5239009C847B00000000000000000000000000000000006BBDDE008CE7
      FF0094E7FF008CE7FF007BDEFF0063D6FF004AC6F70042BDF70031A5D6004252
      52004252520029A5DE00299CCE00218CAD00A57B4A00D6BD9C00DEC6A5000000
      000000000000000000000000000000000000B5B5FF00BDBDFF00BDBDFF009494
      FF007B7BF70052527B006363FF008C8CF7000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B59C8C00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFF7EF00FFEFEF00F7E7DE00F7E7D600EFCEB500AD94
      7B007B634A006B4A39008C7363000000000000000000000000006BCEEF009CEF
      FF0094E7FF0094E7FF0094E7FF0073B5C6004AC6F70042BDF70031B5EF00299C
      C6003194BD0029ADE70029A5D6002194B500A57B4A00AD845200B5946B00BD9C
      7B00C6AD9C00000000000000000000000000B5B5FF00BDBDFF00A5A5CE008C8C
      C6007B7BF7007B7BFF006B6BFF008C8CF7000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000AD9C9400948C8400A5A59C009C9C
      9C00949C94008C948C008C8C8400848C8400738C8C0063848C0073737B008473
      6B00947B630073635200735242007B6B5A0000000000000000006BCEEF009CEF
      FF009CEFFF008CCEDE008CADAD008C94940073A5AD0039BDEF0042A5CE0039B5
      E70031B5EF0029ADE70029A5DE002194BD000000000000000000000000000000
      0000000000000000000000000000000000009C9CD600A5A5B5009CA5A5008C8C
      94007B7BAD008C8CBD006B6BDE008C8CF7000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000ADCED600C6FFFF00ADF7
      FF009CEFFF007BE7FF006BD6F7005ACEFF004AC6F70029ADE7001094BD005A6B
      73008C8C84008C735A006B5A4200634A390000000000000000006BCEEF0094DE
      F7008CB5BD009CA5A500A5ADAD00949C9C00848C8C005AA5BD004A9CB500739C
      AD0031B5EF0042A5C60029ADE7002194BD000000000000000000000000000000
      000000000000000000000000000000000000000000009C9CA5008C8C8C00848C
      8C00848C8C008C8C8C0084848C00A5A5C6000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000ADCEDE00C6FFFF00BDF7
      FF00B5F7FF0094EFFF0084E7FF0073DEFF0063CEFF004ABDF70031A5D6004284
      9C00428CAD0084736B00846B5200735A4200000000000000000073ADBD008C94
      9400ADADAD00A5ADAD009CA5A5008C949400848C8C00848484006B848400949C
      9C006BA5BD00529CB500639CB5002994BD0000000000000000007BD6F7004AB5
      DE007BB5C600000000000000000000000000000000000000000000000000A5A5
      A5009C9CA5008C8CB5009C9CCE00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000ADCED600C6FFFF00C6EF
      FF00BDF7FF00ADEFFF009CEFFF008CE7FF007BDEFF0063D6FF0052C6EF005AA5
      C6002994C600526B730073736B0084735A00000000006B7BB500000000008C94
      94009CA5B5009CA5AD00949C9C00848C8C007B7B7B00848C8C009C9C9C008C8C
      8C007B7B7B00738C94008C8C8C00298CAD00ADD6E70084DEFF007BDEFF004AC6
      F700319CC600526363004AA5C6009CB5BD000000000000000000000000000000
      000000000000ADADFF009494DE00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000094A5B500A5C6D600A5CE
      D6008CB5C6009CBDCE009CC6D60094C6CE008CBDCE0084BDCE0084BDD60073DE
      FF0042B5DE004A849C003184A500736B5A008C94C6003963E7004A5ABD000000
      00004A5AD6001842DE00737BA5008C8C8C00949C9C00848484007B7B7B008C94
      9400949C9C008C8C8C007B7B7B008C9494007BD6F70094E7FF008CD6E70052B5
      DE0039B5EF00318CB50029A5DE0063B5CE000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000009CB5C6009CC6
      CE008CBDC600A5D6E700ADEFFF00A5EFFF009CE7FF0084E7FF0084DEFF006BD6
      FF0063BDDE0052A5BD00299CBD007B949C00949CBD00527BF700426BF700214A
      C600315AE7002952EF005A6BB5009494940073737300949494009CA5A5008484
      84007B8484004A8C9C0000000000000000007BCEEF0094BDC60094A5A5008494
      9400529CBD0052ADCE0039A5D60063B5D6000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000009CAD
      BD00A5C6D6009CCED6008CB5C6009CBDCE009CC6D60094C6CE008CBDCE0084BD
      CE0084BDD6006BDEFF0039ADD6008494A500000000008C94C600526BDE00396B
      EF00426BEF006B6BBD0000000000000000000000000000000000848484007BA5
      AD0063CEF7003194BD0000000000000000009CADAD00A5ADAD00949C9C008484
      8400848C8C00848C940073949C0073ADC600000000000000000000000000C6B5
      A500BD9C7B00B5946B00AD845200A57B4A000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000094B5C60094BDCE008CBDCE00A5D6E700ADEFFF00ADEFFF009CEFFF008CE7
      FF0084DEFF0073DEFF005ABDE7009CA5B5000000000000000000395ADE003963
      DE004A6BE7007384CE00000000000000000000000000000000000000000084BD
      D60063CEF7002994BD00000000000000000000000000000000009CA5A500848C
      8C008C8C8C008C8C8C0084949C00000000000000000000000000000000000000
      0000BDA58C00D6BD9C00CEAD8C00A57B4A000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000009CADBD00A5C6D6009CCED6008CB5C600ADB5BD00A5ADB5009CAD
      AD00A5ADB5009CADAD00ADB5B50000000000000000006373CE00426BF700636B
      BD005263CE004263DE008C8CC600000000000000000000000000000000008CBD
      CE00399CC600429CB50000000000000000000000000000000000000000000000
      0000000000007BC6DE0084C6DE0000000000BDAD9C000000000000000000D6AD
      8400CEA57B00DEB59400BD946300A57B4A000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000094BDC60094BDCE009CBDC60000000000000000000000
      000000000000000000000000000000000000000000007B84B5004A52BD000000
      0000000000003952BD00636B9C00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000007BBDD6008CB5C60000000000AD8C6300D6A57300CE946300DE94
      4A00E7A56300C69C730000000000A57B4A000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000DE8C5A00D6843900D68C
      4A00BD9C7B000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00FFFFFC3FE1FF0000000FF00740EF0000
      0007E001068300000003C0001F0000000001C000070000000000C000FF000000
      8000C000FF8000008000C000C7E100008000A00000F900008000100000FF0000
      C000000300FF0000E00083C300E00000F000C3E3C1F00000F80181E3F9600000
      FC7F99FFF9020000FFFFFFFFFF87000000000000000000000000000000000000
      000000000000}
  end
  object ppmSystem: TAdvPopupMenu
    OnPopup = ppmSystemPopup
    MenuStyler = AdvMenuStyler
    Version = '2.5.0.0'
    Left = 620
    Top = 168
    object mnuNewCompany: TMenuItem
      Action = actNewCompany
    end
    object N10: TMenuItem
      Caption = '-'
    end
    object mnuUserLogins: TMenuItem
      Action = actUserLogin
    end
    object mnuContacts: TMenuItem
      Action = actContacts
    end
    object mnuUpdateManagerPassw: TMenuItem
      Action = actUpdateManagerPassword
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object mnuConfig: TMenuItem
      Action = ActConfiguration
    end
  end
  object SbStyler: TAdvOfficeStatusBarOfficeStyler
    Style = psOffice2007Luna
    BorderColor = 11566422
    PanelAppearanceLight.BorderColor = clNone
    PanelAppearanceLight.BorderColorHot = 14332564
    PanelAppearanceLight.BorderColorDown = 11566422
    PanelAppearanceLight.Color = 16377559
    PanelAppearanceLight.ColorTo = 16309447
    PanelAppearanceLight.ColorHot = 16307384
    PanelAppearanceLight.ColorHotTo = 15909533
    PanelAppearanceLight.ColorDown = 16175798
    PanelAppearanceLight.ColorDownTo = 14855299
    PanelAppearanceLight.ColorMirror = 16109747
    PanelAppearanceLight.ColorMirrorTo = 16244941
    PanelAppearanceLight.ColorMirrorHot = 15909533
    PanelAppearanceLight.ColorMirrorHotTo = 16505537
    PanelAppearanceLight.ColorMirrorDown = 14855299
    PanelAppearanceLight.ColorMirrorDownTo = 16439486
    PanelAppearanceLight.TextColor = 6365193
    PanelAppearanceLight.TextColorHot = clBlack
    PanelAppearanceLight.TextColorDown = clBlack
    PanelAppearanceLight.TextStyle = [fsBold]
    PanelAppearanceDark.BorderColor = clNone
    PanelAppearanceDark.BorderColorHot = 14332564
    PanelAppearanceDark.BorderColorDown = 11566422
    PanelAppearanceDark.Color = 16309445
    PanelAppearanceDark.ColorTo = 16103047
    PanelAppearanceDark.ColorHot = 16307384
    PanelAppearanceDark.ColorHotTo = 15909533
    PanelAppearanceDark.ColorDown = 16175798
    PanelAppearanceDark.ColorDownTo = 14855299
    PanelAppearanceDark.ColorMirror = 15382160
    PanelAppearanceDark.ColorMirrorTo = 12752244
    PanelAppearanceDark.ColorMirrorHot = 15909533
    PanelAppearanceDark.ColorMirrorHotTo = 16505537
    PanelAppearanceDark.ColorMirrorDown = 14855299
    PanelAppearanceDark.ColorMirrorDownTo = 16439486
    PanelAppearanceDark.TextColor = 6365193
    PanelAppearanceDark.TextColorHot = 6365193
    PanelAppearanceDark.TextColorDown = 6365193
    PanelAppearanceDark.TextStyle = []
    Left = 310
    Top = 480
  end
  object tmErrorEvent: TTimer
    Enabled = False
    Interval = 3000
    OnTimer = tmErrorEventTimer
    Left = 630
    Top = 280
  end
  object advAlert: TAdvAlertWindow
    AlertMessages = <
      item
        ImageIndex = 0
        Tag = 0
      end>
    AlwaysOnTop = True
    AutoHide = True
    AutoSize = False
    AutoDelete = True
    BorderColor = 16765615
    BtnHoverColor = 14483455
    BtnHoverColorTo = 6013175
    BtnDownColor = 557032
    BtnDownColorTo = 8182519
    CaptionColor = 16773091
    CaptionColorTo = 16765615
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    GradientDirection = gdVertical
    HintNextBtn = 'Next'
    HintPrevBtn = 'Previous'
    HintCloseBtn = 'Close'
    HintDeleteBtn = 'Delete'
    HintPopupBtn = 'Popup'
    Hover = False
    MarginX = 4
    MarginY = 1
    PopupLeft = 0
    PopupTop = 0
    PopupWidth = 300
    PopupHeight = 100
    PositionFormat = '%d of %d'
    WindowColor = 16774371
    WindowColorTo = 15587784
    ShowScrollers = True
    ShowDelete = True
    ShowPopup = False
    AlphaEnd = 180
    AlphaStart = 0
    FadeTime = 10
    DisplayTime = 10000
    FadeStep = 10
    WindowPosition = wpRightBottom
    Style = asOffice2007Luna
    Version = '1.5.3.1'
    Left = 340
    Top = 480
  end
  object tmUpdateCompanyInfo: TTimer
    Enabled = False
    Interval = 3000
    OnTimer = tmUpdateCompanyInfoTimer
    Left = 658
    Top = 280
  end
  object tmCheckEmail: TTimer
    Enabled = False
    Interval = 60000
    OnTimer = tmCheckEmailTimer
    Left = 686
    Top = 280
  end
  object AdvPanelStyler: TAdvPanelStyler
    Tag = 0
    Settings.AnchorHint = False
    Settings.AutoHideChildren = False
    Settings.BevelInner = bvNone
    Settings.BevelOuter = bvNone
    Settings.BevelWidth = 1
    Settings.BorderColor = 16765615
    Settings.BorderShadow = False
    Settings.BorderStyle = bsNone
    Settings.BorderWidth = 0
    Settings.CanMove = False
    Settings.CanSize = False
    Settings.Caption.Color = 16773091
    Settings.Caption.ColorTo = 16765615
    Settings.Caption.Font.Charset = DEFAULT_CHARSET
    Settings.Caption.Font.Color = clBlack
    Settings.Caption.Font.Height = -11
    Settings.Caption.Font.Name = 'MS Sans Serif'
    Settings.Caption.Font.Style = []
    Settings.Caption.GradientDirection = gdVertical
    Settings.Caption.Indent = 2
    Settings.Caption.ShadeLight = 255
    Settings.Collaps = False
    Settings.CollapsColor = clHighlight
    Settings.CollapsDelay = 0
    Settings.CollapsSteps = 0
    Settings.Color = 16445929
    Settings.ColorTo = 15587527
    Settings.ColorMirror = 15587527
    Settings.ColorMirrorTo = 16773863
    Settings.Cursor = crDefault
    Settings.Font.Charset = DEFAULT_CHARSET
    Settings.Font.Color = 7485192
    Settings.Font.Height = -11
    Settings.Font.Name = 'MS Sans Serif'
    Settings.Font.Style = []
    Settings.FixedTop = False
    Settings.FixedLeft = False
    Settings.FixedHeight = False
    Settings.FixedWidth = False
    Settings.Height = 120
    Settings.Hover = False
    Settings.HoverColor = clNone
    Settings.HoverFontColor = clNone
    Settings.Indent = 0
    Settings.ShadowColor = clBlack
    Settings.ShadowOffset = 0
    Settings.ShowHint = False
    Settings.ShowMoveCursor = False
    Settings.StatusBar.BorderColor = 16765615
    Settings.StatusBar.BorderStyle = bsSingle
    Settings.StatusBar.Font.Charset = DEFAULT_CHARSET
    Settings.StatusBar.Font.Color = 7485192
    Settings.StatusBar.Font.Height = -11
    Settings.StatusBar.Font.Name = 'Tahoma'
    Settings.StatusBar.Font.Style = []
    Settings.StatusBar.Color = 16245715
    Settings.StatusBar.ColorTo = 16109747
    Settings.StatusBar.GradientDirection = gdVertical
    Settings.TextVAlign = tvaTop
    Settings.TopIndent = 0
    Settings.URLColor = clBlue
    Settings.Width = 0
    Style = psOffice2007Luna
    Left = 368
    Top = 480
  end
  object ppmMore: TAdvPopupMenu
    MenuStyler = AdvMenuStyler
    Version = '2.5.0.0'
    Left = 712
    Top = 170
    object CancelDripfeed3: TMenuItem
      Action = actCancelLink
    end
    object N6: TMenuItem
      Caption = '-'
    end
    object DeactivateCompany2: TMenuItem
      Action = actDeactivateComp
    end
    object RefreshCompanies2: TMenuItem
      Action = actRefreshCompany
    end
  end
end
