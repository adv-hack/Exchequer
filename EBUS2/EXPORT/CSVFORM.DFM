object frmCSVExport: TfrmCSVExport
  Left = 315
  Top = 113
  BorderStyle = bsSingle
  Caption = 'CSV Export'
  ClientHeight = 276
  ClientWidth = 408
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefaultPosOnly
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lblSelectionName: TLabel
    Left = 283
    Top = -16
    Width = 3
    Height = 13
  end
  object btnLoad: TButton
    Left = 322
    Top = 37
    Width = 80
    Height = 21
    Hint = 'Load a CSV mapping file.'
    Cancel = True
    Caption = '&Load'
    TabOrder = 2
    OnClick = btnLoadClick
  end
  object btnClose: TButton
    Left = 322
    Top = 10
    Width = 80
    Height = 21
    Hint = 'Close the CSV export window.'
    Caption = '&Close'
    TabOrder = 1
    OnClick = btnCloseClick
  end
  object btnExport: TButton
    Left = 322
    Top = 90
    Width = 80
    Height = 21
    Hint = 'Export CSV file.'
    Cancel = True
    Caption = '&Export'
    TabOrder = 4
    OnClick = btnExportClick
  end
  object btnFileName: TButton
    Left = 322
    Top = 63
    Width = 80
    Height = 21
    Hint = 'Select a CSV export file name.'
    Cancel = True
    Caption = '&File Name'
    TabOrder = 3
    OnClick = btnFileNameClick
  end
  object grpCSVOptions: TGroupBox
    Left = 8
    Top = 4
    Width = 297
    Height = 121
    Caption = 'CSV export options'
    TabOrder = 0
    object Label3: TLabel
      Left = 27
      Top = 91
      Width = 55
      Height = 13
      Caption = 'Header row'
    end
    object Label2: TLabel
      Left = 11
      Top = 59
      Width = 71
      Height = 13
      Caption = 'Field Separator'
    end
    object Label1: TLabel
      Left = 17
      Top = 27
      Width = 65
      Height = 13
      Caption = 'Field Delimiter'
    end
    object cbxHeaderRow: TSBSComboBox
      Left = 92
      Top = 86
      Width = 112
      Height = 22
      Style = csDropDownList
      Color = clGreen
      DropDownCount = 3
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ItemHeight = 14
      ParentFont = False
      TabOrder = 0
      Items.Strings = (
        'None'
        'Field codes'
        'Field descriptions')
      MaxListWidth = 0
    end
    object cbxFieldSep: TSBSComboBox
      Left = 92
      Top = 54
      Width = 112
      Height = 22
      Style = csDropDownList
      Color = clGreen
      DropDownCount = 4
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ItemHeight = 14
      ParentFont = False
      TabOrder = 1
      OnChange = SetUserDefinedFields
      Items.Strings = (
        'Comma'
        'Semicolon'
        'Tab'
        'Other')
      MaxListWidth = 0
    end
    object cbxFieldDelim: TSBSComboBox
      Left = 92
      Top = 22
      Width = 112
      Height = 22
      Style = csDropDownList
      Color = clGreen
      DropDownCount = 4
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ItemHeight = 14
      ParentFont = False
      TabOrder = 2
      OnChange = SetUserDefinedFields
      Items.Strings = (
        'None'
        'Single quote'
        'Double quote'
        'Other')
      MaxListWidth = 0
    end
    object edtFieldDelim: Text8Pt
      Left = 221
      Top = 22
      Width = 63
      Height = 24
      Color = clGreen
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Courier New'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      TextId = 0
      ViaSBtn = False
    end
    object edtFieldSep: Text8Pt
      Left = 221
      Top = 54
      Width = 63
      Height = 24
      Color = clGreen
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Courier New'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
      TextId = 0
      ViaSBtn = False
    end
  end
  object grpExportOptions: TGroupBox
    Left = 8
    Top = 130
    Width = 297
    Height = 76
    Caption = 'Record export options'
    TabOrder = 5
    object Label4: TLabel
      Left = 52
      Top = 27
      Width = 30
      Height = 13
      Caption = 'Export'
    end
    object Label5: TLabel
      Left = 233
      Top = 55
      Width = 32
      Height = 13
      Caption = 'Label5'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 5921370
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object cbxExportMode: TSBSComboBox
      Left = 92
      Top = 22
      Width = 189
      Height = 22
      Style = csDropDownList
      Color = clGreen
      DropDownCount = 2
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ItemHeight = 14
      ParentFont = False
      TabOrder = 0
      OnChange = SetUserDefinedFields
      Items.Strings = (
        'all records'
        'records updated since last export')
      MaxListWidth = 0
    end
    object chkIgnoreWebInclude: TBorCheck
      Left = 24
      Top = 49
      Width = 170
      Height = 20
      Caption = 'Ignore "web include" flag?'
      Color = clBtnFace
      Checked = True
      ParentColor = False
      State = cbChecked
      TabOrder = 1
      TextId = 0
    end
  end
  object grdExportInfo: TStringGrid
    Left = 8
    Top = 213
    Width = 297
    Height = 60
    Color = clGreen
    ColCount = 2
    DefaultColWidth = 80
    DefaultRowHeight = 18
    RowCount = 3
    FixedRows = 0
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssNone
    TabOrder = 6
    RowHeights = (
      18
      18
      17)
  end
  object CheckBox1: TCheckBox
    Left = 312
    Top = 160
    Width = 97
    Height = 17
    Caption = 'CheckBox1'
    TabOrder = 7
  end
  object CheckBox2: TCheckBox
    Left = 311
    Top = 176
    Width = 97
    Height = 17
    Caption = 'CheckBox1'
    TabOrder = 8
  end
  object CheckBox3: TCheckBox
    Left = 311
    Top = 192
    Width = 97
    Height = 17
    Caption = 'CheckBox1'
    TabOrder = 9
  end
  object CheckBox4: TCheckBox
    Left = 311
    Top = 208
    Width = 97
    Height = 17
    Caption = 'CheckBox1'
    TabOrder = 10
  end
  object dlgFileOpen: TOpenDialog
    DefaultExt = 'MAP'
    Filter = 'Field export mapping files|*.MAP'
    Title = 'Select a mapping file'
    Left = 362
    Top = 128
  end
  object dlgExportFile: TSaveDialog
    DefaultExt = 'CSV'
    Filter = 'Comma Separated Values file|*.CSV'
    Title = 'Select CSV export file name'
    Left = 327
    Top = 128
  end
end
