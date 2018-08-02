object frmDBFieldProperties: TfrmDBFieldProperties
  Left = 295
  Top = 152
  HelpContext = 124
  BorderIcons = [biSystemMenu, biHelp]
  BorderStyle = bsDialog
  Caption = 'DB Field Properties'
  ClientHeight = 344
  ClientWidth = 478
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnCloseQuery = FormCloseQuery
  PixelsPerInch = 96
  TextHeight = 14
  object GroupBox1: TGroupBox
    Left = 5
    Top = 2
    Width = 382
    Height = 155
    Caption = ' Field Details '
    TabOrder = 0
    object Label81: Label8
      Left = 5
      Top = 17
      Width = 85
      Height = 14
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Code'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Label82: Label8
      Left = 5
      Top = 46
      Width = 85
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
    object lblFieldDesc: Label8
      Left = 98
      Top = 46
      Width = 265
      Height = 14
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Label84: Label8
      Left = 5
      Top = 71
      Width = 85
      Height = 14
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Type'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object lblFieldType: Label8
      Left = 99
      Top = 71
      Width = 266
      Height = 14
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object lblPeriodYear: Label8
      Left = 5
      Top = 97
      Width = 85
      Height = 14
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Period/Year'
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object lblCurrency: Label8
      Left = 185
      Top = 95
      Width = 60
      Height = 14
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Currency'
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object lblInputLink: Label8
      Left = 8
      Top = 127
      Width = 81
      Height = 14
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Input link'
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object edtFieldCode: Text8Pt
      Left = 95
      Top = 15
      Width = 110
      Height = 22
      CharCase = ecUpperCase
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      MaxLength = 8
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnExit = edtFieldCodeExit
      TextId = 0
      ViaSBtn = False
    end
    object btnSelectField: TSBSButton
      Left = 208
      Top = 15
      Width = 80
      Height = 21
      Caption = '&Select'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = btnSelectFieldClick
      TextId = 0
    end
    object edtPeriod: TEdit
      Left = 95
      Top = 93
      Width = 35
      Height = 22
      CharCase = ecUpperCase
      Enabled = False
      TabOrder = 2
    end
    object edtYear: TEdit
      Left = 132
      Top = 93
      Width = 35
      Height = 22
      Enabled = False
      TabOrder = 3
    end
    object cbCurrency: TComboBox
      Left = 251
      Top = 92
      Width = 100
      Height = 22
      Enabled = False
      ItemHeight = 14
      TabOrder = 4
    end
    object cbInputLink: TComboBox
      Left = 95
      Top = 124
      Width = 154
      Height = 22
      Enabled = False
      ItemHeight = 14
      TabOrder = 5
    end
  end
  object GroupBox2: TGroupBox
    Left = 5
    Top = 158
    Width = 382
    Height = 111
    Caption = ' Formatting '
    TabOrder = 1
    object lblFieldFormat: TLabel
      Left = 6
      Top = 17
      Width = 84
      Height = 14
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Alignment'
    end
    object lblDecPlaces: TLabel
      Left = 5
      Top = 44
      Width = 85
      Height = 14
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Decimal Places'
      Enabled = False
    end
    object cbAlignment: TComboBox
      Left = 94
      Top = 14
      Width = 167
      Height = 22
      Style = csDropDownList
      ItemHeight = 14
      ItemIndex = 0
      TabOrder = 0
      Text = 'Left Justified'
      Items.Strings = (
        'Left Justified'
        'Centred Horizontally'
        'Right Justified')
    end
    object chkBlankOnZero: TCheckBox
      Left = 19
      Top = 68
      Width = 88
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Blank On Zero'
      Enabled = False
      TabOrder = 2
    end
    object chkPrintField: TCheckBox
      Left = 42
      Top = 89
      Width = 65
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Print Field'
      Checked = True
      State = cbChecked
      TabOrder = 3
    end
    object chkPercentage: TCheckBox
      Left = 287
      Top = 16
      Width = 74
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Percentage'
      TabOrder = 1
    end
    object edtDecs: TEdit
      Left = 94
      Top = 40
      Width = 21
      Height = 22
      TabOrder = 4
      Text = '2'
    end
    object udDecs: TUpDown
      Left = 115
      Top = 40
      Width = 15
      Height = 22
      Associate = edtDecs
      Min = 0
      Position = 2
      TabOrder = 5
      Wrap = False
    end
  end
  object btnOK: TSBSButton
    Left = 392
    Top = 9
    Width = 80
    Height = 21
    Caption = '&OK'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ModalResult = 1
    ParentFont = False
    TabOrder = 3
    OnClick = btnOKClick
    TextId = 0
  end
  object btnCancel: TSBSButton
    Left = 392
    Top = 35
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ModalResult = 2
    ParentFont = False
    TabOrder = 4
    TextId = 0
  end
  object GroupBox3: TGroupBox
    Left = 5
    Top = 271
    Width = 382
    Height = 68
    Caption = ' Font Example '
    TabOrder = 2
    object lblFontExample: TLabel
      Left = 6
      Top = 16
      Width = 371
      Height = 44
      AutoSize = False
      Caption = 'abcdefghijklmnopqrstuvwxyz 1234567890'
      OnDblClick = btnChangeFontClick
    end
  end
  object btnChangeFont: TSBSButton
    Left = 392
    Top = 316
    Width = 80
    Height = 21
    Caption = 'Change &Font'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    OnClick = btnChangeFontClick
    TextId = 0
  end
  object FontDialog1: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MinFontSize = 0
    MaxFontSize = 0
    Options = [fdEffects, fdForceFontExist]
    Left = 421
    Top = 212
  end
  object EnterToTab1: TEnterToTab
    ConvertEnters = True
    OverrideFont = False
    Version = 'TEnterToTab v1.02 for Delphi 6.01'
    Left = 426
    Top = 82
  end
end
