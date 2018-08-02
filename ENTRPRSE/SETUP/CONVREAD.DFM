inherited frmReady: TfrmReady
  Left = 278
  Top = 215
  Caption = 'frmReady'
  ClientHeight = 323
  PixelsPerInch = 96
  TextHeight = 13
  inherited Bevel1: TBevel
    Top = 279
  end
  inherited TitleLbl: TLabel
    Caption = 'Ready To Convert'
  end
  inherited InstrLbl: TLabel
    Left = 169
    Caption = 
      'Please check the following details on this dialog before continu' +
      'ing with the conversion:-'
  end
  object Label83: Label8 [3]
    Left = 169
    Top = 82
    Width = 82
    Height = 14
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Convert Dir:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object lblCnvDir: Label8 [4]
    Left = 257
    Top = 82
    Width = 170
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
  object Label1: TLabel [5]
    Left = 169
    Top = 101
    Width = 285
    Height = 28
    AutoSize = False
    Caption = 
      'The following warnings must be checked and confirmed before the ' +
      'conversion can be started:-'
    WordWrap = True
  end
  inherited HelpBtn: TButton
    Top = 295
  end
  inherited Panel1: TPanel
    Height = 262
    inherited Image1: TImage
      Height = 260
    end
  end
  inherited ExitBtn: TButton
    Top = 295
  end
  inherited BackBtn: TButton
    Top = 295
  end
  inherited NextBtn: TButton
    Top = 295
    Caption = '&Convert'
  end
  object panBackup: TPanel
    Left = 169
    Top = 131
    Width = 268
    Height = 79
    BevelOuter = bvNone
    Caption = 'panBackup'
    Ctl3D = True
    ParentCtl3D = False
    TabOrder = 5
    OnClick = panBackupClick
    object Label811: Label8
      Left = 26
      Top = 21
      Width = 241
      Height = 55
      AutoSize = False
      Caption = 
        'A Full Backup of programs and data must have been done before st' +
        'arting this conversion. If you experience problems during the co' +
        'nversion you may be advised to restore your backup.'
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
      Width = 260
      Height = 20
      Align = alRight
      Caption = 'Precautionary Backup Taken'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsUnderline]
      ParentColor = False
      ParentFont = False
      TabOrder = 0
      TextId = 0
      OnClick = DoCheckyChecky
    end
  end
  object panUsers: TPanel
    Left = 169
    Top = 212
    Width = 268
    Height = 67
    BevelOuter = bvNone
    Caption = 'panUsers'
    Ctl3D = True
    ParentCtl3D = False
    TabOrder = 6
    OnClick = panUsersClick
    object Label813: Label8
      Left = 26
      Top = 21
      Width = 241
      Height = 45
      AutoSize = False
      Caption = 
        'If other users are running Exchequer, Enterprise or any of their' +
        ' utility programs this may cause the Conversion to fail partiall' +
        'y or totally.'
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
      Width = 260
      Height = 20
      Align = alRight
      Caption = 'No other users are running Exchequer Enterprise'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsUnderline]
      ParentColor = False
      ParentFont = False
      TabOrder = 0
      TextId = 0
      OnClick = DoCheckyChecky
    end
  end
end
