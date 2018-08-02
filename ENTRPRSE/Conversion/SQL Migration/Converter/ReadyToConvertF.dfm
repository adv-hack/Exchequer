inherited frmReadyToConvert: TfrmReadyToConvert
  Left = 337
  Top = 58
  HorzScrollBar.Range = 0
  VertScrollBar.Range = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'frmReadyToConvert'
  ClientHeight = 494
  ClientWidth = 561
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 14
  inherited shBanner: TShape
    Width = 561
  end
  inherited lblBanner: TLabel
    Width = 205
    Caption = 'Ready To Convert'
  end
  object Label1: TLabel [2]
    Left = 8
    Top = 50
    Width = 528
    Height = 31
    AutoSize = False
    Caption = 
      'The Exchequer Pervasive Edition to Exchequer SQL Edition convers' +
      'ion is ready to proceed, please check the details below and ackn' +
      'owledge the warnings before clicking the Continue button.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object Label2: TLabel [3]
    Left = 27
    Top = 91
    Width = 150
    Height = 14
    Caption = 'Exchequer Pervasive Directory'
  end
  object Label3: TLabel [4]
    Left = 27
    Top = 137
    Width = 123
    Height = 14
    Caption = 'Exchequer SQL Directory'
  end
  object lblExchequerPervasiveDirectory: TLabel [5]
    Left = 193
    Top = 91
    Width = 337
    Height = 14
    AutoSize = False
    Caption = 'Exchequer Pervasive Directory'
  end
  object lblExchequerSQLDirectory: TLabel [6]
    Left = 193
    Top = 137
    Width = 332
    Height = 14
    AutoSize = False
    Caption = 'Exchequer SQL Directory'
  end
  object Label4: TLabel [7]
    Left = 43
    Top = 109
    Width = 53
    Height = 14
    Caption = 'Companies'
  end
  object lblExchequerPervasiveCompanies: TLabel [8]
    Left = 193
    Top = 109
    Width = 300
    Height = 14
    AutoSize = False
    Caption = 'Exchequer Pervasive Directory'
  end
  object Label5: TLabel [9]
    Left = 43
    Top = 155
    Width = 57
    Height = 14
    Caption = 'SQL Server'
  end
  object lblExchequerSQLServer: TLabel [10]
    Left = 193
    Top = 155
    Width = 333
    Height = 14
    AutoSize = False
    Caption = 'Exchequer Pervasive Directory'
  end
  object Label7: TLabel [11]
    Left = 43
    Top = 173
    Width = 46
    Height = 14
    Caption = 'Database'
  end
  object lblExchequerSQLDatabase: TLabel [12]
    Left = 193
    Top = 173
    Width = 329
    Height = 14
    AutoSize = False
    Caption = 'Exchequer Pervasive Directory'
  end
  object Label8: TLabel [13]
    Left = 8
    Top = 200
    Width = 495
    Height = 19
    AutoSize = False
    Caption = 
      'The following warnings must be ackowledged before you can contin' +
      'ue:-'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object btnContinue: TButton [14]
    Left = 195
    Top = 467
    Width = 80
    Height = 21
    Caption = 'Continue'
    Enabled = False
    TabOrder = 1
    OnClick = btnContinueClick
  end
  object btnClose: TButton [15]
    Left = 287
    Top = 467
    Width = 80
    Height = 21
    Cancel = True
    Caption = 'Close'
    ModalResult = 2
    TabOrder = 2
  end
  object scrlWarnings: TScrollBox [16]
    Left = 23
    Top = 222
    Width = 529
    Height = 235
    BorderStyle = bsNone
    TabOrder = 0
    object panNoUsers: TPanel
      Left = 2
      Top = 0
      Width = 490
      Height = 54
      BevelOuter = bvNone
      TabOrder = 1
      object lblNoUsers: TLabel
        Left = 25
        Top = 23
        Width = 465
        Height = 30
        AutoSize = False
        Caption = 
          'No users are using either the Exchequer Pervasive or Exchequer S' +
          'QL Editions installations and all services, tray icons and linke' +
          'd third-party applications are closed.'
        WordWrap = True
        OnClick = lblNoUsersClick
      end
      object chkNoUsers: TCheckBox
        Left = 6
        Top = 4
        Width = 260
        Height = 19
        Caption = 'No Users Using System / All Services Stopped'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsUnderline]
        ParentFont = False
        TabOrder = 0
        OnClick = DoCheckyChecky
      end
    end
    object panBackupTaken: TPanel
      Left = -1
      Top = 52
      Width = 490
      Height = 54
      BevelOuter = bvNone
      TabOrder = 2
      object lblBackupTaken: TLabel
        Left = 25
        Top = 23
        Width = 460
        Height = 34
        AutoSize = False
        Caption = 
          'A Full Backup of programs and data must have been done before co' +
          'ntinuing with this conversion. If problems occur then you will p' +
          'robably be advised to restore your backup.'
        WordWrap = True
        OnClick = lblBackupTakenClick
      end
      object chkBackupTaken: TCheckBox
        Left = 6
        Top = 4
        Width = 169
        Height = 19
        Caption = 'Precautionary Backup Taken'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsUnderline]
        ParentFont = False
        TabOrder = 0
        OnClick = DoCheckyChecky
      end
    end
    object panOverwriteDatabase: TPanel
      Left = 0
      Top = 112
      Width = 490
      Height = 54
      BevelOuter = bvNone
      TabOrder = 3
      object lblOverwriteDatabase: TLabel
        Left = 25
        Top = 23
        Width = 459
        Height = 34
        AutoSize = False
        Caption = 
          'The %DatabaseName% database on the server %SQLSERVER% will be ov' +
          'erwritten, please ensure that this is the correct database.'
        WordWrap = True
        OnClick = lblOverwriteDatabaseClick
      end
      object chkOverwriteDatabase: TCheckBox
        Left = 6
        Top = 4
        Width = 470
        Height = 19
        Caption = 'Overwrite Database %DatabaseName%'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsUnderline]
        ParentFont = False
        TabOrder = 0
        OnClick = DoCheckyChecky
      end
    end
    object panPreConversionChecks: TPanel
      Left = 0
      Top = 173
      Width = 490
      Height = 56
      BevelOuter = bvNone
      TabOrder = 0
      object lblPreConversionChecks: TLabel
        Left = 25
        Top = 23
        Width = 459
        Height = 34
        AutoSize = False
        Caption = 
          'The documented Pre-Conversion Checks have been performed in your' +
          ' existing Exchequer Pervasive Edition so that the converted data' +
          ' can be checked.'
        WordWrap = True
        OnClick = lblPreConversionChecksClick
      end
      object chkPreConversionChecks: TCheckBox
        Left = 6
        Top = 4
        Width = 470
        Height = 19
        Caption = 'Pre-Conversion Checks Performed'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsUnderline]
        ParentFont = False
        TabOrder = 0
        OnClick = DoCheckyChecky
      end
    end
  end
end
