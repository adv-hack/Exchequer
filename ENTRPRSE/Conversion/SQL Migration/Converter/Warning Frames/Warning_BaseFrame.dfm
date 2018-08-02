object WarningBaseFrame: TWarningBaseFrame
  Left = 0
  Top = 0
  Width = 721
  Height = 150
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  ParentFont = False
  TabOrder = 0
  DesignSize = (
    721
    150)
  object lblWarningDescription: TLabel
    Left = 5
    Top = 5
    Width = 464
    Height = 15
    AutoSize = False
    Caption = 'lblWarningDescription'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblDumpFileLink: TLabel
    Left = 472
    Top = 6
    Width = 238
    Height = 14
    Cursor = crHandPoint
    Alignment = taRightJustify
    Anchors = [akTop, akRight]
    AutoSize = False
    Caption = 'lblDumpFileLink'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsUnderline]
    ParentFont = False
    OnClick = lblDumpFileLinkClick
  end
  object Label1: TLabel
    Left = 21
    Top = 24
    Width = 56
    Height = 13
    AutoSize = False
    Caption = 'Company: '
  end
  object lblCompany: TLabel
    Left = 82
    Top = 24
    Width = 626
    Height = 13
    AutoSize = False
    Caption = '<CompanyCode> (<Company Path>)'
  end
end
