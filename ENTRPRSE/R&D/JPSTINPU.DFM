inherited JPostFilt: TJPostFilt
  HelpContext = 1121
  Caption = 'Post Job Costing Ledger'
  ClientHeight = 191
  ClientWidth = 305
  PixelsPerInch = 96
  TextHeight = 14
  inherited SBSPanel4: TSBSBackGroup
    Left = 7
    Height = 145
  end
  object Label86: Label8 [1]
    Left = 12
    Top = 16
    Width = 277
    Height = 35
    AutoSize = False
    Caption = 'Job Posting...'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -24
    Font.Name = 'Arial'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
    TextId = 0
  end
  inherited OkCP1Btn: TButton
    Left = 26
    Top = 162
    TabOrder = 5
  end
  inherited ClsCP1Btn: TButton
    Left = 112
    Top = 162
    TabOrder = 6
  end
  inherited SBSPanel1: TSBSPanel
    Top = 162
    TabOrder = 0
  end
  object PCOMChk: TBorCheck
    Left = 42
    Top = 50
    Width = 173
    Height = 20
    HelpContext = 1122
    Caption = 'Update commitment balances '
    CheckColor = clWindowText
    Color = clBtnFace
    ParentColor = False
    TabOrder = 1
    TabStop = True
    TextId = 0
  end
  object PJDChk: TBorCheck
    Left = 18
    Top = 68
    Width = 197
    Height = 20
    HelpContext = 1122
    Caption = 'Post job details - update job actuals '
    CheckColor = clWindowText
    Color = clBtnFace
    ParentColor = False
    TabOrder = 2
    TabStop = True
    TextId = 0
  end
  object PTSChk: TBorCheck
    Left = 42
    Top = 88
    Width = 173
    Height = 20
    HelpContext = 1123
    Caption = 'Post Timesheets '
    CheckColor = clWindowText
    Color = clBtnFace
    ParentColor = False
    TabOrder = 3
    TabStop = True
    TextId = 0
  end
  object PCERChk: TBorCheck
    Left = 42
    Top = 106
    Width = 173
    Height = 20
    HelpContext = 1124
    Caption = 'Check for expired retentions '
    CheckColor = clWindowText
    Color = clBtnFace
    ParentColor = False
    TabOrder = 4
    TabStop = True
    TextId = 0
  end
  object btnSchedule: TSBSButton
    Left = 199
    Top = 162
    Width = 80
    Height = 21
    HelpContext = 40166
    Caption = '&Schedule'
    TabOrder = 7
    OnClick = btnScheduleClick
    TextId = 0
  end
end
