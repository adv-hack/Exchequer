object frmIntegration: TfrmIntegration
  Left = 352
  Top = 244
  Width = 468
  Height = 231
  HelpContext = 179
  Caption = 'frmIntegration'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Position = poDefault
  Visible = True
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 13
    Top = 9
    Width = 32
    Height = 13
    Caption = 'Label1'
  end
  object Edit1: TEdit
    Left = 51
    Top = 4
    Width = 121
    Height = 21
    TabOrder = 0
    Text = 'Edit1'
  end
  object DBMultiList1: TDBMultiList
    Left = 13
    Top = 73
    Width = 430
    Height = 115
    Custom.SplitterCursor = crHSplit
    Dimensions.HeaderHeight = 18
    Dimensions.SpacerWidth = 1
    Dimensions.SplitterWidth = 3
    Options.BoldActiveColumn = False
    Columns = <
      item
        Caption = 'Code'
        Field = '0'
        Searchable = True
        Sortable = True
      end
      item
        Caption = 'Name'
        Field = '1'
        Searchable = True
        Sortable = True
        Width = 220
        IndexNo = 1
      end>
    TabStop = True
    TabOrder = 1
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
    Version = 'v1.12'
    Dataset = ComTKDataset1
    Active = False
    SortColIndex = 0
    SortAsc = True
  end
  object btnCustomers: TButton
    Left = 16
    Top = 45
    Width = 80
    Height = 21
    Caption = 'Customers'
    TabOrder = 2
    OnClick = btnCustomersClick
  end
  object btnStock: TButton
    Left = 102
    Top = 45
    Width = 80
    Height = 21
    Caption = 'Stock'
    TabOrder = 3
    OnClick = btnStockClick
  end
  object ComTKDataset1: TComTKDataset
    OnGetFieldValue = GetCustomerFieldValue
    Left = 305
    Top = 23
  end
end
