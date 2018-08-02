object StkAdj: TStkAdj
  Left = 612
  Top = 153
  Width = 647
  Height = 390
  HelpContext = 439
  Caption = 'Stock Issue/Adjustment'
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
  ShowHint = True
  Visible = True
  OnActivate = A1LocTxFExit
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
    Width = 630
    Height = 351
    ActivePage = AdjustPage
    TabIndex = 0
    TabOrder = 0
    OnChange = PageControl1Change
    OnChanging = PageControl1Changing
    object AdjustPage: TTabSheet
      Caption = 'Issue/Adjust'
      object A1SBox: TScrollBox
        Left = 0
        Top = 63
        Width = 500
        Height = 240
        HorzScrollBar.Tracking = True
        VertScrollBar.Tracking = True
        VertScrollBar.Visible = False
        TabOrder = 0
        object A1HedPanel: TSBSPanel
          Left = 2
          Top = 2
          Width = 661
          Height = 17
          BevelInner = bvLowered
          BevelOuter = bvNone
          Color = clWhite
          TabOrder = 0
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumnHeader
          object A1CLab: TSBSPanel
            Left = 2
            Top = 2
            Width = 94
            Height = 13
            Alignment = taLeftJustify
            BevelOuter = bvNone
            Caption = '  Stock Code'
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
          object A1GLab: TSBSPanel
            Left = 507
            Top = 2
            Width = 59
            Height = 13
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
            TabOrder = 1
            OnMouseDown = A1CLabMouseDown
            OnMouseMove = A1CLabMouseMove
            OnMouseUp = A1CPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object A1OLab: TSBSPanel
            Left = 267
            Top = 2
            Width = 69
            Height = 13
            BevelOuter = bvNone
            Caption = 'Out (-)'
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
          object A1DLab: TSBSPanel
            Left = 99
            Top = 2
            Width = 99
            Height = 13
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
            OnMouseDown = A1CLabMouseDown
            OnMouseMove = A1CLabMouseMove
            OnMouseUp = A1CPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object A1ILab: TSBSPanel
            Left = 198
            Top = 2
            Width = 68
            Height = 13
            BevelOuter = bvNone
            Caption = 'In (+)'
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
          object A1CCLab: TSBSPanel
            Left = 568
            Top = 2
            Width = 35
            Height = 13
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
            TabOrder = 5
            OnMouseDown = A1CLabMouseDown
            OnMouseMove = A1CLabMouseMove
            OnMouseUp = A1CPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object A1DpLab: TSBSPanel
            Left = 605
            Top = 2
            Width = 34
            Height = 13
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
            TabOrder = 6
            OnMouseDown = A1CLabMouseDown
            OnMouseMove = A1CLabMouseMove
            OnMouseUp = A1CPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object A1BLab: TSBSPanel
            Left = 338
            Top = 2
            Width = 34
            Height = 13
            BevelOuter = bvNone
            Caption = 'Build'
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
          object A1ULab: TSBSPanel
            Left = 375
            Top = 2
            Width = 80
            Height = 13
            BevelOuter = bvNone
            Caption = 'Unit Cost'
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
          object A1LocLab: TSBSPanel
            Left = 455
            Top = 2
            Width = 52
            Height = 13
            BevelOuter = bvNone
            Caption = 'Location'
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
        end
        object A1CPanel: TSBSPanel
          Left = 3
          Top = 22
          Width = 97
          Height = 196
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
        object A1IPanel: TSBSPanel
          Left = 201
          Top = 22
          Width = 68
          Height = 196
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
          Left = 511
          Top = 22
          Width = 59
          Height = 196
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
        object A1DPanel: TSBSPanel
          Left = 102
          Top = 22
          Width = 97
          Height = 196
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
        object A1OPanel: TSBSPanel
          Left = 271
          Top = 22
          Width = 68
          Height = 196
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
        object A1CCPanel: TSBSPanel
          Left = 572
          Top = 22
          Width = 35
          Height = 196
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
        object A1DpPanel: TSBSPanel
          Left = 609
          Top = 22
          Width = 35
          Height = 196
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
        object A1BPanel: TSBSPanel
          Left = 341
          Top = 22
          Width = 35
          Height = 196
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
        object A1UPanel: TSBSPanel
          Left = 378
          Top = 22
          Width = 79
          Height = 196
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
        object A1LocPanel: TSBSPanel
          Left = 459
          Top = 22
          Width = 50
          Height = 196
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
      end
      object A1BtmPanel: TSBSPanel
        Left = 0
        Top = 303
        Width = 622
        Height = 20
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 1
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        object CCPanel: TSBSPanel
          Left = 0
          Top = 3
          Width = 118
          Height = 17
          HelpContext = 433
          BevelOuter = bvLowered
          ParentColor = True
          TabOrder = 0
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          object CCTit: Label8
            Left = 3
            Top = 2
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
            Top = 2
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
            Top = 2
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
            Top = 2
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
        object SBSPanel5: TSBSPanel
          Left = 121
          Top = 3
          Width = 175
          Height = 17
          HelpContext = 442
          BevelOuter = bvLowered
          ParentColor = True
          TabOrder = 1
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          object DrReqdTit: Label8
            Left = 4
            Top = 2
            Width = 46
            Height = 14
            Caption = 'Unit Cost:'
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
            Top = 2
            Width = 117
            Height = 14
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
        object SBSPanel4: TSBSPanel
          Left = 299
          Top = 3
          Width = 175
          Height = 17
          HelpContext = 443
          BevelOuter = bvLowered
          ParentColor = True
          TabOrder = 2
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          object CrReqdTit: Label8
            Left = 4
            Top = 2
            Width = 42
            Height = 14
            Caption = 'G/L Acc:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TextId = 0
          end
          object GLLab: Label8
            Left = 55
            Top = 2
            Width = 117
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
      end
      object A1ListBtnPanel: TSBSPanel
        Left = 501
        Top = 86
        Width = 18
        Height = 195
        BevelOuter = bvLowered
        TabOrder = 2
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
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
        Top = 63
        Width = 500
        Height = 257
        VertScrollBar.Visible = False
        TabOrder = 0
        object TNHedPanel: TSBSPanel
          Left = -1
          Top = 2
          Width = 487
          Height = 17
          BevelInner = bvLowered
          BevelOuter = bvNone
          Color = clWhite
          TabOrder = 0
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumnHeader
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
          Left = 1
          Top = 22
          Width = 67
          Height = 228
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object NDescPanel: TSBSPanel
          Left = 70
          Top = 22
          Width = 344
          Height = 228
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object NUserPanel: TSBSPanel
          Left = 416
          Top = 22
          Width = 70
          Height = 228
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
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
        Left = 501
        Top = 86
        Width = 18
        Height = 227
        BevelOuter = bvLowered
        TabOrder = 1
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
      end
    end
    object TabSheet1: TTabSheet
      Caption = 'TabSheet1'
      ImageIndex = 2
    end
  end
  object A1BtnPanel: TSBSPanel
    Left = 524
    Top = 28
    Width = 100
    Height = 298
    BevelOuter = bvNone
    TabOrder = 1
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
    object A1StatLab: Label8
      Left = 3
      Top = 3
      Width = 95
      Height = 49
      Alignment = taCenter
      AutoSize = False
      Caption = 'A1StatLab'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
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
      Top = 99
      Width = 97
      Height = 190
      HorzScrollBar.Tracking = True
      HorzScrollBar.Visible = False
      VertScrollBar.Position = 120
      VertScrollBar.Tracking = True
      BorderStyle = bsNone
      Color = clBtnFace
      ParentColor = False
      TabOrder = 3
      object AddN1Btn: TButton
        Left = 2
        Top = -119
        Width = 80
        Height = 21
        Hint = 
          'Add new line|Choosing this option allows you to Add a new line w' +
          'hich will be placed at the end of the adjustment.'
        HelpContext = 260
        Caption = '&Add'
        Enabled = False
        TabOrder = 0
        OnClick = AddN1BtnClick
      end
      object EditN1Btn: TButton
        Left = 2
        Top = -95
        Width = 80
        Height = 21
        Hint = 
          'Edit current line|Choosing this option allows you to edit the cu' +
          'rrently highlighted line.'
        HelpContext = 261
        Caption = '&Edit'
        Enabled = False
        TabOrder = 1
        OnClick = AddN1BtnClick
      end
      object DelN1Btn: TButton
        Left = 2
        Top = -71
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
        Top = -23
        Width = 80
        Height = 21
        Hint = 
          'Insert new line|Choosing this option allows you to Insert a new ' +
          'line before the currently highlighted line.'
        HelpContext = 86
        Caption = '&Insert'
        TabOrder = 4
        OnClick = AddN1BtnClick
      end
      object SwiN1Btn: TButton
        Left = 2
        Top = 1
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
        Top = 25
        Width = 80
        Height = 21
        Hint = 
          'Link to additional information|Displays a list of any additional' +
          ' information attached to this transaction.'
        HelpContext = 90
        Caption = 'Lin&ks'
        TabOrder = 6
        OnClick = LnkN1BtnClick
      end
      object FindN1Btn: TButton
        Left = 2
        Top = -47
        Width = 80
        Height = 21
        Hint = 
          'Find Stock Item|Choosing this option allows you to find the next' +
          ' line containing the specified stock code.'
        HelpContext = 165
        Caption = '&Find'
        Enabled = False
        TabOrder = 3
        OnClick = FindN1BtnClick
      end
      object CustTxBtn2: TSBSButton
        Tag = 2
        Left = 2
        Top = 73
        Width = 80
        Height = 21
        Caption = 'Custom 2'
        TabOrder = 8
        OnClick = CustTxBtn1Click
        TextId = 17
      end
      object CustTxBtn1: TSBSButton
        Tag = 1
        Left = 2
        Top = 49
        Width = 80
        Height = 21
        Caption = 'Custom 1'
        TabOrder = 7
        OnClick = CustTxBtn1Click
        TextId = 16
      end
      object CustTxBtn3: TSBSButton
        Tag = 3
        Left = 2
        Top = 97
        Width = 80
        Height = 21
        Caption = 'Custom 3'
        TabOrder = 9
        OnClick = CustTxBtn1Click
        TextId = 451
      end
      object CustTxBtn4: TSBSButton
        Tag = 4
        Left = 2
        Top = 121
        Width = 80
        Height = 21
        Caption = 'Custom 4'
        TabOrder = 10
        OnClick = CustTxBtn1Click
        TextId = 452
      end
      object CustTxBtn5: TSBSButton
        Tag = 5
        Left = 2
        Top = 145
        Width = 80
        Height = 21
        Caption = 'Custom 5'
        TabOrder = 11
        OnClick = CustTxBtn1Click
        TextId = 453
      end
      object CustTxBtn6: TSBSButton
        Tag = 6
        Left = 2
        Top = 169
        Width = 80
        Height = 21
        Caption = 'Custom 6'
        TabOrder = 12
        OnClick = CustTxBtn1Click
        TextId = 454
      end
    end
  end
  object A1FPanel: TSBSPanel
    Left = 2
    Top = 24
    Width = 517
    Height = 61
    BevelOuter = bvNone
    TabOrder = 2
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
    object Label817: Label8
      Left = 186
      Top = 5
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
    object Label87: Label8
      Left = 14
      Top = 5
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
    object Label816: Label8
      Left = 338
      Top = 5
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
    object LTxfrLab: Label8
      Left = 324
      Top = 43
      Width = 82
      Height = 14
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'In Loc Transfer '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object A1OrefF: Text8Pt
      Left = 229
      Top = 1
      Width = 79
      Height = 22
      HelpContext = 142
      TabStop = False
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 1
      Text = 'SRC000080'
      TextId = 0
      ViaSBtn = False
    end
    object A1OpoF: Text8Pt
      Left = 409
      Top = 1
      Width = 86
      Height = 22
      HelpContext = 241
      TabStop = False
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 4
      Text = 'Sally'
      TextId = 0
      ViaSBtn = False
    end
    object A1YRefF: Text8Pt
      Tag = 1
      Left = 42
      Top = 0
      Width = 139
      Height = 22
      HelpContext = 441
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
      TextId = 0
      ViaSBtn = False
    end
    object A1LocTxF: Text8Pt
      Tag = 1
      Left = 409
      Top = 38
      Width = 86
      Height = 22
      Hint = 
        'In Location Transfer|Use this box to specify the In (receiving) ' +
        'location against any lines added to the body of the stock adjust' +
        'ment.'
      HelpContext = 373
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 3
      OnExit = A1LocTxFExit
      TextId = 0
      ViaSBtn = False
    end
    object TransExtForm1: TSBSExtendedForm
      Left = 8
      Top = 23
      Width = 319
      Height = 38
      HelpContext = 1169
      HorzScrollBar.Visible = False
      VertScrollBar.Visible = False
      AutoScroll = False
      BorderStyle = bsNone
      TabOrder = 2
      ArrowPos = alTop
      ArrowX = 148
      ArrowY = 13
      OrigHeight = 38
      OrigWidth = 319
      ExpandedWidth = 319
      ExpandedHeight = 194
      OrigTabOrder = 2
      ShowHorzSB = True
      ShowVertSB = True
      OrigParent = A1FPanel
      NewParent = Owner
      FocusFirst = A1YRef2F
      FocusLast = THUD10F
      TabPrev = A1YRefF
      TabNext = A1LocTxF
      object UDF1L: Label8
        Left = 7
        Top = 50
        Width = 58
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
        Left = 7
        Top = 74
        Width = 58
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
        Left = 157
        Top = 50
        Width = 58
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
        Left = 157
        Top = 74
        Width = 58
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
      object Label84: Label8
        Left = 131
        Top = 1
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
      object Label88: Label8
        Left = 222
        Top = 1
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
      object Label89: Label8
        Left = 38
        Top = 1
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
      object UDF6L: Label8
        Left = 157
        Top = 98
        Width = 58
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
        Left = 157
        Top = 122
        Width = 58
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
        Left = 157
        Top = 146
        Width = 68
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
      object UDF5L: Label8
        Left = 7
        Top = 98
        Width = 58
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
        Left = 7
        Top = 122
        Width = 58
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
        Left = 7
        Top = 146
        Width = 58
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
      object UDF11L: Label8
        Left = 7
        Top = 170
        Width = 58
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
        Left = 157
        Top = 170
        Width = 68
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
        Left = 63
        Top = 46
        Width = 90
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
        Left = 63
        Top = 70
        Width = 90
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
        Left = 221
        Top = 70
        Width = 90
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
        Left = 221
        Top = 46
        Width = 90
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
      object A1TDateF: TEditDate
        Tag = 1
        Left = 130
        Top = 15
        Width = 79
        Height = 22
        HelpContext = 143
        AutoSelect = False
        Color = clWhite
        EditMask = '00/00/0000;0;'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 10
        ParentFont = False
        ReadOnly = True
        TabOrder = 1
        OnExit = A1TDateFExit
        Placement = cpAbove
      end
      object A1TPerF: TEditPeriod
        Tag = 1
        Left = 222
        Top = 15
        Width = 78
        Height = 22
        HelpContext = 239
        AutoSelect = False
        Color = clWhite
        EditMask = '00/0000;0;'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 7
        ParentFont = False
        ReadOnly = True
        TabOrder = 2
        Text = 'mmyyyy'
        Placement = cpAbove
        EPeriod = 1
        EYear = 1996
        ViewMask = '000/0000;0;'
        OnConvDate = A1TPerFConvDate
        OnShowPeriod = A1TPerFShowPeriod
      end
      object A1YRef2F: Text8Pt
        Tag = 1
        Left = 36
        Top = 15
        Width = 84
        Height = 22
        HelpContext = 441
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        TabOrder = 0
        OnChange = A1YRef2FChange
        OnExit = THUD1FExit
        TextId = 0
        ViaSBtn = False
        OnEntHookEvent = THUD1FEntHookEvent
      end
      object THUD5F: Text8Pt
        Tag = 1
        Left = 63
        Top = 94
        Width = 90
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
        Left = 63
        Top = 118
        Width = 90
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
        Left = 63
        Top = 142
        Width = 90
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
        Left = 221
        Top = 94
        Width = 90
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
        Left = 221
        Top = 118
        Width = 90
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
        Left = 221
        Top = 142
        Width = 90
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
        Left = 63
        Top = 166
        Width = 90
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
        Left = 221
        Top = 166
        Width = 90
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
  object PopupMenu1: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 192
    Top = 116
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
    object Find1: TMenuItem
      Caption = '&Find'
      OnClick = FindN1BtnClick
    end
    object Insert1: TMenuItem
      Caption = '&Insert'
      Hint = 
        'Choosing this option allows you to Insert a new line before the ' +
        'currently highlighted line.'
      OnClick = AddN1BtnClick
    end
    object Switch1: TMenuItem
      Caption = '&Switch'
      Hint = 
        'Switches the display of the notepad between dated notepad, & gen' +
        'eral notepad.'
      OnClick = SwiN1BtnClick
    end
    object Links1: TMenuItem
      Caption = 'Lin&ks'
      Hint = 
        'Displays a list of any additional information attached to this t' +
        'ransaction.'
    end
    object Custom1: TMenuItem
      Tag = 1
      Caption = '&Custom1'
      Visible = False
      OnClick = CustTxBtn1Click
    end
    object Custom2: TMenuItem
      Tag = 2
      Caption = '&Custom2'
      OnClick = CustTxBtn1Click
    end
    object Custom3: TMenuItem
      Tag = 3
      Caption = 'Custom3'
      OnClick = CustTxBtn1Click
    end
    object Custom4: TMenuItem
      Tag = 4
      Caption = 'Custom4'
      OnClick = CustTxBtn1Click
    end
    object Custom5: TMenuItem
      Tag = 5
      Caption = 'Custom5'
      OnClick = CustTxBtn1Click
    end
    object Custom6: TMenuItem
      Tag = 6
      Caption = 'Custom6'
      OnClick = CustTxBtn1Click
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
  object EntCustom3: TCustomisation
    DLLId = SysDll_Ent
    Enabled = True
    ExportPath = 'X:\ENTRPRSE\CUSTOM\DEMOHOOK\Daybk1.RC'
    WindowId = 102000
    Left = 434
    Top = 65517
  end
  object PMenu_Notes: TPopupMenu
    Left = 110
    Top = 113
    object MenItem_General: TMenuItem
      Caption = '&General Notes'
      OnClick = MenItem_GeneralClick
    end
    object MenItem_Dated: TMenuItem
      Caption = '&Dated Notes'
      OnClick = MenItem_DatedClick
    end
    object MenItem_Audit: TMenuItem
      Caption = '&Audit History Notes'
      OnClick = MenItem_AuditClick
    end
  end
end
