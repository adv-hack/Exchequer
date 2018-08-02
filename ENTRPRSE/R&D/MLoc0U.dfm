object LocnList: TLocnList
  Left = 397
  Top = 168
  Width = 421
  Height = 275
  HelpContext = 501
  Caption = 'Multi Location Stock'
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
  OnActivate = FormActivate
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
    Top = 0
    Width = 411
    Height = 248
    ActivePage = LocPage
    TabIndex = 0
    TabOrder = 0
    OnChange = PageControl1Change
    OnChanging = PageControl1Changing
    object LocPage: TTabSheet
      Caption = 'Locations'
      object CSBox: TScrollBox
        Left = 1
        Top = 4
        Width = 273
        Height = 213
        VertScrollBar.Visible = False
        TabOrder = 0
        object LoPanel: TSBSPanel
          Left = 4
          Top = 24
          Width = 47
          Height = 167
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          OnMouseUp = LoPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object DePanel: TSBSPanel
          Left = 54
          Top = 24
          Width = 216
          Height = 167
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          OnMouseUp = LoPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object CHedPanel: TSBSPanel
          Left = 2
          Top = 2
          Width = 266
          Height = 19
          BevelOuter = bvLowered
          Caption = 'CHedPanel'
          TabOrder = 0
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumnHeader
          object DeLab: TSBSPanel
            Left = 50
            Top = 3
            Width = 193
            Height = 14
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
            TabOrder = 1
            OnMouseDown = LoLabMouseDown
            OnMouseMove = LoLabMouseMove
            OnMouseUp = LoPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object LoLab: TSBSPanel
            Left = 2
            Top = 3
            Width = 39
            Height = 14
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
            TabOrder = 0
            OnMouseDown = LoLabMouseDown
            OnMouseMove = LoLabMouseMove
            OnMouseUp = LoPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
        end
      end
    end
    object SLocPage: TTabSheet
      Caption = 'Stock at Locations'
      object CS2Box: TScrollBox
        Left = 1
        Top = 4
        Width = 274
        Height = 213
        VertScrollBar.Visible = False
        TabOrder = 0
        object sloPanel: TSBSPanel
          Left = 2
          Top = 24
          Width = 33
          Height = 167
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          OnMouseUp = LoPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object sdePanel: TSBSPanel
          Left = 38
          Top = 24
          Width = 95
          Height = 167
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          OnMouseUp = LoPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object C2HedPanel: TSBSPanel
          Left = 2
          Top = 2
          Width = 266
          Height = 19
          BevelOuter = bvLowered
          TabOrder = 0
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumnHeader
          object sdeLab: TSBSPanel
            Left = 37
            Top = 3
            Width = 93
            Height = 14
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
            TabOrder = 1
            OnMouseDown = LoLabMouseDown
            OnMouseMove = LoLabMouseMove
            OnMouseUp = LoPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object sloLab: TSBSPanel
            Left = 2
            Top = 3
            Width = 31
            Height = 14
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
            TabOrder = 0
            OnMouseDown = LoLabMouseDown
            OnMouseMove = LoLabMouseMove
            OnMouseUp = LoPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object sISLab: TSBSPanel
            Left = 134
            Top = 3
            Width = 42
            Height = 14
            BevelOuter = bvNone
            Caption = 'In Stk'
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 2
            OnMouseDown = LoLabMouseDown
            OnMouseMove = LoLabMouseMove
            OnMouseUp = LoPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object SFLab: TSBSPanel
            Left = 180
            Top = 3
            Width = 42
            Height = 14
            BevelOuter = bvNone
            Caption = 'Free'
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 3
            OnMouseDown = LoLabMouseDown
            OnMouseMove = LoLabMouseMove
            OnMouseUp = LoPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object SOLab: TSBSPanel
            Left = 223
            Top = 3
            Width = 42
            Height = 14
            BevelOuter = bvNone
            Caption = 'On Ord'
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 4
            OnMouseDown = LoLabMouseDown
            OnMouseMove = LoLabMouseMove
            OnMouseUp = LoPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
        end
        object sISPanel: TSBSPanel
          Left = 136
          Top = 24
          Width = 42
          Height = 167
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          OnMouseUp = LoPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object SFPanel: TSBSPanel
          Left = 181
          Top = 24
          Width = 42
          Height = 167
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
          OnMouseUp = LoPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object SOPanel: TSBSPanel
          Left = 226
          Top = 24
          Width = 42
          Height = 167
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 5
          OnMouseUp = LoPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
      end
    end
  end
  object CBtnPanel: TSBSPanel
    Left = 279
    Top = 28
    Width = 123
    Height = 213
    BevelOuter = bvLowered
    PopupMenu = PopupMenu1
    TabOrder = 1
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
    object I1StatLab: Label8
      Left = 24
      Top = 3
      Width = 95
      Height = 49
      Alignment = taCenter
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object CListBtnPanel: TSBSPanel
      Left = 2
      Top = 25
      Width = 18
      Height = 167
      BevelOuter = bvLowered
      TabOrder = 0
      AllowReSize = False
      IsGroupBox = False
      TextId = 0
    end
    object CCBSBox: TScrollBox
      Left = 22
      Top = 81
      Width = 100
      Height = 130
      HorzScrollBar.Visible = False
      BorderStyle = bsNone
      Color = clBtnFace
      ParentColor = False
      TabOrder = 2
      object AddBtn: TButton
        Tag = 1
        Left = 0
        Top = 3
        Width = 80
        Height = 21
        Hint = 
          'Add a new Stock Location record|Adds a new Stock Location record' +
          ' to the current database. The entries are sorted in code order.'
        HelpContext = 511
        Caption = '&Add'
        TabOrder = 0
        OnClick = AddBtnClick
      end
      object EditBtn: TButton
        Tag = 2
        Left = 0
        Top = 27
        Width = 80
        Height = 21
        Hint = 
          'Change exisiting Record|Allows the currently highlighted record ' +
          'to be changed.'
        HelpContext = 509
        Caption = '&Edit'
        TabOrder = 1
        OnClick = AddBtnClick
      end
      object DelBtn: TButton
        Tag = 3
        Left = 0
        Top = 51
        Width = 80
        Height = 21
        Hint = 
          'Delete Record|Allows the currently highlighted record to be dele' +
          'ted.'
        HelpContext = 510
        Caption = '&Delete'
        TabOrder = 2
        OnClick = AddBtnClick
      end
      object TagBtn: TButton
        Tag = 3
        Left = 0
        Top = 147
        Width = 80
        Height = 21
        Hint = 'Tag Location|Used for Reporting purposes'
        Caption = '&Tag'
        TabOrder = 3
      end
      object ClrBtn: TButton
        Tag = 3
        Left = 0
        Top = 171
        Width = 80
        Height = 21
        Hint = 'Clear Tag|Allows the currently highlighted record to be deleted.'
        Caption = 'C&lear Tag'
        TabOrder = 4
      end
      object MoveBtn: TButton
        Tag = 3
        Left = 0
        Top = 123
        Width = 80
        Height = 21
        Hint = 
          'Transfer non-Locn Stock|Used to transfer stock levels to a main ' +
          'location when you first begin using multi-stock location - only ' +
          'use once!'
        HelpContext = 508
        Caption = '&Move Stock'
        TabOrder = 5
        OnClick = MoveBtnClick
      end
      object UseBtn: TButton
        Tag = 3
        Left = 0
        Top = 75
        Width = 80
        Height = 21
        Hint = 
          'Use this Locn|Allows you to select the required quantity from th' +
          'e highlighted location'
        Caption = '&Use'
        TabOrder = 6
        OnClick = UseBtnClick
      end
      object FillBtn: TButton
        Tag = 3
        Left = 0
        Top = 99
        Width = 80
        Height = 21
        Hint = 
          'Create Stock Location Records|Allows you to create blank Stock L' +
          'ocation Records (SLR'#39's) for the current Stock Record'
        HelpContext = 515
        Caption = '&Fill'
        TabOrder = 7
        OnClick = FillBtnClick
      end
      object NteBtn: TButton
        Left = 0
        Top = 195
        Width = 80
        Height = 21
        Hint = 'Access Note Pad|Displays any notes attached to this record.'
        HelpContext = 88
        Caption = '&Notes'
        TabOrder = 8
        OnClick = NteBtnClick
      end
    end
    object ClsCP1Btn: TButton
      Left = 22
      Top = 44
      Width = 80
      Height = 21
      HelpContext = 512
      Cancel = True
      Caption = '&Close'
      ModalResult = 2
      TabOrder = 1
      OnClick = ClsCP1BtnClick
    end
  end
  object PopupMenu1: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 228
    Top = 65513
    object Add1: TMenuItem
      Tag = 1
      Caption = '&Add'
      Hint = 
        'Adds a new Stock Location record to the current database. The en' +
        'tries are sorted in code order.'
      OnClick = AddBtnClick
    end
    object Edit1: TMenuItem
      Tag = 2
      Caption = '&Edit'
      Hint = 'Allows the currently highlighted record to be changed.'
      OnClick = AddBtnClick
    end
    object Delete1: TMenuItem
      Tag = 3
      Caption = '&Delete'
      Hint = 'Allows the currently highlighted record to be deleted.'
      OnClick = AddBtnClick
    end
    object Use1: TMenuItem
      Caption = '&Use'
      Hint = 
        'Allows you to select the required quantity from the highlighted ' +
        'location'
      OnClick = UseBtnClick
    end
    object Fill1: TMenuItem
      Caption = '&Fill'
      Hint = 
        'Allows you to create blank Stock Location Records (SLR'#39's) for th' +
        'e current Stock Record'
      OnClick = FillBtnClick
    end
    object MoveStock1: TMenuItem
      Caption = '&Move Stock'
      Hint = 
        'Used to transfer stock levels to a main location when you first ' +
        'begin using multi-stock location - only use once!'
      OnClick = MoveBtnClick
    end
    object Tag1: TMenuItem
      Caption = '&Tag'
      Hint = 'Used for Reporting purposes'
    end
    object Clear1: TMenuItem
      Caption = 'C&lear Tag'
      Hint = 'Allows the currently highlighted record to be deleted.'
    end
    object Notes1: TMenuItem
      Caption = '&Notes'
      OnClick = NteBtnClick
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
  object WindowExport: TWindowExport
    OnEnableExport = WindowExportEnableExport
    OnExecuteCommand = WindowExportExecuteCommand
    OnGetExportDescription = WindowExportGetExportDescription
    Left = 192
    Top = 152
  end
end
