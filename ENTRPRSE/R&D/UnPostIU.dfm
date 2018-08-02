inherited UnpostInp: TUnpostInp
  Left = 570
  Top = 300
  HelpContext = 715
  Caption = 'Partial Unpost'
  ClientHeight = 175
  PixelsPerInch = 96
  TextHeight = 14
  inherited SBSPanel4: TSBSBackGroup
    Height = 137
  end
  object Label84: Label8 [1]
    Left = 29
    Top = 39
    Width = 139
    Height = 14
    Alignment = taRightJustify
    Caption = 'Unpost back to (&& excluding)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  inherited OkCP1Btn: TButton
    Top = 150
    TabOrder = 4
  end
  inherited ClsCP1Btn: TButton
    Top = 150
    TabOrder = 5
  end
  inherited SBSPanel1: TSBSPanel
    TabOrder = 0
  end
  object I1PrYrF: TEditPeriod
    Tag = 1
    Left = 172
    Top = 36
    Width = 59
    Height = 22
    HelpContext = 636
    AutoSelect = False
    Color = clWhite
    EditMask = '00/0000;0;'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 7
    ParentFont = False
    TabOrder = 1
    Text = '011996'
    Placement = cpAbove
    EPeriod = 1
    EYear = 96
    ViewMask = '000/0000;0;'
  end
  object CBRTF: TBorCheck
    Left = 24
    Top = 70
    Width = 163
    Height = 20
    Caption = 'Reset transaction Tax date'
    CheckColor = clWindowText
    Color = clBtnFace
    ParentColor = False
    TabOrder = 2
    TextId = 0
  end
  object CBCalcTaxF: TBorCheck
    Left = 16
    Top = 97
    Width = 171
    Height = 20
    Caption = 'Recalculate Tax for all periods'
    CheckColor = clWindowText
    Color = clBtnFace
    ParentColor = False
    TabOrder = 3
    TextId = 0
  end
end
