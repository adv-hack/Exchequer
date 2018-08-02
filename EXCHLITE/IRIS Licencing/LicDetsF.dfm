object frmLicenceDetails: TfrmLicenceDetails
  Left = 346
  Top = 202
  BorderStyle = bsDialog
  Caption = 'Enter Licence Details'
  ClientHeight = 244
  ClientWidth = 392
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 0
    Top = 7
    Width = 98
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Country'
  end
  object Label2: TLabel
    Left = 0
    Top = 31
    Width = 98
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Type'
  end
  object Label3: TLabel
    Left = 0
    Top = 116
    Width = 98
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'User Count'
  end
  object Label4: TLabel
    Left = 0
    Top = 140
    Width = 98
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Company Count'
  end
  object Label5: TLabel
    Left = 0
    Top = 169
    Width = 98
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'P.SQL WGE Key'
  end
  object Label7: TLabel
    Left = 0
    Top = 57
    Width = 98
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Edition/Theme'
  end
  object Label8: TLabel
    Left = 0
    Top = 86
    Width = 98
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Company Name'
  end
  object lstCountry: TComboBox
    Left = 102
    Top = 4
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    ItemIndex = 0
    TabOrder = 0
    Text = 'UK'
    Items.Strings = (
      'UK')
  end
  object lstType: TComboBox
    Left = 102
    Top = 28
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    ItemIndex = 0
    TabOrder = 1
    Text = 'Customer'
    Items.Strings = (
      'Customer'
      'Accountant')
  end
  object edtUserCount: TEdit
    Left = 102
    Top = 112
    Width = 46
    Height = 21
    TabOrder = 5
    Text = '45'
  end
  object udUserCount: TUpDown
    Left = 148
    Top = 112
    Width = 12
    Height = 21
    Associate = edtUserCount
    Min = 1
    Position = 45
    TabOrder = 6
    Wrap = False
  end
  object edtCompanyCount: TEdit
    Left = 102
    Top = 136
    Width = 46
    Height = 21
    TabOrder = 7
    Text = '678'
  end
  object udCompanyCount: TUpDown
    Left = 148
    Top = 136
    Width = 12
    Height = 21
    Associate = edtCompanyCount
    Min = 1
    Max = 999
    Position = 678
    TabOrder = 8
    Wrap = False
  end
  object edtPervasiveKey: TEdit
    Left = 102
    Top = 165
    Width = 281
    Height = 21
    TabOrder = 9
    Text = 'AHSH7-AHDH4-73735-ASH56-TYSHJ'
  end
  object btnOK: TButton
    Left = 112
    Top = 219
    Width = 80
    Height = 21
    Caption = '&OK'
    TabOrder = 10
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 200
    Top = 219
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 11
  end
  object edtTheme: TEdit
    Left = 102
    Top = 53
    Width = 46
    Height = 21
    TabOrder = 2
    Text = '1'
  end
  object udTheme: TUpDown
    Left = 148
    Top = 53
    Width = 12
    Height = 21
    Associate = edtTheme
    Min = 1
    Max = 3
    Position = 1
    TabOrder = 3
    Wrap = False
  end
  object edtCompanyName: TEdit
    Left = 102
    Top = 82
    Width = 281
    Height = 21
    TabOrder = 4
    Text = 'Arbuthnot Lapdancing Ltd'
  end
end
