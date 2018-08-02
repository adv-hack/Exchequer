object CredLimForm: TCredLimForm
  Left = 675
  Top = 229
  ActiveControl = OkCP1Btn
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Credit Check'
  ClientHeight = 259
  ClientWidth = 275
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  Scaled = False
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object SBSPanel1: TSBSPanel
    Left = 7
    Top = 9
    Width = 260
    Height = 220
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
    object Label81: Label8
      Left = 120
      Top = 22
      Width = 62
      Height = 16
      Caption = 'WARNING'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TextId = 0
    end
    object Label82: Label8
      Left = 67
      Top = 43
      Width = 179
      Height = 14
      Alignment = taCenter
      AutoSize = False
      Caption = 'Account Over Credit Limit'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object CrLimit: Label8
      Left = 75
      Top = 84
      Width = 52
      Height = 14
      Caption = 'Credit Limit'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object ComitBal: Label8
      Left = 17
      Top = 143
      Width = 110
      Height = 14
      Caption = 'Committed Outstanding'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Label83: Label8
      Left = 49
      Top = 113
      Width = 78
      Height = 14
      Caption = 'Current Balance'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Label84: Label8
      Left = 52
      Top = 172
      Width = 74
      Height = 14
      Caption = 'Credit Available'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Image1: TImage
      Left = 10
      Top = 6
      Width = 53
      Height = 73
    end
    object Label85: Label8
      Left = 48
      Top = 197
      Width = 79
      Height = 14
      Alignment = taRightJustify
      AutoSize = False
      Caption = ' Weeks overdue'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object CLF: TCurrencyEdit
      Left = 131
      Top = 79
      Width = 100
      Height = 22
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
    object CBF: TCurrencyEdit
      Left = 131
      Top = 109
      Width = 100
      Height = 22
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
    object COF: TCurrencyEdit
      Left = 131
      Top = 138
      Width = 100
      Height = 22
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
    object CAF: TCurrencyEdit
      Left = 131
      Top = 168
      Width = 100
      Height = 22
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
    object SBSPanel2: TSBSPanel
      Left = 66
      Top = 13
      Width = 185
      Height = 52
      TabOrder = 4
      AllowReSize = False
      IsGroupBox = False
      TextId = 0
      object CLMsgL: Label8
        Left = 3
        Top = 30
        Width = 179
        Height = 14
        Alignment = taCenter
        AutoSize = False
        Caption = 'Account Over Credit Limit'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label86: Label8
        Left = 4
        Top = 9
        Width = 62
        Height = 16
        Alignment = taCenter
        Caption = 'WARNING'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TextId = 0
      end
    end
    object CWOF: TCurrencyEdit
      Left = 131
      Top = 194
      Width = 100
      Height = 22
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        '0 ')
      ParentFont = False
      ReadOnly = True
      TabOrder = 5
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
  object OkCP1Btn: TButton
    Tag = 1
    Left = 100
    Top = 234
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
end
