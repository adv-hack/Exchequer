object CISVList: TCISVList
  Left = 501
  Top = 182
  Width = 731
  Height = 360
  HelpContext = 1406
  Caption = 'Voucher List'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
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
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object CListBtnPanel: TSBSPanel
    Left = 594
    Top = 29
    Width = 18
    Height = 227
    BevelOuter = bvLowered
    TabOrder = 0
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
  end
  object CSBox: TScrollBox
    Left = 2
    Top = 2
    Width = 587
    Height = 277
    HorzScrollBar.Position = 357
    VertScrollBar.Tracking = True
    VertScrollBar.Visible = False
    TabOrder = 1
    object CHedPanel: TSBSPanel
      Left = -354
      Top = 3
      Width = 937
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
        Width = 47
        Height = 14
        HelpContext = 1413
        BevelOuter = bvNone
        Caption = 'Type'
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
        Left = 156
        Top = 4
        Width = 111
        Height = 14
        HelpContext = 1415
        BevelOuter = bvNone
        Caption = 'Voucher'
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
        Left = 51
        Top = 4
        Width = 103
        Height = 14
        HelpContext = 1414
        BevelOuter = bvNone
        Caption = 'Sub Contractor'
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
        Left = 269
        Top = 4
        Width = 64
        Height = 14
        HelpContext = 1416
        BevelOuter = bvNone
        Caption = 'Period'
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
        Left = 335
        Top = 4
        Width = 95
        Height = 14
        HelpContext = 1417
        Alignment = taRightJustify
        BevelOuter = bvNone
        Caption = 'Gross  '
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
      object CLSetCLab: TSBSPanel
        Left = 429
        Top = 4
        Width = 95
        Height = 14
        HelpContext = 1418
        Alignment = taRightJustify
        BevelOuter = bvNone
        Caption = 'Materials  '
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
      object CLVarLab: TSBSPanel
        Left = 617
        Top = 4
        Width = 95
        Height = 14
        HelpContext = 1420
        Alignment = taRightJustify
        BevelOuter = bvNone
        Caption = 'Tax Deducted  '
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
      object CLOSBLab: TSBSPanel
        Left = 794
        Top = 3
        Width = 118
        Height = 14
        HelpContext = 1422
        BevelOuter = bvNone
        Caption = 'Supplier'
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
      object CLOSCLab: TSBSPanel
        Left = 713
        Top = 4
        Width = 80
        Height = 14
        HelpContext = 1421
        BevelOuter = bvNone
        Caption = 'Ref'
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
      object CLLibLab: TSBSPanel
        Left = 522
        Top = 3
        Width = 95
        Height = 14
        HelpContext = 1419
        Alignment = taRightJustify
        BevelOuter = bvNone
        Caption = 'Tax Liable on  '
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
    end
    object CLORefPanel: TSBSPanel
      Left = -356
      Top = 25
      Width = 53
      Height = 229
      HelpContext = 1413
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
    object CLAMTPanel: TSBSPanel
      Left = -18
      Top = 25
      Width = 93
      Height = 229
      HelpContext = 1417
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
    object CLOSPAnel: TSBSPanel
      Left = -86
      Top = 25
      Width = 67
      Height = 229
      HelpContext = 1416
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
    object CLYRefPanel: TSBSPanel
      Left = -302
      Top = 25
      Width = 103
      Height = 229
      HelpContext = 1414
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
    object CLDuePanel: TSBSPanel
      Left = -198
      Top = 25
      Width = 111
      Height = 229
      HelpContext = 1415
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
    object CLSetCurrPanel: TSBSPanel
      Left = 76
      Top = 25
      Width = 93
      Height = 229
      HelpContext = 1418
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
    object CLVarPanel: TSBSPanel
      Left = 264
      Top = 25
      Width = 93
      Height = 229
      HelpContext = 1420
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
    object CLOSBPanel: TSBSPanel
      Left = 441
      Top = 25
      Width = 120
      Height = 229
      HelpContext = 1422
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
    object CLOSCPanel: TSBSPanel
      Left = 358
      Top = 25
      Width = 82
      Height = 229
      HelpContext = 1421
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
    object CLLibPanel: TSBSPanel
      Left = 170
      Top = 25
      Width = 93
      Height = 229
      HelpContext = 1419
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
  end
  object CBtnPanel: TSBSPanel
    Left = 616
    Top = 1
    Width = 102
    Height = 326
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 2
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
    object AutoLab: Label8
      Left = 3
      Top = 47
      Width = 90
      Height = 14
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TextId = 0
    end
    object ClsCP1Btn: TButton
      Left = 2
      Top = 26
      Width = 80
      Height = 21
      Hint = 'Close window|Closes the Customer/Supplier account window.'
      HelpContext = 1372
      Cancel = True
      Caption = 'C&lose'
      ModalResult = 2
      TabOrder = 0
      OnClick = ClsCP1BtnClick
    end
    object CCBSBox: TScrollBox
      Left = 0
      Top = 84
      Width = 99
      Height = 235
      HorzScrollBar.Visible = False
      BorderStyle = bsNone
      PopupMenu = PopupMenu1
      TabOrder = 1
      object FindCP1Btn: TButton
        Left = 2
        Top = 120
        Width = 80
        Height = 21
        Hint = 
          'Find a record on the list|Find searches the list of records for ' +
          'a match'
        HelpContext = 1428
        Caption = '&Find'
        TabOrder = 2
        OnClick = FindCP1BtnClick
      end
      object AlCP1Btn: TButton
        Tag = 3
        Left = 2
        Top = 3
        Width = 80
        Height = 21
        Hint = 'Add a new record|Ad a new tax record for an employee'
        HelpContext = 1423
        Caption = '&Add'
        TabOrder = 0
        OnClick = PACP1BtnClick
      end
      object PACP1Btn: TButton
        Tag = 5
        Left = 2
        Top = 26
        Width = 80
        Height = 21
        Hint = 'Edit record|Edit the currently selected record.'
        HelpContext = 1424
        Caption = '&Edit'
        TabOrder = 1
        OnClick = PACP1BtnClick
      end
      object MACP1Btn: TButton
        Left = 2
        Top = 143
        Width = 80
        Height = 21
        Hint = 
          'Match current record|Displays a list of all transactions matched' +
          ' against the currently highlighted record.'
        HelpContext = 1429
        Caption = '&Match/Unall.'
        TabOrder = 3
        OnClick = MACP1BtnClick
      end
      object SetCP1Btn: TButton
        Left = 2
        Top = 166
        Width = 80
        Height = 21
        Hint = 'Show notes|Shows the notes for the currently highlighted record.'
        Caption = '&Notes'
        TabOrder = 4
      end
      object DelCP1Btn: TButton
        Left = 2
        Top = 72
        Width = 80
        Height = 21
        Hint = 'Delete entry|Delete the currently selected record.'
        HelpContext = 1426
        Caption = '&Delete'
        TabOrder = 5
        OnClick = DelCP1BtnClick
      end
      object ViewCP1Btn: TButton
        Left = 2
        Top = 189
        Width = 80
        Height = 21
        Hint = 
          'View current record|View the currently selected record without e' +
          'diting it.'
        HelpContext = 1430
        Caption = '&View'
        TabOrder = 6
        OnClick = ViewCP1BtnClick
      end
      object CurCP1Btn: TButton
        Left = 2
        Top = 212
        Width = 80
        Height = 21
        Hint = 
          'Show links|Shows any linked records for the currently highlighte' +
          'd record.'
        HelpContext = 81
        Caption = 'Li&nks'
        TabOrder = 7
        OnClick = CurCP1BtnClick
      end
      object ChkCP1Btn: TButton
        Left = 2
        Top = 258
        Width = 80
        Height = 21
        Hint = 'Recalculate the screen totals|Recalculates the list totals.'
        HelpContext = 1432
        Caption = 'Chec&k'
        TabOrder = 9
        OnClick = ChkCP1BtnClick
      end
      object PrintCP1Btn: TButton
        Left = 2
        Top = 235
        Width = 80
        Height = 21
        Hint = 'Print record|Prints the currently selected record.'
        HelpContext = 1431
        Caption = '&Print'
        TabOrder = 8
        OnClick = PrintCP1BtnClick
      end
      object SetPayBtn: TButton
        Tag = 5
        Left = 1
        Top = 49
        Width = 80
        Height = 21
        Hint = 'Add Payment to record|Allows you to allocate a payment record.'
        HelpContext = 1425
        Caption = 'All&ocate PIN'
        TabOrder = 10
        OnClick = MACP1BtnClick
      end
      object FiltCP1Btn: TButton
        Left = 1
        Top = 96
        Width = 80
        Height = 21
        Hint = 
          'Find a record on the list|Find searches the list of records for ' +
          'a match'
        HelpContext = 1427
        Caption = 'F&ilter'
        TabOrder = 11
        OnClick = FiltCP1BtnClick
      end
    end
  end
  object TotPanel: TSBSPanel
    Left = 0
    Top = 284
    Width = 613
    Height = 44
    HelpContext = 1373
    TabOrder = 3
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
    DesignSize = (
      613
      44)
    object Label82: Label8
      Left = 490
      Top = 1
      Width = 111
      Height = 14
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      AutoSize = False
      Caption = 'Tax Deducted  '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Label84: Label8
      Left = 247
      Top = 1
      Width = 116
      Height = 14
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      AutoSize = False
      Caption = 'Gross  '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Label85: Label8
      Left = 368
      Top = 1
      Width = 116
      Height = 14
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      AutoSize = False
      Caption = 'Materials  '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object CBalF: TCurrencyEdit
      Left = 489
      Top = 16
      Width = 116
      Height = 22
      HelpContext = 40123
      TabStop = False
      Anchors = [akTop, akRight]
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      Lines.Strings = (
        '0.00 ')
      ParentFont = False
      ReadOnly = True
      TabOrder = 2
      WantReturns = False
      WordWrap = False
      AutoSize = False
      BlockNegative = False
      BlankOnZero = False
      DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
      ShowCurrency = True
      TextId = 0
      Value = 1E-10
    end
    object VarTotF: TCurrencyEdit
      Left = 247
      Top = 16
      Width = 116
      Height = 22
      HelpContext = 40122
      TabStop = False
      Anchors = [akTop, akRight]
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      Lines.Strings = (
        '0.00 ')
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
      WantReturns = False
      WordWrap = False
      AutoSize = False
      BlockNegative = False
      BlankOnZero = False
      DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
      ShowCurrency = True
      TextId = 0
      Value = 1E-10
    end
    object SDiscTotF: TCurrencyEdit
      Left = 368
      Top = 16
      Width = 116
      Height = 22
      HelpContext = 40122
      TabStop = False
      Anchors = [akTop, akRight]
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
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
      ShowCurrency = True
      TextId = 0
      Value = 1E-10
    end
  end
  object PopupMenu1: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 697
    Top = 65523
    object Allocate1: TMenuItem
      Tag = 3
      Caption = '&Add'
      OnClick = PACP1BtnClick
    end
    object ReCalc1: TMenuItem
      Tag = 5
      Caption = '&Edit'
      OnClick = PACP1BtnClick
    end
    object AllocatePIN1: TMenuItem
      Caption = 'All&ocate PIN'
      OnClick = MACP1BtnClick
    end
    object Unallocate1: TMenuItem
      Tag = 4
      Caption = '&Delete'
      OnClick = DelCP1BtnClick
    end
    object Filter1: TMenuItem
      Caption = 'F&ilter'
      OnClick = FiltCP1BtnClick
    end
    object Find1: TMenuItem
      Caption = '&Find'
      OnClick = FindCP1BtnClick
    end
    object Match1: TMenuItem
      Caption = '&Match/Unallocate'
      OnClick = MACP1BtnClick
    end
    object Settle1: TMenuItem
      Caption = '&Notes'
    end
    object View1: TMenuItem
      Caption = '&View'
      OnClick = ViewCP1BtnClick
    end
    object Currency1: TMenuItem
      Caption = 'Li&nks'
      OnClick = CurCP1BtnClick
    end
    object Print1: TMenuItem
      Caption = '&Print'
      OnClick = PrintCP1BtnClick
    end
    object Check1: TMenuItem
      Caption = 'Chec&k'
      OnClick = ChkCP1BtnClick
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
    OnPopup = PopupMenu1Popup
    Left = 680
    Top = 65523
    object NoFillter1: TMenuItem
      Caption = '&No Fillter'
      OnClick = NoFillter1Click
    end
    object CIS23: TMenuItem
      Tag = 5
      Caption = 'Filter on &CIS23'
      OnClick = NoFillter1Click
    end
    object CIS24: TMenuItem
      Tag = 6
      Caption = 'Filter on C&IS24'
      OnClick = NoFillter1Click
    end
    object CIS25: TMenuItem
      Tag = 4
      Caption = 'Filter on CI&S25'
      OnClick = NoFillter1Click
    end
    object RCTDC: TMenuItem
      Tag = 4
      Caption = 'Filter on &RCTDC'
      Visible = False
      OnClick = NoFillter1Click
    end
    object RCT47: TMenuItem
      Tag = 5
      Caption = 'Filter on R&CT47'
      Visible = False
      OnClick = NoFillter1Click
    end
  end
  object PopupMenu3: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 658
    Top = 65525
    object Print2: TMenuItem
      Tag = 4
      Caption = '&Print this '
      OnClick = Print2Click
    end
    object Print3: TMenuItem
      Tag = 5
      Caption = 'Print &All '
      OnClick = Print2Click
    end
  end
end
