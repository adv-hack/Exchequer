object PlugInAboutFrame: TPlugInAboutFrame
  Left = 0
  Top = 0
  Width = 453
  Height = 94
  TabOrder = 0
  DesignSize = (
    453
    94)
  object lblPlugInName: TLabel
    Left = 2
    Top = 6
    Width = 274
    Height = 14
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'lblPlugInName'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblClassName: TLabel
    Left = 281
    Top = 6
    Width = 170
    Height = 14
    Alignment = taRightJustify
    Anchors = [akTop]
    AutoSize = False
    Caption = 'lblClassName'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsItalic]
    ParentFont = False
  end
  object bvTopBevel: TBevel
    Left = 0
    Top = 0
    Width = 453
    Height = 2
    Align = alTop
    Shape = bsTopLine
  end
  object bvBottomBevel: TBevel
    Left = 0
    Top = 92
    Width = 453
    Height = 2
    Align = alBottom
    Shape = bsTopLine
  end
  object btnPlugInConfiguration: TButton
    Left = 368
    Top = 65
    Width = 80
    Height = 21
    Caption = 'Configure'
    TabOrder = 0
    OnClick = btnPlugInConfigurationClick
  end
end
