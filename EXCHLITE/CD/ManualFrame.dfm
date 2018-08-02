object fraManual: TfraManual
  Left = 0
  Top = 0
  Width = 540
  Height = 256
  TabOrder = 0
  object lblTitle: TLabel
    Left = 8
    Top = 6
    Width = 173
    Height = 20
    Caption = 'Manual Licence Entry'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblIntro: TLabel
    Left = 9
    Top = 27
    Width = 76
    Height = 13
    Caption = 'Blah blah, blah:-'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object lblInstall: TLabel
    Left = 467
    Top = 235
    Width = 41
    Height = 13
    Cursor = crHandPoint
    Alignment = taRightJustify
    Caption = 'Upgrade'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    OnClick = lblInstallClick
  end
  object Label1: TLabel
    Left = 223
    Top = 159
    Width = 27
    Height = 13
    Caption = 'Users'
  end
  object Label2: TLabel
    Left = 312
    Top = 159
    Width = 52
    Height = 13
    Caption = 'Companies'
  end
  object Label3: TLabel
    Left = 70
    Top = 160
    Width = 35
    Height = 13
    Alignment = taRightJustify
    Caption = 'Version'
  end
  object Label4: TLabel
    Left = 69
    Top = 85
    Width = 36
    Height = 13
    Alignment = taRightJustify
    Caption = 'Country'
  end
  object Label5: TLabel
    Left = 80
    Top = 110
    Width = 24
    Height = 13
    Alignment = taRightJustify
    Caption = 'Type'
  end
  object Label6: TLabel
    Left = 17
    Top = 183
    Width = 88
    Height = 13
    Alignment = taRightJustify
    Caption = 'WGE Licence Key'
  end
  object Label7: TLabel
    Left = 252
    Top = 10
    Width = 258
    Height = 26
    Alignment = taCenter
    Caption = 
      'Temporary contents pending delivery of IRIS Licencing components' +
      ' (Late Nov?)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
  end
  object Label8: TLabel
    Left = 30
    Top = 134
    Width = 75
    Height = 13
    Alignment = taRightJustify
    Caption = 'Company Name'
  end
  object lblCDKey: TLabel
    Left = 55
    Top = 59
    Width = 50
    Height = 16
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'CD-Key'
    Transparent = True
    WordWrap = True
  end
  object lblCDKeyExample: TLabel
    Left = 317
    Top = 59
    Width = 210
    Height = 16
    AutoSize = False
    Caption = 'e.g. A1E25-LJ89X-TBCLJ-FGHJK-2MR8Q'
    Transparent = True
    WordWrap = True
  end
  object cmbSystemType: TComboBox
    Left = 112
    Top = 106
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    ItemIndex = 0
    TabOrder = 2
    Text = 'Customer'
    Items.Strings = (
      'Customer'
      'Accountant')
  end
  object cmbCountry: TComboBox
    Left = 112
    Top = 81
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    ItemIndex = 0
    TabOrder = 1
    Text = 'UK'
    Items.Strings = (
      'UK'
      'New Zealand'
      'Singapore'
      'Australia'
      'EIRE'
      'South Africa')
  end
  object cmbVersion: TComboBox
    Left = 112
    Top = 156
    Width = 100
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 4
    Items.Strings = (
      'SC-Core'
      'SC-Stock'
      'SC-SPOP'
      'MC-Core'
      'MC-Stock'
      'MC-SPOP')
  end
  object edtUserCount: TEdit
    Left = 258
    Top = 156
    Width = 29
    Height = 21
    TabOrder = 5
    Text = '1'
  end
  object udUsers: TUpDown
    Left = 287
    Top = 156
    Width = 15
    Height = 21
    Associate = edtUserCount
    Min = 1
    Max = 3
    Position = 1
    TabOrder = 6
    Wrap = False
  end
  object edtCompanyCount: TEdit
    Left = 371
    Top = 156
    Width = 29
    Height = 21
    TabOrder = 7
    Text = '3'
  end
  object udCompanies: TUpDown
    Left = 400
    Top = 156
    Width = 15
    Height = 21
    Associate = edtCompanyCount
    Min = 1
    Max = 99
    Position = 3
    TabOrder = 8
    Wrap = False
  end
  object edtWGEKey: TEdit
    Left = 112
    Top = 180
    Width = 183
    Height = 21
    CharCase = ecUpperCase
    MaxLength = 25
    TabOrder = 9
    Text = 'GJZ7CZ7YXVKX295JTTFA729K'
  end
  object edtCompanyName: TEdit
    Left = 112
    Top = 131
    Width = 183
    Height = 21
    MaxLength = 45
    TabOrder = 3
    Text = 'Arbuthnot Brothers Ltd'
  end
  object edtCDKey: TMaskEdit
    Left = 112
    Top = 56
    Width = 194
    Height = 21
    EditMask = '>AAAAA-AAAAA-AAAAA-AAAAA-AAAAA;1;_'
    MaxLength = 29
    TabOrder = 0
    Text = '     -     -     -     -     '
  end
  object PopupMenu1: TPopupMenu
    AutoHotkeys = maManual
    Left = 490
    Top = 111
  end
end
