inherited UnpostRInp: TUnpostRInp
  Left = 680
  Top = 255
  HelpContext = 715
  Caption = 'Unpost by Posting Run Number'
  ClientHeight = 175
  PixelsPerInch = 96
  TextHeight = 14
  inherited SBSPanel4: TSBSBackGroup
    Height = 95
  end
  object Label84: Label8 [1]
    Left = 23
    Top = 39
    Width = 84
    Height = 14
    Alignment = taRightJustify
    Caption = 'Unpost from Run '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label81: Label8 [2]
    Left = 171
    Top = 39
    Width = 11
    Height = 14
    Alignment = taRightJustify
    Caption = 'To'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  inherited OkCP1Btn: TButton
    Top = 107
    TabOrder = 2
  end
  inherited ClsCP1Btn: TButton
    Top = 107
    TabOrder = 3
  end
  inherited SBSPanel1: TSBSPanel
    TabOrder = 1
  end
  object PostFF: TCurrencyEdit
    Left = 110
    Top = 36
    Width = 54
    Height = 22
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'ARIAL'
    Font.Style = []
    Lines.Strings = (
      '0 ')
    ParentFont = False
    TabOrder = 0
    WantReturns = False
    WordWrap = False
    AutoSize = False
    BlockNegative = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0 ;###,###,##0-'
    DecPlaces = 0
    ShowCurrency = False
    TextId = 0
    Value = 1E-10
  end
  object Post2F: TCurrencyEdit
    Left = 189
    Top = 36
    Width = 54
    Height = 22
    TabStop = False
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'ARIAL'
    Font.Style = []
    Lines.Strings = (
      '0 ')
    ParentFont = False
    ReadOnly = True
    TabOrder = 4
    WantReturns = False
    WordWrap = False
    AutoSize = False
    BlockNegative = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0 ;###,###,##0-'
    DecPlaces = 0
    ShowCurrency = False
    TextId = 0
    Value = 1E-10
  end
end
