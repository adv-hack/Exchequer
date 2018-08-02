object frmBankList: TfrmBankList
  Left = 473
  Top = 229
  Width = 455
  Height = 317
  Caption = 'Bank Accounts'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  FormStyle = fsMDIChild
  KeyPreview = True
  OldCreateOrder = False
  PopupMenu = PopupMenu1
  Position = poDefault
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 14
  object Panel1: TPanel
    Left = 4
    Top = 8
    Width = 439
    Height = 273
    TabOrder = 0
    object pnlBanks: TPanel
      Left = 4
      Top = 4
      Width = 321
      Height = 265
      TabOrder = 0
      object mlBanks: TMultiList
        Left = 1
        Top = 1
        Width = 319
        Height = 263
        Bevels.Outer = bvLowered
        Custom.SplitterCursor = crHSplit
        Dimensions.HeaderHeight = 18
        Dimensions.SpacerWidth = 1
        Dimensions.SplitterWidth = 3
        Options.BoldActiveColumn = False
        Columns = <
          item
            Caption = 'G/L Code'
            Color = clGreen
            Searchable = True
            Sortable = True
            Width = 75
          end
          item
            Caption = 'Description'
            Color = clGreen
            Searchable = True
            Sortable = True
            Width = 120
          end
          item
            Caption = 'Last Used'
            Color = clGreen
            Searchable = True
            Sortable = True
            Width = 80
          end>
        TabStop = True
        OnChangeSelection = mlBanksChangeSelection
        OnRowClick = mlBanksRowClick
        OnRowDblClick = mlBanksRowDblClick
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        PopupMenu = PopupMenu1
        TabOrder = 0
        OnDblClick = btnEditClick
        OnKeyDown = mlBanksKeyDown
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
      end
    end
    object pnlButtons: TPanel
      Left = 330
      Top = 4
      Width = 103
      Height = 265
      BevelInner = bvLowered
      BevelOuter = bvLowered
      PopupMenu = PopupMenu1
      TabOrder = 1
      object btnClose: TSBSButton
        Left = 9
        Top = 24
        Width = 80
        Height = 21
        Cancel = True
        Caption = '&Close'
        PopupMenu = PopupMenu1
        TabOrder = 0
        OnClick = btnCloseClick
        TextId = 0
      end
      object btnEdit: TSBSButton
        Left = 9
        Top = 96
        Width = 80
        Height = 21
        Caption = '&Edit'
        PopupMenu = PopupMenu1
        TabOrder = 1
        OnClick = btnEditClick
        TextId = 0
      end
      object btnView: TSBSButton
        Left = 9
        Top = 120
        Width = 80
        Height = 21
        Caption = '&View'
        PopupMenu = PopupMenu1
        TabOrder = 2
        OnClick = btnViewClick
        TextId = 0
      end
      object btnDelete: TSBSButton
        Left = 9
        Top = 144
        Width = 80
        Height = 21
        Caption = '&Delete'
        PopupMenu = PopupMenu1
        TabOrder = 3
        OnClick = btnDeleteClick
        TextId = 0
      end
      object btnStatement: TSBSButton
        Left = 9
        Top = 168
        Width = 80
        Height = 21
        Caption = '&Statements'
        PopupMenu = PopupMenu1
        TabOrder = 4
        OnClick = btnStatementClick
        TextId = 0
      end
      object btnAdd: TSBSButton
        Left = 8
        Top = 72
        Width = 80
        Height = 21
        Caption = '&Add'
        PopupMenu = PopupMenu1
        TabOrder = 5
        OnClick = btnAddClick
        TextId = 0
      end
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 336
    Top = 248
    object Add1: TMenuItem
      Caption = '&Add'
    end
    object Edit1: TMenuItem
      Caption = '&Edit'
    end
    object View1: TMenuItem
      Caption = '&View'
    end
    object Delete1: TMenuItem
      Caption = '&Delete'
    end
    object Statements1: TMenuItem
      Caption = '&Statements'
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Properties1: TMenuItem
      Caption = '&Properties'
      OnClick = Properties1Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object SaveCoordinates1: TMenuItem
      AutoCheck = True
      Caption = 'Sa&ve Coordinates'
    end
  end
  object EnterToTab1: TEnterToTab
    ConvertEnters = True
    OverrideFont = True
    Version = 'TEnterToTab v1.02 for Delphi 6.01'
    Left = 368
    Top = 240
  end
end
