inherited frmWorkstationSetup: TfrmWorkstationSetup
  Caption = 'frmWorkstationSetup'
  PixelsPerInch = 96
  TextHeight = 13
  inherited TitleLbl: TLabel
    Caption = 'Workstation Setup'
  end
  inherited InstrLbl: TLabel
    Caption = 
      'You have successfully installed the <APPTITLE> application files' +
      '.'
  end
  object Label1: TLabel [4]
    Left = 167
    Top = 81
    Width = 285
    Height = 31
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 
      'If you want to use the application on this workstation then you ' +
      'should now run the Workstation Setup program.'
    WordWrap = True
  end
  object Label2: TLabel [5]
    Left = 167
    Top = 114
    Width = 285
    Height = 38
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 
      'To run the Workstation Setup click the Setup button below, or cl' +
      'ick the Skip button to complete this setup program.'
    WordWrap = True
  end
  inherited BackBtn: TButton
    Caption = 'S&kip'
  end
  inherited NextBtn: TButton
    Caption = '&Setup'
  end
end
