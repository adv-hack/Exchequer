object LettersList: TLettersList
  Left = 357
  Top = 154
  Width = 498
  Height = 290
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Letters for ########'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = True
  Position = poDefault
  Scaled = False
  Visible = True
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object MPanel: TSBSPanel
    Left = 6
    Top = 5
    Width = 388
    Height = 244
    TabOrder = 0
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
    object MSBox: TScrollBox
      Left = 8
      Top = 8
      Width = 348
      Height = 228
      HorzScrollBar.Position = 153
      HorzScrollBar.Tracking = True
      VertScrollBar.Tracking = True
      VertScrollBar.Visible = False
      TabOrder = 0
      object MHedPanel: TSBSPanel
        Left = -151
        Top = 2
        Width = 495
        Height = 19
        BevelOuter = bvLowered
        TabOrder = 0
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        Purpose = puBtrListColumnHeader
        object MORefLab: TSBSPanel
          Left = 75
          Top = 2
          Width = 68
          Height = 14
          Alignment = taLeftJustify
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
          OnMouseDown = MORefLabMouseDown
          OnMouseMove = MORefLabMouseMove
          OnMouseUp = MORefPanelMouseUp
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumnHeader
        end
        object MYRefLab: TSBSPanel
          Left = 146
          Top = 3
          Width = 190
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
          OnMouseDown = MORefLabMouseDown
          OnMouseMove = MORefLabMouseMove
          OnMouseUp = MORefPanelMouseUp
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumnHeader
        end
        object MDateLab: TSBSPanel
          Left = 340
          Top = 2
          Width = 92
          Height = 14
          BevelOuter = bvNone
          Caption = 'User'
          Ctl3D = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 2
          OnMouseDown = MORefLabMouseDown
          OnMouseMove = MORefLabMouseMove
          OnMouseUp = MORefPanelMouseUp
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumnHeader
        end
        object MAmtLab: TSBSPanel
          Left = 436
          Top = 3
          Width = 54
          Height = 14
          BevelOuter = bvNone
          Caption = 'Time'
          Ctl3D = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 3
          OnMouseDown = MORefLabMouseDown
          OnMouseMove = MORefLabMouseMove
          OnMouseUp = MORefPanelMouseUp
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumnHeader
        end
        object MOTypeLab: TSBSPanel
          Left = 2
          Top = 2
          Width = 68
          Height = 14
          Alignment = taLeftJustify
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
          TabOrder = 4
          OnMouseDown = MORefLabMouseDown
          OnMouseMove = MORefLabMouseMove
          OnMouseUp = MORefPanelMouseUp
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumnHeader
        end
      end
      object MORefPanel: TSBSPanel
        Left = -75
        Top = 24
        Width = 66
        Height = 180
        HelpContext = 1788
        BevelOuter = bvLowered
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        OnMouseUp = MORefPanelMouseUp
        AllowReSize = True
        IsGroupBox = False
        TextId = 0
        Purpose = puBtrListColumn
      end
      object MYRefPanel: TSBSPanel
        Left = -6
        Top = 24
        Width = 192
        Height = 180
        HelpContext = 1789
        BevelOuter = bvLowered
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        OnMouseUp = MORefPanelMouseUp
        AllowReSize = True
        IsGroupBox = False
        TextId = 0
        Purpose = puBtrListColumn
      end
      object MDatePanel: TSBSPanel
        Left = 189
        Top = 24
        Width = 93
        Height = 180
        HelpContext = 1790
        BevelOuter = bvLowered
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        OnMouseUp = MORefPanelMouseUp
        AllowReSize = True
        IsGroupBox = False
        TextId = 0
        Purpose = puBtrListColumn
      end
      object MAmtPanel: TSBSPanel
        Left = 285
        Top = 24
        Width = 56
        Height = 180
        HelpContext = 1791
        BevelOuter = bvLowered
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 4
        OnMouseUp = MORefPanelMouseUp
        AllowReSize = True
        IsGroupBox = False
        TextId = 0
        Purpose = puBtrListColumn
      end
      object MOTypePanel: TSBSPanel
        Left = -150
        Top = 24
        Width = 72
        Height = 180
        HelpContext = 1787
        BevelOuter = bvLowered
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 5
        OnMouseUp = MORefPanelMouseUp
        AllowReSize = True
        IsGroupBox = False
        TextId = 0
        Purpose = puBtrListColumn
      end
    end
  end
  object MListBtnPanel: TSBSPanel
    Left = 365
    Top = 38
    Width = 18
    Height = 203
    BevelOuter = bvLowered
    TabOrder = 1
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
  end
  object LClsBtn: TButton
    Left = 401
    Top = 6
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Close'
    ModalResult = 2
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    OnClick = LClsBtnClick
  end
  object LVwBtn: TButton
    Left = 401
    Top = 113
    Width = 80
    Height = 21
    Caption = '&View'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 5
    OnClick = LVwBtnClick
  end
  object LAddBtn: TButton
    Left = 402
    Top = 63
    Width = 80
    Height = 21
    Caption = '&Add Letter'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    OnClick = LAddBtnClick
  end
  object LDelBtn: TButton
    Left = 401
    Top = 138
    Width = 80
    Height = 21
    Caption = '&Delete'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 6
    OnClick = LDelBtnClick
  end
  object LDescBtn: TButton
    Left = 401
    Top = 164
    Width = 80
    Height = 21
    Caption = '&Edit'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 7
    OnClick = LDescBtnClick
  end
  object LLinkBtn: TButton
    Left = 401
    Top = 88
    Width = 80
    Height = 21
    Caption = '&Add Link'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 4
    OnClick = LLinkBtnClick
  end
  object Btn_AddUrl: TButton
    Left = 402
    Top = 38
    Width = 80
    Height = 21
    Caption = '&Add Webpage'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 8
    OnClick = Btn_AddUrlClick
  end
  object PopupMenu1: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 181
    Top = 65535
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
  object OpenDialog1: TOpenDialog
    Filter = 
      'Document (*.DOC, *.DOCX)|*.DOC;*.DOCX|Image (*.BMP,*.GIF)|*.BMP;' +
      '*.GIF|Sound (*.WAV)|*.WAV|Video (*.AVI,*.MPG)|*.AVI;*.MPG|All Fi' +
      'les|*.*'
    FilterIndex = 5
    Options = [ofPathMustExist, ofFileMustExist]
    Left = 412
    Top = 199
  end
end
