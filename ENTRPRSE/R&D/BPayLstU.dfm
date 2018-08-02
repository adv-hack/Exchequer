object BatchPay: TBatchPay
  Left = 296
  Top = 203
  Width = 744
  Height = 413
  HelpContext = 40158
  Caption = 'Batch'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
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
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 14
  object CSBox: TScrollBox
    Left = 2
    Top = 2
    Width = 595
    Height = 307
    VertScrollBar.Tracking = True
    VertScrollBar.Visible = False
    TabOrder = 0
    object CHedPanel: TSBSPanel
      Left = 1
      Top = 3
      Width = 588
      Height = 19
      BevelInner = bvLowered
      BevelOuter = bvNone
      Color = clWhite
      TabOrder = 0
      AllowReSize = False
      IsGroupBox = False
      TextId = 0
      Purpose = puBtrListColumnHeader
      object CLORefLab: TSBSPanel
        Left = 2
        Top = 2
        Width = 67
        Height = 14
        BevelOuter = bvNone
        Caption = 'A/C Code'
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
        OnMouseDown = CLORefLabMouseDown
        OnMouseMove = CLORefLabMouseMove
        OnMouseUp = CLORefPanelMouseUp
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        Purpose = puBtrListColumnHeader
      end
      object CLDateLab: TSBSPanel
        Left = 63
        Top = 2
        Width = 86
        Height = 14
        BevelOuter = bvNone
        Caption = 'Tagged'
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
        OnMouseDown = CLORefLabMouseDown
        OnMouseMove = CLORefLabMouseMove
        OnMouseUp = CLORefPanelMouseUp
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        Purpose = puBtrListColumnHeader
      end
      object CLAmtLab: TSBSPanel
        Left = 154
        Top = 2
        Width = 85
        Height = 14
        Alignment = taRightJustify
        BevelOuter = bvNone
        Caption = 'Not Due'
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
        OnMouseDown = CLORefLabMouseDown
        OnMouseMove = CLORefLabMouseMove
        OnMouseUp = CLORefPanelMouseUp
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        Purpose = puBtrListColumnHeader
      end
      object CLOSLab: TSBSPanel
        Left = 242
        Top = 2
        Width = 85
        Height = 14
        Alignment = taRightJustify
        BevelOuter = bvNone
        Caption = '1 Month'
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
        OnMouseDown = CLORefLabMouseDown
        OnMouseMove = CLORefLabMouseMove
        OnMouseUp = CLORefPanelMouseUp
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        Purpose = puBtrListColumnHeader
      end
      object CLTotLab: TSBSPanel
        Left = 327
        Top = 2
        Width = 85
        Height = 14
        Alignment = taRightJustify
        BevelOuter = bvNone
        Caption = '2 Months'
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
        OnMouseDown = CLORefLabMouseDown
        OnMouseMove = CLORefLabMouseMove
        OnMouseUp = CLORefPanelMouseUp
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        Purpose = puBtrListColumnHeader
      end
      object CLOrigLab: TSBSPanel
        Left = 413
        Top = 3
        Width = 85
        Height = 14
        Alignment = taRightJustify
        BevelOuter = bvNone
        Caption = '3 Months+'
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
        OnMouseDown = CLORefLabMouseDown
        OnMouseMove = CLORefLabMouseMove
        OnMouseUp = CLORefPanelMouseUp
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        Purpose = puBtrListColumnHeader
      end
      object lblTraderPPD: TSBSPanel
        Left = 505
        Top = 3
        Width = 80
        Height = 14
        BevelOuter = bvNone
        Caption = 'Trader PPD'
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
      Left = 1
      Top = 25
      Width = 60
      Height = 260
      HelpContext = 40111
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
      Left = 63
      Top = 25
      Width = 85
      Height = 260
      HelpContext = 40112
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
      Left = 152
      Top = 25
      Width = 88
      Height = 260
      HelpContext = 40113
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
      Left = 242
      Top = 25
      Width = 85
      Height = 260
      HelpContext = 40114
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
    object CLTotPanel: TSBSPanel
      Left = 329
      Top = 25
      Width = 85
      Height = 260
      HelpContext = 40114
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
    object CLOrigPanel: TSBSPanel
      Left = 416
      Top = 25
      Width = 85
      Height = 260
      HelpContext = 40114
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
    object pnlTraderPPD: TSBSPanel
      Left = 504
      Top = 25
      Width = 85
      Height = 260
      HelpContext = 2222
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
  end
  object CBtnPanel: TSBSPanel
    Left = 621
    Top = 2
    Width = 102
    Height = 307
    BevelOuter = bvNone
    ParentColor = True
    PopupMenu = PopupMenu1
    TabOrder = 1
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
    object ClsCP1Btn: TButton
      Left = 2
      Top = 23
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
      Height = 241
      HorzScrollBar.Visible = False
      BorderStyle = bsNone
      TabOrder = 1
      object Bevel2: TBevel
        Left = 4
        Top = 60
        Width = 77
        Height = 9
        Shape = bsTopLine
      end
      object Bevel3: TBevel
        Left = 4
        Top = 118
        Width = 77
        Height = 9
        Shape = bsTopLine
      end
      object EditCP1Btn: TButton
        Tag = 2
        Left = 2
        Top = 32
        Width = 80
        Height = 21
        Hint = 
          'Untag the currently highlighted row and column|Untagging the cur' +
          'rently highlighted row and column cancels the previous tag.'
        HelpContext = 40116
        Caption = '&Untag'
        TabOrder = 1
        OnClick = AddCP1BtnClick
      end
      object DelCP1Btn: TButton
        Tag = 5
        Left = 2
        Top = 90
        Width = 80
        Height = 21
        Hint = 
          'Clear several, or all previous column Tags|Clear allows you to c' +
          'ancel any previous wild tags.'
        HelpContext = 40118
        Caption = 'Cle&ar Wild Tag'
        TabOrder = 3
        OnClick = InsCP3BtnClick
      end
      object HistCP1Btn: TButton
        Left = 2
        Top = 125
        Width = 80
        Height = 21
        Hint = 
          'Recalculate the Batch List|Resets the Batch list, cancelling any' +
          ' previous tagged entries.'
        HelpContext = 40120
        Caption = '&Re-Calc'
        TabOrder = 4
        OnClick = HistCP1BtnClick
      end
      object AddCP1Btn: TButton
        Tag = 1
        Left = 2
        Top = 9
        Width = 80
        Height = 21
        Hint = 
          'Tag the currently highlighted row and column|Tagging the current' +
          'ly highlighted row and column means that any invoices which are ' +
          'due within that column will get paid.'
        HelpContext = 40115
        Caption = '&Tag'
        TabOrder = 0
        OnClick = AddCP1BtnClick
      end
      object InsCP3Btn: TButton
        Tag = 4
        Left = 2
        Top = 67
        Width = 80
        Height = 21
        Hint = 
          'Wild Tag several, or all columns|Wild Tagging allows you to pay ' +
          'off all accounts within a given column, or all columns.'
        HelpContext = 40117
        Caption = '&Wild Tag'
        TabOrder = 2
        OnClick = InsCP3BtnClick
      end
      object GenCP3Btn: TButton
        Left = 2
        Top = 148
        Width = 80
        Height = 21
        Hint = 
          'Find an account within the list|Searches for a specified account' +
          ' within the batch payments list.'
        HelpContext = 40121
        Caption = '&Find'
        TabOrder = 5
        OnClick = GenCP3BtnClick
      end
      object BPCustBtn1: TSBSButton
        Left = 2
        Top = 171
        Width = 80
        Height = 21
        Caption = 'Custom1'
        TabOrder = 6
        Visible = False
        OnClick = BPCustBtn1Click
        TextId = 15
      end
    end
    object FindCP1Btn: TButton
      Left = 2
      Top = 0
      Width = 80
      Height = 21
      Hint = 
        'Process Payments|Process all tagged items, generating and alloca' +
        'ting a Purchase Payement, or Sales Receipt for each tagged Accou' +
        'nt.'
      HelpContext = 40119
      Caption = '&Process'
      TabOrder = 2
      OnClick = FindCP1BtnClick
    end
  end
  object CListBtnPanel: TSBSPanel
    Left = 598
    Top = 30
    Width = 18
    Height = 258
    BevelOuter = bvLowered
    TabOrder = 2
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
  end
  object SBSPanel1: TSBSPanel
    Left = 0
    Top = 316
    Width = 728
    Height = 59
    Align = alBottom
    TabOrder = 3
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
    object Bevel1: TBevel
      Left = 2
      Top = 28
      Width = 595
      Height = 11
      Shape = bsTopLine
    end
    object Label81: Label8
      Left = 15
      Top = 35
      Width = 96
      Height = 14
      AutoSize = False
      Caption = 'Company Name'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Label82: Label8
      Left = 346
      Top = 35
      Width = 39
      Height = 14
      Caption = 'Balance'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Label83: Label8
      Left = 17
      Top = 8
      Width = 39
      Height = 14
      AutoSize = False
      Caption = 'Totals'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object CompF: Text8Pt
      Left = 120
      Top = 32
      Width = 209
      Height = 22
      TabStop = False
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
      TextId = 0
      ViaSBtn = False
    end
    object CBalF: TCurrencyEdit
      Left = 390
      Top = 32
      Width = 113
      Height = 22
      HelpContext = 40123
      TabStop = False
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
    object M3Tot: TCurrencyEdit
      Left = 420
      Top = 4
      Width = 83
      Height = 22
      HelpContext = 40122
      TabStop = False
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
    object M2Tot: TCurrencyEdit
      Left = 333
      Top = 4
      Width = 83
      Height = 22
      HelpContext = 40122
      TabStop = False
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
      TabOrder = 3
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
    object M1Tot: TCurrencyEdit
      Left = 246
      Top = 4
      Width = 83
      Height = 22
      HelpContext = 40122
      TabStop = False
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
      TabOrder = 4
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
    object NDTot: TCurrencyEdit
      Left = 159
      Top = 4
      Width = 83
      Height = 22
      HelpContext = 40122
      TabStop = False
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
      TabOrder = 5
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
    object TagTot: TCurrencyEdit
      Left = 70
      Top = 4
      Width = 83
      Height = 22
      HelpContext = 40122
      TabStop = False
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
      TabOrder = 6
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
    Left = 560
    Top = 312
    object Tag1: TMenuItem
      Tag = 1
      Caption = '&Tag'
      OnClick = AddCP1BtnClick
    end
    object UnTAG1: TMenuItem
      Tag = 2
      Caption = '&Untag'
      OnClick = AddCP1BtnClick
    end
    object WildTag1: TMenuItem
      Tag = 4
      Caption = '&Wild Tag'
      OnClick = WildTag1Click
    end
    object Clear1: TMenuItem
      Tag = 5
      Caption = 'Cle&ar'
      OnClick = WildTag1Click
    end
    object Process1: TMenuItem
      Caption = '&Process'
      OnClick = FindCP1BtnClick
    end
    object ReCalc1: TMenuItem
      Caption = '&Re-Calc'
      OnClick = HistCP1BtnClick
    end
    object Find1: TMenuItem
      Caption = '&Find'
      OnClick = GenCP3BtnClick
    end
    object Custom1: TMenuItem
      Caption = 'Custom1'
      Visible = False
      OnClick = BPCustBtn1Click
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
    Left = 533
    Top = 312
    object Due1: TMenuItem
      Tag = -1
      Caption = '&Due'
      OnClick = Due1Click
    end
    object NotDue1: TMenuItem
      Tag = 2
      Caption = '&Not Due'
      OnClick = Due1Click
    end
    object Wk1: TMenuItem
      Tag = 3
      Caption = '&1 Week'
      OnClick = Due1Click
    end
    object Wk2: TMenuItem
      Tag = 4
      Caption = '&2 Weeks'
      OnClick = Due1Click
    end
    object Wk3: TMenuItem
      Tag = 5
      Caption = '&3 Weeks+'
      OnClick = Due1Click
    end
    object Total1: TMenuItem
      Tag = -2
      Caption = '&Total'
      OnClick = Due1Click
    end
    object mniTransactionDate: TMenuItem
      Tag = 6
      Caption = 'Transaction Date'
      OnClick = Due1Click
    end
    object mniDueDate: TMenuItem
      Tag = 7
      Caption = 'Due Date'
      OnClick = Due1Click
    end
  end
  object EntCustom1: TCustomisation
    DLLId = SysDll_Ent
    Enabled = True
    ExportPath = 'X:\ENTRPRSE\CUSTOM\DEMOHOOK\Daybk1.RC'
    WindowId = 101000
    Left = 504
    Top = 340
  end
  object PopupMenu3: TPopupMenu
    Left = 507
    Top = 312
    object RC1: TMenuItem
      Tag = 1
      Caption = 'ReCalc &this Account'
      OnClick = RC1Click
    end
    object RC2: TMenuItem
      Caption = 'ReCalc &all Accounts'
      OnClick = RC1Click
    end
  end
end
