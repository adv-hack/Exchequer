inherited SurveyFrameMarketing: TSurveyFrameMarketing
  Height = 334
  object Label11: TLabel
    Left = 8
    Top = 28
    Width = 399
    Height = 13
    AutoSize = False
    Caption = 'What Accounting Software did your company use before Exchequer:-'
  end
  object Label13: TLabel
    Left = 6
    Top = 7
    Width = 339
    Height = 16
    AutoSize = False
    Caption = 'When You Purchased Exchequer'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label14: TLabel
    Left = 9
    Top = 77
    Width = 110
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Other, please specify'
  end
  object Label15: TLabel
    Left = 8
    Top = 104
    Width = 399
    Height = 13
    AutoSize = False
    Caption = 
      'What was the position of the person responsible for purchasing E' +
      'xchequer:-'
  end
  object Label16: TLabel
    Left = 9
    Top = 153
    Width = 110
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Other, please specify'
  end
  object Label10: TLabel
    Left = 6
    Top = 184
    Width = 194
    Height = 16
    Caption = 'Size && Nature of Your Business'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label12: TLabel
    Left = 4
    Top = 208
    Width = 115
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Approximate Turnover'
  end
  object Label17: TLabel
    Left = 4
    Top = 234
    Width = 115
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Number of Employees'
  end
  object Label18: TLabel
    Left = 8
    Top = 261
    Width = 399
    Height = 13
    AutoSize = False
    Caption = 'What Industry Sector applies to your company:-'
  end
  object Label19: TLabel
    Left = 9
    Top = 309
    Width = 110
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Other, please specify'
  end
  object lstAccountsPackage: TComboBox
    Left = 18
    Top = 48
    Width = 372
    Height = 22
    Style = csDropDownList
    ItemHeight = 14
    TabOrder = 0
    OnClick = lstAccountsPackageClick
  end
  object edtOtherPackage: TEdit
    Left = 124
    Top = 74
    Width = 260
    Height = 22
    TabOrder = 1
  end
  object lstPersonResponsible: TComboBox
    Left = 18
    Top = 124
    Width = 372
    Height = 22
    Style = csDropDownList
    ItemHeight = 14
    TabOrder = 2
    OnClick = lstPersonResponsibleClick
  end
  object edtOtherJobPosition: TEdit
    Left = 124
    Top = 150
    Width = 260
    Height = 22
    TabOrder = 3
  end
  object lstCurrency: TComboBox
    Left = 124
    Top = 205
    Width = 58
    Height = 22
    Style = csDropDownList
    ItemHeight = 14
    TabOrder = 4
  end
  object lstTurnoverBands: TComboBox
    Left = 185
    Top = 205
    Width = 176
    Height = 22
    Style = csDropDownList
    ItemHeight = 14
    TabOrder = 5
  end
  object lstStaffBands: TComboBox
    Left = 124
    Top = 231
    Width = 81
    Height = 22
    Style = csDropDownList
    ItemHeight = 14
    TabOrder = 6
  end
  object lstIndustry: TComboBox
    Left = 18
    Top = 281
    Width = 372
    Height = 22
    Style = csDropDownList
    ItemHeight = 14
    TabOrder = 7
    OnClick = lstIndustryClick
  end
  object edtOtherIndustry: TEdit
    Left = 124
    Top = 306
    Width = 260
    Height = 22
    TabOrder = 8
  end
end
