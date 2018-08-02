object CCDepList: TCCDepList
  Left = 616
  Top = 250
  Width = 370
  Height = 244
  Caption = 'Record'
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
  object CSBox: TScrollBox
    Left = 5
    Top = 7
    Width = 225
    Height = 204
    VertScrollBar.Visible = False
    TabOrder = 0
    object CCPanel: TSBSPanel
      Left = 2
      Top = 24
      Width = 39
      Height = 160
      HelpContext = 1754
      BevelOuter = bvLowered
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnMouseUp = CCPanelMouseUp
      AllowReSize = True
      IsGroupBox = False
      TextId = 0
      Purpose = puBtrListColumn
    end
    object DescPanel: TSBSPanel
      Left = 44
      Top = 24
      Width = 175
      Height = 160
      HelpContext = 1755
      BevelOuter = bvLowered
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnMouseUp = CCPanelMouseUp
      AllowReSize = True
      IsGroupBox = False
      TextId = 0
      Purpose = puBtrListColumn
    end
    object CHedPanel: TSBSPanel
      Left = 2
      Top = 2
      Width = 220
      Height = 19
      BevelOuter = bvLowered
      TabOrder = 0
      AllowReSize = False
      IsGroupBox = False
      TextId = 0
      Purpose = puBtrListColumnHeader
      object DescLab: TSBSPanel
        Left = 44
        Top = 3
        Width = 175
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
        OnMouseDown = CCLabMouseDown
        OnMouseMove = CCLabMouseMove
        OnMouseUp = CCPanelMouseUp
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        Purpose = puBtrListColumnHeader
      end
      object CCLab: TSBSPanel
        Left = 2
        Top = 3
        Width = 39
        Height = 14
        Alignment = taLeftJustify
        BevelOuter = bvNone
        Caption = 'CC'
        Ctl3D = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentCtl3D = False
        ParentFont = False
        TabOrder = 0
        OnMouseDown = CCLabMouseDown
        OnMouseMove = CCLabMouseMove
        OnMouseUp = CCPanelMouseUp
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        Purpose = puBtrListColumnHeader
      end
    end
  end
  object CBtnPanel: TSBSPanel
    Left = 233
    Top = 8
    Width = 123
    Height = 203
    BevelOuter = bvLowered
    PopupMenu = PopupMenu1
    TabOrder = 1
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
    object CListBtnPanel: TSBSPanel
      Left = 2
      Top = 26
      Width = 18
      Height = 159
      BevelOuter = bvLowered
      TabOrder = 0
      AllowReSize = False
      IsGroupBox = False
      TextId = 0
    end
    object ClsCP1Btn: TButton
      Left = 22
      Top = 20
      Width = 80
      Height = 21
      Cancel = True
      Caption = '&Close'
      ModalResult = 2
      TabOrder = 1
      OnClick = ClsCP1BtnClick
    end
    object CCBSBox: TScrollBox
      Left = 22
      Top = 81
      Width = 100
      Height = 120
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
          'Add a new CC/Dep record|Adds a new Cost Center/Department record' +
          ' to the current database. The entries are sorted in code order.'
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
        Caption = '&Delete'
        TabOrder = 2
        OnClick = AddBtnClick
      end
      object TagBtn: TButton
        Left = 0
        Top = 75
        Width = 80
        Height = 21
        Hint = 
          'Tag/Untag current record|Allows the currently highlighted record' +
          ' to be tagged for reporting purposes. Also allows a previously t' +
          'agged record to be untagged.'
        Caption = '&Tag'
        TabOrder = 3
        OnClick = TagBtnClick
      end
      object ClrBtn: TButton
        Left = 0
        Top = 99
        Width = 80
        Height = 21
        Hint = 
          'Clear all tags|Allows all previously tagged records to be cleare' +
          'd.'
        Caption = 'C&lear Tag'
        TabOrder = 4
        OnClick = ClrBtnClick
      end
      object NteBtn: TButton
        Left = 0
        Top = 123
        Width = 80
        Height = 21
        Hint = 'Access Note Pad|Displays any notes attached to this record.'
        HelpContext = 88
        Caption = '&Notes'
        TabOrder = 5
        OnClick = NteBtnClick
      end
    end
  end
  object PopupMenu1: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 278
    Top = 51
    object Add1: TMenuItem
      Tag = 1
      Caption = '&Add'
      OnClick = AddBtnClick
    end
    object Edit1: TMenuItem
      Tag = 2
      Caption = '&Edit'
      OnClick = AddBtnClick
    end
    object Delete1: TMenuItem
      Tag = 3
      Caption = '&Delete'
      OnClick = AddBtnClick
    end
    object Tag1: TMenuItem
      Caption = '&Tag'
      OnClick = TagBtnClick
    end
    object Clear1: TMenuItem
      Caption = 'C&lear Tag'
      OnClick = ClrBtnClick
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
end
