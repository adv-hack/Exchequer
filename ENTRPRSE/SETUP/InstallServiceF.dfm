inherited frmInstallService: TfrmInstallService
  Caption = 'frmInstallService'
  PixelsPerInch = 96
  TextHeight = 13
  inherited TitleLbl: TLabel
    Caption = 'Install Service?'
  end
  inherited InstrLbl: TLabel
    Caption = 'The <ServiceDesc> Service is not installed.'
  end
  object lblDesc: TLabel [4]
    Left = 167
    Top = 85
    Width = 285
    Height = 30
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 
      'To install the <ServiceDesc> Service click the Install Service b' +
      'utton below.'
    WordWrap = True
  end
  inherited ExitBtn: TButton
    Visible = False
  end
  inherited BackBtn: TButton
    Visible = False
  end
  inherited NextBtn: TButton
    Caption = '&Close'
  end
  object btnInstallService: TButton
    Left = 259
    Top = 122
    Width = 79
    Height = 23
    Anchors = [akRight, akBottom]
    Caption = 'Install Service'
    TabOrder = 5
    OnClick = btnInstallServiceClick
  end
end
