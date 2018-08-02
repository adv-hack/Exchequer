object frmDebt: TfrmDebt
  Left = 276
  Top = 263
  Width = 490
  Height = 258
  HorzScrollBar.Visible = False
  Caption = 'Debt Collection Charge Scale'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  PopupMenu = pmMain
  Position = poScreenCenter
  Scaled = False
  Visible = True
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
    Width = 377
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
        DataType = dtFloat
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
      end
      item
        Caption = 'Folio'
        DataType = dtInteger
        Field = '1'
        Searchable = True
        Sortable = True
        IndexNo = 1
      end>
    TabStop = True
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
  object btnFind: TButton
    Left = 392
    Top = 48
    Width = 80
    Height = 21
    Caption = '&Find Dbl'
    TabOrder = 1
    OnClick = btnFindClick
  end
  object btnClose: TButton
    Left = 392
    Top = 192
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Close'
    TabOrder = 3
    OnClick = btnCloseClick
  end
  object btnEdit: TButton
    Left = 392
    Top = 128
    Width = 80
    Height = 21
    Caption = 'Find Int'
    TabOrder = 2
    OnClick = btnEditClick
  end
  object btnFD: TButton
    Left = 392
    Top = 88
    Width = 80
    Height = 21
    Caption = '&Find Dbl (full)'
    TabOrder = 4
    OnClick = btnFDClick
  end
  object Button2: TButton
    Left = 392
    Top = 168
    Width = 80
    Height = 21
    Caption = 'Find Int (full)'
    TabOrder = 5
    OnClick = Button2Click
  end
  object edD: TNumEdit
    Left = 392
    Top = 24
    Width = 81
    Height = 22
    TabOrder = 6
    Text = '12.00'
    EditAlignment = alLeft
    PermitNegatives = False
    PermitDecimals = True
    DecimalPlaces = 2
    Value = 12
  end
  object edDF: TNumEdit
    Left = 392
    Top = 64
    Width = 81
    Height = 22
    TabOrder = 7
    Text = '12.00'
    EditAlignment = alLeft
    PermitNegatives = False
    PermitDecimals = True
    DecimalPlaces = 2
    Value = 12
  end
  object edI: TNumEdit
    Left = 392
    Top = 104
    Width = 81
    Height = 22
    TabOrder = 8
    Text = '13'
    EditAlignment = alLeft
    PermitNegatives = False
    PermitDecimals = False
    DecimalPlaces = 0
    Value = 13
  end
  object edIF: TNumEdit
    Left = 392
    Top = 144
    Width = 81
    Height = 22
    TabOrder = 9
    Text = '13'
    EditAlignment = alLeft
    PermitNegatives = False
    PermitDecimals = False
    DecimalPlaces = 0
    Value = 13
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
    end
    object Edit1: TMenuItem
      Caption = 'Edit'
    end
    object Delete1: TMenuItem
      Caption = 'Delete'
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
