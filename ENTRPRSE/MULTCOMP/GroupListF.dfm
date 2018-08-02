object frmGroupList: TfrmGroupList
  Left = 404
  Top = 280
  Width = 573
  Height = 226
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Company Groups'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  PopupMenu = PopupMenu1
  Position = poOwnerFormCenter
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 14
  object mulGroups: TDBMultiList
    Left = 4
    Top = 4
    Width = 439
    Height = 180
    Custom.SplitterCursor = crHSplit
    Dimensions.HeaderHeight = 18
    Dimensions.SpacerWidth = 1
    Dimensions.SplitterWidth = 3
    Options.BoldActiveColumn = False
    Columns = <
      item
        Caption = 'Code'
        Color = clCream
        Field = '0'
        Searchable = True
        Sortable = True
        Width = 150
      end
      item
        Caption = 'Name'
        Color = clCream
        Field = '1'
        Searchable = True
        Sortable = True
        Width = 245
        IndexNo = 1
      end>
    TabStop = True
    OnRowDblClick = mulGroupsRowDblClick
    Font.Charset = ANSI_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    TabOrder = 0
    HeaderFont.Charset = DEFAULT_CHARSET
    HeaderFont.Color = clWindowText
    HeaderFont.Height = -11
    HeaderFont.Name = 'Arial'
    HeaderFont.Style = []
    HighlightFont.Charset = DEFAULT_CHARSET
    HighlightFont.Color = clWhite
    HighlightFont.Height = -11
    HighlightFont.Name = 'Arial'
    HighlightFont.Style = []
    MultiSelectFont.Charset = DEFAULT_CHARSET
    MultiSelectFont.Color = clWindowText
    MultiSelectFont.Height = -11
    MultiSelectFont.Name = 'Arial'
    MultiSelectFont.Style = []
    Version = 'v1.13'
    Dataset = bdsGroups
    Active = True
    SortColIndex = 0
    SortAsc = True
  end
  object panButtons: TPanel
    Left = 446
    Top = 4
    Width = 108
    Height = 180
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      108
      180)
    object btnClose: TSBSButton
      Left = 4
      Top = 4
      Width = 80
      Height = 21
      Cancel = True
      Caption = '&Close'
      TabOrder = 0
      OnClick = btnCloseClick
      TextId = 0
    end
    object ScrollBox1: TScrollBox
      Left = 0
      Top = 32
      Width = 104
      Height = 152
      Anchors = [akLeft, akTop, akBottom]
      BorderStyle = bsNone
      TabOrder = 1
      object btnAddGroup: TSBSButton
        Left = 4
        Top = 1
        Width = 80
        Height = 21
        Caption = '&Add'
        TabOrder = 0
        OnClick = btnAddGroupClick
        TextId = 0
      end
      object btnEditGroup: TSBSButton
        Left = 4
        Top = 25
        Width = 80
        Height = 21
        Caption = '&Edit'
        TabOrder = 1
        OnClick = btnEditGroupClick
        TextId = 0
      end
      object btnDeleteGroup: TSBSButton
        Left = 4
        Top = 49
        Width = 80
        Height = 21
        Caption = '&Delete'
        TabOrder = 2
        OnClick = btnDeleteGroupClick
        TextId = 0
      end
      object btnViewGroup: TSBSButton
        Left = 4
        Top = 73
        Width = 80
        Height = 21
        Caption = '&View'
        TabOrder = 3
        OnClick = btnViewGroupClick
        TextId = 0
      end
      object btnFindGroup: TSBSButton
        Left = 4
        Top = 97
        Width = 80
        Height = 21
        Caption = '&Find'
        TabOrder = 4
        OnClick = btnFindGroupClick
        TextId = 0
      end
      object btnPrintGroup: TSBSButton
        Left = 4
        Top = 121
        Width = 80
        Height = 21
        Caption = '&Print'
        TabOrder = 5
        OnClick = btnPrintGroupClick
        TextId = 0
      end
    end
  end
  object bdsGroups: TBTGlobalDataset
    FileName = 'Param Not Used'
    OnGetFieldValue = bdsGroupsGetFieldValue
    OnGetFileVar = bdsGroupsGetFileVar
    OnGetDataRecord = bdsGroupsGetDataRecord
    OnGetBufferSize = bdsGroupsGetBufferSize
    Left = 35
    Top = 44
  end
  object PopupMenu1: TPopupMenu
    AutoHotkeys = maManual
    Left = 177
    Top = 43
    object popAddGroup: TMenuItem
      Tag = 1
      Caption = '&Add Group'
      OnClick = btnAddGroupClick
    end
    object popEditGroup: TMenuItem
      Tag = 2
      Caption = '&Edit Group'
      OnClick = btnEditGroupClick
    end
    object popDeleteGroup: TMenuItem
      Tag = 3
      Caption = '&Delete Group'
      OnClick = btnDeleteGroupClick
    end
    object popViewGroup: TMenuItem
      Caption = '&View Group'
      OnClick = btnViewGroupClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object popFindGroup: TMenuItem
      Caption = '&Find Group'
      OnClick = btnFindGroupClick
    end
    object PopupOpt_SepBar2: TMenuItem
      Caption = '-'
    end
    object popFormProperties: TMenuItem
      Caption = '&Properties'
      Hint = 'Access Colour & Font settings'
      OnClick = popFormPropertiesClick
    end
    object PopupOpt_SepBar3: TMenuItem
      Caption = '-'
    end
    object popSavePosition: TMenuItem
      AutoCheck = True
      Caption = '&Save Coordinates'
      Hint = 'Make the current window settings permanent'
    end
  end
end
