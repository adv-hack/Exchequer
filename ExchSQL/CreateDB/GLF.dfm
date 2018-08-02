object frmGLs: TfrmGLs
  Left = 432
  Top = 160
  BorderStyle = bsDialog
  Caption = 'General Ledger Codes'
  ClientHeight = 295
  ClientWidth = 360
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 257
    Height = 281
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    object Label1: TLabel
      Left = 118
      Top = 20
      Width = 26
      Height = 13
      Alignment = taRightJustify
      Caption = 'Sales'
    end
    object Label2: TLabel
      Left = 82
      Top = 52
      Width = 62
      Height = 13
      Alignment = taRightJustify
      Caption = 'Cost of Sales'
    end
    object Label3: TLabel
      Left = 27
      Top = 84
      Width = 117
      Height = 13
      Alignment = taRightJustify
      Caption = 'Closing Stock/Write Offs'
    end
    object Label4: TLabel
      Left = 86
      Top = 116
      Width = 58
      Height = 13
      Alignment = taRightJustify
      Caption = 'Stock Value'
    end
    object Label5: TLabel
      Left = 42
      Top = 148
      Width = 102
      Height = 13
      Alignment = taRightJustify
      Caption = 'BOM/Finished Goods'
    end
    object Label6: TLabel
      Left = 76
      Top = 180
      Width = 68
      Height = 13
      Alignment = taRightJustify
      Caption = 'Bank Account'
    end
    object Label7: TLabel
      Left = 78
      Top = 212
      Width = 66
      Height = 13
      Alignment = taRightJustify
      Caption = 'Sales Returns'
    end
    object Label8: TLabel
      Left = 59
      Top = 244
      Width = 85
      Height = 13
      Alignment = taRightJustify
      Caption = 'Purchase Returns'
    end
    object ceSales: TCurrencyEdit
      Left = 160
      Top = 16
      Width = 80
      Height = 21
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'ARIAL'
      Font.Style = []
      Lines.Strings = (
        '0')
      ParentFont = False
      TabOrder = 0
      WantReturns = False
      WordWrap = False
      AutoSize = False
      BlankOnZero = False
      DisplayFormat = '########0'
      ShowCurrency = False
      TextId = 0
      Value = 1E-10
    end
    object ceCOS: TCurrencyEdit
      Left = 160
      Top = 48
      Width = 80
      Height = 21
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'ARIAL'
      Font.Style = []
      Lines.Strings = (
        '0')
      ParentFont = False
      TabOrder = 1
      WantReturns = False
      WordWrap = False
      AutoSize = False
      BlankOnZero = False
      DisplayFormat = '########0'
      ShowCurrency = False
      TextId = 0
      Value = 1E-10
    end
    object ceClosing: TCurrencyEdit
      Left = 160
      Top = 80
      Width = 80
      Height = 21
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'ARIAL'
      Font.Style = []
      Lines.Strings = (
        '0')
      ParentFont = False
      TabOrder = 2
      WantReturns = False
      WordWrap = False
      AutoSize = False
      BlankOnZero = False
      DisplayFormat = '########0'
      ShowCurrency = False
      TextId = 0
      Value = 1E-10
    end
    object ceStockVal: TCurrencyEdit
      Left = 160
      Top = 112
      Width = 80
      Height = 21
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'ARIAL'
      Font.Style = []
      Lines.Strings = (
        '0')
      ParentFont = False
      TabOrder = 3
      WantReturns = False
      WordWrap = False
      AutoSize = False
      BlankOnZero = False
      DisplayFormat = '########0'
      ShowCurrency = False
      TextId = 0
      Value = 1E-10
    end
    object ceBOM: TCurrencyEdit
      Left = 160
      Top = 144
      Width = 80
      Height = 21
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'ARIAL'
      Font.Style = []
      Lines.Strings = (
        '0')
      ParentFont = False
      TabOrder = 4
      WantReturns = False
      WordWrap = False
      AutoSize = False
      BlankOnZero = False
      DisplayFormat = '########0'
      ShowCurrency = False
      TextId = 0
      Value = 1E-10
    end
    object ceBank: TCurrencyEdit
      Left = 160
      Top = 176
      Width = 80
      Height = 21
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'ARIAL'
      Font.Style = []
      Lines.Strings = (
        '0')
      ParentFont = False
      TabOrder = 5
      WantReturns = False
      WordWrap = False
      AutoSize = False
      BlankOnZero = False
      DisplayFormat = '########0'
      ShowCurrency = False
      TextId = 0
      Value = 1E-10
    end
    object ceSalesRet: TCurrencyEdit
      Left = 160
      Top = 208
      Width = 80
      Height = 21
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'ARIAL'
      Font.Style = []
      Lines.Strings = (
        '0')
      ParentFont = False
      TabOrder = 6
      WantReturns = False
      WordWrap = False
      AutoSize = False
      BlankOnZero = False
      DisplayFormat = '########0'
      ShowCurrency = False
      TextId = 0
      Value = 1E-10
    end
    object cePurchRet: TCurrencyEdit
      Left = 160
      Top = 240
      Width = 80
      Height = 21
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'ARIAL'
      Font.Style = []
      Lines.Strings = (
        '0')
      ParentFont = False
      TabOrder = 7
      WantReturns = False
      WordWrap = False
      AutoSize = False
      BlankOnZero = False
      DisplayFormat = '########0'
      ShowCurrency = False
      TextId = 0
      Value = 1E-10
    end
  end
  object SBSButton1: TSBSButton
    Left = 272
    Top = 8
    Width = 80
    Height = 21
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 1
    TextId = 0
  end
  object SBSButton2: TSBSButton
    Left = 272
    Top = 32
    Width = 80
    Height = 21
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 2
    TextId = 0
  end
end
