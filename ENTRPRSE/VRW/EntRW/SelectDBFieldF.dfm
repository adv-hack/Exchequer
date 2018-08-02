object frmSelectDBField: TfrmSelectDBField
  Left = 427
  Top = 140
  HelpContext = 10
  BorderIcons = [biSystemMenu, biHelp]
  BorderStyle = bsDialog
  Caption = 'Select Database Field'
  ClientHeight = 421
  ClientWidth = 417
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poOwnerFormCenter
  Scaled = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    417
    421)
  PixelsPerInch = 96
  TextHeight = 14
  object Label81: Label8
    Left = 8
    Top = 371
    Width = 90
    Height = 14
    Caption = '&Find by Field Name'
    FocusControl = edtFindField
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object lstAvailableFiles: TComboBox
    Left = 5
    Top = 4
    Width = 385
    Height = 22
    Style = csDropDownList
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 14
    ParentFont = False
    TabOrder = 4
    OnClick = lstAvailableFilesClick
  end
  object DBMultiList1: TDBMultiList
    Left = 5
    Top = 27
    Width = 407
    Height = 338
    Custom.SplitterCursor = crHSplit
    Dimensions.HeaderHeight = 18
    Dimensions.SpacerWidth = 1
    Dimensions.SplitterWidth = 3
    Options.BoldActiveColumn = False
    Columns = <
      item
        Caption = 'Field Name'
        Field = '0'
        Searchable = True
        Sortable = True
        Width = 120
      end
      item
        Caption = 'Field Description'
        Field = '1'
        Width = 240
      end>
    TabStop = True
    OnRowClick = DBMultiList1RowClick
    OnRowDblClick = DBMultiList1RowDblClick
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
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
    Dataset = BtrieveDataset1
    Active = False
    SortColIndex = 0
    SortAsc = True
  end
  object btnOK: TSBSButton
    Left = 125
    Top = 396
    Width = 80
    Height = 21
    Anchors = [akLeft, akBottom]
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 2
    TextId = 0
  end
  object btnCancel: TSBSButton
    Left = 212
    Top = 396
    Width = 80
    Height = 21
    Anchors = [akLeft, akBottom]
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 3
    TextId = 0
  end
  object edtFindField: TEdit
    Left = 101
    Top = 368
    Width = 100
    Height = 22
    CharCase = ecUpperCase
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 10
    ParentFont = False
    TabOrder = 1
    OnChange = edtFindFieldChange
  end
  object BtrieveDataset1: TBtrieveDataset
    SearchKey = 'DV'
    OnFilterRecord = BtrieveDataset1FilterRecord
    OnGetFieldValue = BtrieveDataset1GetFieldValue
    Left = 321
    Top = 69
  end
  object EnterToTab1: TEnterToTab
    ConvertEnters = True
    OverrideFont = False
    Version = 'TEnterToTab v1.02 for Delphi 6.01'
    Left = 341
    Top = 373
  end
end
