object SinglePlugInFrame: TSinglePlugInFrame
  Left = 0
  Top = 0
  Width = 616
  Height = 48
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  ParentFont = False
  TabOrder = 0
  object lblPlugInName: TLabel
    Left = 3
    Top = 6
    Width = 500
    Height = 14
    AutoSize = False
    Caption = 'lblPlugInName'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblPlugInDesc: TLabel
    Left = 5
    Top = 25
    Width = 605
    Height = 14
    Caption = 
      'This is a really, really, really, really, really, really, really' +
      ', really, really, really, really, really, really long plug-in de' +
      'scription.'
    WordWrap = True
  end
  object lblInstallPlugIn: TLabel
    Left = 562
    Top = 6
    Width = 27
    Height = 14
    Cursor = crHandPoint
    Alignment = taRightJustify
    Caption = 'Install'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsUnderline]
    ParentFont = False
    OnClick = lblInstallPlugInClick
  end
  object lblPlugInInstalled: TLabel
    Left = 595
    Top = 6
    Width = 16
    Height = 14
    AutoSize = False
    Caption = #252
    Font.Charset = SYMBOL_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Wingdings'
    Font.Style = [fsBold]
    ParentFont = False
    Visible = False
  end
end
