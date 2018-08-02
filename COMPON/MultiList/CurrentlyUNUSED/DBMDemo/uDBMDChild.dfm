object frmDBMChild: TfrmDBMChild
  Left = 296
  Top = 177
  Width = 602
  Height = 435
  Caption = 'DBMultilist Session'
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
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pnlHeader: TPanel
    Left = 0
    Top = 0
    Width = 594
    Height = 115
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object Panel2: TPanel
      Left = 0
      Top = 0
      Width = 129
      Height = 115
      Align = alLeft
      TabOrder = 0
      object Label1: TLabel
        Left = 16
        Top = 36
        Width = 35
        Height = 13
        Caption = 'Index 1'
      end
      object Label2: TLabel
        Left = 16
        Top = 68
        Width = 35
        Height = 13
        Caption = 'Index 2'
      end
      object se1: TSpinEdit
        Left = 64
        Top = 32
        Width = 49
        Height = 22
        MaxValue = 0
        MinValue = 0
        TabOrder = 0
        Value = 0
      end
      object se2: TSpinEdit
        Left = 64
        Top = 64
        Width = 49
        Height = 22
        MaxValue = 0
        MinValue = 0
        TabOrder = 1
        Value = 0
      end
    end
    object pcDBM: TPageControl
      Left = 129
      Top = 0
      Width = 465
      Height = 115
      ActivePage = tsColumns
      Align = alClient
      TabIndex = 0
      TabOrder = 1
      object tsColumns: TTabSheet
        Caption = '&Columns'
        object bnAddCol: TButton
          Left = 16
          Top = 16
          Width = 105
          Height = 25
          Caption = 'Add'
          TabOrder = 0
          OnClick = bnAddColClick
        end
        object bnRemoveCol: TButton
          Left = 136
          Top = 16
          Width = 105
          Height = 25
          Caption = 'Remove'
          TabOrder = 1
          OnClick = bnRemoveColClick
        end
        object bnHideCol: TButton
          Left = 136
          Top = 48
          Width = 105
          Height = 25
          Caption = 'Hide'
          TabOrder = 2
          OnClick = bnHideColClick
        end
        object bnInsertCol: TButton
          Left = 16
          Top = 48
          Width = 105
          Height = 25
          Caption = 'Insert'
          TabOrder = 3
          OnClick = bnInsertColClick
        end
        object bnClearCols: TButton
          Left = 256
          Top = 48
          Width = 105
          Height = 25
          Caption = 'Clear'
          TabOrder = 4
          OnClick = bnClearColsClick
        end
        object bnMoveCol: TButton
          Left = 256
          Top = 16
          Width = 105
          Height = 25
          Caption = 'Move'
          TabOrder = 5
          OnClick = bnMoveColClick
        end
      end
      object tsInteraction: TTabSheet
        Caption = '&Interaction'
        ImageIndex = 1
        object lblSearchCol: TLabel
          Left = 6
          Top = 20
          Width = 50
          Height = 13
          Caption = 'Search Str'
        end
        object bnSelectRow: TButton
          Left = 16
          Top = 48
          Width = 105
          Height = 25
          Caption = 'Select Row'
          TabOrder = 0
          OnClick = bnSelectRowClick
        end
        object bnSortCol: TButton
          Left = 136
          Top = 48
          Width = 105
          Height = 25
          Caption = 'Sort'
          TabOrder = 1
          OnClick = bnSortColClick
        end
        object bnSearchCol: TButton
          Left = 136
          Top = 16
          Width = 105
          Height = 25
          Caption = 'Search'
          TabOrder = 2
          OnClick = bnSearchColClick
        end
        object edSearchCol: TEdit
          Left = 64
          Top = 17
          Width = 57
          Height = 21
          TabOrder = 3
        end
      end
      object tsDisplay: TTabSheet
        Caption = 'Display'
        ImageIndex = 2
        object bnRandDisplay: TButton
          Left = 16
          Top = 16
          Width = 105
          Height = 25
          Caption = 'Random Display'
          TabOrder = 0
          OnClick = bnRandDisplayClick
        end
        object cbCellGradients: TCheckBox
          Left = 152
          Top = 16
          Width = 97
          Height = 17
          Caption = 'Cell Gradients'
          TabOrder = 1
          OnClick = cbCellGradientsClick
        end
        object cbChangeText: TCheckBox
          Left = 152
          Top = 56
          Width = 113
          Height = 17
          Caption = 'Change Cell Text'
          TabOrder = 2
          OnClick = cbBoldSelectionClick
        end
      end
      object tsTimers: TTabSheet
        Caption = '&Timers'
        ImageIndex = 3
        object lblInterval: TLabel
          Left = 12
          Top = 22
          Width = 35
          Height = 13
          Caption = 'Interval'
        end
        object bnDisplays: TButton
          Left = 136
          Top = 16
          Width = 105
          Height = 25
          Caption = 'Displays'
          TabOrder = 0
          OnClick = bnDisplaysClick
        end
        object bnMovingCols: TButton
          Left = 136
          Top = 48
          Width = 105
          Height = 25
          Caption = 'Columns'
          TabOrder = 1
          OnClick = bnMovingColsClick
        end
        object edInterval: TEdit
          Left = 60
          Top = 18
          Width = 49
          Height = 21
          TabOrder = 2
          Text = '1000'
        end
        object bnRandGradients: TButton
          Left = 256
          Top = 16
          Width = 105
          Height = 25
          Caption = 'Gradients'
          TabOrder = 3
          OnClick = bnRandGradientsClick
        end
      end
      object tsMultiSelection: TTabSheet
        Caption = '&Multi Selection'
        ImageIndex = 4
        object lbMultiselect: TListBox
          Left = 304
          Top = 0
          Width = 153
          Height = 87
          Align = alRight
          ItemHeight = 13
          TabOrder = 0
        end
        object bnMSAddresses: TButton
          Left = 16
          Top = 16
          Width = 105
          Height = 25
          Caption = 'Selected Addresses'
          TabOrder = 1
          OnClick = bnMSAddressesClick
        end
        object cbIntegrity: TCheckBox
          Left = 144
          Top = 56
          Width = 129
          Height = 17
          Caption = 'Multi Select Integrity'
          TabOrder = 2
          OnClick = cbIntegrityClick
        end
        object cbMultiSelect: TCheckBox
          Left = 144
          Top = 24
          Width = 121
          Height = 17
          Caption = 'Allow Multi Select'
          Checked = True
          State = cbChecked
          TabOrder = 3
          OnClick = cbMultiSelectClick
        end
      end
    end
  end
  object DBM: TDBMultiList
    Left = 0
    Top = 115
    Width = 594
    Height = 293
    Cursor = crHSplit
    Custom.SplitterCursor = crHSplit
    Options.MultiSelection = True
    Columns = <>
    TabStop = True
    OnCellPaint = DBMCellPaint
    Align = alClient
    TabOrder = 1
    Dataset = BtrieveDataset
    OnAfterLoad = DBMAfterLoad
    OnSortColumn = DBMSortColumn
  end
  object BtrieveDataset: TBtrieveDataset
    SearchIndex = 0
    OnFilterRecord = BtrieveDatasetFilterRecord
    OnGetFieldValue = BtrieveDatasetGetFieldValue
    Left = 24
    Top = 168
  end
  object timerConfigs: TTimer
    Enabled = False
    OnTimer = timerConfigsTimer
    Left = 56
    Top = 168
  end
  object timerMovingCols: TTimer
    Enabled = False
    OnTimer = timerMovingColsTimer
    Left = 56
    Top = 200
  end
  object timerGradients: TTimer
    Enabled = False
    OnTimer = timerGradientsTimer
    Left = 56
    Top = 232
  end
end
