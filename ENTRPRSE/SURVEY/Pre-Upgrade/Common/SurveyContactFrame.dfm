inherited SurveyFrameContactDetails: TSurveyFrameContactDetails
  Height = 332
  object Label1: TLabel
    Left = 3
    Top = 87
    Width = 87
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Company Name'
  end
  object Label3: TLabel
    Left = 3
    Top = 31
    Width = 87
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Contact Name'
  end
  object lblAddress: TLabel
    Left = 3
    Top = 112
    Width = 87
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Address'
  end
  object lblEmail: TLabel
    Left = 3
    Top = 303
    Width = 87
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Email Address'
  end
  object lblFax: TLabel
    Left = 3
    Top = 278
    Width = 87
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Fax'
  end
  object lblPhone: TLabel
    Left = 3
    Top = 253
    Width = 87
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Telephone'
  end
  object lblPostCode: TLabel
    Left = 3
    Top = 222
    Width = 87
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Post Code'
  end
  object Label2: TLabel
    Left = 6
    Top = 7
    Width = 139
    Height = 16
    Caption = 'Your Company Details'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label31: TLabel
    Left = 25
    Top = 57
    Width = 123
    Height = 14
    Caption = 'Preferred contact method'
  end
  object Label9: TLabel
    Left = 154
    Top = 9
    Width = 111
    Height = 14
    Caption = '(* = Mandatory Field)'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object edtCompanyName: TEdit
    Left = 94
    Top = 84
    Width = 273
    Height = 22
    TabOrder = 2
  end
  object edtContactName: TEdit
    Left = 94
    Top = 28
    Width = 188
    Height = 22
    TabOrder = 0
  end
  object edtAddress1: TEdit
    Left = 94
    Top = 109
    Width = 273
    Height = 22
    TabOrder = 3
  end
  object edtAddress2: TEdit
    Left = 94
    Top = 131
    Width = 273
    Height = 22
    TabOrder = 4
  end
  object edtAddress3: TEdit
    Left = 94
    Top = 153
    Width = 273
    Height = 22
    TabOrder = 5
  end
  object edtAddress5: TEdit
    Left = 94
    Top = 197
    Width = 273
    Height = 22
    TabOrder = 7
  end
  object edtAddress4: TEdit
    Left = 94
    Top = 175
    Width = 273
    Height = 22
    TabOrder = 6
  end
  object edtEmail: TEdit
    Left = 94
    Top = 300
    Width = 273
    Height = 22
    TabOrder = 11
  end
  object edtFax: TEdit
    Left = 94
    Top = 275
    Width = 188
    Height = 22
    TabOrder = 10
  end
  object edtPhone: TEdit
    Left = 94
    Top = 250
    Width = 188
    Height = 22
    TabOrder = 9
  end
  object edtPostCode: TEdit
    Left = 94
    Top = 219
    Width = 101
    Height = 22
    TabOrder = 8
  end
  object lstContactMethod: TComboBox
    Left = 153
    Top = 53
    Width = 130
    Height = 22
    Style = csDropDownList
    ItemHeight = 14
    TabOrder = 1
    OnClick = lstContactMethodClick
  end
end
