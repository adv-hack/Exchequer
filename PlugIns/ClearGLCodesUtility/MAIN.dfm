object frmMain: TfrmMain
  Left = 449
  Top = 287
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsDialog
  ClientHeight = 247
  ClientWidth = 377
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
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 14
  object Bevel1: TBevel
    Left = 8
    Top = 40
    Width = 361
    Height = 81
    Shape = bsFrame
  end
  object lCompany: TLabel
    Left = 8
    Top = 11
    Width = 51
    Height = 14
    Caption = 'Company :'
  end
  object lGLName: TLabel
    Left = 128
    Top = 92
    Width = 225
    Height = 14
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label1: TLabel
    Left = 16
    Top = 59
    Width = 109
    Height = 14
    Caption = 'General Ledger Code :'
  end
  object Label2: TLabel
    Left = 16
    Top = 91
    Width = 60
    Height = 14
    Caption = 'Description :'
  end
  object Label3: TLabel
    Left = 16
    Top = 140
    Width = 55
    Height = 14
    Caption = 'Date From :'
  end
  object Label4: TLabel
    Left = 16
    Top = 172
    Width = 43
    Height = 14
    Caption = 'Date To :'
  end
  object Bevel2: TBevel
    Left = 8
    Top = 119
    Width = 361
    Height = 90
    Shape = bsFrame
  end
  object cmbCompany: TComboBox
    Left = 64
    Top = 8
    Width = 305
    Height = 22
    Style = csDropDownList
    ItemHeight = 14
    TabOrder = 0
    OnChange = cmbCompanyChange
  end
  object btnRun: TButton
    Left = 200
    Top = 216
    Width = 80
    Height = 21
    Caption = 'C&lear'
    TabOrder = 1
    OnClick = btnRunClick
  end
  object btnCancel: TButton
    Left = 288
    Top = 216
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    TabOrder = 2
    OnClick = btnCancelClick
  end
  object edGLCode: TEdit
    Left = 128
    Top = 56
    Width = 73
    Height = 22
    MaxLength = 10
    TabOrder = 3
    OnChange = edGLCodeChange
  end
  object btnFindGLCode: TButton
    Left = 200
    Top = 56
    Width = 23
    Height = 21
    Caption = '...'
    TabOrder = 4
    OnClick = btnFindGLCodeClick
  end
  object edDateFrom: TDateTimePicker
    Left = 128
    Top = 136
    Width = 97
    Height = 22
    CalAlignment = dtaLeft
    Date = 39374.4230458796
    Time = 39374.4230458796
    DateFormat = dfShort
    DateMode = dmComboBox
    Kind = dtkDate
    ParseInput = False
    TabOrder = 5
  end
  object edDateTo: TDateTimePicker
    Left = 128
    Top = 168
    Width = 97
    Height = 22
    CalAlignment = dtaLeft
    Date = 39374.4230458796
    Time = 39374.4230458796
    DateFormat = dfShort
    DateMode = dmComboBox
    Kind = dtkDate
    ParseInput = False
    TabOrder = 6
  end
  object EnterToTab1: TEnterToTab
    ConvertEnters = True
    OverrideFont = True
    Version = 'TEnterToTab v1.02 for Delphi 6.01'
    Left = 8
    Top = 216
  end
end
