object DiaryList: TDiaryList
  Left = 414
  Top = 294
  Width = 521
  Height = 347
  Caption = 'Notes'
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
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 505
    Height = 309
    Align = alClient
    TabOrder = 0
    object A1SBox: TScrollBox
      Left = 4
      Top = 2
      Width = 380
      Height = 307
      VertScrollBar.Visible = False
      TabOrder = 0
      object A1HedPanel: TSBSPanel
        Left = 2
        Top = 3
        Width = 397
        Height = 19
        BevelInner = bvLowered
        BevelOuter = bvNone
        TabOrder = 0
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        Purpose = puBtrListColumnHeader
        object ADateLab: TSBSPanel
          Left = 2
          Top = 2
          Width = 65
          Height = 16
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
          TabOrder = 0
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumnHeader
        end
        object ADescLab: TSBSPanel
          Left = 67
          Top = 1
          Width = 154
          Height = 16
          BevelOuter = bvNone
          Caption = 'Notes'
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
        object ASRCLab: TSBSPanel
          Left = 291
          Top = 2
          Width = 52
          Height = 16
          BevelOuter = bvNone
          Caption = 'Source'
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
        object AtoLab: TSBSPanel
          Left = 345
          Top = 2
          Width = 45
          Height = 16
          BevelOuter = bvNone
          Caption = 'To'
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
        object AUserLab: TSBSPanel
          Left = 223
          Top = 2
          Width = 68
          Height = 16
          BevelOuter = bvNone
          Caption = 'From'
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
      end
      object ADatePanel: TSBSPanel
        Left = 2
        Top = 26
        Width = 65
        Height = 258
        HelpContext = 112
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
      object ADescPanel: TSBSPanel
        Left = 70
        Top = 26
        Width = 153
        Height = 258
        HelpContext = 113
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
      object ASRCPanel: TSBSPanel
        Left = 278
        Top = 26
        Width = 67
        Height = 258
        HelpContext = 592
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
      object AUserPanel: TSBSPanel
        Left = 226
        Top = 26
        Width = 49
        Height = 258
        HelpContext = 579
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
      object AToPanel: TSBSPanel
        Left = 348
        Top = 26
        Width = 49
        Height = 258
        HelpContext = 579
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
    end
    object A1BtnPanel: TSBSPanel
      Left = 382
      Top = 1
      Width = 125
      Height = 308
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 1
      AllowReSize = False
      IsGroupBox = False
      TextId = 0
      object A1BsBox: TScrollBox
        Left = 34
        Top = 84
        Width = 86
        Height = 218
        HorzScrollBar.Visible = False
        BorderStyle = bsNone
        TabOrder = 0
        object EditN1Btn: TButton
          Left = 2
          Top = 25
          Width = 80
          Height = 21
          Hint = 
            'Edit current record|Edit the currently displayed record. Store a' +
            'ny changes with OK, abandon with Cancel.'
          HelpContext = 593
          Caption = '&Edit'
          TabOrder = 1
          OnClick = AddN1BtnClick
        end
        object DelN1Btn: TButton
          Left = 2
          Top = 72
          Width = 80
          Height = 21
          Hint = 'Delete record|Delete the currently selected record.'
          HelpContext = 77
          Caption = '&Delete'
          TabOrder = 3
          OnClick = DelN1BtnClick
        end
        object AddN1Btn: TButton
          Left = 2
          Top = 1
          Width = 80
          Height = 21
          Hint = 
            'Add a new record|Add a new record. Store with OK, abandon with C' +
            'ancel.'
          HelpContext = 593
          Caption = '&Add'
          TabOrder = 0
          OnClick = AddN1BtnClick
        end
        object InsN1Btn: TButton
          Left = 2
          Top = 49
          Width = 80
          Height = 21
          Hint = 
            'Insert a record|Inserts a new record at the current line. Simila' +
            'r to Add.'
          HelpContext = 593
          Caption = '&Insert'
          TabOrder = 2
          OnClick = AddN1BtnClick
        end
        object SwiN1Btn: TButton
          Left = 2
          Top = 96
          Width = 80
          Height = 21
          Hint = 
            'Switch Note view|Changes the notes view between dated notes and ' +
            'general notes.'
          HelpContext = 134
          Caption = 'S&witch'
          TabOrder = 4
          OnClick = SwiN1BtnClick
        end
        object ClrN1Btn: TButton
          Left = 2
          Top = 120
          Width = 80
          Height = 21
          Hint = 
            'Clear the note from the diary without deleting it from the origi' +
            'nal notepad'
          HelpContext = 594
          Caption = 'C&lear'
          TabOrder = 5
          OnClick = ClrN1BtnClick
        end
        object ViewN1Btn: TButton
          Left = 2
          Top = 144
          Width = 80
          Height = 21
          Hint = 'Drill-Down to the source of the note'
          HelpContext = 595
          Caption = '&View Source'
          TabOrder = 6
          OnClick = ViewN1BtnClick
        end
        object TelSN1Btn: TButton
          Left = 2
          Top = 168
          Width = 80
          Height = 21
          Hint = 'Jump directly into telesales to add an order for this customer'
          HelpContext = 134
          Caption = '&Telesales'
          TabOrder = 7
        end
      end
      object A1ListBtnPanel: TSBSPanel
        Left = 4
        Top = 28
        Width = 18
        Height = 257
        BevelOuter = bvLowered
        TabOrder = 1
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
      end
      object ClsN1Btn: TButton
        Left = 36
        Top = 3
        Width = 80
        Height = 21
        Hint = 'Close window|Closes the Customer/Supplier account window.'
        HelpContext = 24
        Cancel = True
        Caption = '&Close'
        ModalResult = 2
        TabOrder = 2
        OnClick = ClsN1BtnClick
      end
    end
  end
  object PopupMenu1: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 445
    Top = 36
    object Add1: TMenuItem
      Caption = '&Add'
      Hint = 
        'Choosing this option allows you to Add a new line which will be ' +
        'placed at the end of the adjustment.'
    end
    object Edit1: TMenuItem
      Tag = 1
      Caption = '&Edit'
      Hint = 
        'Choosing this option allows you to edit the currently highlighte' +
        'd line.'
      Visible = False
    end
    object Delete1: TMenuItem
      Caption = '&Delete'
      Hint = 
        'Choosing this option allows you to delete the currently highligh' +
        'ted line.'
    end
    object Insert1: TMenuItem
      Caption = '&Insert'
      Hint = 
        'Choosing this option allows you to Insert a new line before the ' +
        'currently highlighted line.'
    end
    object Switch1: TMenuItem
      Caption = '&Switch'
      Hint = 
        'Switches the display of the notepad between dated notepad, & gen' +
        'eral notepad.'
    end
    object Clear1: TMenuItem
      Caption = 'C&lear'
    end
    object View1: TMenuItem
      Caption = '&View'
      OnClick = ViewN1BtnClick
    end
    object TeleSales1: TMenuItem
      Caption = '&TeleSales'
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
