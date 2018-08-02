inherited frmWelcome: TfrmWelcome
  Left = 260
  Top = 277
  Caption = 'frmWelcome'
  PixelsPerInch = 96
  TextHeight = 13
  inherited TitleLbl: TLabel
    Caption = 'Enterprise Conversion'
  end
  inherited InstrLbl: TLabel
    Height = 44
    Caption = 
      'This Conversion Program can be used to convert your existing Exc' +
      'hequer or Exchequer Enterprise system so that it can be upgraded' +
      ' to Exchequer Enterprise v4.31.'
  end
  object Label1: TLabel [3]
    Left = 167
    Top = 100
    Width = 285
    Height = 44
    AutoSize = False
    Caption = 
      'Click the '#39'Next >>'#39' button to continue with the conversion proce' +
      'ss, or click the '#39'Exit Installation'#39' button to abandon this conv' +
      'ersion program now.'
    WordWrap = True
  end
  inherited BackBtn: TButton
    Visible = False
  end
end
