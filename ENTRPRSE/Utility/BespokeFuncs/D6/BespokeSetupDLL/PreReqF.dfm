inherited frmPreRequisites: TfrmPreRequisites
  Left = 337
  Top = 230
  HelpContext = 88
  ActiveControl = nil
  Caption = 'frmPreRequisites'
  ClientHeight = 287
  ClientWidth = 537
  Font.Name = 'Arial'
  PixelsPerInch = 96
  TextHeight = 14
  inherited Bevel1: TBevel
    Top = 242
    Width = 514
  end
  inherited TitleLbl: TLabel
    Top = 15
    Width = 362
    Caption = 'Pre-Requisites'
    Font.Height = -21
    Font.Name = 'Arial'
    Font.Style = [fsBold]
  end
  inherited InstrLbl: TLabel
    Width = 363
    Height = 19
    Caption = 
      'This workstation needs the following in order to run this bespok' +
      'e Plug-In'
  end
  inherited imgSide: TImage
    Height = 131
  end
  inherited HelpBtn: TButton
    Top = 259
    Font.Name = 'Arial'
    ParentFont = False
  end
  inherited Panel1: TPanel
    Height = 225
    inherited Image1: TImage
      Height = 223
    end
  end
  inherited ExitBtn: TButton
    Top = 259
    Font.Name = 'Arial'
    ParentFont = False
  end
  inherited BackBtn: TButton
    Left = 360
    Top = 259
    Font.Name = 'Arial'
    ParentFont = False
    Visible = False
  end
  inherited NextBtn: TButton
    Left = 446
    Top = 259
    Font.Name = 'Arial'
    ParentFont = False
    Visible = False
  end
  object ScrollBox2: TScrollBox
    Left = 180
    Top = 71
    Width = 365
    Height = 178
    BorderStyle = bsNone
    TabOrder = 5
    object panNetFramework: TPanel
      Left = 0
      Top = 58
      Width = 345
      Height = 56
      TabOrder = 0
      object lblNetFrameworkTitle: TLabel
        Left = 7
        Top = 6
        Width = 175
        Height = 13
        Caption = 'Microsoft .Net Framework v3.5'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblNetFrameworkText: TLabel
        Left = 7
        Top = 23
        Width = 330
        Height = 30
        AutoSize = False
        Caption = 
          'The .NET Framework is Microsoft'#39's framework for building and run' +
          'ning applications and is required in order to run this Plug-In.'
        WordWrap = True
      end
      object lblNetFrameworkInstall: TLabel
        Left = 306
        Top = 6
        Width = 27
        Height = 13
        Cursor = crHandPoint
        Alignment = taRightJustify
        Caption = 'Install'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsUnderline]
        ParentFont = False
        OnClick = lblNetFrameworkInstallClick
      end
    end
    object panWinInstaller: TPanel
      Left = 0
      Top = 0
      Width = 345
      Height = 57
      TabOrder = 1
      object lblWinInstallerTitle: TLabel
        Left = 7
        Top = 6
        Width = 123
        Height = 13
        Caption = 'Windows Installer 4.5'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblWinInstallerText: TLabel
        Left = 8
        Top = 23
        Width = 329
        Height = 34
        AutoSize = False
        Caption = 
          'A new version of Windows Installer is required on this workstati' +
          'on. You will need to download and run an update from Microsoft.'
        WordWrap = True
      end
      object lblWinInstallerInstall: TLabel
        Left = 262
        Top = 6
        Width = 71
        Height = 13
        Cursor = crHandPoint
        Alignment = taRightJustify
        Caption = 'Download Link'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsUnderline]
        ParentFont = False
        OnClick = lblWinInstallerInstallClick
      end
    end
    object panSQLExpress: TPanel
      Left = 0
      Top = 114
      Width = 345
      Height = 56
      TabOrder = 2
      object lblSQLExpressTitle: TLabel
        Left = 7
        Top = 6
        Width = 245
        Height = 13
        Caption = 'Microsoft SQL Server 2008 Express Edition'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblSQLExpressInstall: TLabel
        Left = 306
        Top = 6
        Width = 27
        Height = 13
        Cursor = crHandPoint
        Alignment = taRightJustify
        Caption = 'Install'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsUnderline]
        ParentFont = False
        OnClick = lblSQLExpressInstallClick
      end
      object lblSQLExpressText: TLabel
        Left = 7
        Top = 23
        Width = 330
        Height = 27
        AutoSize = False
        Caption = 
          'SQL Server 2008 Express is the free version of SQL Server 2008 a' +
          'nd is required in order to run this Plug-In.'
        WordWrap = True
      end
    end
  end
end
