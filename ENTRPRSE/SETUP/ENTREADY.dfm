inherited frmEntReady: TfrmEntReady
  Left = 335
  Top = 175
  HelpContext = 32
  ActiveControl = nil
  Caption = 'Exchequer Setup Program'
  ClientHeight = 277
  ClientWidth = 586
  Font.Charset = ANSI_CHARSET
  Font.Name = 'Arial'
  PixelsPerInch = 96
  TextHeight = 14
  inherited InstrLbl: TLabel [0]
    Left = 193
    Width = 100
    Height = 19
    Caption = ''
  end
  inherited Bevel1: TBevel [1]
    Top = 237
    Width = 563
    Height = 6
  end
  inherited TitleLbl: TLabel [2]
    Width = 411
    Caption = 'Ready To '
  end
  inherited imgSide: TImage
    Height = 121
  end
  inherited HelpBtn: TButton
    Top = 249
  end
  inherited Panel1: TPanel
    Height = 215
    inherited Image1: TImage
      Height = 213
    end
  end
  inherited ExitBtn: TButton
    Top = 249
  end
  inherited BackBtn: TButton
    Left = 409
    Top = 249
  end
  inherited NextBtn: TButton
    Left = 495
    Top = 249
    Caption = '&Install'
  end
  object ScrollBox1: TScrollBox
    Left = 169
    Top = 43
    Width = 407
    Height = 185
    HorzScrollBar.Visible = False
    VertScrollBar.Position = 176
    Anchors = [akLeft, akTop, akRight, akBottom]
    BorderStyle = bsNone
    Color = clBtnFace
    Ctl3D = False
    ParentColor = False
    ParentCtl3D = False
    TabOrder = 5
    object panUpgrade: TPanel
      Left = 2
      Top = -54
      Width = 380
      Height = 33
      BevelOuter = bvNone
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 0
      object Label84: Label8
        Left = 10
        Top = 3
        Width = 60
        Height = 14
        Caption = 'Upgrade Dir:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label86: Label8
        Left = 10
        Top = 18
        Width = 41
        Height = 14
        Caption = 'Version:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object lblUpgDir: Label8
        Left = 108
        Top = 3
        Width = 270
        Height = 14
        AutoSize = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object lblUpgEntVer: Label8
        Left = 108
        Top = 18
        Width = 270
        Height = 14
        AutoSize = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
    end
    object panCompany: TPanel
      Left = 2
      Top = -19
      Width = 380
      Height = 49
      BevelOuter = bvNone
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 2
      object Label87: Label8
        Left = 10
        Top = 3
        Width = 73
        Height = 14
        Caption = 'Main Company:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label88: Label8
        Left = 10
        Top = 18
        Width = 74
        Height = 14
        Caption = 'New Company:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label89: Label8
        Left = 10
        Top = 33
        Width = 75
        Height = 14
        Caption = 'Company Type:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object lblCompMainDir: Label8
        Left = 108
        Top = 3
        Width = 270
        Height = 14
        AutoSize = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object lblCompInstDir: Label8
        Left = 108
        Top = 18
        Width = 270
        Height = 14
        AutoSize = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object lblCompCompType: Label8
        Left = 108
        Top = 33
        Width = 270
        Height = 14
        AutoSize = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
    end
    object panWarnTitle: TPanel
      Left = 2
      Top = 31
      Width = 380
      Height = 55
      BevelOuter = bvNone
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 1
      object Label810: Label8
        Left = 3
        Top = 6
        Width = 374
        Height = 48
        AutoSize = False
        Caption = 
          'Setup has generated the following warnings for you to check befo' +
          're proceeding. Each warning must be acknowledged by ticking the ' +
          'box before the setup can be completed.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        WordWrap = True
        TextId = 0
      end
    end
    object panUsers: TPanel
      Left = 2
      Top = 240
      Width = 380
      Height = 51
      BevelOuter = bvNone
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 3
      OnClick = panUsersClick
      object Label813: Label8
        Left = 26
        Top = 21
        Width = 350
        Height = 31
        AutoSize = False
        Caption = 
          'If other users are running <APPTITLE> or any of its utility prog' +
          'rams this may cause the Setup to fail partially or totally.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        WordWrap = True
        OnClick = panUsersClick
        TextId = 0
      end
      object chkUsers: TBorCheck
        Left = 6
        Top = 1
        Width = 370
        Height = 20
        Align = alRight
        Caption = 'No other users are running <APPTITLE>'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsUnderline]
        ParentColor = False
        ParentFont = False
        TabOrder = 0
        TextId = 0
        OnClick = DoCheckyChecky
      end
    end
    object panInstall: TPanel
      Left = 2
      Top = -158
      Width = 380
      Height = 47
      BevelOuter = bvNone
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 4
      object Label81: Label8
        Left = 10
        Top = 3
        Width = 45
        Height = 14
        Caption = 'Install To:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label82: Label8
        Left = 10
        Top = 18
        Width = 75
        Height = 14
        Caption = 'Company Type:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label83: Label8
        Left = 10
        Top = 33
        Width = 41
        Height = 14
        Caption = 'Version:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object lblInstDir: Label8
        Left = 108
        Top = 3
        Width = 270
        Height = 14
        AutoSize = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object lblInstCompType: Label8
        Left = 108
        Top = 18
        Width = 270
        Height = 14
        AutoSize = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object lblInstEntVer: Label8
        Left = 108
        Top = 33
        Width = 270
        Height = 14
        AutoSize = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
    end
    object panTitle: TPanel
      Left = 2
      Top = -175
      Width = 268
      Height = 19
      BevelOuter = bvNone
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 5
      object Label85: Label8
        Left = 3
        Top = 3
        Width = 79
        Height = 14
        Caption = 'Setup Summary:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
    end
    object panBackup: TPanel
      Left = 2
      Top = 83
      Width = 380
      Height = 65
      BevelOuter = bvNone
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 6
      OnClick = panBackupClick
      object Label811: Label8
        Left = 26
        Top = 21
        Width = 350
        Height = 44
        AutoSize = False
        Caption = 
          'A Full Backup of programs and data must have been done before co' +
          'mpleting this setup. If problems occur during the setup, you wil' +
          'l probably be advised to restore your backup.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        WordWrap = True
        OnClick = panBackupClick
        TextId = 0
      end
      object chkBackup: TBorCheck
        Left = 6
        Top = 1
        Width = 370
        Height = 20
        Align = alRight
        Caption = 'Precautionary Backup Taken'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsUnderline]
        ParentColor = False
        ParentFont = False
        TabOrder = 0
        TextId = 0
        OnClick = DoCheckyChecky
      end
    end
    object panOverwrite: TPanel
      Left = 2
      Top = 150
      Width = 380
      Height = 85
      BevelOuter = bvNone
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 7
      OnClick = panOverwriteClick
      object Label812: Label8
        Left = 26
        Top = 21
        Width = 350
        Height = 17
        AutoSize = False
        Caption = 'This setup is about to overwrite an existing system in:-'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        WordWrap = True
        OnClick = panOverwriteClick
        TextId = 0
      end
      object lvlOverWriteDir: Label8
        Left = 39
        Top = 38
        Width = 227
        Height = 15
        AutoSize = False
        Caption = '-- directory --'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        OnClick = panOverwriteClick
        TextId = 0
      end
      object Label815: Label8
        Left = 25
        Top = 56
        Width = 350
        Height = 31
        AutoSize = False
        Caption = 
          'We recommend a precautionary backup is done before continuing to' +
          ' prevent accidental data loss.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        WordWrap = True
        OnClick = panOverwriteClick
        TextId = 0
      end
      object chkOverwrite: TBorCheck
        Left = 6
        Top = 1
        Width = 370
        Height = 20
        Align = alRight
        Caption = 'Overwrite an existing system'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsUnderline]
        ParentColor = False
        ParentFont = False
        TabOrder = 0
        TextId = 0
        OnClick = DoCheckyChecky
      end
    end
    object panDowngrade: TPanel
      Left = 2
      Top = 294
      Width = 380
      Height = 54
      BevelOuter = bvNone
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 8
      OnClick = panDowngradeClick
      object Label814: Label8
        Left = 26
        Top = 21
        Width = 350
        Height = 45
        AutoSize = False
        Caption = 
          'This upgrade will downgrade components to the level specified in' +
          ' the Licence.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        WordWrap = True
        OnClick = panDowngradeClick
        TextId = 0
      end
      object chkDowngrade: TBorCheck
        Left = 6
        Top = 1
        Width = 370
        Height = 20
        Align = alRight
        Caption = 'Downgrade Components'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsUnderline]
        ParentColor = False
        ParentFont = False
        TabOrder = 0
        TextId = 0
        OnClick = DoCheckyChecky
      end
    end
    object panWGEServer: TPanel
      Left = 3
      Top = 349
      Width = 380
      Height = 52
      BevelOuter = bvNone
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 9
      object Label817: Label8
        Left = 26
        Top = 21
        Width = 350
        Height = 29
        AutoSize = False
        Caption = 
          'This upgrade will setup the system to use the current workstatio' +
          'n as the Workgroup Server.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        WordWrap = True
        TextId = 0
      end
      object chkWGEServer: TBorCheck
        Left = 6
        Top = 1
        Width = 370
        Height = 20
        Align = alRight
        Caption = 'Change Workgroup Server'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsUnderline]
        ParentColor = False
        ParentFont = False
        TabOrder = 0
        TextId = 0
        OnClick = DoCheckyChecky
      end
    end
    object panSQLDBServer: TPanel
      Left = 2
      Top = -111
      Width = 380
      Height = 18
      BevelOuter = bvNone
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 10
      object Label816: Label8
        Left = 10
        Top = 1
        Width = 49
        Height = 14
        Caption = 'Database:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object lblSQLDatabaseServer: Label8
        Left = 108
        Top = 1
        Width = 270
        Height = 14
        AutoSize = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
    end
  end
end
