inherited frmBtr6Welcome: TfrmBtr6Welcome
  Left = 364
  Top = 177
  HelpContext = 501
  Caption = 'frmBtr6Welcome'
  PixelsPerInch = 96
  TextHeight = 13
  inherited TitleLbl: TLabel
    Caption = 'Welcome'
  end
  inherited InstrLbl: TLabel
    Height = 54
    Caption = 
      'The <APPTITLE> Btrieve v6.15 Pre-Installer allows <APPTITLE> to ' +
      'be used in conjunction with the legacy Btrieve v6.15 Microkernel' +
      ' Workstation Engine.'
  end
  object Label1: TLabel [4]
    Left = 167
    Top = 107
    Width = 285
    Height = 48
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 
      'This option can be used to allow <APPTITLE> to be used in conjun' +
      'ction with software that cannot be upgraded to use the Pervasive' +
      '.SQL Workgroup Engine.'
    WordWrap = True
  end
  object Label2: TLabel [5]
    Left = 167
    Top = 160
    Width = 285
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'Please click the Help button below for further information.'
    WordWrap = True
  end
  inherited BackBtn: TButton
    Visible = False
  end
end
