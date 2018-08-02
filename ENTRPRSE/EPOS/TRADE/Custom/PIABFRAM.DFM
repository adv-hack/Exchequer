object PlugInAboutFrame: TPlugInAboutFrame
  Left = 0
  Top = 0
  Width = 352
  Height = 124
  Color = clWhite
  ParentColor = False
  TabOrder = 0
  DesignSize = (
    352
    124)
  object lPlugInName: TLabel
    Left = 2
    Top = 6
    Width = 351
    Height = 14
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'lPlugInName'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    ShowAccelChar = False
  end
  object lClassName: TLabel
    Left = 0
    Top = 22
    Width = 353
    Height = 14
    Anchors = [akTop]
    AutoSize = False
    Caption = 'lClassName'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsItalic]
    ParentFont = False
    ShowAccelChar = False
  end
  object bvTopBevel: TBevel
    Left = 0
    Top = 0
    Width = 352
    Height = 2
    Align = alTop
    Shape = bsTopLine
  end
  object bvBottomBevel: TBevel
    Left = 0
    Top = 122
    Width = 352
    Height = 2
    Align = alBottom
    Shape = bsTopLine
  end
  object lAuthor: TLabel
    Left = 10
    Top = 46
    Width = 335
    Height = 14
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'lAuthor'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ShowAccelChar = False
  end
  object lSupport: TLabel
    Left = 10
    Top = 62
    Width = 335
    Height = 14
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'lSupport'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ShowAccelChar = False
  end
  object lCopyright: TLabel
    Left = 10
    Top = 78
    Width = 335
    Height = 14
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'lCopyright'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ShowAccelChar = False
  end
  object btnPlugInConfiguration: TButton
    Left = 252
    Top = 96
    Width = 80
    Height = 21
    Caption = 'Configure'
    TabOrder = 0
    OnClick = btnPlugInConfigurationClick
  end
end
