inherited frmWStationConfig: TfrmWStationConfig
  Left = 365
  Top = 176
  HelpContext = 12
  ActiveControl = nil
  Caption = 'Exchequer Setup Program'
  Font.Charset = ANSI_CHARSET
  Font.Name = 'Arial'
  PixelsPerInch = 96
  TextHeight = 14
  inherited TitleLbl: TLabel
    Caption = 'Workstation Configuration'
  end
  inherited InstrLbl: TLabel
    Height = 22
    Caption = 'Please select the workstation operation configuration:'
  end
  object Label1: TLabel [3]
    Left = 197
    Top = 96
    Width = 247
    Height = 43
    AutoSize = False
    Caption = 
      'The workstation is configured to use the program  files and data' +
      ' on the network. Only essential files are installed locally.'
    WordWrap = True
    OnClick = Label1Click
  end
  object Label2: TLabel [4]
    Left = 340
    Top = 79
    Width = 102
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Recommended'
    OnClick = Label1Click
  end
  object Label3: TLabel [5]
    Left = 197
    Top = 164
    Width = 247
    Height = 43
    AutoSize = False
    Caption = 
      'The program  files are installed locally and use data stored cen' +
      'trally on the network. This reduces the network traffic on low b' +
      'andwidth connections.'
    WordWrap = True
    OnClick = Label3Click
  end
  object radStandard: TRadioButton [7]
    Left = 178
    Top = 78
    Width = 110
    Height = 17
    Caption = 'Standard'
    Checked = True
    TabOrder = 1
    TabStop = True
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
  object radLocal: TRadioButton
    Left = 178
    Top = 146
    Width = 113
    Height = 17
    Caption = 'Local Program Files'
    TabOrder = 2
  end
end
