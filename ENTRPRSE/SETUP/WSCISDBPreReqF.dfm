inherited frmWSDashbPreRequisits: TfrmWSDashbPreRequisits
  Left = 427
  Top = 279
  HelpContext = 88
  ActiveControl = nil
  Caption = 'frmWSDashbPreRequisits'
  ClientHeight = 331
  ClientWidth = 708
  DesignSize = (
    708
    331)
  PixelsPerInch = 96
  TextHeight = 13
  inherited Bevel1: TBevel
    Top = 286
    Width = 685
  end
  inherited TitleLbl: TLabel
    Width = 533
    Caption = 'CIS Pre-Requisites'
  end
  inherited InstrLbl: TLabel
    Width = 534
    Height = 33
    Caption = 
      'This workstation needs the following components installed to all' +
      'ow the CIS module to create XML files used for submitting CIS Mo' +
      'nthly Returns and for applying for Sub Contractor Verification c' +
      'odes'
  end
  inherited imgSide: TImage
    Height = 175
  end
  object Label1: TLabel [4]
    Left = 167
    Top = 258
    Width = 534
    Height = 33
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 
      'If you will not be using this functionality on this workstation ' +
      'then you can use the '#39'Skip'#39' button to continue without installin' +
      'g these components.'
    WordWrap = True
  end
  inherited HelpBtn: TButton
    Top = 303
  end
  inherited Panel1: TPanel
    Height = 269
    DesignSize = (
      145
      269)
    inherited Image1: TImage
      Height = 267
    end
  end
  inherited ExitBtn: TButton
    Top = 303
  end
  inherited BackBtn: TButton
    Left = 531
    Top = 303
    Visible = False
  end
  inherited NextBtn: TButton
    Left = 617
    Top = 303
    Caption = '&Skip'
  end
  object ScrollBox2: TScrollBox
    Left = 180
    Top = 86
    Width = 520
    Height = 165
    BorderStyle = bsNone
    TabOrder = 5
    object panNetFramework: TPanel
      Left = 0
      Top = 50
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
          'ning applications and is required in order to run the Exchequer ' +
          'FBI Subsystem.'
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
    object panMSXML: TPanel
      Left = 0
      Top = 5
      Width = 503
      Height = 42
      TabOrder = 1
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
        Caption = 
          'Microsoft'#39's XML Parser is required by the Exchequer FBI Subsyste' +
          'm.'
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
    object panFBI: TPanel
      Left = 0
      Top = 108
      Width = 503
      Height = 56
      TabOrder = 2
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
