inherited RepJCIInp: TRepJCIInp
  HelpContext = 1214
  Caption = 'Job Billing Report'
  ClientHeight = 197
  ClientWidth = 356
  PixelsPerInch = 96
  TextHeight = 14
  inherited SBSPanel4: TSBSBackGroup
    Top = 8
    Width = 342
    Height = 139
  end
  object Label810: Label8 [1]
    Left = 59
    Top = 68
    Width = 98
    Height = 14
    Alignment = taRightJustify
    Caption = 'Job/Contract Code : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  inherited OkCP1Btn: TButton
    Left = 98
    Top = 162
    TabOrder = 1
  end
  inherited ClsCP1Btn: TButton
    Left = 184
    Top = 162
    TabOrder = 2
  end
  inherited SBSPanel1: TSBSPanel
    TabOrder = 3
  end
  object ACFF: Text8Pt
    Tag = 1
    Left = 160
    Top = 64
    Width = 131
    Height = 22
    Hint = 
      'Double click to drill down|Double clicking or using the down but' +
      'ton will drill down to the record for this field. The up button ' +
      'will search for the nearest match.'
    HelpContext = 652
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnExit = ACFFExit
    TextId = 0
    ViaSBtn = False
    Link_to_Cust = True
    ShowHilight = True
  end
end
