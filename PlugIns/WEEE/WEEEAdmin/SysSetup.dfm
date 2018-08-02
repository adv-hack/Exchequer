object frmWEEESetup: TfrmWEEESetup
  Left = 320
  Top = 286
  BorderStyle = bsSingle
  Caption = 'WEEE Plug-In Setup'
  ClientHeight = 445
  ClientWidth = 569
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnActivate = FormActivate
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 14
  object Label6: TLabel
    Left = 8
    Top = 12
    Width = 51
    Height = 14
    Caption = 'Company :'
  end
  object pcTabs: TPageControl
    Left = 8
    Top = 40
    Width = 553
    Height = 369
    ActivePage = tsGeneral
    TabIndex = 0
    TabOrder = 1
    object tsGeneral: TTabSheet
      Caption = 'General'
      object Label2: TLabel
        Left = 8
        Top = 28
        Width = 127
        Height = 14
        Caption = 'Stock UDF for WEEE Flag :'
      end
      object Label3: TLabel
        Left = 8
        Top = 172
        Width = 108
        Height = 14
        Caption = 'Customer UDF to use :'
      end
      object Label4: TLabel
        Left = 8
        Top = 212
        Width = 101
        Height = 14
        Caption = 'Supplier UDF to use :'
      end
      object Label5: TLabel
        Left = 8
        Top = 252
        Width = 142
        Height = 14
        Caption = 'Transaction Line UDF to use :'
      end
      object Label8: TLabel
        Left = 8
        Top = 68
        Width = 127
        Height = 14
        Caption = 'Stock UDF for EMC Value :'
      end
      object Label9: TLabel
        Left = 8
        Top = 108
        Width = 121
        Height = 14
        Caption = 'Stock UDF for ITC Value :'
      end
      object cmbStockFlagUDF: TComboBox
        Left = 160
        Top = 24
        Width = 145
        Height = 22
        Style = csDropDownList
        ItemHeight = 14
        TabOrder = 0
        OnChange = StockUDFChange
        Items.Strings = (
          'User Defined Field #1'
          'User Defined Field #2'
          'User Defined Field #3'
          'User Defined Field #4')
      end
      object cmbCustomerUDF: TComboBox
        Left = 160
        Top = 168
        Width = 145
        Height = 22
        Style = csDropDownList
        ItemHeight = 14
        TabOrder = 3
        Items.Strings = (
          'User Defined Field #1'
          'User Defined Field #2'
          'User Defined Field #3'
          'User Defined Field #4')
      end
      object cmbSupplierUDF: TComboBox
        Left = 160
        Top = 208
        Width = 145
        Height = 22
        Style = csDropDownList
        ItemHeight = 14
        TabOrder = 4
        Items.Strings = (
          'User Defined Field #1'
          'User Defined Field #2'
          'User Defined Field #3'
          'User Defined Field #4')
      end
      object cmbTXLineUDF: TComboBox
        Left = 160
        Top = 248
        Width = 145
        Height = 22
        Style = csDropDownList
        ItemHeight = 14
        TabOrder = 5
        Items.Strings = (
          'User Defined Field #1'
          'User Defined Field #2'
          'User Defined Field #3'
          'User Defined Field #4')
      end
      object cbShowWEEEValuePopup: TCheckBox
        Left = 8
        Top = 304
        Width = 297
        Height = 17
        Caption = 'Show WEEE Value Popup Message on Line'
        TabOrder = 6
      end
      object cmbStockEMCUDF: TComboBox
        Left = 160
        Top = 64
        Width = 145
        Height = 22
        Style = csDropDownList
        ItemHeight = 14
        TabOrder = 1
        OnChange = StockUDFChange
        Items.Strings = (
          'User Defined Field #1'
          'User Defined Field #2'
          'User Defined Field #3'
          'User Defined Field #4')
      end
      object cmbStockITCUDF: TComboBox
        Left = 160
        Top = 104
        Width = 145
        Height = 22
        Style = csDropDownList
        ItemHeight = 14
        TabOrder = 2
        OnChange = StockUDFChange
        Items.Strings = (
          'User Defined Field #1'
          'User Defined Field #2'
          'User Defined Field #3'
          'User Defined Field #4')
      end
    end
    object tsReportCats: TTabSheet
      Caption = 'Report Categories'
      ImageIndex = 1
      object Label1: TLabel
        Left = 8
        Top = 8
        Width = 52
        Height = 14
        Caption = 'Categories'
      end
      object Label7: TLabel
        Left = 280
        Top = 8
        Width = 74
        Height = 14
        Caption = 'Sub Categories'
      end
      object btnAddCat: TButton
        Left = 8
        Top = 312
        Width = 80
        Height = 21
        Caption = '&Add'
        TabOrder = 1
        OnClick = btnAddCatClick
      end
      object btnEditCat: TButton
        Left = 96
        Top = 312
        Width = 80
        Height = 21
        Caption = '&Edit'
        TabOrder = 2
        OnClick = btnEditCatClick
      end
      object btnDeleteCat: TButton
        Left = 184
        Top = 312
        Width = 80
        Height = 21
        Caption = '&Delete'
        TabOrder = 3
        Visible = False
        OnClick = btnDeleteCatClick
      end
      object mlReportCats: TDBMultiList
        Left = 8
        Top = 24
        Width = 257
        Height = 281
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
            Width = 60
            IndexNo = 1
          end
          item
            Caption = 'Description'
            Field = 'D'
            Searchable = True
            Sortable = True
            Width = 159
            IndexNo = 2
          end>
        TabStop = True
        OnChangeSelection = mlReportCatsChangeSelection
        OnRowDblClick = mlReportCatsRowDblClick
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
        Dataset = bdsReportCats
        Active = False
        SortColIndex = 0
        SortAsc = True
      end
      object mlReportSubCats: TDBMultiList
        Left = 280
        Top = 24
        Width = 257
        Height = 281
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
            Width = 60
            IndexNo = 1
          end
          item
            Caption = 'Description'
            Field = 'D'
            Searchable = True
            Sortable = True
            Width = 159
            IndexNo = 2
          end>
        TabStop = True
        OnRowDblClick = mlReportSubCatsRowDblClick
        TabOrder = 4
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
        Dataset = bdsReportSubCats
        Active = False
        SortColIndex = 0
        SortAsc = True
      end
      object btnAddSubCat: TButton
        Left = 280
        Top = 312
        Width = 80
        Height = 21
        Caption = '&Add'
        TabOrder = 5
        OnClick = btnAddSubCatClick
      end
      object btnEditSubCat: TButton
        Left = 368
        Top = 312
        Width = 80
        Height = 21
        Caption = '&Edit'
        TabOrder = 6
        OnClick = btnEditSubCatClick
      end
      object btnDeleteSubCat: TButton
        Left = 456
        Top = 312
        Width = 80
        Height = 21
        Caption = '&Delete'
        TabOrder = 7
        Visible = False
      end
    end
  end
  object btnOK: TButton
    Left = 480
    Top = 416
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Close'
    TabOrder = 2
    OnClick = btnOKClick
  end
  object cmbCompany: TComboBox
    Left = 64
    Top = 8
    Width = 497
    Height = 22
    Style = csDropDownList
    ItemHeight = 14
    TabOrder = 0
    OnChange = cmbCompanyChange
  end
  object MainMenu1: TMainMenu
    Left = 104
    Top = 416
    object File1: TMenuItem
      Caption = 'File'
      object Import1: TMenuItem
        Caption = 'Import Products'
        OnClick = Import1Click
      end
      object Export1: TMenuItem
        Caption = 'Export Products'
        OnClick = Export1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Exit1: TMenuItem
        Caption = 'Exit'
        OnClick = Exit1Click
      end
    end
    object Reports1: TMenuItem
      Caption = 'Reports'
      object RunWEEEReport1: TMenuItem
        Caption = 'Run WEEE Report'
        OnClick = RunWEEEReport1Click
      end
    end
    object Help1: TMenuItem
      Caption = 'Help'
      object About1: TMenuItem
        Caption = 'About'
        OnClick = About1Click
      end
    end
  end
  object bdsReportCats: TBtrieveDataset
    OnGetFieldValue = bdsReportCatsGetFieldValue
    Left = 8
    Top = 416
  end
  object SaveDialog: TSaveDialog
    Left = 136
    Top = 416
  end
  object OpenDialog: TOpenDialog
    Left = 168
    Top = 416
  end
  object EnterToTab1: TEnterToTab
    ConvertEnters = True
    OverrideFont = False
    Version = 'TEnterToTab v1.02 for Delphi 6.01'
    Left = 200
    Top = 416
  end
  object bdsReportSubCats: TBtrieveDataset
    OnGetFieldValue = bdsReportSubCatsGetFieldValue
    Left = 296
    Top = 416
  end
end
