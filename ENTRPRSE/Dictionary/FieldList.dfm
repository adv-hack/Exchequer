object frmFieldList: TfrmFieldList
  Left = 206
  Top = 133
  Width = 627
  Height = 454
  Caption = 'Data Dictionary Editor v6.3.006'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnDestroy = FormDestroy
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object mlFields: TDBMultiList
    Left = 8
    Top = 8
    Width = 508
    Height = 385
    Custom.SplitterCursor = crHSplit
    Dimensions.HeaderHeight = 18
    Dimensions.SpacerWidth = 1
    Dimensions.SplitterWidth = 3
    Options.BoldActiveColumn = False
    Columns = <
      item
        Caption = 'Field'
        Field = 'F'
        Searchable = True
        Sortable = True
        Width = 80
      end
      item
        Caption = 'Var No'
        Field = 'V'
        Searchable = True
        Sortable = True
        Width = 55
        IndexNo = 1
      end
      item
        Caption = 'Description'
        Field = 'D'
        Width = 175
      end
      item
        Caption = 'Type'
        Field = 'T'
        Width = 60
      end
      item
        Caption = 'Length'
        DataType = dtInteger
        Field = 'L'
        Width = 50
      end
      item
        Caption = 'DPs'
        DataType = dtInteger
        Field = 'P'
        Width = 34
      end>
    TabStop = True
    OnRowDblClick = mlFieldsRowDblClick
    TabOrder = 0
    HeaderFont.Charset = DEFAULT_CHARSET
    HeaderFont.Color = clWindowText
    HeaderFont.Height = -11
    HeaderFont.Name = 'Tahoma'
    HeaderFont.Style = []
    HighlightFont.Charset = DEFAULT_CHARSET
    HighlightFont.Color = clWhite
    HighlightFont.Height = -11
    HighlightFont.Name = 'Tahoma'
    HighlightFont.Style = []
    MultiSelectFont.Charset = DEFAULT_CHARSET
    MultiSelectFont.Color = clWindowText
    MultiSelectFont.Height = -11
    MultiSelectFont.Name = 'Tahoma'
    MultiSelectFont.Style = []
    Version = 'v1.13'
    Dataset = bdsFields
    Active = False
    SortColIndex = 0
    SortAsc = True
  end
  object panButts: TPanel
    Left = 528
    Top = 8
    Width = 81
    Height = 129
    BevelOuter = bvNone
    TabOrder = 1
    object btnAdd: TButton
      Tag = 2
      Left = 1
      Top = 32
      Width = 80
      Height = 21
      Caption = '&Add'
      TabOrder = 0
      OnClick = AddEditField
    end
    object btnEdit: TButton
      Tag = 1
      Left = 1
      Top = 56
      Width = 80
      Height = 21
      Caption = '&Edit'
      TabOrder = 1
      OnClick = AddEditField
    end
    object btnDelete: TButton
      Left = 1
      Top = 104
      Width = 80
      Height = 21
      Caption = '&Delete'
      TabOrder = 2
      OnClick = btnDeleteClick
    end
    object btnClose: TButton
      Left = 1
      Top = 0
      Width = 80
      Height = 21
      Cancel = True
      Caption = '&Close'
      TabOrder = 3
      OnClick = btnCloseClick
    end
    object btnCopy: TButton
      Tag = 2
      Left = 1
      Top = 80
      Width = 80
      Height = 21
      Caption = '&Copy'
      TabOrder = 4
      OnClick = AddEditField
    end
  end
  object bdsFields: TBtrieveDataset
    FileName = 'Dictnary.dat'
    SearchKey = 'DV'
    OnGetFieldValue = bdsFieldsGetFieldValue
    OnSelectRecord = bdsFieldsSelectRecord
    Left = 16
    Top = 32
  end
  object MainMenu1: TMainMenu
    object File1: TMenuItem
      Caption = 'File'
      object ExporttoCSV1: TMenuItem
        Caption = 'Export to CSV'
        OnClick = ExporttoCSV1Click
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object Exit1: TMenuItem
        Caption = 'Exit'
        OnClick = Exit1Click
      end
    end
    object Functions1: TMenuItem
      Caption = 'Functions'
      object SetFlagsforRangeofFields1: TMenuItem
        Caption = 'Set one Flag for a Range of Fields'
        OnClick = SetFlagsforRangeofFields1Click
      end
      object SetoneFlagforaListofFields1: TMenuItem
        Caption = 'Set one Flag for a List of Fields'
        OnClick = SetoneFlagforaListofFields1Click
      end
      object ResetAllXRefFields1: TMenuItem
        Caption = 'Rebuild All XRef Records'
        OnClick = ResetAllXRefFields1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object CountRecords1: TMenuItem
        Caption = 'Count Records'
        OnClick = CountRecords1Click
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object RebuildDictnarydattodictnewdat1: TMenuItem
        Caption = 'Rebuild Dictnary.dat to dictnew.dat'
        OnClick = RebuildDictnarydattodictnewdat1Click
      end
    end
  end
  object dlgSave: TSaveDialog
    Filter = '*.CSV'
    Left = 528
    Top = 144
  end
end