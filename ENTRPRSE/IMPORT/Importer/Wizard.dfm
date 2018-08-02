object frmWizard: TfrmWizard
  Left = 270
  Top = 169
  HelpContext = 6
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Build Import Job'
  ClientHeight = 363
  ClientWidth = 558
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  FormStyle = fsMDIChild
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  ShowHint = True
  Visible = True
  WindowState = wsMinimized
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  OnKeyUp = FormKeyUp
  PixelsPerInch = 96
  TextHeight = 14
  object lblPage: TLabel
    Left = 12
    Top = 337
    Width = 34
    Height = 14
    Caption = 'lblPage'
  end
  object PageControl: TPageControl
    Left = 6
    Top = 12
    Width = 545
    Height = 314
    ActivePage = tsImportList
    TabIndex = 0
    TabOrder = 0
    object tsImportList: TTabSheet
      Caption = 'Import List'
      object Label1: TLabel
        Left = 8
        Top = 7
        Width = 234
        Height = 14
        Caption = 'Please select the files and folders to be imported'
      end
      object btnMoveImportListUp: TButton
        Left = 453
        Top = 100
        Width = 80
        Height = 21
        Hint = 
          '|Move the selected item up one row - items are imported in seque' +
          'nce'
        Caption = 'Move Up'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        OnClick = btnMoveImportListUpClick
      end
      object btnMoveImportListDown: TButton
        Left = 453
        Top = 126
        Width = 80
        Height = 21
        Hint = 
          '|Move the selected item down one row - items are imported in seq' +
          'uence'
        Caption = 'Move Down'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 4
        OnClick = btnMoveImportListDownClick
      end
      object btnAdd: TButton
        Left = 453
        Top = 48
        Width = 80
        Height = 21
        Hint = '|Add a file or folder to be imported'
        Caption = 'Add'
        TabOrder = 1
        OnClick = btnAddClick
      end
      object btnEditItem: TButton
        Left = 453
        Top = 74
        Width = 80
        Height = 21
        Hint = '|Edit the selected import item'
        Caption = 'Edit'
        Enabled = False
        TabOrder = 2
        OnClick = btnEditItemClick
      end
      object btnRemoveItem: TButton
        Left = 453
        Top = 152
        Width = 80
        Height = 21
        Hint = '|Delete the selected import item'
        Caption = 'Delete'
        Enabled = False
        TabOrder = 5
        OnClick = btnRemoveItemClick
      end
      object btnRemoveAllItems: TButton
        Left = 453
        Top = 178
        Width = 80
        Height = 21
        Hint = '|Delete all the import items'
        Caption = 'Delete All'
        Enabled = False
        TabOrder = 6
        OnClick = btnRemoveAllItemsClick
      end
      object mlImportList: TMultiList
        Left = 4
        Top = 28
        Width = 441
        Height = 250
        Custom.SplitterCursor = crHSplit
        Dimensions.HeaderHeight = 18
        Dimensions.SpacerWidth = 1
        Dimensions.SplitterWidth = 3
        Options.BoldActiveColumn = False
        Columns = <
          item
            Caption = 'Folder'
            Width = 245
          end
          item
            Caption = 'File or Mask'
            Width = 140
          end>
        TabStop = True
        OnChangeSelection = mlImportListChangeSelection
        OnRowDblClick = mlImportListRowDblClick
        PopupMenu = ImportListPopupMenu
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
      object btnViewFile: TButton
        Left = 453
        Top = 204
        Width = 80
        Height = 21
        Caption = 'View File'
        TabOrder = 7
        OnClick = btnViewFileClick
      end
    end
    object tsJobSettings: TTabSheet
      Caption = 'Job Settings'
      ImageIndex = 1
      object Label2: TLabel
        Left = 8
        Top = 7
        Width = 179
        Height = 14
        Caption = 'These settings apply to the import job'
      end
      object btnEditJobSetting: TButton
        Left = 453
        Top = 48
        Width = 80
        Height = 21
        Hint = '|Edit the selected Job Setting'
        Caption = 'Edit'
        Enabled = False
        TabOrder = 1
        OnClick = btnEditJobSettingClick
      end
      object mlJobSettings: TMultiList
        Left = 4
        Top = 28
        Width = 441
        Height = 250
        Custom.SplitterCursor = crHSplit
        Dimensions.HeaderHeight = 18
        Dimensions.SpacerWidth = 1
        Dimensions.SplitterWidth = 3
        Options.BoldActiveColumn = False
        Columns = <
          item
            Caption = 'DefOrJob'
            Visible = False
          end
          item
            Caption = 'Setting'
            Field = 'JobSetting'
            Sortable = True
            Width = 185
          end
          item
            Caption = 'Current Value'
            Width = 200
          end>
        TabStop = True
        OnChangeSelection = mlJobSettingsChangeSelection
        OnRowDblClick = mlJobSettingsRowDblClick
        PopupMenu = JobSettingsPopupMenu
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
      object btnJobSettingsDefaults: TButton
        Left = 453
        Top = 72
        Width = 80
        Height = 21
        Hint = '|Reset all Job Settings to their default value'
        Caption = 'Defaults'
        TabOrder = 2
        OnClick = btnJobSettingsDefaultsClick
      end
    end
    object tsImportSettings: TTabSheet
      Caption = 'Import Settings'
      ImageIndex = 2
      object Label3: TLabel
        Left = 8
        Top = 7
        Width = 218
        Height = 14
        Caption = 'These settings affect the data being imported'
      end
      object btnEditImportSetting: TButton
        Left = 453
        Top = 48
        Width = 80
        Height = 21
        Hint = '|Edit the selected Import Setting'
        Caption = 'Edit'
        Enabled = False
        TabOrder = 1
        OnClick = btnEditImportSettingClick
      end
      object mlImportSettings: TMultiList
        Left = 4
        Top = 28
        Width = 441
        Height = 250
        Custom.SplitterCursor = crHSplit
        Dimensions.HeaderHeight = 18
        Dimensions.SpacerWidth = 1
        Dimensions.SplitterWidth = 3
        Options.BoldActiveColumn = False
        Columns = <
          item
            Caption = 'DefOrJob'
            Visible = False
          end
          item
            Caption = 'Setting'
            Field = 'ImportSetting'
            Sortable = True
            Width = 185
          end
          item
            Caption = 'Current Value'
            Width = 200
          end>
        TabStop = True
        OnChangeSelection = mlImportSettingsChangeSelection
        OnRowDblClick = mlImportSettingsRowDblClick
        PopupMenu = ImportSettingsPopupMenu
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
      object btnImportSettingsDefaults: TButton
        Left = 453
        Top = 72
        Width = 80
        Height = 21
        Hint = '|Reset all Import Settings to their default value'
        Caption = 'Defaults'
        TabOrder = 2
        OnClick = btnImportSettingsDefaultsClick
      end
    end
    object tsFieldMaps: TTabSheet
      Caption = 'Field Maps'
      ImageIndex = 3
      object Label4: TLabel
        Left = 8
        Top = 7
        Width = 401
        Height = 14
        Caption = 
          'Each type of record that this job will import must have a field ' +
          'map associated with it'
      end
      object btnEditMapFile: TButton
        Left = 453
        Top = 48
        Width = 80
        Height = 21
        Hint = '|Change the Field Map file for the selected Record Type'
        Caption = 'Edit'
        Enabled = False
        TabOrder = 1
        OnClick = btnEditMapFileClick
      end
      object btnCheckRecordTypes: TButton
        Left = 453
        Top = 100
        Width = 80
        Height = 21
        Caption = 'Check Files'
        Enabled = False
        TabOrder = 3
        Visible = False
      end
      object btnEditMap: TButton
        Left = 453
        Top = 74
        Width = 80
        Height = 21
        Hint = '|Make changes to the selected Field Map'
        Caption = 'Edit Map'
        TabOrder = 2
        OnClick = btnEditMapClick
      end
      object mlMapFiles: TMultiList
        Left = 4
        Top = 28
        Width = 441
        Height = 250
        Custom.SplitterCursor = crHSplit
        Dimensions.HeaderHeight = 18
        Dimensions.SpacerWidth = 1
        Dimensions.SplitterWidth = 3
        Options.BoldActiveColumn = False
        Columns = <
          item
            Caption = 'DefOrJob'
            Visible = False
          end
          item
            Caption = 'RT'
            Field = 'RT'
            Sortable = True
            Width = 30
          end
          item
            Caption = 'Record Type'
            Field = 'RecordType'
            Sortable = True
          end
          item
            Caption = 'Field Map'
            Width = 150
          end
          item
            Caption = 'Description'
            Width = 300
          end
          item
            Caption = 'Reqd'
            Field = 'Reqd'
            Sortable = True
            Visible = False
            Width = 40
          end>
        TabStop = True
        OnChangeSelection = mlMapFilesChangeSelection
        OnRowDblClick = mlMapFilesRowDblClick
        PopupMenu = FieldMapsPopupMenu
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
    end
    object tsSchedule: TTabSheet
      Caption = 'Schedule'
      ImageIndex = 4
      object lblSpecifySchedule: TLabel
        Left = 12
        Top = 31
        Width = 240
        Height = 14
        Caption = 'Please specify when this import job should be run'
      end
      object GroupBox1: TGroupBox
        Left = 8
        Top = 52
        Width = 521
        Height = 94
        Caption = 'Schedule Basis'
        TabOrder = 0
        object pnlFirstLast: TPanel
          Left = 111
          Top = 19
          Width = 371
          Height = 16
          BevelOuter = bvNone
          TabOrder = 0
          object Label9: TLabel
            Left = 9
            Top = 1
            Width = 35
            Height = 14
            Caption = 'on the'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object cbFirst: TBorCheckEx
            Left = 56
            Top = -3
            Width = 45
            Height = 20
            Align = alRight
            Caption = 'First'
            Color = clBtnFace
            ParentColor = False
            TabOrder = 0
            TextId = 0
            OnClick = rbMonthlyClick
          end
          object cbSecond: TBorCheckEx
            Left = 116
            Top = -3
            Width = 61
            Height = 20
            Align = alRight
            Caption = 'Second'
            Color = clBtnFace
            ParentColor = False
            TabOrder = 1
            TextId = 0
            OnClick = rbMonthlyClick
          end
          object cbThird: TBorCheckEx
            Left = 189
            Top = -3
            Width = 47
            Height = 20
            Align = alRight
            Caption = 'Third'
            Color = clBtnFace
            ParentColor = False
            TabOrder = 2
            TextId = 0
            OnClick = rbMonthlyClick
          end
          object cbFourth: TBorCheckEx
            Left = 258
            Top = -3
            Width = 53
            Height = 20
            Align = alRight
            Caption = 'Fourth'
            Color = clBtnFace
            ParentColor = False
            TabOrder = 3
            TextId = 0
            OnClick = rbMonthlyClick
          end
          object cbLast: TBorCheckEx
            Left = 324
            Top = -3
            Width = 44
            Height = 20
            Align = alRight
            Caption = 'Last'
            Color = clBtnFace
            Checked = True
            ParentColor = False
            State = cbChecked
            TabOrder = 4
            TextId = 0
            OnClick = rbMonthlyClick
          end
        end
        object pnlDays: TPanel
          Left = 126
          Top = 44
          Width = 374
          Height = 39
          BevelOuter = bvNone
          TabOrder = 1
          object lblOfEachMonth: TLabel
            Left = 286
            Top = 25
            Width = 79
            Height = 14
            Caption = 'of each month'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object cbMonday: TBorCheckEx
            Left = 5
            Top = -2
            Width = 61
            Height = 20
            Align = alRight
            Caption = 'Monday'
            Color = clBtnFace
            ParentColor = False
            TabOrder = 0
            TextId = 0
            OnClick = rbMonthlyClick
          end
          object cbTuesday: TBorCheckEx
            Left = 101
            Top = -2
            Width = 61
            Height = 20
            Align = alRight
            Caption = 'Tuesday'
            Color = clBtnFace
            ParentColor = False
            TabOrder = 1
            TextId = 0
            OnClick = rbMonthlyClick
          end
          object cbWednesday: TBorCheckEx
            Left = 201
            Top = -2
            Width = 88
            Height = 20
            Align = alRight
            Caption = 'Wednesday'
            Color = clBtnFace
            ParentColor = False
            TabOrder = 2
            TextId = 0
            OnClick = rbMonthlyClick
          end
          object cbThursday: TBorCheckEx
            Left = 301
            Top = -2
            Width = 72
            Height = 20
            Align = alRight
            Caption = 'Thursday'
            Color = clBtnFace
            ParentColor = False
            TabOrder = 3
            TextId = 0
            OnClick = rbMonthlyClick
          end
          object cbFriday: TBorCheckEx
            Left = 5
            Top = 21
            Width = 61
            Height = 20
            Align = alRight
            Caption = 'Friday'
            Color = clBtnFace
            ParentColor = False
            TabOrder = 4
            TextId = 0
            OnClick = rbMonthlyClick
          end
          object cbSaturday: TBorCheckEx
            Left = 101
            Top = 21
            Width = 61
            Height = 20
            Align = alRight
            Caption = 'Saturday'
            Color = clBtnFace
            ParentColor = False
            TabOrder = 5
            TextId = 0
            OnClick = rbMonthlyClick
          end
          object cbSunday: TBorCheckEx
            Left = 201
            Top = 21
            Width = 61
            Height = 20
            Align = alRight
            Caption = 'Sunday'
            Color = clBtnFace
            Checked = True
            ParentColor = False
            State = cbChecked
            TabOrder = 6
            TextId = 0
            OnClick = rbMonthlyClick
          end
        end
        object cbDailyMonthly: TComboBox
          Left = 12
          Top = 16
          Width = 77
          Height = 22
          Style = csDropDownList
          ItemHeight = 14
          ItemIndex = 1
          TabOrder = 2
          Text = 'Monthly'
          OnChange = cbDailyMonthlyChange
          Items.Strings = (
            'Daily'
            'Monthly')
        end
      end
      object GroupBox2: TGroupBox
        Left = 8
        Top = 150
        Width = 273
        Height = 131
        Caption = 'At What Time'
        TabOrder = 1
        object Label7: TLabel
          Left = 102
          Top = 20
          Width = 37
          Height = 14
          Caption = 'minutes'
        end
        object Label6: TLabel
          Left = 102
          Top = 53
          Width = 83
          Height = 14
          Caption = 'minutes between'
        end
        object Label8: TLabel
          Left = 167
          Top = 77
          Width = 18
          Height = 14
          Caption = 'and'
        end
        object edtEvery: TEdit
          Left = 61
          Top = 16
          Width = 33
          Height = 22
          TabOrder = 1
          Text = '60'
          OnChange = edtEveryChange
          OnKeyPress = edtEveryKeyPress
        end
        object rbEvery: TBorRadio
          Left = 8
          Top = 16
          Width = 52
          Height = 20
          Align = alRight
          Caption = 'Every'
          TabOrder = 0
          TextId = 0
          OnClick = rbMonthlyClick
        end
        object rbEveryBetween: TBorRadio
          Left = 8
          Top = 49
          Width = 52
          Height = 20
          Align = alRight
          Caption = 'Every'
          TabOrder = 2
          TextId = 0
          OnClick = rbMonthlyClick
        end
        object rbOnce: TBorRadio
          Left = 8
          Top = 103
          Width = 65
          Height = 20
          Align = alRight
          Caption = 'Once at'
          Checked = True
          TabOrder = 6
          TabStop = True
          TextId = 0
          OnClick = rbMonthlyClick
        end
        object edtEveryBetween: TEdit
          Left = 61
          Top = 49
          Width = 33
          Height = 22
          TabOrder = 3
          Text = '60'
          OnChange = edtEveryChange
          OnKeyPress = edtEveryKeyPress
        end
        object dtpTimeFrom: TDateTimePicker
          Left = 200
          Top = 49
          Width = 60
          Height = 22
          CalAlignment = dtaLeft
          Date = 38670.375
          Format = 'HH:mm'
          Time = 38670.375
          DateFormat = dfShort
          DateMode = dmComboBox
          Kind = dtkTime
          ParseInput = False
          TabOrder = 4
          OnChange = dtpTimeFromChange
        end
        object dtpTimeTo: TDateTimePicker
          Left = 200
          Top = 73
          Width = 60
          Height = 22
          CalAlignment = dtaLeft
          Date = 38670.7083333333
          Format = 'HH:mm'
          Time = 38670.7083333333
          DateFormat = dfShort
          DateMode = dmComboBox
          Kind = dtkTime
          ParseInput = False
          TabOrder = 5
          OnChange = dtpTimeFromChange
        end
        object dtpTimeAt: TDateTimePicker
          Left = 72
          Top = 103
          Width = 60
          Height = 22
          CalAlignment = dtaLeft
          Date = 38670.5
          Format = 'HH:mm'
          Time = 38670.5
          DateFormat = dfShort
          DateMode = dmComboBox
          Kind = dtkTime
          ParseInput = False
          TabOrder = 7
          OnChange = dtpTimeFromChange
        end
      end
      object cbEnabled: TBorCheckEx
        Left = 12
        Top = 6
        Width = 69
        Height = 20
        Align = alRight
        Caption = 'Enabled'
        Color = clBtnFace
        Checked = True
        ParentColor = False
        State = cbChecked
        TabOrder = 2
        TextId = 0
        OnClick = rbMonthlyClick
      end
      object cbISO8601: TBorCheckEx
        Left = 428
        Top = 20
        Width = 98
        Height = 20
        Align = alRight
        Caption = 'Use ISO 8601'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 3
        TextId = 0
        Visible = False
      end
      object GroupBox3: TGroupBox
        Left = 288
        Top = 150
        Width = 241
        Height = 131
        Caption = 'Next Run'
        TabOrder = 4
        object lblNextRun: TLabel
          Left = 16
          Top = 30
          Width = 213
          Height = 84
          Alignment = taCenter
          AutoSize = False
          WordWrap = True
        end
      end
    end
  end
  object btnPrev: TButton
    Left = 117
    Top = 334
    Width = 80
    Height = 21
    Hint = '|Go to the previous page'
    Caption = '<< Prev'
    TabOrder = 1
    OnClick = btnPrevClick
  end
  object btnNext: TButton
    Left = 205
    Top = 334
    Width = 80
    Height = 21
    Hint = '|Go to the next page'
    Caption = 'Next >>'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    OnClick = btnNextClick
  end
  object btnSave: TButton
    Left = 293
    Top = 334
    Width = 80
    Height = 21
    Hint = '|Save the changes to the Import Job'
    Caption = 'Save'
    TabOrder = 3
    OnClick = btnSaveClick
  end
  object btnSaveAs: TButton
    Left = 381
    Top = 334
    Width = 80
    Height = 21
    Hint = '|Save the Import Job to a file'
    Caption = 'Save As...'
    TabOrder = 4
    OnClick = btnSaveAsClick
  end
  object btnClose: TButton
    Left = 470
    Top = 334
    Width = 80
    Height = 21
    Hint = '|Close this window'
    Caption = 'Close'
    TabOrder = 5
    OnClick = btnCloseClick
  end
  object OpenJobDialog: TpsvOpenDialog
    Options = [ofHideReadOnly, ofNoChangeDir, ofEnableSizing]
    Left = 164
    Top = 200
  end
  object BrowseFolderDialog: TpsvBrowseFolderDialog
    Left = 192
    Top = 200
  end
  object PopupMenu1: TPopupMenu
    Left = 160
    Top = 284
    object mnuSelectFiles: TMenuItem
      Caption = 'Add File(s)'
      Hint = '|Add one or more files to the list of items to be imported'
      OnClick = mnuSelectFilesClick
    end
    object mnuSelectFolder: TMenuItem
      Caption = 'Add Folder'
      Hint = '|Add a folder to the list of items to be imported'
      OnClick = mnuSelectFolderClick
    end
  end
  object SaveJobDialog: TpsvSaveDialog
    Options = [ofHideReadOnly, ofNoChangeDir, ofEnableSizing]
    Left = 220
    Top = 200
  end
  object OpenFileDialog: TpsvOpenDialog
    Options = [ofHideReadOnly, ofNoChangeDir, ofEnableSizing]
    Left = 192
    Top = 283
  end
  object OpenMapFileDialog: TOpenDialog
    Options = [ofHideReadOnly, ofNoChangeDir, ofEnableSizing]
    Left = 224
    Top = 284
  end
  object ImportListPopupMenu: TPopupMenu
    Left = 60
    Top = 96
    object mniAdd: TMenuItem
      Caption = 'Add'
      Hint = '|Add a file or folder to be imported'
      object mniSelectFiles: TMenuItem
        Caption = 'Add File(s)'
        Hint = '|Add one or more files to the list of items to be imported'
        OnClick = mnuSelectFilesClick
      end
      object mniSelectFolder: TMenuItem
        Caption = 'Add Folder'
        Hint = '|Add a folder to the list of items to be imported'
        OnClick = mnuSelectFolderClick
      end
    end
    object mniEditItem: TMenuItem
      Caption = 'Edit'
      Hint = '|Edit the selected import item'
      OnClick = btnEditItemClick
    end
    object mniMoveImportListUp: TMenuItem
      Caption = 'Move Up'
      Hint = 
        '|Move the selected item up one row - items are imported in seque' +
        'nce'
      OnClick = btnMoveImportListUpClick
    end
    object mniMoveImportListDown: TMenuItem
      Caption = 'Move Down'
      Hint = 
        '|Move the selected item down one row - items are imported in seq' +
        'uence'
      OnClick = btnMoveImportListDownClick
    end
    object mniRemoveItem: TMenuItem
      Caption = 'Delete'
      Hint = '|Delete the selected import item'
      OnClick = btnRemoveItemClick
    end
    object mniRemoveAllItems: TMenuItem
      Caption = 'Delete All'
      Hint = '|Delete all the import items'
      OnClick = btnRemoveAllItemsClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object mniImportListProperties: TMenuItem
      Caption = 'Properties'
      OnClick = mniImportListPropertiesClick
    end
    object mniImportListSaveCoordinates: TMenuItem
      Caption = 'Save Coordinates'
      OnClick = mniSaveCoordinatesClick
    end
  end
  object JobSettingsPopupMenu: TPopupMenu
    Left = 64
    Top = 144
    object mniEditJobSetting: TMenuItem
      Caption = 'Edit'
      Hint = '|Edit the selected Job Setting'
      OnClick = btnEditJobSettingClick
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object mniJobSettingsProperties: TMenuItem
      Caption = 'Properties'
      OnClick = mniJobSettingsPropertiesClick
    end
    object mniJobSettingsSavecoordinates: TMenuItem
      Caption = 'Save Coordinates'
      OnClick = mniSaveCoordinatesClick
    end
  end
  object ImportSettingsPopupMenu: TPopupMenu
    Left = 72
    Top = 204
    object mniEditImportSetting: TMenuItem
      Caption = 'Edit'
      Hint = '|Edit the selected Import Setting'
      OnClick = mniEditImportSettingClick
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object mniImportSettingsProperties: TMenuItem
      Caption = 'Properties'
      OnClick = mniImportSettingsPropertiesClick
    end
    object mniImportSettingsSavecoordinates: TMenuItem
      Caption = 'Save Coordinates'
      OnClick = mniSaveCoordinatesClick
    end
  end
  object FieldMapsPopupMenu: TPopupMenu
    Left = 68
    Top = 256
    object mniEditMapFile: TMenuItem
      Caption = 'Edit'
      Hint = '|Change the Field Map file for the selected Record Type'
      OnClick = btnEditMapFileClick
    end
    object EditMap1: TMenuItem
      Caption = 'Edit Map'
      Hint = '|Make changes to the selected Field Map'
      OnClick = btnEditMapClick
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object mniFieldMapsProperties: TMenuItem
      Caption = 'Properties'
      OnClick = mniFieldMapsPropertiesClick
    end
    object mniMapFilesSavecoordinates: TMenuItem
      Caption = 'Save Coordinates'
      OnClick = mniSaveCoordinatesClick
    end
  end
end
