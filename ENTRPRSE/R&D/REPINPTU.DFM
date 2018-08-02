inherited RepInpMsgT: TRepInpMsgT
  HelpContext = 675
  Caption = 'Print Transaction Stock Labels'
  ClientHeight = 186
  PixelsPerInch = 96
  TextHeight = 14
  inherited SBSPanel4: TSBSBackGroup
    Left = 6
    Width = 287
    Height = 145
  end
  object Label81: Label8 [1]
    Left = 18
    Top = 14
    Width = 253
    Height = 27
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'How many labels for each stock item?'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
    TextId = 0
  end
  inherited OkCP1Btn: TButton
    Left = 67
    Top = 158
    TabOrder = 7
  end
  inherited ClsCP1Btn: TButton
    Left = 153
    Top = 158
    TabOrder = 8
  end
  inherited SBSPanel1: TSBSPanel
    TabOrder = 0
  end
  object BR1: TBorRadio
    Left = 48
    Top = 31
    Width = 177
    Height = 20
    Align = alRight
    Caption = 'Use qty from transaction line.'
    CheckColor = clWindowText
    Checked = True
    GroupIndex = 1
    TabOrder = 1
    TabStop = True
    TextId = 0
    OnClick = BR2Click
  end
  object BR2: TBorRadio
    Left = 48
    Top = 54
    Width = 91
    Height = 20
    Align = alRight
    Caption = 'Specify qty.'
    CheckColor = clWindowText
    GroupIndex = 1
    TabOrder = 2
    TextId = 0
    OnClick = BR2Click
  end
  object LabQtyF: TCurrencyEdit
    Left = 137
    Top = 51
    Width = 46
    Height = 25
    Color = clWhite
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'ARIAL'
    Font.Style = []
    Lines.Strings = (
      '1 ')
    MaxLength = 4
    ParentFont = False
    TabOrder = 3
    WantReturns = False
    WordWrap = False
    AutoSize = False
    BlockNegative = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0 ;###,###,##0-'
    DecPlaces = 0
    ShowCurrency = False
    TextId = 0
    Value = 1
  end
  object BR3: TBorRadio
    Left = 48
    Top = 78
    Width = 177
    Height = 20
    Align = alRight
    Caption = 'Use qty picked / received.'
    CheckColor = clWindowText
    GroupIndex = 1
    TabOrder = 5
    TextId = 0
    OnClick = BR2Click
  end
  object BR4: TBorCheck
    Left = 48
    Top = 102
    Width = 156
    Height = 20
    Align = alRight
    Caption = 'Exclude Component Items'
    CheckColor = clWindowText
    Color = clBtnFace
    ParentColor = False
    TabOrder = 6
    TextId = 0
  end
  object BCSNo1: TBorCheck
    Left = 195
    Top = 54
    Width = 88
    Height = 20
    Align = alRight
    Caption = 'per Serial Item'
    CheckColor = clWindowText
    Color = clBtnFace
    Enabled = False
    ParentColor = False
    TabOrder = 4
    TextId = 0
  end
end
