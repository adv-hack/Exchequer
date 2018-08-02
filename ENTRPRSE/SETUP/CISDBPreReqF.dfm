inherited frmDashbPreRequisits: TfrmDashbPreRequisits
  Left = 337
  Top = 230
  HelpContext = 88
  ActiveControl = nil
  Caption = 'frmDashbPreRequisits'
  ClientHeight = 287
  ClientWidth = 708
  PixelsPerInch = 96
  TextHeight = 13
  inherited Bevel1: TBevel
    Top = 242
    Width = 685
  end
  inherited TitleLbl: TLabel
    Width = 533
    Caption = 'Pre-Requisites'
  end
  inherited InstrLbl: TLabel
    Width = 534
    Height = 19
    Caption = 
      'This workstation needs the following updates installed before it' +
      ' can run the Data Synchronisation Service.'
  end
  inherited imgSide: TImage
    Height = 131
  end
  inherited HelpBtn: TButton
    Top = 259
  end
  inherited Panel1: TPanel
    Height = 225
    inherited Image1: TImage
      Height = 223
    end
  end
  inherited ExitBtn: TButton
    Top = 259
  end
  inherited BackBtn: TButton
    Left = 531
    Top = 259
    Visible = False
  end
  inherited NextBtn: TButton
    Left = 617
    Top = 259
    Visible = False
  end
  object ScrollBox2: TScrollBox
    Left = 180
    Top = 71
    Width = 520
    Height = 168
    VertScrollBar.Position = 127
    BorderStyle = bsNone
    TabOrder = 5
    object panNetFramework: TPanel
      Left = 0
      Top = 0
      Width = 503
      Height = 56
      TabOrder = 0
      object lblNetFrameworkTitle: TLabel
        Left = 7
        Top = 6
        Width = 175
        Height = 13
        Caption = 'Microsoft .Net Framework v2.0'
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
        Width = 474
        Height = 30
        AutoSize = False
        Caption = 
          'The .NET Framework is Microsoft'#39's framework for building and run' +
          'ning applications and is required in order to run the service.'
        WordWrap = True
      end
      object lblNetFrameworkInstall: TLabel
        Left = 466
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
      Top = -127
      Width = 503
      Height = 42
      TabOrder = 1
      object lblWinInstallerTitle: TLabel
        Left = 7
        Top = 6
        Width = 123
        Height = 13
        Caption = 'Windows Installer 3.1'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblWinInstallerText: TLabel
        Left = 7
        Top = 23
        Width = 474
        Height = 16
        AutoSize = False
        Caption = 'A Windows Installer update is needed on this workstation.'
        WordWrap = True
      end
      object lblWinInstallerInstall: TLabel
        Left = 466
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
        OnClick = lblWinInstallerInstallClick
      end
    end
    object panMSXML: TPanel
      Left = 0
      Top = -85
      Width = 503
      Height = 42
      TabOrder = 2
      object lblMSXMLTitle: TLabel
        Left = 7
        Top = 6
        Width = 214
        Height = 13
        Caption = 'Microsoft XML Core Services 4.0 SP2'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblMSXMLText: TLabel
        Left = 7
        Top = 23
        Width = 474
        Height = 16
        AutoSize = False
        Caption = 'Microsoft'#39's XML Parser is required by the service.'
        WordWrap = True
      end
      object lblMSXMLInstall: TLabel
        Left = 466
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
      end
    end
    object panMDAC: TPanel
      Left = 0
      Top = -43
      Width = 503
      Height = 43
      TabOrder = 3
      object lblMDACTitle: TLabel
        Left = 7
        Top = 6
        Width = 302
        Height = 13
        Caption = 'Microsoft Data Access Components (MDAC) 2.8 SP1 '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblMDACText: TLabel
        Left = 7
        Top = 23
        Width = 474
        Height = 16
        AutoSize = False
        Caption = 'This is required by Microsoft SQL Server Express 2005.'
        WordWrap = True
      end
      object lblMDACInstall: TLabel
        Left = 466
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
        OnClick = lblMDACInstallClick
      end
    end
    object panSQLExpress: TPanel
      Left = 0
      Top = 56
      Width = 503
      Height = 56
      TabOrder = 4
      object lblSQLExpressTitle: TLabel
        Left = 7
        Top = 6
        Width = 245
        Height = 13
        Caption = 'Microsoft SQL Server 2005 Express Edition'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblSQLExpressInstall: TLabel
        Left = 466
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
        Width = 474
        Height = 27
        AutoSize = False
        Caption = 
          'SQL Server 2005 Express is the free version of SQL Server 2005 a' +
          'nd is required in order to run the service.'
        WordWrap = True
      end
    end
    object panFBI: TPanel
      Left = 0
      Top = 112
      Width = 503
      Height = 56
      TabOrder = 5
      object lblFBITitle: TLabel
        Left = 7
        Top = 6
        Width = 148
        Height = 13
        Caption = 'Exchequer FBI Subsystem'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblFBIInstall: TLabel
        Left = 466
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
        OnClick = lblFBIInstallClick
      end
      object lblFBIText: TLabel
        Left = 7
        Top = 23
        Width = 474
        Height = 27
        AutoSize = False
        Caption = 
          'The Exchequer FBI Subsystem manages the communication between Ex' +
          'chequer GovLink and the government gateways.'
        WordWrap = True
      end
    end
  end
end
