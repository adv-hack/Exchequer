object frmCurrencyList: TfrmCurrencyList
  Left = 116
  Top = 213
  Width = 873
  Height = 526
  Caption = 'Currency Setup'
  Color = clBtnFace
  Constraints.MinHeight = 220
  Constraints.MinWidth = 360
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Position = poDefault
  Scaled = False
  ShowHint = True
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  DesignSize = (
    857
    487)
  PixelsPerInch = 96
  TextHeight = 14
  object bvlSeparator: TBevel
    Left = 770
    Top = 204
    Width = 80
    Height = 6
    Shape = bsTopLine
  end
  object mlCurrencies: TMultiList
    Left = 8
    Top = 8
    Width = 745
    Height = 473
    Custom.SplitterCursor = crHSplit
    Dimensions.HeaderHeight = 18
    Dimensions.SpacerWidth = 1
    Dimensions.SplitterWidth = 3
    Options.BoldActiveColumn = False
    Columns = <
      item
        Caption = 'No'
        Width = 30
      end
      item
        Caption = 'Description'
      end
      item
        Caption = 'Screen Symbol'
        Width = 48
        WrapCaption = True
      end
      item
        Caption = 'Printer Symbol'
        Width = 48
        WrapCaption = True
      end
      item
        Alignment = taRightJustify
        Caption = 'Daily Rate'
        DataType = dtFloat
      end
      item
        Alignment = taRightJustify
        Caption = 'Company Rate'
        DataType = dtFloat
      end
      item
        Caption = '1/x'
        Width = 40
      end
      item
        Caption = 'Float'
        Width = 40
      end
      item
        Alignment = taRightJustify
        Caption = 'Triangulation'
        DataType = dtInteger
        Width = 66
      end
      item
        Alignment = taRightJustify
        Caption = 'Rate'
        DataType = dtFloat
      end>
    TabStop = True
    OnChangeSelection = mlCurrenciesChangeSelection
    OnRowDblClick = mlCurrenciesRowDblClick
    Font.Charset = ANSI_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    PopupMenu = PopupMenu1
    TabOrder = 0
    OnResize = mlCurrenciesResize
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
  object btnAdd: TSBSButton
    Left = 768
    Top = 104
    Width = 80
    Height = 21
    Hint = 'Allows a new Currency to be added'
    Anchors = [akTop]
    Caption = '&Add'
    TabOrder = 2
    OnClick = btnAddClick
    TextId = 0
  end
  object btnEdit: TSBSButton
    Left = 768
    Top = 128
    Width = 80
    Height = 21
    Hint = 'Allows the currently selected Currency to be edited'
    Anchors = [akTop]
    Caption = '&Edit'
    TabOrder = 3
    OnClick = btnEditClick
    TextId = 0
  end
  object btnView: TSBSButton
    Left = 768
    Top = 152
    Width = 80
    Height = 21
    Hint = 'View the currently selected Currency without editing it'
    Anchors = [akTop]
    Caption = '&View'
    TabOrder = 4
    OnClick = btnViewClick
    TextId = 0
  end
  object btnClose: TSBSButton
    Left = 768
    Top = 8
    Width = 80
    Height = 21
    Anchors = [akTop]
    Cancel = True
    Caption = '&Close'
    TabOrder = 1
    OnClick = btnCloseClick
    TextId = 0
  end
  object btnCancel: TSBSButton
    Left = 768
    Top = 32
    Width = 80
    Height = 21
    Anchors = [akTop]
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 8
    Visible = False
    TextId = 0
  end
  object btnExport: TSBSButton
    Left = 768
    Top = 176
    Width = 80
    Height = 21
    Hint = 'Export the Currency Exchange Rate History to file'
    Anchors = [akTop]
    Caption = 'Export &History'
    TabOrder = 5
    OnClick = btnExportClick
    TextId = 0
  end
  object btnExportRates: TSBSButton
    Left = 768
    Top = 210
    Width = 80
    Height = 21
    Hint = 'Export the current Currency Exchange Rates to file'
    Anchors = [akTop]
    Caption = 'E&xport Rates'
    TabOrder = 6
    OnClick = btnExportRatesClick
    TextId = 0
  end
  object btnImportRates: TSBSButton
    Left = 768
    Top = 234
    Width = 80
    Height = 21
    Hint = 'Import the Currency Exchange Rates from file'
    Anchors = [akTop]
    Caption = '&Import Rates'
    TabOrder = 7
    OnClick = btnImportRatesClick
    TextId = 0
  end
  object PopupMenu1: TPopupMenu
    Left = 776
    Top = 312
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
    object ExportHistory1: TMenuItem
      Caption = 'Export &History'
      object OrderByDate2: TMenuItem
        Caption = 'Order by Date'
        OnClick = OrderbyDate1Click
      end
      object OrderByCurrencyNo1: TMenuItem
        Caption = 'Order by Currency No'
        OnClick = OrderbyCurrency1Click
      end
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object ExportRates1: TMenuItem
      Caption = 'E&xport Rates'
      OnClick = btnExportRatesClick
    end
    object ImportRates1: TMenuItem
      Caption = '&Import Rates'
      OnClick = btnImportRatesClick
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object Properties1: TMenuItem
      Caption = '&Properties'
      OnClick = Properties1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object SaveCoordinates1: TMenuItem
      AutoCheck = True
      Caption = '&Save Coordinates'
    end
  end
  object mnuExport: TPopupMenu
    AutoPopup = False
    Left = 776
    Top = 280
    object OrderbyDate1: TMenuItem
      Caption = 'Order by &Date'
      OnClick = OrderbyDate1Click
    end
    object OrderbyCurrency1: TMenuItem
      Caption = 'Order by Currency &No'
      OnClick = OrderbyCurrency1Click
    end
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = '.csv'
    Filter = 'CSV Files (*.csv)|*.csv'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 64
    Top = 56
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = '.csv'
    Filter = 'CSV Files (*.csv)|*.csv'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 64
    Top = 96
  end
end
