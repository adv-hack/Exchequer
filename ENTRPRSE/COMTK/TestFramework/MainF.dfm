object frmMain: TfrmMain
  Left = 44
  Top = 183
  Width = 1189
  Height = 638
  Caption = 'COM Toolkit Test Framework'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  DesignSize = (
    1173
    580)
  PixelsPerInch = 96
  TextHeight = 13
  object lblTestCo: TLabel
    Left = 411
    Top = 28
    Width = 3
    Height = 13
  end
  object lblRefCo: TLabel
    Left = 411
    Top = 56
    Width = 3
    Height = 13
  end
  object Label1: TLabel
    Left = 39
    Top = 28
    Width = 68
    Height = 13
    Alignment = taRightJustify
    Caption = 'Test Company'
  end
  object Label3: TLabel
    Left = 115
    Top = 8
    Width = 46
    Height = 13
    Caption = 'Database'
  end
  object Label2: TLabel
    Left = 10
    Top = 55
    Width = 97
    Height = 13
    Alignment = taRightJustify
    Caption = 'Reference Company'
  end
  object Label5: TLabel
    Left = 31
    Top = 84
    Width = 77
    Height = 13
    Alignment = taRightJustify
    Caption = 'Folder for results'
  end
  object Label4: TLabel
    Left = 267
    Top = 8
    Width = 44
    Height = 13
    Caption = 'Company'
  end
  object lvTests: TListView
    Left = 115
    Top = 104
    Width = 960
    Height = 441
    Checkboxes = True
    Columns = <
      item
        Caption = 'Test Name'
        Width = 124
      end
      item
        Caption = 'Application'
        Width = 260
      end
      item
        Caption = 'Check Result'
        Width = 76
      end
      item
        Caption = 'Expected Result'
        Width = 92
      end
      item
        Caption = 'Compare DB'
        Width = 80
      end
      item
        Caption = 'Parameters'
        Width = 160
      end
      item
        Caption = 'Status'
        Width = 150
      end>
    GridLines = True
    HideSelection = False
    ReadOnly = True
    RowSelect = True
    ParentShowHint = False
    PopupMenu = PopupMenu1
    ShowHint = True
    TabOrder = 0
    ViewStyle = vsReport
    OnChange = lvTestsChange
    OnDblClick = btnEditClick
    OnInfoTip = lvTestsInfoTip
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 561
    Width = 1173
    Height = 19
    Panels = <>
    SimplePanel = True
  end
  object Panel1: TPanel
    Left = 1080
    Top = 0
    Width = 103
    Height = 565
    Anchors = []
    BevelOuter = bvNone
    TabOrder = 2
    DesignSize = (
      103
      565)
    object btnCompare: TButton
      Left = 8
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Com&pare DBs'
      TabOrder = 0
      OnClick = btnCompareClick
    end
    object btnRunAll: TButton
      Left = 8
      Top = 40
      Width = 75
      Height = 25
      Caption = '&Run Tests'
      TabOrder = 1
      OnClick = btnRunAllClick
    end
    object btnLoadResults: TButton
      Left = 8
      Top = 72
      Width = 75
      Height = 25
      Caption = '&Load Results'
      TabOrder = 2
      OnClick = btnLoadResultsClick
    end
    object btnAdd: TButton
      Left = 8
      Top = 136
      Width = 75
      Height = 25
      Caption = '&Add'
      TabOrder = 3
      OnClick = btnAddClick
    end
    object btnEdit: TButton
      Left = 8
      Top = 168
      Width = 75
      Height = 25
      Caption = '&Edit'
      TabOrder = 4
      OnClick = btnEditClick
    end
    object btnDelete: TButton
      Left = 8
      Top = 200
      Width = 75
      Height = 25
      Caption = '&Delete'
      TabOrder = 5
      OnClick = btnDeleteClick
    end
    object btnRun: TButton
      Left = 8
      Top = 232
      Width = 75
      Height = 25
      Caption = 'R&un'
      TabOrder = 6
      OnClick = btnRunClick
    end
    object btnLoadTests: TButton
      Left = 8
      Top = 272
      Width = 75
      Height = 25
      Caption = 'Load Tests'
      TabOrder = 7
      OnClick = btnLoadTestsClick
    end
    object btnSave: TButton
      Left = 8
      Top = 304
      Width = 75
      Height = 25
      Caption = 'Save Tests'
      TabOrder = 8
      OnClick = btnSaveClick
    end
    object btnSaveAs: TButton
      Left = 8
      Top = 336
      Width = 75
      Height = 25
      Caption = 'Save Tests As'
      TabOrder = 9
      OnClick = btnSaveAsClick
    end
    object btnClose: TButton
      Left = 11
      Top = 519
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = '&Close'
      TabOrder = 10
      OnClick = btnCloseClick
    end
    object btnCheckAll: TButton
      Left = 8
      Top = 368
      Width = 75
      Height = 25
      Caption = 'Tick All'
      TabOrder = 11
      OnClick = btnCheckAllClick
    end
  end
  object cbTestDb: TComboBox
    Left = 115
    Top = 24
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    Sorted = True
    TabOrder = 3
    OnChange = cbTestDbChange
  end
  object cbTestCo: TComboBox
    Left = 267
    Top = 24
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    Sorted = True
    TabOrder = 4
    OnChange = cbTestCoChange
  end
  object cbRefCo: TComboBox
    Left = 267
    Top = 53
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    Sorted = True
    TabOrder = 6
    OnChange = cbRefCoChange
  end
  object cbRefDb: TComboBox
    Left = 115
    Top = 53
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    Sorted = True
    TabOrder = 5
    OnChange = cbRefDbChange
  end
  object edtResultsFolder: TEdit
    Left = 115
    Top = 82
    Width = 121
    Height = 21
    TabOrder = 7
    Text = 'C:\TestResults\'
  end
  object chkCompareAtEnd: TCheckBox
    Left = 267
    Top = 84
    Width = 320
    Height = 17
    Caption = 'Compare DBs at end of run, (Overrides individual compares.)'
    TabOrder = 8
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'ini'
    Filter = 'CSV Files (*.csv)|*.csv'
    Left = 3
    Top = 120
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'csv'
    Filter = 'CSV Files (*.csv)|*.csv'
    Left = 3
    Top = 160
  end
  object MainMenu1: TMainMenu
    Left = 443
    Top = 8
    object File1: TMenuItem
      Caption = '&File'
      object New1: TMenuItem
        Caption = '&New'
        OnClick = New1Click
      end
      object Open1: TMenuItem
        Caption = '&Open...'
        OnClick = btnLoadTestsClick
      end
      object Save1: TMenuItem
        Caption = '&Save...'
        OnClick = btnSaveClick
      end
      object SaveAs1: TMenuItem
        Caption = 'Save &As...'
        OnClick = btnSaveAsClick
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Exit1: TMenuItem
        Caption = 'E&xit'
        OnClick = btnCloseClick
      end
    end
    object est1: TMenuItem
      Caption = '&Test'
      object Add1: TMenuItem
        Caption = '&Add'
        OnClick = btnAddClick
      end
      object Edit1: TMenuItem
        Caption = '&Edit'
        OnClick = btnEditClick
      end
      object Delete1: TMenuItem
        Caption = '&Delete'
        OnClick = btnDeleteClick
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object Run1: TMenuItem
        Caption = '&Run'
        OnClick = btnRunClick
      end
    end
    object ools1: TMenuItem
      Caption = 'F&unctions'
      object CompareDatabases1: TMenuItem
        Caption = 'Compare &Databases'
        OnClick = btnCompareClick
      end
      object RunTests1: TMenuItem
        Caption = '&Run Tests'
        OnClick = btnRunAllClick
      end
      object CheckTests1: TMenuItem
        Caption = '&Check Tests'
        OnClick = CheckTests1Click
      end
      object LoadResults1: TMenuItem
        Caption = '&Load Results'
        OnClick = btnLoadResultsClick
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object SetupDatabase1: TMenuItem
        Caption = '&Setup Test Company'
        OnClick = SetupDatabase1Click
      end
    end
    object hELP1: TMenuItem
      Caption = '&Help'
      object About1: TMenuItem
        Caption = '&About'
        OnClick = About1Click
      end
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 496
    Top = 24
    object Add2: TMenuItem
      Caption = '&Add'
      OnClick = btnAddClick
    end
    object Edit2: TMenuItem
      Caption = '&Edit'
      OnClick = btnEditClick
    end
    object Delete2: TMenuItem
      Caption = '&Delete'
      OnClick = btnDeleteClick
    end
    object Run2: TMenuItem
      Caption = '&Run'
      OnClick = btnRunClick
    end
  end
end
