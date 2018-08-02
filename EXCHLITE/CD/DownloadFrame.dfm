object fraDownload: TfraDownload
  Left = 0
  Top = 0
  Width = 540
  Height = 256
  TabOrder = 0
  object lblTitle: TLabel
    Left = 8
    Top = 6
    Width = 278
    Height = 20
    Caption = 'Downloading <APPTITLE> Licence'
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
    Width = 494
    Height = 43
    AutoSize = False
    Caption = 
      'This application is now attempting to connect to the IRIS Licens' +
      'ing Server on the Internet to download your licence.  This may t' +
      'ake a few seconds depending on the speed of your Internet connec' +
      'tion and how busy the IRIS Licensing Server is.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object lblContinue: TLabel
    Left = 458
    Top = 104
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
  object lblInfo: TLabel
    Left = 29
    Top = 79
    Width = 267
    Height = 13
    Caption = 'Connecting to Licensing Server, Please Wait...'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
  end
  object lblRetryDownload: TLabel
    Left = 9
    Top = 104
    Width = 25
    Height = 13
    Cursor = crHandPoint
    Caption = 'Retry'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    OnClick = lblRetryDownloadClick
  end
end
