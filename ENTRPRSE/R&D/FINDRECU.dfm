object FindRec: TFindRec
  Left = 427
  Top = 210
  Width = 407
  Height = 265
  ActiveControl = GFCombo1
  Caption = 'Find Record'
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
    Width = 392
    Height = 229
    ActivePage = Serial
    Align = alClient
    TabIndex = 5
    TabOrder = 5
    OnChange = PageControl1Change
    OnChanging = PageControl1Changing
    object Customer: TTabSheet
      Caption = 'Customer'
    end
    object tabConsumer: TTabSheet
      Caption = 'Consumer'
      ImageIndex = 7
    end
    object Supplier: TTabSheet
      Caption = 'Supplier'
    end
    object Document: TTabSheet
      Caption = 'Document'
    end
    object Stock: TTabSheet
      Caption = 'Stock'
    end
    object Serial: TTabSheet
      Caption = 'Serial'
    end
    object Bins: TTabSheet
      Caption = 'Bins'
      ImageIndex = 6
    end
    object Job: TTabSheet
      Caption = 'Job'
    end
  end
  object GFScrollBox1: TScrollBox
    Left = 2
    Top = 110
    Width = 373
    Height = 119
    HorzScrollBar.Tracking = True
    VertScrollBar.Tracking = True
    VertScrollBar.Visible = False
    BorderStyle = bsNone
    TabOrder = 6
    object GFLabPanel: TSBSPanel
      Left = 2
      Top = 2
      Width = 363
      Height = 19
      BevelOuter = bvLowered
      TabOrder = 0
      AllowReSize = False
      IsGroupBox = False
      TextId = 0
      Purpose = puBtrListColumnHeader
      object GFAccLab: TSBSPanel
        Left = 3
        Top = 3
        Width = 70
        Height = 14
        BevelOuter = bvNone
        Caption = 'A/C Code'
        Ctl3D = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentCtl3D = False
        ParentFont = False
        TabOrder = 0
        OnMouseDown = GFAccLabMouseDown
        OnMouseMove = GFAccLabMouseMove
        OnMouseUp = GFAccPanelMouseUp
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        Purpose = puBtrListColumnHeader
      end
      object GFCompLab: TSBSPanel
        Left = 72
        Top = 4
        Width = 142
        Height = 14
        BevelOuter = bvNone
        Caption = 'Company'
        Ctl3D = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentCtl3D = False
        ParentFont = False
        TabOrder = 1
        OnMouseDown = GFAccLabMouseDown
        OnMouseMove = GFAccLabMouseMove
        OnMouseUp = GFAccPanelMouseUp
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        Purpose = puBtrListColumnHeader
      end
      object GFBalLab: TSBSPanel
        Left = 214
        Top = 3
        Width = 139
        Height = 14
        Alignment = taRightJustify
        BevelOuter = bvNone
        Caption = 'Balance'
        Ctl3D = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentCtl3D = False
        ParentFont = False
        TabOrder = 2
        OnMouseDown = GFAccLabMouseDown
        OnMouseMove = GFAccLabMouseMove
        OnMouseUp = GFAccPanelMouseUp
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        Purpose = puBtrListColumnHeader
      end
    end
    object GFAccPanel: TSBSPanel
      Left = 2
      Top = 24
      Width = 71
      Height = 84
      BevelOuter = bvLowered
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnMouseUp = GFAccPanelMouseUp
      AllowReSize = True
      IsGroupBox = False
      TextId = 0
      Purpose = puBtrListColumn
    end
    object GFCompPanel: TSBSPanel
      Left = 76
      Top = 24
      Width = 139
      Height = 84
      BevelOuter = bvLowered
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnMouseUp = GFAccPanelMouseUp
      AllowReSize = True
      IsGroupBox = False
      TextId = 0
      Purpose = puBtrListColumn
    end
    object GFBalPanel: TSBSPanel
      Left = 218
      Top = 24
      Width = 139
      Height = 84
      BevelOuter = bvLowered
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnMouseUp = GFAccPanelMouseUp
      AllowReSize = True
      IsGroupBox = False
      TextId = 0
      Purpose = puBtrListColumn
    end
  end
  object GFListBtnPanel: TSBSPanel
    Left = 374
    Top = 113
    Width = 18
    Height = 106
    BevelOuter = bvLowered
    PopupMenu = PopupMenu1
    TabOrder = 7
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
  end
  object GFBtnPanel: TSBSPanel
    Left = 306
    Top = 22
    Width = 86
    Height = 87
    BevelOuter = bvNone
    PopupMenu = PopupMenu1
    TabOrder = 8
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
  end
  object GFSPanel: TSBSPanel
    Left = 4
    Top = 26
    Width = 301
    Height = 77
    BevelInner = bvRaised
    PopupMenu = PopupMenu1
    TabOrder = 9
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
    object Label81: Label8
      Left = 12
      Top = 18
      Width = 55
      Height = 14
      Caption = '&Search for:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Label82: Label8
      Left = 12
      Top = 48
      Width = 53
      Height = 14
      Caption = 'Search &by:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
  end
  object GFCombo1: TSBSComboBox
    Left = 72
    Top = 38
    Width = 219
    Height = 22
    Hint = 'Search for?|Enter details to search for'
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 14
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    MaxListWidth = 0
  end
  object GFCombo2: TSBSComboBox
    Left = 72
    Top = 72
    Width = 219
    Height = 22
    Hint = 'Search by?|Choose by which field you wish to search'
    Style = csDropDownList
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 14
    MaxLength = 255
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    MaxListWidth = 0
  end
  object GFFindBtn: TButton
    Left = 311
    Top = 26
    Width = 80
    Height = 21
    Hint = 
      'Start ObjectFind|Using the information in Search for, start sear' +
      'ch'
    Caption = 'F&ind Now'
    ModalResult = 1
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    OnClick = GFFindBtnClick
  end
  object GFStopBtn: TButton
    Left = 311
    Top = 54
    Width = 80
    Height = 21
    Hint = 'Stop current ObjectFind|Abandon the search at any time'
    Caption = 'Sto&p'
    Enabled = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    OnClick = GFStopBtnClick
  end
  object GFCloseBtn: TButton
    Left = 311
    Top = 82
    Width = 80
    Height = 21
    Hint = 
      'Close ObjectFind window|Close the ObjectFind window. ObjectFind ' +
      'will remember the last seach details'
    Cancel = True
    Caption = '&Close'
    ModalResult = 2
    ParentShowHint = False
    ShowHint = True
    TabOrder = 4
    OnClick = GFCloseBtnClick
  end
  object PopupMenu1: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 436
    Top = 117
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
end
