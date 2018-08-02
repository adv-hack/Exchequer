inherited JGenValFilt: TJGenValFilt
  HelpContext = 1121
  Caption = 'Generate Valuation'
  ClientHeight = 208
  ClientWidth = 301
  PixelsPerInch = 96
  TextHeight = 14
  inherited SBSPanel4: TSBSBackGroup
    Left = 7
    Top = 4
    Height = 163
  end
  object Label86: Label8 [1]
    Left = 12
    Top = 16
    Width = 277
    Height = 35
    AutoSize = False
    Caption = 'Generate Valuation'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -24
    Font.Name = 'Arial'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
    TextId = 0
  end
  object Label81: Label8 [2]
    Left = 34
    Top = 92
    Width = 103
    Height = 14
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Round to the nearest'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label82: Label8 [3]
    Left = 34
    Top = 122
    Width = 103
    Height = 14
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Base valuation on'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  inherited OkCP1Btn: TButton
    Top = 176
    TabOrder = 4
  end
  inherited ClsCP1Btn: TButton
    Top = 176
    TabOrder = 5
  end
  inherited SBSPanel1: TSBSPanel
    Top = 162
    TabOrder = 0
  end
  object PCOMChk: TBorCheck
    Left = 40
    Top = 60
    Width = 117
    Height = 20
    HelpContext = 1122
    Caption = 'Round down value'
    CheckColor = clWindowText
    Color = clBtnFace
    ParentColor = False
    TabOrder = 1
    TabStop = True
    TextId = 0
  end
  object Roundcb: TSBSComboBox
    Left = 144
    Top = 88
    Width = 99
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
    Text = '2 decimal places'
    Items.Strings = (
      '2 decimal places'
      '1'
      '10'
      '100'
      '1000')
    MaxListWidth = 0
  end
  object PJDChk: TSBSComboBox
    Left = 144
    Top = 118
    Width = 121
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
    TabOrder = 3
    Text = 'Actual Costs'
    Items.Strings = (
      'Actual Costs'
      'Actuals + Committed'
      'Committed Costs')
    MaxListWidth = 0
  end
end
