object frmDayBook: TfrmDayBook
  Left = 81
  Top = 104
  Width = 633
  Height = 379
  HelpContext = 78
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  Caption = 'E-Business Daybook'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  KeyPreview = True
  OldCreateOrder = True
  PopupMenu = mnuPopup
  Position = poDefault
  Scaled = False
  ShowHint = True
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object sptFormDivider: TSplitter
    Left = 0
    Top = 181
    Width = 625
    Height = 4
    Cursor = crVSplit
    Align = alBottom
    Beveled = True
    MinSize = 1
    OnCanResize = sptFormDividerCanResize
    OnMoved = sptFormDividerMoved
  end
  object pnlClient: TPanel
    Left = 0
    Top = 0
    Width = 625
    Height = 181
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object pnlButtons: TSBSPanel
      Left = 515
      Top = 4
      Width = 107
      Height = 180
      BevelOuter = bvNone
      BorderStyle = bsSingle
      TabOrder = 0
      AllowReSize = False
      IsGroupBox = False
      TextId = 0
      object sbxButtons: TScrollBox
        Left = 0
        Top = 64
        Width = 99
        Height = 113
        HorzScrollBar.Visible = False
        VertScrollBar.Position = 101
        BorderStyle = bsNone
        Color = clBtnFace
        ParentColor = False
        TabOrder = 0
        object btnEdit: TButton
          Left = 2
          Top = -95
          Width = 80
          Height = 21
          HelpContext = 79
          Action = actEditTrans
          TabOrder = 0
        end
        object btnPost: TButton
          Left = 2
          Top = 45
          Width = 80
          Height = 21
          Hint = 'Post the daybook|Allows the posting of the current daybook.'
          HelpContext = 83
          Caption = 'Daybook &Post'
          TabOrder = 6
          OnClick = btnClickShowPopup
        end
        object btnDelete: TButton
          Left = 2
          Top = 68
          Width = 80
          Height = 21
          Hint = 
            'Delete transactions|Delete transactions permanently from the Day' +
            'book.'
          HelpContext = 84
          Caption = '&Delete'
          TabOrder = 7
          OnClick = btnClickShowPopup
        end
        object btnTag: TButton
          Left = 2
          Top = 22
          Width = 80
          Height = 21
          HelpContext = 82
          Caption = '&Tag'
          TabOrder = 5
          OnClick = btnClickShowPopup
        end
        object btnHold: TButton
          Left = 2
          Top = -1
          Width = 80
          Height = 21
          HelpContext = 81
          Action = actHoldTrans
          TabOrder = 4
        end
        object btnRefresh: TButton
          Left = 2
          Top = -25
          Width = 80
          Height = 21
          HelpContext = 80
          Action = actRefresh
          TabOrder = 3
        end
        object btnView: TButton
          Left = 2
          Top = -71
          Width = 80
          Height = 21
          HelpContext = 79
          Action = actViewTrans
          TabOrder = 1
        end
        object btnShowHide: TButton
          Left = 2
          Top = -48
          Width = 80
          Height = 21
          HelpContext = 85
          Action = actHideShow
          TabOrder = 2
        end
        object btnPrint: TButton
          Left = 2
          Top = 92
          Width = 80
          Height = 21
          Caption = 'P&rint HTML'
          TabOrder = 8
          OnClick = btnPrintClick
        end
      end
      object btnClose: TButton
        Left = 2
        Top = 3
        Width = 80
        Height = 21
        HelpContext = 24
        Cancel = True
        Caption = '&Close'
        ModalResult = 2
        TabOrder = 1
        OnClick = actCloseExecute
      end
    end
    object sbxMain: TScrollBox
      Left = 1
      Top = 4
      Width = 488
      Height = 181
      VertScrollBar.Visible = False
      TabOrder = 1
      object pnlDate: TSBSPanel
        Left = 71
        Top = 24
        Width = 65
        Height = 134
        BevelInner = bvLowered
        BevelOuter = bvLowered
        Color = clTeal
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnMouseUp = MoveAlignColsExecute
        AllowReSize = True
        IsGroupBox = False
        TextId = 0
      end
      object pnlORef: TSBSPanel
        Left = 4
        Top = 24
        Width = 65
        Height = 134
        BevelInner = bvLowered
        BevelOuter = bvLowered
        Color = clTeal
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        OnMouseUp = MoveAlignColsExecute
        AllowReSize = True
        IsGroupBox = False
        TextId = 0
      end
      object pnlPer: TSBSPanel
        Left = 138
        Top = 24
        Width = 51
        Height = 134
        BevelInner = bvLowered
        BevelOuter = bvLowered
        Color = clTeal
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        OnMouseUp = MoveAlignColsExecute
        AllowReSize = True
        IsGroupBox = False
        TextId = 0
      end
      object pnlAC: TSBSPanel
        Left = 191
        Top = 24
        Width = 65
        Height = 134
        BevelInner = bvLowered
        BevelOuter = bvLowered
        Color = clTeal
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        OnMouseUp = MoveAlignColsExecute
        AllowReSize = True
        IsGroupBox = False
        TextId = 0
      end
      object pnlAmnt: TSBSPanel
        Left = 258
        Top = 24
        Width = 106
        Height = 134
        BevelInner = bvLowered
        BevelOuter = bvLowered
        Color = clTeal
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 4
        OnMouseUp = MoveAlignColsExecute
        AllowReSize = True
        IsGroupBox = False
        TextId = 0
      end
      object pnlStat: TSBSPanel
        Left = 366
        Top = 24
        Width = 95
        Height = 134
        BevelInner = bvLowered
        BevelOuter = bvLowered
        Color = clTeal
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 5
        OnMouseUp = MoveAlignColsExecute
        AllowReSize = True
        IsGroupBox = False
        TextId = 0
      end
      object pnlColumnHeaders: TSBSPanel
        Left = 4
        Top = 3
        Width = 528
        Height = 17
        BevelInner = bvLowered
        BevelOuter = bvNone
        TabOrder = 6
        OnMouseDown = HeadersMouseDownExecute
        OnMouseMove = HeadersMouseMoveExecute
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        object pnlORefHead: TSBSPanel
          Left = 4
          Top = 2
          Width = 61
          Height = 13
          Alignment = taLeftJustify
          BevelOuter = bvNone
          Caption = 'Our Ref'
          Ctl3D = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 0
          OnMouseDown = HeadersMouseDownExecute
          OnMouseMove = HeadersMouseMoveExecute
          OnMouseUp = MoveAlignColsExecute
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
        end
        object pnlDateHead: TSBSPanel
          Left = 67
          Top = 2
          Width = 65
          Height = 13
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
          OnMouseDown = HeadersMouseDownExecute
          OnMouseMove = HeadersMouseMoveExecute
          OnMouseUp = MoveAlignColsExecute
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
        end
        object pnlACHead: TSBSPanel
          Left = 191
          Top = 2
          Width = 64
          Height = 13
          Alignment = taLeftJustify
          BevelOuter = bvNone
          Caption = 'A/C'
          Ctl3D = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 2
          OnMouseDown = HeadersMouseDownExecute
          OnMouseMove = HeadersMouseMoveExecute
          OnMouseUp = MoveAlignColsExecute
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
        end
        object pnlAmntHead: TSBSPanel
          Left = 256
          Top = 2
          Width = 110
          Height = 13
          Alignment = taRightJustify
          BevelOuter = bvNone
          Caption = 'Amount   '
          Ctl3D = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 3
          OnMouseDown = HeadersMouseDownExecute
          OnMouseMove = HeadersMouseMoveExecute
          OnMouseUp = MoveAlignColsExecute
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
        end
        object pnlStatHead: TSBSPanel
          Left = 358
          Top = 2
          Width = 95
          Height = 13
          Alignment = taLeftJustify
          BevelOuter = bvNone
          Caption = '   Status'
          Ctl3D = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 4
          OnMouseDown = HeadersMouseDownExecute
          OnMouseMove = HeadersMouseMoveExecute
          OnMouseUp = MoveAlignColsExecute
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
        end
        object pnlPerHead: TSBSPanel
          Left = 134
          Top = 2
          Width = 53
          Height = 13
          BevelOuter = bvNone
          Caption = 'Period'
          Ctl3D = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 5
          OnMouseDown = HeadersMouseDownExecute
          OnMouseMove = HeadersMouseMoveExecute
          OnMouseUp = MoveAlignColsExecute
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
        end
        object pnlYRefHead: TSBSPanel
          Left = 454
          Top = 2
          Width = 51
          Height = 13
          BevelOuter = bvNone
          Caption = 'Your Ref'
          Ctl3D = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 6
          OnMouseDown = HeadersMouseDownExecute
          OnMouseMove = HeadersMouseMoveExecute
          OnMouseUp = MoveAlignColsExecute
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
        end
      end
      object pnlYRef: TSBSPanel
        Left = 463
        Top = 24
        Width = 65
        Height = 134
        BevelInner = bvLowered
        BevelOuter = bvLowered
        Color = clTeal
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 7
        OnMouseUp = MoveAlignColsExecute
        AllowReSize = True
        IsGroupBox = False
        TextId = 0
      end
    end
    object pnlListControls: TSBSPanel
      Left = 492
      Top = 32
      Width = 18
      Height = 153
      BevelOuter = bvLowered
      TabOrder = 2
      AllowReSize = False
      IsGroupBox = False
      TextId = 0
    end
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 185
    Width = 625
    Height = 160
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object pgcTransactions: TPageControl
      Left = 0
      Top = 0
      Width = 625
      Height = 160
      ActivePage = tabHTML
      Align = alClient
      TabIndex = 1
      TabOrder = 0
      OnChange = pgcTransactionsChange
      object tabImportLog: TTabSheet
        Caption = 'Import Log'
        object edtLog: TRichEdit
          Left = 0
          Top = 0
          Width = 617
          Height = 132
          Align = alClient
          Lines.Strings = (
            '')
          TabOrder = 0
        end
      end
      object tabHTML: TTabSheet
        Caption = 'HTML'
        ImageIndex = 1
        object Panel1: TPanel
          Left = 0
          Top = 0
          Width = 617
          Height = 132
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 0
          object HTMLViewer: THTMLViewer
            Left = 0
            Top = 0
            Width = 617
            Height = 132
            TabOrder = 0
            Align = alClient
            BorderStyle = htFocused
            HistoryMaxCount = 0
            DefFontName = 'Times New Roman'
            DefPreFontName = 'Courier New'
            NoSelect = False
            CharSet = DEFAULT_CHARSET
            PrintMarginLeft = 2
            PrintMarginRight = 2
            PrintMarginTop = 2
            PrintMarginBottom = 2
          end
        end
      end
      object tabXML: TTabSheet
        Caption = 'XML'
        ImageIndex = 2
        object lvXML: TListView
          Left = 0
          Top = 0
          Width = 617
          Height = 132
          Align = alClient
          Columns = <
            item
              AutoSize = True
            end>
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          SmallImages = ImageList1
          TabOrder = 0
          ViewStyle = vsReport
        end
      end
    end
    object cbxStyleSheet: TComboBox
      Left = 339
      Top = 0
      Width = 283
      Height = 21
      ItemHeight = 13
      TabOrder = 1
      Visible = False
      OnChange = cbxStyleSheetChange
    end
  end
  object mnuPopup: TPopupMenu
    OnPopup = mnuPopupPopup
    Left = 440
    Top = 3
    object mniClose: TMenuItem
      Action = actClose
    end
    object mniEdit: TMenuItem
      Action = actEditTrans
    end
    object mniView: TMenuItem
      Action = actViewTrans
    end
    object mniHideDetails: TMenuItem
      Action = actHideShow
    end
    object mniRefresh: TMenuItem
      Action = actRefresh
    end
    object mniHold: TMenuItem
      Tag = 2
      Action = actHoldTrans
    end
    object mniTag: TMenuItem
      Caption = '&Tag'
      OnClick = actTagTransExecute
    end
    object mniPost: TMenuItem
      Caption = 'Daybook &Post'
      OnClick = mniPostClick
      object mniSubPostCurrent: TMenuItem
        Caption = '&Current Row'
        OnClick = mniPostClick
      end
      object mniSubPostTagged: TMenuItem
        Caption = '&Tagged'
        OnClick = mniPostClick
      end
      object mniSubPostAll: TMenuItem
        Caption = '&All'
        OnClick = mniPostClick
      end
    end
    object mniDelete: TMenuItem
      Caption = '&Delete'
      object mniSubDeleteCurrent: TMenuItem
        Caption = '&Current Line'
        OnClick = mniDeleteClick
      end
      object mniSubDeleteTagged: TMenuItem
        Caption = '&Tagged Lines'
        OnClick = mniDeleteClick
      end
      object mniSubDeleteErrors: TMenuItem
        Caption = '&Error Lines'
        OnClick = mniDeleteClick
      end
    end
    object mnuPopupSep1: TMenuItem
      Caption = '-'
    end
    object mniProperties: TMenuItem
      Caption = 'Pr&operties'
      Hint = 'Access Colour & Font settings'
      OnClick = mniPropertiesClick
    end
    object mnuPopupSep2: TMenuItem
      Caption = '-'
    end
    object mniSaveOnExit: TMenuItem
      Caption = '&Save Coordinates'
      Hint = 'Make the current window settings permanent'
      OnClick = mniSaveOnExitClick
    end
  end
  object actDaybookMain: TActionList
    Left = 408
    Top = 3
    object actRefresh: TAction
      Caption = '&Refresh'
      OnExecute = actRefreshExecute
    end
    object actClose: TAction
      Caption = '&Close'
      OnExecute = actCloseExecute
    end
    object actEditTrans: TAction
      Caption = '&Edit'
      OnExecute = actEditTransExecute
    end
    object actViewTrans: TAction
      Caption = '&View'
      OnExecute = actViewTransExecute
    end
    object actHoldTrans: TAction
      Caption = '&Hold'
      OnExecute = actHoldTransExecute
    end
    object actTagTrans: TAction
      Caption = '&Tag'
      OnExecute = actTagTransExecute
    end
    object actHTML: TAction
      Caption = 'HT&ML'
      OnExecute = actHTMLExecute
    end
    object actHideShow: TAction
      Caption = '&Hide Details'
      OnExecute = actHideShowExecute
    end
  end
  object mnuDelete: TPopupMenu
    Left = 485
    Top = 140
    object mniDeleteCurrent: TMenuItem
      Caption = '&Current Line'
      OnClick = mniDeleteClick
    end
    object mniDeleteTagged: TMenuItem
      Caption = '&Tagged Lines'
      OnClick = mniDeleteClick
    end
    object mniDeleteErrors: TMenuItem
      Caption = '&Error Lines'
      OnClick = mniDeleteClick
    end
  end
  object mnuPost: TPopupMenu
    Left = 485
    Top = 108
    object mniPostCurrent: TMenuItem
      Caption = 'This &Transaction'
      OnClick = mniPostClick
    end
    object mniPostTagged: TMenuItem
      Caption = 'Ta&gged'
      OnClick = mniPostClick
    end
    object mniPostAll: TMenuItem
      Caption = '&All'
      OnClick = mniPostClick
    end
  end
  object mnuTag: TPopupMenu
    Left = 485
    Top = 79
    object mniTagCurrent: TMenuItem
      Caption = '&Tag/Untag this line'
      OnClick = actTagTransExecute
    end
    object mniTagAll: TMenuItem
      Caption = 'Tag &All lines'
      OnClick = actTagTransExecute
    end
    object mniUntagAll: TMenuItem
      Caption = '&Untag all tagged lines'
      OnClick = actTagTransExecute
    end
  end
  object ImageList1: TImageList
    Width = 12
    Left = 540
    Top = 312
  end
  object PrintDialog1: TPrintDialog
    Left = 509
    Top = 313
  end
  object XmlScanner: TXmlScanner
    Normalize = True
    OnXmlProlog = XmlScannerXmlProlog
    OnStartTag = XmlScannerStartTag
    OnEmptyTag = XmlScannerEmptyTag
    OnEndTag = XmlScannerEndTag
    OnContent = XmlScannerContent
    Left = 576
    Top = 312
  end
end
