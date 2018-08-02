object Form1: TForm1
  Left = 461
  Top = 197
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'SIN000001 Total Transaction Discount'
  ClientHeight = 227
  ClientWidth = 387
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel
    Left = 116
    Top = 7
    Width = 48
    Height = 14
    Alignment = taRightJustify
    Caption = 'Total Cost'
  end
  object Label3: TLabel
    Left = 16
    Top = 55
    Width = 47
    Height = 14
    Alignment = taRightJustify
    Caption = 'After TTD'
  end
  object Label4: TLabel
    Left = 8
    Top = 28
    Width = 55
    Height = 14
    Alignment = taRightJustify
    Caption = 'Before TTD'
  end
  object Label2: TLabel
    Left = 223
    Top = 7
    Width = 45
    Height = 14
    Alignment = taRightJustify
    Caption = 'NET Total'
  end
  object Label5: TLabel
    Left = 291
    Top = 7
    Width = 80
    Height = 14
    Alignment = taRightJustify
    Caption = 'NET - Settle Disc'
  end
  object Bevel1: TBevel
    Left = 4
    Top = 82
    Width = 376
    Height = 10
    Shape = bsTopLine
  end
  object Label6: TLabel
    Left = 8
    Top = 118
    Width = 291
    Height = 14
    Caption = 'Please specify the Total Transaction Discount to be applied:-'
  end
  object Label7: TLabel
    Left = 233
    Top = 172
    Width = 10
    Height = 14
    Alignment = taRightJustify
    Caption = '%'
  end
  object Bevel2: TBevel
    Left = 5
    Top = 109
    Width = 376
    Height = 10
    Shape = bsTopLine
  end
  object Label8: TLabel
    Left = 8
    Top = 90
    Width = 370
    Height = 14
    Alignment = taCenter
    AutoSize = False
    Caption = '10% Value Based Discount is available for this transaction'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Button1: TButton
    Left = 294
    Top = 151
    Width = 80
    Height = 21
    Caption = '&Apply'
    TabOrder = 0
  end
  object Button2: TButton
    Left = 294
    Top = 179
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    TabOrder = 1
  end
  object BorRadio1: TBorRadio
    Left = 30
    Top = 142
    Width = 213
    Height = 20
    Align = alRight
    Caption = 'No additional discount'
    Checked = True
    TabOrder = 2
    TabStop = True
    TextId = 0
  end
  object BorRadio2: TBorRadio
    Left = 30
    Top = 168
    Width = 133
    Height = 20
    Align = alRight
    Caption = 'Apply Percentage TTD'
    TabOrder = 3
    TextId = 0
  end
  object BorRadio3: TBorRadio
    Left = 30
    Top = 195
    Width = 112
    Height = 20
    Align = alRight
    Caption = 'Apply Value TTD'
    TabOrder = 4
    TextId = 0
  end
  object INetTotF: TCurrencyEdit
    Tag = 2
    Left = 172
    Top = 51
    Width = 100
    Height = 22
    HelpContext = 252
    TabStop = False
    Color = clPurple
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      '0.00 ')
    ParentFont = False
    ReadOnly = True
    TabOrder = 5
    WantReturns = False
    WordWrap = False
    AutoSize = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
    ShowCurrency = False
    TextId = 0
    Value = 1E-10
  end
  object CurrencyEdit1: TCurrencyEdit
    Tag = 2
    Left = 169
    Top = 169
    Width = 60
    Height = 22
    HelpContext = 252
    TabStop = False
    Color = clPurple
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      '0.00 ')
    ParentFont = False
    ReadOnly = True
    TabOrder = 6
    WantReturns = False
    WordWrap = False
    AutoSize = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
    ShowCurrency = False
    TextId = 0
    Value = 1E-10
  end
  object CurrencyEdit2: TCurrencyEdit
    Tag = 2
    Left = 169
    Top = 196
    Width = 60
    Height = 22
    HelpContext = 252
    TabStop = False
    Color = clPurple
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      '0.00 ')
    ParentFont = False
    ReadOnly = True
    TabOrder = 7
    WantReturns = False
    WordWrap = False
    AutoSize = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
    ShowCurrency = False
    TextId = 0
    Value = 1E-10
  end
  object CurrencyEdit3: TCurrencyEdit
    Tag = 2
    Left = 275
    Top = 51
    Width = 100
    Height = 22
    HelpContext = 252
    TabStop = False
    Color = clPurple
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      '0.00 ')
    ParentFont = False
    ReadOnly = True
    TabOrder = 8
    WantReturns = False
    WordWrap = False
    AutoSize = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
    ShowCurrency = False
    TextId = 0
    Value = 1E-10
  end
  object CurrencyEdit4: TCurrencyEdit
    Tag = 2
    Left = 68
    Top = 51
    Width = 100
    Height = 22
    HelpContext = 252
    TabStop = False
    Color = clPurple
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      '0.00 ')
    ParentFont = False
    ReadOnly = True
    TabOrder = 9
    WantReturns = False
    WordWrap = False
    AutoSize = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
    ShowCurrency = False
    TextId = 0
    Value = 1E-10
  end
  object CurrencyEdit5: TCurrencyEdit
    Tag = 2
    Left = 172
    Top = 25
    Width = 100
    Height = 22
    HelpContext = 252
    TabStop = False
    Color = clPurple
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      '0.00 ')
    ParentFont = False
    ReadOnly = True
    TabOrder = 10
    WantReturns = False
    WordWrap = False
    AutoSize = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
    ShowCurrency = False
    TextId = 0
    Value = 1E-10
  end
  object CurrencyEdit6: TCurrencyEdit
    Tag = 2
    Left = 275
    Top = 25
    Width = 100
    Height = 22
    HelpContext = 252
    TabStop = False
    Color = clPurple
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      '0.00 ')
    ParentFont = False
    ReadOnly = True
    TabOrder = 11
    WantReturns = False
    WordWrap = False
    AutoSize = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
    ShowCurrency = False
    TextId = 0
    Value = 1E-10
  end
  object CurrencyEdit7: TCurrencyEdit
    Tag = 2
    Left = 68
    Top = 25
    Width = 100
    Height = 22
    HelpContext = 252
    TabStop = False
    Color = clPurple
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      '0.00 ')
    ParentFont = False
    ReadOnly = True
    TabOrder = 12
    WantReturns = False
    WordWrap = False
    AutoSize = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
    ShowCurrency = False
    TextId = 0
    Value = 1E-10
  end
end
