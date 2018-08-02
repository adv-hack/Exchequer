inherited frmInstallType: TfrmInstallType
  Left = 441
  Top = 162
  HelpContext = 40
  ActiveControl = nil
  Caption = 'Exchequer Setup Program'
  Font.Charset = ANSI_CHARSET
  Font.Name = 'Arial'
  PixelsPerInch = 96
  TextHeight = 14
  inherited Bevel1: TBevel
    Top = 241
  end
  inherited TitleLbl: TLabel
    Caption = 'Installation Type'
  end
  inherited InstrLbl: TLabel
    Height = 19
    Caption = 'Please specify what you want to do:-'
  end
  inherited HelpBtn: TButton
    TabOrder = 2
  end
  inherited Panel1: TPanel
    TabOrder = 1
  end
  inherited ExitBtn: TButton
    TabOrder = 3
  end
  inherited BackBtn: TButton
    TabOrder = 4
  end
  inherited NextBtn: TButton
    TabOrder = 5
  end
  object NoteBook1: TNotebook
    Left = 169
    Top = 70
    Width = 287
    Height = 168
    TabOrder = 0
    object TPage
      Left = 0
      Top = 0
      Caption = 'nbInstall'
      object Label3: TLabel
        Left = 29
        Top = 40
        Width = 247
        Height = 28
        AutoSize = False
        Caption = 
          'Add uninstalled components or repair damage to an existing insta' +
          'llation.'
        WordWrap = True
        OnClick = Label3Click
      end
      object Label2: TLabel
        Left = 29
        Top = 85
        Width = 247
        Height = 47
        AutoSize = False
        Caption = 'Adds a new set of company data to an existing <APPTITLE> system.'
        WordWrap = True
        OnClick = Label2Click
      end
      object radInstall: TRadioButton
        Left = 11
        Top = 6
        Width = 271
        Height = 17
        Caption = 'Install <APPTITLE>'
        Checked = True
        TabOrder = 0
        TabStop = True
      end
      object radUpgrade: TRadioButton
        Left = 11
        Top = 24
        Width = 224
        Height = 19
        Caption = 'Add Components / Repair Installation'
        TabOrder = 1
      end
      object radAddComp: TRadioButton
        Left = 11
        Top = 69
        Width = 237
        Height = 19
        Caption = 'Add New Company Dataset'
        TabOrder = 2
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'nbUpgrade'
      object Label1: TLabel
        Left = 29
        Top = 42
        Width = 247
        Height = 56
        AutoSize = False
        Caption = 'Adds a new set of company data to an existing <APPTITLE> system.'
        WordWrap = True
        OnClick = Label1Click
      end
      object radUpgrade2: TRadioButton
        Left = 11
        Top = 6
        Width = 273
        Height = 19
        Caption = 'Upgrade an existing installation'
        Checked = True
        TabOrder = 0
        TabStop = True
      end
      object radAddComp2: TRadioButton
        Left = 11
        Top = 24
        Width = 268
        Height = 19
        Caption = 'Add New Company Dataset'
        TabOrder = 1
      end
    end
  end
end
