object fraCheckList: TfraCheckList
  Left = 0
  Top = 0
  Width = 540
  Height = 256
  HelpContext = 1
  TabOrder = 0
  object Label4: TLabel
    Left = 9
    Top = 209
    Width = 505
    Height = 32
    AutoSize = False
    Caption = 
      'PLEASE CALL 0870 428 1330 IF YOU HAVE ANY CONCERNS REGARDING THI' +
      'S INSTALLATION'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
    WordWrap = True
  end
  object lblIntro: TLabel
    Left = 24
    Top = 36
    Width = 457
    Height = 30
    AutoSize = False
    Caption = 
      'IRIS Accounts Office Support will be pleased to assist if you ar' +
      'e at all concerned with performing the following steps prior to ' +
      'the installation of IRIS Accounts Office:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    Transparent = True
    WordWrap = True
  end
  object lblOKLink: TLabel
    Left = 419
    Top = 241
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
    OnClick = lblOKLinkClick
  end
  object lblCancelLink: TLabel
    Left = 481
    Top = 241
    Width = 26
    Height = 13
    Cursor = crHandPoint
    Alignment = taRightJustify
    Caption = 'Close'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    OnClick = lblCancelLinkClick
  end
  object Label2: TLabel
    Left = 9
    Top = 72
    Width = 421
    Height = 14
    AutoSize = False
    Caption = 'Installing IRIS Accounts Office on a Network'
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
    Left = 24
    Top = 169
    Width = 451
    Height = 35
    AutoSize = False
    Caption = 
      'prerequisites.  Some Antivirus applications can interrupt the in' +
      'stallation and licensing process.  Please contact us if you need' +
      ' any assistance with closing any active programs.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    Transparent = True
    WordWrap = True
    OnClick = Label3Click
  end
  object Label1: TLabel
    Left = 9
    Top = 137
    Width = 113
    Height = 14
    AutoSize = False
    Caption = 'All Installations'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
    WordWrap = True
  end
  object lblTitle: TLabel
    Left = 9
    Top = 4
    Width = 456
    Height = 26
    Caption = 
      'PLEASE CALL 0870 428 1330 IF YOU REQUIRE ANY ASSISTANCE WITH THE' +
      ' INSTALLATION OF IRIS ACCOUNTS OFFICE'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
    WordWrap = True
  end
  object Label5: TLabel
    Left = 24
    Top = 92
    Width = 446
    Height = 13
    Caption = 
      'Creating a shared folder for a networked installation and applyi' +
      'ng user permissions to the folder.'
  end
  object Label6: TLabel
    Left = 24
    Top = 116
    Width = 335
    Height = 13
    Caption = 
      'Applying a mapped drive to the shared folder for networked insta' +
      'llations'
  end
  object Label7: TLabel
    Left = 24
    Top = 156
    Width = 429
    Height = 13
    Caption = 
      'All programs should be closed before attempting to install IRIS ' +
      'Accounts Office or any of its '
  end
end
