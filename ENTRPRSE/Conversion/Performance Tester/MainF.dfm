object frmMain: TfrmMain
  Left = 320
  Top = 198
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'frmMain'
  ClientHeight = 274
  ClientWidth = 532
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
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object shBanner: TShape
    Left = 0
    Top = 0
    Width = 532
    Height = 43
    Align = alTop
  end
  object lblBanner: TLabel
    Left = 8
    Top = 7
    Width = 262
    Height = 29
    Caption = 'Start Performance Test'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object Label1: TLabel
    Left = 54
    Top = 157
    Width = 103
    Height = 14
    Caption = 'Computer Description'
  end
  object Label2: TLabel
    Left = 11
    Top = 49
    Width = 510
    Height = 14
    AutoSize = False
    Caption = 
      'This utility performs a simple disk-write test on the computer'#39's' +
      ' local hard disk to give a rough measure'
  end
  object Label3: TLabel
    Left = 11
    Top = 64
    Width = 510
    Height = 14
    AutoSize = False
    Caption = 
      'of performance.  This can then be used to help select the best c' +
      'omputer to use when converting your'
  end
  object Label4: TLabel
    Left = 11
    Top = 78
    Width = 510
    Height = 14
    AutoSize = False
    Caption = 'Exchequer Accounts Data to Exchequer v6.00 format.'
  end
  object Label5: TLabel
    Left = 11
    Top = 103
    Width = 510
    Height = 14
    AutoSize = False
    Caption = 
      'If this utility is run from a common writeable location across a' +
      'll workstations, for example, a network'
  end
  object Label6: TLabel
    Left = 11
    Top = 117
    Width = 510
    Height = 14
    AutoSize = False
    Caption = 
      'drive or  USB key, then a league table will automatically be kep' +
      't.  The Computer Description field below'
  end
  object Label7: TLabel
    Left = 11
    Top = 132
    Width = 510
    Height = 14
    AutoSize = False
    Caption = 
      'can be used to enter a meaningful description for the current co' +
      'mputer:-'
  end
  object Label8: TLabel
    Left = 11
    Top = 217
    Width = 510
    Height = 14
    AutoSize = False
    Caption = 
      'To start the performance test click the &Start Test button below' +
      '.'
  end
  object lblProgress: TLabel
    Left = 318
    Top = 246
    Width = 195
    Height = 14
    AutoSize = False
  end
  object Label9: TLabel
    Left = 89
    Top = 185
    Width = 68
    Height = 14
    Caption = 'Test Directory'
  end
  object btnStartTest: TButton
    Left = 228
    Top = 242
    Width = 80
    Height = 21
    Caption = '&Start Test'
    TabOrder = 1
    OnClick = btnStartTestClick
  end
  object edtComputerDesc: TEdit
    Left = 164
    Top = 154
    Width = 255
    Height = 22
    MaxLength = 30
    TabOrder = 0
  end
  object btnLeagueTable: TButton
    Left = 424
    Top = 155
    Width = 80
    Height = 21
    Caption = '&League Table'
    TabOrder = 2
    OnClick = btnLeagueTableClick
  end
  object edtTestDirectory: TEdit
    Left = 164
    Top = 182
    Width = 255
    Height = 22
    MaxLength = 30
    TabOrder = 3
  end
  object EnterToTab1: TEnterToTab
    ConvertEnters = True
    OverrideFont = True
    Version = 'TEnterToTab v1.02 for Delphi 6.01'
    Left = 437
    Top = 65535
  end
end
