inherited RegisterProgress: TRegisterProgress
  Left = 342
  Top = 201
  ActiveControl = nil
  Caption = 'Exchequer Accounting System'
  Font.Charset = ANSI_CHARSET
  Font.Name = 'Arial'
  PixelsPerInch = 96
  TextHeight = 14
  inherited TitleLbl: TLabel
    Caption = 'Register Components'
    Font.Charset = ANSI_CHARSET
    Font.Height = -21
    Font.Name = 'Arial'
  end
  inherited InstrLbl: TLabel
    Caption = 
      'Please wait while the software components are registered with Wi' +
      'ndows.'
  end
  object Label1: TLabel [3]
    Left = 183
    Top = 98
    Width = 56
    Height = 15
    AutoSize = False
    Caption = 'Updating...'
    Visible = False
    WordWrap = True
  end
  object Label2: TLabel [4]
    Left = 183
    Top = 119
    Width = 59
    Height = 15
    AutoSize = False
    Caption = 'Copying...'
    Visible = False
    WordWrap = True
  end
  object Label3: TLabel [5]
    Left = 250
    Top = 98
    Width = 201
    Height = 15
    AutoSize = False
    Visible = False
    WordWrap = True
  end
  object Label4: TLabel [6]
    Left = 250
    Top = 119
    Width = 202
    Height = 15
    AutoSize = False
    Visible = False
    WordWrap = True
  end
  inherited HelpBtn: TButton
    Enabled = False
  end
  inherited ExitBtn: TButton
    Enabled = False
  end
  inherited BackBtn: TButton
    Enabled = False
  end
  inherited NextBtn: TButton
    Enabled = False
  end
  object ProgressBar1: TProgressBar
    Left = 183
    Top = 158
    Width = 256
    Height = 16
    Min = 1
    Max = 100
    Position = 1
    TabOrder = 5
    Visible = False
  end
end
