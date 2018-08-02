inherited WarningSQLExecutionExceptionFrame: TWarningSQLExecutionExceptionFrame
  Height = 86
  object Label2: TLabel
    Left = 21
    Top = 64
    Width = 56
    Height = 13
    AutoSize = False
    Caption = 'Exception:'
  end
  object Label3: TLabel
    Left = 21
    Top = 44
    Width = 56
    Height = 13
    AutoSize = False
    Caption = 'SQL:'
  end
  object memExceptionMessage: TMemo
    Left = 80
    Top = 64
    Width = 626
    Height = 15
    TabStop = False
    BorderStyle = bsNone
    Color = clBtnFace
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      '<ExceptionMessage>')
    ParentFont = False
    ReadOnly = True
    TabOrder = 0
  end
  object memSQLCommand: TMemo
    Left = 82
    Top = 44
    Width = 626
    Height = 15
    TabStop = False
    BorderStyle = bsNone
    Color = clBtnFace
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      '<SQLCommand>')
    ParentFont = False
    ReadOnly = True
    TabOrder = 1
  end
end
