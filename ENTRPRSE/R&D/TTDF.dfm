object frmTTDOffer: TfrmTTDOffer
  Left = 394
  Top = 219
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'SIN000001 Total Transaction Discount'
  ClientHeight = 251
  ClientWidth = 404
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Scaled = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object lblTotalCost: TLabel
    Left = 132
    Top = 7
    Width = 47
    Height = 14
    Alignment = taRightJustify
    Caption = 'Total Cost'
  end
  object Label3: TLabel
    Left = 38
    Top = 55
    Width = 47
    Height = 14
    Alignment = taRightJustify
    Caption = 'After TTD'
  end
  object Label4: TLabel
    Left = 30
    Top = 28
    Width = 55
    Height = 14
    Alignment = taRightJustify
    Caption = 'Before TTD'
  end
  object Label2: TLabel
    Left = 239
    Top = 7
    Width = 44
    Height = 14
    Alignment = taRightJustify
    Caption = 'NET Total'
  end
  object lblNetLessSettle: TLabel
    Left = 307
    Top = 7
    Width = 80
    Height = 14
    Alignment = taRightJustify
    Caption = 'NET - Settle Disc'
  end
  object lblDiscountApplied: TLabel
    Left = 5
    Top = 81
    Width = 80
    Height = 14
    Alignment = taRightJustify
    Caption = 'Discount Applied'
  end
  object edtAfterNetTotal: TCurrencyEdit
    Tag = 2
    Left = 194
    Top = 51
    Width = 100
    Height = 22
    HelpContext = 252
    TabStop = False
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      '0.00 ')
    ParentFont = False
    ReadOnly = True
    TabOrder = 0
    WantReturns = False
    WordWrap = False
    AutoSize = False
    BlockNegative = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
    ShowCurrency = False
    TextId = 0
    Value = 1E-10
  end
  object edtAfterNetLessSettle: TCurrencyEdit
    Tag = 2
    Left = 298
    Top = 51
    Width = 100
    Height = 22
    HelpContext = 252
    TabStop = False
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      '0.00 ')
    ParentFont = False
    ReadOnly = True
    TabOrder = 1
    WantReturns = False
    WordWrap = False
    AutoSize = False
    BlockNegative = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
    ShowCurrency = False
    TextId = 0
    Value = 1E-10
  end
  object edtAfterTotalCost: TCurrencyEdit
    Tag = 2
    Left = 90
    Top = 51
    Width = 100
    Height = 22
    HelpContext = 252
    TabStop = False
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      '0.00 ')
    ParentFont = False
    ReadOnly = True
    TabOrder = 2
    WantReturns = False
    WordWrap = False
    AutoSize = False
    BlockNegative = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
    ShowCurrency = False
    TextId = 0
    Value = 1E-10
  end
  object edtBeforeNetTotal: TCurrencyEdit
    Tag = 2
    Left = 194
    Top = 25
    Width = 100
    Height = 22
    HelpContext = 252
    TabStop = False
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      '0.00 ')
    ParentFont = False
    ReadOnly = True
    TabOrder = 3
    WantReturns = False
    WordWrap = False
    AutoSize = False
    BlockNegative = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
    ShowCurrency = False
    TextId = 0
    Value = 1E-10
  end
  object edtBeforeNetLessSettle: TCurrencyEdit
    Tag = 2
    Left = 298
    Top = 25
    Width = 100
    Height = 22
    HelpContext = 252
    TabStop = False
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      '0.00 ')
    ParentFont = False
    ReadOnly = True
    TabOrder = 4
    WantReturns = False
    WordWrap = False
    AutoSize = False
    BlockNegative = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
    ShowCurrency = False
    TextId = 0
    Value = 1E-10
  end
  object edtBeforeTotalCost: TCurrencyEdit
    Tag = 2
    Left = 90
    Top = 25
    Width = 100
    Height = 22
    HelpContext = 252
    TabStop = False
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
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
    BlockNegative = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
    ShowCurrency = False
    TextId = 0
    Value = 1E-10
  end
  object panVBDNotifcation: TPanel
    Left = 0
    Top = 103
    Width = 404
    Height = 27
    BevelOuter = bvNone
    TabOrder = 6
    DesignSize = (
      404
      27)
    object Bevel1: TBevel
      Left = 5
      Top = 1
      Width = 394
      Height = 10
      Anchors = [akLeft, akTop, akRight]
      Shape = bsTopLine
    end
    object lblVBDOffer: TLabel
      Left = 6
      Top = 9
      Width = 392
      Height = 14
      Alignment = taCenter
      AutoSize = False
      Caption = '10% Value Based Discount is available for this transaction'
      Font.Charset = ANSI_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object panTTDOffer: TPanel
    Left = 0
    Top = 130
    Width = 404
    Height = 119
    BevelOuter = bvNone
    TabOrder = 7
    DesignSize = (
      404
      119)
    object Label6: TLabel
      Left = 8
      Top = 12
      Width = 290
      Height = 14
      Caption = 'Please specify the Total Transaction Discount to be applied:-'
    end
    object Label7: TLabel
      Left = 233
      Top = 66
      Width = 10
      Height = 14
      Alignment = taRightJustify
      Caption = '%'
    end
    object Bevel2: TBevel
      Left = 5
      Top = 3
      Width = 394
      Height = 10
      Anchors = [akLeft, akTop, akRight]
      Shape = bsTopLine
    end
    object btnApplyTTD: TButton
      Left = 315
      Top = 62
      Width = 80
      Height = 21
      Caption = '&Apply'
      TabOrder = 0
      OnClick = btnApplyTTDClick
    end
    object btnCancel: TButton
      Left = 315
      Top = 90
      Width = 80
      Height = 21
      Cancel = True
      Caption = '&Cancel'
      ModalResult = 2
      TabOrder = 1
    end
    object radNoTTD: TBorRadio
      Left = 30
      Top = 36
      Width = 213
      Height = 20
      Align = alRight
      Caption = 'Do not apply Total Transaction Discount'
      CheckColor = clWindowText
      Checked = True
      TabOrder = 2
      TabStop = True
      TextId = 0
      OnClick = DoClickyClicky
    end
    object radPercentageTTD: TBorRadio
      Left = 30
      Top = 62
      Width = 133
      Height = 20
      Align = alRight
      Caption = 'Apply Percentage TTD'
      CheckColor = clWindowText
      TabOrder = 3
      TextId = 0
      OnClick = DoClickyClicky
    end
    object radValueTTD: TBorRadio
      Left = 30
      Top = 89
      Width = 112
      Height = 20
      Align = alRight
      Caption = 'Apply Value TTD'
      CheckColor = clWindowText
      TabOrder = 4
      TextId = 0
      OnClick = DoClickyClicky
    end
    object edtTTDPercentage: TCurrencyEdit
      Tag = 2
      Left = 169
      Top = 63
      Width = 60
      Height = 22
      HelpContext = 252
      TabStop = False
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        '0.00 ')
      ParentFont = False
      TabOrder = 5
      WantReturns = False
      WordWrap = False
      OnChange = edtTTDPercentageChange
      OnKeyPress = edtTTDPercentageKeyPress
      AutoSize = False
      BlockNegative = False
      BlankOnZero = False
      DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
      ShowCurrency = False
      TextId = 0
      Value = 1E-10
    end
    object edtTTDValue: TCurrencyEdit
      Tag = 2
      Left = 169
      Top = 90
      Width = 60
      Height = 22
      HelpContext = 252
      TabStop = False
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        '0.00 ')
      ParentFont = False
      TabOrder = 6
      WantReturns = False
      WordWrap = False
      OnChange = edtTTDValueChange
      OnKeyPress = edtTTDValueKeyPress
      AutoSize = False
      BlockNegative = False
      BlankOnZero = False
      DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
      ShowCurrency = False
      TextId = 0
      Value = 1E-10
    end
  end
  object edtDiscountApplied: TCurrencyEdit
    Tag = 2
    Left = 194
    Top = 77
    Width = 100
    Height = 22
    HelpContext = 252
    TabStop = False
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
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
    BlockNegative = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
    ShowCurrency = False
    TextId = 0
    Value = 1E-10
  end
  object EnterToTab1: TEnterToTab
    ConvertEnters = True
    OverrideFont = True
    Version = 'TEnterToTab v1.02 for Delphi 6.01'
    Left = 343
    Top = 122
  end
  object tmBlinky: TTimer
    Enabled = False
    Interval = 500
    OnTimer = tmBlinkyTimer
    Left = 313
    Top = 81
  end
end
