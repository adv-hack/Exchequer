object ReconList: TReconList
  Left = 309
  Top = 124
  Width = 542
  Height = 378
  HelpContext = 560
  Caption = 'Reconciliation List'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  KeyPreview = True
  OldCreateOrder = True
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
    Left = 0
    Top = 0
    Width = 525
    Height = 338
    ActivePage = ItemPage
    TabIndex = 0
    TabOrder = 0
    OnChange = PageControl1Change
    OnChanging = PageControl1Changing
    object ItemPage: TTabSheet
      Caption = 'Itemised'
      object D1SBox: TScrollBox
        Left = 5
        Top = 5
        Width = 387
        Height = 278
        HorzScrollBar.Position = 240
        VertScrollBar.Visible = False
        TabOrder = 0
        object D1HedPanel: TSBSPanel
          Left = -237
          Top = 4
          Width = 619
          Height = 17
          BevelInner = bvLowered
          BevelOuter = bvNone
          Color = clWhite
          TabOrder = 0
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumnHeader
          object D1ORefLab: TSBSPanel
            Left = 4
            Top = 2
            Width = 28
            Height = 13
            Alignment = taLeftJustify
            BevelOuter = bvNone
            Caption = 'Doc'
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
            OnMouseDown = D1ORefLabMouseDown
            OnMouseMove = D1ORefLabMouseMove
            OnMouseUp = D1ORefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object D1DateLab: TSBSPanel
            Left = 35
            Top = 2
            Width = 65
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
            OnMouseDown = D1ORefLabMouseDown
            OnMouseMove = D1ORefLabMouseMove
            OnMouseUp = D1ORefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object D1AccLab: TSBSPanel
            Left = 103
            Top = 2
            Width = 64
            Height = 13
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
            OnMouseDown = D1ORefLabMouseDown
            OnMouseMove = D1ORefLabMouseMove
            OnMouseUp = D1ORefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object D1AmtLab: TSBSPanel
            Left = 271
            Top = 2
            Width = 110
            Height = 13
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = 'Amount'
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
            OnMouseDown = D1ORefLabMouseDown
            OnMouseMove = D1ORefLabMouseMove
            OnMouseUp = D1ORefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object D1StatLab: TSBSPanel
            Left = 389
            Top = 2
            Width = 54
            Height = 13
            Alignment = taLeftJustify
            BevelOuter = bvNone
            Caption = 'Status'
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
            OnMouseDown = D1ORefLabMouseDown
            OnMouseMove = D1ORefLabMouseMove
            OnMouseUp = D1ORefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object D1DesLab: TSBSPanel
            Left = 171
            Top = 3
            Width = 107
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
            TabOrder = 5
            OnMouseDown = D1ORefLabMouseDown
            OnMouseMove = D1ORefLabMouseMove
            OnMouseUp = D1ORefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object D1DatLab: TSBSPanel
            Left = 448
            Top = 2
            Width = 61
            Height = 13
            Alignment = taLeftJustify
            BevelOuter = bvNone
            Caption = 'Trans Date'
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
            OnMouseDown = D1ORefLabMouseDown
            OnMouseMove = D1ORefLabMouseMove
            OnMouseUp = D1ORefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object D1ReconLab: TSBSPanel
            Left = 512
            Top = 2
            Width = 101
            Height = 13
            Alignment = taLeftJustify
            BevelOuter = bvNone
            Caption = 'Reconciliation Date'
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
            OnMouseDown = D1ORefLabMouseDown
            OnMouseMove = D1ORefLabMouseMove
            OnMouseUp = D1ORefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
        end
        object D1ORefPanel: TSBSPanel
          Left = -236
          Top = 24
          Width = 34
          Height = 232
          HelpContext = 565
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
          OnMouseUp = D1ORefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object D1DatePanel: TSBSPanel
          Left = -200
          Top = 24
          Width = 65
          Height = 232
          HelpContext = 2084
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
          OnMouseUp = D1ORefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object D1AccPanel: TSBSPanel
          Left = -133
          Top = 24
          Width = 65
          Height = 232
          HelpContext = 2085
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
          OnMouseUp = D1ORefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object D1DesPanel: TSBSPanel
          Left = -66
          Top = 24
          Width = 106
          Height = 232
          HelpContext = 566
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
          OnMouseUp = D1ORefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object D1AmtPanel: TSBSPanel
          Left = 42
          Top = 24
          Width = 106
          Height = 232
          HelpContext = 567
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
          OnMouseUp = D1ORefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object D1StatPanel: TSBSPanel
          Left = 151
          Top = 24
          Width = 56
          Height = 232
          HelpContext = 568
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
          OnMouseUp = D1ORefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object D1DatPanel: TSBSPanel
          Left = 210
          Top = 24
          Width = 65
          Height = 232
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
          OnMouseUp = D1ORefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object D1ReconPanel: TSBSPanel
          Left = 278
          Top = 24
          Width = 105
          Height = 232
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
          OnMouseUp = D1ORefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
      end
      object D1ListBtnPanel: TSBSPanel
        Left = 394
        Top = 31
        Width = 18
        Height = 231
        BevelOuter = bvLowered
        PopupMenu = PopupMenu1
        TabOrder = 1
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
      end
      object TotalPanel: TSBSPanel
        Left = 0
        Top = 284
        Width = 517
        Height = 26
        HelpContext = 563
        Align = alBottom
        BevelOuter = bvNone
        PopupMenu = PopupMenu1
        TabOrder = 2
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        object Label82: Label8
          Left = 205
          Top = 6
          Width = 79
          Height = 14
          Caption = 'Cleared Balance'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label81: Label8
          Left = 6
          Top = 6
          Width = 76
          Height = 14
          Caption = 'Ledger Balance'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object TotBalance: TCurrencyEdit
          Left = 86
          Top = 3
          Width = 106
          Height = 22
          HelpContext = 573
          TabStop = False
          Color = clBtnFace
          Ctl3D = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Lines.Strings = (
            '0.00 ')
          ParentCtl3D = False
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
        object TotCleared: TCurrencyEdit
          Left = 288
          Top = 3
          Width = 106
          Height = 22
          HelpContext = 574
          TabStop = False
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
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
      end
    end
    object GroupPage: TTabSheet
      HelpContext = 564
      Caption = 'Grouped'
      object D2SBox: TScrollBox
        Left = 5
        Top = 5
        Width = 387
        Height = 278
        HorzScrollBar.Position = 63
        VertScrollBar.Visible = False
        TabOrder = 0
        object D2DatePanel: TSBSPanel
          Left = -23
          Top = 24
          Width = 65
          Height = 232
          HelpContext = 2084
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
          OnMouseUp = D1ORefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object D2ORefPanel: TSBSPanel
          Left = -59
          Top = 24
          Width = 34
          Height = 232
          HelpContext = 565
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
          OnMouseUp = D1ORefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object D2AccPanel: TSBSPanel
          Left = 44
          Top = 24
          Width = 65
          Height = 232
          HelpContext = 2085
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
          OnMouseUp = D1ORefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object D2AmtPanel: TSBSPanel
          Left = 219
          Top = 24
          Width = 106
          Height = 232
          HelpContext = 567
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
          OnMouseUp = D1ORefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object D2StatPanel: TSBSPanel
          Left = 327
          Top = 24
          Width = 56
          Height = 232
          HelpContext = 568
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
          OnMouseUp = D1ORefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object d2HedPanel: TSBSPanel
          Left = -59
          Top = 4
          Width = 442
          Height = 17
          BevelInner = bvLowered
          BevelOuter = bvNone
          Color = clWhite
          TabOrder = 5
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumnHeader
          object D2ORefLab: TSBSPanel
            Left = 4
            Top = 2
            Width = 28
            Height = 13
            Alignment = taLeftJustify
            BevelOuter = bvNone
            Caption = 'Doc'
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 0
            OnMouseDown = D1ORefLabMouseDown
            OnMouseMove = D1ORefLabMouseMove
            OnMouseUp = D1ORefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
          end
          object D2DateLab: TSBSPanel
            Left = 35
            Top = 2
            Width = 65
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
            OnMouseDown = D1ORefLabMouseDown
            OnMouseMove = D1ORefLabMouseMove
            OnMouseUp = D1ORefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object D2AccLab: TSBSPanel
            Left = 103
            Top = 2
            Width = 64
            Height = 13
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
            OnMouseDown = D1ORefLabMouseDown
            OnMouseMove = D1ORefLabMouseMove
            OnMouseUp = D1ORefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object D2AmtLab: TSBSPanel
            Left = 271
            Top = 2
            Width = 110
            Height = 13
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = 'Amount'
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
            OnMouseDown = D1ORefLabMouseDown
            OnMouseMove = D1ORefLabMouseMove
            OnMouseUp = D1ORefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object D2StatLab: TSBSPanel
            Left = 391
            Top = 2
            Width = 49
            Height = 13
            Alignment = taLeftJustify
            BevelOuter = bvNone
            Caption = 'Status'
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
            OnMouseDown = D1ORefLabMouseDown
            OnMouseMove = D1ORefLabMouseMove
            OnMouseUp = D1ORefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object D2DesLab: TSBSPanel
            Left = 169
            Top = 3
            Width = 106
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
            TabOrder = 5
            OnMouseDown = D1ORefLabMouseDown
            OnMouseMove = D1ORefLabMouseMove
            OnMouseUp = D1ORefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
        end
        object D2DesPanel: TSBSPanel
          Left = 111
          Top = 24
          Width = 106
          Height = 232
          HelpContext = 566
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
          OnMouseUp = D1ORefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
      end
      object d2ListBtnPanel: TSBSPanel
        Left = 394
        Top = 31
        Width = 18
        Height = 231
        BevelOuter = bvLowered
        TabOrder = 1
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
      end
    end
  end
  object D1BtnPanel: TSBSPanel
    Left = 418
    Top = 29
    Width = 102
    Height = 304
    BevelOuter = bvNone
    PopupMenu = PopupMenu1
    TabOrder = 1
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
    object D1BSBox: TScrollBox
      Left = 0
      Top = 107
      Width = 99
      Height = 193
      HorzScrollBar.Visible = False
      BorderStyle = bsNone
      Color = clBtnFace
      ParentColor = False
      TabOrder = 0
      object ClrD1Btn: TButton
        Tag = 202
        Left = 2
        Top = 1
        Width = 80
        Height = 21
        HelpContext = 569
        Caption = 'C&lear'
        TabOrder = 0
        OnClick = ClrD1BtnClick
      end
      object UnCD1Btn: TButton
        Left = 2
        Top = 25
        Width = 80
        Height = 21
        HelpContext = 570
        Caption = '&Unclear'
        TabOrder = 1
        OnClick = UnCD1BtnClick
      end
      object FindD1Btn: TButton
        Left = 2
        Top = 49
        Width = 80
        Height = 21
        HelpContext = 571
        Caption = '&Find'
        TabOrder = 2
        OnClick = UnCD1BtnClick
      end
      object ViewD1Btn: TButton
        Left = 2
        Top = 73
        Width = 80
        Height = 21
        HelpContext = 32
        Caption = '&View'
        TabOrder = 3
        OnClick = ViewD1BtnClick
      end
      object EditD1Btn: TButton
        Left = 2
        Top = 121
        Width = 80
        Height = 21
        Caption = '&Edit'
        Enabled = False
        TabOrder = 4
      end
      object CopyD1Btn: TButton
        Left = 2
        Top = 97
        Width = 80
        Height = 21
        HelpContext = 19
        Caption = 'Cop&y'
        TabOrder = 5
        OnClick = UnCD1BtnClick
      end
      object NoteD1Btn: TButton
        Left = 2
        Top = 169
        Width = 80
        Height = 21
        HelpContext = 66
        Caption = '&Notes'
        TabOrder = 6
        OnClick = ViewD1BtnClick
      end
      object ChkD1Btn: TButton
        Left = 2
        Top = 145
        Width = 80
        Height = 21
        HelpContext = 572
        Caption = 'Chec&k'
        TabOrder = 7
        OnClick = ChkD1BtnClick
      end
    end
    object Clsd1Btn: TButton
      Left = 2
      Top = 3
      Width = 80
      Height = 21
      Cancel = True
      Caption = '&Close'
      ModalResult = 2
      TabOrder = 1
      OnClick = Clsd1BtnClick
    end
  end
  object PopupMenu1: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 402
    Top = 2
    object Clear1: TMenuItem
      Tag = 202
      Caption = '&Clear'
      OnClick = ClrD1BtnClick
    end
    object Unclear1: TMenuItem
      Caption = '&Unclear'
    end
    object Find1: TMenuItem
      Caption = '&Find'
    end
    object View1: TMenuItem
      Caption = '&View'
    end
    object Copy1: TMenuItem
      Caption = 'Cop&y'
    end
    object Edit1: TMenuItem
      Caption = '&Edit'
    end
    object Check1: TMenuItem
      Caption = 'Chec&k'
    end
    object Notes1: TMenuItem
      Caption = '&Notes'
      OnClick = ViewD1BtnClick
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object PropFlg: TMenuItem
      Caption = '&Properties'
      Hint = 'Access Colour & Font settings'
      OnClick = PropFlgClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object StoreCoordFlg: TMenuItem
      Caption = '&Save Coordinates'
      Hint = 'Make the current window settings permanent'
      OnClick = StoreCoordFlgClick
    end
  end
  object PopupMenu2: TPopupMenu
    Left = 433
    object NClr1: TMenuItem
      Tag = 201
      Caption = '&Not Cleared'
      OnClick = ClrD1BtnClick
    end
    object Cancelled1: TMenuItem
      Tag = 203
      Caption = '&Cancelled'
      OnClick = ClrD1BtnClick
    end
    object Ret1: TMenuItem
      Tag = 204
      Caption = '&Returned'
      OnClick = ClrD1BtnClick
    end
  end
  object PopupMenu3: TPopupMenu
    Left = 460
    object Amount1: TMenuItem
      Tag = 1
      Caption = '&Amount'
      OnClick = Amount1Click
    end
    object NotCleared2: TMenuItem
      Tag = 2
      Caption = '&Not Cleared'
      OnClick = Amount1Click
    end
    object FIClr1: TMenuItem
      Caption = '&Filter Not Cleared'
      OnClick = FIClr1Click
    end
    object UnclearedAmount1: TMenuItem
      Tag = 3
      Caption = '&Uncleared Amount'
      OnClick = Amount1Click
    end
    object LineDetails1: TMenuItem
      Tag = 4
      Caption = '&Line Details'
      OnClick = Amount1Click
    end
    object AccountCode1: TMenuItem
      Tag = 5
      Caption = 'Account &Code'
      OnClick = Amount1Click
    end
    object ReconciliationDate1: TMenuItem
      Tag = 9
      Caption = 'Reconciliation Date'
      OnClick = Amount1Click
    end
  end
  object PopupMenu4: TPopupMenu
    OnPopup = PopupMenu4Popup
    Left = 487
    object Copy2: TMenuItem
      Tag = 1
      Caption = '&Copy Transaction'
      OnClick = Copy2Click
    end
    object Reverse1: TMenuItem
      Tag = 2
      Caption = '&Reverse/Contra Transaction'
      OnClick = Copy2Click
    end
  end
  object PopupMenu5: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 504
    Top = 1
    object Check2: TMenuItem
      Tag = 1
      Caption = 'Check &Actual Balance'
      OnClick = Check2Click
    end
    object Check3: TMenuItem
      Caption = 'Check &Cleared Balance'
      OnClick = Check2Click
    end
  end
  object PopupMenu6: TPopupMenu
    Left = 366
    Top = 3
    object ClearedBalance: TMenuItem
      Tag = 1
      Caption = 'Recalculate Cleared Balance'
      OnClick = RecalculateBalance
    end
    object YTDBalance: TMenuItem
      Tag = 2
      Caption = 'Recalculate Cumulative / YTD Balance'
      OnClick = RecalculateBalance
    end
  end
  object WindowExport: TWindowExport
    OnEnableExport = WindowExportEnableExport
    OnExecuteCommand = WindowExportExecuteCommand
    OnGetExportDescription = WindowExportGetExportDescription
    Left = 445
    Top = 73
  end
end
