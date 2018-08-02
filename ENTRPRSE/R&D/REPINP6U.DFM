inherited RepInpMsg6: TRepInpMsg6
  Left = 343
  Top = 190
  HelpContext = 715
  Caption = 'Posting Report'
  PixelsPerInch = 96
  TextHeight = 14
  object Label85: Label8 [1]
    Left = 19
    Top = 44
    Width = 134
    Height = 14
    Alignment = taRightJustify
    Caption = 'Report for Posting Run No. :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  inherited OkCP1Btn: TButton
    TabOrder = 1
  end
  inherited ClsCP1Btn: TButton
    TabOrder = 3
  end
  object AgeInt: TCurrencyEdit
    Left = 154
    Top = 39
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
    BlockNegative = True
    BlankOnZero = False
    DisplayFormat = '###,###,##0 ;###,###,##0-'
    DecPlaces = 0
    ShowCurrency = False
    TextId = 0
    Value = 1E-10
  end
end
