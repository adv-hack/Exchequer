object frmVRWReportProperties: TfrmVRWReportProperties
  Left = 392
  Top = 70
  HelpContext = 74
  BorderIcons = [biSystemMenu, biHelp]
  BorderStyle = bsSingle
  Caption = 'Report Properties'
  ClientHeight = 523
  ClientWidth = 542
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
  PixelsPerInch = 96
  TextHeight = 14
  object btnOK: TButton
    Left = 185
    Top = 498
    Width = 80
    Height = 21
    Caption = '&OK'
    TabOrder = 3
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 276
    Top = 498
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 4
    OnClick = btnCancelClick
  end
  object gbFileIdx: TGroupBox
    Left = 5
    Top = 160
    Width = 533
    Height = 170
    Caption = ' Data Access '
    TabOrder = 1
    object Label84: Label8
      Left = 3
      Top = 20
      Width = 63
      Height = 14
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Main File'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object lblIndex: Label8
      Left = 3
      Top = 45
      Width = 63
      Height = 14
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Index'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object lblRFDesc: Label8
      Left = 3
      Top = 100
      Width = 63
      Height = 14
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Description'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object lblRFFrom: Label8
      Left = 3
      Top = 126
      Width = 63
      Height = 14
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Range Start'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object lblRFTo: Label8
      Left = 226
      Top = 126
      Width = 57
      Height = 14
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Range End'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object lblRFIntro: Label8
      Left = 7
      Top = 67
      Width = 518
      Height = 30
      AutoSize = False
      Caption = 
        'This index supports an optional Range Filter, using this to filt' +
        'er the selected data will cause the report to print faster:-'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      WordWrap = True
      TextId = 0
    end
    object cbIndex: TComboBox
      Left = 71
      Top = 42
      Width = 455
      Height = 22
      Style = csDropDownList
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ItemHeight = 14
      ParentFont = False
      TabOrder = 1
      OnClick = cbIndexClick
    end
    object cbMainFile: TComboBox
      Left = 71
      Top = 17
      Width = 455
      Height = 22
      Style = csDropDownList
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ItemHeight = 14
      ParentFont = False
      TabOrder = 0
      OnClick = cbMainFileClick
    end
    object edtRFDescr: Text8Pt
      Left = 71
      Top = 97
      Width = 368
      Height = 22
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      MaxLength = 255
      ParentFont = False
      ParentShowHint = False
      ReadOnly = True
      ShowHint = True
      TabOrder = 2
      TextId = 0
      ViaSBtn = False
    end
    object edtRFFrom: Text8Pt
      Left = 71
      Top = 123
      Width = 152
      Height = 22
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      MaxLength = 50
      ParentFont = False
      ParentShowHint = False
      ReadOnly = True
      ShowHint = True
      TabOrder = 4
      TextId = 0
      ViaSBtn = False
    end
    object edtRFTo: Text8Pt
      Left = 287
      Top = 123
      Width = 152
      Height = 22
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      MaxLength = 50
      ParentFont = False
      ParentShowHint = False
      ReadOnly = True
      ShowHint = True
      TabOrder = 5
      TextId = 0
      ViaSBtn = False
    end
    object chkRFAsk: TCheckBox
      Left = 71
      Top = 148
      Width = 202
      Height = 16
      Caption = 'Always ask the user for input'
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 6
      OnClick = cbTestModeClick
    end
    object btnRangeFilter: TSBSButton
      Left = 444
      Top = 97
      Width = 80
      Height = 21
      Caption = 'Edit &Filter'
      TabOrder = 3
      OnClick = btnRangeFilterClick
      TextId = 0
    end
  end
  object GroupBox1: TGroupBox
    Left = 5
    Top = 3
    Width = 533
    Height = 154
    Caption = ' Report Details '
    TabOrder = 0
    object Label81: Label8
      Left = 3
      Top = 20
      Width = 63
      Height = 14
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Name'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Label82: Label8
      Left = 3
      Top = 46
      Width = 63
      Height = 14
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Description'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Label83: Label8
      Left = 3
      Top = 130
      Width = 63
      Height = 14
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Orientation'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Label1: TLabel
      Left = 16
      Top = 104
      Width = 51
      Height = 14
      Caption = 'Paper size'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object edtReportName: Text8Pt
      Left = 71
      Top = 17
      Width = 455
      Height = 22
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      MaxLength = 50
      ParentFont = False
      ParentShowHint = False
      ReadOnly = True
      ShowHint = True
      TabOrder = 0
      TextId = 0
      ViaSBtn = False
    end
    object memReportDesc: TMemo
      Left = 71
      Top = 43
      Width = 455
      Height = 52
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      MaxLength = 255
      ParentFont = False
      TabOrder = 1
    end
    object rbPortrait: TRadioButton
      Left = 73
      Top = 129
      Width = 62
      Height = 17
      Caption = 'Portrait'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
    end
    object rbLandscape: TRadioButton
      Left = 139
      Top = 129
      Width = 79
      Height = 17
      Caption = 'Landscape'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
    end
    object cbPaperSize: TComboBox
      Left = 72
      Top = 100
      Width = 145
      Height = 22
      Style = csDropDownList
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ItemHeight = 14
      ParentFont = False
      TabOrder = 2
    end
  end
  object GroupBox2: TGroupBox
    Left = 5
    Top = 332
    Width = 533
    Height = 162
    Caption = ' Miscellaneous Options '
    TabOrder = 2
    object Label86: Label8
      Left = 7
      Top = 16
      Width = 518
      Height = 46
      AutoSize = False
      Caption = 
        #39'Test Mode'#39' is used to speed up the process of writing a new rep' +
        'ort when you have lots of data, when enabled it stops the printi' +
        'ng process once a specified number of records have been returned' +
        ', reducing the time taken to print the report.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      WordWrap = True
      TextId = 0
    end
    object Label87: Label8
      Left = 7
      Top = 92
      Width = 518
      Height = 46
      AutoSize = False
      Caption = 
        'By default, the Visual Report Writer searches the database to fi' +
        'nd the first and last records to print. If you have a static rep' +
        'ort containing the same records each time, you can disable this ' +
        'behaviour to reduce the time taken to print the report:-'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      WordWrap = True
      TextId = 0
    end
    object cbTestMode: TCheckBox
      Left = 71
      Top = 64
      Width = 102
      Height = 17
      Caption = 'Use Test Mode'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = cbTestModeClick
    end
    object lbledtSampleCount: TLabeledEdit
      Left = 289
      Top = 61
      Width = 74
      Height = 22
      EditLabel.Width = 91
      EditLabel.Height = 14
      EditLabel.Caption = 'Number of records'
      EditLabel.Font.Charset = DEFAULT_CHARSET
      EditLabel.Font.Color = clWindowText
      EditLabel.Font.Height = -11
      EditLabel.Font.Name = 'Arial'
      EditLabel.Font.Style = []
      EditLabel.ParentFont = False
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      LabelPosition = lpLeft
      LabelSpacing = 5
      ParentFont = False
      TabOrder = 1
    end
    object cbRefreshFirst: TCheckBox
      Left = 71
      Top = 139
      Width = 124
      Height = 17
      Caption = 'Refresh First Record'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
    end
    object cbRefreshLast: TCheckBox
      Left = 215
      Top = 139
      Width = 127
      Height = 17
      Caption = 'Refresh Last Record'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
    end
  end
  object EnterToTab1: TEnterToTab
    ConvertEnters = True
    OverrideFont = False
    Version = 'TEnterToTab v1.02 for Delphi 6.01'
    Left = 479
    Top = 6
  end
end
