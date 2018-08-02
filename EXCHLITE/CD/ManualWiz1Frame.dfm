object fraManualWiz1: TfraManualWiz1
  Left = 0
  Top = 0
  Width = 540
  Height = 256
  HelpContext = 51
  TabOrder = 0
  object lblTitle: TLabel
    Left = 8
    Top = 6
    Width = 303
    Height = 20
    Caption = 'Manual Licence Entry - Codes (1 of 3)'
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
  object lblCDKey: TLabel
    Left = 28
    Top = 48
    Width = 50
    Height = 16
    AutoSize = False
    Caption = 'CD-Key'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
    WordWrap = True
  end
  object Label6: TLabel
    Left = 28
    Top = 63
    Width = 455
    Height = 19
    AutoSize = False
    Caption = 
      'A CD-Key in the format '#39'xxxx-xxxx-xxxx-xxxx-xxxx-xxxx'#39' will have' +
      ' been supplied with your CD:-'
    WordWrap = True
  end
  object Label2: TLabel
    Left = 28
    Top = 112
    Width = 93
    Height = 16
    AutoSize = False
    Caption = 'Licence Code'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
    WordWrap = True
  end
  object Label3: TLabel
    Left = 28
    Top = 127
    Width = 455
    Height = 19
    AutoSize = False
    Caption = 
      'An alphanumeric licence code will have been supplied with the CD' +
      '-Key:-'
    WordWrap = True
  end
  object meCDKey: TMaskEdit
    Left = 44
    Top = 82
    Width = 226
    Height = 21
    EditMask = '>AAAA-AAAA-AAAA-AAAA-AAAA-AAAA;1;_'
    MaxLength = 29
    TabOrder = 0
    Text = '    -    -    -    -    -    '
  end
  object edtLicenceCode: TEdit
    Left = 44
    Top = 146
    Width = 151
    Height = 21
    CharCase = ecUpperCase
    MaxLength = 45
    TabOrder = 1
  end
end
