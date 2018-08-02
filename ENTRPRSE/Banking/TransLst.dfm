object frmTransList: TfrmTransList
  Left = 207
  Top = 293
  Width = 554
  Height = 367
  HelpContext = 1919
  Caption = 'frmTransList'
  Color = clBtnFace
  Constraints.MinHeight = 210
  Constraints.MinWidth = 200
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  FormStyle = fsMDIChild
  KeyPreview = True
  OldCreateOrder = False
  PopupMenu = PopupMenu1
  Position = poDefault
  Scaled = False
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 14
  object Panel1: TPanel
    Left = 2
    Top = 2
    Width = 543
    Height = 329
    TabOrder = 0
    object TabControl1: TTabControl
      Left = 1
      Top = 1
      Width = 541
      Height = 327
      HelpContext = 1919
      Align = alClient
      TabOrder = 0
      Tabs.Strings = (
        'Itemised'
        'Grouped')
      TabIndex = 0
      TabStop = False
      OnChange = TabControl1Change
      OnChanging = TabControl1Changing
      object Panel3: TPanel
        Left = 4
        Top = 25
        Width = 409
        Height = 296
        BevelOuter = bvNone
        TabOrder = 0
        object mlTrans: TDBMultiList
          Left = 1
          Top = 44
          Width = 400
          Height = 188
          HelpContext = 1919
          Custom.SplitterCursor = crHSplit
          Dimensions.HeaderHeight = 18
          Dimensions.SpacerWidth = 1
          Dimensions.SplitterWidth = 3
          Options.BoldActiveColumn = False
          Columns = <
            item
              Caption = 'Doc'
              Color = clWhite
              Field = 'D'
              Searchable = True
              Sortable = True
              Width = 30
            end
            item
              Caption = 'A/C'
              Color = clWhite
              Field = 'A'
              Searchable = True
              Sortable = True
              Width = 52
              IndexNo = 1
            end
            item
              Caption = 'Reference'
              Color = clWhite
              Field = 'N'
              Searchable = True
              Sortable = True
              Width = 75
              IndexNo = 5
            end
            item
              Alignment = taRightJustify
              Caption = 'Amount'
              Color = clWhite
              DataType = dtFloat
              Field = 'Modigliani'
              Searchable = True
              Sortable = True
              Width = 70
              IndexNo = 4
            end
            item
              Caption = 'Status'
              Color = clWhite
              Field = 'S'
              Searchable = True
              Sortable = True
              Width = 66
              IndexNo = 2
            end
            item
              Caption = 'Date'
              Color = clWhite
              DataType = dtDate
              Field = 'T'
              Searchable = True
              Sortable = True
              Width = 60
              IndexNo = 3
            end
            item
              Alignment = taRightJustify
              Caption = 'Period'
              Color = clWhite
              Field = 'P'
              Width = 52
            end
            item
              Caption = 'Doc No'
              Color = clWhite
              Field = 'O'
              Searchable = True
              Sortable = True
              IndexNo = 7
            end
            item
              Caption = 'Line Description'
              Color = clWhite
              Field = 'L'
              Searchable = True
              Sortable = True
              Width = 150
              IndexNo = 8
            end
            item
              Caption = 'Recon Date'
              Color = clWhite
              DataType = dtDate
              Field = 'R'
              Width = 60
            end>
          TabStop = True
          OnColumnClick = mlTransColumnClick
          OnChangeSelection = mlTransChangeSelection
          OnRowDblClick = mlTransRowDblClick
          OnMultiSelect = mlTransMultiSelect
          Font.Charset = ANSI_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          TabOrder = 0
          OnEndDrag = mlTransEndDrag
          OnMouseDown = mlTransMouseDown
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
          MultiSelectFont.Color = clAqua
          MultiSelectFont.Height = -11
          MultiSelectFont.Name = 'Arial'
          MultiSelectFont.Style = []
          Version = 'v1.13'
          Dataset = btData
          OnBeforeLoad = mlTransBeforeLoad
          Active = False
          SortColIndex = 0
          SortAsc = True
        end
        object pnlItemTop: TPanel
          Left = 0
          Top = 0
          Width = 409
          Height = 39
          HelpContext = 1919
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 1
          object Label1: TLabel
            Left = 2
            Top = 4
            Width = 90
            Height = 14
            Caption = 'Statement Balance'
          end
          object Label2: TLabel
            Left = 138
            Top = 4
            Width = 51
            Height = 14
            Caption = 'Difference'
          end
          object Label3: TLabel
            Left = 274
            Top = 4
            Width = 82
            Height = 14
            Caption = 'Opening Balance'
          end
          object ceStatBalance: TCurrencyEdit
            Left = 2
            Top = 18
            Width = 103
            Height = 21
            HelpContext = 1929
            TabStop = False
            Color = clBtnFace
            Ctl3D = True
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'ARIAL'
            Font.Style = []
            Lines.Strings = (
              '0.00 ')
            ParentCtl3D = False
            ParentFont = False
            ReadOnly = True
            TabOrder = 0
            WantReturns = False
            WordWrap = False
            AutoSize = False
            BlockNegative = False
            BlankOnZero = False
            DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
            ShowCurrency = False
            TextId = 0
            Value = 1E-10
          end
          object ceDifference: TCurrencyEdit
            Left = 138
            Top = 18
            Width = 103
            Height = 21
            HelpContext = 1930
            TabStop = False
            Color = clBtnFace
            Ctl3D = True
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'ARIAL'
            Font.Style = []
            Lines.Strings = (
              '0.00 ')
            ParentCtl3D = False
            ParentFont = False
            ReadOnly = True
            TabOrder = 1
            WantReturns = False
            WordWrap = False
            AutoSize = False
            BlockNegative = False
            BlankOnZero = False
            DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
            ShowCurrency = False
            TextId = 0
            Value = 1E-10
          end
          object ceOpenBalance: TCurrencyEdit
            Left = 274
            Top = 18
            Width = 103
            Height = 21
            HelpContext = 1931
            TabStop = False
            Color = clBtnFace
            Ctl3D = True
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'ARIAL'
            Font.Style = []
            Lines.Strings = (
              '0.00 ')
            ParentCtl3D = False
            ParentFont = False
            ReadOnly = True
            TabOrder = 2
            WantReturns = False
            WordWrap = False
            AutoSize = False
            BlockNegative = False
            BlankOnZero = False
            DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
            ShowCurrency = False
            TextId = 0
            Value = 1E-10
          end
        end
        object pnlItemBottom: TPanel
          Left = 0
          Top = 240
          Width = 409
          Height = 56
          HelpContext = 1919
          Align = alBottom
          BevelOuter = bvNone
          TabOrder = 2
          object Label4: TLabel
            Left = 2
            Top = 2
            Width = 73
            Height = 14
            Caption = 'Current Ledger'
          end
          object Label5: TLabel
            Left = 138
            Top = 2
            Width = 53
            Height = 14
            Caption = 'Reconciled'
          end
          object Label6: TLabel
            Left = 274
            Top = 2
            Width = 60
            Height = 14
            Caption = 'Tagged Total'
          end
          object lblFilters: TLabel
            Left = 2
            Top = 42
            Width = 72
            Height = 14
            Caption = 'Current filters: '
          end
          object ceCurrent: TCurrencyEdit
            Left = 2
            Top = 18
            Width = 103
            Height = 21
            HelpContext = 1932
            TabStop = False
            Color = clBtnFace
            Ctl3D = True
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'ARIAL'
            Font.Style = []
            Lines.Strings = (
              '0.00 ')
            ParentCtl3D = False
            ParentFont = False
            ReadOnly = True
            TabOrder = 0
            WantReturns = False
            WordWrap = False
            AutoSize = False
            BlockNegative = False
            BlankOnZero = False
            DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
            ShowCurrency = False
            TextId = 0
            Value = 1E-10
          end
          object ceReconciled: TCurrencyEdit
            Left = 138
            Top = 18
            Width = 103
            Height = 21
            HelpContext = 1933
            TabStop = False
            Color = clBtnFace
            Ctl3D = True
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'ARIAL'
            Font.Style = []
            Lines.Strings = (
              '0.00 ')
            ParentCtl3D = False
            ParentFont = False
            ReadOnly = True
            TabOrder = 1
            WantReturns = False
            WordWrap = False
            AutoSize = False
            BlockNegative = False
            BlankOnZero = False
            DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
            ShowCurrency = False
            TextId = 0
            Value = 1E-10
          end
          object ceTagged: TCurrencyEdit
            Left = 274
            Top = 18
            Width = 103
            Height = 21
            HelpContext = 1934
            TabStop = False
            Color = clBtnFace
            Ctl3D = True
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'ARIAL'
            Font.Style = []
            Lines.Strings = (
              '0.00 ')
            ParentCtl3D = False
            ParentFont = False
            ReadOnly = True
            TabOrder = 2
            WantReturns = False
            WordWrap = False
            AutoSize = False
            BlockNegative = False
            BlankOnZero = False
            DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
            ShowCurrency = False
            TextId = 0
            Value = 1E-10
          end
        end
      end
      object pnlButtons: TPanel
        Left = 412
        Top = 25
        Width = 117
        Height = 297
        HelpContext = 1919
        BevelOuter = bvNone
        TabOrder = 1
        object ScrollBox1: TScrollBox
          Left = 2
          Top = 74
          Width = 111
          Height = 221
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = bsNone
          TabOrder = 2
          object btnClear: TSBSButton
            Left = 8
            Top = 32
            Width = 80
            Height = 21
            HelpContext = 1938
            Caption = 'C&lear'
            TabOrder = 1
            OnClick = btnClearClick
            TextId = 0
          end
          object btnUnclear: TSBSButton
            Left = 8
            Top = 56
            Width = 80
            Height = 21
            HelpContext = 1939
            Caption = '&Unclear'
            TabOrder = 2
            OnClick = btnUnclearClick
            TextId = 0
          end
          object btnTag: TSBSButton
            Left = 8
            Top = 8
            Width = 80
            Height = 21
            HelpContext = 1940
            Caption = '&Tag'
            TabOrder = 0
            OnClick = btnTagClick
            TextId = 0
          end
          object btnFind: TSBSButton
            Left = 8
            Top = 104
            Width = 80
            Height = 21
            HelpContext = 1941
            Caption = '&Find'
            TabOrder = 4
            OnClick = btnFindClick
            TextId = 0
          end
          object btnProcess: TSBSButton
            Left = 8
            Top = 128
            Width = 80
            Height = 21
            HelpContext = 1942
            Caption = '&Process'
            TabOrder = 5
            OnClick = btnProcessClick
            TextId = 0
          end
          object btnStatement: TSBSButton
            Left = 8
            Top = 152
            Width = 80
            Height = 21
            HelpContext = 1943
            Caption = 'e-&Statement'
            TabOrder = 6
            OnClick = btnStatementClick
            TextId = 0
          end
          object btnView: TSBSButton
            Left = 8
            Top = 176
            Width = 80
            Height = 21
            HelpContext = 1944
            Caption = '&View'
            TabOrder = 7
            OnClick = btnViewClick
            TextId = 0
          end
          object btnAdjustment: TSBSButton
            Left = 8
            Top = 200
            Width = 80
            Height = 21
            HelpContext = 1945
            Caption = '&Adjustment'
            TabOrder = 8
            OnClick = btnAdjustmentClick
            TextId = 0
          end
          object btnFilter: TSBSButton
            Left = 8
            Top = 224
            Width = 80
            Height = 21
            HelpContext = 1946
            Caption = 'F&ilters'
            TabOrder = 9
            OnClick = btnFilterClick
            TextId = 0
          end
          object btnCheck: TSBSButton
            Left = 8
            Top = 248
            Width = 80
            Height = 21
            HelpContext = 1947
            Caption = 'C&heck'
            TabOrder = 10
            OnClick = btnCheckClick
            TextId = 0
          end
          object btnMatch: TSBSButton
            Left = 8
            Top = 80
            Width = 80
            Height = 21
            HelpContext = 1937
            Caption = '&Match'
            TabOrder = 3
            OnClick = btnMatchClick
            TextId = 0
          end
          object btnClearAll: TSBSButton
            Left = 8
            Top = 272
            Width = 80
            Height = 21
            Caption = 'Unclear All'
            TabOrder = 11
            OnClick = btnClearAllClick
            TextId = 0
          end
        end
        object btnOK: TSBSButton
          Left = 10
          Top = 16
          Width = 80
          Height = 21
          HelpContext = 1935
          Caption = '&OK'
          TabOrder = 0
          OnClick = btnOKClick
          TextId = 0
        end
        object btnCancel: TSBSButton
          Left = 10
          Top = 40
          Width = 80
          Height = 21
          HelpContext = 1936
          Cancel = True
          Caption = '&Cancel'
          TabOrder = 1
          OnClick = btnCancelClick
          TextId = 0
        end
      end
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 448
    Top = 248
    object ag1: TMenuItem
      Caption = 'Tag'
      OnClick = btnTagClick
    end
    object Clear1: TMenuItem
      Caption = 'Clear'
      OnClick = btnClearClick
    end
    object Unclear1: TMenuItem
      Caption = 'Unclear'
      object Unclear3: TMenuItem
        Caption = 'Unclear'
        OnClick = Unclear2Click
      end
      object Cancel2: TMenuItem
        Tag = 2
        Caption = 'Cancel'
        OnClick = Unclear2Click
      end
      object Suspend1: TMenuItem
        Tag = 3
        Caption = 'Return'
        OnClick = Unclear2Click
      end
    end
    object Match1: TMenuItem
      Caption = '&Match'
      OnClick = btnMatchClick
    end
    object Find1: TMenuItem
      Caption = 'Find'
      OnClick = btnFindClick
    end
    object Process1: TMenuItem
      Caption = 'Process'
      OnClick = btnProcessClick
    end
    object Statement1: TMenuItem
      Caption = 'e-&Statement'
      OnClick = btnStatementClick
    end
    object RemoveAllFilters1: TMenuItem
      Caption = 'Remove All Filters'
      OnClick = RemoveAllFilters1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Properties1: TMenuItem
      Caption = 'Properties'
      OnClick = Properties1Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object SaveCoordinates1: TMenuItem
      AutoCheck = True
      Caption = 'Save Coordinates'
    end
  end
  object btData: TBtrieveDataset
    OnFilterRecord = btDataFilterRecord
    OnGetFieldValue = btDataGetFieldValue
    Left = 448
    Top = 224
  end
  object PopupMenu2: TPopupMenu
    Left = 440
    Top = 88
    object Unclear2: TMenuItem
      Caption = 'Unclear'
      OnClick = Unclear2Click
    end
    object Cancel1: TMenuItem
      Tag = 2
      Caption = 'Cancel'
      OnClick = Unclear2Click
    end
    object Return1: TMenuItem
      Tag = 3
      Caption = 'Return'
      OnClick = Unclear2Click
    end
  end
  object mnuFilters: TPopupMenu
    Left = 440
    Top = 8
    object AddFilter1: TMenuItem
      Caption = '&Add Filter'
      OnClick = AddFilter1Click
    end
    object RemoveFilter1: TMenuItem
      Caption = '&Remove Filter'
      object mnuDocType: TMenuItem
        Tag = 1
        Caption = 'Doc Type'
        OnClick = mnuDocTypeClick
      end
      object mnuAcCode: TMenuItem
        Tag = 2
        Caption = 'Account Code'
        OnClick = mnuDocTypeClick
      end
      object mnuRef: TMenuItem
        Tag = 4
        Caption = 'Reference'
        OnClick = mnuDocTypeClick
      end
      object mnuAmount: TMenuItem
        Tag = 8
        Caption = 'Amount'
        OnClick = mnuDocTypeClick
      end
      object mnuStatus: TMenuItem
        Tag = 16
        Caption = 'Status'
        OnClick = mnuDocTypeClick
      end
      object mnuDate: TMenuItem
        Tag = 32
        Caption = 'Date'
        OnClick = mnuDocTypeClick
      end
    end
    object RemoveAllFilters2: TMenuItem
      Caption = 'Remove All &Filters'
      OnClick = RemoveAllFilters1Click
    end
  end
  object mnuAdjust: TPopupMenu
    Left = 440
    Top = 40
    object mnuNom: TMenuItem
      Caption = 'Nominal Journal'
      OnClick = mnuNomClick
    end
    object mnuPPY: TMenuItem
      Caption = 'Purchase Payment'
      OnClick = mnuPPYClick
    end
    object mnuPPI: TMenuItem
      Caption = 'Purchase Payment with Invoice'
      OnClick = mnuPPIClick
    end
    object mnuSRC: TMenuItem
      Caption = 'Sales Receipt'
      OnClick = mnuSRCClick
    end
    object mnuSRI: TMenuItem
      Caption = 'Sales Receipt with Invoice'
      OnClick = mnuSRIClick
    end
  end
  object EnterToTab1: TEnterToTab
    ConvertEnters = True
    OverrideFont = True
    Version = 'TEnterToTab v1.02 for Delphi 6.01'
    Top = 32
  end
end
