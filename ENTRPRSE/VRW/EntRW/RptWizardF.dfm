object frmRepWizard: TfrmRepWizard
  Left = 240
  Top = 187
  BorderIcons = [biSystemMenu, biHelp]
  BorderStyle = bsSingle
  Caption = 'Add Report Wizard'
  ClientHeight = 366
  ClientWidth = 689
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Scaled = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 14
  object PageControl1: TPageControl
    Left = 190
    Top = 5
    Width = 493
    Height = 331
    ActivePage = tabshInitialParams
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabIndex = 0
    TabOrder = 0
    OnChange = PageControl1Change
    object tabshInitialParams: TTabSheet
      HelpContext = 105
      Caption = 'Report Name && Type'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      object lblReportType: TLabel
        Left = 10
        Top = 178
        Width = 423
        Height = 14
        AutoSize = False
        Caption = 'Specify the type of item you want to add into the Report Tree:-'
        WordWrap = True
      end
      object lblReportDesc: TLabel
        Left = 10
        Top = 58
        Width = 446
        Height = 29
        AutoSize = False
        Caption = 
          'The Report Description can be used to provide additional descrip' +
          'tive text which is also shown in the Report Tree:-'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        WordWrap = True
      end
      object Label82: Label8
        Left = 10
        Top = 8
        Width = 331
        Height = 14
        Caption = 
          'The name uniquely identifies the Group or Report in the Report T' +
          'ree:-'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object memReportDesc: TMemo
        Left = 27
        Top = 92
        Width = 413
        Height = 73
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 255
        ParentFont = False
        TabOrder = 1
      end
      object edtReportName: Text8Pt
        Left = 27
        Top = 28
        Width = 204
        Height = 22
        CharCase = ecUpperCase
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 20
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnKeyPress = edtReportNameKeyPress
        TextId = 0
        ViaSBtn = False
      end
      object radReport: TBorRadio
        Left = 27
        Top = 198
        Width = 98
        Height = 20
        Align = alRight
        Caption = 'Report'
        Checked = True
        TabOrder = 2
        TabStop = True
        TextId = 0
        OnClick = radGroupClick
      end
      object radGroup: TBorRadio
        Left = 27
        Top = 221
        Width = 98
        Height = 20
        Align = alRight
        Caption = 'Report Group'
        TabOrder = 3
        TextId = 0
        OnClick = radGroupClick
      end
    end
    object tabshMainFile: TTabSheet
      HelpContext = 144
      Caption = 'Main File && Index'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ImageIndex = 1
      ParentFont = False
      object Label81: Label8
        Left = 10
        Top = 8
        Width = 320
        Height = 14
        Caption = 
          'Select the Exchequer Data File that you want the report to run o' +
          'n:-'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object lblIndex: TLabel
        Left = 10
        Top = 58
        Width = 446
        Height = 29
        AutoSize = False
        Caption = 
          'The selected file uses indexes to reduce the time taken to gener' +
          'ate a report, please select the index most applicable to your re' +
          'port:-'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        WordWrap = True
      end
      object cbMainFile: TComboBox
        Left = 27
        Top = 28
        Width = 203
        Height = 22
        Style = csDropDownList
        ItemHeight = 14
        TabOrder = 0
        OnClick = cbMainFileClick
      end
      object cbIndex: TComboBox
        Left = 27
        Top = 92
        Width = 204
        Height = 22
        Style = csDropDownList
        Enabled = False
        ItemHeight = 14
        ParentShowHint = False
        ShowHint = False
        TabOrder = 1
      end
    end
    object tabshSelectDBFields: TTabSheet
      HelpContext = 9
      Caption = 'Select Database Fields'
      ImageIndex = 2
      object Label83: Label8
        Left = 10
        Top = 8
        Width = 465
        Height = 17
        AutoSize = False
        Caption = 
          'Please specify the fields that you want to appear on the report:' +
          '-'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        WordWrap = True
        TextId = 0
      end
      object mulDBFields: TMultiList
        Left = 10
        Top = 28
        Width = 464
        Height = 244
        Custom.SplitterCursor = crHSplit
        Dimensions.HeaderHeight = 18
        Dimensions.SpacerWidth = 1
        Dimensions.SplitterWidth = 3
        Options.BoldActiveColumn = False
        Columns = <
          item
            Caption = 'Field Name'
            Field = 'ssReportField'
            Width = 84
          end
          item
            Caption = 'Field Description'
            Width = 180
          end
          item
            Caption = 'Column Title'
            Width = 120
          end
          item
            Caption = 'Total?'
            DataType = dtBoolean
            Width = 33
          end>
        TabStop = True
        OnRowDblClick = mulDBFieldsRowDblClick
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        TabOrder = 0
        OnKeyDown = mulDBFieldsKeyDown
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
      object btnFieldUp: TButton
        Tag = 1
        Left = 287
        Top = 277
        Width = 80
        Height = 21
        Caption = 'Move &Up'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 4
        OnClick = btnFieldUpClick
      end
      object btnFieldDown: TButton
        Tag = 2
        Left = 372
        Top = 277
        Width = 80
        Height = 21
        Caption = 'Move Do&wn'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 5
        OnClick = btnFieldDownClick
      end
      object btnAddDBField: TButton
        Tag = 1
        Left = 33
        Top = 277
        Width = 80
        Height = 21
        Caption = '&Add Field'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        OnClick = btnAddDBFieldClick
      end
      object btnDeleteDBField: TButton
        Tag = 2
        Left = 202
        Top = 277
        Width = 80
        Height = 21
        Caption = '&Delete Field'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        OnClick = btnDeleteDBFieldClick
      end
      object btnEditProperties: TButton
        Tag = 2
        Left = 118
        Top = 277
        Width = 80
        Height = 21
        Caption = '&Properties'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        OnClick = btnEditPropertiesClick
      end
    end
    object tabshSortBreaks: TTabSheet
      HelpContext = 110
      Caption = 'Sorting'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ImageIndex = 3
      ParentFont = False
      object Label84: Label8
        Left = 10
        Top = 8
        Width = 465
        Height = 17
        AutoSize = False
        Caption = 
          'Please specify which fields should be used to sort the data appe' +
          'aring on the report:-'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        WordWrap = True
        TextId = 0
      end
      object btnAddOne: TButton
        Left = 135
        Top = 125
        Width = 25
        Height = 25
        Hint = 'Add field to sort list'
        Caption = '>'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        OnClick = btnAddOneClick
      end
      object btnRemoveOne: TButton
        Left = 135
        Top = 156
        Width = 25
        Height = 25
        Hint = 'Remove field from sort list'
        Caption = '<'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        OnClick = btnRemoveOneClick
      end
      object mulUnsorted: TMultiList
        Left = 10
        Top = 28
        Width = 120
        Height = 244
        Custom.SplitterCursor = crHSplit
        Dimensions.HeaderHeight = 18
        Dimensions.SpacerWidth = 1
        Dimensions.SplitterWidth = 3
        Options.BoldActiveColumn = False
        Columns = <
          item
            Caption = 'Report Fields'
            Field = 'Report Fields'
            Width = 86
          end>
        TabStop = True
        OnRowDblClick = mulUnsortedRowDblClick
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
      end
      object mulSorted: TMultiList
        Left = 165
        Top = 28
        Width = 309
        Height = 244
        Custom.SplitterCursor = crHSplit
        Dimensions.HeaderHeight = 18
        Dimensions.SpacerWidth = 1
        Dimensions.SplitterWidth = 3
        Options.BoldActiveColumn = False
        Columns = <
          item
            Caption = 'Fields to sort by'
          end
          item
            Caption = 'Sort Order'
            Width = 93
          end
          item
            Caption = 'Page Break?'
            Width = 74
          end>
        TabStop = True
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
        MultiSelectFont.Color = clWindowText
        MultiSelectFont.Height = -11
        MultiSelectFont.Name = 'Arial'
        MultiSelectFont.Style = []
        Version = 'v1.13'
      end
      object btnSortUp: TButton
        Tag = 1
        Left = 322
        Top = 277
        Width = 73
        Height = 21
        Hint = 'Raise sort priority'
        Caption = 'Move Up'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 6
        OnClick = btnSortUpClick
      end
      object btnSortDown: TButton
        Tag = 2
        Left = 401
        Top = 277
        Width = 73
        Height = 21
        Hint = 'Lower sort priority'
        Caption = 'Move Down'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 7
        OnClick = btnSortDownClick
      end
      object btnPageBreak: TButton
        Left = 243
        Top = 277
        Width = 73
        Height = 21
        Caption = '&Page Break'
        TabOrder = 5
        OnClick = btnPageBreakClick
      end
      object btnSortOrder: TButton
        Left = 165
        Top = 277
        Width = 73
        Height = 21
        Caption = '&Sort Order'
        TabOrder = 4
        OnClick = btnSortOrderClick
      end
    end
    object tabshFilters: TTabSheet
      HelpContext = 147
      Caption = 'Selection Criteria'
      ImageIndex = 4
      object Label85: Label8
        Left = 10
        Top = 8
        Width = 465
        Height = 17
        AutoSize = False
        Caption = 
          'To control the data being included within the report optional fi' +
          'lters can be specified:-'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        WordWrap = True
        TextId = 0
      end
      object mulFieldFilters: TMultiList
        Left = 10
        Top = 28
        Width = 464
        Height = 244
        Custom.SplitterCursor = crHSplit
        Dimensions.HeaderHeight = 18
        Dimensions.SpacerWidth = 1
        Dimensions.SplitterWidth = 3
        Options.BoldActiveColumn = False
        Columns = <
          item
            Caption = 'Field Name'
            Field = 'ssReportField'
            Width = 91
          end
          item
            Caption = 'Filter'
            Width = 335
          end>
        TabStop = True
        OnRowDblClick = mulFieldFiltersRowDblClick
        Font.Charset = DEFAULT_CHARSET
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
      end
      object btnEditFilter: TButton
        Tag = 1
        Left = 205
        Top = 277
        Width = 80
        Height = 21
        Caption = 'Change &Filter'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        OnClick = btnEditFilterClick
      end
    end
    object tabshReportSections: TTabSheet
      HelpContext = 155
      Caption = 'Report Sections'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ImageIndex = 5
      ParentFont = False
      object Label86: Label8
        Left = 10
        Top = 8
        Width = 465
        Height = 17
        AutoSize = False
        Caption = 
          'The report consists of the sections shown below, use the buttons' +
          ' to hide unwanted sections:-'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        WordWrap = True
        TextId = 0
      end
      object lbSections: TListBox
        Left = 10
        Top = 28
        Width = 379
        Height = 256
        Style = lbOwnerDrawFixed
        IntegralHeight = True
        ItemHeight = 14
        TabOrder = 0
        OnClick = lbSectionsClick
        OnDblClick = lbSectionsDblClick
        OnDrawItem = lbSectionsDrawItem
      end
      object btnShowSection: TButton
        Left = 394
        Top = 29
        Width = 80
        Height = 21
        Caption = '&Show Section'
        TabOrder = 1
        OnClick = btnShowSectionClick
      end
      object btnHideSection: TButton
        Left = 394
        Top = 55
        Width = 80
        Height = 21
        Caption = '&Hide Section'
        TabOrder = 2
        OnClick = btnHideSectionClick
      end
      object btnShowAllSections: TButton
        Left = 394
        Top = 80
        Width = 80
        Height = 21
        Caption = 'Show &All'
        TabOrder = 3
        OnClick = btnShowAllSectionsClick
      end
    end
  end
  object btnBack: TButton
    Left = 414
    Top = 341
    Width = 80
    Height = 21
    Caption = '<< &Back'
    TabOrder = 1
    OnClick = btnBackClick
  end
  object btnNext: TButton
    Left = 502
    Top = 341
    Width = 80
    Height = 21
    Caption = '&Next >>'
    TabOrder = 2
    OnClick = btnNextClick
  end
  object btnCancel: TButton
    Left = 589
    Top = 341
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    TabOrder = 3
    OnClick = btnCancelClick
  end
  object pnlImage: TPanel
    Left = 4
    Top = 5
    Width = 185
    Height = 331
    BevelInner = bvRaised
    BevelOuter = bvNone
    TabOrder = 4
    object imgPanelImage: TImage
      Left = 0
      Top = 0
      Width = 185
      Height = 331
      Center = True
      Stretch = True
    end
  end
  object pmTableNamesMenu: TPopupMenu
    Left = 70
    Top = 235
  end
  object EnterToTab1: TEnterToTab
    ConvertEnters = True
    OverrideFont = True
    Version = 'TEnterToTab v1.02 for Delphi 6.01'
    Left = 71
    Top = 287
  end
end
