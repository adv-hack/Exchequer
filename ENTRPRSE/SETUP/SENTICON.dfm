inherited frmSentimailIcons: TfrmSentimailIcons
  Left = 357
  Top = 223
  HelpContext = 87
  Caption = 'frmSentimailIcons'
  ClientHeight = 267
  Font.Charset = ANSI_CHARSET
  Font.Name = 'Arial'
  PixelsPerInch = 96
  TextHeight = 14
  inherited Bevel1: TBevel
    Top = 222
  end
  inherited TitleLbl: TLabel
    Caption = 'Sentimail Module'
  end
  inherited InstrLbl: TLabel
    Height = 31
    Caption = 
      'The Sentimail Engine is responsible for processing the Sentinels' +
      ' and sending out the Email and SMS Alerts.'
  end
  object Label2: TLabel [4]
    Left = 167
    Top = 85
    Width = 285
    Height = 45
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 
      'The Sentimail Engine should be running on at least one workstati' +
      'on, but can be run simultaneously on more than one workstation t' +
      'o improve performance where necessary.'
    WordWrap = True
  end
  object Label1: TLabel [5]
    Left = 167
    Top = 134
    Width = 285
    Height = 32
    AutoSize = False
    Caption = 
      'Select either of the options below to add shortcuts to this work' +
      'station for the Sentimail Engine.'
    WordWrap = True
  end
  inherited HelpBtn: TButton
    Top = 239
    TabOrder = 2
  end
  inherited Panel1: TPanel
    Height = 205
    TabOrder = 1
    inherited Image1: TImage
      Height = 203
    end
  end
  inherited ExitBtn: TButton
    Top = 239
    TabOrder = 3
  end
  inherited BackBtn: TButton
    Top = 239
    TabOrder = 4
  end
  inherited NextBtn: TButton
    Top = 239
    TabOrder = 5
  end
  object chkStartup: TBorCheck
    Left = 179
    Top = 167
    Width = 247
    Height = 20
    Align = alRight
    Caption = 'Add shortcut into Windows Startup Group'
    Color = clBtnFace
    ParentColor = False
    TabOrder = 0
    TextId = 0
  end
  object chkExchequer: TBorCheck
    Left = 179
    Top = 190
    Width = 247
    Height = 20
    Align = alRight
    Caption = 'Add shortcut into the Exchequer Group'
    Color = clBtnFace
    ParentColor = False
    TabOrder = 6
    TextId = 0
  end
end
