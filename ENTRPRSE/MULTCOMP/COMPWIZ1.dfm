inherited CompDetail1: TCompDetail1
  Left = 177
  Top = 168
  HelpContext = 35
  ActiveControl = cpName
  Caption = 'CompDetail1'
  Font.Charset = ANSI_CHARSET
  Font.Name = 'Arial'
  PixelsPerInch = 96
  TextHeight = 14
  inherited TitleLbl: TLabel
    Caption = 'Company Details'
  end
  inherited InstrLbl: TLabel
    Left = 168
    Top = 100
    Height = 17
    Caption = 'Company Code'
  end
  object Label1: TLabel [3]
    Left = 168
    Top = 48
    Width = 285
    Height = 19
    AutoSize = False
    Caption = 'Enter the company name below. '
    WordWrap = True
  end
  inherited HelpBtn: TButton
    HelpContext = 10020
    TabOrder = 3
  end
  inherited Panel1: TPanel
    TabOrder = 2
  end
  inherited ExitBtn: TButton
    TabOrder = 4
  end
  inherited BackBtn: TButton
    Enabled = False
    TabOrder = 5
  end
  inherited NextBtn: TButton
    Left = 373
    TabOrder = 6
  end
  object cpName: Text8Pt
    Tag = 1
    Left = 184
    Top = 65
    Width = 265
    Height = 22
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 45
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    OnChange = cpNameChange
    OnExit = cpNameExit
    TextId = 0
    ViaSBtn = False
  end
  object cpCode: Text8Pt
    Tag = 1
    Left = 184
    Top = 117
    Width = 64
    Height = 22
    CharCase = ecUpperCase
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 6
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    TextId = 0
    ViaSBtn = False
  end
end
