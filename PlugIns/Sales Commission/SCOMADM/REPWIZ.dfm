object frmRepWizard: TfrmRepWizard
  Left = 310
  Top = 139
  BorderStyle = bsDialog
  Caption = 'Sales Commission Report'
  ClientHeight = 448
  ClientWidth = 480
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  PopupMenu = pmMain
  Position = poScreenCenter
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object pcWizard: TPageControl
    Left = 0
    Top = 3
    Width = 480
    Height = 406
    ActivePage = tsRanges
    Style = tsFlatButtons
    TabIndex = 4
    TabOrder = 0
    OnChange = pcWizardChange
    OnChanging = pcWizardChanging
    object tsFilters: TTabSheet
      Caption = '1. Data'
      object Label9: TLabel
        Left = 16
        Top = 16
        Width = 309
        Height = 14
        Caption = 'Pick the date range that  you wish to run this report for :'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
      end
      object Label10: TLabel
        Left = 29
        Top = 44
        Width = 55
        Height = 14
        Caption = 'Date From :'
        Transparent = True
      end
      object Label11: TLabel
        Left = 29
        Top = 76
        Width = 42
        Height = 14
        Caption = 'Date To :'
        Transparent = True
      end
      object Bevel3: TBevel
        Left = 0
        Top = 0
        Width = 472
        Height = 374
        Align = alClient
        Shape = bsFrame
      end
      object edDateFrom: TDateTimePicker
        Left = 88
        Top = 40
        Width = 137
        Height = 22
        BevelEdges = []
        BevelInner = bvNone
        BevelOuter = bvNone
        CalAlignment = dtaLeft
        Date = 37855.538082419
        Time = 37855.538082419
        DateFormat = dfShort
        DateMode = dmComboBox
        Kind = dtkDate
        ParseInput = False
        TabOrder = 0
        OnChange = edDateChange
      end
      object edDateTo: TDateTimePicker
        Left = 88
        Top = 72
        Width = 137
        Height = 22
        CalAlignment = dtaLeft
        Date = 37855.538082419
        Time = 37855.538082419
        DateFormat = dfShort
        DateMode = dmComboBox
        Kind = dtkDate
        ParseInput = False
        TabOrder = 1
        OnChange = edDateChange
      end
    end
    object tsCustomer: TTabSheet
      Caption = '2. Customers'
      ImageIndex = 4
      object Bevel4: TBevel
        Left = 0
        Top = 0
        Width = 472
        Height = 374
        Align = alClient
        Shape = bsFrame
      end
      object Bevel2: TBevel
        Left = 26
        Top = 336
        Width = 7
        Height = 33
        Shape = bsTopLine
      end
      object Bevel1: TBevel
        Left = 24
        Top = 320
        Width = 17
        Height = 33
        Shape = bsLeftLine
        Style = bsRaised
      end
      object lIncludeCustAccType: TLabel
        Left = 37
        Top = 329
        Width = 134
        Height = 14
        Caption = 'Only Include Account Type :'
        Enabled = False
        Transparent = True
      end
      object Label7: TLabel
        Left = 16
        Top = 16
        Width = 330
        Height = 14
        Caption = 'Select the Customers that you wish to include in this report'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
      end
      object Label1: TLabel
        Left = 24
        Top = 32
        Width = 268
        Height = 14
        Caption = 'Double click on each customer in the list, to select them.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
      object edIncludeCustAccType: TEdit
        Left = 177
        Top = 327
        Width = 121
        Height = 22
        Enabled = False
        MaxLength = 4
        TabOrder = 2
      end
      object cbFilterByCustAccType: TCheckBox
        Left = 16
        Top = 304
        Width = 377
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Do you wish to filter the selected Customers by  Account Type ?'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        TabOrder = 1
        OnClick = cbFilterByCustAccTypeClick
      end
      object mlCustomers: TDBMultiList
        Left = 24
        Top = 48
        Width = 353
        Height = 251
        Colours.MultiSelection = 10841658
        Colours.Selection = clNavy
        Custom.SplitterCursor = crHSplit
        Dimensions.HeaderHeight = 18
        Dimensions.SpacerWidth = 1
        Dimensions.SplitterWidth = 3
        Options.BoldActiveColumn = False
        Options.MultiSelection = True
        Options.MultiSelectIntegrity = True
        Columns = <
          item
            Caption = 'Code'
            Field = 'C'
            Searchable = True
            Sortable = True
          end
          item
            Caption = 'Description'
            Field = 'D'
            Searchable = True
            Sortable = True
            Width = 215
            IndexNo = 1
          end>
        TabStop = True
        OnRowDblClick = MultiListRowDblClick
        OnMultiSelect = MultiListMultiSelect
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
        MultiSelectFont.Color = clWhite
        MultiSelectFont.Height = -11
        MultiSelectFont.Name = 'Arial'
        MultiSelectFont.Style = []
        Version = 'v1.13'
        Active = True
        SortColIndex = 0
        SortAsc = True
      end
      object btnCuSelectAll: TButton
        Tag = 1
        Left = 384
        Top = 48
        Width = 80
        Height = 21
        Caption = 'Select All'
        TabOrder = 3
        OnClick = SelectDeselectAll
      end
    end
    object tsTXtype: TTabSheet
      Caption = '3. Transactions'
      ImageIndex = 3
      object Bevel5: TBevel
        Left = 26
        Top = 296
        Width = 7
        Height = 33
        Shape = bsTopLine
      end
      object Bevel6: TBevel
        Left = 24
        Top = 280
        Width = 17
        Height = 33
        Shape = bsLeftLine
        Style = bsRaised
      end
      object lTXCurrency: TLabel
        Left = 37
        Top = 289
        Width = 113
        Height = 14
        Caption = 'Only Include Currency :'
        Enabled = False
        Transparent = True
      end
      object Label8: TLabel
        Left = 16
        Top = 16
        Width = 338
        Height = 14
        Caption = 'Tick the Transaction Types you wish to include in this report :'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
      end
      object Bevel13: TBevel
        Left = 0
        Top = 0
        Width = 472
        Height = 374
        Align = alClient
        Shape = bsFrame
      end
      object cbFilterByTXCurrency: TCheckBox
        Left = 16
        Top = 264
        Width = 305
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Do you wish to filter by Transaction Currency ?'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        TabOrder = 0
        OnClick = cbFilterByTXCurrencyClick
      end
      object cbOnlyIncludePaidOffTXs: TCheckBox
        Left = 16
        Top = 208
        Width = 329
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Do you wish to include only fully paid off transactions ?'
        Checked = True
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        State = cbChecked
        TabOrder = 1
      end
      object lbTXs: TCheckListBox
        Left = 16
        Top = 32
        Width = 361
        Height = 130
        OnClickCheck = lbTXsClickCheck
        ItemHeight = 14
        Items.Strings = (
          'Sales Invoice (SIN)'
          'Sales Credit Note (SCR)'
          'Sales Journal Invoice (SJI)'
          'Sales Journal Credit (SJC)'
          'Sales Refund (SRF)'
          'Sales Receipt + Invoice (SRI)'
          'Sales Order (SOR)'
          'Sales Delivery Note (SDN)'
          'Sales Quotation (SQU)')
        TabOrder = 2
      end
      object cmbTXCurrency: TComboBox
        Left = 160
        Top = 288
        Width = 161
        Height = 22
        Style = csDropDownList
        Enabled = False
        ItemHeight = 14
        TabOrder = 3
      end
      object btnTXSelectAll: TButton
        Tag = 1
        Left = 384
        Top = 32
        Width = 80
        Height = 21
        Caption = 'Select All'
        TabOrder = 4
        OnClick = SelectDeselectAll
      end
    end
    object TabSheet1: TTabSheet
      Caption = '4. Stock'
      ImageIndex = 5
      object Bevel9: TBevel
        Left = 24
        Top = 104
        Width = 7
        Height = 33
        Shape = bsTopLine
      end
      object Bevel10: TBevel
        Left = 24
        Top = 280
        Width = 7
        Height = 33
        Shape = bsTopLine
      end
      object Bevel11: TBevel
        Left = 22
        Top = 206
        Width = 17
        Height = 75
        Shape = bsLeftLine
        Style = bsRaised
      end
      object Bevel12: TBevel
        Left = 22
        Top = 30
        Width = 17
        Height = 75
        Shape = bsLeftLine
        Style = bsRaised
      end
      object Bevel14: TBevel
        Left = 0
        Top = 0
        Width = 472
        Height = 374
        Align = alClient
        Shape = bsFrame
      end
      object rbProduct: TRadioButton
        Left = 16
        Top = 16
        Width = 321
        Height = 17
        Caption = 'I wish to manually pick the products to report on :'
        Checked = True
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        TabOrder = 0
        TabStop = True
        OnClick = rbProductClick
      end
      object rbProdGroup: TRadioButton
        Left = 16
        Top = 192
        Width = 321
        Height = 17
        Caption = 'I wish to filter the products by product group :'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        TabOrder = 1
        OnClick = rbProductClick
      end
      object mlProducts: TDBMultiList
        Left = 32
        Top = 32
        Width = 345
        Height = 153
        Colours.MultiSelection = 10841658
        Colours.Selection = clNavy
        Custom.SplitterCursor = crHSplit
        Dimensions.HeaderHeight = 18
        Dimensions.SpacerWidth = 1
        Dimensions.SplitterWidth = 3
        Options.BoldActiveColumn = False
        Options.MultiSelection = True
        Options.MultiSelectIntegrity = True
        Columns = <
          item
            Caption = 'Code'
            Field = 'C'
            Searchable = True
            Sortable = True
          end
          item
            Caption = 'Description'
            Field = 'D'
            Searchable = True
            Sortable = True
            Width = 207
            IndexNo = 3
          end>
        TabStop = True
        OnRowDblClick = MultiListRowDblClick
        OnMultiSelect = MultiListMultiSelect
        TabOrder = 2
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
        MultiSelectFont.Color = clWhite
        MultiSelectFont.Height = -11
        MultiSelectFont.Name = 'Arial'
        MultiSelectFont.Style = []
        Version = 'v1.13'
        Active = True
        SortColIndex = 0
        SortAsc = True
      end
      object mlProdGroups: TDBMultiList
        Left = 32
        Top = 208
        Width = 345
        Height = 153
        Colours.MultiSelection = 10841658
        Colours.Selection = clNavy
        Custom.SplitterCursor = crHSplit
        Dimensions.HeaderHeight = 18
        Dimensions.SpacerWidth = 1
        Dimensions.SplitterWidth = 3
        Options.BoldActiveColumn = False
        Options.MultiSelection = True
        Options.MultiSelectIntegrity = True
        Columns = <
          item
            Caption = 'Code'
            Field = 'C'
            Searchable = True
            Sortable = True
          end
          item
            Caption = 'Description'
            Field = 'D'
            Searchable = True
            Sortable = True
            Width = 207
            IndexNo = 3
          end>
        TabStop = True
        OnRowDblClick = MultiListRowDblClick
        OnMultiSelect = MultiListMultiSelect
        Enabled = False
        TabOrder = 3
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
        MultiSelectFont.Color = clWhite
        MultiSelectFont.Height = -11
        MultiSelectFont.Name = 'Arial'
        MultiSelectFont.Style = []
        Version = 'v1.13'
        Active = True
        SortColIndex = 0
        SortAsc = True
      end
      object btnPrSelectAll: TButton
        Tag = 1
        Left = 384
        Top = 32
        Width = 80
        Height = 21
        Caption = 'Select All'
        TabOrder = 4
        OnClick = SelectDeselectAll
      end
      object btnPGSelectAll: TButton
        Tag = 1
        Left = 384
        Top = 208
        Width = 80
        Height = 21
        Caption = 'Select All'
        Enabled = False
        TabOrder = 5
        OnClick = SelectDeselectAll
      end
    end
    object tsRanges: TTabSheet
      Caption = '5. Sales Codes'
      ImageIndex = 1
      object Label12: TLabel
        Left = 8
        Top = 8
        Width = 3
        Height = 14
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
      end
      object Bevel7: TBevel
        Left = 13
        Top = 48
        Width = 15
        Height = 153
        Shape = bsLeftLine
        Style = bsRaised
      end
      object Bevel8: TBevel
        Left = 14
        Top = 200
        Width = 26
        Height = 33
        Shape = bsTopLine
      end
      object Bevel15: TBevel
        Left = 253
        Top = 48
        Width = 17
        Height = 153
        Shape = bsLeftLine
        Style = bsRaised
      end
      object Bevel16: TBevel
        Left = 255
        Top = 200
        Width = 10
        Height = 33
        Shape = bsTopLine
      end
      object Label2: TLabel
        Left = 16
        Top = 16
        Width = 53
        Height = 14
        Caption = 'I wish to :'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
      end
      object Bevel17: TBevel
        Left = 0
        Top = 0
        Width = 472
        Height = 374
        Align = alClient
        Shape = bsFrame
      end
      object rbPickSalesCodes: TRadioButton
        Left = 8
        Top = 40
        Width = 193
        Height = 17
        Caption = 'manually pick the sales codes :'
        Checked = True
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        TabOrder = 0
        TabStop = True
        OnClick = rbPickSalesCodesClick
      end
      object rbPickSalesCodeTypes: TRadioButton
        Left = 248
        Top = 40
        Width = 193
        Height = 17
        Caption = 'filter the sales codes by type :'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        TabOrder = 1
        OnClick = rbPickSalesCodesClick
      end
      object mlSalesCodes: TDBMultiList
        Left = 24
        Top = 64
        Width = 209
        Height = 273
        Colours.MultiSelection = 10841658
        Colours.Selection = clNavy
        Custom.SplitterCursor = crHSplit
        Dimensions.HeaderHeight = 18
        Dimensions.SpacerWidth = 1
        Dimensions.SplitterWidth = 3
        Options.BoldActiveColumn = False
        Options.MultiSelection = True
        Options.MultiSelectIntegrity = True
        Columns = <
          item
            Caption = 'Code'
            Field = 'C'
            Searchable = True
            Sortable = True
            Width = 61
            IndexNo = 1
          end
          item
            Caption = 'Description'
            Field = 'D'
            Searchable = True
            Sortable = True
            Width = 110
            IndexNo = 2
          end>
        TabStop = True
        OnRowDblClick = MultiListRowDblClick
        OnMultiSelect = MultiListMultiSelect
        TabOrder = 2
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
        MultiSelectFont.Color = clWhite
        MultiSelectFont.Height = -11
        MultiSelectFont.Name = 'Arial'
        MultiSelectFont.Style = []
        Version = 'v1.13'
        Dataset = bdsSalesCode
        Active = False
        SortColIndex = 0
        SortAsc = True
      end
      object mlSalesCodeTypes: TDBMultiList
        Left = 264
        Top = 64
        Width = 185
        Height = 273
        Colours.MultiSelection = 10841658
        Colours.Selection = clNavy
        Custom.SplitterCursor = crHSplit
        Dimensions.HeaderHeight = 18
        Dimensions.SpacerWidth = 1
        Dimensions.SplitterWidth = 3
        Options.BoldActiveColumn = False
        Options.MultiSelection = True
        Options.MultiSelectIntegrity = True
        Columns = <
          item
            Caption = 'Sales Code Type'
            Field = 'D'
            Searchable = True
            Sortable = True
            Width = 151
            IndexNo = 1
          end>
        TabStop = True
        OnRowDblClick = MultiListRowDblClick
        OnMultiSelect = MultiListMultiSelect
        Enabled = False
        TabOrder = 3
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
        MultiSelectFont.Color = clWhite
        MultiSelectFont.Height = -11
        MultiSelectFont.Name = 'Arial'
        MultiSelectFont.Style = []
        Version = 'v1.13'
        Dataset = bdsSalesCodeType
        Active = False
        SortColIndex = 0
        SortAsc = True
      end
      object btnSCSelectAll: TButton
        Tag = 1
        Left = 152
        Top = 344
        Width = 80
        Height = 21
        Caption = 'Select All'
        TabOrder = 4
        OnClick = SelectDeselectAll
      end
      object btnSCTSelectAll: TButton
        Tag = 1
        Left = 368
        Top = 344
        Width = 80
        Height = 21
        Caption = 'Select All'
        Enabled = False
        TabOrder = 5
        OnClick = SelectDeselectAll
      end
    end
    object tsConditions: TTabSheet
      Caption = '6. Conditions'
      ImageIndex = 2
      object lConvertCurrency: TLabel
        Left = 16
        Top = 115
        Width = 219
        Height = 14
        Caption = 'Report all commission in this currency :'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
      end
      object Bevel18: TBevel
        Left = 0
        Top = 0
        Width = 472
        Height = 374
        Align = alClient
        Shape = bsFrame
      end
      object cbGeneratePJI: TCheckBox
        Left = 16
        Top = 24
        Width = 305
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Do you wish to Generate a PJI for the commission ?'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        TabOrder = 0
        OnClick = cbGeneratePJIClick
      end
      object cmbConvertCurrency: TComboBox
        Left = 240
        Top = 112
        Width = 161
        Height = 22
        Style = csDropDownList
        Enabled = False
        ItemHeight = 14
        TabOrder = 1
        OnChange = cmbConvertCurrencyChange
      end
      object cbCostAllocLineCost: TCheckBox
        Left = 16
        Top = 64
        Width = 305
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Do you wish to use the Cost Allocation line cost ?'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        TabOrder = 2
      end
    end
  end
  object btnNext: TButton
    Left = 304
    Top = 418
    Width = 80
    Height = 21
    Caption = '&Next >>'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = btnNextClick
  end
  object btnPrevious: TButton
    Left = 216
    Top = 418
    Width = 80
    Height = 21
    Caption = '<< &Previous'
    Enabled = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    OnClick = btnPreviousClick
  end
  object btnCancel: TButton
    Left = 392
    Top = 418
    Width = 80
    Height = 21
    Caption = '&Cancel'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    OnClick = btnCancelClick
  end
  object cdsCustomers: TComTKDataset
    OnGetFieldValue = cdsCustomersGetFieldValue
    Left = 8
    Top = 416
  end
  object bdsSalesCode: TBtrieveDataset
    OnFilterRecord = bdsSalesCodeFilterRecord
    OnGetFieldValue = bdsSalesCodeGetFieldValue
    Left = 48
    Top = 416
  end
  object bdsSalesCodeType: TBtrieveDataset
    OnGetFieldValue = bdsSalesCodeTypeGetFieldValue
    Left = 80
    Top = 416
  end
  object cdsProducts: TComTKDataset
    OnFilterRecord = cdsProductsFilterRecord
    OnGetFieldValue = cdsProductsGetFieldValue
    Left = 120
    Top = 416
  end
  object cdsProdGroup: TComTKDataset
    OnFilterRecord = cdsProdGroupFilterRecord
    OnGetFieldValue = cdsProductsGetFieldValue
    Left = 152
    Top = 416
  end
  object pmMain: TPopupMenu
    Left = 184
    Top = 416
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
