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
    Glyph.Data = {
      F6000000424DF600000000000000760000002800000010000000100000000100
      04000000000080000000CE0E0000C40E00001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
      77777777777777777777000000000007777700333333333077770B0333333333
      07770FB03333333330770BFB0333333333070FBFB000000000000BFBFBFBFB07
      77770FBFBFBFBF0777770BFB0000000777777000777777770007777777777777
      7007777777770777070777777777700077777777777777777777}
    OnClick = btnXmlClick
  end
  object btnXSL: TSpeedButton
    Left = 332
    Top = 183
    Width = 23
    Height = 22
    Glyph.Data = {
      F6000000424DF600000000000000760000002800000010000000100000000100
      04000000000080000000CE0E0000C40E00001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
      77777777777777777777000000000007777700333333333077770B0333333333
      07770FB03333333330770BFB0333333333070FBFB000000000000BFBFBFBFB07
      77770FBFBFBFBF0777770BFB0000000777777000777777770007777777777777
      7007777777770777070777777777700077777777777777777777}
    OnClick = btnXSLClick
  end
  object btnXSD: TSpeedButton
    Left = 332
    Top = 229
    Width = 23
    Height = 22
    Glyph.Data = {
      F6000000424DF600000000000000760000002800000010000000100000000100
      04000000000080000000CE0E0000C40E00001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
      77777777777777777777000000000007777700333333333077770B0333333333
      07770FB03333333330770BFB0333333333070FBFB000000000000BFBFBFBFB07
      77770FBFBFBFBF0777770BFB0000000777777000777777770007777777777777
      7007777777770777070777777777700077777777777777777777}
    OnClick = btnXSDClick
  end
  object bgtnAddPackage: TButton
    Left = 164
    Top = 276
    Width = 129
    Height = 25
    Caption = 'Add'
    TabOrder = 6
    OnClick = bgtnAddPackageClick
  end
  object edtDescription: TEdit
    Left = 18
    Top = 38
    Width = 289
    Height = 21
    MaxLength = 255
    TabOrder = 0
  end
  object edtUserReference: TEdit
    Left = 18
    Top = 280
    Width = 121
    Height = 21
    TabOrder = 5
  end
  object edtXml: TEdit
    Tag = 9
    Left = 18
    Top = 138
    Width = 309
    Height = 21
    TabOrder = 2
  end
  object edtXSL: TEdit
    Tag = 9
    Left = 18
    Top = 184
    Width = 309
    Height = 21
    TabOrder = 3
  end
  object edtXSD: TEdit
    Tag = 9
    Left = 18
    Top = 230
    Width = 309
    Height = 21
    TabOrder = 4
  end
  object edtFileGuid: TMaskEdit
    Left = 18
    Top = 88
    Width = 277
    Height = 21
    CharCase = ecUpperCase
    EditMask = '{AAAAAAAA-AAAA-AAAA-AAAA-AAAAAAAAAAAA};1;_'
    MaxLength = 38
    TabOrder = 1
    Text = '{        -    -    -    -            }'
  end
end
