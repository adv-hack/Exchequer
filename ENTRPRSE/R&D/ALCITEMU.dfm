object AllocItems: TAllocItems
  Left = 221
  Top = 401
  Width = 739
  Height = 365
  HelpContext = 1371
  Caption = 'Allocation List'
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
    Height = 202
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
    Height = 250
    VertScrollBar.Tracking = True
    VertScrollBar.Visible = False
    TabOrder = 1
    object CHedPanel: TSBSPanel
      Left = 1
      Top = 3
      Width = 1267
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
        Top = 4
        Width = 67
        Height = 14
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
      object CLYRefLab: TSBSPanel
        Left = 70
        Top = 4
        Width = 71
        Height = 14
        BevelOuter = bvNone
        Caption = 'Your Ref'
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
        Left = 207
        Top = 4
        Width = 95
        Height = 14
        Alignment = taRightJustify
        BevelOuter = bvNone
        Caption = 'Outstanding'
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
      object CLAMTLab: TSBSPanel
        Left = 302
        Top = 4
        Width = 95
        Height = 14
        Alignment = taRightJustify
        BevelOuter = bvNone
        Caption = 'Settle this Run  '
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
      object CLDateLab: TSBSPanel
        Left = 859
        Top = 3
        Width = 58
        Height = 14
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
        Left = 780
        Top = 3
        Width = 76
        Height = 14
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
        TabOrder = 6
        OnMouseDown = CLORefLabMouseDown
        OnMouseMove = CLORefLabMouseMove
        OnMouseUp = CLORefPanelMouseUp
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        Purpose = puBtrListColumnHeader
      end
      object CLSetCLab: TSBSPanel
        Left = 398
        Top = 4
        Width = 95
        Height = 14
        Alignment = taRightJustify
        BevelOuter = bvNone
        Caption = 'Settle Currency '
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
        OnMouseDown = CLORefLabMouseDown
        OnMouseMove = CLORefLabMouseMove
        OnMouseUp = CLORefPanelMouseUp
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        Purpose = puBtrListColumnHeader
      end
      object CLVarLab: TSBSPanel
        Left = 492
        Top = 4
        Width = 95
        Height = 14
        Alignment = taRightJustify
        BevelOuter = bvNone
        Caption = 'Variance '
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
        OnMouseDown = CLORefLabMouseDown
        OnMouseMove = CLORefLabMouseMove
        OnMouseUp = CLORefPanelMouseUp
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        Purpose = puBtrListColumnHeader
      end
      object CLOSBLab: TSBSPanel
        Left = 587
        Top = 3
        Width = 95
        Height = 14
        Alignment = taRightJustify
        BevelOuter = bvNone
        Caption = 'O/S Base Curr.'
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
        OnMouseDown = CLORefLabMouseDown
        OnMouseMove = CLORefLabMouseMove
        OnMouseUp = CLORefPanelMouseUp
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        Purpose = puBtrListColumnHeader
      end
      object CLOSCLab: TSBSPanel
        Left = 681
        Top = 3
        Width = 95
        Height = 14
        Alignment = taRightJustify
        BevelOuter = bvNone
        Caption = 'O/S Own Curr.'
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
        OnMouseDown = CLORefLabMouseDown
        OnMouseMove = CLORefLabMouseMove
        OnMouseUp = CLORefPanelMouseUp
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        Purpose = puBtrListColumnHeader
      end
      object panPPDAvailableHed: TSBSPanel
        Left = 925
        Top = 5
        Width = 95
        Height = 14
        Alignment = taRightJustify
        BevelOuter = bvNone
        Caption = 'PPD Available '
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
        OnMouseDown = CLORefLabMouseDown
        OnMouseMove = CLORefLabMouseMove
        OnMouseUp = CLORefPanelMouseUp
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        Purpose = puBtrListColumnHeader
      end
      object panTotWithPPDHed: TSBSPanel
        Left = 1021
        Top = 5
        Width = 95
        Height = 14
        Alignment = taRightJustify
        BevelOuter = bvNone
        Caption = 'O/S after PPD '
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
        OnMouseDown = CLORefLabMouseDown
        OnMouseMove = CLORefLabMouseMove
        OnMouseUp = CLORefPanelMouseUp
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        Purpose = puBtrListColumnHeader
      end
      object panPPDExpiryHed: TSBSPanel
        Left = 1123
        Top = 5
        Width = 58
        Height = 14
        BevelOuter = bvNone
        Caption = 'PPD Expiry'
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
        OnMouseDown = CLORefLabMouseDown
        OnMouseMove = CLORefLabMouseMove
        OnMouseUp = CLORefPanelMouseUp
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        Purpose = puBtrListColumnHeader
      end
      object panPPDStatusHed: TSBSPanel
        Left = 1188
        Top = 5
        Width = 76
        Height = 14
        BevelOuter = bvNone
        Caption = 'PPD Status'
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
      Width = 69
      Height = 198
      HelpContext = 142
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
      Left = 861
      Top = 25
      Width = 67
      Height = 198
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
      TabOrder = 9
      OnMouseUp = CLORefPanelMouseUp
      AllowReSize = True
      IsGroupBox = False
      TextId = 0
      Purpose = puBtrListColumn
    end
    object CLAMTPanel: TSBSPanel
      Left = 307
      Top = 25
      Width = 93
      Height = 198
      HelpContext = 40128
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
      Left = 212
      Top = 25
      Width = 93
      Height = 198
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
      Left = 782
      Top = 25
      Width = 77
      Height = 198
      HelpContext = 40129
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
    object CLYRefPanel: TSBSPanel
      Left = 72
      Top = 25
      Width = 69
      Height = 198
      HelpContext = 5148
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
      Left = 143
      Top = 25
      Width = 67
      Height = 198
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
      TabOrder = 3
      OnMouseUp = CLORefPanelMouseUp
      AllowReSize = True
      IsGroupBox = False
      TextId = 0
      Purpose = puBtrListColumn
    end
    object CLSetCurrPanel: TSBSPanel
      Left = 402
      Top = 25
      Width = 93
      Height = 198
      HelpContext = 40128
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
      Left = 497
      Top = 25
      Width = 93
      Height = 198
      HelpContext = 40128
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
      Left = 592
      Top = 25
      Width = 93
      Height = 198
      HelpContext = 40128
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
    object CLOSCPanel: TSBSPanel
      Left = 687
      Top = 25
      Width = 93
      Height = 198
      HelpContext = 40128
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
    object panPPDAvailable: TSBSPanel
      Left = 930
      Top = 25
      Width = 93
      Height = 198
      HelpContext = 40128
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
      OnMouseUp = CLORefPanelMouseUp
      AllowReSize = True
      IsGroupBox = False
      TextId = 0
      Purpose = puBtrListColumn
    end
    object panTotWithPPD: TSBSPanel
      Left = 1025
      Top = 25
      Width = 93
      Height = 198
      HelpContext = 40128
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
      OnMouseUp = CLORefPanelMouseUp
      AllowReSize = True
      IsGroupBox = False
      TextId = 0
      Purpose = puBtrListColumn
    end
    object panPPDExpiry: TSBSPanel
      Left = 1120
      Top = 25
      Width = 67
      Height = 198
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
      TabOrder = 14
      OnMouseUp = CLORefPanelMouseUp
      AllowReSize = True
      IsGroupBox = False
      TextId = 0
      Purpose = puBtrListColumn
    end
    object panPPDStatus: TSBSPanel
      Left = 1189
      Top = 25
      Width = 77
      Height = 198
      HelpContext = 40129
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
      OnMouseUp = CLORefPanelMouseUp
      AllowReSize = True
      IsGroupBox = False
      TextId = 0
      Purpose = puBtrListColumn
    end
  end
  object CBtnPanel: TSBSPanel
    Left = 616
    Top = 0
    Width = 102
    Height = 307
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
      TabOrder = 1
      OnClick = ClsCP1BtnClick
    end
    object CCBSBox: TScrollBox
      Left = 0
      Top = 84
      Width = 99
      Height = 215
      HorzScrollBar.Visible = False
      BorderStyle = bsNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      PopupMenu = PopupMenu1
      TabOrder = 2
      object FindCP1Btn: TButton
        Left = 2
        Top = 95
        Width = 80
        Height = 21
        Hint = 
          'Find a transaction on the list by Our Ref, or YourRef|Find searc' +
          'hes the list of transactions for a match by Our Ref, or Your Ref' +
          '.'
        HelpContext = 1328
        Caption = '&Find'
        TabOrder = 4
        OnClick = FindCP1BtnClick
      end
      object SDiscBtn: TButton
        Left = 2
        Top = 72
        Width = 80
        Height = 21
        Hint = 
          'Write-off the currently highlighted transaction|Allows you to sp' +
          'ecify an additional discount for the currently highlighted trans' +
          'action'
        HelpContext = 1377
        Caption = '&Write-off'
        TabOrder = 3
        OnClick = SDiscBtnClick
      end
      object AlCP1Btn: TButton
        Tag = 3
        Left = 2
        Top = 3
        Width = 80
        Height = 21
        Hint = 
          'Allocate transaction|Allocates the currently selected transactio' +
          'n if there is an amount outstanding.'
        HelpContext = 1374
        Caption = '<--    &Allocate'
        TabOrder = 0
        OnClick = AlCP1BtnClick
      end
      object PACP1Btn: TButton
        Tag = 5
        Left = 2
        Top = 26
        Width = 80
        Height = 21
        Hint = 
          'Part allocate transaction|Part allocate a specified amount again' +
          'st the currently selected transaction.'
        HelpContext = 1375
        Caption = '<?  &Part Alloc'
        TabOrder = 1
        OnClick = AlCP1BtnClick
      end
      object UACP1Btn: TButton
        Tag = 4
        Left = 2
        Top = 49
        Width = 80
        Height = 21
        Hint = 
          'Unallocate transaction|Unallocate the amount settled for the cur' +
          'rently selected transaction.'
        HelpContext = 1376
        Caption = '--> &Unallocate'
        TabOrder = 2
        OnClick = AlCP1BtnClick
      end
      object MACP1Btn: TButton
        Left = 2
        Top = 118
        Width = 80
        Height = 21
        Hint = 
          'Match current transaction|Displays a list of all transactions al' +
          'located against the currently highlighted transaction.'
        HelpContext = 1380
        Caption = '&Match'
        TabOrder = 5
        OnClick = MACP1BtnClick
      end
      object SetCP1Btn: TButton
        Left = 2
        Top = 141
        Width = 80
        Height = 21
        Hint = 
          'Allocate all outstanding transactions|Automaticaly allocates as ' +
          'many outstanding transactions as possible.'
        HelpContext = 1381
        Caption = '&Settle'
        TabOrder = 6
        OnClick = SetCP1BtnClick
      end
      object DelCP1Btn: TButton
        Left = 2
        Top = 164
        Width = 80
        Height = 21
        Hint = 
          'Remove entry|Remove the currently selected record from this list' +
          '. Original transaction unaffected.'
        HelpContext = 1382
        Caption = '&Remove'
        TabOrder = 7
        OnClick = DelCP1BtnClick
      end
      object ViewCP1Btn: TButton
        Left = 2
        Top = 187
        Width = 80
        Height = 21
        Hint = 
          'View current transaction|View the currently selected transaction' +
          ' without editing it, allowing list scanning.'
        HelpContext = 1383
        Caption = '&View'
        TabOrder = 8
        OnClick = ViewCP1BtnClick
      end
      object CurCP1Btn: TButton
        Left = 2
        Top = 210
        Width = 80
        Height = 21
        Hint = 
          'Change currency view|Allows the current ledger view to be change' +
          'd to another currency.'
        HelpContext = 1384
        Caption = '&Currency'
        TabOrder = 9
        OnClick = CurCP1BtnClick
      end
      object ChkCP1Btn: TButton
        Left = 2
        Top = 279
        Width = 80
        Height = 21
        Hint = 'Recalculate the screen totals|Recalculates the list totals.'
        HelpContext = 1386
        Caption = 'C&heck'
        TabOrder = 12
        OnClick = ChkCP1BtnClick
      end
      object PrintCP1Btn: TButton
        Left = 2
        Top = 233
        Width = 80
        Height = 21
        Hint = 
          'Print list of allocations|Prints a list showing all the allocati' +
          'ons which will be made when the list is processed'
        HelpContext = 1385
        Caption = '&Print'
        TabOrder = 10
        OnClick = PrintCP1BtnClick
      end
      object CalcCP1Btn: TButton
        Left = 2
        Top = 302
        Width = 80
        Height = 21
        Hint = 
          'Regenerate the Allocation List|Resets the Allocation list, cance' +
          'lling any previous entries.'
        HelpContext = 1387
        Caption = 'R&e-Calc'
        TabOrder = 13
        OnClick = CalcCP1BtnClick
      end
      object SetSplitBtn: TButton
        Left = 1
        Top = 256
        Width = 80
        Height = 21
        Hint = 
          'Set additional payment split details|Set additional payment spli' +
          't details'
        HelpContext = 1570
        Caption = 'Se&t Pay Split'
        TabOrder = 11
        OnClick = SetSplitBtnClick
      end
    end
    object GenCP1Btn: TButton
      Left = 2
      Top = 3
      Width = 80
      Height = 21
      Hint = 
        'Process Allocations|Process all settled items, generating and al' +
        'locating a Purchase Payement, or Sales Receipt.'
      HelpContext = 1370
      Caption = 'Pr&ocess'
      TabOrder = 0
      OnClick = GenCP1BtnClick
    end
  end
  object TotPanel: TSBSPanel
    Left = 0
    Top = 257
    Width = 613
    Height = 70
    HelpContext = 1373
    BevelOuter = bvNone
    TabOrder = 3
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
    object Label82: Label8
      Left = 491
      Top = 1
      Width = 111
      Height = 14
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Account Balance'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Label83: Label8
      Left = 6
      Top = 1
      Width = 115
      Height = 14
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Amount to Allocate  '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Label81: Label8
      Left = 127
      Top = 1
      Width = 116
      Height = 14
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Unallocated  '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Label84: Label8
      Left = 248
      Top = 1
      Width = 116
      Height = 14
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Variance  '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Label85: Label8
      Left = 369
      Top = 1
      Width = 116
      Height = 14
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Settlement Write-Off'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object CBalF: TCurrencyEdit
      Left = 490
      Top = 16
      Width = 116
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
    object DocTotF: TCurrencyEdit
      Left = 5
      Top = 16
      Width = 116
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
    object UnalTotF: TCurrencyEdit
      Left = 127
      Top = 16
      Width = 116
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
    object VarTotF: TCurrencyEdit
      Left = 248
      Top = 16
      Width = 116
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
    object SDiscTotF: TCurrencyEdit
      Left = 369
      Top = 16
      Width = 116
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
    object DocCF: TCurrencyEdit
      Left = 5
      Top = 44
      Width = 116
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
    object UnalCF: TCurrencyEdit
      Left = 127
      Top = 44
      Width = 116
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
    object CBalCF: TCurrencyEdit
      Left = 490
      Top = 44
      Width = 116
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
      TabOrder = 7
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
    object SDiscCF: TCurrencyEdit
      Left = 369
      Top = 44
      Width = 116
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
      TabOrder = 8
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
    Left = 535
    Top = 50
    object Allocate1: TMenuItem
      Tag = 3
      Caption = '&Allocate'
      OnClick = AlCP1BtnClick
    end
    object ReCalc1: TMenuItem
      Tag = 5
      Caption = '&Part Allocate'
      OnClick = AlCP1BtnClick
    end
    object Unallocate1: TMenuItem
      Tag = 4
      Caption = '&Unallocate'
      OnClick = AlCP1BtnClick
    end
    object Discount1: TMenuItem
      Caption = '&Write-off'
      OnClick = SDiscBtnClick
    end
    object Find1: TMenuItem
      Caption = '&Find'
      OnClick = FindCP1BtnClick
    end
    object Match1: TMenuItem
      Caption = '&Match'
    end
    object Settle1: TMenuItem
      Caption = '&Settle'
      OnClick = SetCP1BtnClick
    end
    object Remove1: TMenuItem
      Caption = '&Remove'
      OnClick = DelCP1BtnClick
    end
    object View1: TMenuItem
      Caption = '&View'
      OnClick = ViewCP1BtnClick
    end
    object Currency1: TMenuItem
      Caption = '&Currency'
      OnClick = CurCP1BtnClick
    end
    object Print1: TMenuItem
      Caption = '&Print'
      OnClick = PrintCP1BtnClick
    end
    object SetPaysplit1: TMenuItem
      Caption = 'Se&t Pay Split'
      OnClick = SetSplitBtnClick
    end
    object Check1: TMenuItem
      Caption = 'C&heck'
      OnClick = ChkCP1BtnClick
    end
    object ReCalc2: TMenuItem
      Caption = 'R&e-Calc'
      OnClick = CalcCP1BtnClick
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
  object PPDAllocationMenu: TPopupMenu
    Left = 536
    Top = 88
    object Allocate2: TMenuItem
      Caption = 'Allocate'
      OnClick = Allocate2Click
    end
    object akePPD1: TMenuItem
      Caption = 'Take PPD'
      OnClick = akePPD1Click
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object Cancel1: TMenuItem
      Caption = 'Cancel'
    end
  end
end
