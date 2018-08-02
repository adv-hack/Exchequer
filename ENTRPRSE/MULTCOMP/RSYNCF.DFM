object Form1: TForm1
  Left = 394
  Top = 210
  Width = 356
  Height = 505
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object ccyISN1: TCurrencyEdit
    Left = 20
    Top = 14
    Width = 35
    Height = 21
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'ARIAL'
    Font.Style = []
    Lines.Strings = (
      '124 ')
    MaxLength = 3
    ParentFont = False
    TabOrder = 0
    WantReturns = False
    WordWrap = False
    AutoSize = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0 ;###,###,##0-'
    DecPlaces = 0
    ShowCurrency = False
    TextId = 0
    Value = 124
  end
  object ccyISN2: TCurrencyEdit
    Left = 55
    Top = 14
    Width = 35
    Height = 21
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'ARIAL'
    Font.Style = []
    Lines.Strings = (
      '95 ')
    MaxLength = 3
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
    Value = 95
  end
  object ccyISN3: TCurrencyEdit
    Left = 90
    Top = 14
    Width = 35
    Height = 21
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'ARIAL'
    Font.Style = []
    Lines.Strings = (
      '202 ')
    MaxLength = 3
    ParentFont = False
    TabOrder = 2
    WantReturns = False
    WordWrap = False
    AutoSize = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0 ;###,###,##0-'
    DecPlaces = 0
    ShowCurrency = False
    TextId = 0
    Value = 202
  end
  object ccyISN4: TCurrencyEdit
    Left = 125
    Top = 14
    Width = 35
    Height = 21
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'ARIAL'
    Font.Style = []
    Lines.Strings = (
      '3 ')
    MaxLength = 3
    ParentFont = False
    TabOrder = 3
    WantReturns = False
    WordWrap = False
    AutoSize = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0 ;###,###,##0-'
    DecPlaces = 0
    ShowCurrency = False
    TextId = 0
    Value = 3
  end
  object ccyISN5: TCurrencyEdit
    Left = 160
    Top = 14
    Width = 35
    Height = 21
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'ARIAL'
    Font.Style = []
    Lines.Strings = (
      '88 ')
    MaxLength = 3
    ParentFont = False
    TabOrder = 4
    WantReturns = False
    WordWrap = False
    AutoSize = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0 ;###,###,##0-'
    DecPlaces = 0
    ShowCurrency = False
    TextId = 0
    Value = 88
  end
  object ccyISN6: TCurrencyEdit
    Left = 195
    Top = 14
    Width = 35
    Height = 21
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'ARIAL'
    Font.Style = []
    Lines.Strings = (
      '176 ')
    MaxLength = 3
    ParentFont = False
    TabOrder = 5
    WantReturns = False
    WordWrap = False
    AutoSize = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0 ;###,###,##0-'
    DecPlaces = 0
    ShowCurrency = False
    TextId = 0
    Value = 176
  end
  object Button1: TButton
    Left = 249
    Top = 12
    Width = 75
    Height = 25
    Caption = 'Go'
    TabOrder = 6
    OnClick = Button1Click
  end
  object ListBox1: TListBox
    Left = 9
    Top = 46
    Width = 332
    Height = 396
    Anchors = [akLeft, akTop, akBottom]
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ItemHeight = 14
    ParentFont = False
    TabOrder = 7
    TabWidth = 100
  end
  object Button2: TButton
    Left = 8
    Top = 448
    Width = 332
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Save To c:\rsync.txt'
    TabOrder = 8
    OnClick = Button2Click
  end
end
