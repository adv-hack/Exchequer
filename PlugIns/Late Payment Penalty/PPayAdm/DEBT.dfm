object frmDebt: TfrmDebt
  Left = 301
  Top = 355
  Width = 390
  Height = 259
  HorzScrollBar.Visible = False
  Caption = 'Debt Collection Charge Scale'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  PopupMenu = pmMain
  Position = poScreenCenter
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object lCustomer: TLabel
    Left = 8
    Top = 8
    Width = 59
    Height = 14
    Caption = 'lCustomer'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object mlDebt: TDBMultiList
    Left = 8
    Top = 24
    Width = 267
    Height = 193
    Custom.SplitterCursor = crHSplit
    Dimensions.HeaderHeight = 18
    Dimensions.SpacerWidth = 1
    Dimensions.SplitterWidth = 3
    Options.BoldActiveColumn = False
    Columns = <
      item
        Alignment = taRightJustify
        Caption = 'Value From'
        Field = 'F'
        Searchable = True
        Sortable = True
        Width = 75
      end
      item
        Alignment = taRightJustify
        Caption = 'Value To'
        Field = 'T'
        Width = 75
      end
      item
        Alignment = taRightJustify
        Caption = 'Charge'
        Field = 'C'
        Width = 75
      end>
    TabStop = True
    OnRowDblClick = mlDebtRowDblClick
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
    Dataset = bdsDebt
    OnAfterLoad = mlDebtAfterLoad
    Active = False
    SortColIndex = 0
    SortAsc = True
  end
  object btnAdd: TButton
    Left = 288
    Top = 24
    Width = 80
    Height = 21
    Caption = '&Add'
    TabOrder = 1
    OnClick = btnAddClick
  end
  object btnDelete: TButton
    Left = 288
    Top = 72
    Width = 80
    Height = 21
    Caption = '&Delete'
    TabOrder = 3
    OnClick = btnDeleteClick
  end
  object btnClose: TButton
    Left = 288
    Top = 192
    Width = 80
    Height = 21
    Caption = '&Close'
    TabOrder = 4
    OnClick = btnCloseClick
  end
  object btnEdit: TButton
    Left = 288
    Top = 48
    Width = 80
    Height = 21
    Caption = '&Edit'
    TabOrder = 2
    OnClick = btnEditClick
  end
  object bdsDebt: TBtrieveDataset
    OnGetFieldValue = bdsDebtGetFieldValue
    Left = 16
    Top = 32
  end
  object pmMain: TPopupMenu
    OnPopup = pmMainPopup
    Left = 48
    Top = 32
    object Add1: TMenuItem
      Caption = 'Add'
      OnClick = Add1Click
    end
    object Edit1: TMenuItem
      Caption = 'Edit'
      OnClick = Edit1Click
    end
    object Delete1: TMenuItem
      Caption = 'Delete'
      OnClick = Delete1Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object Properties1: TMenuItem
      Caption = 'Properties'
      OnClick = Properties1Click
    end
    object SaveCoordinates1: TMenuItem
      AutoCheck = True
      Caption = 'Save Coordinates'
    end
  end
end
