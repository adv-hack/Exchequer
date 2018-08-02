object SysFrmLst: TSysFrmLst
  Left = 257
  Top = 168
  Width = 391
  Height = 242
  HelpContext = 6002
  BorderIcons = [biSystemMenu]
  Caption = 'System Setup - Form Definition Sets'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  PopupMenu = PopupMenu1
  Scaled = False
  OnActivate = FormActivate
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 14
  object PnlButt: TPanel
    Left = 288
    Top = 5
    Width = 89
    Height = 198
    BevelOuter = bvNone
    BorderStyle = bsSingle
    Ctl3D = True
    ParentCtl3D = False
    TabOrder = 2
    object SpeedButton1: TSpeedButton
      Left = 48
      Top = 147
      Width = 35
      Height = 25
      Caption = 'DBug'
      Visible = False
      OnClick = SpeedButton1Click
    end
    object CloseBtn: TButton
      Tag = 1
      Left = 4
      Top = 4
      Width = 78
      Height = 21
      Caption = '&Close'
      ModalResult = 1
      TabOrder = 0
    end
    object AddBtn: TButton
      Tag = 1
      Left = 4
      Top = 34
      Width = 78
      Height = 21
      Hint = 'Adds a new Form Definition Set'
      Caption = '&Add'
      TabOrder = 1
      OnClick = AddBtnClick
    end
    object EditBtn: TButton
      Tag = 2
      Left = 4
      Top = 58
      Width = 78
      Height = 21
      Hint = 
        'Allows the settings for the currently highlighted set to be chan' +
        'ged'
      Caption = '&Edit'
      TabOrder = 2
      OnClick = AddBtnClick
    end
    object DelBtn: TButton
      Tag = 3
      Left = 5
      Top = 82
      Width = 78
      Height = 21
      Hint = 'Deletes the currently highlighted set'
      Caption = '&Delete'
      TabOrder = 3
      OnClick = DelBtnClick
    end
    object CopyBtn: TButton
      Tag = 4
      Left = 4
      Top = 108
      Width = 78
      Height = 21
      Hint = 
        'Copies the currently highlighted set into a new form definition ' +
        'set'
      Caption = 'C&opy'
      TabOrder = 4
      OnClick = AddBtnClick
    end
  end
  object InpBox: TScrollBox
    Left = 6
    Top = 5
    Width = 256
    Height = 198
    HorzScrollBar.Tracking = True
    VertScrollBar.Tracking = True
    TabOrder = 0
    object IHedPanel: TSBSPanel
      Left = 3
      Top = 2
      Width = 248
      Height = 19
      BevelOuter = bvLowered
      TabOrder = 0
      AllowReSize = False
      IsGroupBox = False
      TextId = 0
      object IVarLabel: TSBSPanel
        Left = 3
        Top = 3
        Width = 53
        Height = 14
        Alignment = taLeftJustify
        BevelOuter = bvNone
        Caption = 'Set No'
        Ctl3D = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentCtl3D = False
        ParentFont = False
        TabOrder = 0
        OnMouseDown = RRefLabMouseDown
        OnMouseMove = RRefLabMouseMove
        OnMouseUp = RRefPanelMouseUp
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
      end
      object IDescLabel: TSBSPanel
        Left = 60
        Top = 4
        Width = 186
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
        OnMouseDown = RRefLabMouseDown
        OnMouseMove = RRefLabMouseMove
        OnMouseUp = RRefPanelMouseUp
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
      end
    end
    object IVarPanel: TSBSPanel
      Left = 3
      Top = 25
      Width = 55
      Height = 150
      BevelOuter = bvLowered
      Color = clAqua
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnMouseUp = RRefPanelMouseUp
      AllowReSize = True
      IsGroupBox = False
      TextId = 0
    end
    object IDescPanel: TSBSPanel
      Left = 61
      Top = 25
      Width = 190
      Height = 150
      BevelOuter = bvLowered
      Color = clAqua
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnMouseUp = RRefPanelMouseUp
      AllowReSize = True
      IsGroupBox = False
      TextId = 0
    end
  end
  object MListBtnPanel: TSBSPanel
    Left = 264
    Top = 32
    Width = 19
    Height = 149
    BevelOuter = bvLowered
    TabOrder = 1
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
  end
  object PopupMenu1: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 296
    Top = 167
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
      OnClick = DelBtnClick
    end
    object Copy1: TMenuItem
      Tag = 4
      Caption = 'C&opy'
      OnClick = AddBtnClick
    end
    object N3: TMenuItem
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
