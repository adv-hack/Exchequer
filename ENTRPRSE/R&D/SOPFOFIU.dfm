inherited SOPROFiFrm: TSOPROFiFrm
  Caption = 'Re-Order Filter'
  ClientHeight = 161
  PixelsPerInch = 96
  TextHeight = 14
  inherited SBSPanel4: TSBSBackGroup
    Height = 127
  end
  object Label81: Label8 [1]
    Left = 50
    Top = 31
    Width = 110
    Height = 14
    Alignment = taRightJustify
    Caption = 'Product Group (Filter) :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label89: Label8 [2]
    Left = 33
    Top = 59
    Width = 128
    Height = 14
    Alignment = taRightJustify
    Caption = 'Preferred Supplier (Filter) :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  inherited OkCP1Btn: TButton
    Top = 137
    TabOrder = 3
  end
  inherited ClsCP1Btn: TButton
    Top = 137
    TabOrder = 4
  end
  inherited SBSPanel1: TSBSPanel
    TabOrder = 5
  end
  object ACFF: Text8Pt
    Tag = 1
    Left = 163
    Top = 26
    Width = 99
    Height = 22
    Hint = 
      'Double click to drill down|Double clicking or using the down but' +
      'ton will drill down to the record for this field. The up button ' +
      'will search for the nearest match.'
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
    Link_to_Stock = True
    ShowHilight = True
  end
  object AccF3: Text8Pt
    Tag = 1
    Left = 163
    Top = 56
    Width = 49
    Height = 22
    Hint = 
      'Double click to drill down|Double clicking or using the down but' +
      'ton will drill down to the record for this field. The up button ' +
      'will search for the nearest match.'
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnExit = AccF3Exit
    TextId = 0
    ViaSBtn = False
    Link_to_Cust = True
    ShowHilight = True
  end
  object BorCheck1: TBorCheck
    Left = 13
    Top = 86
    Width = 163
    Height = 20
    HelpContext = 524
    Caption = 'Show only BOM'#39's for WOR'#39's'
    CheckColor = clWindowText
    Color = clBtnFace
    ParentColor = False
    TabOrder = 2
    TextId = 0
  end
end
