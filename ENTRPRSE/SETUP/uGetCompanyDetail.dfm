inherited frmGetCompDetail: TfrmGetCompDetail
  Left = 345
  Top = 186
  HelpContext = 35
  Caption = 'Company Details'
  PixelsPerInch = 96
  TextHeight = 13
  inherited TitleLbl: TLabel
    Caption = 'Company Details'
  end
  inherited InstrLbl: TLabel
    Height = 17
    Caption = 'Enter the company name below. '
    Font.Charset = ANSI_CHARSET
    Font.Name = 'Arial'
    ParentFont = False
  end
  object Label1: TLabel [4]
    Left = 168
    Top = 100
    Width = 285
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'Company Code'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  inherited HelpBtn: TButton
    Font.Charset = ANSI_CHARSET
    Font.Name = 'Arial'
    ParentFont = False
  end
  inherited ExitBtn: TButton
    Font.Charset = ANSI_CHARSET
    Font.Name = 'Arial'
    ParentFont = False
  end
  inherited BackBtn: TButton
    Font.Charset = ANSI_CHARSET
    Font.Name = 'Arial'
    ParentFont = False
  end
  inherited NextBtn: TButton
    Font.Charset = ANSI_CHARSET
    Font.Name = 'Arial'
    ParentFont = False
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
    TabOrder = 5
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
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 6
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 6
    OnKeyPress = cpCodeKeyPress
    TextId = 0
    ViaSBtn = False
  end
end
