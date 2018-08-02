inherited RepInpMsgQ: TRepInpMsgQ
  Caption = 'Batch Payments Report'
  PixelsPerInch = 96
  TextHeight = 14
  object Label85: Label8 [1]
    Left = 26
    Top = 34
    Width = 127
    Height = 14
    Alignment = taRightJustify
    Caption = 'Report for Batch Run No. :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label88: Label8 [2]
    Left = 64
    Top = 68
    Width = 89
    Height = 14
    Alignment = taRightJustify
    Caption = 'Summary Report : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  inherited OkCP1Btn: TButton
    TabOrder = 2
  end
  inherited ClsCP1Btn: TButton
    TabOrder = 3
  end
  inherited SBSPanel1: TSBSPanel
    TabOrder = 4
  end
  object AgeInt: TCurrencyEdit
    Left = 154
    Top = 31
    Width = 79
    Height = 22
    Hint = 
      'Enter Run Noumber.|Enter the run number of the posting report yo' +
      'u wish to reprint. 0 for unposted items, -1 for all posting runs' +
      '.'
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      '0 ')
    MaxLength = 9
    ParentFont = False
    TabOrder = 0
    WantReturns = False
    WordWrap = False
    OnKeyPress = AgeIntKeyPress
    AutoSize = False
    BlockNegative = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0 ;###,###,##0-'
    DecPlaces = 0
    ShowCurrency = False
    TextId = 0
    Value = 1E-10
  end
  object Back1: TBorCheck
    Left = 151
    Top = 64
    Width = 17
    Height = 20
    Caption = 'Summary Report : '
    CheckColor = clWindowText
    Color = clBtnFace
    ParentColor = False
    TabOrder = 1
    TabStop = True
    TextId = 0
  end
end
