object fraInstall: TfraInstall
  Left = 0
  Top = 0
  Width = 540
  Height = 256
  HelpContext = 63
  TabOrder = 0
  object lblTitle: TLabel
    Left = 8
    Top = 6
    Width = 157
    Height = 20
    Caption = 'Install <APPTITLE>'
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
    Width = 382
    Height = 13
    Caption = 
      'This CD allows you to <TYPE> <APPTITLE>, the following options a' +
      're available:-'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label6: TLabel
    Left = 47
    Top = 71
    Width = 455
    Height = 29
    AutoSize = False
    Caption = 
      'This option connects to the IRIS Licensing Server on the Interne' +
      't to get your licence, please enter your CD-Key in the field bel' +
      'ow as this is used to identify your details.'
    WordWrap = True
    OnClick = DownloadClick
  end
  object lblBackToOptions: TLabel
    Left = 9
    Top = 207
    Width = 25
    Height = 13
    Cursor = crHandPoint
    Caption = 'Back'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    OnClick = lblBackToOptionsClick
  end
  object lblCDKey: TLabel
    Left = 47
    Top = 107
    Width = 51
    Height = 16
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'CD-Key'
    Transparent = True
    WordWrap = True
    OnClick = DownloadClick
  end
  object Label2: TLabel
    Left = 47
    Top = 177
    Width = 455
    Height = 18
    AutoSize = False
    Caption = 
      'This option allows you to manually enter licence details which h' +
      'ave been supplied to you.'
    WordWrap = True
    OnClick = ManualClick
  end
  object lblContinue: TLabel
    Left = 458
    Top = 207
    Width = 42
    Height = 13
    Cursor = crHandPoint
    Alignment = taRightJustify
    Caption = 'Continue'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    OnClick = lblContinueClick
  end
  object Label1: TLabel
    Left = 47
    Top = 132
    Width = 455
    Height = 19
    AutoSize = False
    Caption = 
      'NOTE: This requires an active internet connection on this comput' +
      'er.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    WordWrap = True
    OnClick = DownloadClick
  end
  object radDownload: TRadioButton
    Left = 28
    Top = 52
    Width = 348
    Height = 17
    Caption = 'Download your licence from the IRIS website'
    Checked = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    TabStop = True
    OnClick = DoCheckyChecky
  end
  object radManual: TRadioButton
    Left = 28
    Top = 158
    Width = 303
    Height = 17
    Caption = 'Enter the licence details manually'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    OnClick = DoCheckyChecky
  end
  object edtCDKey: TMaskEdit
    Left = 103
    Top = 104
    Width = 226
    Height = 21
    EditMask = '>AAAA-AAAA-AAAA-AAAA-AAAA-AAAA;1;_'
    MaxLength = 29
    TabOrder = 2
    Text = '    -    -    -    -    -    '
  end
end
