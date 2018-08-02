object frmCriteria: TfrmCriteria
  Left = 433
  Top = 307
  HorzScrollBar.Visible = False
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Administration'
  ClientHeight = 334
  ClientWidth = 345
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 14
  object Bevel5: TBevel
    Left = 8
    Top = 8
    Width = 329
    Height = 42
    Shape = bsFrame
  end
  object Label1: TLabel
    Left = 24
    Top = 20
    Width = 51
    Height = 14
    Caption = 'Company :'
  end
  object Bevel1: TBevel
    Left = 8
    Top = 48
    Width = 329
    Height = 98
    Shape = bsFrame
  end
  object Label3: TLabel
    Left = 24
    Top = 64
    Width = 64
    Height = 14
    Caption = 'Report Type :'
  end
  object Bevel3: TBevel
    Left = 8
    Top = 144
    Width = 329
    Height = 82
    Shape = bsFrame
  end
  object Label4: TLabel
    Left = 24
    Top = 161
    Width = 91
    Height = 14
    Caption = 'VAT Period Month :'
  end
  object Label5: TLabel
    Left = 24
    Top = 193
    Width = 85
    Height = 14
    Caption = 'VAT Period Year :'
  end
  object btnCancel: TButton
    Left = 256
    Top = 304
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    TabOrder = 8
    OnClick = btnCancelClick
  end
  object cmbCompany: TComboBox
    Left = 80
    Top = 16
    Width = 241
    Height = 22
    Style = csDropDownList
    ItemHeight = 14
    TabOrder = 0
    OnChange = cmbCompanyChange
  end
  object btnOK: TButton
    Left = 168
    Top = 304
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&OK'
    TabOrder = 7
    OnClick = btnOKClick
  end
  object rbMonthly: TRadioButton
    Left = 104
    Top = 64
    Width = 145
    Height = 17
    Caption = 'RCSL Monthly Report'
    Checked = True
    TabOrder = 1
    TabStop = True
  end
  object rbQuarterly: TRadioButton
    Left = 104
    Top = 88
    Width = 145
    Height = 17
    Caption = 'RCSL Quarterly Report'
    TabOrder = 2
  end
  object rbAnnual: TRadioButton
    Left = 104
    Top = 112
    Width = 145
    Height = 17
    Caption = 'RCSL Annual Report'
    TabOrder = 3
  end
  object panPrint: TPanel
    Left = 8
    Top = 224
    Width = 329
    Height = 73
    BevelOuter = bvNone
    TabOrder = 6
    object Label2: TLabel
      Left = 16
      Top = 16
      Width = 68
      Height = 14
      Caption = 'Print Report to'
    end
    object Bevel2: TBevel
      Left = 0
      Top = 0
      Width = 329
      Height = 73
      Shape = bsFrame
    end
    object rbPrinter: TRadioButton
      Left = 96
      Top = 16
      Width = 113
      Height = 17
      Caption = 'Printer / Preview'
      Checked = True
      TabOrder = 0
      TabStop = True
    end
    object rbCSV: TRadioButton
      Left = 96
      Top = 40
      Width = 113
      Height = 17
      Caption = 'CSV File'
      TabOrder = 1
    end
  end
  object cmbMonth: TComboBox
    Left = 120
    Top = 157
    Width = 89
    Height = 22
    Style = csDropDownList
    ItemHeight = 14
    TabOrder = 4
  end
  object seYear: TSpinEdit
    Left = 120
    Top = 188
    Width = 89
    Height = 23
    MaxLength = 4
    MaxValue = 2100
    MinValue = 1900
    TabOrder = 5
    Value = 2000
  end
  object MainMenu1: TMainMenu
    Left = 8
    Top = 304
    object File1: TMenuItem
      Caption = 'File'
      object Exit1: TMenuItem
        Caption = 'Exit'
        OnClick = Exit1Click
      end
    end
    object Help1: TMenuItem
      Caption = 'Help'
      object About1: TMenuItem
        Caption = 'About'
        OnClick = About1Click
      end
    end
  end
  object EnterToTab1: TEnterToTab
    ConvertEnters = True
    OverrideFont = True
    Version = 'TEnterToTab v1.02 for Delphi 6.01'
    Left = 40
    Top = 304
  end
  object dlgSave: TSaveDialog
    DefaultExt = 'CSV'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 72
    Top = 304
  end
end
