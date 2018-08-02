inherited SecurityWarning: TSecurityWarning
  Left = 453
  Top = 192
  ActiveControl = nil
  Caption = 'SecurityWarning'
  PixelsPerInch = 96
  TextHeight = 13
  inherited TitleLbl: TLabel
    Caption = '30-DAY Security Check'
  end
  inherited InstrLbl: TLabel
    Height = 43
    Caption = 
      'Please note that this Exchequer product has a built-in security ' +
      'check. This helps us to prevent software theft and ensures that ' +
      'all users of Exchequer are registered.'
  end
  object Label1: TLabel [3]
    Left = 167
    Top = 99
    Width = 285
    Height = 42
    AutoSize = False
    Caption = 
      '30 days after installing Exchequer you will be prompted to enter' +
      ' a '#39'Release Code'#39', this code can be obtained from your vendor.'
    WordWrap = True
  end
  object Label2: TLabel [4]
    Left = 167
    Top = 150
    Width = 285
    Height = 44
    AutoSize = False
    Caption = 
      'Once you have entered your '#39'Release Code'#39', the usual password sc' +
      'reen will be displayed and you will be able to continue using th' +
      'e system.'
    WordWrap = True
  end
  inherited Panel1: TPanel
    inherited Image1: TImage
      OnDblClick = Image1DblClick
    end
  end
  inherited ExitBtn: TButton
    Visible = False
  end
  inherited BackBtn: TButton
    Visible = False
  end
  inherited NextBtn: TButton
    Caption = '&Continue'
    Enabled = False
  end
  object Timer1: TTimer
    Interval = 6000
    OnTimer = Timer1Timer
    Left = 235
    Top = 255
  end
end
