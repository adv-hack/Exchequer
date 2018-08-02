object frmTest: TfrmTest
  Left = 518
  Top = 291
  BorderStyle = bsDialog
  Caption = 'Test Input'
  ClientHeight = 183
  ClientWidth = 233
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object Bevel1: TBevel
    Left = 8
    Top = 8
    Width = 217
    Height = 137
    Shape = bsFrame
  end
  object Label1: TLabel
    Left = 16
    Top = 20
    Width = 91
    Height = 14
    Caption = 'Cost Centre Code :'
  end
  object Label2: TLabel
    Left = 18
    Top = 52
    Width = 89
    Height = 14
    Caption = 'Department Code :'
  end
  object lGLCode: TLabel
    Left = 59
    Top = 116
    Width = 48
    Height = 14
    Alignment = taRightJustify
    Caption = 'GL Code :'
  end
  object lVAT: TLabel
    Left = 50
    Top = 84
    Width = 56
    Height = 14
    Caption = 'VAT Code :'
  end
  object edCC: TEdit
    Left = 112
    Top = 16
    Width = 97
    Height = 22
    CharCase = ecUpperCase
    MaxLength = 3
    TabOrder = 0
  end
  object edDept: TEdit
    Left = 112
    Top = 48
    Width = 97
    Height = 22
    CharCase = ecUpperCase
    MaxLength = 3
    TabOrder = 1
  end
  object btnTest: TButton
    Left = 56
    Top = 152
    Width = 80
    Height = 21
    Caption = '&Test'
    TabOrder = 4
    OnClick = btnTestClick
  end
  object btnClose: TButton
    Left = 144
    Top = 152
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Close'
    TabOrder = 5
    OnClick = btnCloseClick
  end
  object edGLCode: TEdit
    Left = 112
    Top = 112
    Width = 97
    Height = 22
    TabOrder = 3
  end
  object cmbVAT: TComboBox
    Left = 112
    Top = 80
    Width = 98
    Height = 22
    Style = csDropDownList
    ItemHeight = 14
    TabOrder = 2
  end
  object EnterToTab1: TEnterToTab
    ConvertEnters = True
    OverrideFont = True
    Version = 'TEnterToTab v1.02 for Delphi 6.01'
    Left = 8
    Top = 152
  end
end
