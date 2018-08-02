inherited CompDetail5: TCompDetail5
  Left = 230
  Top = 165
  HelpContext = 39
  ActiveControl = cpYearStart
  Caption = 'CompDetail5'
  Font.Charset = ANSI_CHARSET
  Font.Name = 'Arial'
  PixelsPerInch = 96
  TextHeight = 14
  inherited TitleLbl: TLabel
    Top = 11
    Caption = 'Company Details'
  end
  inherited InstrLbl: TLabel
    Height = 16
    Caption = 'Financial year start date'
  end
  object Label86: Label8 [3]
    Left = 167
    Top = 102
    Width = 168
    Height = 14
    Caption = 'Number of periods in financial year'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  inherited HelpBtn: TButton
    HelpContext = 10024
    TabOrder = 3
  end
  inherited Panel1: TPanel
    TabOrder = 2
  end
  inherited ExitBtn: TButton
    TabOrder = 4
  end
  inherited BackBtn: TButton
    TabOrder = 5
  end
  inherited NextBtn: TButton
    Caption = '&Finish'
    TabOrder = 6
  end
  object cpYearStart: TEditDate
    Tag = 1
    Left = 183
    Top = 66
    Width = 63
    Height = 22
    AutoSelect = False
    EditMask = '00/00/0000;0;'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 10
    ParentFont = False
    TabOrder = 0
    Placement = cpAbove
  end
  object cpPeriods: TCurrencyEdit
    Tag = 1
    Left = 183
    Top = 119
    Width = 46
    Height = 22
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      '12 ')
    MaxLength = 2
    ParentFont = False
    TabOrder = 1
    WantReturns = False
    WordWrap = False
    AutoSize = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0 ;###,###,##0-'
    DecPlaces = 0
    ShowCurrency = False
    TextId = 0
    Value = 12
  end
end
