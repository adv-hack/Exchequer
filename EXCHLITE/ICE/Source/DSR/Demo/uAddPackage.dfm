object frmAddPackage: TfrmAddPackage
  Left = 421
  Top = 380
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Add Packages'
  ClientHeight = 333
  ClientWidth = 368
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 18
    Top = 22
    Width = 64
    Height = 13
    Caption = 'Description'
  end
  object Label2: TLabel
    Left = 18
    Top = 264
    Width = 85
    Height = 13
    Caption = 'User reference'
  end
  object Label3: TLabel
    Left = 18
    Top = 68
    Width = 49
    Height = 13
    Caption = 'File Guid'
  end
  object Label4: TLabel
    Left = 18
    Top = 120
    Width = 23
    Height = 13
    Caption = 'XML'
  end
  object Label5: TLabel
    Left = 18
    Top = 168
    Width = 22
    Height = 13
    Caption = 'XSL'
  end
  object Label6: TLabel
    Left = 18
    Top = 214
    Width = 25
    Height = 13
    Caption = 'XSD'
  end
  object btnXml: TSpeedButton
    Left = 332
    Top = 137
    Width = 23
    Height = 22
    OnClick = btnXmlClick
  end
  object btnXSL: TSpeedButton
    Left = 332
    Top = 183
    Width = 23
    Height = 22
    OnClick = btnXSLClick
  end
  object btnXSD: TSpeedButton
    Left = 332
    Top = 229
    Width = 23
    Height = 22
    OnClick = btnXSDClick
  end
  object bgtnAddPackage: TButton
    Left = 164
    Top = 276
    Width = 129
    Height = 25
    Caption = 'Add'
    ModalResult = 1
    TabOrder = 0
  end
  object edtDescription: TEdit
    Left = 18
    Top = 38
    Width = 121
    Height = 21
    TabOrder = 1
  end
  object edtUserReference: TEdit
    Left = 18
    Top = 280
    Width = 121
    Height = 21
    TabOrder = 2
  end
  object edtFileGuid: TEdit
    Tag = 9
    Left = 18
    Top = 86
    Width = 309
    Height = 21
    TabOrder = 3
  end
  object edtXml: TEdit
    Tag = 9
    Left = 18
    Top = 138
    Width = 309
    Height = 21
    TabOrder = 4
  end
  object edtXSL: TEdit
    Tag = 9
    Left = 18
    Top = 184
    Width = 309
    Height = 21
    TabOrder = 5
  end
  object edtXSD: TEdit
    Tag = 9
    Left = 18
    Top = 230
    Width = 309
    Height = 21
    TabOrder = 6
  end
end
