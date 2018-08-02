inherited frmWGEOpts: TfrmWGEOpts
  Left = 340
  Top = 146
  HelpContext = 42
  Caption = 'frmWGEOpts'
  ClientHeight = 324
  PixelsPerInch = 96
  TextHeight = 13
  inherited Bevel1: TBevel
    Top = 279
  end
  inherited TitleLbl: TLabel
    Caption = 'Use Workgroup Engine?'
  end
  inherited InstrLbl: TLabel
    Height = 59
    Caption = 
      'You are licenced to use the Pervasive.SQL v8 Workgroup Engine, t' +
      'his provides superior performance to the standard v6.15 database' +
      ' engine used by Exchequer but does not work on Windows 95. '
  end
  object Label1: TLabel [4]
    Left = 168
    Top = 113
    Width = 284
    Height = 44
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 
      'If you do not have any Windows 95 workstations running Exchequer' +
      ' and you want to use the Workgroup Engine then select the '#39'Use W' +
      'orkgroup Engine'#39' option below.'
    WordWrap = True
  end
  object Label2: TLabel [5]
    Left = 168
    Top = 165
    Width = 284
    Height = 48
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 
      'If you do use Windows 95 workstations or you do not want to use ' +
      'the Workgroup Engine then select the '#39'Use Standard Engine'#39' optio' +
      'n below.'
    WordWrap = True
  end
  inherited HelpBtn: TButton
    Top = 296
  end
  inherited Panel1: TPanel
    Height = 262
    inherited Image1: TImage
      Height = 260
      Anchors = [akLeft, akTop, akRight, akBottom]
    end
  end
  inherited ExitBtn: TButton
    Top = 296
  end
  inherited BackBtn: TButton
    Top = 296
  end
  inherited NextBtn: TButton
    Top = 296
  end
  object radStandard: TRadioButton
    Left = 196
    Top = 242
    Width = 244
    Height = 19
    Caption = 'Use Standard Engine'
    TabOrder = 5
  end
  object radWorkgroup: TRadioButton
    Left = 196
    Top = 220
    Width = 243
    Height = 17
    Caption = 'Use Workgroup Engine'
    Checked = True
    TabOrder = 6
    TabStop = True
  end
end
