object frmViewLicence: TfrmViewLicence
  Left = 343
  Top = 177
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Exchequer Licence Viewer'
  ClientHeight = 228
  ClientWidth = 448
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = True
  Scaled = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 0
    Top = 0
    Width = 448
    Height = 2
    Align = alTop
    Shape = bsTopLine
  end
  object lblSno: TLabel
    Left = 6
    Top = 32
    Width = 105
    Height = 18
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'CD Serial Number'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ShowAccelChar = False
  end
  object lblSerialNo: TLabel
    Left = 120
    Top = 32
    Width = 91
    Height = 18
    AutoSize = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ShowAccelChar = False
  end
  object Label3: TLabel
    Left = 6
    Top = 160
    Width = 105
    Height = 18
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Exchequer Version'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ShowAccelChar = False
  end
  object lblEntVer: TLabel
    Left = 120
    Top = 160
    Width = 221
    Height = 18
    AutoSize = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ShowAccelChar = False
  end
  object Label9: TLabel
    Left = 6
    Top = 78
    Width = 105
    Height = 18
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Company'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ShowAccelChar = False
  end
  object lblCompany: TLabel
    Left = 120
    Top = 78
    Width = 324
    Height = 18
    AutoSize = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ShowAccelChar = False
  end
  object lblType: TLabel
    Left = 6
    Top = 6
    Width = 431
    Height = 23
    Alignment = taCenter
    AutoSize = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    ShowAccelChar = False
  end
  object Label11: TLabel
    Left = 6
    Top = 52
    Width = 105
    Height = 18
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'ESN'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ShowAccelChar = False
  end
  object lblESN: TLabel
    Left = 120
    Top = 52
    Width = 324
    Height = 18
    AutoSize = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ShowAccelChar = False
  end
  object Bevel2: TBevel
    Left = -1
    Top = 73
    Width = 454
    Height = 2
    Shape = bsTopLine
  end
  object Bevel3: TBevel
    Left = -1
    Top = 117
    Width = 454
    Height = 2
    Shape = bsTopLine
  end
  object Label12: TLabel
    Left = 6
    Top = 96
    Width = 105
    Height = 18
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Dealer'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ShowAccelChar = False
  end
  object lblDealer: TLabel
    Left = 120
    Top = 96
    Width = 324
    Height = 18
    AutoSize = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ShowAccelChar = False
  end
  object lblLicLicType: TLabel
    Left = 219
    Top = 32
    Width = 217
    Height = 18
    Alignment = taRightJustify
    AutoSize = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ShowAccelChar = False
  end
  object lblEngineType: TLabel
    Left = 6
    Top = 122
    Width = 105
    Height = 18
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'DB Engine'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ShowAccelChar = False
  end
  object lblCSvrVer: TLabel
    Left = 120
    Top = 122
    Width = 324
    Height = 18
    AutoSize = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ShowAccelChar = False
  end
  object lblEntCompanies: TLabel
    Left = 344
    Top = 160
    Width = 92
    Height = 18
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Companies  '
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ShowAccelChar = False
  end
  object Label2: TLabel
    Left = 6
    Top = 140
    Width = 105
    Height = 18
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Licence Key'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ShowAccelChar = False
  end
  object lblPSQLLicKey: TLabel
    Left = 120
    Top = 140
    Width = 324
    Height = 18
    AutoSize = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ShowAccelChar = False
  end
  object lstEntModules: TListBox
    Left = 128
    Top = 179
    Width = 316
    Height = 45
    BorderStyle = bsNone
    Color = clBtnFace
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 14
    ParentFont = False
    TabOrder = 0
    TabWidth = 120
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'LIC'
    Filter = 'Licence Files (*.LIC)|*.LIC|All Files (*.*)|*.*'
    Options = [ofPathMustExist, ofFileMustExist]
    Title = 'Open Exchequer CD Licence'
    Left = 81
    Top = 184
  end
  object MainMenu1: TMainMenu
    Left = 23
    Top = 183
    object Menu_File: TMenuItem
      Caption = '&File'
      object Menu_File_Open: TMenuItem
        Caption = '&Open'
        Hint = 'Open an existing licence file'
        OnClick = Menu_File_OpenClick
      end
      object Menu_File_SepBar1: TMenuItem
        Caption = '-'
      end
      object Menu_File_Exit: TMenuItem
        Caption = 'E&xit'
        OnClick = Menu_File_ExitClick
      end
    end
    object Menu_Help: TMenuItem
      Caption = '&Help'
      object Menu_Help_About: TMenuItem
        Caption = '&About'
        OnClick = Menu_Help_AboutClick
      end
    end
  end
end
