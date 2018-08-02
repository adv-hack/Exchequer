object frmBankList: TfrmBankList
  Left = 145
  Top = 205
  Width = 448
  Height = 321
  HelpContext = 1949
  Caption = 'Bank Accounts'
  Color = clBtnFace
  Constraints.MinHeight = 210
  Constraints.MinWidth = 200
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
  Scaled = False
  ShowHint = True
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 14
  object Panel1: TPanel
    Left = 2
    Top = 2
    Width = 423
    Height = 273
    BevelOuter = bvNone
    TabOrder = 0
    object pnlBanks: TPanel
      Left = 4
      Top = 4
      Width = 321
      Height = 265
      BevelOuter = bvNone
      TabOrder = 0
      object mlBanks: TDBMultiList
        Left = 0
        Top = 0
        Width = 321
        Height = 265
        HelpContext = 1949
        Custom.SplitterCursor = crHSplit
        Dimensions.HeaderHeight = 18
        Dimensions.SpacerWidth = 1
        Dimensions.SplitterWidth = 3
        Options.BoldActiveColumn = False
        Columns = <
          item
            Caption = 'G/LCode'
            Color = clWhite
            DataType = dtInteger
            Field = 'C'
            Searchable = True
            Sortable = True
            Width = 75
          end
          item
            Caption = 'Description'
            Color = clWhite
            Field = 'D'
            Searchable = True
            Sortable = True
            Width = 120
          end
          item
            Caption = 'Last Used'
            Color = clWhite
            Field = 'L'
            Width = 80
          end>
        TabStop = True
        OnColumnClick = mlBanksColumnClick
        OnChangeSelection = mlBanksChangeSelection
        OnRowDblClick = mlBanksRowDblClick
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
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
        Dataset = ctkBanks
        Active = False
        SortColIndex = 0
        SortAsc = True
      end
    end
    object pnlButtons: TPanel
      Left = 330
      Top = 4
      Width = 91
      Height = 265
      HelpContext = 1949
      BevelOuter = bvNone
      PopupMenu = PopupMenu1
      TabOrder = 1
      object btnClose: TSBSButton
        Left = 5
        Top = 24
        Width = 80
        Height = 21
        Hint = 'Close this window'
        Cancel = True
        Caption = '&Close'
        PopupMenu = PopupMenu1
        TabOrder = 0
        OnClick = btnCloseClick
        TextId = 0
      end
      object ScrollBox1: TScrollBox
        Left = 2
        Top = 62
        Width = 87
        Height = 200
        HelpContext = 1949
        BevelInner = bvNone
        BevelOuter = bvNone
        BorderStyle = bsNone
        TabOrder = 1
        object btnAdd: TSBSButton
          Left = 3
          Top = 8
          Width = 80
          Height = 21
          Hint = 'Add a new record'
          HelpContext = 1953
          Caption = '&Add'
          PopupMenu = PopupMenu1
          TabOrder = 0
          OnClick = btnAddClick
          TextId = 0
        end
        object btnEdit: TSBSButton
          Left = 3
          Top = 32
          Width = 80
          Height = 21
          Hint = 'Edit Current Record'
          HelpContext = 1954
          Caption = '&Edit'
          PopupMenu = PopupMenu1
          TabOrder = 1
          OnClick = btnEditClick
          TextId = 0
        end
        object btnView: TSBSButton
          Left = 3
          Top = 56
          Width = 80
          Height = 21
          Hint = 'View current record'
          HelpContext = 1955
          Caption = '&View'
          PopupMenu = PopupMenu1
          TabOrder = 2
          OnClick = btnViewClick
          TextId = 0
        end
        object btnDelete: TSBSButton
          Left = 3
          Top = 80
          Width = 80
          Height = 21
          Hint = 'Delete current record'
          HelpContext = 1956
          Caption = '&Delete'
          PopupMenu = PopupMenu1
          TabOrder = 3
          OnClick = btnDeleteClick
          TextId = 0
        end
        object btnStatement: TSBSButton
          Left = 3
          Top = 103
          Width = 80
          Height = 21
          Hint = 'View statements for current record'
          HelpContext = 1957
          Caption = '&Statements'
          ParentShowHint = False
          PopupMenu = PopupMenu1
          ShowHint = True
          TabOrder = 4
          OnClick = btnStatementClick
          TextId = 0
        end
      end
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 336
    Top = 232
    object Add1: TMenuItem
      Caption = '&Add'
      OnClick = btnAddClick
    end
    object Edit1: TMenuItem
      Caption = '&Edit'
      OnClick = btnEditClick
    end
    object View1: TMenuItem
      Caption = '&View'
      OnClick = btnViewClick
    end
    object Delete1: TMenuItem
      Caption = '&Delete'
      OnClick = btnDeleteClick
    end
    object Statements1: TMenuItem
      Caption = '&Statements'
      OnClick = btnStatementClick
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
  object ctkBanks: TComTKDataset
    OnGetFieldValue = ctkBanksGetFieldValue
    Left = 408
    Top = 224
  end
end
