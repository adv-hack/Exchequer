object FrmPrinterCodes: TFrmPrinterCodes
  Left = 290
  Top = 225
  BorderStyle = bsDialog
  Caption = 'Printer Codes'
  ClientHeight = 375
  ClientWidth = 465
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel
    Left = 45
    Top = 20
    Width = 61
    Height = 14
    Alignment = taRightJustify
    Caption = 'Printer Name'
  end
  object Label2: TLabel
    Left = 18
    Top = 44
    Width = 88
    Height = 14
    Alignment = taRightJustify
    Caption = #163' Translation Char'
  end
  object Label3: TLabel
    Left = 87
    Top = 68
    Width = 19
    Height = 14
    Alignment = taRightJustify
    Caption = 'Port'
  end
  object edName: TEdit
    Left = 112
    Top = 16
    Width = 89
    Height = 22
    MaxLength = 8
    TabOrder = 0
  end
  object edPoundChar: TEdit
    Left = 112
    Top = 40
    Width = 33
    Height = 22
    MaxLength = 1
    TabOrder = 1
  end
  object sbCodes: TScrollBox
    Left = 8
    Top = 96
    Width = 449
    Height = 273
    TabOrder = 3
  end
  object btnOK: TButton
    Left = 376
    Top = 16
    Width = 80
    Height = 21
    Caption = '&OK'
    TabOrder = 4
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 376
    Top = 40
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    TabOrder = 5
    OnClick = btnCancelClick
  end
  object edPort: TCurrencyEdit
    Left = 112
    Top = 64
    Width = 33
    Height = 22
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'ARIAL'
    Font.Style = []
    MaxLength = 3
    ParentFont = False
    TabOrder = 2
    WantReturns = False
    WordWrap = False
    AutoSize = False
    BlankOnZero = False
    DisplayFormat = '#'
    ShowCurrency = False
    TextId = 0
    Value = 1E-10
  end
  object EnterToTab1: TEnterToTab
    ConvertEnters = True
    OverrideFont = False
    Version = 'TEnterToTab v1.02 for Delphi 6.01'
    Left = 280
    Top = 16
  end
end
