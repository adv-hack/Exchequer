object frmReportDispProps: TfrmReportDispProps
  Left = 332
  Top = 185
  HelpContext = 26
  BorderIcons = [biSystemMenu, biHelp]
  BorderStyle = bsDialog
  Caption = 'Visual Report Writer Properties'
  ClientHeight = 239
  ClientWidth = 349
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
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 14
  object gbBannerColours: TGroupBox
    Left = 5
    Top = 3
    Width = 252
    Height = 74
    Caption = ' Report Designer Region Banner '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object shBackgroundColour: TShape
      Left = 10
      Top = 17
      Width = 110
      Height = 21
    end
    object shFontColour: TShape
      Left = 10
      Top = 44
      Width = 110
      Height = 21
    end
    object btnBackgroundColour: TButton
      Left = 130
      Top = 17
      Width = 110
      Height = 21
      Caption = 'Background Colour'
      TabOrder = 0
      OnClick = btnBackgroundColourClick
    end
    object btnFontColour: TButton
      Left = 130
      Top = 44
      Width = 110
      Height = 21
      Caption = 'Font Colour'
      TabOrder = 1
      OnClick = btnFontColourClick
    end
  end
  object gbSectionFonts: TGroupBox
    Left = 5
    Top = 175
    Width = 252
    Height = 60
    Caption = ' Default Report Font '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    object lblFontExample: TLabel
      Left = 5
      Top = 17
      Width = 242
      Height = 37
      AutoSize = False
      Caption = 'Example:- AaBbCcDdEeFfGg - 1234567890'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
  end
  object btnOK: TButton
    Left = 264
    Top = 9
    Width = 80
    Height = 21
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 3
  end
  object btnCancel: TButton
    Left = 264
    Top = 33
    Width = 80
    Height = 21
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 4
  end
  object btnDefaults: TButton
    Left = 264
    Top = 87
    Width = 80
    Height = 21
    Caption = 'Defaults'
    TabOrder = 6
    OnClick = btnDefaultsClick
  end
  object btnChangeFont: TButton
    Left = 264
    Top = 63
    Width = 80
    Height = 21
    Caption = 'Change &Font'
    TabOrder = 5
    OnClick = btnChangeFontClick
  end
  object GroupBox1: TGroupBox
    Left = 5
    Top = 79
    Width = 252
    Height = 94
    Caption = ' Report Designer Grid '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object Label81: Label8
      Left = 25
      Top = 41
      Width = 139
      Height = 14
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Vertical Separation (mm)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Label82: Label8
      Left = 25
      Top = 67
      Width = 139
      Height = 14
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Horizontal Separation (mm)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object chkShowGrid: TBorCheckEx
      Left = 9
      Top = 17
      Width = 85
      Height = 20
      Align = alRight
      Caption = 'Show Grid'
      Color = clBtnFace
      ParentColor = False
      TabOrder = 0
      TabStop = True
      TextId = 0
    end
    object edtYMM: Text8Pt
      Left = 167
      Top = 38
      Width = 27
      Height = 22
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      MaxLength = 2
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      Text = '1'
      TextId = 0
      ViaSBtn = False
    end
    object udYMM: TSBSUpDown
      Left = 194
      Top = 38
      Width = 15
      Height = 22
      Associate = edtYMM
      Min = 1
      Max = 10
      Position = 1
      TabOrder = 2
      Wrap = False
    end
    object edtXMM: Text8Pt
      Left = 167
      Top = 64
      Width = 27
      Height = 22
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      MaxLength = 2
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      Text = '1'
      TextId = 0
      ViaSBtn = False
    end
    object udXMM: TSBSUpDown
      Left = 194
      Top = 64
      Width = 15
      Height = 22
      Associate = edtXMM
      Min = 1
      Max = 10
      Position = 1
      TabOrder = 4
      Wrap = False
    end
  end
  object ColourDialog1: TColorDialog
    Ctl3D = True
    Left = 287
    Top = 110
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
    Left = 287
    Top = 153
  end
  object EnterToTab1: TEnterToTab
    ConvertEnters = True
    OverrideFont = False
    Version = 'TEnterToTab v1.02 for Delphi 6.01'
    Left = 288
    Top = 198
  end
end
