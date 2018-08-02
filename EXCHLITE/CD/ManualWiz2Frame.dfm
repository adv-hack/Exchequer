object fraManualWiz2: TfraManualWiz2
  Left = 0
  Top = 0
  Width = 540
  Height = 256
  HelpContext = 52
  TabOrder = 0
  object lblTitle: TLabel
    Left = 8
    Top = 6
    Width = 504
    Height = 20
    Caption = 'Manual Licence Entry - Company Name && Licence Type (2 of 3)'
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
    Width = 500
    Height = 21
    AutoSize = False
    Caption = 'Please enter the following details.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object lblCDKey: TLabel
    Left = 28
    Top = 48
    Width = 88
    Height = 13
    Caption = 'Company Name'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object lblCompDesc: TLabel
    Left = 28
    Top = 63
    Width = 455
    Height = 19
    AutoSize = False
    Caption = 'The Company Name that <APPTITLE> has been sold to:-'
    WordWrap = True
  end
  object lblTypeTitle: TLabel
    Left = 28
    Top = 112
    Width = 155
    Height = 13
    Caption = '<APPTITLE> Licence Type'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object Label3: TLabel
    Left = 28
    Top = 127
    Width = 455
    Height = 19
    AutoSize = False
    Caption = 'Please specify the version you have purchased:-'
    WordWrap = True
  end
  object lblNext: TLabel
    Left = 471
    Top = 225
    Width = 37
    Height = 13
    Cursor = crHandPoint
    Alignment = taRightJustify
    Caption = 'Next >>'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    OnClick = lblNextClick
  end
  object lblBack: TLabel
    Left = 9
    Top = 225
    Width = 40
    Height = 13
    Cursor = crHandPoint
    Caption = '<< Back'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    OnClick = lblBackClick
  end
  object Label2: TLabel
    Left = 164
    Top = 147
    Width = 98
    Height = 19
    AutoSize = False
    Caption = 'Type'
    WordWrap = True
  end
  object Label4: TLabel
    Left = 46
    Top = 147
    Width = 99
    Height = 19
    AutoSize = False
    Caption = 'Country'
    WordWrap = True
  end
  object Label1: TLabel
    Left = 271
    Top = 147
    Width = 98
    Height = 19
    AutoSize = False
    Caption = 'Edition'
    WordWrap = True
  end
  object lstCountry: TComboBox
    Left = 45
    Top = 162
    Width = 113
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 1
  end
  object lstLITEType: TComboBox
    Left = 163
    Top = 162
    Width = 102
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 2
    Items.Strings = (
      'Standard'
      'Practice')
  end
  object edtCompanyName: TEdit
    Left = 44
    Top = 81
    Width = 274
    Height = 21
    MaxLength = 45
    TabOrder = 0
  end
  object lstLITEEdition: TComboBox
    Left = 270
    Top = 162
    Width = 102
    Height = 21
    Style = csDropDownList
    Enabled = False
    ItemHeight = 13
    ItemIndex = 0
    TabOrder = 3
    Text = 'Standard'
    Items.Strings = (
      'Standard')
  end
end
