object fNomLine: TfNomLine
  Left = 0
  Top = 0
  Width = 603
  Height = 22
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  ParentFont = False
  TabOrder = 0
  object Shape1: TShape
    Left = 3
    Top = 21
    Width = 114
    Height = 1
    Pen.Color = clGray
  end
  object Shape2: TShape
    Left = 122
    Top = 21
    Width = 63
    Height = 1
    Pen.Color = clGray
  end
  object Shape3: TShape
    Left = 190
    Top = 21
    Width = 43
    Height = 1
    Pen.Color = clGray
  end
  object Shape4: TShape
    Left = 238
    Top = 21
    Width = 43
    Height = 1
    Pen.Color = clGray
  end
  object Shape5: TShape
    Left = 457
    Top = 21
    Width = 70
    Height = 1
    Pen.Color = clGray
  end
  object Shape6: TShape
    Left = 382
    Top = 21
    Width = 70
    Height = 1
    Pen.Color = clGray
  end
  object lGrossAmount: TLabel
    Left = 580
    Top = 2
    Width = 21
    Height = 14
    Alignment = taRightJustify
    Caption = '0.00'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object edDesc: TEdit
    Tag = 1
    Left = 3
    Top = 2
    Width = 114
    Height = 18
    BorderStyle = bsNone
    TabOrder = 0
    OnEnter = EditEnter
  end
  object edGLCode: TEdit
    Tag = 2
    Left = 122
    Top = 2
    Width = 63
    Height = 18
    BorderStyle = bsNone
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    OnEnter = EditEnter
    OnExit = edGLCodeExit
  end
  object edCC: TEdit
    Tag = 3
    Left = 190
    Top = 2
    Width = 43
    Height = 18
    BorderStyle = bsNone
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    OnEnter = EditEnter
    OnExit = edCCExit
  end
  object edDept: TEdit
    Tag = 4
    Left = 238
    Top = 2
    Width = 43
    Height = 18
    BorderStyle = bsNone
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    OnEnter = EditEnter
    OnExit = edDeptExit
  end
  object cmbVATCode: TComboBox
    Tag = 5
    Left = 286
    Top = 0
    Width = 91
    Height = 22
    BevelInner = bvNone
    BevelOuter = bvNone
    Style = csDropDownList
    ItemHeight = 14
    TabOrder = 4
    OnEnter = EditEnter
    OnExit = AmountExit
  end
  object edNetAmount: TNumEdit
    Tag = 6
    Left = 382
    Top = 2
    Width = 70
    Height = 18
    AutoSize = False
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderStyle = bsNone
    TabOrder = 5
    Text = '0'
    OnEnter = EditEnter
    OnExit = AmountExit
    EditAlignment = alRight
    PermitNegatives = False
    PermitDecimals = True
    DecimalPlaces = 2
  end
  object edVATAmount: TNumEdit
    Tag = 7
    Left = 457
    Top = 2
    Width = 70
    Height = 18
    AutoSize = False
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderStyle = bsNone
    TabOrder = 6
    Text = '0'
    OnEnter = EditEnter
    OnExit = AmountExit
    EditAlignment = alRight
    PermitNegatives = False
    PermitDecimals = True
    DecimalPlaces = 2
  end
end