inherited frmStartStopService: TfrmStartStopService
  Caption = 'frmStartStopService'
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  inherited TitleLbl: TLabel
    Caption = '<Action> Service?'
  end
  inherited InstrLbl: TLabel
    Caption = 
      'The <ServiceDesc> Service is already installed but is not curren' +
      'tly running.'
  end
  object lblDesc: TLabel [4]
    Left = 167
    Top = 85
    Width = 285
    Height = 30
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 
      'To <Action> the <ServiceDesc> Service click the <Action> Service' +
      ' button below.'
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
  object btnStartStopService: TButton
    Left = 259
    Top = 122
    Width = 79
    Height = 23
    Anchors = [akRight, akBottom]
    Caption = '<Action> Service'
    TabOrder = 5
    OnClick = btnStartStopServiceClick
  end
end
