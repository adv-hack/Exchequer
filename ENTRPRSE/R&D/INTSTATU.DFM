object IntStatInv: TIntStatInv
  Left = 204
  Top = 176
  HelpContext = 282
  ActiveControl = ISDelF
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Intrastat Details'
  ClientHeight = 157
  ClientWidth = 252
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  Scaled = False
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 14
  object Label84: Label8
    Left = 23
    Top = 4
    Width = 206
    Height = 14
    Caption = 'EC Trader - Complete Intrastat Details'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TextId = 0
  end
  object SBSPanel1: TSBSPanel
    Left = 3
    Top = 20
    Width = 244
    Height = 109
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
    object Label81: Label8
      Left = 65
      Top = 8
      Width = 71
      Height = 14
      Caption = 'Delivery Terms'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Label82: Label8
      Left = 53
      Top = 31
      Width = 83
      Height = 14
      Caption = 'Transaction Type'
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
      Top = 54
      Width = 89
      Height = 14
      Caption = 'Mode of Transport'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object ISDelF: Text8Pt
      Tag = 1
      Left = 140
      Top = 5
      Width = 44
      Height = 22
      Color = clWhite
      EditMask = '>ccc;0; '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      MaxLength = 3
      ParentFont = False
      ParentShowHint = False
      ReadOnly = True
      ShowHint = True
      TabOrder = 0
      OnExit = ISDelFExit
      TextId = 0
      ViaSBtn = False
    end
    object ISTTF: TCurrencyEdit
      Tag = 1
      Left = 140
      Top = 28
      Width = 33
      Height = 22
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        '0 ')
      MaxLength = 2
      ParentFont = False
      ReadOnly = True
      TabOrder = 1
      WantReturns = False
      WordWrap = False
      OnExit = ISTTFExit
      AutoSize = False
      BlockNegative = False
      BlankOnZero = False
      DisplayFormat = '###,###,##0 ;###,###,##0-'
      DecPlaces = 0
      ShowCurrency = False
      TextId = 0
      Value = 1E-10
    end
    object ISMTF: TCurrencyEdit
      Tag = 1
      Left = 140
      Top = 51
      Width = 33
      Height = 22
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        '0 ')
      MaxLength = 2
      ParentFont = False
      ReadOnly = True
      TabOrder = 2
      WantReturns = False
      WordWrap = False
      OnExit = ISMTFExit
      AutoSize = False
      BlockNegative = False
      BlankOnZero = False
      DisplayFormat = '###,###,##0 ;###,###,##0-'
      DecPlaces = 0
      ShowCurrency = False
      TextId = 0
      Value = 1E-10
    end
    object ISPTF: TSBSComboBox
      Tag = 1
      Left = 42
      Top = 77
      Width = 145
      Height = 22
      Style = csDropDownList
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ItemHeight = 14
      ParentFont = False
      TabOrder = 3
      Items.Strings = (
        'Normal Transaction'
        'Triangulation Transaction'
        'Process Transaction')
      MaxListWidth = 0
      ReadOnly = True
    end
  end
  object ClsCP1Btn: TButton
    Left = 129
    Top = 134
    Width = 80
    Height = 21
    Cancel = True
    Caption = 'C&lose'
    ModalResult = 2
    TabOrder = 2
  end
  object OkCP1Btn: TButton
    Tag = 1
    Left = 44
    Top = 134
    Width = 80
    Height = 21
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 1
    OnClick = OkCP1BtnClick
  end
end
