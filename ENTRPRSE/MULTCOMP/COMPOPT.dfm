object frmCompOpt: TfrmCompOpt
  Left = 617
  Top = 226
  HelpContext = 23
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Multi-Company Manager Options'
  ClientHeight = 243
  ClientWidth = 420
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  Position = poOwnerFormCenter
  Scaled = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 14
  object SaveBtn: TButton
    Left = 251
    Top = 215
    Width = 78
    Height = 21
    HelpContext = 155
    Caption = '&Save'
    TabOrder = 1
    OnClick = SaveBtnClick
  end
  object CancelBtn: TButton
    Left = 334
    Top = 215
    Width = 78
    Height = 21
    HelpContext = 155
    Cancel = True
    Caption = '&Cancel'
    TabOrder = 2
    OnClick = CancelBtnClick
  end
  object PageControl1: TPageControl
    Left = 5
    Top = 3
    Width = 410
    Height = 205
    ActivePage = TabSheet1
    TabIndex = 0
    TabOrder = 0
    object TabSheet1: TTabSheet
      HelpContext = 23
      Caption = 'Backup / Restore'
      object SBSBackGroup2: TSBSBackGroup
        Left = 3
        Top = -2
        Width = 395
        Height = 173
        HelpContext = 23
        TextId = 0
      end
      object Label82: Label8
        Left = 17
        Top = 117
        Width = 36
        Height = 16
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Backup'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label83: Label8
        Left = 15
        Top = 144
        Width = 38
        Height = 14
        Caption = 'Restore'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label81: Label8
        Left = 12
        Top = 10
        Width = 381
        Height = 34
        AutoSize = False
        Caption = 
          'Specify below the commands needed to run your backup and restore' +
          ' utilities. The following macros can be placed in the command li' +
          'nes:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        WordWrap = True
        TextId = 0
      end
      object Label810: Label8
        Left = 22
        Top = 43
        Width = 55
        Height = 14
        AutoSize = False
        Caption = '%DRIVE%'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label811: Label8
        Left = 22
        Top = 59
        Width = 54
        Height = 14
        AutoSize = False
        Caption = '%PATH%'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label812: Label8
        Left = 85
        Top = 43
        Width = 302
        Height = 14
        AutoSize = False
        Caption = 'The Drive of the company. e.g. C:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label813: Label8
        Left = 85
        Top = 59
        Width = 305
        Height = 14
        AutoSize = False
        Caption = 'The full path less the drive. e.g. \ACCOUNTS\COMP01'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label814: Label8
        Left = 22
        Top = 75
        Width = 36
        Height = 14
        AutoSize = False
        Caption = '%DIR%'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label815: Label8
        Left = 85
        Top = 75
        Width = 304
        Height = 14
        AutoSize = False
        Caption = 'The full drive and path. e.g. C:\ACCOUNTS\COMP01\'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label822: Label8
        Left = 22
        Top = 91
        Width = 55
        Height = 14
        AutoSize = False
        Caption = '%CODE%'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label825: Label8
        Left = 85
        Top = 91
        Width = 304
        Height = 14
        AutoSize = False
        Caption = 'The Company Code, e.g. ZZZZ01'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object coBackup: Text8Pt
        Tag = 1
        Left = 57
        Top = 114
        Width = 333
        Height = 22
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 200
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        TextId = 0
        ViaSBtn = False
      end
      object coRestore: Text8Pt
        Left = 57
        Top = 140
        Width = 333
        Height = 22
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 200
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        TextId = 0
        ViaSBtn = False
      end
    end
    object Configuration: TTabSheet
      HelpContext = 25
      Caption = 'Configuration'
      object SBSBackGroup4: TSBSBackGroup
        Left = 3
        Top = -2
        Width = 395
        Height = 98
        Caption = 'System Set-Up'
        TextId = 0
      end
      object chkHidePath: TBorCheck
        Left = 12
        Top = 12
        Width = 376
        Height = 20
        Align = alRight
        Caption = 'Hide Company Paths if no password entered    (Standard MCM Only)'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 0
        TextId = 0
      end
      object chkHideBackup: TBorCheck
        Left = 12
        Top = 31
        Width = 376
        Height = 20
        Align = alRight
        Caption = 'Hide Backup Option if no password entered'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 1
        TextId = 0
      end
      object chkHideUsers: TBorCheck
        Left = 11
        Top = 50
        Width = 376
        Height = 20
        Align = alRight
        Caption = 'Hide Logged In User Report if no password entered'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 2
        TextId = 0
      end
      object chkShowViewCompany: TBorCheck
        Left = 12
        Top = 69
        Width = 376
        Height = 20
        Align = alRight
        Caption = 'Show View Company if no password entered'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 3
        TextId = 0
      end
    end
    object TabSheet2: TTabSheet
      HelpContext = 27
      Caption = 'Password'
      object SBSBackGroup5: TSBSBackGroup
        Left = 3
        Top = -2
        Width = 395
        Height = 150
        TextId = 0
      end
      object Label84: Label8
        Left = 12
        Top = 10
        Width = 373
        Height = 16
        AutoSize = False
        Caption = 
          'A password can be specified to limit access to the following fun' +
          'ctions:-'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        WordWrap = True
        TextId = 0
      end
      object Label85: Label8
        Left = 22
        Top = 28
        Width = 120
        Height = 14
        Caption = 'Attach Existing Company'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label86: Label8
        Left = 22
        Top = 46
        Width = 100
        Height = 14
        Caption = 'Edit Company Details'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label87: Label8
        Left = 22
        Top = 64
        Width = 127
        Height = 14
        Caption = 'Detach Selected Company'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label89: Label8
        Left = 164
        Top = 28
        Width = 109
        Height = 14
        Caption = 'View Company Details'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label88: Label8
        Left = 164
        Top = 46
        Width = 77
        Height = 14
        Caption = 'Backup/Restore'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label817: Label8
        Left = 12
        Top = 86
        Width = 373
        Height = 29
        AutoSize = False
        Caption = 
          'Click the Change &Password button below to set a new password or' +
          ' to change an existing password.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        WordWrap = True
        TextId = 0
      end
      object Label816: Label8
        Left = 164
        Top = 64
        Width = 35
        Height = 14
        Caption = 'Rebuild'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label821: Label8
        Left = 295
        Top = 28
        Width = 37
        Height = 14
        Caption = 'Options'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object ChngPWordBtn: TButton
        Left = 74
        Top = 119
        Width = 255
        Height = 21
        Caption = 'Change &Password'
        TabOrder = 0
        OnClick = ChngPWordBtnClick
      end
    end
    object TabSheet3: TTabSheet
      HelpContext = 26
      Caption = 'Exchequer DOS'
      TabVisible = False
      object SBSBackGroup1: TSBSBackGroup
        Left = 3
        Top = -3
        Width = 395
        Height = 96
        TextId = 0
      end
      object Label818: Label8
        Left = 12
        Top = 10
        Width = 378
        Height = 45
        AutoSize = False
        Caption = 
          'Specify below the name of the Batch Files to be used to run Exch' +
          'equer for DOS from the Exchqr DOS button on the Company List. If' +
          ' left blank REX will be assumed.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        WordWrap = True
        TextId = 0
      end
      object Label823: Label8
        Left = 12
        Top = 64
        Width = 115
        Height = 16
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'In Windows 95/98, run'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label824: Label8
        Left = 219
        Top = 64
        Width = 94
        Height = 14
        Alignment = taRightJustify
        Caption = 'In Windows NT, run'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object SBSBackGroup3: TSBSBackGroup
        Left = 3
        Top = 94
        Width = 395
        Height = 41
        TextId = 0
      end
      object edtWin95: Text8Pt
        Tag = 1
        Left = 132
        Top = 60
        Width = 70
        Height = 22
        CharCase = ecUpperCase
        Color = clAqua
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 8
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        TextId = 0
        ViaSBtn = False
      end
      object edtwinNT: Text8Pt
        Left = 318
        Top = 60
        Width = 70
        Height = 22
        CharCase = ecUpperCase
        Color = clAqua
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 8
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        TextId = 0
        ViaSBtn = False
      end
      object chkShowExch: TBorCheck
        Left = 12
        Top = 107
        Width = 376
        Height = 20
        Align = alRight
        Caption = 'Show Exchequer for DOS options in Multi-Company Manager'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 2
        TextId = 0
      end
    end
    object tabshBureau: TTabSheet
      HelpContext = 26
      Caption = 'Bureau Mode'
      ImageIndex = 4
      object SBSBackGroup6: TSBSBackGroup
        Left = 3
        Top = -2
        Width = 395
        Height = 156
        TextId = 0
      end
      object Label819: Label8
        Left = 12
        Top = 10
        Width = 378
        Height = 46
        AutoSize = False
        Caption = 
          'Running the Multi-Company Manager in Bureau Mode means that user' +
          's have to log into the Multi-Company Manager, and will see a fil' +
          'tered list of Companies which is linked to that Login.  See the ' +
          'online help for more inforrmation.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        WordWrap = True
        TextId = 0
      end
      object Label820: Label8
        Left = 12
        Top = 79
        Width = 378
        Height = 41
        AutoSize = False
        Caption = 
          'A password for the Bureau Administrator must also be defined, lo' +
          'gging in with the ADMIN user id and this password will allow you' +
          ' to setup the users and company lists.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        WordWrap = True
        TextId = 0
      end
      object chkBureauMode: TBorCheck
        Left = 21
        Top = 55
        Width = 369
        Height = 22
        Align = alRight
        Caption = 'Use the Multi-Company Manager in Bureau Mode'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 0
        TextId = 0
      end
      object btnChangeBureauPW: TButton
        Left = 74
        Top = 125
        Width = 255
        Height = 21
        Caption = 'Change Bureau Admin &Password'
        TabOrder = 1
        OnClick = btnChangeBureauPWClick
      end
    end
  end
  object PopupMenu1: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 203
    Top = 211
    object PropFlg: TMenuItem
      Caption = '&Properties'
      Hint = 'Access Colour & Font settings'
      OnClick = PropFlgClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object StoreCoordFlg: TMenuItem
      Caption = '&Save Coordinates'
      Hint = 'Make the current window settings permanent'
      OnClick = StoreCoordFlgClick
    end
  end
end
