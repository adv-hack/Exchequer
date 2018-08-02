object Form7: TForm7
  Left = 224
  Top = 190
  Width = 391
  Height = 387
  Caption = 'Test Licence Viewer'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 112
    Top = 320
    Width = 161
    Height = 13
    Alignment = taCenter
    AutoSize = False
    Caption = 'User response:'
  end
  object Label2: TLabel
    Left = 8
    Top = 24
    Width = 79
    Height = 13
    Caption = 'Plain Licence File'
  end
  object Label3: TLabel
    Left = 8
    Top = 80
    Width = 106
    Height = 13
    Caption = 'Encrypted Licence File'
  end
  object Label4: TLabel
    Left = 8
    Top = 128
    Width = 82
    Height = 13
    Caption = 'Acceptance Data'
  end
  object Button1: TButton
    Left = 127
    Top = 288
    Width = 129
    Height = 25
    Caption = 'View Encrypted Licence'
    TabOrder = 0
    OnClick = Button1Click
  end
  object edtPlainLicenceFile: TEdit
    Left = 8
    Top = 40
    Width = 281
    Height = 21
    TabOrder = 1
    Text = 'C:\Dev\IRISLicence\GPA_Licence.rvf'
  end
  object edtEncryptedLicenceFile: TEdit
    Left = 8
    Top = 96
    Width = 281
    Height = 21
    TabOrder = 2
    Text = 'C:\Dev\IRISLicence\GPA_Licence.lic'
  end
  object btnEncryptFile: TButton
    Left = 297
    Top = 39
    Width = 75
    Height = 25
    Caption = 'Encrypt File'
    TabOrder = 3
    OnClick = btnEncryptFileClick
  end
  object btnDecryptFile: TButton
    Left = 297
    Top = 95
    Width = 75
    Height = 25
    Caption = 'Decrypt File'
    TabOrder = 4
    OnClick = btnDecryptFileClick
  end
  object btnWriteAccData: TButton
    Left = 296
    Top = 144
    Width = 81
    Height = 25
    Caption = 'Write Acc Data'
    TabOrder = 5
    OnClick = btnWriteAccDataClick
  end
  object Memo: TMemo
    Left = 8
    Top = 144
    Width = 281
    Height = 97
    Lines.Strings = (
      'v1'
      '16/11/2008')
    TabOrder = 6
  end
  object edtAcceptanceFile: TEdit
    Left = 8
    Top = 248
    Width = 281
    Height = 21
    TabOrder = 7
    Text = 'C:\Dev\IRISLicence\GPA_Licence.acc'
  end
  object btnReadAccData: TButton
    Left = 296
    Top = 176
    Width = 81
    Height = 25
    Caption = 'Read Acc Data'
    TabOrder = 8
    OnClick = btnReadAccDataClick
  end
end
