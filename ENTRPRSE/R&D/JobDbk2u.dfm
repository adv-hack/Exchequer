object JobDaybk: TJobDaybk
  Left = -949
  Top = -169
  Width = 631
  Height = 378
  Caption = 'Job Costing Transactions'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  FormStyle = fsMDIChild
  KeyPreview = True
  OldCreateOrder = True
  PopupMenu = PopupMenu1
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
    Width = 613
    Height = 337
    ActivePage = MainPage
    TabIndex = 0
    TabOrder = 0
    OnChange = DPageCtrl1Change
    OnChanging = DPageCtrl1Changing
    object MainPage: TTabSheet
      HelpContext = 950
      Caption = 'Job Pre-Postings'
      object db1SBox: TScrollBox
        Left = 1
        Top = 2
        Width = 476
        Height = 308
        HorzScrollBar.Position = 598
        VertScrollBar.Visible = False
        TabOrder = 0
        object db1DatePanel: TSBSPanel
          Left = -388
          Top = 24
          Width = 63
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
          Left = -454
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
          TabOrder = 1
          OnMouseUp = db1OrefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object db1PrPanel: TSBSPanel
          Left = -323
          Top = 24
          Width = 49
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
          Left = -516
          Top = 24
          Width = 60
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
        object db1PstdPanel: TSBSPanel
          Left = 236
          Top = 24
          Width = 41
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
          Left = 279
          Top = 24
          Width = 85
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
          TabOrder = 15
          OnMouseUp = db1OrefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object db1OwnerPanel: TSBSPanel
          Left = 366
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
          TabOrder = 5
          OnMouseUp = db1OrefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object db1HedPanel: TSBSPanel
          Left = -594
          Top = 3
          Width = 1059
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
            Left = 141
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
          object db1DateLab: TSBSPanel
            Left = 205
            Top = 2
            Width = 62
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
            Left = 77
            Top = 2
            Width = 61
            Height = 13
            Alignment = taLeftJustify
            BevelOuter = bvNone
            Caption = '   A/C'
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
          object db1WkLab: TSBSPanel
            Left = 796
            Top = 2
            Width = 32
            Height = 13
            BevelOuter = bvNone
            Caption = 'Ref.'
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
            Left = 872
            Top = 2
            Width = 85
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
            Left = 270
            Top = 2
            Width = 49
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
            Left = 678
            Top = 2
            Width = 116
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
          object db1JCLab: TSBSPanel
            Left = 3
            Top = 2
            Width = 61
            Height = 13
            Alignment = taLeftJustify
            BevelOuter = bvNone
            Caption = 'Job Code'
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
          object db1ExpLab: TSBSPanel
            Left = 322
            Top = 2
            Width = 62
            Height = 13
            BevelOuter = bvNone
            Caption = 'Expires'
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
          object db1QtyLab: TSBSPanel
            Left = 386
            Top = 2
            Width = 49
            Height = 13
            BevelOuter = bvNone
            Caption = 'Hrs/Qty'
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
          object db1CostLab: TSBSPanel
            Left = 437
            Top = 2
            Width = 77
            Height = 13
            BevelOuter = bvNone
            Caption = 'Cost'
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
            OnMouseDown = db1ORefLabMouseDown
            OnMouseMove = db1ORefLabMouseMove
            OnMouseUp = db1OrefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object db1ChrgLab: TSBSPanel
            Left = 595
            Top = 2
            Width = 77
            Height = 13
            BevelOuter = bvNone
            Caption = 'Charge'
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
            OnMouseDown = db1ORefLabMouseDown
            OnMouseMove = db1ORefLabMouseMove
            OnMouseUp = db1OrefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object db1PstdLab: TSBSPanel
            Left = 830
            Top = 2
            Width = 41
            Height = 13
            BevelOuter = bvNone
            Caption = 'Posted'
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
            OnMouseDown = db1ORefLabMouseDown
            OnMouseMove = db1ORefLabMouseMove
            OnMouseUp = db1OrefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object db1UpLab: TSBSPanel
            Left = 517
            Top = 2
            Width = 77
            Height = 13
            BevelOuter = bvNone
            Caption = 'Uplift'
            Color = clWhite
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 13
            OnMouseDown = db1ORefLabMouseDown
            OnMouseMove = db1ORefLabMouseMove
            OnMouseUp = db1OrefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object db1OwnerLab: TSBSPanel
            Left = 960
            Top = 2
            Width = 85
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
            TabOrder = 14
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
          Left = 81
          Top = 24
          Width = 119
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
        object db1JCPanel: TSBSPanel
          Left = -593
          Top = 24
          Width = 75
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
        object db1ExpPanel: TSBSPanel
          Left = -272
          Top = 24
          Width = 63
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
        object db1QtyPanel: TSBSPanel
          Left = -207
          Top = 24
          Width = 49
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
        object db1ChrgPanel: TSBSPanel
          Left = 2
          Top = 24
          Width = 77
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
          TabOrder = 11
          OnMouseUp = db1OrefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object db1WkPanel: TSBSPanel
          Left = 202
          Top = 24
          Width = 32
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
          TabOrder = 12
          OnMouseUp = db1OrefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object db1CostPanel: TSBSPanel
          Left = -156
          Top = 24
          Width = 77
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
          TabOrder = 13
          OnMouseUp = db1OrefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object db1UpliftPanel: TSBSPanel
          Left = -77
          Top = 24
          Width = 77
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
          TabOrder = 14
          OnMouseUp = db1OrefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
      end
      object db1ListBtnPanel: TSBSPanel
        Left = 480
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
    end
    object QuotesPage: TTabSheet
      HelpContext = 954
      Caption = 'Time Sheets'
    end
    object TSHistPage: TTabSheet
      Caption = 'Time Sheet History'
      ImageIndex = 5
    end
    object PLAPage: TTabSheet
      Caption = 'Purchase Applications'
      ImageIndex = 4
    end
    object PLAHPage: TTabSheet
      Caption = 'Purchase Application  History'
    end
    object SLAPage: TTabSheet
      Caption = 'Sales Applications'
      ImageIndex = 6
    end
    object SLAHPage: TTabSheet
      Caption = 'Sales Application History'
      ImageIndex = 8
    end
    object AutoPage: TTabSheet
      HelpContext = 1054
      Caption = 'P/L Retentions'
    end
    object HistoryPage: TTabSheet
      HelpContext = 1054
      Caption = 'S/L Retentions'
    end
  end
  object db1BtnPanel: TSBSPanel
    Left = 508
    Top = 26
    Width = 102
    Height = 308
    BevelOuter = bvNone
    TabOrder = 1
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
    object db1BSBox: TScrollBox
      Left = 0
      Top = 86
      Width = 99
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
        Caption = '&Tag'
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
        OnClick = Notedb1BtnClick
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
      object Remdb1Btn: TButton
        Left = 2
        Top = 217
        Width = 80
        Height = 21
        Hint = 
          'Delete a Retention|Deletes the currently highlighted Retention E' +
          'ntry'
        HelpContext = 463
        Caption = '&Delete'
        Enabled = False
        TabOrder = 9
        OnClick = Remdb1BtnClick
      end
      object Viewdb1Btn: TButton
        Left = 2
        Top = 241
        Width = 80
        Height = 21
        Hint = 
          'View current Transaction|Displays the currently highlighted tran' +
          'saction in a view only mode, ideal for list scanning.'
        HelpContext = 32
        Caption = '&View'
        TabOrder = 10
        OnClick = Viewdb1BtnClick
      end
      object CustdbBtn1: TSBSButton
        Tag = 1
        Left = 2
        Top = 265
        Width = 80
        Height = 21
        Caption = 'Custom1'
        TabOrder = 11
        OnClick = CustdbBtn1Click
        TextId = 10
      end
      object CustdbBtn2: TSBSButton
        Tag = 2
        Left = 2
        Top = 289
        Width = 80
        Height = 21
        Caption = 'Custom2'
        TabOrder = 12
        OnClick = CustdbBtn1Click
        TextId = 20
      end
      object CustdbBtn3: TSBSButton
        Tag = 3
        Left = 2
        Top = 313
        Width = 80
        Height = 21
        Caption = 'Custom3'
        TabOrder = 13
        OnClick = CustdbBtn1Click
        TextId = 180
      end
      object CustdbBtn4: TSBSButton
        Tag = 4
        Left = 2
        Top = 337
        Width = 80
        Height = 21
        Caption = 'Custom4'
        TabOrder = 14
        OnClick = CustdbBtn1Click
        TextId = 190
      end
      object CustdbBtn5: TSBSButton
        Tag = 5
        Left = 2
        Top = 361
        Width = 80
        Height = 21
        Caption = 'Custom5'
        TabOrder = 15
        OnClick = CustdbBtn1Click
        TextId = 200
      end
      object CustdbBtn6: TSBSButton
        Tag = 6
        Left = 2
        Top = 384
        Width = 80
        Height = 21
        Caption = 'Custom6'
        TabOrder = 16
        OnClick = CustdbBtn1Click
        TextId = 210
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
    Left = 164
    Top = 81
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
      Caption = '&Tag'
      Hint = 
        'Converts the currently highlighted quotation into either an invo' +
        'ice, or an order (SPOP version only).'
    end
    object Post1: TMenuItem
      Caption = '&Daybook Post'
      Hint = 
        'Allows the posting of the current daybook, or the printing of va' +
        'rious posting related reports.'
      OnClick = Postdb1BtnClick
    end
    object Notes1: TMenuItem
      Tag = 1
      Caption = '&Notes'
      Hint = 'Shows the notepad for the currently highlighted transaction.'
      Visible = False
      OnClick = Notedb1BtnClick
    end
    object Print1: TMenuItem
      Caption = '&Print'
      Enabled = False
      Hint = 'Prints the currently highlighted transaction.'
      OnClick = Printdb1BtnClick
    end
    object Remove1: TMenuItem
      Caption = '&Delete'
      Hint = 'Deletes the currently highlighted Quotation.'
      OnClick = Remdb1BtnClick
    end
    object View1: TMenuItem
      Caption = '&View'
      Hint = 
        'Displays the currently highlighted transaction in a view only mo' +
        'de, ideal for list scanning.'
      OnClick = Viewdb1BtnClick
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
    Left = 167
    Top = 136
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
  end
  object PopupMenu3: TPopupMenu
    Left = 162
    Top = 183
    object HQ1: TMenuItem
      Tag = 1
      Caption = 'Hold for &Query'
      HelpContext = 21
      Hint = 'Holds the currently highlighted transaction.'
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
  object EntCustom1: TCustomisation
    DLLId = SysDll_Ent
    Enabled = True
    ExportPath = 'X:\ENTRPRSE\CUSTOM\DEMOHOOK\Daybk1.RC'
    WindowId = 105000
    Left = 419
    Top = 58
  end
  object SBSPopupMenu1: TSBSPopupMenu
    Left = 36
    Top = 78
    object ViewR1: TMenuItem
      Caption = 'View &Credit Note'
      OnClick = ViewR1Click
    end
    object ViewR2: TMenuItem
      Tag = 1
      Caption = '&Original Invoice'
      OnClick = ViewR1Click
    end
  end
  object SBSPopupMenu2: TSBSPopupMenu
    Left = 32
    Top = 128
    object PostJD1: TMenuItem
      Caption = 'Post &Job Daybook'
      OnClick = PostJD1Click
    end
    object PostJD2: TMenuItem
      Tag = 1
      Caption = 'Post &Timesheet && Job Daybook'
      OnClick = PostJD1Click
    end
  end
  object SBSPopupMenu3: TSBSPopupMenu
    Left = 28
    Top = 179
    object EdtChmi: TMenuItem
      Caption = 'Edit &Charge'
      OnClick = EdtChmiClick
    end
    object Edtulmi: TMenuItem
      Tag = 2
      Caption = 'Edit &Uplift'
      OnClick = EdtChmiClick
    end
  end
  object SBSPopupMenu4: TSBSPopupMenu
    Left = 30
    Top = 238
    object MenuItem1: TMenuItem
      Tag = 1
      Caption = 'Post &this Certified Application'
      OnClick = MenuItem1Click
    end
    object MenuItem2: TMenuItem
      Tag = 2
      Caption = 'Post &all Certified Applications'
      OnClick = MenuItem1Click
    end
  end
  object PopupMenu7: TPopupMenu
    Left = 162
    Top = 241
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
    object AggTag1: TMenuItem
      Tag = 3
      Caption = '&Aggregate tagged Apps.'
      OnClick = MenuItem1Click
    end
  end
  object WindowExport: TWindowExport
    OnEnableExport = WindowExportEnableExport
    OnExecuteCommand = WindowExportExecuteCommand
    OnGetExportDescription = WindowExportGetExportDescription
    Left = 352
    Top = 63
  end
end
