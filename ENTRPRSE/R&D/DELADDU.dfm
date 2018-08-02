object DelAddrPop: TDelAddrPop
  Left = 620
  Top = 198
  HelpContext = 245
  ActiveControl = ADL1F
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Delivery Address'
  ClientHeight = 196
  ClientWidth = 400
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  Scaled = False
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 14
  object lblLine1: TLabel
    Left = 2
    Top = 8
    Width = 57
    Height = 14
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Line 1'
  end
  object lblLine2: TLabel
    Left = 2
    Top = 31
    Width = 57
    Height = 14
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Line 2'
  end
  object lblLine3: TLabel
    Left = 2
    Top = 54
    Width = 57
    Height = 14
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Line 3'
  end
  object lblLine4: TLabel
    Left = 2
    Top = 77
    Width = 57
    Height = 14
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Town'
  end
  object lblLine5: TLabel
    Left = 2
    Top = 100
    Width = 57
    Height = 14
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'County'
  end
  object OkCP1Btn: TButton
    Tag = 1
    Left = 117
    Top = 171
    Width = 80
    Height = 21
    Caption = '&OK'
    TabOrder = 0
    OnClick = OkCP1BtnClick
  end
  object ClsCP1Btn: TButton
    Left = 202
    Top = 171
    Width = 80
    Height = 21
    Cancel = True
    Caption = 'C&lose'
    ModalResult = 2
    TabOrder = 1
  end
  object ADL1F: Text8Pt
    Tag = 1
    Left = 62
    Top = 5
    Width = 332
    Height = 22
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 30
    ParentFont = False
    ParentShowHint = False
    ReadOnly = True
    ShowHint = True
    TabOrder = 2
    OnKeyPress = ADL1FKeyPress
    TextId = 0
    ViaSBtn = False
    GDPREnabled = True
  end
  object ADL2F: Text8Pt
    Tag = 1
    Left = 62
    Top = 28
    Width = 332
    Height = 22
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 30
    ParentFont = False
    ParentShowHint = False
    ReadOnly = True
    ShowHint = True
    TabOrder = 3
    OnKeyPress = ADL1FKeyPress
    TextId = 0
    ViaSBtn = False
    GDPREnabled = True
  end
  object ADL3F: Text8Pt
    Tag = 1
    Left = 62
    Top = 51
    Width = 332
    Height = 22
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 30
    ParentFont = False
    ParentShowHint = False
    ReadOnly = True
    ShowHint = True
    TabOrder = 4
    OnKeyPress = ADL1FKeyPress
    TextId = 0
    ViaSBtn = False
    GDPREnabled = True
  end
  object ADL4F: Text8Pt
    Tag = 1
    Left = 62
    Top = 74
    Width = 332
    Height = 22
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 30
    ParentFont = False
    ParentShowHint = False
    ReadOnly = True
    ShowHint = True
    TabOrder = 5
    OnKeyPress = ADL1FKeyPress
    TextId = 0
    ViaSBtn = False
    GDPREnabled = True
  end
  object ADL5F: Text8Pt
    Tag = 1
    Left = 62
    Top = 97
    Width = 332
    Height = 22
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 30
    ParentFont = False
    ParentShowHint = False
    ReadOnly = True
    ShowHint = True
    TabOrder = 6
    OnKeyPress = ADL1FKeyPress
    TextId = 0
    ViaSBtn = False
    GDPREnabled = True
  end
  object PostCodePnl: TPanel
    Left = 0
    Top = 120
    Width = 397
    Height = 48
    BevelOuter = bvNone
    TabOrder = 7
    object Label1: TLabel
      Left = 11
      Top = 6
      Width = 48
      Height = 14
      Caption = 'Post code'
    end
    object Label821: Label8
      Left = 21
      Top = 30
      Width = 38
      Height = 14
      Caption = 'Country'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object PostCodeTxt: Text8Pt
      Tag = 1
      Left = 62
      Top = 1
      Width = 150
      Height = 22
      CharCase = ecUpperCase
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      MaxLength = 20
      ParentFont = False
      ParentShowHint = False
      ReadOnly = True
      ShowHint = True
      TabOrder = 0
      OnKeyPress = ADL1FKeyPress
      TextId = 0
      ViaSBtn = False
      GDPREnabled = True
    end
    object lstCountry: TSBSComboBox
      Tag = 1
      Left = 62
      Top = 25
      Width = 279
      Height = 22
      HelpContext = 111
      Style = csDropDownList
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ItemHeight = 14
      MaxLength = 3
      ParentFont = False
      TabOrder = 1
      ExtendedList = True
      MaxListWidth = 220
      ReadOnly = True
      Validate = True
    end
  end
  object SpellCheck4Modal1: TSpellCheck4Modal
    Version = 'TSpellCheck4Modal v5.70.001 for Delphi 6.01'
    Left = 240
    Top = 90
  end
end