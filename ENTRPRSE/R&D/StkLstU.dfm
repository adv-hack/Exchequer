object StkList: TStkList
  Left = 431
  Top = 223
  Width = 629
  Height = 373
  HelpContext = 178
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  Caption = 'Stock List'
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
  ShowHint = True
  Visible = True
  OnActivate = FormActivate
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnDeactivate = FormDeactivate
  OnKeyDown = FormKeyDown
  OnMouseDown = FormMouseDown
  OnPaint = FormPaint
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 14
  object pcStockList: TPageControl
    Left = 3
    Top = 3
    Width = 614
    Height = 333
    HelpContext = 178
    ActivePage = TabSheet1
    Images = ImageRepos.MulCtrlImages
    TabIndex = 0
    TabOrder = 0
    OnChange = pcStockListChange
    OnChanging = pcStockListChanging
    object TabSheet1: TTabSheet
      Caption = 'Stock List'
      ImageIndex = -1
      object SLSBox: TScrollBox
        Left = -1
        Top = 0
        Width = 483
        Height = 302
        VertScrollBar.Visible = False
        BorderStyle = bsNone
        TabOrder = 0
        object SLDPanel: TSBSPanel
          Left = 124
          Top = 24
          Width = 148
          Height = 261
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
          OnMouseUp = SLCPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object SLCPanel: TSBSPanel
          Left = 4
          Top = 24
          Width = 117
          Height = 261
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
          OnMouseUp = SLCPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object SLFPanel: TSBSPanel
          Left = 343
          Top = 24
          Width = 65
          Height = 261
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
          OnMouseUp = SLCPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object SLIPanel: TSBSPanel
          Left = 275
          Top = 24
          Width = 65
          Height = 261
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
          OnMouseUp = SLCPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object SLHedPanel: TSBSPanel
          Left = 4
          Top = 2
          Width = 472
          Height = 19
          BevelOuter = bvLowered
          Color = clWhite
          TabOrder = 4
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumnHeader
          object SLCLab: TSBSPanel
            Left = 3
            Top = 3
            Width = 116
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
            TabOrder = 0
            OnMouseDown = SLCLabMouseDown
            OnMouseMove = SLCLabMouseMove
            OnMouseUp = SLCPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object SLDLab: TSBSPanel
            Left = 120
            Top = 3
            Width = 151
            Height = 14
            BevelOuter = bvNone
            Caption = 'Description'
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
            OnMouseDown = SLCLabMouseDown
            OnMouseMove = SLCLabMouseMove
            OnMouseUp = SLCPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object SLILab: TSBSPanel
            Left = 274
            Top = 3
            Width = 65
            Height = 14
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = 'In Stock  '
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
            OnMouseDown = SLCLabMouseDown
            OnMouseMove = SLCLabMouseMove
            OnMouseUp = SLCPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object SLFLab: TSBSPanel
            Left = 342
            Top = 3
            Width = 65
            Height = 14
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = 'Free Stock  '
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
            OnMouseDown = SLCLabMouseDown
            OnMouseMove = SLCLabMouseMove
            OnMouseUp = SLCPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object SLOLab: TSBSPanel
            Left = 407
            Top = 3
            Width = 63
            Height = 14
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = 'On Order  '
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
            OnMouseDown = SLCLabMouseDown
            OnMouseMove = SLCLabMouseMove
            OnMouseUp = SLCPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
        end
        object SLOPanel: TSBSPanel
          Left = 411
          Top = 24
          Width = 65
          Height = 261
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
          OnMouseUp = SLCPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
      end
      object SLListBtnPanel: TSBSPanel
        Left = 477
        Top = 24
        Width = 18
        Height = 261
        BevelOuter = bvLowered
        TabOrder = 1
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Re-Order'
      ImageIndex = -1
      object ROSBox: TScrollBox
        Left = -1
        Top = 0
        Width = 476
        Height = 307
        HorzScrollBar.Position = 63
        VertScrollBar.Visible = False
        BorderStyle = bsNone
        TabOrder = 0
        object ROCPanel: TSBSPanel
          Left = 3
          Top = 24
          Width = 108
          Height = 265
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
          OnMouseUp = SLCPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object ROSPanel: TSBSPanel
          Left = -59
          Top = 24
          Width = 59
          Height = 265
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
          OnMouseUp = SLCPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object ROMPanel: TSBSPanel
          Left = 171
          Top = 24
          Width = 54
          Height = 265
          HelpContext = 1339
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
          OnMouseUp = SLCPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object ROFPanel: TSBSPanel
          Left = 114
          Top = 24
          Width = 54
          Height = 265
          HelpContext = 1338
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
          OnMouseUp = SLCPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object ROHedPanel: TSBSPanel
          Left = -59
          Top = 2
          Width = 534
          Height = 19
          BevelOuter = bvLowered
          Color = clWhite
          TabOrder = 4
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumnHeader
          object ROCLab: TSBSPanel
            Left = 61
            Top = 3
            Width = 108
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
            TabOrder = 0
            OnMouseDown = SLCLabMouseDown
            OnMouseMove = SLCLabMouseMove
            OnMouseUp = SLCPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object ROSLab: TSBSPanel
            Left = 1
            Top = 3
            Width = 57
            Height = 14
            BevelOuter = bvNone
            Caption = 'Supplier'
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
            OnMouseDown = SLCLabMouseDown
            OnMouseMove = SLCLabMouseMove
            OnMouseUp = SLCPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object RONLab: TSBSPanel
            Left = 343
            Top = 3
            Width = 54
            Height = 14
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = 'Need   '
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
            OnMouseDown = SLCLabMouseDown
            OnMouseMove = SLCLabMouseMove
            OnMouseUp = SLCPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object ROFLab: TSBSPanel
            Left = 173
            Top = 3
            Width = 52
            Height = 14
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = 'Free   '
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
            OnMouseDown = SLCLabMouseDown
            OnMouseMove = SLCLabMouseMove
            OnMouseUp = SLCPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object ROOLab: TSBSPanel
            Left = 287
            Top = 3
            Width = 54
            Height = 14
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = 'On Ord  '
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
            OnMouseDown = SLCLabMouseDown
            OnMouseMove = SLCLabMouseMove
            OnMouseUp = SLCPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object ROMLab: TSBSPanel
            Left = 229
            Top = 3
            Width = 54
            Height = 14
            BevelOuter = bvNone
            Caption = 'Min Stk'
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
            OnMouseDown = SLCLabMouseDown
            OnMouseMove = SLCLabMouseMove
            OnMouseUp = SLCPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object RORLab: TSBSPanel
            Left = 400
            Top = 3
            Width = 54
            Height = 14
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = 'Order   '
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
            OnMouseDown = SLCLabMouseDown
            OnMouseMove = SLCLabMouseMove
            OnMouseUp = SLCPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object ROTLab: TSBSPanel
            Left = 456
            Top = 3
            Width = 77
            Height = 14
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = 'Cost   '
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
            OnMouseDown = SLCLabMouseDown
            OnMouseMove = SLCLabMouseMove
            OnMouseUp = SLCPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
        end
        object RONPanel: TSBSPanel
          Left = 285
          Top = 24
          Width = 54
          Height = 265
          HelpContext = 1341
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
          OnMouseUp = SLCPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object ROOPanel: TSBSPanel
          Left = 228
          Top = 24
          Width = 54
          Height = 265
          HelpContext = 1340
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
          OnMouseUp = SLCPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object RORPanel: TSBSPanel
          Left = 342
          Top = 24
          Width = 54
          Height = 265
          HelpContext = 1342
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
          OnMouseUp = SLCPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object ROTPanel: TSBSPanel
          Left = 399
          Top = 24
          Width = 77
          Height = 265
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
          OnMouseUp = SLCPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
      end
      object ROListBtnPanel: TSBSPanel
        Left = 479
        Top = 22
        Width = 18
        Height = 266
        BevelOuter = bvLowered
        TabOrder = 1
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Stock Take'
      ImageIndex = -1
      object STSBox: TScrollBox
        Left = -2
        Top = -1
        Width = 483
        Height = 307
        VertScrollBar.Visible = False
        BorderStyle = bsNone
        TabOrder = 0
        object STCPanel: TSBSPanel
          Left = 66
          Top = 24
          Width = 108
          Height = 265
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
          OnMouseUp = SLCPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object STBPanel: TSBSPanel
          Left = 4
          Top = 24
          Width = 59
          Height = 265
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
          OnMouseUp = SLCPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object STDPanel: TSBSPanel
          Left = 177
          Top = 24
          Width = 110
          Height = 265
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
          OnMouseUp = SLCPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object STHedPanel: TSBSPanel
          Left = 4
          Top = 2
          Width = 458
          Height = 19
          BevelOuter = bvLowered
          Color = clWhite
          TabOrder = 3
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumnHeader
          object STCLab: TSBSPanel
            Left = 61
            Top = 3
            Width = 108
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
            TabOrder = 0
            OnMouseDown = SLCLabMouseDown
            OnMouseMove = SLCLabMouseMove
            OnMouseUp = SLCPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object STBLab: TSBSPanel
            Left = 1
            Top = 3
            Width = 57
            Height = 14
            BevelOuter = bvNone
            Caption = 'Bin Locn'
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
            OnMouseDown = SLCLabMouseDown
            OnMouseMove = SLCLabMouseMove
            OnMouseUp = SLCPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object STALab: TSBSPanel
            Left = 343
            Top = 3
            Width = 54
            Height = 14
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = 'Actual  '
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
            OnMouseDown = SLCLabMouseDown
            OnMouseMove = SLCLabMouseMove
            OnMouseUp = SLCPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object STDLAb: TSBSPanel
            Left = 173
            Top = 3
            Width = 109
            Height = 14
            BevelOuter = bvNone
            Caption = 'Description'
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
            OnMouseDown = SLCLabMouseDown
            OnMouseMove = SLCLabMouseMove
            OnMouseUp = SLCPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object STILab: TSBSPanel
            Left = 287
            Top = 3
            Width = 54
            Height = 14
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = 'In Stock  '
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
            OnMouseDown = SLCLabMouseDown
            OnMouseMove = SLCLabMouseMove
            OnMouseUp = SLCPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object STFLab: TSBSPanel
            Left = 400
            Top = 3
            Width = 54
            Height = 14
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = 'Difference'
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
            OnMouseDown = SLCLabMouseDown
            OnMouseMove = SLCLabMouseMove
            OnMouseUp = SLCPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
        end
        object STAPanel: TSBSPanel
          Left = 348
          Top = 24
          Width = 54
          Height = 265
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
          OnMouseUp = SLCPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object STIPanel: TSBSPanel
          Left = 291
          Top = 24
          Width = 54
          Height = 265
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
          OnMouseUp = SLCPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object STFPanel: TSBSPanel
          Left = 405
          Top = 24
          Width = 54
          Height = 265
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
          OnMouseUp = SLCPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
      end
      object STListBtnPanel: TSBSPanel
        Left = 461
        Top = 20
        Width = 18
        Height = 266
        BevelOuter = bvLowered
        TabOrder = 1
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
      end
    end
  end
  object SLBtnPanel: TSBSPanel
    Left = 502
    Top = 29
    Width = 109
    Height = 303
    BevelOuter = bvNone
    Caption = 'SLBtnPanel'
    PopupMenu = PopupMenu1
    TabOrder = 1
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
    object ClsDb1Btn: TButton
      Left = 3
      Top = 20
      Width = 80
      Height = 21
      HelpContext = 24
      Cancel = True
      Caption = '&Close'
      ModalResult = 2
      TabOrder = 0
      OnClick = ClsDb1BtnClick
    end
    object SLBSBox: TScrollBox
      Left = 3
      Top = 60
      Width = 100
      Height = 242
      HorzScrollBar.Visible = False
      VertScrollBar.Position = 388
      BorderStyle = bsNone
      Color = clBtnFace
      ParentColor = False
      TabOrder = 1
      object Editdb1Btn: TButton
        Left = 0
        Top = -361
        Width = 80
        Height = 21
        Hint = 
          'Edit stock record|Choosing this option allows you to edit the cu' +
          'rrently highlighted record.'
        HelpContext = 155
        Caption = '&Edit'
        TabOrder = 1
        OnClick = Editdb1BtnClick
      end
      object FindDb1Btn: TButton
        Left = 0
        Top = -337
        Width = 80
        Height = 21
        Hint = 
          'Find stock record|Choosing this option allows you to find a stoc' +
          'k record within the list using object find.'
        HelpContext = 165
        Caption = '&Find'
        TabOrder = 2
        OnClick = FindDb1BtnClick
      end
      object Deldb1Btn: TButton
        Left = 0
        Top = -78
        Width = 80
        Height = 21
        Hint = 
          'Delete stock record|Choosing this option allows you to delete th' +
          'e currently highlighted record, as long as no transactions exist' +
          ' for it.'
        HelpContext = 159
        Caption = '&Delete'
        Enabled = False
        TabOrder = 13
        OnClick = Editdb1BtnClick
      end
      object Notedb1Btn: TButton
        Left = 0
        Top = -241
        Width = 80
        Height = 21
        Hint = 
          'View notepad for stock record|Choosing this option allows you vi' +
          'ew the notepad for currently highlighted record.'
        HelpContext = 80
        Caption = '&Notes'
        TabOrder = 6
        OnClick = Editdb1BtnClick
      end
      object Chkdb1Btn: TButton
        Left = 0
        Top = -32
        Width = 80
        Height = 21
        Hint = 
          'Recalculate stock levels|Choosing this option allows you to reca' +
          'lculate the stock levels for currently highlighted record.'
        HelpContext = 187
        Caption = 'Chec&k'
        TabOrder = 15
        OnClick = Chkdb1BtnClick
      end
      object Valdb1Btn: TButton
        Left = 0
        Top = -147
        Width = 80
        Height = 21
        Hint = 
          'View valuation details|Choosing this option allows you to view t' +
          'he valuation screen for the currently highlighted record.'
        HelpContext = 157
        Caption = '&Value'
        TabOrder = 10
        OnClick = Editdb1BtnClick
      end
      object Pricdb1Btn: TButton
        Left = 0
        Top = -170
        Width = 80
        Height = 21
        Hint = 
          'Display selling prices|Choosing this option displays the selling' +
          ' price bands for any highlighted record.'
        HelpContext = 451
        Caption = '&Prices'
        TabOrder = 9
        OnClick = Pricdb1BtnClick
      end
      object Leddb1Btn: TButton
        Left = 0
        Top = -313
        Width = 80
        Height = 21
        Hint = 
          'View Ledger details|Choosing this option allows you to view the ' +
          'stock ledger for the currently highlighted record.'
        HelpContext = 153
        Caption = '&Ledger'
        TabOrder = 3
        OnClick = Editdb1BtnClick
      end
      object Histdb1Btn: TButton
        Left = 0
        Top = -289
        Width = 80
        Height = 21
        Hint = 
          'View sales history|Choosing this option allows you to view the s' +
          'ales history by period for the currently highlighted record.'
        HelpContext = 164
        Caption = '&History'
        TabOrder = 4
        OnClick = Editdb1BtnClick
      end
      object Builddb1Btn: TButton
        Left = 0
        Top = -193
        Width = 80
        Height = 21
        Hint = 
          'View Bill of material details|Choosing this option allows you to' +
          ' access options for Bill of materials and their components.'
        HelpContext = 449
        Caption = '&Build'
        TabOrder = 8
        OnClick = Builddb1BtnClick
      end
      object Sortdb1Btn: TButton
        Left = 0
        Top = -217
        Width = 80
        Height = 21
        Hint = 
          'Sort Stock List|Alternates the stock list to display in stock co' +
          'de, description, parent code/stock code order.'
        HelpContext = 450
        Caption = '&Sort'
        Enabled = False
        TabOrder = 7
        OnClick = Sortdb1BtnClick
      end
      object Qtydb1Btn: TButton
        Left = 0
        Top = -124
        Width = 80
        Height = 21
        Hint = 
          'View qty break details|Choosing this option allows you to view t' +
          'he qty break discounts screen for the currently highlighted reco' +
          'rd.'
        HelpContext = 158
        Caption = '&Qty-Breaks'
        Enabled = False
        TabOrder = 11
        OnClick = Editdb1BtnClick
      end
      object Agedb1Btn: TButton
        Left = 0
        Top = -101
        Width = 80
        Height = 21
        Hint = 
          'Show supply/demand details|Choosing this option allows you to vi' +
          'ew the current supply/demand situation for the currently highlig' +
          'hted record.'
        HelpContext = 160
        Caption = '&Age'
        TabOrder = 12
        OnClick = Agedb1BtnClick
      end
      object DLdb1Btn: TButton
        Tag = 1
        Left = 0
        Top = -9
        Width = 80
        Height = 21
        Hint = 
          'Show all Stock Items|Toggles between showing all stock items, or' +
          ' products only.'
        HelpContext = 520
        Caption = 'De-L&ist'
        TabOrder = 16
        OnClick = DLdb1BtnClick
      end
      object Mindb1Btn: TButton
        Tag = 2
        Left = 0
        Top = 14
        Width = 80
        Height = 21
        Hint = 
          'Show Stock records below min|Toggles between showing stock recor' +
          'ds below their minimum level, or all Stock records.'
        HelpContext = 521
        Caption = '&Min'
        TabOrder = 17
        OnClick = DLdb1BtnClick
      end
      object ASdb1Btn: TButton
        Left = 0
        Top = 37
        Width = 80
        Height = 21
        Hint = 
          'Set Re-order qty as suggested|Automatically sets the Order qty a' +
          's per the Need column.'
        HelpContext = 522
        Caption = '&Auto Set'
        TabOrder = 18
        OnClick = ASdb1BtnClick
      end
      object BOdb1Btn: TButton
        Tag = 3
        Left = 0
        Top = 60
        Width = 80
        Height = 21
        Hint = 
          'Switch to Back Order Mode|Switches display to show stock records' +
          ' which have sales orders outstanding against them giving back to' +
          ' back ordering information.'
        HelpContext = 523
        Caption = 'Bac&k Order'
        TabOrder = 19
        OnClick = DLdb1BtnClick
      end
      object FIDb1Btn: TButton
        Left = 0
        Top = 106
        Width = 80
        Height = 21
        Hint = 
          'Filter the list by Supplier...|Filter the Re-Order list by Suppl' +
          'ier or Stock Group.'
        HelpContext = 524
        Caption = 'Fil&ter'
        TabOrder = 21
        OnClick = FIDb1BtnClick
      end
      object FRdb1Btn: TButton
        Left = 0
        Top = 83
        Width = 80
        Height = 21
        Hint = 
          'Freeze the current stock level|Freezes the current stock level t' +
          'o allow the system to be used whilst the stock take is being ent' +
          'ered.'
        HelpContext = 534
        Caption = 'Free&ze'
        TabOrder = 20
        OnClick = FRdb1BtnClick
      end
      object PRdb1Btn: TButton
        Left = 0
        Top = 129
        Width = 80
        Height = 21
        Hint = 'Process the list|Process the list as highlighted.'
        HelpContext = 525
        Caption = 'P&rocess'
        TabOrder = 22
        OnClick = PRdb1BtnClick
      end
      object Locdb1Btn: TButton
        Left = 0
        Top = -55
        Width = 80
        Height = 21
        Hint = 
          'Change the current Location|Allows the list to be viewed by a di' +
          'fferent Location, or all Locations. Also gives access to Locatio' +
          'n Stock Records.'
        HelpContext = 499
        Caption = 'L&ocation'
        TabOrder = 14
        OnClick = Locdb1BtnClick
      end
      object Lnkdb1Btn: TButton
        Left = 0
        Top = 175
        Width = 80
        Height = 21
        Hint = 
          'Link to additional information|Displays a list of any additional' +
          ' information attached to this Stock Record.'
        HelpContext = 525
        Caption = 'Links'
        TabOrder = 24
        OnClick = Lnkdb1BtnClick
      end
      object Altdb1Btn: TButton
        Left = 0
        Top = 152
        Width = 80
        Height = 21
        Hint = 
          'Show alternative codes|This option displays a list of alternativ' +
          'e codes available for the highlighted stock item.'
        HelpContext = 596
        Caption = 'Al&t Codes'
        TabOrder = 23
        OnClick = Altdb1BtnClick
      end
      object CustdbBtn1: TSBSButton
        Left = 0
        Top = 198
        Width = 80
        Height = 21
        Caption = 'Custom1'
        TabOrder = 25
        OnClick = CustdbBtn1Click
        TextId = 1
      end
      object CustdbBtn2: TSBSButton
        Left = 0
        Top = 221
        Width = 80
        Height = 21
        Caption = 'Custom2'
        TabOrder = 26
        OnClick = CustdbBtn1Click
        TextId = 2
      end
      object Adddb1Btn: TButton
        Left = 0
        Top = -385
        Width = 80
        Height = 21
        Hint = 
          'Add stock record|Choosing this option allows you to add in a new' +
          ' Stock record.'
        HelpContext = 156
        Caption = '&Add'
        TabOrder = 0
        OnClick = Editdb1BtnClick
      end
      object SortViewBtn: TButton
        Left = 0
        Top = -265
        Width = 80
        Height = 21
        Hint = 
          'Sort View options|Apply or change the column sorting for the lis' +
          't.'
        HelpContext = 8028
        Caption = 'Sort &View'
        Enabled = False
        TabOrder = 5
        OnClick = SortViewBtnClick
      end
    end
  end
  object UPBOMP: TSBSPanel
    Left = 501
    Top = 4
    Width = 112
    Height = 18
    BevelInner = bvLowered
    BevelOuter = bvNone
    TabOrder = 2
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
    Purpose = puFrame
  end
  object PopupMenu1: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 53
    Top = 56
    object Add1: TMenuItem
      Caption = '&Add'
      HelpContext = 155
    end
    object Edit1: TMenuItem
      Tag = 1
      Caption = '&Edit'
      Hint = 
        'Choosing this option allows you to edit the currently highlighte' +
        'd record.'
      Visible = False
      OnClick = Editdb1BtnClick
    end
    object Find1: TMenuItem
      Caption = '&Find'
      Hint = 
        'Choosing this option allows you to find a stock record within th' +
        'e list using ObjectFind.'
      OnClick = FindDb1BtnClick
    end
    object Ledger1: TMenuItem
      Caption = '&Ledger'
      Hint = 
        'Choosing this option allows you to view the stock ledger for the' +
        ' currently highlighted record.'
      OnClick = Editdb1BtnClick
    end
    object SortView1: TMenuItem
      Caption = 'Sort &View'
      Hint = 
        'Sort View options|Apply or change the column sorting for the lis' +
        't.'
      object Refreshview1: TMenuItem
        Caption = '&Refresh View'
        OnClick = Refreshview1Click
      end
      object Closeview1: TMenuItem
        Caption = '&Close View'
        OnClick = Closeview1Click
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object SortViewOptions1: TMenuItem
        Caption = 'Sort View &Options'
        OnClick = SortViewOptions1Click
      end
    end
    object History1: TMenuItem
      Caption = '&History'
      Hint = 
        'Choosing this option allows you to view the sales history by per' +
        'iod for the currently highlighted record.'
      OnClick = Editdb1BtnClick
    end
    object Notes1: TMenuItem
      Caption = '&Notes'
      Hint = 
        'Choosing this option allows you view the notepad for currently h' +
        'ighlighted record.'
      OnClick = Editdb1BtnClick
    end
    object Sort1: TMenuItem
      Caption = '&Sort'
      Hint = 
        'Alternates the stock list to displsy in stock code, description,' +
        ' alternative code order.'
      OnClick = Sortdb1BtnClick
    end
    object Build1: TMenuItem
      Caption = '&Build'
    end
    object Prices1: TMenuItem
      Caption = '&Prices'
      Hint = 
        'Choosing this option displays the selling price bands for any hi' +
        'ghlighted record.'
      OnClick = Pricdb1BtnClick
    end
    object Value1: TMenuItem
      Caption = '&Value'
      Hint = 
        'Choosing this option allows you to view the valuation screen for' +
        ' the currently highlighted record.'
      OnClick = Editdb1BtnClick
    end
    object QtyBreaks1: TMenuItem
      Caption = '&Qty-Breaks'
      Hint = 
        'Choosing this option allows you to view the qty break discounts ' +
        'screen for the currently highlighted record.'
      OnClick = Editdb1BtnClick
    end
    object Age1: TMenuItem
      Caption = '&Age'
      Hint = 
        'Choosing this option allows you to view the current supply/deman' +
        'd situation for the currently highlighted record.'
      OnClick = Agedb1BtnClick
    end
    object Delete1: TMenuItem
      Caption = '&Delete'
      Hint = 
        'Choosing this option allows you to delete the currently highligh' +
        'ted record, as long as no transactions exist for it.'
      OnClick = Editdb1BtnClick
    end
    object Loc1: TMenuItem
      Caption = 'L&ocation'
      HelpContext = 499
    end
    object Check1: TMenuItem
      Caption = 'Chec&k'
      Hint = 
        'Choosing this option allows you to recalculate the stock levels ' +
        'for currently highlighted record.'
      OnClick = Chkdb1BtnClick
    end
    object DeList1: TMenuItem
      Tag = 1
      Caption = 'De-L&ist'
      OnClick = DLdb1BtnClick
    end
    object Min1: TMenuItem
      Tag = 2
      Caption = '&Min'
      OnClick = DLdb1BtnClick
    end
    object AutoSet1: TMenuItem
      Caption = '&Auto Set'
      OnClick = ASdb1BtnClick
    end
    object BackOrder1: TMenuItem
      Tag = 3
      Caption = 'Ba&ck Order'
      OnClick = DLdb1BtnClick
    end
    object Freeze1: TMenuItem
      Caption = 'Free&ze'
      OnClick = FRdb1BtnClick
    end
    object Filter1: TMenuItem
      Caption = 'Fil&ter'
      OnClick = FIDb1BtnClick
    end
    object Process1: TMenuItem
      Caption = 'P&rocess'
      OnClick = PRdb1BtnClick
    end
    object AltCodes1: TMenuItem
      Caption = 'Al&t Codes'
      OnClick = Altdb1BtnClick
    end
    object Links1: TMenuItem
      Caption = 'Links'
      Hint = 
        'Displays a list of any additional information attached to this S' +
        'tock Record.'
      OnClick = Lnkdb1BtnClick
    end
    object Custom1: TMenuItem
      Caption = '&Custom Btn 1'
      Visible = False
      OnClick = CustdbBtn1Click
    end
    object Custom2: TMenuItem
      Caption = '&Custom Btn 2'
      Visible = False
      OnClick = CustdbBtn1Click
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
  object PopupMenu2: TPopupMenu
    Left = 53
    Top = 104
    object Build2: TMenuItem
      Tag = 7
      Caption = '&Build'
      HelpContext = 449
      Hint = 
        'Choosing this option allows you to access options for Bill of ma' +
        'terials and their components.'
      OnClick = Editdb1BtnClick
    end
    object UpdateCostings1: TMenuItem
      Caption = '&Update Costings'
      HelpContext = 448
      Hint = 
        'Choosing this option allows you to update all the bill of materi' +
        'al cost prices after changes to the cost of any components.'
      OnClick = UpdateCostings1Click
    end
  end
  object PopupMenu3: TPopupMenu
    Left = 52
    Top = 151
    object FList1: TMenuItem
      Caption = '&Filter List by Location'
      Hint = 
        'Choosing this option filters the current list by location, speci' +
        'fying a blank location gives a consolidated view.'
      OnClick = FList1Click
    end
    object View1: TMenuItem
      Caption = '&View Stock Location Records'
      Hint = 
        'Choosing this option gives access to the Location Stock Records ' +
        'for the currently highlighted stock record.'
      OnClick = View1Click
    end
  end
  object EntCustom4: TCustomisation
    DLLId = SysDll_Ent
    Enabled = True
    ExportPath = 'StkList'
    WindowId = 103000
    Left = 184
    Top = 67
  end
  object PopupMenu4: TPopupMenu
    Left = 52
    Top = 198
    object ASROQty1: TMenuItem
      Caption = '&Auto Set Re-Order Quantity'
      Hint = 
        'Set Re-order qty as suggested|Automatically sets the Order qty a' +
        's per the Need column.'
      OnClick = ASROQty1Click
    end
    object ARROQty1: TMenuItem
      Tag = 1
      Caption = '&Reset Re-Order Quantity to zero'
      Hint = 
        'Set Re-order qty to zero|Automatically sets the Order qty to zer' +
        'o.'
      OnClick = ASROQty1Click
    end
  end
  object SortViewPopupMenu: TPopupMenu
    Left = 51
    Top = 247
    object RefreshView2: TMenuItem
      Caption = '&Refresh View'
      OnClick = Refreshview1Click
    end
    object CloseView2: TMenuItem
      Caption = '&Close View'
      OnClick = Closeview1Click
    end
    object MenuItem3: TMenuItem
      Caption = '-'
    end
    object SortViewOptions2: TMenuItem
      Caption = 'Sort View &Options'
      OnClick = SortViewOptions1Click
    end
  end
  object ProcessButtonPopupMenu: TPopupMenu
    Left = 96
    Top = 248
    object CreatePurchaseOrdersOnly: TMenuItem
      Caption = 'Create PORs Only'
      OnClick = CreatePurchaseOrdersOnlyClick
    end
    object PrintPurchaseOrders: TMenuItem
      Caption = 'Create PORs and Print to Printer'
      OnClick = PrintPurchaseOrdersClick
    end
    object UseSupplierDefaults: TMenuItem
      Caption = 'Create PORs and Output Using Supplier Defaults'
      OnClick = UseSupplierDefaultsClick
    end
    object N5: TMenuItem
      Caption = '-'
    end
    object Cancel: TMenuItem
      Caption = 'Cancel'
    end
  end
  object WindowExport: TWindowExport
    OnEnableExport = WindowExportEnableExport
    OnExecuteCommand = WindowExportExecuteCommand
    OnGetExportDescription = WindowExportGetExportDescription
    Left = 184
    Top = 112
  end
end
