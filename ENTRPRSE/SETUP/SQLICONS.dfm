inherited frmSQLIcons: TfrmSQLIcons
  Left = 357
  Top = 223
  HelpContext = 124
  Caption = 'frmSQLIcons'
  ClientHeight = 267
  Font.Charset = ANSI_CHARSET
  Font.Name = 'Arial'
  PixelsPerInch = 96
  TextHeight = 14
  inherited Bevel1: TBevel
    Top = 222
    HelpContext = 124
  end
  inherited TitleLbl: TLabel
    Caption = 'SQL Edition Help'
  end
  inherited InstrLbl: TLabel
    Height = 32
    Caption = 
      'A help file is available containing additional information on to' +
      'pics specific to the Exchequer SQL Edition:-'
  end
  object Label1: TLabel [4]
    Left = 167
    Top = 149
    Width = 285
    Height = 31
    AutoSize = False
    Caption = 
      'Do you want this information made available to users on this wor' +
      'kstation:-'
    WordWrap = True
  end
  object Label2: TLabel [5]
    Left = 181
    Top = 84
    Width = 6
    Height = 16
    Caption = #183
    Font.Charset = SYMBOL_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Symbol'
    Font.Style = []
    ParentFont = False
  end
  object Label4: TLabel [6]
    Left = 181
    Top = 104
    Width = 6
    Height = 16
    Caption = #183
    Font.Charset = SYMBOL_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Symbol'
    Font.Style = []
    ParentFont = False
  end
  object Label6: TLabel [7]
    Left = 181
    Top = 124
    Width = 6
    Height = 16
    Caption = #183
    Font.Charset = SYMBOL_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Symbol'
    Font.Style = []
    ParentFont = False
  end
  object Label7: TLabel [8]
    Left = 193
    Top = 126
    Width = 253
    Height = 16
    AutoSize = False
    Caption = 'Example queries'
    WordWrap = True
  end
  object Label5: TLabel [9]
    Left = 193
    Top = 106
    Width = 253
    Height = 16
    AutoSize = False
    Caption = 'The Exchequer SQL Database Structure'
    WordWrap = True
  end
  object Label3: TLabel [10]
    Left = 193
    Top = 86
    Width = 253
    Height = 16
    AutoSize = False
    Caption = 'Backups and Restores'
    WordWrap = True
  end
  inherited HelpBtn: TButton
    Top = 239
  end
  inherited Panel1: TPanel
    Height = 205
    inherited Image1: TImage
      Height = 203
    end
  end
  inherited ExitBtn: TButton
    Top = 239
  end
  inherited BackBtn: TButton
    Top = 239
  end
  inherited NextBtn: TButton
    Top = 239
  end
  object chkSQLHelp: TBorCheck
    Left = 179
    Top = 184
    Width = 247
    Height = 20
    Align = alRight
    Caption = 'Add shortcut into the Exchequer Group'
    Color = clBtnFace
    ParentColor = False
    TabOrder = 5
    TextId = 0
  end
end
