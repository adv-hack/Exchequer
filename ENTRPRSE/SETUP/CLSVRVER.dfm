inherited frmCSEngineVer: TfrmCSEngineVer
  HelpContext = 42
  Caption = 'frmCSEngineVer'
  PixelsPerInch = 96
  TextHeight = 13
  inherited TitleLbl: TLabel
    Caption = 'Client-Server Engine'
  end
  inherited InstrLbl: TLabel
    Height = 16
    Caption = 'You have the Client-Server version of Exchequer.'
  end
  object Label1: TLabel [4]
    Left = 168
    Top = 125
    Width = 284
    Height = 28
    AutoSize = False
    Caption = 
      'What is the Operating System of the Server that the Client Serve' +
      'r Engine is installed on:-'
    WordWrap = True
  end
  object Label2: TLabel [5]
    Left = 168
    Top = 188
    Width = 284
    Height = 20
    AutoSize = False
    Caption = 'What version of the Client Server Engine are you using:-'
    WordWrap = True
  end
  object Label3: TLabel [6]
    Left = 167
    Top = 68
    Width = 285
    Height = 48
    AutoSize = False
    Caption = 
      'In order to correctly configure the system, the setup program ne' +
      'eds to know some details about the Client-Server Engine you will' +
      ' be using.'
    WordWrap = True
  end
  object lstServerOS: TComboBox
    Left = 186
    Top = 161
    Width = 265
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 5
    Items.Strings = (
      'Microsoft Windows NT 3.5x'
      'Microsoft Windows NT 4.x'
      'Microsoft Windows 2000'
      'Microsoft Windows 2003'
      'Novell Netware 3.xx'
      'Novell Netware 4.xx'
      'Novell Netware 5.xx'
      'Novell Netware 6.xx')
  end
  object lstEngineVer: TComboBox
    Left = 186
    Top = 210
    Width = 265
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 6
    Items.Strings = (
      'Btrieve 6.15'
      'Pervasive.SQL v7'
      'Pervasive.SQL 2000'
      'Pervasive.SQL 8           (Win95 Not Supported)')
  end
end
