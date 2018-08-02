inherited RollBudgetInp: TRollBudgetInp
  Left = 437
  Top = 155
  HelpContext = 181
  Caption = 'Roll Up CC/Dept Budgets'
  ClientHeight = 183
  PixelsPerInch = 96
  TextHeight = 14
  inherited SBSPanel4: TSBSBackGroup
    Height = 141
  end
  object Label81: Label8 [1]
    Left = 25
    Top = 71
    Width = 63
    Height = 14
    Caption = 'Roll Up Basis'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label82: Label8 [2]
    Left = 25
    Top = 101
    Width = 64
    Height = 14
    Caption = 'Budget Basis'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  inherited OkCP1Btn: TButton
    Left = 67
    Top = 154
    TabOrder = 4
  end
  inherited ClsCP1Btn: TButton
    Left = 153
    Top = 154
    TabOrder = 5
  end
  inherited SBSPanel1: TSBSPanel
    TabOrder = 6
  end
  object RU1CB: TBorRadio
    Left = 46
    Top = 16
    Width = 124
    Height = 20
    Align = alRight
    Caption = 'Roll Up All G/L Codes'
    CheckColor = clWindowText
    Checked = True
    GroupIndex = 1
    TabOrder = 0
    TabStop = True
    TextId = 0
  end
  object RU2CB: TBorRadio
    Left = 46
    Top = 38
    Width = 215
    Height = 20
    Align = alRight
    Caption = 'Roll Up Codes in this G/L Heading Only'
    CheckColor = clWindowText
    GroupIndex = 1
    TabOrder = 1
    TextId = 0
  end
  object BasisCB: TSBSComboBox
    Left = 93
    Top = 68
    Width = 195
    Height = 22
    Style = csDropDownList
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 14
    ItemIndex = 0
    ParentFont = False
    TabOrder = 2
    Text = 'Cost Centres Only'
    Items.Strings = (
      'Cost Centres Only'
      'Departments Only'
      'Individual CC + Dept.'
      'Combined CC + Dept.'
      'Combined Dept. + CC')
    MaxListWidth = 0
  end
  object BudgetCB: TSBSComboBox
    Left = 93
    Top = 98
    Width = 195
    Height = 22
    Style = csDropDownList
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 14
    ParentFont = False
    TabOrder = 3
    Items.Strings = (
      'Roll Up Original & Revised'
      'Roll Up Original Only'
      'Roll up Revised Only')
    MaxListWidth = 0
  end
end
