object CMPSerCtrl: TCMPSerCtrl
  Left = 461
  Top = 193
  Width = 588
  Height = 382
  HelpContext = 546
  VertScrollBar.Position = 26
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 
    'Bill of Material Components requiring Serial/Batch & Locn detail' +
    's'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  Position = poDefault
  Scaled = False
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
    Left = 1
    Top = -24
    Width = 577
    Height = 351
    ActivePage = AdjustPage
    TabIndex = 0
    TabOrder = 0
    OnChange = PageControl1Change
    OnChanging = PageControl1Changing
    object AdjustPage: TTabSheet
      Caption = 'Components'
      object A1SBox: TScrollBox
        Left = 0
        Top = 4
        Width = 443
        Height = 299
        HorzScrollBar.Tracking = True
        VertScrollBar.Tracking = True
        VertScrollBar.Visible = False
        TabOrder = 0
        object A1HedPanel: TSBSPanel
          Left = 2
          Top = 2
          Width = 528
          Height = 17
          BevelInner = bvLowered
          BevelOuter = bvNone
          TabOrder = 0
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumnHeader
          object A1CLab: TSBSPanel
            Left = 2
            Top = 2
            Width = 97
            Height = 13
            Alignment = taLeftJustify
            BevelOuter = bvNone
            Caption = '  Stock Code'
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
            Left = 278
            Top = 2
            Width = 69
            Height = 13
            BevelOuter = bvNone
            Caption = 'Out (-)'
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
          object A1DLab: TSBSPanel
            Left = 102
            Top = 2
            Width = 102
            Height = 13
            BevelOuter = bvNone
            Caption = 'Description'
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
          object A1ILab: TSBSPanel
            Left = 205
            Top = 2
            Width = 71
            Height = 13
            BevelOuter = bvNone
            Caption = 'In (+)'
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
          object A1BLab: TSBSPanel
            Left = 347
            Top = 2
            Width = 37
            Height = 13
            BevelOuter = bvNone
            Caption = ' Ser No.'
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
          object A1ULab: TSBSPanel
            Left = 436
            Top = 3
            Width = 87
            Height = 13
            BevelOuter = bvNone
            Caption = 'Unit Cost'
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
            Left = 385
            Top = 2
            Width = 51
            Height = 13
            BevelOuter = bvNone
            Caption = 'Locn'
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
        end
        object A1CPanel: TSBSPanel
          Left = 3
          Top = 23
          Width = 100
          Height = 252
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
          Left = 207
          Top = 23
          Width = 70
          Height = 252
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
        object A1DPanel: TSBSPanel
          Left = 105
          Top = 23
          Width = 100
          Height = 252
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
          Left = 279
          Top = 23
          Width = 70
          Height = 252
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
        object A1BPanel: TSBSPanel
          Left = 351
          Top = 23
          Width = 35
          Height = 252
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
        object A1UPanel: TSBSPanel
          Left = 440
          Top = 23
          Width = 86
          Height = 252
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
        object A1LocPanel: TSBSPanel
          Left = 388
          Top = 23
          Width = 50
          Height = 252
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
      end
      object A1BtmPanel: TSBSPanel
        Left = 0
        Top = 303
        Width = 569
        Height = 20
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 1
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        object BOMNameP: TSBSPanel
          Left = 2
          Top = 3
          Width = 491
          Height = 17
          HelpContext = 442
          BevelOuter = bvLowered
          Caption = 'BOMNameP'
          ParentColor = True
          TabOrder = 0
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          object DrReqdTit: Label8
            Left = 4
            Top = 2
            Width = 93
            Height = 14
            Caption = 'From Bill of Material'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TextId = 0
          end
          object CostLab: Label8
            Left = 102
            Top = 2
            Width = 387
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
        Left = 446
        Top = 30
        Width = 18
        Height = 250
        BevelOuter = bvLowered
        TabOrder = 2
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
      end
    end
  end
  object A1BtnPanel: TSBSPanel
    Left = 470
    Top = 2
    Width = 100
    Height = 298
    BevelOuter = bvNone
    Caption = 'A1BtnPanel'
    TabOrder = 1
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
    object ClsN1Btn: TButton
      Left = 2
      Top = 2
      Width = 80
      Height = 21
      HelpContext = 259
      Cancel = True
      Caption = '&Close'
      ModalResult = 2
      TabOrder = 0
      OnClick = ClsN1BtnClick
    end
    object A1BSBox: TScrollBox
      Left = 1
      Top = 99
      Width = 97
      Height = 190
      HorzScrollBar.Tracking = True
      HorzScrollBar.Visible = False
      VertScrollBar.Tracking = True
      BorderStyle = bsNone
      Color = clBtnFace
      ParentColor = False
      TabOrder = 1
      object AddN1Btn: TButton
        Left = 2
        Top = 1
        Width = 80
        Height = 21
        Hint = 
          'Add new line|Choosing this option allows you to Add a new line w' +
          'hich will be placed at the end of the adjustment.'
        Caption = 'Change &Locn'
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
        Caption = '&Serial/Batch'
        Enabled = False
        TabOrder = 1
        OnClick = EditN1BtnClick
      end
    end
  end
  object PopupMenu1: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 528
    Top = 65518
    object Add1: TMenuItem
      Caption = 'Change &Location'
      Hint = 
        'Choosing this option allows you to alter the location from where' +
        ' the component stock is being drawn for the currently highlighte' +
        'd line.'
      OnClick = AddN1BtnClick
    end
    object Edit1: TMenuItem
      Tag = 1
      Caption = '&Serial/Batch'
      Hint = 
        'Choosing this option allows you to allocate/deallocate serial nu' +
        'mbers from the currently highlighted line.'
      Visible = False
      OnClick = EditN1BtnClick
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
end
