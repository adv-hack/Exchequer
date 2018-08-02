object BatchItems: TBatchItems
  Left = 367
  Top = 196
  Width = 716
  Height = 274
  HelpContext = 40133
  Caption = 'Itemised List'
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
  OnActivate = FormActivate
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object CListBtnPanel: TSBSPanel
    Left = 570
    Top = 29
    Width = 18
    Height = 179
    BevelOuter = bvLowered
    TabOrder = 0
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
  end
  object CSBox: TScrollBox
    Left = 2
    Top = 2
    Width = 567
    Height = 228
    HorzScrollBar.Position = 270
    VertScrollBar.Tracking = True
    VertScrollBar.Visible = False
    TabOrder = 1
    object CHedPanel: TSBSPanel
      Left = -269
      Top = 3
      Width = 832
      Height = 19
      BevelInner = bvLowered
      BevelOuter = bvNone
      TabOrder = 0
      AllowReSize = False
      IsGroupBox = False
      TextId = 0
      Purpose = puBtrListColumnHeader
      object CLORefLab: TSBSPanel
        Left = 2
        Top = 4
        Width = 67
        Height = 14
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
        OnMouseDown = CLORefLabMouseDown
        OnMouseMove = CLORefLabMouseMove
        OnMouseUp = CLORefPanelMouseUp
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        Purpose = puBtrListColumnHeader
      end
      object CLDueLab: TSBSPanel
        Left = 138
        Top = 4
        Width = 67
        Height = 14
        BevelOuter = bvNone
        Caption = 'Date Due'
        Ctl3D = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentCtl3D = False
        ParentFont = False
        TabOrder = 1
        OnMouseDown = CLORefLabMouseDown
        OnMouseMove = CLORefLabMouseMove
        OnMouseUp = CLORefPanelMouseUp
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        Purpose = puBtrListColumnHeader
      end
      object CLYRefLab: TSBSPanel
        Left = 70
        Top = 4
        Width = 71
        Height = 14
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
        TabOrder = 2
        OnMouseDown = CLORefLabMouseDown
        OnMouseMove = CLORefLabMouseMove
        OnMouseUp = CLORefPanelMouseUp
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        Purpose = puBtrListColumnHeader
      end
      object CLOSLab: TSBSPanel
        Left = 202
        Top = 4
        Width = 87
        Height = 14
        Alignment = taRightJustify
        BevelOuter = bvNone
        Caption = 'Outstanding'
        Ctl3D = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentCtl3D = False
        ParentFont = False
        TabOrder = 3
        OnMouseDown = CLORefLabMouseDown
        OnMouseMove = CLORefLabMouseMove
        OnMouseUp = CLORefPanelMouseUp
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        Purpose = puBtrListColumnHeader
      end
      object CLAMTLab: TSBSPanel
        Left = 292
        Top = 4
        Width = 83
        Height = 14
        Alignment = taRightJustify
        BevelOuter = bvNone
        Caption = 'Paid this Run'
        Ctl3D = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentCtl3D = False
        ParentFont = False
        TabOrder = 4
        OnMouseDown = CLORefLabMouseDown
        OnMouseMove = CLORefLabMouseMove
        OnMouseUp = CLORefPanelMouseUp
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        Purpose = puBtrListColumnHeader
      end
      object CLDateLab: TSBSPanel
        Left = 457
        Top = 3
        Width = 58
        Height = 14
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
        TabOrder = 5
        OnMouseDown = CLORefLabMouseDown
        OnMouseMove = CLORefLabMouseMove
        OnMouseUp = CLORefPanelMouseUp
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        Purpose = puBtrListColumnHeader
      end
      object CLStatLab: TSBSPanel
        Left = 378
        Top = 3
        Width = 76
        Height = 14
        BevelOuter = bvNone
        Caption = 'Status'
        Ctl3D = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentCtl3D = False
        ParentFont = False
        TabOrder = 6
        OnMouseDown = CLORefLabMouseDown
        OnMouseMove = CLORefLabMouseMove
        OnMouseUp = CLORefPanelMouseUp
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        Purpose = puBtrListColumnHeader
      end
      object lblPPDAvailable: TSBSPanel
        Left = 524
        Top = 3
        Width = 76
        Height = 14
        Alignment = taRightJustify
        BevelOuter = bvNone
        Caption = 'PPD Available'
        Ctl3D = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentCtl3D = False
        ParentFont = False
        TabOrder = 7
        OnMouseDown = CLORefLabMouseDown
        OnMouseMove = CLORefLabMouseMove
        OnMouseUp = CLORefPanelMouseUp
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        Purpose = puBtrListColumnHeader
      end
      object lblTotalAfterPPD: TSBSPanel
        Left = 608
        Top = 3
        Width = 76
        Height = 14
        Alignment = taRightJustify
        BevelOuter = bvNone
        Caption = 'Total after PPD'
        Ctl3D = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentCtl3D = False
        ParentFont = False
        TabOrder = 8
        OnMouseDown = CLORefLabMouseDown
        OnMouseMove = CLORefLabMouseMove
        OnMouseUp = CLORefPanelMouseUp
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        Purpose = puBtrListColumnHeader
      end
      object lblPPDExpiry: TSBSPanel
        Left = 690
        Top = 3
        Width = 63
        Height = 14
        BevelOuter = bvNone
        Caption = 'PPD Expiry'
        Ctl3D = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentCtl3D = False
        ParentFont = False
        TabOrder = 9
        OnMouseDown = CLORefLabMouseDown
        OnMouseMove = CLORefLabMouseMove
        OnMouseUp = CLORefPanelMouseUp
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        Purpose = puBtrListColumnHeader
      end
      object lblPPDStatus: TSBSPanel
        Left = 754
        Top = 3
        Width = 76
        Height = 14
        BevelOuter = bvNone
        Caption = 'PPD Status'
        Ctl3D = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentCtl3D = False
        ParentFont = False
        TabOrder = 10
        OnMouseDown = CLORefLabMouseDown
        OnMouseMove = CLORefLabMouseMove
        OnMouseUp = CLORefPanelMouseUp
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        Purpose = puBtrListColumnHeader
      end
    end
    object CLORefPanel: TSBSPanel
      Left = -269
      Top = 25
      Width = 69
      Height = 180
      HelpContext = 40001
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
      OnMouseUp = CLORefPanelMouseUp
      AllowReSize = True
      IsGroupBox = False
      TextId = 0
      Purpose = puBtrListColumn
    end
    object CLDatePanel: TSBSPanel
      Left = 188
      Top = 25
      Width = 60
      Height = 180
      HelpContext = 1844
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
      OnMouseUp = CLORefPanelMouseUp
      AllowReSize = True
      IsGroupBox = False
      TextId = 0
      Purpose = puBtrListColumn
    end
    object CLAMTPanel: TSBSPanel
      Left = 22
      Top = 25
      Width = 85
      Height = 180
      HelpContext = 1842
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
      OnMouseUp = CLORefPanelMouseUp
      AllowReSize = True
      IsGroupBox = False
      TextId = 0
      Purpose = puBtrListColumn
    end
    object CLOSPAnel: TSBSPanel
      Left = -65
      Top = 25
      Width = 85
      Height = 180
      HelpContext = 40127
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
      OnMouseUp = CLORefPanelMouseUp
      AllowReSize = True
      IsGroupBox = False
      TextId = 0
      Purpose = puBtrListColumn
    end
    object CLStatPanel: TSBSPanel
      Left = 109
      Top = 25
      Width = 77
      Height = 180
      HelpContext = 1843
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
      OnMouseUp = CLORefPanelMouseUp
      AllowReSize = True
      IsGroupBox = False
      TextId = 0
      Purpose = puBtrListColumn
    end
    object CLYRefPanel: TSBSPanel
      Left = -198
      Top = 25
      Width = 69
      Height = 180
      HelpContext = 40011
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
      OnMouseUp = CLORefPanelMouseUp
      AllowReSize = True
      IsGroupBox = False
      TextId = 0
      Purpose = puBtrListColumn
    end
    object CLDuePanel: TSBSPanel
      Left = -127
      Top = 25
      Width = 60
      Height = 180
      HelpContext = 40126
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
      OnMouseUp = CLORefPanelMouseUp
      AllowReSize = True
      IsGroupBox = False
      TextId = 0
      Purpose = puBtrListColumn
    end
    object pnlPPDAvailable: TSBSPanel
      Left = 249
      Top = 25
      Width = 85
      Height = 180
      HelpContext = 2216
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
      OnMouseUp = CLORefPanelMouseUp
      AllowReSize = True
      IsGroupBox = False
      TextId = 0
      Purpose = puBtrListColumn
    end
    object pnlTotalAfterPPD: TSBSPanel
      Left = 335
      Top = 25
      Width = 85
      Height = 180
      HelpContext = 2215
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
      OnMouseUp = CLORefPanelMouseUp
      AllowReSize = True
      IsGroupBox = False
      TextId = 0
      Purpose = puBtrListColumn
    end
    object pnlPPDExpiry: TSBSPanel
      Left = 421
      Top = 25
      Width = 62
      Height = 180
      HelpContext = 2217
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
      OnMouseUp = CLORefPanelMouseUp
      AllowReSize = True
      IsGroupBox = False
      TextId = 0
      Purpose = puBtrListColumn
    end
    object pnlPPDStatus: TSBSPanel
      Left = 485
      Top = 25
      Width = 77
      Height = 180
      HelpContext = 2218
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
      OnMouseUp = CLORefPanelMouseUp
      AllowReSize = True
      IsGroupBox = False
      TextId = 0
      Purpose = puBtrListColumn
    end
  end
  object CBtnPanel: TSBSPanel
    Left = 592
    Top = 0
    Width = 102
    Height = 229
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 2
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
    object ClsCP1Btn: TButton
      Left = 2
      Top = 3
      Width = 80
      Height = 21
      Hint = 'Close window|Closes the Customer/Supplier account window.'
      HelpContext = 24
      Cancel = True
      Caption = 'C&lose'
      ModalResult = 2
      TabOrder = 0
      OnClick = ClsCP1BtnClick
    end
    object CCBSBox: TScrollBox
      Left = 0
      Top = 64
      Width = 99
      Height = 161
      HorzScrollBar.Visible = False
      BorderStyle = bsNone
      TabOrder = 1
      object Bevel1: TBevel
        Left = 4
        Top = 52
        Width = 77
        Height = 9
        Shape = bsTopLine
      end
      object btnUntag: TButton
        Left = 2
        Top = 25
        Width = 80
        Height = 21
        Hint = 
          'Untag the currently highlighted transaction|Untagging the curren' +
          'tly highlighted transaction means it will be removed from the li' +
          'st of items to be paid.'
        HelpContext = 40132
        Caption = '&Untag'
        TabOrder = 1
        OnClick = btnTagClick
      end
      object btnTag: TButton
        Left = 2
        Top = 1
        Width = 80
        Height = 21
        Hint = 
          'Tag the currently highlighted transaction|Tagging the currently ' +
          'highlighted transaction means it will be added to the list of it' +
          'ems to be paid.'
        HelpContext = 40131
        Caption = '&Tag'
        TabOrder = 0
        OnClick = btnTagClick
      end
      object GenCP3Btn: TButton
        Left = 2
        Top = 127
        Width = 80
        Height = 21
        Hint = 
          'Find a transaction on the list by Our Ref, or YourRef|Find searc' +
          'hes the list of transactions for a match by Our Ref, or Your Ref' +
          '.'
        HelpContext = 27
        Caption = '&Find'
        TabOrder = 3
        OnClick = GenCP3BtnClick
      end
      object btnPartAllocate: TButton
        Left = 2
        Top = 57
        Width = 80
        Height = 21
        Hint = 
          'Part allocate the currently highlighted transaction|Allows you t' +
          'o specify how much of the currently highlighted transaction is p' +
          'aid.'
        HelpContext = 40130
        Caption = '&Part Allocate'
        TabOrder = 2
        OnClick = btnPartAllocateClick
      end
      object btnWriteOff: TButton
        Left = 2
        Top = 80
        Width = 80
        Height = 21
        Hint = 
          'Discount the currently highlighted transaction|Allows you to spe' +
          'cify an additional discount for the currently highlighted transa' +
          'ction'
        HelpContext = 1167
        Caption = '&Write-Off'
        TabOrder = 4
        OnClick = btnWriteOffClick
      end
      object btnSetUnsetPPD: TButton
        Left = 2
        Top = 103
        Width = 80
        Height = 21
        Hint = 'Toggle the PPD Give/Take Status'
        HelpContext = 2223
        Caption = 'Set PP&D'
        TabOrder = 5
        OnClick = btnSetUnsetPPDClick
      end
    end
  end
  object PopupMenu1: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 640
    Top = 27
    object Tag1: TMenuItem
      Tag = 1
      Caption = '&Tag'
      OnClick = btnTagClick
    end
    object UnTAG1: TMenuItem
      Tag = 2
      Caption = '&Untag'
      OnClick = btnTagClick
    end
    object ReCalc1: TMenuItem
      Caption = '&Part Allocate'
      OnClick = btnPartAllocateClick
    end
    object Discount1: TMenuItem
      Caption = '&Discount'
      OnClick = btnWriteOffClick
    end
    object Find1: TMenuItem
      Caption = '&Find'
      OnClick = GenCP3BtnClick
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
end
