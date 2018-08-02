object RetDoc: TRetDoc
  Left = 420
  Top = 195
  Width = 652
  Height = 450
  HelpContext = 1594
  Caption = 'Returns Document'
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
    Left = 0
    Top = 0
    Width = 630
    Height = 375
    ActivePage = TabSheet3
    TabIndex = 3
    TabOrder = 0
    OnChange = PageControl1Change
    OnChanging = PageControl1Changing
    object AdjustPage: TTabSheet
      Caption = 'Return'
      object A1SBox: TScrollBox
        Left = 0
        Top = 88
        Width = 500
        Height = 236
        HorzScrollBar.Position = 374
        HorzScrollBar.Tracking = True
        VertScrollBar.Tracking = True
        VertScrollBar.Visible = False
        TabOrder = 0
        OnClick = A1CPanelClick
        object A1HedPanel: TSBSPanel
          Left = -372
          Top = 1
          Width = 868
          Height = 17
          BevelInner = bvLowered
          BevelOuter = bvNone
          Color = clWhite
          TabOrder = 0
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumnHeader
          object A1GLab: TSBSPanel
            Left = 723
            Top = 2
            Width = 59
            Height = 13
            HelpContext = 1633
            BevelOuter = bvNone
            Caption = 'G/L Code'
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
            OnMouseDown = A1CLabMouseDown
            OnMouseMove = A1CLabMouseMove
            OnMouseUp = A1CPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object A1OLab: TSBSPanel
            Left = 644
            Top = 2
            Width = 24
            Height = 13
            HelpContext = 249
            BevelOuter = bvNone
            Caption = 'TC'
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
            OnMouseDown = A1CLabMouseDown
            OnMouseMove = A1CLabMouseMove
            OnMouseUp = A1CPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object A1ILab: TSBSPanel
            Left = 479
            Top = 2
            Width = 84
            Height = 13
            HelpContext = 1628
            BevelOuter = bvNone
            Caption = 'Line Total'
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
            OnMouseDown = A1CLabMouseDown
            OnMouseMove = A1CLabMouseMove
            OnMouseUp = A1CPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object A1CCLab: TSBSPanel
            Left = 784
            Top = 2
            Width = 35
            Height = 13
            HelpContext = 272
            BevelOuter = bvNone
            Caption = 'CC'
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
            OnMouseDown = A1CLabMouseDown
            OnMouseMove = A1CLabMouseMove
            OnMouseUp = A1CPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object A1DpLab: TSBSPanel
            Left = 827
            Top = 2
            Width = 34
            Height = 13
            HelpContext = 272
            BevelOuter = bvNone
            Caption = 'Dept'
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
            OnMouseDown = A1CLabMouseDown
            OnMouseMove = A1CLabMouseMove
            OnMouseUp = A1CPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object A1BLab: TSBSPanel
            Left = 151
            Top = 2
            Width = 65
            Height = 13
            HelpContext = 1623
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = 'Expctd Qty '
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
            OnMouseDown = A1CLabMouseDown
            OnMouseMove = A1CLabMouseMove
            OnMouseUp = A1CPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object A1LocLab: TSBSPanel
            Left = 671
            Top = 2
            Width = 52
            Height = 13
            BevelOuter = bvNone
            Caption = 'Spare'
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
            OnMouseDown = A1CLabMouseDown
            OnMouseMove = A1CLabMouseMove
            OnMouseUp = A1CPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object A1UOLab: TSBSPanel
            Left = 214
            Top = 2
            Width = 60
            Height = 13
            HelpContext = 1624
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = 'Returned '
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
            OnMouseDown = A1CLabMouseDown
            OnMouseMove = A1CLabMouseMove
            OnMouseUp = A1CPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object A1OSLab: TSBSPanel
            Left = 275
            Top = 2
            Width = 60
            Height = 13
            HelpContext = 1625
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = 'Repaired '
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
            OnMouseDown = A1CLabMouseDown
            OnMouseMove = A1CLabMouseMove
            OnMouseUp = A1CPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object A1BULab: TSBSPanel
            Left = 569
            Top = 2
            Width = 72
            Height = 13
            HelpContext = 1629
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = 'Unit Price'
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
            OnMouseDown = A1CLabMouseDown
            OnMouseMove = A1CLabMouseMove
            OnMouseUp = A1CPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object A1IssLab: TSBSPanel
            Left = 402
            Top = 2
            Width = 75
            Height = 13
            HelpContext = 1627
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
            TabOrder = 10
            OnMouseDown = A1CLabMouseDown
            OnMouseMove = A1CLabMouseMove
            OnMouseUp = A1CPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object A1WOLab: TSBSPanel
            Left = 337
            Top = 2
            Width = 60
            Height = 13
            HelpContext = 1626
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = 'O/S '
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
            OnMouseDown = A1CLabMouseDown
            OnMouseMove = A1CLabMouseMove
            OnMouseUp = A1CPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object A1CLab: TSBSPanel
            Left = 2
            Top = 2
            Width = 145
            Height = 13
            HelpContext = 1622
            Alignment = taLeftJustify
            BevelOuter = bvNone
            Caption = '  Stock Code / Description'
            Color = clWhite
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 12
            OnMouseDown = A1CLabMouseDown
            OnMouseMove = A1CLabMouseMove
            OnMouseUp = A1CPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
        end
        object A1CPanel: TSBSPanel
          Left = -371
          Top = 22
          Width = 152
          Height = 189
          HelpContext = 1622
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
          OnMouseUp = A1CPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object A1BUPanel: TSBSPanel
          Left = 200
          Top = 22
          Width = 71
          Height = 189
          HelpContext = 1629
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
          OnMouseUp = A1CPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object A1GPanel: TSBSPanel
          Left = 352
          Top = 22
          Width = 59
          Height = 189
          HelpContext = 1633
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
          OnMouseUp = A1CPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object A1OPanel: TSBSPanel
          Left = 273
          Top = 22
          Width = 25
          Height = 189
          HelpContext = 249
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
          OnMouseUp = A1CPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object A1CCPanel: TSBSPanel
          Left = 413
          Top = 22
          Width = 35
          Height = 189
          HelpContext = 272
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
          OnMouseUp = A1CPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object A1DpPanel: TSBSPanel
          Left = 450
          Top = 22
          Width = 35
          Height = 189
          HelpContext = 272
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
          OnMouseUp = A1CPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object A1BPanel: TSBSPanel
          Left = -217
          Top = 22
          Width = 60
          Height = 189
          HelpContext = 1623
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
          OnMouseUp = A1CPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object A1LocPanel: TSBSPanel
          Left = 300
          Top = 22
          Width = 50
          Height = 189
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
          OnMouseUp = A1CPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object A1UOPanel: TSBSPanel
          Left = -155
          Top = 22
          Width = 60
          Height = 189
          HelpContext = 1624
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
          OnMouseUp = A1CPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object A1WOPanel: TSBSPanel
          Left = -29
          Top = 22
          Width = 60
          Height = 189
          HelpContext = 1626
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
          OnMouseUp = A1CPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object A1IPanel: TSBSPanel
          Left = 109
          Top = 22
          Width = 89
          Height = 189
          HelpContext = 1628
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
          OnMouseUp = A1CPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object A1IssPanel: TSBSPanel
          Left = 33
          Top = 22
          Width = 74
          Height = 189
          HelpContext = 1627
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
          OnMouseUp = A1CPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object A1OSPanel: TSBSPanel
          Left = -92
          Top = 22
          Width = 60
          Height = 189
          HelpContext = 1625
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 13
          OnMouseUp = A1CPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
      end
      object A1BtmPanel: TSBSPanel
        Left = 0
        Top = 326
        Width = 622
        Height = 20
        HelpContext = 1311
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 1
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        object CCPanel: TSBSPanel
          Left = 0
          Top = 3
          Width = 172
          Height = 17
          HelpContext = 272
          BevelOuter = bvLowered
          ParentColor = True
          TabOrder = 0
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          Purpose = puFrame
          object CCTit: Label8
            Left = 3
            Top = 1
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
            Top = 1
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
            Top = 1
            Width = 30
            Height = 14
            AutoSize = False
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
            Top = 1
            Width = 30
            Height = 14
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
        object CostPanel: TSBSPanel
          Left = 175
          Top = 3
          Width = 147
          Height = 17
          HelpContext = 1619
          BevelOuter = bvLowered
          ParentColor = True
          TabOrder = 1
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          Purpose = puFrame
          object DrReqdTit: Label8
            Left = 4
            Top = 1
            Width = 47
            Height = 14
            Caption = 'Returned:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TextId = 0
          end
          object CostLab: Label8
            Left = 53
            Top = 1
            Width = 92
            Height = 14
            HelpContext = 1619
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
        object IssuePanel: TSBSPanel
          Left = 324
          Top = 3
          Width = 161
          Height = 17
          HelpContext = 1620
          BevelOuter = bvLowered
          ParentColor = True
          TabOrder = 2
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          Purpose = puFrame
          object CrReqdTit: Label8
            Left = 4
            Top = 1
            Width = 49
            Height = 14
            Caption = 'Repaired :'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TextId = 0
          end
          object IssuedLab: Label8
            Left = 67
            Top = 1
            Width = 92
            Height = 14
            HelpContext = 1620
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
        object FinPanel: TSBSPanel
          Left = 486
          Top = 3
          Width = 133
          Height = 17
          HelpContext = 1621
          BevelOuter = bvLowered
          ParentColor = True
          TabOrder = 3
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          object Label812: Label8
            Left = 1
            Top = 1
            Width = 58
            Height = 14
            Alignment = taRightJustify
            AutoSize = False
            Caption = '%Complete:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TextId = 0
          end
          object Gauge1: TGauge
            Left = 61
            Top = 1
            Width = 70
            Height = 14
            Hint = '|Shows what percentage of the Works Order has been issued'
            HelpContext = 1313
            BackColor = clBlack
            BorderStyle = bsNone
            Color = clBlack
            ForeColor = clYellow
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWhite
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentColor = False
            ParentFont = False
            ParentShowHint = False
            Progress = 0
            ShowHint = True
          end
        end
      end
      object A1ListBtnPanel: TSBSPanel
        Left = 501
        Top = 88
        Width = 18
        Height = 236
        BevelOuter = bvLowered
        TabOrder = 2
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
      end
    end
    object TabSheet1: TTabSheet
      HelpContext = 1630
      Caption = 'Analysis'
      ImageIndex = 2
    end
    object TabSheet2: TTabSheet
      Caption = 'TabSheet2'
      ImageIndex = 3
      TabVisible = False
    end
    object TabSheet4: TTabSheet
      HelpContext = 1619
      Caption = 'Footer'
      ImageIndex = 5
      object SBSPanel55: TSBSBackGroup
        Left = 304
        Top = 128
        Width = 318
        Height = 185
        Caption = 'Totals:'
        TextId = 0
      end
      object Label5: TLabel
        Left = 312
        Top = 148
        Width = 84
        Height = 14
        Caption = 'Settlement Disc%'
      end
      object Label6: TLabel
        Left = 464
        Top = 148
        Width = 25
        Height = 14
        Caption = 'Days'
      end
      object Label4: TLabel
        Left = 337
        Top = 204
        Width = 16
        Height = 14
        Caption = 'Net'
      end
      object Label14: TLabel
        Left = 333
        Top = 231
        Width = 20
        Height = 14
        Caption = 'VAT'
      end
      object Label15: TLabel
        Left = 311
        Top = 258
        Width = 42
        Height = 14
        Caption = 'Discount'
      end
      object Label16: TLabel
        Left = 331
        Top = 284
        Width = 22
        Height = 14
        Caption = 'Total'
      end
      object Label20: TLabel
        Left = 487
        Top = 284
        Width = 22
        Height = 14
        Caption = 'Total'
      end
      object Label19: TLabel
        Left = 467
        Top = 258
        Width = 42
        Height = 14
        Caption = 'Discount'
      end
      object Label18: TLabel
        Left = 489
        Top = 231
        Width = 20
        Height = 14
        Caption = 'VAT'
      end
      object Label17: TLabel
        Left = 493
        Top = 204
        Width = 16
        Height = 14
        Caption = 'Net'
      end
      object panFooterTotals: TSBSBackGroup
        Left = 304
        Top = 1
        Width = 166
        Height = 125
        Caption = 'Totals:'
        TextId = 0
      end
      object lblTotalsNet: TLabel
        Left = 307
        Top = 20
        Width = 54
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Net'
      end
      object lblTotalsVAT: TLabel
        Left = 307
        Top = 46
        Width = 54
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'VAT'
      end
      object lblTotalsDiscount: TLabel
        Left = 307
        Top = 72
        Width = 54
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Discount'
      end
      object lblTotalsTotal: TLabel
        Left = 307
        Top = 98
        Width = 54
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Total'
      end
      object SBSPanel53: TSBSPanel
        Left = 3
        Top = 7
        Width = 295
        Height = 306
        BevelInner = bvRaised
        BevelOuter = bvLowered
        PopupMenu = PopupMenu1
        TabOrder = 0
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        object Label834: Label8
          Left = 143
          Top = 12
          Width = 70
          Height = 14
          Alignment = taRightJustify
          Caption = 'Cntrl G/L Code'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          PopupMenu = PopupMenu1
          TextId = 0
        end
        object I5VRateL: TLabel
          Left = 128
          Top = 39
          Width = 64
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = ' Ex.Rate'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          Visible = False
        end
        object SBSPanel54: TSBSPanel
          Left = 8
          Top = 36
          Width = 277
          Height = 17
          TabOrder = 0
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          object I5VATRLab: TLabel
            Left = 3
            Top = 2
            Width = 65
            Height = 13
            AutoSize = False
            Caption = ' Rate'
          end
          object Label8: TLabel
            Left = 131
            Top = 2
            Width = 32
            Height = 14
            Caption = 'Goods'
          end
          object I5VATLab: TLabel
            Left = 174
            Top = 3
            Width = 80
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'VAT'
          end
        end
      end
      object ScrollBox8: TScrollBox
        Left = 10
        Top = 63
        Width = 280
        Height = 244
        HelpContext = 286
        HorzScrollBar.Visible = False
        TabOrder = 4
        object I5VR1F: Text8Pt
          Tag = 2
          Left = 2
          Top = 2
          Width = 65
          Height = 22
          TabStop = False
          AutoSize = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ReadOnly = True
          TabOrder = 0
          Visible = False
          TextId = 0
          ViaSBtn = False
        end
        object I5VR2F: Text8Pt
          Tag = 2
          Left = 2
          Top = 26
          Width = 65
          Height = 22
          TabStop = False
          AutoSize = False
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ReadOnly = True
          TabOrder = 1
          Visible = False
          TextId = 0
          ViaSBtn = False
        end
        object I5VR3F: Text8Pt
          Tag = 2
          Left = 2
          Top = 50
          Width = 65
          Height = 22
          TabStop = False
          AutoSize = False
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ReadOnly = True
          TabOrder = 2
          Visible = False
          TextId = 0
          ViaSBtn = False
        end
        object I5VR4F: Text8Pt
          Tag = 2
          Left = 2
          Top = 74
          Width = 65
          Height = 22
          TabStop = False
          AutoSize = False
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ReadOnly = True
          TabOrder = 3
          Visible = False
          TextId = 0
          ViaSBtn = False
        end
        object I5VR5F: Text8Pt
          Tag = 2
          Left = 2
          Top = 98
          Width = 65
          Height = 22
          TabStop = False
          AutoSize = False
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ReadOnly = True
          TabOrder = 4
          Visible = False
          TextId = 0
          ViaSBtn = False
        end
        object I5VR6F: Text8Pt
          Tag = 2
          Left = 2
          Top = 122
          Width = 65
          Height = 22
          TabStop = False
          AutoSize = False
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ReadOnly = True
          TabOrder = 5
          Visible = False
          TextId = 0
          ViaSBtn = False
        end
        object I5VR7F: Text8Pt
          Tag = 2
          Left = 2
          Top = 145
          Width = 65
          Height = 22
          TabStop = False
          AutoSize = False
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ReadOnly = True
          TabOrder = 6
          Visible = False
          TextId = 0
          ViaSBtn = False
        end
        object I5VG1F: TCurrencyEdit
          Tag = 2
          Left = 69
          Top = 2
          Width = 100
          Height = 22
          TabStop = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Lines.Strings = (
            '0.67-')
          ParentFont = False
          ReadOnly = True
          TabOrder = 21
          Visible = False
          WantReturns = False
          WordWrap = False
          AutoSize = False
          BlockNegative = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
          ShowCurrency = False
          TextId = 0
          Value = -0.666666
        end
        object I5VG2F: TCurrencyEdit
          Tag = 2
          Left = 69
          Top = 26
          Width = 100
          Height = 22
          TabStop = False
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Lines.Strings = (
            '0.67-')
          ParentFont = False
          ReadOnly = True
          TabOrder = 22
          Visible = False
          WantReturns = False
          WordWrap = False
          AutoSize = False
          BlockNegative = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
          ShowCurrency = False
          TextId = 0
          Value = -0.666666
        end
        object I5VG3F: TCurrencyEdit
          Tag = 2
          Left = 69
          Top = 50
          Width = 100
          Height = 22
          TabStop = False
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Lines.Strings = (
            '0.67-')
          ParentFont = False
          ReadOnly = True
          TabOrder = 23
          Visible = False
          WantReturns = False
          WordWrap = False
          AutoSize = False
          BlockNegative = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
          ShowCurrency = False
          TextId = 0
          Value = -0.666666
        end
        object I5VG4F: TCurrencyEdit
          Tag = 2
          Left = 69
          Top = 74
          Width = 100
          Height = 22
          TabStop = False
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Lines.Strings = (
            '0.67-')
          ParentFont = False
          ReadOnly = True
          TabOrder = 24
          Visible = False
          WantReturns = False
          WordWrap = False
          AutoSize = False
          BlockNegative = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
          ShowCurrency = False
          TextId = 0
          Value = -0.666666
        end
        object I5VG5F: TCurrencyEdit
          Tag = 2
          Left = 69
          Top = 98
          Width = 100
          Height = 22
          TabStop = False
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Lines.Strings = (
            '0.67-')
          ParentFont = False
          ReadOnly = True
          TabOrder = 25
          Visible = False
          WantReturns = False
          WordWrap = False
          AutoSize = False
          BlockNegative = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
          ShowCurrency = False
          TextId = 0
          Value = -0.666666
        end
        object I5VG6F: TCurrencyEdit
          Tag = 2
          Left = 69
          Top = 122
          Width = 100
          Height = 22
          TabStop = False
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Lines.Strings = (
            '0.67-')
          ParentFont = False
          ReadOnly = True
          TabOrder = 26
          Visible = False
          WantReturns = False
          WordWrap = False
          AutoSize = False
          BlockNegative = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
          ShowCurrency = False
          TextId = 0
          Value = -0.666666
        end
        object I5VG7F: TCurrencyEdit
          Tag = 2
          Left = 69
          Top = 145
          Width = 100
          Height = 22
          TabStop = False
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Lines.Strings = (
            '0.67-')
          ParentFont = False
          ReadOnly = True
          TabOrder = 27
          Visible = False
          WantReturns = False
          WordWrap = False
          AutoSize = False
          BlockNegative = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
          ShowCurrency = False
          TextId = 0
          Value = -0.666666
        end
        object I5VV1F: TCurrencyEdit
          Tag = 1
          Left = 171
          Top = 2
          Width = 88
          Height = 22
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Lines.Strings = (
            '0.67-')
          ParentFont = False
          ReadOnly = True
          TabOrder = 42
          Visible = False
          WantReturns = False
          WordWrap = False
          OnExit = I5VV1FExit
          AutoSize = False
          BlockNegative = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
          ShowCurrency = False
          TextId = 0
          Value = -0.666666
        end
        object I5VV2F: TCurrencyEdit
          Tag = 1
          Left = 171
          Top = 26
          Width = 88
          Height = 22
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Lines.Strings = (
            '0.67-')
          ParentFont = False
          ReadOnly = True
          TabOrder = 43
          Visible = False
          WantReturns = False
          WordWrap = False
          OnExit = I5VV1FExit
          AutoSize = False
          BlockNegative = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
          ShowCurrency = False
          TextId = 0
          Value = -0.666666
        end
        object I5VV3F: TCurrencyEdit
          Tag = 1
          Left = 171
          Top = 50
          Width = 88
          Height = 22
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Lines.Strings = (
            '0.67-')
          ParentFont = False
          ReadOnly = True
          TabOrder = 44
          Visible = False
          WantReturns = False
          WordWrap = False
          OnExit = I5VV1FExit
          AutoSize = False
          BlockNegative = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
          ShowCurrency = False
          TextId = 0
          Value = -0.666666
        end
        object I5VV4F: TCurrencyEdit
          Tag = 1
          Left = 171
          Top = 74
          Width = 88
          Height = 22
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Lines.Strings = (
            '0.67-')
          ParentFont = False
          ReadOnly = True
          TabOrder = 45
          Visible = False
          WantReturns = False
          WordWrap = False
          OnExit = I5VV1FExit
          AutoSize = False
          BlockNegative = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
          ShowCurrency = False
          TextId = 0
          Value = -0.666666
        end
        object I5VV5F: TCurrencyEdit
          Tag = 1
          Left = 171
          Top = 98
          Width = 88
          Height = 22
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Lines.Strings = (
            '0.67-')
          ParentFont = False
          ReadOnly = True
          TabOrder = 46
          Visible = False
          WantReturns = False
          WordWrap = False
          OnExit = I5VV1FExit
          AutoSize = False
          BlockNegative = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
          ShowCurrency = False
          TextId = 0
          Value = -0.666666
        end
        object I5VV6F: TCurrencyEdit
          Tag = 1
          Left = 171
          Top = 122
          Width = 88
          Height = 22
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Lines.Strings = (
            '0.67-')
          ParentFont = False
          ReadOnly = True
          TabOrder = 47
          Visible = False
          WantReturns = False
          WordWrap = False
          OnExit = I5VV1FExit
          AutoSize = False
          BlockNegative = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
          ShowCurrency = False
          TextId = 0
          Value = -0.666666
        end
        object I5VV7F: TCurrencyEdit
          Tag = 1
          Left = 171
          Top = 145
          Width = 88
          Height = 22
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Lines.Strings = (
            '0.67-')
          ParentFont = False
          ReadOnly = True
          TabOrder = 48
          Visible = False
          WantReturns = False
          WordWrap = False
          OnExit = I5VV1FExit
          AutoSize = False
          BlockNegative = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
          ShowCurrency = False
          TextId = 0
          Value = -0.666666
        end
        object I5VR8F: Text8Pt
          Tag = 2
          Left = 2
          Top = 168
          Width = 65
          Height = 22
          TabStop = False
          AutoSize = False
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ReadOnly = True
          TabOrder = 7
          Visible = False
          TextId = 0
          ViaSBtn = False
        end
        object I5VG8F: TCurrencyEdit
          Tag = 2
          Left = 69
          Top = 168
          Width = 100
          Height = 22
          TabStop = False
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Lines.Strings = (
            '0.67-')
          ParentFont = False
          ReadOnly = True
          TabOrder = 28
          Visible = False
          WantReturns = False
          WordWrap = False
          AutoSize = False
          BlockNegative = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
          ShowCurrency = False
          TextId = 0
          Value = -0.666666
        end
        object I5VV8F: TCurrencyEdit
          Tag = 1
          Left = 171
          Top = 168
          Width = 88
          Height = 22
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Lines.Strings = (
            '0.67-')
          ParentFont = False
          ReadOnly = True
          TabOrder = 49
          Visible = False
          WantReturns = False
          WordWrap = False
          OnExit = I5VV1FExit
          AutoSize = False
          BlockNegative = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
          ShowCurrency = False
          TextId = 0
          Value = -0.666666
        end
        object I5Vr9F: Text8Pt
          Tag = 2
          Left = 2
          Top = 192
          Width = 65
          Height = 22
          TabStop = False
          AutoSize = False
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ReadOnly = True
          TabOrder = 8
          Visible = False
          TextId = 0
          ViaSBtn = False
        end
        object I5VG9F: TCurrencyEdit
          Tag = 2
          Left = 69
          Top = 192
          Width = 100
          Height = 22
          TabStop = False
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Lines.Strings = (
            '0.67-')
          ParentFont = False
          ReadOnly = True
          TabOrder = 29
          Visible = False
          WantReturns = False
          WordWrap = False
          AutoSize = False
          BlockNegative = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
          ShowCurrency = False
          TextId = 0
          Value = -0.666666
        end
        object I5VV9F: TCurrencyEdit
          Tag = 1
          Left = 171
          Top = 192
          Width = 88
          Height = 22
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Lines.Strings = (
            '0.67-')
          ParentFont = False
          ReadOnly = True
          TabOrder = 50
          Visible = False
          WantReturns = False
          WordWrap = False
          OnExit = I5VV1FExit
          AutoSize = False
          BlockNegative = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
          ShowCurrency = False
          TextId = 0
          Value = -0.666666
        end
        object I5Vr10F: Text8Pt
          Tag = 2
          Left = 2
          Top = 216
          Width = 65
          Height = 22
          TabStop = False
          AutoSize = False
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ReadOnly = True
          TabOrder = 9
          Visible = False
          TextId = 0
          ViaSBtn = False
        end
        object I5VG10F: TCurrencyEdit
          Tag = 2
          Left = 69
          Top = 216
          Width = 100
          Height = 22
          TabStop = False
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Lines.Strings = (
            '0.67-')
          ParentFont = False
          ReadOnly = True
          TabOrder = 30
          Visible = False
          WantReturns = False
          WordWrap = False
          AutoSize = False
          BlockNegative = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
          ShowCurrency = False
          TextId = 0
          Value = -0.666666
        end
        object I5VV10F: TCurrencyEdit
          Tag = 1
          Left = 171
          Top = 216
          Width = 88
          Height = 22
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Lines.Strings = (
            '0.67-')
          ParentFont = False
          ReadOnly = True
          TabOrder = 51
          Visible = False
          WantReturns = False
          WordWrap = False
          OnExit = I5VV1FExit
          AutoSize = False
          BlockNegative = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
          ShowCurrency = False
          TextId = 0
          Value = -0.666666
        end
        object I5Vr11F: Text8Pt
          Tag = 2
          Left = 2
          Top = 240
          Width = 65
          Height = 22
          TabStop = False
          AutoSize = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ReadOnly = True
          TabOrder = 10
          Visible = False
          TextId = 0
          ViaSBtn = False
        end
        object I5VG11F: TCurrencyEdit
          Tag = 2
          Left = 69
          Top = 240
          Width = 100
          Height = 22
          TabStop = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Lines.Strings = (
            '0.67-')
          ParentFont = False
          ReadOnly = True
          TabOrder = 31
          Visible = False
          WantReturns = False
          WordWrap = False
          AutoSize = False
          BlockNegative = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
          ShowCurrency = False
          TextId = 0
          Value = -0.666666
        end
        object I5VV11F: TCurrencyEdit
          Tag = 1
          Left = 171
          Top = 240
          Width = 88
          Height = 22
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Lines.Strings = (
            '0.67-')
          ParentFont = False
          ReadOnly = True
          TabOrder = 52
          Visible = False
          WantReturns = False
          WordWrap = False
          OnExit = I5VV1FExit
          AutoSize = False
          BlockNegative = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
          ShowCurrency = False
          TextId = 0
          Value = -0.666666
        end
        object I5VR12F: Text8Pt
          Tag = 2
          Left = 2
          Top = 264
          Width = 65
          Height = 22
          TabStop = False
          AutoSize = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ReadOnly = True
          TabOrder = 11
          Visible = False
          TextId = 0
          ViaSBtn = False
        end
        object I5VG12F: TCurrencyEdit
          Tag = 2
          Left = 69
          Top = 264
          Width = 100
          Height = 22
          TabStop = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Lines.Strings = (
            '0.67-')
          ParentFont = False
          ReadOnly = True
          TabOrder = 32
          Visible = False
          WantReturns = False
          WordWrap = False
          AutoSize = False
          BlockNegative = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
          ShowCurrency = False
          TextId = 0
          Value = -0.666666
        end
        object I5VV12F: TCurrencyEdit
          Tag = 1
          Left = 171
          Top = 264
          Width = 88
          Height = 22
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Lines.Strings = (
            '0.67-')
          ParentFont = False
          ReadOnly = True
          TabOrder = 53
          Visible = False
          WantReturns = False
          WordWrap = False
          OnExit = I5VV1FExit
          AutoSize = False
          BlockNegative = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
          ShowCurrency = False
          TextId = 0
          Value = -0.666666
        end
        object I5Vr13F: Text8Pt
          Tag = 2
          Left = 2
          Top = 288
          Width = 65
          Height = 22
          TabStop = False
          AutoSize = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ReadOnly = True
          TabOrder = 12
          Visible = False
          TextId = 0
          ViaSBtn = False
        end
        object I5VG13F: TCurrencyEdit
          Tag = 2
          Left = 69
          Top = 288
          Width = 100
          Height = 22
          TabStop = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Lines.Strings = (
            '0.67-')
          ParentFont = False
          ReadOnly = True
          TabOrder = 33
          Visible = False
          WantReturns = False
          WordWrap = False
          AutoSize = False
          BlockNegative = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
          ShowCurrency = False
          TextId = 0
          Value = -0.666666
        end
        object I5VV13F: TCurrencyEdit
          Tag = 1
          Left = 171
          Top = 288
          Width = 88
          Height = 22
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Lines.Strings = (
            '0.67-')
          ParentFont = False
          ReadOnly = True
          TabOrder = 54
          Visible = False
          WantReturns = False
          WordWrap = False
          OnExit = I5VV1FExit
          AutoSize = False
          BlockNegative = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
          ShowCurrency = False
          TextId = 0
          Value = -0.666666
        end
        object I5Vr14F: Text8Pt
          Tag = 2
          Left = 2
          Top = 312
          Width = 65
          Height = 22
          TabStop = False
          AutoSize = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ReadOnly = True
          TabOrder = 13
          Visible = False
          TextId = 0
          ViaSBtn = False
        end
        object I5VG14F: TCurrencyEdit
          Tag = 2
          Left = 69
          Top = 312
          Width = 100
          Height = 22
          TabStop = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Lines.Strings = (
            '0.67-')
          ParentFont = False
          ReadOnly = True
          TabOrder = 34
          Visible = False
          WantReturns = False
          WordWrap = False
          AutoSize = False
          BlockNegative = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
          ShowCurrency = False
          TextId = 0
          Value = -0.666666
        end
        object I5VV14F: TCurrencyEdit
          Tag = 1
          Left = 170
          Top = 312
          Width = 88
          Height = 22
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Lines.Strings = (
            '0.67-')
          ParentFont = False
          ReadOnly = True
          TabOrder = 55
          Visible = False
          WantReturns = False
          WordWrap = False
          OnExit = I5VV1FExit
          AutoSize = False
          BlockNegative = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
          ShowCurrency = False
          TextId = 0
          Value = -0.666666
        end
        object I5Vr15F: Text8Pt
          Tag = 2
          Left = 2
          Top = 336
          Width = 65
          Height = 22
          TabStop = False
          AutoSize = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ReadOnly = True
          TabOrder = 14
          Visible = False
          TextId = 0
          ViaSBtn = False
        end
        object I5VG15F: TCurrencyEdit
          Tag = 2
          Left = 69
          Top = 336
          Width = 100
          Height = 22
          TabStop = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Lines.Strings = (
            '0.67-')
          ParentFont = False
          ReadOnly = True
          TabOrder = 35
          Visible = False
          WantReturns = False
          WordWrap = False
          AutoSize = False
          BlockNegative = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
          ShowCurrency = False
          TextId = 0
          Value = -0.666666
        end
        object I5VV15F: TCurrencyEdit
          Tag = 1
          Left = 170
          Top = 336
          Width = 88
          Height = 22
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Lines.Strings = (
            '0.67-')
          ParentFont = False
          ReadOnly = True
          TabOrder = 56
          Visible = False
          WantReturns = False
          WordWrap = False
          OnExit = I5VV1FExit
          AutoSize = False
          BlockNegative = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
          ShowCurrency = False
          TextId = 0
          Value = -0.666666
        end
        object I5VV16F: TCurrencyEdit
          Tag = 1
          Left = 170
          Top = 360
          Width = 88
          Height = 22
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Lines.Strings = (
            '0.67-')
          ParentFont = False
          ReadOnly = True
          TabOrder = 57
          Visible = False
          WantReturns = False
          WordWrap = False
          OnExit = I5VV1FExit
          AutoSize = False
          BlockNegative = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
          ShowCurrency = False
          TextId = 0
          Value = -0.666666
        end
        object I5VG16F: TCurrencyEdit
          Tag = 2
          Left = 69
          Top = 360
          Width = 100
          Height = 22
          TabStop = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Lines.Strings = (
            '0.67-')
          ParentFont = False
          ReadOnly = True
          TabOrder = 36
          Visible = False
          WantReturns = False
          WordWrap = False
          AutoSize = False
          BlockNegative = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
          ShowCurrency = False
          TextId = 0
          Value = -0.666666
        end
        object I5Vr16F: Text8Pt
          Tag = 2
          Left = 2
          Top = 360
          Width = 65
          Height = 22
          TabStop = False
          AutoSize = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ReadOnly = True
          TabOrder = 15
          Visible = False
          TextId = 0
          ViaSBtn = False
        end
        object I5Vr17F: Text8Pt
          Tag = 2
          Left = 2
          Top = 384
          Width = 65
          Height = 22
          TabStop = False
          AutoSize = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ReadOnly = True
          TabOrder = 16
          Visible = False
          TextId = 0
          ViaSBtn = False
        end
        object I5VG17F: TCurrencyEdit
          Tag = 2
          Left = 69
          Top = 384
          Width = 100
          Height = 22
          TabStop = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Lines.Strings = (
            '0.67-')
          ParentFont = False
          ReadOnly = True
          TabOrder = 37
          Visible = False
          WantReturns = False
          WordWrap = False
          AutoSize = False
          BlockNegative = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
          ShowCurrency = False
          TextId = 0
          Value = -0.666666
        end
        object I5VV17F: TCurrencyEdit
          Tag = 1
          Left = 170
          Top = 384
          Width = 88
          Height = 22
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Lines.Strings = (
            '0.67-')
          ParentFont = False
          ReadOnly = True
          TabOrder = 58
          Visible = False
          WantReturns = False
          WordWrap = False
          OnExit = I5VV1FExit
          AutoSize = False
          BlockNegative = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
          ShowCurrency = False
          TextId = 0
          Value = -0.666666
        end
        object I5VV18F: TCurrencyEdit
          Tag = 1
          Left = 170
          Top = 408
          Width = 88
          Height = 22
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Lines.Strings = (
            '0.67-')
          ParentFont = False
          ReadOnly = True
          TabOrder = 59
          Visible = False
          WantReturns = False
          WordWrap = False
          OnExit = I5VV1FExit
          AutoSize = False
          BlockNegative = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
          ShowCurrency = False
          TextId = 0
          Value = -0.666666
        end
        object I5VG18F: TCurrencyEdit
          Tag = 2
          Left = 69
          Top = 408
          Width = 100
          Height = 22
          TabStop = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Lines.Strings = (
            '0.67-')
          ParentFont = False
          ReadOnly = True
          TabOrder = 38
          Visible = False
          WantReturns = False
          WordWrap = False
          AutoSize = False
          BlockNegative = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
          ShowCurrency = False
          TextId = 0
          Value = -0.666666
        end
        object I5Vr18F: Text8Pt
          Tag = 2
          Left = 2
          Top = 408
          Width = 65
          Height = 22
          TabStop = False
          AutoSize = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ReadOnly = True
          TabOrder = 17
          Visible = False
          TextId = 0
          ViaSBtn = False
        end
        object I5Vr19F: Text8Pt
          Tag = 2
          Left = 2
          Top = 431
          Width = 65
          Height = 22
          TabStop = False
          AutoSize = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ReadOnly = True
          TabOrder = 18
          Visible = False
          TextId = 0
          ViaSBtn = False
        end
        object I5VG19F: TCurrencyEdit
          Tag = 2
          Left = 69
          Top = 431
          Width = 100
          Height = 22
          TabStop = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Lines.Strings = (
            '0.67-')
          ParentFont = False
          ReadOnly = True
          TabOrder = 39
          Visible = False
          WantReturns = False
          WordWrap = False
          AutoSize = False
          BlockNegative = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
          ShowCurrency = False
          TextId = 0
          Value = -0.666666
        end
        object I5VV19F: TCurrencyEdit
          Tag = 1
          Left = 170
          Top = 431
          Width = 88
          Height = 22
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Lines.Strings = (
            '0.67-')
          ParentFont = False
          ReadOnly = True
          TabOrder = 60
          Visible = False
          WantReturns = False
          WordWrap = False
          OnExit = I5VV1FExit
          AutoSize = False
          BlockNegative = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
          ShowCurrency = False
          TextId = 0
          Value = -0.666666
        end
        object I5Vr20F: Text8Pt
          Tag = 2
          Left = 2
          Top = 455
          Width = 65
          Height = 22
          TabStop = False
          AutoSize = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ReadOnly = True
          TabOrder = 19
          Visible = False
          TextId = 0
          ViaSBtn = False
        end
        object I5VG20F: TCurrencyEdit
          Tag = 2
          Left = 69
          Top = 455
          Width = 100
          Height = 22
          TabStop = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Lines.Strings = (
            '0.67-')
          ParentFont = False
          ReadOnly = True
          TabOrder = 40
          Visible = False
          WantReturns = False
          WordWrap = False
          AutoSize = False
          BlockNegative = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
          ShowCurrency = False
          TextId = 0
          Value = -0.666666
        end
        object I5VV20F: TCurrencyEdit
          Tag = 1
          Left = 170
          Top = 455
          Width = 88
          Height = 22
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Lines.Strings = (
            '0.67-')
          ParentFont = False
          ReadOnly = True
          TabOrder = 61
          Visible = False
          WantReturns = False
          WordWrap = False
          OnExit = I5VV1FExit
          AutoSize = False
          BlockNegative = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
          ShowCurrency = False
          TextId = 0
          Value = -0.666666
        end
        object I5Vr21F: Text8Pt
          Tag = 2
          Left = 2
          Top = 478
          Width = 65
          Height = 22
          TabStop = False
          AutoSize = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ReadOnly = True
          TabOrder = 20
          Visible = False
          TextId = 0
          ViaSBtn = False
        end
        object I5VG21F: TCurrencyEdit
          Tag = 2
          Left = 69
          Top = 478
          Width = 100
          Height = 22
          TabStop = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Lines.Strings = (
            '0.67-')
          ParentFont = False
          ReadOnly = True
          TabOrder = 41
          Visible = False
          WantReturns = False
          WordWrap = False
          AutoSize = False
          BlockNegative = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
          ShowCurrency = False
          TextId = 0
          Value = -0.666666
        end
        object I5VV21F: TCurrencyEdit
          Tag = 1
          Left = 170
          Top = 478
          Width = 88
          Height = 22
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Lines.Strings = (
            '0.67-')
          ParentFont = False
          ReadOnly = True
          TabOrder = 62
          Visible = False
          WantReturns = False
          WordWrap = False
          OnExit = I5VV1FExit
          AutoSize = False
          BlockNegative = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
          ShowCurrency = False
          TextId = 0
          Value = -0.666666
        end
      end
      object I5MVATF: TBorCheck
        Tag = 1
        Left = 10
        Top = 15
        Width = 131
        Height = 20
        HelpContext = 285
        Caption = ' Content Amended'
        CheckColor = clWindowText
        Color = clBtnFace
        Enabled = False
        ParentColor = False
        TabOrder = 1
        TabStop = True
        TextId = 0
        OnClick = I5MVATFClick
      end
      object I5SDPF: TCurrencyEdit
        Tag = 1
        Left = 398
        Top = 145
        Width = 63
        Height = 22
        HelpContext = 288
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          '-0.67')
        ParentFont = False
        ReadOnly = True
        TabOrder = 9
        WantReturns = False
        WordWrap = False
        OnExit = I5SDPFExit
        AutoSize = False
        BlockNegative = False
        BlankOnZero = False
        DisplayFormat = ' 0.00%;-0.00'
        ShowCurrency = False
        TextId = 0
        Value = -0.666666
      end
      object I5SDDF: TCurrencyEdit
        Tag = 1
        Left = 492
        Top = 145
        Width = 46
        Height = 22
        HelpContext = 288
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          '1-')
        ParentFont = False
        ReadOnly = True
        TabOrder = 10
        WantReturns = False
        WordWrap = False
        AutoSize = False
        BlockNegative = False
        BlankOnZero = False
        DisplayFormat = '###,###,##0 ;###,###,##0-'
        DecPlaces = 0
        ShowCurrency = False
        TextId = 0
        Value = -0.666666
      end
      object I5Net1F: TCurrencyEdit
        Tag = 2
        Left = 358
        Top = 201
        Width = 100
        Height = 22
        HelpContext = 252
        TabStop = False
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          '0.67-')
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
        Value = -0.666666
      end
      object I5VAT1F: TCurrencyEdit
        Tag = 2
        Left = 358
        Top = 228
        Width = 100
        Height = 22
        HelpContext = 252
        TabStop = False
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          '0.67-')
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
        Value = -0.666666
      end
      object I5Disc1F: TCurrencyEdit
        Tag = 2
        Left = 358
        Top = 255
        Width = 100
        Height = 22
        HelpContext = 252
        TabStop = False
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          '0.67-')
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
        Value = -0.666666
      end
      object I5Tot1F: TCurrencyEdit
        Tag = 2
        Left = 358
        Top = 282
        Width = 100
        Height = 22
        HelpContext = 252
        TabStop = False
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          '0.67-')
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
        Value = -0.666666
      end
      object I5Net2F: TCurrencyEdit
        Tag = 2
        Left = 514
        Top = 201
        Width = 100
        Height = 22
        HelpContext = 252
        TabStop = False
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          '0.67-')
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
        Value = -0.666666
      end
      object I5VAT2F: TCurrencyEdit
        Tag = 2
        Left = 514
        Top = 228
        Width = 100
        Height = 22
        HelpContext = 252
        TabStop = False
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          '0.67-')
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
        Value = -0.666666
      end
      object I5Disc2F: TCurrencyEdit
        Tag = 2
        Left = 514
        Top = 255
        Width = 100
        Height = 22
        HelpContext = 252
        TabStop = False
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          '0.67-')
        ParentFont = False
        ReadOnly = True
        TabOrder = 20
        WantReturns = False
        WordWrap = False
        AutoSize = False
        BlockNegative = False
        BlankOnZero = False
        DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
        ShowCurrency = False
        TextId = 0
        Value = -0.666666
      end
      object I5Tot2F: TCurrencyEdit
        Tag = 2
        Left = 514
        Top = 282
        Width = 100
        Height = 22
        HelpContext = 252
        TabStop = False
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          '0.67-')
        ParentFont = False
        ReadOnly = True
        TabOrder = 21
        WantReturns = False
        WordWrap = False
        AutoSize = False
        BlockNegative = False
        BlankOnZero = False
        DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
        ShowCurrency = False
        TextId = 0
        Value = -0.666666
      end
      object SBSPanel62: TSBSPanel
        Left = 315
        Top = 175
        Width = 142
        Height = 17
        Caption = 'SBSPanel62'
        TabOrder = 12
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        object Label13: TLabel
          Left = 19
          Top = 2
          Width = 115
          Height = 14
          Alignment = taRightJustify
          Caption = 'S.Discount Not Taken'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
      end
      object SBSPanel63: TSBSPanel
        Left = 465
        Top = 175
        Width = 147
        Height = 17
        TabOrder = 17
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        object Label21: TLabel
          Left = 46
          Top = 2
          Width = 94
          Height = 14
          Alignment = taRightJustify
          Caption = 'S.Discount Taken'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
      end
      object DMDCNomF: Text8Pt
        Tag = 1
        Left = 218
        Top = 15
        Width = 65
        Height = 22
        HelpContext = 551
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 10
        ParentFont = False
        ReadOnly = True
        TabOrder = 2
        TextId = 0
        ViaSBtn = False
      end
      object I5VRateF: TCurrencyEdit
        Tag = 1
        Left = 199
        Top = 40
        Width = 84
        Height = 22
        HelpContext = 763
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          '0.000000 ')
        ParentFont = False
        ReadOnly = True
        TabOrder = 3
        Visible = False
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
      object CanI5Btn: TButton
        Tag = 1
        Left = 524
        Top = 27
        Width = 80
        Height = 21
        HelpContext = 258
        Cancel = True
        Caption = '&Cancel'
        Enabled = False
        ModalResult = 2
        TabOrder = 23
        OnClick = ClsN1BtnClick
      end
      object ClsI5Btn: TButton
        Left = 524
        Top = 50
        Width = 80
        Height = 21
        HelpContext = 259
        Cancel = True
        Caption = 'C&lose'
        ModalResult = 2
        TabOrder = 24
        OnClick = ClsN1BtnClick
      end
      object OkI5Btn: TButton
        Tag = 1
        Left = 524
        Top = 4
        Width = 80
        Height = 21
        HelpContext = 257
        Caption = '&OK'
        Enabled = False
        ModalResult = 1
        TabOrder = 22
        OnClick = OkN1BtnClick
      end
      object I5SDTF: TBorCheck
        Tag = 1
        Left = 545
        Top = 144
        Width = 52
        Height = 20
        HelpContext = 288
        Caption = 'Taken'
        CheckColor = clWindowText
        Color = clBtnFace
        Enabled = False
        ParentColor = False
        TabOrder = 11
        TabStop = True
        TextId = 0
      end
      object ccyTotalsTotal: TCurrencyEdit
        Tag = 2
        Left = 365
        Top = 95
        Width = 96
        Height = 22
        HelpContext = 287
        TabStop = False
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          '0.67-')
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
        Value = -0.666666
      end
      object ccyTotalsDiscount: TCurrencyEdit
        Tag = 2
        Left = 365
        Top = 69
        Width = 96
        Height = 22
        HelpContext = 287
        TabStop = False
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          '0.67-')
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
        Value = -0.666666
      end
      object ccyTotalsVAT: TCurrencyEdit
        Tag = 2
        Left = 365
        Top = 43
        Width = 96
        Height = 22
        HelpContext = 287
        TabStop = False
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          '0.67-')
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
        Value = -0.666666
      end
      object ccyTotalsNet: TCurrencyEdit
        Tag = 2
        Left = 365
        Top = 17
        Width = 96
        Height = 22
        HelpContext = 287
        TabStop = False
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          '0.67-')
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
        Value = -0.666666
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Receipt'
      ImageIndex = 4
      object SBSBackGroup2: TSBSBackGroup
        Left = 12
        Top = 108
        Width = 417
        Height = 231
        Caption = 'Certified Receipt Details:-'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = []
        TextId = 0
      end
      object Bevel2: TBevel
        Left = 6
        Top = 94
        Width = 509
        Height = 3
      end
      object Label810: Label8
        Left = 52
        Top = 297
        Width = 76
        Height = 14
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Amount : '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label815: Label8
        Left = 70
        Top = 210
        Width = 59
        Height = 14
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'CC/Dept : '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object PILab: Label8
        Left = 44
        Top = 269
        Width = 85
        Height = 14
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Pay-In Ref : '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label816: Label8
        Left = 42
        Top = 239
        Width = 87
        Height = 14
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Cheque No. : '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label819: Label8
        Left = 63
        Top = 181
        Width = 65
        Height = 14
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'G/L Code : '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label7: TLabel
        Left = 243
        Top = 295
        Width = 62
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Cert. Total'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label87: Label8
        Left = 229
        Top = 210
        Width = 59
        Height = 14
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Analysis : '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object cbPayAppsF: TBorCheckEx
        Left = 24
        Top = 152
        Width = 119
        Height = 20
        Caption = 'Generate Receipt : '
        Color = clBtnFace
        ParentColor = False
        TabOrder = 0
        TextId = 0
      end
      object PINAF: Text8Pt
        Tag = 1
        Left = 130
        Top = 177
        Width = 73
        Height = 22
        HelpContext = 410
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
      object PICQF: Text8Pt
        Tag = 1
        Left = 130
        Top = 235
        Width = 107
        Height = 22
        HelpContext = 412
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
        TabOrder = 5
        TextId = 0
        ViaSBtn = False
      end
      object PIPIF: Text8Pt
        Tag = 1
        Left = 130
        Top = 263
        Width = 107
        Height = 22
        HelpContext = 413
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 16
        ParentFont = False
        ParentShowHint = False
        ReadOnly = True
        ShowHint = True
        TabOrder = 6
        TextId = 0
        ViaSBtn = False
      end
      object PICCF: Text8Pt
        Tag = 1
        Left = 130
        Top = 206
        Width = 47
        Height = 22
        HelpContext = 414
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
        TextId = 0
        ViaSBtn = False
      end
      object PIDepF: Text8Pt
        Tag = 1
        Left = 178
        Top = 206
        Width = 47
        Height = 22
        HelpContext = 414
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
        TextId = 0
        ViaSBtn = False
      end
      object PIAmtF: TCurrencyEdit
        Tag = 1
        Left = 130
        Top = 291
        Width = 107
        Height = 22
        HelpContext = 416
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
      object PINDF: Text8Pt
        Left = 210
        Top = 177
        Width = 199
        Height = 22
        HelpContext = 417
        TabStop = False
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
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
      object I5Tot3F: TCurrencyEdit
        Left = 309
        Top = 292
        Width = 100
        Height = 22
        HelpContext = 252
        TabStop = False
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          '0.67-')
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
        Value = -0.666666
      end
      object PIJAF: Text8Pt
        Tag = 1
        Left = 290
        Top = 206
        Width = 120
        Height = 22
        HelpContext = 466
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
        TabOrder = 4
        TextId = 0
        ViaSBtn = False
      end
    end
    object NotesPage: TTabSheet
      HelpContext = 438
      Caption = 'Notes'
      object Label81: Label8
        Left = 17
        Top = 36
        Width = 22
        Height = 14
        Caption = 'Date'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label82: Label8
        Left = 14
        Top = 9
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
      object Label83: Label8
        Left = 204
        Top = 9
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
      object Label85: Label8
        Left = 211
        Top = 37
        Width = 31
        Height = 14
        Caption = 'Per/Yr'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label86: Label8
        Left = 338
        Top = 9
        Width = 68
        Height = 14
        Caption = 'Last edited by'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object TCNScrollBox: TScrollBox
        Left = 0
        Top = 97
        Width = 497
        Height = 234
        VertScrollBar.Visible = False
        TabOrder = 0
        object TNHedPanel: TSBSPanel
          Left = 3
          Top = 2
          Width = 487
          Height = 17
          BevelInner = bvLowered
          BevelOuter = bvNone
          TabOrder = 0
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
          object NDateLab: TSBSPanel
            Left = 2
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
            TabOrder = 0
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object NDescLab: TSBSPanel
            Left = 67
            Top = 1
            Width = 345
            Height = 13
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
            Left = 417
            Top = 1
            Width = 65
            Height = 13
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
          Left = 5
          Top = 22
          Width = 67
          Height = 195
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = ANSI_CHARSET
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
          Left = 74
          Top = 22
          Width = 344
          Height = 195
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = ANSI_CHARSET
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
          Left = 420
          Top = 22
          Width = 70
          Height = 195
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = ANSI_CHARSET
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
        Left = 502
        Top = 123
        Width = 18
        Height = 192
        BevelOuter = bvLowered
        TabOrder = 1
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
      end
    end
  end
  object A1FPanel: TSBSPanel
    Left = 1
    Top = 24
    Width = 626
    Height = 89
    BevelOuter = bvNone
    PopupMenu = PopupMenu1
    TabOrder = 2
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
    object Label84: Label8
      Left = 183
      Top = 36
      Width = 22
      Height = 14
      Caption = 'Date'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object I1CurrLab: Label8
      Left = 445
      Top = 36
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
    object lblAcCode: Label8
      Left = 4
      Top = 10
      Width = 18
      Height = 14
      Caption = 'A/C'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object I1ExLab: Label8
      Left = 453
      Top = 62
      Width = 37
      Height = 14
      Caption = 'Ex.Rate'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Label89: Label8
      Left = 309
      Top = 11
      Width = 31
      Height = 14
      Caption = 'Per/Yr'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Label817: Label8
      Left = 452
      Top = 10
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
    object I1DelBtn: TSpeedButton
      Left = 576
      Top = 59
      Width = 45
      Height = 22
      Hint = 'Edit Delivery Address|Displays the Delivery address box.'
      Caption = 'Deli&very'
      OnClick = I1DelBtnClick
    end
    object I1DueDateL: Label8
      Left = 186
      Top = 62
      Width = 19
      Height = 14
      Caption = 'Stat'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object SBSAccelLabel1: TSBSAccelLabel
      Left = 578
      Top = 44
      Width = 42
      Height = 14
      AccelChars = 'V'
    end
    object A1ORefF: Text8Pt
      Left = 491
      Top = 6
      Width = 78
      Height = 22
      HelpContext = 142
      TabStop = False
      Color = clBtnFace
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
      Text = 'SRC000080'
      TextId = 0
      ViaSBtn = False
    end
    object A1OpoF: Text8Pt
      Left = 572
      Top = 6
      Width = 51
      Height = 22
      HelpContext = 241
      TabStop = False
      Color = clBtnFace
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 1
      Text = 'Sally'
      TextId = 0
      ViaSBtn = False
    end
    object I1AccF: Text8Pt
      Tag = 1
      Left = 25
      Top = 7
      Width = 263
      Height = 22
      Hint = 
        'Double click to drill down|Double clicking or using the down but' +
        'ton will drill down to the record for this field. The up button ' +
        'will search for the nearest match.'
      HelpContext = 238
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 2
      OnDblClick = I1AddrFDblClick
      OnExit = I1AccFExit
      TextId = 0
      ViaSBtn = False
      ShowHilight = True
    end
    object A1TDateF: TEditDate
      Tag = 1
      Left = 209
      Top = 33
      Width = 79
      Height = 22
      HelpContext = 143
      AutoSelect = False
      Color = clWhite
      EditMask = '00/00/0000;0;'
      Font.Charset = ANSI_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      MaxLength = 10
      ParentFont = False
      ReadOnly = True
      TabOrder = 3
      OnExit = A1TDateFExit
      Placement = cpAbove
    end
    object I1EXRateF: TCurrencyEdit
      Tag = 1
      Left = 491
      Top = 59
      Width = 78
      Height = 22
      HelpContext = 242
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        '0.000000 ')
      ParentFont = False
      ReadOnly = True
      TabOrder = 9
      WantReturns = False
      WordWrap = False
      OnEnter = I1EXRateFEnter
      AutoSize = False
      BlockNegative = False
      BlankOnZero = False
      DisplayFormat = '###,###,##0.000000 ;###,###,##0.000000-'
      DecPlaces = 6
      ShowCurrency = False
      TextId = 0
      Value = 1E-10
    end
    object A1TPerF: TEditPeriod
      Tag = 1
      Left = 343
      Top = 7
      Width = 80
      Height = 22
      HelpContext = 239
      AutoSelect = False
      Color = clWhite
      EditMask = '00/0000;0;'
      Font.Charset = ANSI_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      MaxLength = 7
      ParentFont = False
      ReadOnly = True
      TabOrder = 5
      Text = '011996'
      OnExit = A1TPerFExit
      Placement = cpAbove
      EPeriod = 1
      EYear = 96
      ViewMask = '000/0000;0;'
      OnConvDate = A1TPerFConvDate
      OnShowPeriod = A1TPerFShowPeriod
    end
    object I1CurrF: TSBSComboBox
      Tag = 1
      Left = 491
      Top = 33
      Width = 78
      Height = 22
      HelpContext = 242
      Style = csDropDownList
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ItemHeight = 14
      MaxLength = 3
      ParentFont = False
      TabOrder = 7
      OnExit = I1CurrFExit
      ExtendedList = True
      MaxListWidth = 90
      ReadOnly = True
      Validate = True
    end
    object I1DumPanel: TSBSPanel
      Left = 576
      Top = 36
      Width = 0
      Height = 0
      BevelOuter = bvNone
      Enabled = False
      TabOrder = 10
      Visible = False
      AllowReSize = False
      IsGroupBox = False
      TextId = 0
    end
    object FixXRF: TBorCheck
      Tag = 1
      Left = 572
      Top = 35
      Width = 50
      Height = 20
      HelpContext = 1171
      Caption = 'Fixed'
      Color = clBtnFace
      ParentColor = False
      TabOrder = 8
      TabStop = True
      TextId = 0
      Visible = False
    end
    object I1StatCB1: TSBSComboBox
      Tag = 1
      Left = 209
      Top = 59
      Width = 79
      Height = 22
      HelpContext = 1456
      Style = csDropDownList
      Color = clWhite
      DropDownCount = 10
      Font.Charset = ANSI_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ItemHeight = 14
      MaxLength = 3
      ParentFont = False
      TabOrder = 4
      OnDropDown = I1StatCB1DropDown
      OnEnter = I1StatCB1Enter
      OnExit = I1CurrFExit
      ExtendedList = True
      MaxListWidth = 250
      ReadOnly = True
      Validate = True
    end
    object I1AddrF: TMemo
      Left = 3
      Top = 33
      Width = 175
      Height = 48
      Hint = 
        'Double click to drill down|Double clicking will drill down to th' +
        'e main record for this field.'
      HelpContext = 230
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 11
      WantReturns = False
      OnDblClick = I1AddrFDblClick
    end
    object TransExtForm1: TSBSExtendedForm
      Left = 288
      Top = 29
      Width = 156
      Height = 55
      HelpContext = 1169
      HorzScrollBar.Visible = False
      VertScrollBar.Visible = False
      AutoScroll = False
      BorderStyle = bsNone
      TabOrder = 6
      OnEnter = TransExtForm1Enter
      OnExit = TransExtForm1Exit
      OnResize = TransExtForm1Resize
      ArrowPos = alNone
      OrigHeight = 55
      OrigWidth = 156
      ExpandedWidth = 305
      ExpandedHeight = 212
      OrigTabOrder = 6
      ShowHorzSB = True
      ShowVertSB = True
      OrigParent = A1FPanel
      NewParent = Owner
      FocusFirst = A1YRefF
      FocusLast = THUD10F
      TabPrev = A1TPerF
      TabNext = I1CurrF
      object I1YrRefL: Label8
        Left = 9
        Top = 8
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
      object I1YrRef2L: Label8
        Left = 17
        Top = 33
        Width = 36
        Height = 14
        Caption = 'Alt. Ref'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object UDF1L: Label8
        Left = 2
        Top = 69
        Width = 59
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
        Left = 2
        Top = 93
        Width = 59
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
        Left = 150
        Top = 69
        Width = 63
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
        Left = 150
        Top = 93
        Width = 63
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
      object Bevel1: TBevel
        Left = 7
        Top = 58
        Width = 290
        Height = 2
      end
      object I5NBL: Label8
        Left = 175
        Top = 33
        Width = 54
        Height = 14
        Caption = 'Box Labels'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Visible = False
        TextId = 0
      end
      object UDF5L: Label8
        Left = 2
        Top = 117
        Width = 59
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
      object UDF7L: Label8
        Left = 2
        Top = 141
        Width = 59
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
        Left = 2
        Top = 165
        Width = 59
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
      object UDF6L: Label8
        Left = 150
        Top = 117
        Width = 63
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
      object UDF8L: Label8
        Left = 150
        Top = 141
        Width = 63
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
        Left = 150
        Top = 165
        Width = 63
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
      object UDF11L: Label8
        Left = 2
        Top = 189
        Width = 59
        Height = 14
        AutoSize = False
        Caption = 'UD Field 11'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object UDF12L: Label8
        Left = 150
        Top = 189
        Width = 63
        Height = 14
        AutoSize = False
        Caption = 'UD Field 12'
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
        Left = 59
        Top = 65
        Width = 86
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
        OnExit = THUD1FExit
        TextId = 0
        ViaSBtn = False
        OnEntHookEvent = THUD1FEntHookEvent
      end
      object THUD3F: Text8Pt
        Tag = 1
        Left = 59
        Top = 89
        Width = 86
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
        OnExit = THUD1FExit
        TextId = 0
        ViaSBtn = False
        OnEntHookEvent = THUD1FEntHookEvent
      end
      object THUD4F: Text8Pt
        Tag = 1
        Left = 214
        Top = 89
        Width = 87
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
        OnExit = THUD1FExit
        TextId = 0
        ViaSBtn = False
        OnEntHookEvent = THUD1FEntHookEvent
      end
      object THUD2F: Text8Pt
        Tag = 1
        Left = 214
        Top = 65
        Width = 87
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
        OnExit = THUD1FExit
        TextId = 0
        ViaSBtn = False
        OnEntHookEvent = THUD1FEntHookEvent
      end
      object A1YRefF: Text8Pt
        Tag = 1
        Left = 55
        Top = 4
        Width = 90
        Height = 22
        HelpContext = 148
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        TabOrder = 0
        OnChange = A1YRefFChange
        OnEnter = A1YRefFEnter
        OnExit = THUD1FExit
        TextId = 0
        ViaSBtn = False
        OnEntHookEvent = THUD1FEntHookEvent
      end
      object I1YrRef2F: Text8Pt
        Tag = 1
        Left = 55
        Top = 30
        Width = 90
        Height = 22
        HelpContext = 240
        CharCase = ecUpperCase
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        TabOrder = 1
        OnChange = I1YrRef2FChange
        OnEnter = I1YrRef2FEnter
        OnExit = THUD1FExit
        TextId = 0
        ViaSBtn = False
        OnEntHookEvent = THUD1FEntHookEvent
      end
      object I5NBF: TCurrencyEdit
        Tag = 1
        Left = 234
        Top = 29
        Width = 56
        Height = 22
        HelpContext = 472
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          '1-')
        ParentFont = False
        ReadOnly = True
        TabOrder = 2
        Visible = False
        WantReturns = False
        WordWrap = False
        AutoSize = False
        BlockNegative = False
        BlankOnZero = False
        DisplayFormat = '###,###,##0 ;###,###,##0-'
        DecPlaces = 0
        ShowCurrency = False
        TextId = 0
        Value = -0.666666
      end
      object THUD5F: Text8Pt
        Tag = 1
        Left = 59
        Top = 113
        Width = 86
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
        OnExit = THUD1FExit
        TextId = 0
        ViaSBtn = False
        OnEntHookEvent = THUD1FEntHookEvent
      end
      object THUD7F: Text8Pt
        Tag = 1
        Left = 59
        Top = 137
        Width = 86
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
        OnExit = THUD1FExit
        TextId = 0
        ViaSBtn = False
        OnEntHookEvent = THUD1FEntHookEvent
      end
      object THUD9F: Text8Pt
        Tag = 1
        Left = 59
        Top = 161
        Width = 86
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
        OnExit = THUD1FExit
        TextId = 0
        ViaSBtn = False
        OnEntHookEvent = THUD1FEntHookEvent
      end
      object THUD6F: Text8Pt
        Tag = 1
        Left = 214
        Top = 113
        Width = 87
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
        OnExit = THUD1FExit
        TextId = 0
        ViaSBtn = False
        OnEntHookEvent = THUD1FEntHookEvent
      end
      object THUD8F: Text8Pt
        Tag = 1
        Left = 214
        Top = 137
        Width = 87
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
        OnExit = THUD1FExit
        TextId = 0
        ViaSBtn = False
        OnEntHookEvent = THUD1FEntHookEvent
      end
      object THUD10F: Text8Pt
        Tag = 1
        Left = 214
        Top = 161
        Width = 87
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
        TabOrder = 12
        OnExit = THUD1FExit
        TextId = 0
        ViaSBtn = False
        OnEntHookEvent = THUD1FEntHookEvent
      end
      object THUD11F: Text8Pt
        Tag = 1
        Left = 59
        Top = 185
        Width = 86
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
        TabOrder = 13
        OnExit = THUD1FExit
        TextId = 0
        ViaSBtn = False
        OnEntHookEvent = THUD1FEntHookEvent
      end
      object THUD12F: Text8Pt
        Tag = 1
        Left = 214
        Top = 185
        Width = 87
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
        TabOrder = 14
        OnExit = THUD1FExit
        TextId = 0
        ViaSBtn = False
        OnEntHookEvent = THUD1FEntHookEvent
      end
    end
  end
  object A1BtnPanel: TSBSPanel
    Left = 524
    Top = 112
    Width = 100
    Height = 236
    BevelOuter = bvNone
    TabOrder = 1
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
    object Shape1: TShape
      Left = 0
      Top = 0
      Width = 65
      Height = 65
      Pen.Style = psClear
      Visible = False
    end
    object A1StatLab: Label8
      Left = 9
      Top = 8
      Width = 84
      Height = 17
      Alignment = taCenter
      AutoSize = False
      Caption = 'A1StatLab'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object OkN1Btn: TButton
      Tag = 1
      Left = 2
      Top = 2
      Width = 80
      Height = 21
      HelpContext = 257
      Caption = '&OK'
      Enabled = False
      ModalResult = 1
      TabOrder = 0
      OnClick = OkN1BtnClick
    end
    object CanN1Btn: TButton
      Tag = 1
      Left = 2
      Top = 25
      Width = 80
      Height = 21
      HelpContext = 258
      Cancel = True
      Caption = '&Cancel'
      Enabled = False
      ModalResult = 2
      TabOrder = 1
      OnClick = ClsN1BtnClick
    end
    object ClsN1Btn: TButton
      Left = 2
      Top = 49
      Width = 80
      Height = 21
      HelpContext = 259
      Cancel = True
      Caption = 'C&lose'
      ModalResult = 2
      TabOrder = 2
      OnClick = ClsN1BtnClick
    end
    object A1BSBox: TScrollBox
      Left = 1
      Top = 80
      Width = 97
      Height = 151
      HorzScrollBar.Tracking = True
      HorzScrollBar.Visible = False
      VertScrollBar.Tracking = True
      BorderStyle = bsNone
      Color = clBtnFace
      ParentColor = False
      TabOrder = 3
      object AddN1Btn: TButton
        Left = 2
        Top = 1
        Width = 80
        Height = 21
        Hint = 
          'Add new line|Choosing this option allows you to Add a new line w' +
          'hich will be placed at the end of the document.'
        HelpContext = 1617
        Caption = '&Add'
        Enabled = False
        TabOrder = 0
        OnClick = AddN1BtnClick
      end
      object EditN1Btn: TButton
        Left = 2
        Top = 25
        Width = 80
        Height = 21
        Hint = 
          'Edit current line|Choosing this option allows you to edit the cu' +
          'rrently highlighted line.'
        HelpContext = 1617
        Caption = '&Edit'
        Enabled = False
        TabOrder = 1
        OnClick = AddN1BtnClick
      end
      object DelN1Btn: TButton
        Left = 2
        Top = 49
        Width = 80
        Height = 21
        Hint = 
          'Delete current line|Choosing this option allows you to delete th' +
          'e currently highlighted line.'
        HelpContext = 263
        Caption = '&Delete'
        Enabled = False
        TabOrder = 2
        OnClick = DelN1BtnClick
      end
      object InsN1Btn: TButton
        Left = 2
        Top = 73
        Width = 80
        Height = 21
        Hint = 
          'Insert new line|Choosing this option allows you to Insert a new ' +
          'line before the currently highlighted line.'
        HelpContext = 1617
        Caption = '&Insert'
        TabOrder = 3
        OnClick = AddN1BtnClick
      end
      object SwiN1Btn: TButton
        Left = 2
        Top = 121
        Width = 80
        Height = 21
        Hint = 
          'Switch between alternative notepads|Switches the display of the ' +
          'notepad between dated notepad, & general notepad.'
        HelpContext = 90
        Caption = '&Switch To'
        TabOrder = 5
        OnClick = SwiN1BtnClick
      end
      object LnkN1Btn: TButton
        Left = 2
        Top = 242
        Width = 80
        Height = 21
        Hint = 
          'Link to additional information|Displays a list of any additional' +
          ' information attached to this transaction.'
        HelpContext = 81
        Caption = 'Lin&ks'
        TabOrder = 10
        OnClick = LnkN1BtnClick
      end
      object ChkBtn: TButton
        Left = 2
        Top = 217
        Width = 80
        Height = 21
        Hint = 
          'Recalculate total|Choosing this option will recalculate the tota' +
          'l in cases where the total does not agree with the sum of the in' +
          'dividual entries.'
        HelpContext = 40013
        Caption = '&Check'
        TabOrder = 9
        OnClick = ChkBtnClick
      end
      object APickI1Btn: TButton
        Left = 2
        Top = 145
        Width = 80
        Height = 21
        HelpContext = 1618
        Caption = 'A&uto'
        TabOrder = 6
        OnClick = APickI1BtnClick
      end
      object WORI1Btn: TButton
        Left = 2
        Top = 169
        Width = 80
        Height = 21
        Hint = 
          'Generate a Purchase Return|Generate a Purchase Return from the c' +
          'urrently highlighted line.'
        Caption = '&Return'
        TabOrder = 7
        OnClick = WORI1BtnClick
      end
      object MatI1Btn: TButton
        Left = 2
        Top = 193
        Width = 80
        Height = 21
        Hint = 
          'Match transaction details|Displays any matching information for ' +
          'the currently highlighted line.'
        HelpContext = 1308
        Caption = '&Match'
        Enabled = False
        TabOrder = 8
      end
      object FindN1Btn: TButton
        Left = 2
        Top = 97
        Width = 80
        Height = 21
        Hint = 
          'Find Stock Item|Choosing this option allows you to find the next' +
          ' line containing the specified stock code.'
        HelpContext = 165
        Caption = '&Find'
        Enabled = False
        TabOrder = 4
        OnClick = FindN1BtnClick
      end
    end
  end
  object pnlAnonymisationStatus: TPanel
    Left = -16
    Top = 377
    Width = 660
    Height = 42
    BevelOuter = bvNone
    TabOrder = 3
    Visible = False
    object shpNotifyStatus: TShape
      Left = 5
      Top = 0
      Width = 652
      Height = 38
      Brush.Color = clRed
      Shape = stRoundRect
    end
    object lblAnonStatus: TLabel
      Left = 215
      Top = 7
      Width = 240
      Height = 24
      Alignment = taCenter
      Caption = 'Anonymised 30/09/2017'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -21
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
  end
  object PopupMenu1: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 470
    object Add1: TMenuItem
      Caption = '&Add'
      Hint = 
        'Choosing this option allows you to Add a new line which will be ' +
        'placed at the end of the adjustment.'
      OnClick = AddN1BtnClick
    end
    object Edit1: TMenuItem
      Tag = 1
      Caption = '&Edit'
      Hint = 
        'Choosing this option allows you to edit the currently highlighte' +
        'd line.'
      Visible = False
      OnClick = AddN1BtnClick
    end
    object Delete1: TMenuItem
      Caption = '&Delete'
      Hint = 
        'Choosing this option allows you to delete the currently highligh' +
        'ted line.'
      OnClick = DelN1BtnClick
    end
    object Insert1: TMenuItem
      Caption = '&Insert'
      Hint = 
        'Choosing this option allows you to Insert a new line before the ' +
        'currently highlighted line.'
      OnClick = AddN1BtnClick
    end
    object Find1: TMenuItem
      Caption = '&Find'
      OnClick = FindN1BtnClick
    end
    object Switch1: TMenuItem
      Caption = '&Switch'
      Hint = 
        'Switches the display of the notepad between dated notepad, & gen' +
        'eral notepad.'
      OnClick = SwiN1BtnClick
    end
    object AutoPick1: TMenuItem
      Caption = 'A&uto'
      OnClick = APickI1BtnClick
    end
    object WorksOrder1: TMenuItem
      Caption = '&Return'
      OnClick = WORI1BtnClick
    end
    object Match1: TMenuItem
      Caption = '&Match'
    end
    object Check1: TMenuItem
      Caption = '&Check'
      OnClick = ChkBtnClick
    end
    object Links1: TMenuItem
      Caption = 'Lin&ks'
      Hint = 
        'Displays a list of any additional information attached to this t' +
        'ransaction.'
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
    Left = 426
    object AP1: TMenuItem
      Tag = 1
      Caption = '&Return'
      HelpContext = 1618
      Hint = 
        'Automaticaly Returns any outstanding lines, excluding any serial' +
        ' items'
      OnClick = AP1Click
    end
    object Ap2: TMenuItem
      Tag = 2
      Caption = 'Return with &Serial Nos'
      HelpContext = 1618
      Hint = 
        'Automaticaly returns any outstanding lines, including any serial' +
        ' items'
      OnClick = AP1Click
    end
    object AR1: TMenuItem
      Tag = 11
      Caption = 'U&ndo Return'
      HelpContext = 1618
      Hint = 'Automaticaly resets any currently Returned lines.'
      OnClick = AP1Click
    end
    object AR2: TMenuItem
      Tag = 12
      Caption = 'Un&do Return with Serial Nos'
      HelpContext = 1618
      Hint = 'Automaticaly resets any currently Returned lines.'
      OnClick = AP1Click
    end
    object N6: TMenuItem
      Caption = '-'
      HelpContext = 1618
    end
    object Rep1: TMenuItem
      Tag = 3
      Caption = 'R&epair'
      HelpContext = 1618
      Hint = 
        'Automaticaly sets the Repair qty on any outstanding lines, exclu' +
        'ding any serial items'
      OnClick = AP1Click
    end
    object Rep2: TMenuItem
      Tag = 4
      Caption = '&Re&pair with Serial Nos'
      HelpContext = 1618
      Hint = 
        'Automaticaly sets the Repair qty on any outstanding lines, inclu' +
        'ding any serial items'
      OnClick = AP1Click
    end
    object AW1: TMenuItem
      Tag = 13
      Caption = '&Undo Repair'
      HelpContext = 1618
      Hint = 'Automaticaly resets any currently Repaired lines.'
      OnClick = AP1Click
    end
    object AW2: TMenuItem
      Tag = 14
      Caption = 'Un&do Repair with Serial Nos'
      HelpContext = 1618
      Hint = 'Automaticaly resets any currently Repaired lines.'
      OnClick = AP1Click
    end
    object N4: TMenuItem
      Caption = '-'
      HelpContext = 1618
    end
    object WO1: TMenuItem
      Tag = 5
      Caption = '&Write Off'
      HelpContext = 1618
      OnClick = AP1Click
    end
    object WO2: TMenuItem
      Tag = 15
      Caption = 'Undo Write &Off'
      HelpContext = 1618
      OnClick = AP1Click
    end
  end
  object mnuSwitchNotes: TPopupMenu
    Left = 16
    Top = 176
    object General1: TMenuItem
      Caption = '&General Notes'
      OnClick = General1Click
    end
    object Dated1: TMenuItem
      Caption = '&Dated Notes'
      OnClick = Dated1Click
    end
    object AuditHistory1: TMenuItem
      Caption = '&Audit History Notes'
      OnClick = AuditHistory1Click
    end
  end
end
