inherited frmConfirmRebuild: TfrmConfirmRebuild
  Left = 505
  Top = 142
  ActiveControl = BackBtn
  Caption = 'frmConfirmRebuild'
  ClientHeight = 300
  Font.Charset = ANSI_CHARSET
  Font.Name = 'Arial'
  PixelsPerInch = 96
  TextHeight = 14
  inherited Bevel1: TBevel
    Top = 255
  end
  inherited TitleLbl: TLabel
    Caption = 'Data Rebuild Module'
    Font.Charset = ANSI_CHARSET
    Font.Height = -21
    Font.Name = 'Arial'
  end
  inherited InstrLbl: TLabel
    Top = 44
    Caption = 
      'This module can be used to rebuild the data files and to perform' +
      ' special maintainance functions.'
  end
  inherited imgSide: TImage
    Height = 134
  end
  object Label1: TLabel [4]
    Left = 167
    Top = 78
    Width = 285
    Height = 17
    AutoSize = False
    Caption = 'You have selected the following company:-'
    WordWrap = True
  end
  object lblCompDets: TLabel [5]
    Left = 183
    Top = 97
    Width = 268
    Height = 33
    AutoSize = False
    Caption = ' qwoui yeoqw reoqwu oqwu eyouewq riuw iwueyr iw iywr iuwr yiwer '
    WordWrap = True
  end
  object Label2: TLabel [6]
    Left = 167
    Top = 133
    Width = 285
    Height = 45
    AutoSize = False
    Caption = 
      'Please check that the correct company is selected before clickin' +
      'g the '#39'&Rebuild'#39' button below to run the Data Rebuild Module.'
    WordWrap = True
  end
  object lblDailyPword: TLabel [7]
    Left = 167
    Top = 185
    Width = 285
    Height = 68
    AutoSize = False
    Caption = 
      'NOTE: The Special Functions will not be available in the Rebuild' +
      ' Module.  To access the Special functions you have to log into t' +
      'he Multi-Company Manager with the Daily Password, contact your T' +
      'echnical Support for instructions.'
    WordWrap = True
  end
  inherited HelpBtn: TButton
    Top = 272
    Visible = False
  end
  inherited Panel1: TPanel
    Height = 238
    inherited Image1: TImage
      Height = 236
    end
  end
  inherited ExitBtn: TButton
    Top = 272
    Visible = False
  end
  inherited BackBtn: TButton
    Top = 272
    Caption = '&Rebuild'
    Default = True
  end
  inherited NextBtn: TButton
    Left = 373
    Top = 272
    Cancel = True
    Caption = '&Cancel'
  end
end
