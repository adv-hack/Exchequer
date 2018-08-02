object frmPickAccount: TfrmPickAccount
  Left = 241
  Top = 179
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Pick Account'
  ClientHeight = 345
  ClientWidth = 633
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
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
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object pcAccounts: TPageControl
    Left = 8
    Top = 8
    Width = 529
    Height = 329
    ActivePage = tsSuppliers
    TabIndex = 1
    TabOrder = 0
    object tsCustomers: TTabSheet
      Caption = 'Customers'
      object mlCustomers: TDBMultiList
        Left = 8
        Top = 8
        Width = 505
        Height = 282
        Custom.SplitterCursor = crHSplit
        Dimensions.HeaderHeight = 18
        Dimensions.SpacerWidth = 1
        Dimensions.SplitterWidth = 3
        Options.BoldActiveColumn = False
        Columns = <
          item
            Caption = 'Code'
            Field = 'C'
            Searchable = True
            Sortable = True
            Width = 65
          end
          item
            Caption = 'Account Name'
            Field = 'N'
            Searchable = True
            Sortable = True
            Width = 196
            IndexNo = 1
          end
          item
            Caption = 'Address'
            Field = 'A'
            Width = 202
          end>
        TabStop = True
        OnRowDblClick = mlCustomersRowDblClick
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
        Dataset = tkdsCustomers
        Active = False
        SortColIndex = 0
        SortAsc = True
      end
    end
    object tsSuppliers: TTabSheet
      Caption = 'Suppliers'
      ImageIndex = 1
      object mlSuppliers: TDBMultiList
        Left = 8
        Top = 8
        Width = 505
        Height = 282
        Custom.SplitterCursor = crHSplit
        Dimensions.HeaderHeight = 18
        Dimensions.SpacerWidth = 1
        Dimensions.SplitterWidth = 3
        Options.BoldActiveColumn = False
        Columns = <
          item
            Caption = 'Code'
            Field = 'C'
            Searchable = True
            Sortable = True
            Width = 65
          end
          item
            Caption = 'Account Name'
            Field = 'N'
            Searchable = True
            Sortable = True
            Width = 196
            IndexNo = 1
          end
          item
            Caption = 'Address'
            Field = 'A'
            Width = 202
          end>
        TabStop = True
        OnRowDblClick = mlSuppliersRowDblClick
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
        Dataset = tkdsSuppliers
        Active = False
        SortColIndex = 0
        SortAsc = True
      end
    end
  end
  object btnRefresh: TButton
    Left = 536
    Top = 128
    Width = 89
    Height = 25
    Caption = '&Refresh Lists'
    TabOrder = 1
    Visible = False
    OnClick = btnRefreshClick
  end
  object btnOK: TButton
    Left = 544
    Top = 56
    Width = 80
    Height = 21
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 2
  end
  object btnCancel: TButton
    Left = 544
    Top = 32
    Width = 80
    Height = 21
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object Button1: TButton
    Left = 544
    Top = 80
    Width = 80
    Height = 21
    Caption = 'Show &All'
    ModalResult = 1
    TabOrder = 4
    OnClick = Button1Click
  end
  object tkdsSuppliers: TComTKDataset
    OnGetFieldValue = tkdsGetFieldValue
    Left = 80
    Top = 24
  end
  object tkdsCustomers: TComTKDataset
    OnGetFieldValue = tkdsGetFieldValue
    Left = 16
    Top = 24
  end
  object pmMain: TPopupMenu
    Left = 544
    Top = 160
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
