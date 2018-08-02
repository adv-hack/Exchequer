object Form1: TForm1
  Left = 352
  Top = 215
  BorderStyle = bsDialog
  Caption = 'Form1'
  ClientHeight = 119
  ClientWidth = 349
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 2
    Top = 13
    Width = 68
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Licencee'
  end
  object Label2: TLabel
    Left = 2
    Top = 38
    Width = 68
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Password'
  end
  object Label3: TLabel
    Left = 2
    Top = 62
    Width = 68
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Expiry Date'
  end
  object cbLicencee: TComboBox
    Left = 74
    Top = 10
    Width = 269
    Height = 21
    ItemHeight = 13
    TabOrder = 0
    Items.Strings = (
      'Exchequer Software (Australia) Ltd'
      'Exchequer Software (Ireland) Ltd'
      'Exchequer Software (New Zealand) Ltd')
  end
  object edtPword: TEdit
    Left = 74
    Top = 35
    Width = 121
    Height = 21
    TabOrder = 1
  end
  object btnWritelic: TButton
    Left = 12
    Top = 87
    Width = 329
    Height = 25
    Caption = 'Write Distributor Release Code Utility Licence'
    TabOrder = 2
    OnClick = btnWritelicClick
  end
  object mskLicExpiry: TMaskEdit
    Left = 74
    Top = 59
    Width = 89
    Height = 21
    EditMask = '!99/99/0000;1;_'
    MaxLength = 10
    TabOrder = 3
    Text = '  /  /    '
  end
end
