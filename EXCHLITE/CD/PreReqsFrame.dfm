object fraPreReqs: TfraPreReqs
  Left = 0
  Top = 0
  Width = 540
  Height = 256
  HelpContext = 57
  TabOrder = 0
  object ScrollBox1: TScrollBox
    Left = 0
    Top = 0
    Width = 540
    Height = 256
    Align = alClient
    BorderStyle = bsNone
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 6
      Width = 119
      Height = 20
      Caption = 'Pre-Requisites'
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
      Width = 386
      Height = 13
      Caption = 
        '<APPTITLE> requires the following items to be installed prior to' +
        ' its own installation.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object ScrollBox2: TScrollBox
      Left = 10
      Top = 46
      Width = 519
      Height = 197
      BorderStyle = bsNone
      TabOrder = 0
      object panNetFramework: TPanel
        Left = 0
        Top = 126
        Width = 487
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
            'ning applications and is required in order to run <APPTITLE> and' +
            ' its utilities.'
          WordWrap = True
        end
        object lblNetFrameworkInstall: TLabel
          Left = 453
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
      object panIRISLicencing: TPanel
        Left = 0
        Top = 238
        Width = 487
        Height = 56
        TabOrder = 1
        object lblIRISLicencingTitle: TLabel
          Left = 7
          Top = 6
          Width = 84
          Height = 13
          Caption = 'IRIS Licensing'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lblIRISLicencingInstall: TLabel
          Left = 453
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
          OnClick = lblIRISLicencingInstallClick
        end
        object lblIRISLicencingText: TLabel
          Left = 7
          Top = 23
          Width = 474
          Height = 30
          AutoSize = False
          Caption = 
            'The IRIS Licensing subsystem controls access to <APPTITLE> and a' +
            'llows licences for this Installation CD to be downloaded from th' +
            'e internet.'
          WordWrap = True
        end
      end
      object panSQLExpress: TPanel
        Left = 0
        Top = 182
        Width = 487
        Height = 56
        TabOrder = 2
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
          Left = 454
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
            'nd is required in order to run <APPTITLE> and its utilities.'
          WordWrap = True
        end
      end
      object panWinInstaller: TPanel
        Left = 0
        Top = 0
        Width = 487
        Height = 42
        TabOrder = 3
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
          Left = 453
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
        Top = 42
        Width = 487
        Height = 42
        TabOrder = 4
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
          Caption = 'Microsoft'#39's XML Parser is required by <APPTITLE>.'
          WordWrap = True
        end
        object lblMSXMLInstall: TLabel
          Left = 453
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
          OnClick = lblMSXMLInstallClick
        end
      end
      object panMDAC: TPanel
        Left = 0
        Top = 84
        Width = 487
        Height = 42
        TabOrder = 5
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
          Left = 453
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
      object panPSQLWGE: TPanel
        Left = 0
        Top = 294
        Width = 487
        Height = 56
        TabOrder = 6
        object lblPSQLWGETitle: TLabel
          Left = 7
          Top = 6
          Width = 223
          Height = 13
          Caption = 'Pervasive.SQL Workgroup Engine v8.7'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lblPSQLWGEInstall: TLabel
          Left = 453
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
          OnClick = lblPSQLWGEInstallClick
        end
        object lblPSQLWGEText: TLabel
          Left = 7
          Top = 23
          Width = 474
          Height = 30
          AutoSize = False
          Caption = 
            'The Pervasive.SQL Workgroup Engine is required in order to run <' +
            'APPTITLE> and its utilities.'
          WordWrap = True
        end
      end
    end
  end
end
