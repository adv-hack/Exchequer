object frmSelectData: TfrmSelectData
  Left = 739
  Top = 492
  Width = 413
  Height = 272
  ActiveControl = cmbSearchFor
  BorderIcons = [biSystemMenu]
  Caption = 'frmSelectData'
  Color = clBtnFace
  Constraints.MinHeight = 180
  Constraints.MinWidth = 300
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PopupMenu = PopupMenu1
  OnResize = FormResize
  DesignSize = (
    405
    245)
  PixelsPerInch = 96
  TextHeight = 13
  object GFScrollBox1: TScrollBox
    Left = 4
    Top = 80
    Width = 373
    Height = 159
    HorzScrollBar.Tracking = True
    VertScrollBar.Tracking = True
    VertScrollBar.Visible = False
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 6
    object GFLabPanel: TSBSPanel
      Left = 4
      Top = 4
      Width = 363
      Height = 19
      BevelOuter = bvLowered
      TabOrder = 0
      AllowReSize = False
      IsGroupBox = False
      TextId = 0
      object GFAccLab: TSBSPanel
        Left = 4
        Top = 3
        Width = 63
        Height = 14
        Alignment = taLeftJustify
        BevelOuter = bvNone
        Caption = 'A/C Code'
        Ctl3D = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentCtl3D = False
        ParentFont = False
        TabOrder = 0
        OnMouseDown = GFAccLabMouseDown
        OnMouseMove = GFAccLabMouseMove
        OnMouseUp = GFAccLabMouseUp
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
      end
      object GFCompLab: TSBSPanel
        Left = 76
        Top = 3
        Width = 133
        Height = 14
        Alignment = taLeftJustify
        BevelOuter = bvNone
        Caption = 'Company'
        Ctl3D = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentCtl3D = False
        ParentFont = False
        TabOrder = 1
        OnMouseDown = GFAccLabMouseDown
        OnMouseMove = GFAccLabMouseMove
        OnMouseUp = GFAccLabMouseUp
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
      end
      object GFBalLab: TSBSPanel
        Left = 219
        Top = 3
        Width = 138
        Height = 14
        Alignment = taRightJustify
        BevelOuter = bvNone
        Caption = 'Balance'
        Ctl3D = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentCtl3D = False
        ParentFont = False
        TabOrder = 2
        OnMouseDown = GFAccLabMouseDown
        OnMouseMove = GFAccLabMouseMove
        OnMouseUp = GFAccLabMouseUp
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
      end
    end
    object GFAccPanel: TSBSPanel
      Left = 6
      Top = 25
      Width = 68
      Height = 113
      BevelOuter = bvLowered
      Color = clMaroon
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clYellow
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnMouseUp = GFAccLabMouseUp
      AllowReSize = True
      IsGroupBox = False
      TextId = 0
    end
    object GFCompPanel: TSBSPanel
      Left = 78
      Top = 25
      Width = 139
      Height = 113
      BevelOuter = bvLowered
      Color = clMaroon
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clYellow
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnMouseUp = GFAccLabMouseUp
      AllowReSize = True
      IsGroupBox = False
      TextId = 0
    end
    object GFBalPanel: TSBSPanel
      Left = 221
      Top = 25
      Width = 144
      Height = 113
      BevelOuter = bvLowered
      Color = clMaroon
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clYellow
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnMouseUp = GFAccLabMouseUp
      AllowReSize = True
      IsGroupBox = False
      TextId = 0
    end
  end
  object GFListBtnPanel: TSBSPanel
    Left = 381
    Top = 106
    Width = 18
    Height = 126
    Anchors = [akTop, akRight, akBottom]
    BevelOuter = bvLowered
    PopupMenu = PopupMenu1
    TabOrder = 7
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
  end
  object btnFind: TButton
    Left = 297
    Top = 6
    Width = 80
    Height = 21
    Hint = 
      'Start ObjectFind|Using the information in Search for, start sear' +
      'ch'
    Anchors = [akTop, akRight]
    Caption = 'F&ind Now'
    Default = True
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    OnClick = btnFindClick
  end
  object btnStop: TButton
    Left = 297
    Top = 30
    Width = 80
    Height = 21
    Hint = 
      'Close ObjectFind window|Close the ObjectFind window. ObjectFind ' +
      'will remember the last seach details'
    Anchors = [akTop, akRight]
    Caption = '&Stop'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 4
    OnClick = btnStopClick
  end
  object btnClose: TButton
    Left = 297
    Top = 54
    Width = 80
    Height = 21
    Hint = 
      'Close ObjectFind window|Close the ObjectFind window. ObjectFind ' +
      'will remember the last seach details'
    Anchors = [akTop, akRight]
    Cancel = True
    Caption = '&Close'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 5
    OnClick = btnCloseClick
  end
  object Panel1: TPanel
    Left = 5
    Top = 6
    Width = 287
    Height = 70
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
    object Label81: Label8
      Left = 10
      Top = 14
      Width = 55
      Height = 14
      Caption = '&Search for:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Label82: Label8
      Left = 12
      Top = 43
      Width = 53
      Height = 14
      Caption = 'Search &by:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
  end
  object cmbSearchFor: TSBSComboBox
    Left = 74
    Top = 16
    Width = 208
    Height = 22
    Hint = 'Search for?|Enter details to search for'
    Anchors = [akLeft, akTop, akRight]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 14
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    MaxListWidth = 0
  end
  object cmbSearchBy: TSBSComboBox
    Left = 75
    Top = 44
    Width = 208
    Height = 22
    Hint = 'Search by?|Choose by which field you wish to search'
    Style = csDropDownList
    Anchors = [akLeft, akTop, akRight]
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 14
    MaxLength = 255
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    MaxListWidth = 0
  end
  object PopupMenu1: TPopupMenu
    Left = 293
    Top = 83
    object PropFlg: TMenuItem
      Caption = '&Properties'
      Hint = 'Access Colour & Font settings'
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object StoreCoordFlg: TMenuItem
      Caption = '&Save Coordinates'
      Hint = 'Make the current window settings permanent'
    end
  end
end
