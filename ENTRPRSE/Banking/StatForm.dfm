object frmStatement: TfrmStatement
  Left = 237
  Top = 173
  Width = 459
  Height = 335
  HelpContext = 2010
  Caption = 'Bank Statement'
  Color = clBtnFace
  Constraints.MinHeight = 200
  Constraints.MinWidth = 210
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  PopupMenu = PopupMenu1
  Position = poDefault
  Scaled = False
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 14
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 443
    Height = 296
    Align = alClient
    Caption = 'Panel1'
    TabOrder = 0
    object pnlBtns: TPanel
      Left = 340
      Top = 4
      Width = 105
      Height = 293
      BevelOuter = bvNone
      TabOrder = 1
      object btnClose: TSBSButton
        Left = 10
        Top = 48
        Width = 80
        Height = 21
        HelpContext = 2018
        Caption = '&Close'
        TabOrder = 0
        OnClick = btnCloseClick
        TextId = 0
      end
      object btnFilter: TSBSButton
        Left = 10
        Top = 120
        Width = 80
        Height = 21
        HelpContext = 2019
        Caption = '&Filter'
        TabOrder = 1
        OnClick = btnFilterClick
        TextId = 0
      end
      object btnTag: TSBSButton
        Left = 10
        Top = 144
        Width = 80
        Height = 21
        HelpContext = 1937
        Caption = '&Match'
        TabOrder = 2
        OnClick = btnTagClick
        TextId = 0
      end
      object btnAuto: TSBSButton
        Left = 10
        Top = 168
        Width = 80
        Height = 21
        HelpContext = 1987
        Caption = '&Reconcile'
        TabOrder = 3
        OnClick = btnAutoClick
        TextId = 0
      end
    end
    object mlStatements: TDBMultiList
      Left = 4
      Top = 48
      Width = 333
      Height = 250
      HelpContext = 2010
      Custom.SplitterCursor = crHSplit
      Dimensions.HeaderHeight = 18
      Dimensions.SpacerWidth = 1
      Dimensions.SplitterWidth = 3
      Options.BoldActiveColumn = False
      Columns = <
        item
          Alignment = taRightJustify
          Caption = 'Line'
          Color = clWhite
          DataType = dtInteger
          Field = 'L'
          Width = 30
        end
        item
          Caption = 'Date'
          Color = clWhite
          DataType = dtDate
          Field = 'D'
          Searchable = True
          Sortable = True
          Width = 60
        end
        item
          Alignment = taRightJustify
          Caption = 'Amount'
          Color = clWhite
          DataType = dtFloat
          Field = 'A'
          Width = 60
        end
        item
          Caption = 'Reference'
          Color = clWhite
          Field = 'R'
          Width = 90
        end
        item
          Caption = 'Status'
          Color = clWhite
          Field = 'S'
          Width = 50
        end>
      TabStop = True
      OnColumnClick = mlStatementsColumnClick
      Font.Charset = ANSI_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      TabOrder = 0
      OnDragOver = mlStatementsDragOver
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
      Dataset = ctkData
      OnAfterLoad = mlStatementsAfterLoad
      Active = False
      SortColIndex = 1
      SortAsc = True
    end
    object Panel3: TPanel
      Left = 4
      Top = 4
      Width = 333
      Height = 41
      BevelInner = bvLowered
      BevelOuter = bvNone
      TabOrder = 2
      object Label1: TLabel
        Left = 10
        Top = 16
        Width = 22
        Height = 14
        Alignment = taRightJustify
        Caption = 'Date'
      end
      object Label2: TLabel
        Left = 141
        Top = 16
        Width = 51
        Height = 14
        Alignment = taRightJustify
        Caption = 'Reference'
      end
      object edtDate: TEdit
        Left = 40
        Top = 12
        Width = 89
        Height = 22
        HelpContext = 2011
        TabStop = False
        BevelInner = bvNone
        Color = clBtnFace
        Font.Charset = ANSI_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
      end
      object edtRef: TEdit
        Left = 200
        Top = 12
        Width = 97
        Height = 22
        HelpContext = 2012
        TabStop = False
        BevelInner = bvNone
        Color = clBtnFace
        Font.Charset = ANSI_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
      end
    end
  end
  object ctkData: TComTKDataset
    OnFilterRecord = ctkDataFilterRecord
    OnGetFieldValue = ctkDataGetFieldValue
    Left = 384
    Top = 264
  end
  object popFilter: TPopupMenu
    Left = 408
    Top = 8
    object Allitems1: TMenuItem
      Caption = 'All Items'
      OnClick = Allitems1Click
    end
    object MatchedItemsonly1: TMenuItem
      Caption = 'Matched Items only'
      OnClick = MatchedItemsonly1Click
    end
    object UnmatchedItemsonly1: TMenuItem
      Caption = 'Unmatched Items only'
      OnClick = UnmatchedItemsonly1Click
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 384
    Top = 216
    object Close1: TMenuItem
      Caption = 'Close'
      OnClick = btnCloseClick
    end
    object Filter1: TMenuItem
      Caption = 'Filter'
      OnClick = btnFilterClick
    end
    object Match1: TMenuItem
      Caption = 'Match'
      OnClick = btnTagClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Properties1: TMenuItem
      Caption = 'Properties'
      OnClick = Properties1Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object SaveCoordinates1: TMenuItem
      AutoCheck = True
      Caption = 'Save Coordinates'
    end
  end
end
