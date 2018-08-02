object Daybk1: TDaybk1
  Left = 602
  Top = 243
  Width = 542
  Height = 379
  HelpContext = 1
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
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
  object DPageCtrl1: TPageControl
    Left = 2
    Top = 2
    Width = 527
    Height = 337
    HelpContext = 1
    ActivePage = MainPage
    Images = ImageRepos.MulCtrlImages
    TabIndex = 0
    TabOrder = 0
    OnChange = DPageCtrl1Change
    OnChanging = DPageCtrl1Changing
    object MainPage: TTabSheet
      Caption = 'Main'
      ImageIndex = -1
      object db1SBox: TScrollBox
        Left = 1
        Top = 2
        Width = 1
        Height = 1
        HorzScrollBar.Position = 7
        VertScrollBar.Visible = False
        TabOrder = 0
        object db1DatePanel: TSBSPanel
          Left = 70
          Top = 24
          Width = 65
          Height = 264
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
          OnMouseUp = db1OrefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object db1OrefPanel: TSBSPanel
          Left = -3
          Top = 23
          Width = 71
          Height = 264
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
          OnMouseUp = db1OrefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object db1PrPanel: TSBSPanel
          Left = 137
          Top = 24
          Width = 51
          Height = 264
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
          OnMouseUp = db1OrefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object db1AccPanel: TSBSPanel
          Left = 190
          Top = 24
          Width = 65
          Height = 264
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
          OnMouseUp = db1OrefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object db1AmtPanel: TSBSPanel
          Left = 382
          Top = 24
          Width = 106
          Height = 264
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
          OnMouseUp = db1OrefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object db1StatPanel: TSBSPanel
          Left = 490
          Top = 24
          Width = 95
          Height = 264
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
          OnMouseUp = db1OrefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object db1HedPanel: TSBSPanel
          Left = -3
          Top = 3
          Width = 768
          Height = 17
          BevelInner = bvLowered
          BevelOuter = bvNone
          Color = clWhite
          TabOrder = 6
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumnHeader
          object db1ORefLab: TSBSPanel
            Left = 5
            Top = 2
            Width = 67
            Height = 13
            Alignment = taLeftJustify
            BevelOuter = bvNone
            Caption = 'Our Ref'
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
            OnMouseDown = db1ORefLabMouseDown
            OnMouseMove = db1ORefLabMouseMove
            OnMouseUp = db1OrefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object db1DateLab: TSBSPanel
            Left = 72
            Top = 2
            Width = 65
            Height = 13
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
            OnMouseDown = db1ORefLabMouseDown
            OnMouseMove = db1ORefLabMouseMove
            OnMouseUp = db1OrefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object db1AccLab: TSBSPanel
            Left = 197
            Top = 2
            Width = 64
            Height = 13
            Alignment = taLeftJustify
            BevelOuter = bvNone
            Caption = 'A/C'
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
            OnMouseDown = db1ORefLabMouseDown
            OnMouseMove = db1ORefLabMouseMove
            OnMouseUp = db1OrefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object db1AMtLab: TSBSPanel
            Left = 382
            Top = 2
            Width = 110
            Height = 13
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = 'Amount   '
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
            OnMouseDown = db1ORefLabMouseDown
            OnMouseMove = db1ORefLabMouseMove
            OnMouseUp = db1OrefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object db1StatLab: TSBSPanel
            Left = 493
            Top = 2
            Width = 95
            Height = 13
            Alignment = taLeftJustify
            BevelOuter = bvNone
            Caption = '   Status'
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
            OnMouseDown = db1ORefLabMouseDown
            OnMouseMove = db1ORefLabMouseMove
            OnMouseUp = db1OrefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object db1PrLab: TSBSPanel
            Left = 140
            Top = 2
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
            TabOrder = 5
            OnMouseDown = db1ORefLabMouseDown
            OnMouseMove = db1ORefLabMouseMove
            OnMouseUp = db1OrefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object db1DescLab: TSBSPanel
            Left = 261
            Top = 2
            Width = 123
            Height = 13
            Alignment = taLeftJustify
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
            TabOrder = 6
            OnMouseDown = db1ORefLabMouseDown
            OnMouseMove = db1ORefLabMouseMove
            OnMouseUp = db1OrefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object db1YRefLab: TSBSPanel
            Left = 589
            Top = 2
            Width = 75
            Height = 13
            BevelOuter = bvNone
            Caption = 'Your Ref'
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
            OnMouseDown = db1ORefLabMouseDown
            OnMouseMove = db1ORefLabMouseMove
            OnMouseUp = db1OrefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object db1OwnerLab: TSBSPanel
            Left = 677
            Top = 2
            Width = 75
            Height = 13
            BevelOuter = bvNone
            Caption = 'User Name'
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
            OnMouseDown = db1ORefLabMouseDown
            OnMouseMove = db1ORefLabMouseMove
            OnMouseUp = db1OrefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
        end
        object db1DescPanel: TSBSPanel
          Left = 257
          Top = 24
          Width = 123
          Height = 264
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
          OnMouseUp = db1OrefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object db1YRefPanel: TSBSPanel
          Left = 587
          Top = 24
          Width = 71
          Height = 264
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
          OnMouseUp = db1OrefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object db1OwnerPanel: TSBSPanel
          Left = 660
          Top = 24
          Width = 106
          Height = 264
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
          OnMouseUp = db1OrefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
      end
      object db1ListBtnPanel: TSBSPanel
        Left = 382
        Top = 28
        Width = 18
        Height = 263
        BevelOuter = bvLowered
        PopupMenu = PopupMenu1
        TabOrder = 1
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
      end
      object pnlGridBackground: TPanel
        Left = 1
        Top = 2
        Width = 380
        Height = 308
        Color = clSkyBlue
        TabOrder = 2
        inline frDaybkGrid: TfrDataGrid
          Left = 1
          Top = 1
          Width = 378
          Height = 306
          Align = alClient
          TabOrder = 0
          inherited pnlMain: TPanel
            Width = 378
            Height = 306
            inherited grdMain: TcxGrid
              Width = 376
              Height = 304
            end
          end
        end
      end
    end
    object QuotesPage: TTabSheet
      HelpContext = 5
      Caption = 'Quotes'
      ImageIndex = -1
      object db2SBox: TScrollBox
        Left = 1
        Top = 2
        Width = 380
        Height = 308
        VertScrollBar.Visible = False
        TabOrder = 0
        object db2DatePanel: TSBSPanel
          Left = 71
          Top = 24
          Width = 65
          Height = 264
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
          OnMouseUp = db1OrefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object db2ORefPanel: TSBSPanel
          Left = 4
          Top = 24
          Width = 65
          Height = 264
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
          OnMouseUp = db1OrefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object db2PrPanel: TSBSPanel
          Left = 138
          Top = 24
          Width = 51
          Height = 264
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
          OnMouseUp = db1OrefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object db2AccPanel: TSBSPanel
          Left = 191
          Top = 24
          Width = 65
          Height = 264
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
          OnMouseUp = db1OrefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object db2AmtPanel: TSBSPanel
          Left = 383
          Top = 24
          Width = 106
          Height = 264
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
          OnMouseUp = db1OrefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object db2StatPanel: TSBSPanel
          Left = 491
          Top = 24
          Width = 95
          Height = 264
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
          OnMouseUp = db1OrefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object db2HedPanel: TSBSPanel
          Left = 4
          Top = 3
          Width = 757
          Height = 17
          BevelInner = bvLowered
          BevelOuter = bvNone
          Color = clWhite
          TabOrder = 6
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumnHeader
          object db2OrefLab: TSBSPanel
            Left = 4
            Top = 2
            Width = 61
            Height = 13
            Alignment = taLeftJustify
            BevelOuter = bvNone
            Caption = 'Our Ref'
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
            OnMouseDown = db1ORefLabMouseDown
            OnMouseMove = db1ORefLabMouseMove
            OnMouseUp = db1OrefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object db2DateLab: TSBSPanel
            Left = 67
            Top = 2
            Width = 65
            Height = 13
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
            OnMouseDown = db1ORefLabMouseDown
            OnMouseMove = db1ORefLabMouseMove
            OnMouseUp = db1OrefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object db2AccLab: TSBSPanel
            Left = 188
            Top = 2
            Width = 64
            Height = 13
            Alignment = taLeftJustify
            BevelOuter = bvNone
            Caption = 'A/C'
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
            OnMouseDown = db1ORefLabMouseDown
            OnMouseMove = db1ORefLabMouseMove
            OnMouseUp = db1OrefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object db2AmtLab: TSBSPanel
            Left = 376
            Top = 2
            Width = 110
            Height = 13
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = 'Amount   '
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
            OnMouseDown = db1ORefLabMouseDown
            OnMouseMove = db1ORefLabMouseMove
            OnMouseUp = db1OrefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object db2StatLab: TSBSPanel
            Left = 487
            Top = 2
            Width = 95
            Height = 13
            Alignment = taLeftJustify
            BevelOuter = bvNone
            Caption = '   Status'
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
            OnMouseDown = db1ORefLabMouseDown
            OnMouseMove = db1ORefLabMouseMove
            OnMouseUp = db1OrefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object db2PrLab: TSBSPanel
            Left = 134
            Top = 2
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
            TabOrder = 5
            OnMouseDown = db1ORefLabMouseDown
            OnMouseMove = db1ORefLabMouseMove
            OnMouseUp = db1OrefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object db2DescLab: TSBSPanel
            Left = 254
            Top = 2
            Width = 123
            Height = 13
            Alignment = taLeftJustify
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
            TabOrder = 6
            OnMouseDown = db1ORefLabMouseDown
            OnMouseMove = db1ORefLabMouseMove
            OnMouseUp = db1OrefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object db2YRefLab: TSBSPanel
            Left = 583
            Top = 2
            Width = 65
            Height = 13
            BevelOuter = bvNone
            Caption = 'Your Ref'
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
            OnMouseDown = db1ORefLabMouseDown
            OnMouseMove = db1ORefLabMouseMove
            OnMouseUp = db1OrefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object db2OwnerLab: TSBSPanel
            Left = 649
            Top = 2
            Width = 104
            Height = 13
            BevelOuter = bvNone
            Caption = 'User Name'
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
            OnMouseDown = db1ORefLabMouseDown
            OnMouseMove = db1ORefLabMouseMove
            OnMouseUp = db1OrefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
        end
        object db2DescPanel: TSBSPanel
          Left = 258
          Top = 24
          Width = 123
          Height = 264
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
          OnMouseUp = db1OrefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object db2YRefPanel: TSBSPanel
          Left = 588
          Top = 24
          Width = 65
          Height = 264
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
          OnMouseUp = db1OrefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object db2OwnerPanel: TSBSPanel
          Left = 655
          Top = 24
          Width = 106
          Height = 264
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
          OnMouseUp = db1OrefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
      end
      object db2ListBtnPanel: TSBSPanel
        Left = 382
        Top = 28
        Width = 18
        Height = 263
        BevelOuter = bvLowered
        TabOrder = 1
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
      end
    end
    object AutoPage: TTabSheet
      HelpContext = 51
      Caption = 'Auto'
      ImageIndex = -1
      object db3SBox: TScrollBox
        Left = 1
        Top = 2
        Width = 380
        Height = 308
        VertScrollBar.Visible = False
        TabOrder = 0
        object db3DatePanel: TSBSPanel
          Left = 71
          Top = 24
          Width = 65
          Height = 264
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
          OnMouseUp = db1OrefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object db3ORefPanel: TSBSPanel
          Left = 4
          Top = 24
          Width = 65
          Height = 264
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
          OnMouseUp = db1OrefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object db3PrPanel: TSBSPanel
          Left = 138
          Top = 24
          Width = 51
          Height = 264
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
          OnMouseUp = db1OrefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object db3AccPanel: TSBSPanel
          Left = 191
          Top = 24
          Width = 65
          Height = 264
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
          OnMouseUp = db1OrefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object db3AmtPanel: TSBSPanel
          Left = 383
          Top = 24
          Width = 106
          Height = 264
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
          OnMouseUp = db1OrefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object db3StatPanel: TSBSPanel
          Left = 491
          Top = 24
          Width = 95
          Height = 264
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
          OnMouseUp = db1OrefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object db3HedPanel: TSBSPanel
          Left = 4
          Top = 3
          Width = 758
          Height = 17
          BevelInner = bvLowered
          BevelOuter = bvNone
          Color = clWhite
          TabOrder = 6
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumnHeader
          object db3ORefLab: TSBSPanel
            Left = 4
            Top = 2
            Width = 61
            Height = 13
            Alignment = taLeftJustify
            BevelOuter = bvNone
            Caption = 'Our Ref'
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
            OnMouseDown = db1ORefLabMouseDown
            OnMouseMove = db1ORefLabMouseMove
            OnMouseUp = db1OrefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object db3DateLab: TSBSPanel
            Left = 67
            Top = 2
            Width = 65
            Height = 13
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
            OnMouseDown = db1ORefLabMouseDown
            OnMouseMove = db1ORefLabMouseMove
            OnMouseUp = db1OrefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object db3AccLab: TSBSPanel
            Left = 188
            Top = 2
            Width = 64
            Height = 13
            Alignment = taLeftJustify
            BevelOuter = bvNone
            Caption = 'A/C'
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
            OnMouseDown = db1ORefLabMouseDown
            OnMouseMove = db1ORefLabMouseMove
            OnMouseUp = db1OrefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object db3AmtLab: TSBSPanel
            Left = 377
            Top = 2
            Width = 110
            Height = 13
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = 'Amount    '
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
            OnMouseDown = db1ORefLabMouseDown
            OnMouseMove = db1ORefLabMouseMove
            OnMouseUp = db1OrefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object db3StatLab: TSBSPanel
            Left = 487
            Top = 2
            Width = 93
            Height = 13
            Alignment = taLeftJustify
            BevelOuter = bvNone
            Caption = '   Status'
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
            OnMouseDown = db1ORefLabMouseDown
            OnMouseMove = db1ORefLabMouseMove
            OnMouseUp = db1OrefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object db3PrLab: TSBSPanel
            Left = 134
            Top = 2
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
            TabOrder = 5
            OnMouseDown = db1ORefLabMouseDown
            OnMouseMove = db1ORefLabMouseMove
            OnMouseUp = db1OrefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object db3DescLab: TSBSPanel
            Left = 253
            Top = 2
            Width = 124
            Height = 13
            Alignment = taLeftJustify
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
            TabOrder = 6
            OnMouseDown = db1ORefLabMouseDown
            OnMouseMove = db1ORefLabMouseMove
            OnMouseUp = db1OrefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object db3YRefLab: TSBSPanel
            Left = 584
            Top = 2
            Width = 64
            Height = 13
            BevelOuter = bvNone
            Caption = 'Your Ref'
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
            OnMouseDown = db1ORefLabMouseDown
            OnMouseMove = db1ORefLabMouseMove
            OnMouseUp = db1OrefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object db3OwnerLab: TSBSPanel
            Left = 648
            Top = 2
            Width = 113
            Height = 13
            BevelOuter = bvNone
            Caption = 'User Name'
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
            OnMouseDown = db1ORefLabMouseDown
            OnMouseMove = db1ORefLabMouseMove
            OnMouseUp = db1OrefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
        end
        object db3DescPanel: TSBSPanel
          Left = 258
          Top = 24
          Width = 123
          Height = 264
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
          OnMouseUp = db1OrefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object db3YRefPanel: TSBSPanel
          Left = 588
          Top = 24
          Width = 65
          Height = 264
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
          OnMouseUp = db1OrefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object db3OwnerPanel: TSBSPanel
          Left = 655
          Top = 24
          Width = 106
          Height = 264
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
          OnMouseUp = db1OrefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
      end
      object db3ListBtnPanel: TSBSPanel
        Left = 382
        Top = 28
        Width = 18
        Height = 263
        BevelOuter = bvLowered
        TabOrder = 1
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
      end
    end
    object HistoryPage: TTabSheet
      HelpContext = 64
      Caption = 'History'
      ImageIndex = -1
      object db4SBox: TScrollBox
        Left = 1
        Top = 2
        Width = 380
        Height = 308
        VertScrollBar.Visible = False
        TabOrder = 0
        object db5DatePanel: TSBSPanel
          Left = 77
          Top = 24
          Width = 65
          Height = 264
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
          OnMouseUp = db1OrefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object db5ORefPanel: TSBSPanel
          Left = 4
          Top = 24
          Width = 71
          Height = 264
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
          OnMouseUp = db1OrefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object db5PrPanel: TSBSPanel
          Left = 144
          Top = 24
          Width = 51
          Height = 264
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
          OnMouseUp = db1OrefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object db5AccPanel: TSBSPanel
          Left = 197
          Top = 24
          Width = 65
          Height = 264
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
          OnMouseUp = db1OrefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object db5AmtPanel: TSBSPanel
          Left = 389
          Top = 24
          Width = 106
          Height = 264
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
          OnMouseUp = db1OrefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object db5StatPanel: TSBSPanel
          Left = 497
          Top = 24
          Width = 95
          Height = 264
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
          OnMouseUp = db1OrefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object db5HedPanel: TSBSPanel
          Left = 5
          Top = 3
          Width = 771
          Height = 17
          BevelInner = bvLowered
          BevelOuter = bvNone
          Color = clWhite
          TabOrder = 6
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumnHeader
          object db5ORefLab: TSBSPanel
            Left = 4
            Top = 2
            Width = 67
            Height = 13
            Alignment = taLeftJustify
            BevelOuter = bvNone
            Caption = 'Our Ref'
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
            OnMouseDown = db1ORefLabMouseDown
            OnMouseMove = db1ORefLabMouseMove
            OnMouseUp = db1OrefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object db5DateLab: TSBSPanel
            Left = 72
            Top = 2
            Width = 65
            Height = 13
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
            OnMouseDown = db1ORefLabMouseDown
            OnMouseMove = db1ORefLabMouseMove
            OnMouseUp = db1OrefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object db5AccLab: TSBSPanel
            Left = 197
            Top = 2
            Width = 64
            Height = 13
            Alignment = taLeftJustify
            BevelOuter = bvNone
            Caption = 'A/C'
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
            OnMouseDown = db1ORefLabMouseDown
            OnMouseMove = db1ORefLabMouseMove
            OnMouseUp = db1OrefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object db5AmtLab: TSBSPanel
            Left = 381
            Top = 2
            Width = 110
            Height = 13
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = 'Amount    '
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
            OnMouseDown = db1ORefLabMouseDown
            OnMouseMove = db1ORefLabMouseMove
            OnMouseUp = db1OrefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object db5StatLab: TSBSPanel
            Left = 492
            Top = 2
            Width = 94
            Height = 13
            Alignment = taLeftJustify
            BevelOuter = bvNone
            Caption = '   Status'
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
            OnMouseDown = db1ORefLabMouseDown
            OnMouseMove = db1ORefLabMouseMove
            OnMouseUp = db1OrefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object db5PrLab: TSBSPanel
            Left = 138
            Top = 2
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
            TabOrder = 5
            OnMouseDown = db1ORefLabMouseDown
            OnMouseMove = db1ORefLabMouseMove
            OnMouseUp = db1OrefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object db5DescLab: TSBSPanel
            Left = 260
            Top = 2
            Width = 123
            Height = 13
            Alignment = taLeftJustify
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
            TabOrder = 6
            OnMouseDown = db1ORefLabMouseDown
            OnMouseMove = db1ORefLabMouseMove
            OnMouseUp = db1OrefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object db5YRefLab: TSBSPanel
            Left = 589
            Top = 2
            Width = 69
            Height = 13
            BevelOuter = bvNone
            Caption = 'Your Ref'
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
            OnMouseDown = db1ORefLabMouseDown
            OnMouseMove = db1ORefLabMouseMove
            OnMouseUp = db1OrefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object db5OwnerLab: TSBSPanel
            Left = 661
            Top = 2
            Width = 108
            Height = 13
            BevelOuter = bvNone
            Caption = 'User Name'
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
            OnMouseDown = db1ORefLabMouseDown
            OnMouseMove = db1ORefLabMouseMove
            OnMouseUp = db1OrefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
        end
        object db5DescPanel: TSBSPanel
          Left = 264
          Top = 24
          Width = 123
          Height = 264
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
          OnMouseUp = db1OrefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object db5YRefPanel: TSBSPanel
          Left = 594
          Top = 24
          Width = 71
          Height = 264
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
          OnMouseUp = db1OrefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object db5OwnerPanel: TSBSPanel
          Left = 667
          Top = 24
          Width = 106
          Height = 264
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
          OnMouseUp = db1OrefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
      end
      object db5ListBtnPanel: TSBSPanel
        Left = 382
        Top = 28
        Width = 18
        Height = 263
        BevelOuter = bvLowered
        TabOrder = 1
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
      end
    end
    object OrdersPage: TTabSheet
      HelpContext = 13
      Caption = 'Orders'
      ImageIndex = -1
      object db5SBox: TScrollBox
        Left = 1
        Top = 2
        Width = 380
        Height = 308
        VertScrollBar.Visible = False
        TabOrder = 0
        object db4DatePanel: TSBSPanel
          Left = 71
          Top = 24
          Width = 65
          Height = 264
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
          OnMouseUp = db1OrefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object db4ORefPanel: TSBSPanel
          Left = 4
          Top = 24
          Width = 65
          Height = 264
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
          OnMouseUp = db1OrefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object db4PrPanel: TSBSPanel
          Left = 138
          Top = 24
          Width = 51
          Height = 264
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
          OnMouseUp = db1OrefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object db4AccPanel: TSBSPanel
          Left = 191
          Top = 24
          Width = 65
          Height = 264
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
          OnMouseUp = db1OrefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object db4AmtPanel: TSBSPanel
          Left = 383
          Top = 24
          Width = 106
          Height = 264
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
          OnMouseUp = db1OrefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object db4StatPanel: TSBSPanel
          Left = 524
          Top = 24
          Width = 95
          Height = 264
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
          OnMouseUp = db1OrefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object db4HedPanel: TSBSPanel
          Left = 3
          Top = 3
          Width = 785
          Height = 17
          BevelInner = bvLowered
          BevelOuter = bvNone
          Color = clWhite
          TabOrder = 6
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumnHeader
          object db4ORefLab: TSBSPanel
            Left = 4
            Top = 2
            Width = 61
            Height = 13
            Alignment = taLeftJustify
            BevelOuter = bvNone
            Caption = 'Our Ref'
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
            OnMouseDown = db1ORefLabMouseDown
            OnMouseMove = db1ORefLabMouseMove
            OnMouseUp = db1OrefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object db4DateLab: TSBSPanel
            Left = 67
            Top = 2
            Width = 65
            Height = 13
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
            OnMouseDown = db1ORefLabMouseDown
            OnMouseMove = db1ORefLabMouseMove
            OnMouseUp = db1OrefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object db4AccLab: TSBSPanel
            Left = 191
            Top = 2
            Width = 64
            Height = 13
            Alignment = taLeftJustify
            BevelOuter = bvNone
            Caption = 'A/C'
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
            OnMouseDown = db1ORefLabMouseDown
            OnMouseMove = db1ORefLabMouseMove
            OnMouseUp = db1OrefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object db4AmtLab: TSBSPanel
            Left = 377
            Top = 2
            Width = 110
            Height = 13
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = 'Amount    '
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
            OnMouseDown = db1ORefLabMouseDown
            OnMouseMove = db1ORefLabMouseMove
            OnMouseUp = db1OrefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object db4StatLab: TSBSPanel
            Left = 522
            Top = 2
            Width = 90
            Height = 13
            Alignment = taLeftJustify
            BevelOuter = bvNone
            Caption = '    Status'
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
            OnMouseDown = db1ORefLabMouseDown
            OnMouseMove = db1ORefLabMouseMove
            OnMouseUp = db1OrefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object db4PrLab: TSBSPanel
            Left = 134
            Top = 2
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
            TabOrder = 5
            OnMouseDown = db1ORefLabMouseDown
            OnMouseMove = db1ORefLabMouseMove
            OnMouseUp = db1OrefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object db4DescLab: TSBSPanel
            Left = 253
            Top = 2
            Width = 124
            Height = 13
            Alignment = taLeftJustify
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
            TabOrder = 6
            OnMouseDown = db1ORefLabMouseDown
            OnMouseMove = db1ORefLabMouseMove
            OnMouseUp = db1OrefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object db4YRefLab: TSBSPanel
            Left = 620
            Top = 2
            Width = 62
            Height = 13
            BevelOuter = bvNone
            Caption = 'Your Ref'
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
            OnMouseDown = db1ORefLabMouseDown
            OnMouseMove = db1ORefLabMouseMove
            OnMouseUp = db1OrefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object db4OrdPayLab: TSBSPanel
            Left = 491
            Top = 2
            Width = 24
            Height = 13
            Alignment = taLeftJustify
            BevelOuter = bvNone
            Caption = 'OP'
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
            OnMouseDown = db1ORefLabMouseDown
            OnMouseMove = db1ORefLabMouseMove
            OnMouseUp = db1OrefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object db4OwnerLab: TSBSPanel
            Left = 688
            Top = 2
            Width = 89
            Height = 13
            BevelOuter = bvNone
            Caption = 'User Name'
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
            OnMouseDown = db1ORefLabMouseDown
            OnMouseMove = db1ORefLabMouseMove
            OnMouseUp = db1OrefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
        end
        object db4DescPanel: TSBSPanel
          Left = 258
          Top = 24
          Width = 123
          Height = 264
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
          OnMouseUp = db1OrefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object db4YRefPanel: TSBSPanel
          Left = 621
          Top = 24
          Width = 66
          Height = 264
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
          OnMouseUp = db1OrefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object db4OrdPayPanel: TSBSPanel
          Left = 491
          Top = 24
          Width = 31
          Height = 264
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
          OnMouseUp = db1OrefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object db4OwnerPanel: TSBSPanel
          Left = 689
          Top = 24
          Width = 106
          Height = 264
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
          OnMouseUp = db1OrefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
      end
      object db4ListBtnPanel: TSBSPanel
        Left = 382
        Top = 28
        Width = 18
        Height = 263
        BevelOuter = bvLowered
        TabOrder = 1
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
      end
    end
    object OrdHistoryPage: TTabSheet
      HelpContext = 14
      Caption = 'Order History'
      ImageIndex = -1
      object db6SBox: TScrollBox
        Left = 1
        Top = 2
        Width = 380
        Height = 308
        VertScrollBar.Visible = False
        TabOrder = 0
        object db6DatePanel: TSBSPanel
          Left = 71
          Top = 24
          Width = 65
          Height = 264
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
          OnMouseUp = db1OrefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object db6ORefPanel: TSBSPanel
          Left = 4
          Top = 24
          Width = 65
          Height = 264
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
          OnMouseUp = db1OrefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object db6PrPanel: TSBSPanel
          Left = 138
          Top = 24
          Width = 51
          Height = 264
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
          OnMouseUp = db1OrefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object db6AccPanel: TSBSPanel
          Left = 191
          Top = 24
          Width = 64
          Height = 264
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
          OnMouseUp = db1OrefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object db6AmtPanel: TSBSPanel
          Left = 383
          Top = 24
          Width = 106
          Height = 264
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
          OnMouseUp = db1OrefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object db6StatPanel: TSBSPanel
          Left = 491
          Top = 24
          Width = 95
          Height = 264
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
          OnMouseUp = db1OrefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object db6HedPanel: TSBSPanel
          Left = 4
          Top = 3
          Width = 760
          Height = 17
          BevelInner = bvLowered
          BevelOuter = bvNone
          Color = clWhite
          TabOrder = 6
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumnHeader
          object db6ORefLab: TSBSPanel
            Left = 4
            Top = 2
            Width = 61
            Height = 13
            Alignment = taLeftJustify
            BevelOuter = bvNone
            Caption = 'Our Ref'
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
            OnMouseDown = db1ORefLabMouseDown
            OnMouseMove = db1ORefLabMouseMove
            OnMouseUp = db1OrefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object db6DateLab: TSBSPanel
            Left = 67
            Top = 2
            Width = 65
            Height = 13
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
            OnMouseDown = db1ORefLabMouseDown
            OnMouseMove = db1ORefLabMouseMove
            OnMouseUp = db1OrefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object db6AccLab: TSBSPanel
            Left = 188
            Top = 2
            Width = 64
            Height = 13
            Alignment = taLeftJustify
            BevelOuter = bvNone
            Caption = 'A/C'
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
            OnMouseDown = db1ORefLabMouseDown
            OnMouseMove = db1ORefLabMouseMove
            OnMouseUp = db1OrefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object db6AmtLab: TSBSPanel
            Left = 377
            Top = 2
            Width = 109
            Height = 13
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = 'Amount    '
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
            OnMouseDown = db1ORefLabMouseDown
            OnMouseMove = db1ORefLabMouseMove
            OnMouseUp = db1OrefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object db6StatLab: TSBSPanel
            Left = 487
            Top = 2
            Width = 96
            Height = 13
            Alignment = taLeftJustify
            BevelOuter = bvNone
            Caption = '    Status'
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
            OnMouseDown = db1ORefLabMouseDown
            OnMouseMove = db1ORefLabMouseMove
            OnMouseUp = db1OrefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object db6PrLab: TSBSPanel
            Left = 134
            Top = 2
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
            TabOrder = 5
            OnMouseDown = db1ORefLabMouseDown
            OnMouseMove = db1ORefLabMouseMove
            OnMouseUp = db1OrefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object db6DescLab: TSBSPanel
            Left = 253
            Top = 2
            Width = 126
            Height = 13
            Alignment = taLeftJustify
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
            TabOrder = 6
            OnMouseDown = db1ORefLabMouseDown
            OnMouseMove = db1ORefLabMouseMove
            OnMouseUp = db1OrefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object db6YRefLab: TSBSPanel
            Left = 585
            Top = 2
            Width = 62
            Height = 13
            BevelOuter = bvNone
            Caption = 'Your Ref'
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
            OnMouseDown = db1ORefLabMouseDown
            OnMouseMove = db1ORefLabMouseMove
            OnMouseUp = db1OrefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object db6OwnerLab: TSBSPanel
            Left = 649
            Top = 2
            Width = 112
            Height = 13
            BevelOuter = bvNone
            Caption = 'User Name'
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
            OnMouseDown = db1ORefLabMouseDown
            OnMouseMove = db1ORefLabMouseMove
            OnMouseUp = db1OrefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
        end
        object db6DescPanel: TSBSPanel
          Left = 257
          Top = 24
          Width = 123
          Height = 264
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
          OnMouseUp = db1OrefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object db6YRefPanel: TSBSPanel
          Left = 588
          Top = 24
          Width = 65
          Height = 264
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
          OnMouseUp = db1OrefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object db6OwnerPanel: TSBSPanel
          Left = 655
          Top = 24
          Width = 106
          Height = 264
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
          OnMouseUp = db1OrefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
      end
      object db6ListBtnPanel: TSBSPanel
        Left = 382
        Top = 28
        Width = 18
        Height = 263
        BevelOuter = bvLowered
        TabOrder = 1
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
      end
    end
  end
  object db1BtnPanel: TSBSPanel
    Left = 413
    Top = 26
    Width = 102
    Height = 308
    BevelOuter = bvNone
    PopupMenu = PopupMenu1
    TabOrder = 1
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
    object db1BSBox: TScrollBox
      Left = 0
      Top = 86
      Width = 105
      Height = 219
      HorzScrollBar.Visible = False
      BorderStyle = bsNone
      Color = clBtnFace
      ParentColor = False
      TabOrder = 0
      object Adddb1Btn: TButton
        Left = 2
        Top = 1
        Width = 80
        Height = 21
        Hint = 
          'Add a new transaction|Choosing this option adds a new transactio' +
          'n to the current daybook. You will be prompted for which transac' +
          'tion type.'
        HelpContext = 25
        Caption = '&Add'
        TabOrder = 0
        OnClick = Adddb1BtnClick
      end
      object Editdb1Btn: TButton
        Left = 2
        Top = 25
        Width = 80
        Height = 21
        Hint = 
          'Edit an existing transaction|Choosing this option allows the edi' +
          'ting of the currently highlighted transaction.'
        HelpContext = 26
        Caption = '&Edit'
        TabOrder = 1
        OnClick = Adddb1BtnClick
      end
      object Finddb1Btn: TButton
        Left = 2
        Top = 49
        Width = 80
        Height = 21
        Hint = 
          'Find a transaction on the daybook|Find a transaction within the ' +
          'daybook using the ObjectFind window.'
        HelpContext = 27
        Caption = '&Find'
        Enabled = False
        TabOrder = 2
        OnClick = Finddb1BtnClick
      end
      object Printdb1Btn: TButton
        Left = 2
        Top = 193
        Width = 80
        Height = 21
        Hint = 
          'Print this transaction|Prints the currently highlighted transact' +
          'ion.'
        HelpContext = 31
        Caption = '&Print'
        Enabled = False
        TabOrder = 8
        OnClick = Printdb1BtnClick
      end
      object Holddb1Btn: TButton
        Left = 2
        Top = 73
        Width = 80
        Height = 21
        Hint = 'Hold a transaction|Holds the currently highlighted transaction.'
        HelpContext = 21
        Caption = '&Hold'
        TabOrder = 3
        OnClick = Holddb1BtnClick
      end
      object Convdb1Btn: TButton
        Left = 2
        Top = 121
        Width = 80
        Height = 21
        Hint = 
          'Convert Quotation|Converts the currently highlighted quotation i' +
          'nto either an invoice, or an order (SPOP version only).'
        HelpContext = 52
        Caption = 'Con&vert'
        Enabled = False
        TabOrder = 5
        OnClick = Convdb1BtnClick
      end
      object CopyDb1Btn: TButton
        Left = 2
        Top = 97
        Width = 80
        Height = 21
        Hint = 
          'Copy/Reverse current transaction|Generate an exact copy, or reve' +
          'rse of the currently highlighted transaction.'
        HelpContext = 28
        Caption = 'Cop&y'
        TabOrder = 4
        OnClick = CopyDb1BtnClick
      end
      object Notedb1Btn: TButton
        Left = 2
        Top = 169
        Width = 80
        Height = 21
        Hint = 
          'Show Notepad|Shows the notepad for the currently highlighted tra' +
          'nsaction.'
        HelpContext = 30
        Caption = '&Notes'
        TabOrder = 7
        OnClick = Pickdb1BtnClick
      end
      object Postdb1Btn: TButton
        Left = 2
        Top = 145
        Width = 80
        Height = 21
        Hint = 
          'Post the daybook|Allows the posting of the current daybook, or t' +
          'he printing of various posting related reports.'
        HelpContext = 29
        Caption = '&Daybook Post'
        Enabled = False
        TabOrder = 6
        OnClick = Postdb1BtnClick
      end
      object Pickdb1Btn: TButton
        Left = 2
        Top = 216
        Width = 80
        Height = 21
        Hint = 
          'Pick Sales Order|Displays the currently highlighted Sales Order ' +
          'in a picking mode, allowing the order picking status to be alter' +
          'ed, or viewed.'
        HelpContext = 458
        Caption = 'Pic&k'
        TabOrder = 9
        OnClick = Pickdb1BtnClick
      end
      object Recdb1Btn: TButton
        Left = 2
        Top = 239
        Width = 80
        Height = 21
        Hint = 
          'Receive Purchase Order|Displays the currently highlighted Purcha' +
          'se Order in a receipt mode, allowing the order receipt status to' +
          ' be altered, or viewed.'
        HelpContext = 458
        Caption = '&Receive'
        TabOrder = 10
        OnClick = Pickdb1BtnClick
      end
      object Matdb1Btn: TButton
        Left = 2
        Top = 262
        Width = 80
        Height = 21
        Hint = 
          'Match Order Information|Displays any matching information associ' +
          'ated with an order or delivery note.'
        HelpContext = 498
        Caption = '&Match'
        Enabled = False
        TabOrder = 11
        OnClick = Matdb1BtnClick
      end
      object Remdb1Btn: TButton
        Left = 2
        Top = 285
        Width = 80
        Height = 21
        Hint = 
          'Remove (Delete) a Quotation|Deletes the currently highlighted Qu' +
          'otation.'
        HelpContext = 463
        Caption = '&Remove'
        Enabled = False
        TabOrder = 12
        OnClick = Remdb1BtnClick
      end
      object Tagdb1Btn: TButton
        Left = 2
        Top = 308
        Width = 80
        Height = 21
        Hint = 
          'Tag an Order or Delivery Note|Tags the currently highlighted Ord' +
          'er or Delivery Note, for selected processing.'
        HelpContext = 459
        Caption = '&Tag'
        TabOrder = 13
        OnClick = Tagdb1BtnClick
      end
      object Viewdb1Btn: TButton
        Left = 2
        Top = 331
        Width = 80
        Height = 21
        Hint = 
          'View current Transaction|Displays the currently highlighted tran' +
          'saction in a view only mode, ideal for list scanning.'
        HelpContext = 32
        Caption = '&View'
        TabOrder = 14
        OnClick = Adddb1BtnClick
      end
      object CustdbBtn1: TSBSButton
        Tag = 1
        Left = 2
        Top = 400
        Width = 80
        Height = 21
        Caption = 'Custom1'
        TabOrder = 17
        OnClick = CustdbBtn1Click
        TextId = 1
      end
      object CustdbBtn2: TSBSButton
        Tag = 2
        Left = 2
        Top = 423
        Width = 80
        Height = 21
        Caption = 'Custom2'
        TabOrder = 18
        OnClick = CustdbBtn1Click
        TextId = 2
      end
      object Returndb1Btn: TButton
        Left = 2
        Top = 356
        Width = 80
        Height = 21
        Hint = 
          'Generate a Stock Return|Generates a Stock Return Note for the cu' +
          'rrently highlighted Quotation.'
        HelpContext = 1593
        Caption = 'Ret&urn'
        Enabled = False
        TabOrder = 15
        OnClick = Returndb1BtnClick
      end
      object CustdbBtn3: TSBSButton
        Tag = 3
        Left = 2
        Top = 446
        Width = 80
        Height = 21
        Caption = 'Custom3'
        TabOrder = 19
        OnClick = CustdbBtn1Click
        TextId = 0
      end
      object CustdbBtn4: TSBSButton
        Tag = 4
        Left = 2
        Top = 469
        Width = 80
        Height = 21
        Caption = 'Custom4'
        TabOrder = 20
        OnClick = CustdbBtn1Click
        TextId = 0
      end
      object CustdbBtn5: TSBSButton
        Tag = 5
        Left = 2
        Top = 492
        Width = 80
        Height = 21
        Caption = 'Custom5'
        TabOrder = 21
        OnClick = CustdbBtn1Click
        TextId = 0
      end
      object CustdbBtn6: TSBSButton
        Tag = 6
        Left = 2
        Top = 515
        Width = 80
        Height = 21
        Caption = 'Custom6'
        TabOrder = 22
        OnClick = CustdbBtn1Click
        TextId = 0
      end
      object Filterdb1Btn: TButton
        Left = 2
        Top = 377
        Width = 80
        Height = 21
        Hint = 
          'Change the Override Location|Allows the list to be viewed by a d' +
          'ifferent Override Location, or all Override Locations. Also give' +
          's access to Purchase Records.'
        HelpContext = 8096
        Caption = 'F&ilter'
        Enabled = False
        PopupMenu = PopupMenu9
        TabOrder = 16
        OnClick = Filterdb1BtnClick
      end
      object SortViewBtn: TButton
        Left = 2
        Top = 486
        Width = 80
        Height = 21
        Hint = 
          'Sort View options|Apply or change the column sorting for the lis' +
          't.'
        HelpContext = 8030
        Caption = 'S&ort View'
        TabOrder = 23
        OnClick = SortViewBtnClick
      end
    end
    object Clsdb1Btn: TButton
      Left = 2
      Top = 3
      Width = 80
      Height = 21
      HelpContext = 24
      Cancel = True
      Caption = 'C&lose'
      ModalResult = 2
      TabOrder = 1
      OnClick = Clsdb1BtnClick
    end
  end
  object PopupMenu1: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 225
    Top = 74
    object Add1: TMenuItem
      Caption = '&Add'
      Hint = 
        'Choosing this option adds a new transaction to the current daybo' +
        'ok. You will be prompted for which transaction type.'
      OnClick = Adddb1BtnClick
    end
    object Edit1: TMenuItem
      Tag = 1
      Caption = '&Edit'
      Hint = 
        'Choosing this option allows the editing of the currently highlig' +
        'hted transaction.'
      Visible = False
      OnClick = Adddb1BtnClick
    end
    object Find1: TMenuItem
      Caption = '&Find'
      Hint = 
        'Find a transaction within the daybook using the ObjectFind windo' +
        'w.'
      OnClick = Finddb1BtnClick
    end
    object mnuFindOptions: TMenuItem
      Caption = '&Find'
      Hint = 
        'Find a transaction within the daybook using the ObjectFind windo' +
        'w.'
      object mnuTransactionRef1: TMenuItem
        Tag = 17
        Caption = '&Transaction Ref'
        Checked = True
        OnClick = Orders1Click
      end
      object mnuN8: TMenuItem
        Caption = '-'
      end
      object mnuOrders1: TMenuItem
        Tag = 1
        Caption = '&Orders'
        Checked = True
        OnClick = Orders1Click
      end
      object mnuDeliveries1: TMenuItem
        Tag = 2
        Caption = '&Deliveries'
        Checked = True
        OnClick = Orders1Click
      end
      object mnuTagged1: TMenuItem
        Tag = 3
        Caption = '&Tagged'
        OnClick = Orders1Click
      end
      object mnuNotTagged1: TMenuItem
        Tag = 4
        Caption = 'Not &Tagged'
        OnClick = Orders1Click
      end
      object mnuOnPickingRun1: TMenuItem
        Tag = 5
        Caption = '&On Picking Run'
        OnClick = Orders1Click
      end
      object mnuNotOnPickingRun1: TMenuItem
        Tag = 6
        Caption = 'Not &On Picking Run'
        OnClick = Orders1Click
      end
      object mnuWaitStock1: TMenuItem
        Tag = 7
        Caption = 'Wait Stock'
        OnClick = Orders1Click
      end
      object mnuNotWaitStock1: TMenuItem
        Tag = 8
        Caption = 'Not &Wait Stock'
        OnClick = Orders1Click
      end
      object mnuWaitforallStock1: TMenuItem
        Tag = 9
        Caption = '&Wait for all Stock'
        OnClick = Orders1Click
      end
      object mnuNotWaitforallStock1: TMenuItem
        Tag = 10
        Caption = 'Not &Wait for all Stock'
        OnClick = Orders1Click
      end
      object mnuN9: TMenuItem
        Caption = '-'
      end
      object mnuCreditHold1: TMenuItem
        Tag = 11
        Caption = '&Credit Hold'
        OnClick = Orders1Click
      end
      object mnuNotCreditHold1: TMenuItem
        Tag = 12
        Caption = 'Not &Credit Hold'
        OnClick = Orders1Click
      end
      object mnuQuery1: TMenuItem
        Tag = 13
        Caption = '&Query'
        OnClick = Orders1Click
      end
      object mnuNotQuery1: TMenuItem
        Tag = 14
        Caption = 'Not &Query'
        OnClick = Orders1Click
      end
      object mnuN10: TMenuItem
        Caption = '-'
      end
      object mnuAccountCode1: TMenuItem
        Tag = 15
        Caption = '&Account Code'
        OnClick = Orders1Click
      end
      object mnuN11: TMenuItem
        Caption = '-'
      end
      object mnuNoFilter1: TMenuItem
        Tag = 16
        Caption = 'No &Filter'
        OnClick = Orders1Click
      end
    end
    object Hold1: TMenuItem
      Caption = '&Hold'
      Hint = 'Holds the currently highlighted transaction.'
    end
    object Copy1: TMenuItem
      Caption = 'Cop&y'
      Hint = 
        'Generate an exact copy, or reverse of the currently highlighted ' +
        'transaction.'
    end
    object Convert1: TMenuItem
      Caption = 'Con&vert'
      Hint = 
        'Converts the currently highlighted quotation into either an invo' +
        'ice, or an order (SPOP version only).'
      OnClick = Convert1Click
    end
    object Post1: TMenuItem
      Caption = '&Daybook Post'
      Hint = 
        'Allows the posting of the current daybook, or the printing of va' +
        'rious posting related reports.'
      OnClick = Postdb1BtnClick
    end
    object SortView1: TMenuItem
      Caption = 'S&ort View'
      object RefreshView1: TMenuItem
        Caption = 'Refresh View'
        OnClick = RefreshView2Click
      end
      object CloseView1: TMenuItem
        Caption = 'Close View'
        OnClick = CloseView2Click
      end
      object N14: TMenuItem
        Caption = '-'
      end
      object SortViewOptions1: TMenuItem
        Caption = 'Sort View Options'
        OnClick = SortViewOptions2Click
      end
    end
    object Notes1: TMenuItem
      Tag = 1
      Caption = '&Notes'
      Hint = 'Shows the notepad for the currently highlighted transaction.'
      Visible = False
      OnClick = Pickdb1BtnClick
    end
    object Print1: TMenuItem
      Caption = '&Print'
      Enabled = False
      Hint = 'Prints the currently highlighted transaction.'
      OnClick = Printdb1BtnClick
    end
    object Pick1: TMenuItem
      Caption = 'Pic&k'
      Hint = 
        'Displays the currently highlighted Sales Order in a picking mode' +
        ', allowing the order picking status to be altered, or viewed.'
      OnClick = Pickdb1BtnClick
    end
    object Receive1: TMenuItem
      Caption = '&Receive'
      Hint = 
        'Displays the currently highlighted Purchase Order in a receipt m' +
        'ode, allowing the order receipt status to be altered, or viewed.'
      OnClick = Pickdb1BtnClick
    end
    object Match1: TMenuItem
      Caption = '&Match'
      Hint = 
        'Displays any matching information associated with an order or de' +
        'livery note.'
      OnClick = Matdb1BtnClick
    end
    object Remove1: TMenuItem
      Caption = '&Remove'
      Hint = 'Deletes the currently highlighted Quotation.'
      OnClick = Remdb1BtnClick
    end
    object Tag1: TMenuItem
      Caption = '&Tag'
      Hint = 
        'Tags the currently highlighted Order or Delivery Note, for selec' +
        'ted processing.'
    end
    object View1: TMenuItem
      Caption = '&View'
      Hint = 
        'Displays the currently highlighted transaction in a view only mo' +
        'de, ideal for list scanning.'
      OnClick = Adddb1BtnClick
    end
    object Returns1: TMenuItem
      Caption = 'Ret&urn'
      Hint = 
        'Generates a Stock Return Note for the currently highlighted Quot' +
        'ation.'
      OnClick = Returndb1BtnClick
    end
    object Filter1: TMenuItem
      Caption = 'F&ilter'
      Hint = 
        'Change the Override Location|Allows the list to be viewed by a d' +
        'ifferent Override Location, or all Override Locations.'
      Visible = False
      OnClick = Filterdb1BtnClick
    end
    object Custom1: TMenuItem
      Tag = 1
      Caption = 'Custom Btn 1'
      Visible = False
      OnClick = CustdbBtn1Click
    end
    object Custom2: TMenuItem
      Tag = 2
      Caption = 'Custom Btn 2'
      Visible = False
      OnClick = CustdbBtn1Click
    end
    object Custom3: TMenuItem
      Tag = 3
      Caption = 'Custom Btn 3'
      OnClick = CustdbBtn1Click
    end
    object Custom4: TMenuItem
      Tag = 4
      Caption = 'Custom Btn 4'
      OnClick = CustdbBtn1Click
    end
    object Custom5: TMenuItem
      Tag = 5
      Caption = 'Custom Btn 5'
      OnClick = CustdbBtn1Click
    end
    object Custom6: TMenuItem
      Tag = 6
      Caption = 'Custom Btn 6'
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
    OnPopup = PopupMenu2Popup
    Left = 221
    Top = 134
    object Copy2: TMenuItem
      Tag = 1
      Caption = '&Copy Transaction'
      HelpContext = 28
      Hint = 'Generate an exact copy of the currently highlighted transaction.'
      OnClick = Copy2Click
    end
    object Reverse1: TMenuItem
      Tag = 2
      Caption = '&Reverse/Contra Transaction'
      HelpContext = 28
      Hint = 
        'Generate the exact reverse of the currently highlighted transact' +
        'ion.'
      OnClick = Copy2Click
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object Back1: TMenuItem
      Tag = 3
      Caption = '&Back to Back Order'
      HelpContext = 19
      Hint = 
        'Generate a matching Purchase Order (POR) for the currently highl' +
        'ighted Sales Order (SOR).'
      OnClick = Copy2Click
    end
  end
  object PopupMenu3: TPopupMenu
    OnPopup = PopupMenu2Popup
    Left = 220
    Top = 197
    object HQ1: TMenuItem
      Tag = 1
      Caption = 'Hold for &Query'
      HelpContext = 21
      Hint = 'Holds the currently highlighted transaction.'
      OnClick = HQ1Click
    end
    object HQS1: TMenuItem
      Tag = 7
      Caption = 'Hold for S&tock'
      Hint = 
        'Holds the currently highlighted record untill any stock is avail' +
        'able.'
      OnClick = HQ1Click
    end
    object HQS2: TMenuItem
      Tag = 8
      Caption = 'Hold for A&ll Stock'
      Hint = 
        'Holds the currently highlighted record untill all stock is avail' +
        'able.'
      OnClick = HQ1Click
    end
    object HCR1: TMenuItem
      Tag = 10
      Caption = 'Hold for Cre&dit'
      OnClick = HQ1Click
    end
    object HU1: TMenuItem
      Tag = 2
      Caption = 'Hold &until allocated'
      HelpContext = 21
      Hint = 
        'Holds the currently highlighted transaction until it is allocate' +
        'd.'
      OnClick = HQ1Click
    end
    object HA1: TMenuItem
      Tag = 3
      Caption = '&Authorise'
      HelpContext = 21
      Hint = 
        'Sets the currently highlighted transaction as authorised for pay' +
        'ment.'
      OnClick = HQ1Click
    end
    object N5: TMenuItem
      Caption = '-'
      OnClick = HQ1Click
    end
    object HSP1: TMenuItem
      Tag = 4
      Caption = '&Stop posting here'
      HelpContext = 21
      Hint = 
        'Places a Stop Posting Here (Suspend) marker at the currently hig' +
        'hlighted transaction.'
      OnClick = HQ1Click
    end
    object MenuItem3: TMenuItem
      Caption = '-'
      OnClick = HQ1Click
    end
    object HC1: TMenuItem
      Tag = 5
      Caption = '&Cancel hold'
      HelpContext = 21
      Hint = 'Cancels the hold on the currently highlighted transaction.'
      OnClick = HQ1Click
    end
    object HR1: TMenuItem
      Tag = 6
      Caption = '&Remove suspend'
      HelpContext = 21
      Hint = 
        'Cancels the Stop Posting marker on the currently highlighted tra' +
        'nsaction.'
      OnClick = HQ1Click
    end
  end
  object PopupMenu4: TPopupMenu
    OnPopup = PopupMenu2Popup
    Left = 218
    Top = 261
    object QuoO1: TMenuItem
      Tag = 14
      Caption = 'Convert to &Order'
      HelpContext = 52
      Hint = 
        'Convert the currently highlighted Quotation (SQU/PQU) to an Orde' +
        'r (SOR/POR), taking the next Order No.'
      OnClick = QuoI1Click
    end
    object QuoI1: TMenuItem
      Tag = 6
      Caption = 'Convert to &Invoice'
      HelpContext = 52
      Hint = 
        'Convert the currently highlighted Quotation (SQU/PQU) to an Invo' +
        'ice (SIN/PIN), taking the next Invoice No.'
      OnClick = QuoI1Click
    end
  end
  object PopupMenu5: TPopupMenu
    OnPopup = PopupMenu5Popup
    Left = 295
    Top = 101
    object GLPP1: TMenuItem
      Caption = '&General Ledger Preposting Report'
      HelpContext = 29
      Hint = 
        'Produce a preposting report for the current daybook indicating t' +
        'he items & value which will be posted by G/L Code.'
      OnClick = GLPP1Click
    end
    object DPP1: TMenuItem
      Caption = '&Document Preposting Report'
      HelpContext = 29
      Hint = 
        'Produce a preposting report for the current daybook indicating t' +
        'he items & value which will be posted by Document Type.'
      OnClick = GLPP1Click
    end
    object DO1: TMenuItem
      Tag = 1
      Caption = '&Deliver this Order'
      HelpContext = 492
      Hint = 
        'Deliver the currently highlighted Order based on the items marke' +
        'd as picked/received.'
      OnClick = DO1Click
    end
    object DPO1: TMenuItem
      Tag = 1
      Caption = 'Deliver &Picked Orders'
      HelpContext = 492
      Hint = 'Deliver all Sales Orders which have items marked as picked.'
      OnClick = DO1Click
    end
    object DRO1: TMenuItem
      Tag = 1
      Caption = 'Deliver &Received Orders to PDN'
      HelpContext = 492
      Hint = 'Deliver all Purchase Orders which have items marked as received.'
      OnClick = DO1Click
    end
    object DRO2: TMenuItem
      Tag = 1
      Caption = 'Invoice R&eceived Orders (POR->PIN)'
      Hint = 
        'Invoice all Purchase Orders which have items marked as received ' +
        'bypassing the PDN stage'
      OnClick = DO1Click
    end
    object ITD1: TMenuItem
      Tag = 2
      Caption = '&Invoice this Delivery'
      HelpContext = 493
      Hint = 'Convert the currently highlighted Delivery Note to an Invoice.'
      OnClick = DO1Click
    end
    object IAD1: TMenuItem
      Tag = 2
      Caption = 'Invoice &all Deliveries'
      HelpContext = 493
      Hint = 'Convert all Delivery Notes to Invoices.'
      OnClick = DO1Click
    end
    object IGD1: TMenuItem
      Tag = 2
      Caption = 'Invoice &Tagged Deliveries'
      HelpContext = 493
      Hint = 
        'Convert all Delivery Notes marked as tagged in the status column' +
        ' to Invoices.'
      OnClick = DO1Click
    end
    object ITWO1: TMenuItem
      Tag = 80
      Caption = '&Issue this Works Order'
      OnClick = ITWO1Click
    end
    object IAWO1: TMenuItem
      Tag = 80
      Caption = 'Issue &all Works Orders'
      OnClick = IAWO1Click
    end
    object BTRT1: TMenuItem
      Tag = 100
      Caption = '&Book in this Return'
      OnClick = ITRT1Click
    end
    object BART1: TMenuItem
      Tag = 100
      Caption = 'B&ook in all Returns'
      OnClick = BART1Click
    end
    object N12: TMenuItem
      Caption = '-'
    end
    object BTWO1: TMenuItem
      Tag = 81
      Caption = '&Build this Works Order'
      OnClick = ITWO1Click
    end
    object BAWO1: TMenuItem
      Tag = 81
      Caption = 'B&uild all Works Orders'
      OnClick = IAWO1Click
    end
    object ITRT1: TMenuItem
      Tag = 101
      Caption = 'A&ction this Return'
      HelpContext = 1598
      OnClick = ITRT1Click
    end
    object IART1: TMenuItem
      Tag = 102
      Caption = 'Action &all Returns'
      HelpContext = 1598
      OnClick = ITRT1Click
    end
    object N6: TMenuItem
      Caption = '-'
    end
    object PD1: TMenuItem
      Caption = '&Post this Daybook'
      HelpContext = 29
      Hint = 
        'Post all eligible transactions within this daybook to the Genera' +
        'l Ledger.'
      OnClick = PD1Click
    end
    object SDT1: TMenuItem
      Caption = '&Show Daybook Totals'
      HelpContext = 29
      Hint = 
        'Display the value of all transactions within the current daybook' +
        '.'
      OnClick = SDT1Click
    end
    object N7: TMenuItem
      Caption = '-'
    end
    object RDR1: TMenuItem
      Tag = 11
      Caption = 'Reprint D&elivery run'
      HelpContext = 482
      Hint = 'Reprint a previous Delivery Note run by specifying a Run No.'
      OnClick = DO1Click
    end
    object RIR1: TMenuItem
      Tag = 12
      Caption = 'Reprint I&nvoice run'
      HelpContext = 482
      Hint = 'Reprint a previous Invoice run by specifying a Run No.'
      OnClick = DO1Click
    end
    object N13: TMenuItem
      Caption = '-'
    end
    object RPWI1: TMenuItem
      Tag = 90
      Caption = 'R&eprint Issue run'
      OnClick = IAWO1Click
    end
    object RPWB1: TMenuItem
      Tag = 91
      Caption = 'Repri&nt Build run'
      OnClick = IAWO1Click
    end
    object RPRet1: TMenuItem
      Tag = 102
      Caption = 'R&eprint Return Action'
      OnClick = RPRet1Click
    end
    object N15: TMenuItem
      Caption = '-'
    end
    object PostTransactionOnly: TMenuItem
      Caption = 'Post Only'
      Visible = False
      OnClick = PostTransactionOnlyClick
    end
    object PostTransactionWithReport: TMenuItem
      Caption = 'Post Only with report '
      Visible = False
      OnClick = PostTransactionWithReportClick
    end
  end
  object PopupMenu6: TPopupMenu
    OnPopup = PopupMenu2Popup
    Left = 300
    Top = 149
    object PrintDoc1: TMenuItem
      Tag = 6
      Caption = '&This Document'
      HelpContext = 495
      Hint = 'Print the currently highlighted Document'
      OnClick = PrintDoc1Click
    end
    object GenPick1: TMenuItem
      Tag = 14
      Caption = '&Picking List Run'
      HelpContext = 495
      Hint = 'Generate a picking list.'
      OnClick = GenPick1Click
    end
  end
  object PopupMenu7: TPopupMenu
    Left = 295
    Top = 198
    object Tag2: TMenuItem
      Tag = 6
      Caption = '&Tag/Untag this transaction'
      HelpContext = 495
      Hint = 'Tag the currently highlighted Document'
      OnClick = Tag2Click
    end
    object Untag1: TMenuItem
      Tag = 14
      Caption = '&Untag all tagged transactions'
      HelpContext = 495
      Hint = 'Untag any transaction currently marked as tagged.'
      OnClick = Untag1Click
    end
  end
  object PopupFindBtn: TPopupMenu
    Left = 287
    Top = 255
    object TransactionRef1: TMenuItem
      Tag = 17
      Caption = '&Transaction Ref'
      OnClick = Orders1Click
    end
    object N8: TMenuItem
      Caption = '-'
    end
    object Orders1: TMenuItem
      Tag = 1
      Caption = '&Orders'
      OnClick = Orders1Click
    end
    object Deliveries1: TMenuItem
      Tag = 2
      Caption = '&Deliveries'
      OnClick = Orders1Click
    end
    object Tagged1: TMenuItem
      Tag = 3
      Caption = '&Tagged'
      OnClick = Orders1Click
    end
    object NotTagged1: TMenuItem
      Tag = 4
      Caption = 'Not &Tagged'
      OnClick = Orders1Click
    end
    object OnPickingRun1: TMenuItem
      Tag = 5
      Caption = '&On Picking Run'
      OnClick = Orders1Click
    end
    object NotOnPickingRun1: TMenuItem
      Tag = 6
      Caption = 'Not &On Picking Run'
      OnClick = Orders1Click
    end
    object WaitStock1: TMenuItem
      Tag = 7
      Caption = 'Wait Stock'
      OnClick = Orders1Click
    end
    object NotWaitStock1: TMenuItem
      Tag = 8
      Caption = 'Not &Wait Stock'
      OnClick = Orders1Click
    end
    object WaitforallStock1: TMenuItem
      Tag = 9
      Caption = '&Wait for all Stock'
      OnClick = Orders1Click
    end
    object NotWaitforallStock1: TMenuItem
      Tag = 10
      Caption = 'Not &Wait for all Stock'
      OnClick = Orders1Click
    end
    object N9: TMenuItem
      Caption = '-'
    end
    object CreditHold1: TMenuItem
      Tag = 11
      Caption = '&Credit Hold'
      OnClick = Orders1Click
    end
    object NotCreditHold1: TMenuItem
      Tag = 12
      Caption = 'Not &Credit Hold'
      OnClick = Orders1Click
    end
    object Query1: TMenuItem
      Tag = 13
      Caption = '&Query'
      OnClick = Orders1Click
    end
    object NotQuery1: TMenuItem
      Tag = 14
      Caption = 'Not &Query'
      OnClick = Orders1Click
    end
    object N10: TMenuItem
      Caption = '-'
    end
    object AccountCode1: TMenuItem
      Tag = 15
      Caption = '&Account Code'
      OnClick = Orders1Click
    end
    object N11: TMenuItem
      Caption = '-'
    end
    object NoFilter1: TMenuItem
      Tag = 16
      Caption = 'No &Filter'
      OnClick = Orders1Click
    end
  end
  object EntCustom1: TCustomisation
    DLLId = SysDll_Ent
    Enabled = True
    ExportPath = 'X:\ENTRPRSE\CUSTOM\DEMOHOOK\Daybk1.RC'
    WindowId = 102000
    Left = 442
    Top = 60
  end
  object SortViewPopupMenu: TPopupMenu
    Left = 159
    Top = 131
    object RefreshView2: TMenuItem
      Caption = '&Refresh View'
      OnClick = RefreshView2Click
    end
    object CloseView2: TMenuItem
      Caption = '&Close View'
      OnClick = CloseView2Click
    end
    object MenuItem1: TMenuItem
      Caption = '-'
    end
    object SortViewOptions2: TMenuItem
      Caption = 'Sort View &Options'
      OnClick = SortViewOptions2Click
    end
  end
  object PopupMenu9: TPopupMenu
    Left = 158
    Top = 83
    object FList1: TMenuItem
      Caption = '&Filter by Override Location'
      Hint = 
        'Choosing this option filters the current list by override locati' +
        'on, specifying a blank override location gives a consolidated vi' +
        'ew.'
      OnClick = FList1Click
    end
    object ClearFilterItem1: TMenuItem
      Caption = '&Clear Current Filter'
      Hint = 'Choosing this option clears the current filter being used'
      OnClick = ClearFilterItem1Click
    end
    object FilterSeparator1: TMenuItem
      Caption = '-'
    end
    object FilterbyTransactionOriginator1: TMenuItem
      Caption = 'Filter by &Transaction Originator'
      OnClick = FilterbyTransactionOriginator1Click
    end
    object ClearTransactionOriginator1: TMenuItem
      Caption = 'C&lear Transaction Originator'
      OnClick = ClearTransactionOriginator1Click
    end
    object FilterSeparator2: TMenuItem
      Caption = '-'
    end
    object FilterbyCustomer1: TMenuItem
      Caption = 'Filter by C&ustomer'
      OnClick = FilterbyCustomer1Click
    end
    object FilterbyConsumer1: TMenuItem
      Caption = 'Filter by Co&nsumer'
      OnClick = FilterbyConsumer1Click
    end
    object ClearCustomerConsumerFilter1: TMenuItem
      Caption = 'Cl&ear Customer/Consumer Filter'
      OnClick = ClearCustomerConsumerFilter1Click
    end
  end
  object WindowExport: TWindowExport
    OnEnableExport = WindowExportEnableExport
    OnExecuteCommand = WindowExportExecuteCommand
    OnGetExportDescription = WindowExportGetExportDescription
    Left = 34
    Top = 102
  end
end
