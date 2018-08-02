object frmDemo: TfrmDemo
  Left = 657
  Top = 217
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'E365Util Demo'
  ClientHeight = 220
  ClientWidth = 214
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel
    Left = 15
    Top = 115
    Width = 45
    Height = 14
    Caption = 'Company'
  end
  object Label2: TLabel
    Left = 15
    Top = 141
    Width = 34
    Height = 14
    Caption = 'User Id'
  end
  object Label3: TLabel
    Left = 15
    Top = 167
    Width = 50
    Height = 14
    Caption = 'Password'
  end
  object btnCreateMap: TButton
    Left = 9
    Top = 6
    Width = 80
    Height = 21
    Caption = 'Create Map'
    TabOrder = 0
    OnClick = btnCreateMapClick
  end
  object btnDestroyMap: TButton
    Left = 9
    Top = 31
    Width = 80
    Height = 21
    Caption = 'Destroy Map'
    TabOrder = 1
    OnClick = btnDestroyMapClick
  end
  object btnClearMap: TButton
    Left = 9
    Top = 56
    Width = 80
    Height = 21
    Caption = 'Clear Map'
    TabOrder = 2
    OnClick = btnClearMapClick
  end
  object edtCompanyCode: TEdit
    Left = 70
    Top = 111
    Width = 121
    Height = 22
    MaxLength = 6
    TabOrder = 3
  end
  object edtUserID: TEdit
    Left = 70
    Top = 137
    Width = 121
    Height = 22
    MaxLength = 12
    TabOrder = 4
  end
  object edtPassword: TEdit
    Left = 70
    Top = 163
    Width = 121
    Height = 22
    MaxLength = 9
    TabOrder = 5
  end
  object btnAddCompanyDetails: TButton
    Left = 13
    Top = 190
    Width = 182
    Height = 21
    Caption = 'Add Company Details'
    TabOrder = 6
    OnClick = btnAddCompanyDetailsClick
  end
end
