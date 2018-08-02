inherited frmDLLWarning: TfrmDLLWarning
  Caption = 'frmDLLWarning'
  PixelsPerInch = 96
  TextHeight = 13
  inherited TitleLbl: TLabel
    Caption = 'Warning'
  end
  inherited InstrLbl: TLabel
    Height = 32
    Caption = 
      'One or more of the following files have been found installed in ' +
      'your Windows System:-'
  end
  object Label1: TLabel [4]
    Left = 179
    Top = 84
    Width = 273
    Height = 18
    AutoSize = False
    Caption = 'CALWIN32.DLL, CLNWINTH.DLL'
    WordWrap = True
  end
  object Label2: TLabel [5]
    Left = 167
    Top = 104
    Width = 285
    Height = 31
    AutoSize = False
    Caption = 
      'These files have been known to cause Access Violations when star' +
      'ting Exchequer.  '
    WordWrap = True
  end
  object Label3: TLabel [6]
    Left = 167
    Top = 141
    Width = 285
    Height = 45
    AutoSize = False
    Caption = 
      'If you are experiencing problems of this sort, you can use the '#39 +
      'Move Files'#39' button below to move these files to the ENTBAK direc' +
      'tory off of '
    WordWrap = True
  end
  object Label4: TLabel [7]
    Left = 167
    Top = 216
    Width = 285
    Height = 21
    AutoSize = False
    Caption = 'Alternatively, contact your System Administrator.'
    WordWrap = True
  end
  inherited HelpBtn: TButton
    TabOrder = 2
    Visible = False
  end
  inherited Panel1: TPanel
    TabOrder = 1
  end
  inherited ExitBtn: TButton
    TabOrder = 3
    Visible = False
  end
  inherited BackBtn: TButton
    TabOrder = 4
    Visible = False
  end
  inherited NextBtn: TButton
    Caption = '&Continue'
    TabOrder = 5
  end
  object btnMoveFiles: TButton
    Left = 177
    Top = 189
    Width = 262
    Height = 22
    Caption = 'Move Files'
    TabOrder = 0
    OnClick = btnMoveFilesClick
  end
end
