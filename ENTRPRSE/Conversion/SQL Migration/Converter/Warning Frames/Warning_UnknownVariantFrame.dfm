inherited TWarningUnknownVariantFrame: TTWarningUnknownVariantFrame
  Height = 118
  object Label3: TLabel
    Left = 21
    Top = 44
    Width = 56
    Height = 13
    AutoSize = False
    Caption = 'Variant:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object lblVariant: TLabel
    Left = 82
    Top = 44
    Width = 263
    Height = 13
    AutoSize = False
    Caption = '<VariantHexString>'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 21
    Top = 62
    Width = 56
    Height = 13
    AutoSize = False
    Caption = 'Data:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object memHexData: TMemo
    Left = 82
    Top = 63
    Width = 626
    Height = 48
    TabStop = False
    BorderStyle = bsNone
    Color = clBtnFace
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      '<DataHexString>')
    ParentFont = False
    ReadOnly = True
    TabOrder = 0
  end
end
