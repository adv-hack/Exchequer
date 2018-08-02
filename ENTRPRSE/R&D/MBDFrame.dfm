object MultiBuyDiscountFrame: TMultiBuyDiscountFrame
  Left = 0
  Top = 0
  Width = 388
  Height = 341
  TabOrder = 0
  object scrMBDList: TScrollBox
    Left = 2
    Top = 2
    Width = 357
    Height = 337
    VertScrollBar.Visible = False
    TabOrder = 0
    object mbdHedPanel: TSBSPanel
      Left = 2
      Top = 3
      Width = 504
      Height = 18
      BevelInner = bvLowered
      BevelOuter = bvNone
      Color = clWhite
      TabOrder = 0
      AllowReSize = False
      IsGroupBox = False
      TextId = 0
      Purpose = puBtrListColumnHeader
      object mdLabSCode: TSBSPanel
        Left = 2
        Top = 1
        Width = 88
        Height = 16
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
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        Purpose = puBtrListColumnHeader
      end
      object mdLabBuyQty: TSBSPanel
        Left = 92
        Top = 1
        Width = 47
        Height = 16
        BevelOuter = bvNone
        Caption = 'Buy Qty'
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
      object mdLabFreeQty: TSBSPanel
        Left = 150
        Top = 1
        Width = 53
        Height = 16
        BevelOuter = bvNone
        Caption = 'Free Qty'
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
      object mdLabPurchVal: TSBSPanel
        Left = 204
        Top = 1
        Width = 85
        Height = 16
        BevelOuter = bvNone
        Caption = 'Purchase Value'
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
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        Purpose = puBtrListColumnHeader
      end
      object mdLabDisc: TSBSPanel
        Left = 290
        Top = 1
        Width = 61
        Height = 16
        BevelOuter = bvNone
        Caption = 'Disc%'
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
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        Purpose = puBtrListColumnHeader
      end
      object mdLabDates: TSBSPanel
        Left = 362
        Top = 1
        Width = 137
        Height = 16
        BevelOuter = bvNone
        Caption = 'Effective'
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
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        Purpose = puBtrListColumnHeader
      end
    end
    object mdPanSCode: TSBSPanel
      Left = 2
      Top = 24
      Width = 87
      Height = 288
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
    object mdPanBuyQty: TSBSPanel
      Left = 92
      Top = 24
      Width = 55
      Height = 288
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
    object mdPanDisc: TSBSPanel
      Left = 294
      Top = 24
      Width = 61
      Height = 288
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
    object mdPanFreeQty: TSBSPanel
      Left = 150
      Top = 24
      Width = 55
      Height = 288
      BevelInner = bvLowered
      BevelOuter = bvLowered
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      AllowReSize = True
      IsGroupBox = False
      TextId = 0
      Purpose = puBtrListColumn
    end
    object mdPanPurchVal: TSBSPanel
      Left = 208
      Top = 24
      Width = 83
      Height = 288
      BevelInner = bvLowered
      BevelOuter = bvLowered
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
      AllowReSize = True
      IsGroupBox = False
      TextId = 0
      Purpose = puBtrListColumn
    end
    object mdPanDates: TSBSPanel
      Left = 358
      Top = 24
      Width = 145
      Height = 288
      BevelInner = bvLowered
      BevelOuter = bvLowered
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 6
      AllowReSize = True
      IsGroupBox = False
      TextId = 0
      Purpose = puBtrListColumn
    end
  end
  object mbdListBtnPanel: TSBSPanel
    Left = 360
    Top = 27
    Width = 18
    Height = 286
    BevelOuter = bvLowered
    TabOrder = 1
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
  end
  object mnuCopy: TPopupMenu
    Left = 72
    Top = 88
    object Fromanotheraccount1: TMenuItem
      Caption = 'From another account'
    end
    object osametypeaccounts1: TMenuItem
      Caption = 'To same type accounts'
      OnClick = osametypeaccounts1Click
    end
  end
end
