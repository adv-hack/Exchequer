inherited frmWsStartup: TfrmWsStartup
  Left = 367
  Top = 166
  HelpContext = 13
  ActiveControl = nil
  Caption = 'Exchequer Setup Program'
  Font.Charset = ANSI_CHARSET
  Font.Name = 'Arial'
  PixelsPerInch = 96
  TextHeight = 14
  inherited TitleLbl: TLabel
    Caption = 'Update Engine'
  end
  inherited InstrLbl: TLabel
    Top = 47
    Caption = 
      'The Update Engine checks that the local copy of <APPTITLE> is up' +
      '-to-date. '
  end
  object Label2: TLabel [3]
    Left = 286
    Top = 162
    Width = 102
    Height = 13
    AutoSize = False
    Caption = '(Recommended)'
    OnClick = Label1Click
  end
  object Label1: TLabel [4]
    Left = 167
    Top = 80
    Width = 285
    Height = 31
    AutoSize = False
    Caption = 
      'If it finds any differences, it will optionally update the local' +
      ' copy from the main install directory.'
    WordWrap = True
  end
  object Label4: TLabel [5]
    Left = 167
    Top = 125
    Width = 285
    Height = 34
    AutoSize = False
    Caption = 
      'Do you want to install the Update engine into the Startup folder' +
      ', so it runs automatically when Windows starts?'
    WordWrap = True
  end
  inherited HelpBtn: TButton
    TabOrder = 3
  end
  inherited ExitBtn: TButton
    TabOrder = 4
  end
  inherited BackBtn: TButton
    TabOrder = 5
  end
  inherited NextBtn: TButton
    TabOrder = 6
  end
  object radYes: TRadioButton
    Left = 232
    Top = 161
    Width = 50
    Height = 17
    Caption = 'Yes'
    Checked = True
    TabOrder = 1
    TabStop = True
  end
  object radNo: TRadioButton
    Left = 232
    Top = 181
    Width = 50
    Height = 17
    Caption = 'No'
    TabOrder = 2
  end
end
