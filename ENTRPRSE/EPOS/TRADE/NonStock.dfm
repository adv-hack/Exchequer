object FrmNonStockItem: TFrmNonStockItem
  Left = 303
  Top = 174
  HelpContext = 9
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Non-Stock Item'
  ClientHeight = 393
  ClientWidth = 450
  Color = clNavy
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Arial Narrow'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  DesignSize = (
    450
    393)
  PixelsPerInch = 96
  TextHeight = 16
  object Label2: TLabel
    Left = 8
    Top = 236
    Width = 45
    Height = 16
    Caption = 'Quantity'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -13
    Font.Name = 'Arial Narrow'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object Shape1: TShape
    Left = 78
    Top = 16
    Width = 3
    Height = 244
    Pen.Style = psClear
  end
  object Label5: TLabel
    Left = 8
    Top = 20
    Width = 61
    Height = 16
    Caption = 'Description'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -13
    Font.Name = 'Arial Narrow'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object Label1: TLabel
    Left = 8
    Top = 172
    Width = 26
    Height = 16
    Caption = 'Price'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -13
    Font.Name = 'Arial Narrow'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object lVATRate: TLabel
    Left = 8
    Top = 204
    Width = 44
    Height = 16
    Caption = 'Vat Rate'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -13
    Font.Name = 'Arial Narrow'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object lInclusive: TLabel
    Left = 251
    Top = 172
    Width = 68
    Height = 16
    Caption = 'Vat Inclusive'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -13
    Font.Name = 'Arial Narrow'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
    OnClick = lInclusiveClick
    OnDblClick = lInclusiveClick
  end
  object btnOK: TIAeverButton
    Left = 256
    Top = 352
    Width = 90
    Height = 33
    Caption = 'OK'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial Narrow'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 11
    OnClick = btnOKClick
    ButtonAngle = 1800
    ButtonWidth = 90
    ButtonHeight = 33
    CaptionAngle = 0
    ButtonKind = bkRoundRect
    ButtonDepth = 4
    MainBitmap.Data = {
      36030000424D3603000000000000360000002800000010000000100000000100
      1800000000000003000000000000000000000000000000000000C0C0C0C0C0C0
      C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
      C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
      C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
      C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
      C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
      C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
      C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
      C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
      C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
      C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
      C0C0C0C0C0C0C0C0C0C0C0C0C0000080000080C0C0C0C0C0C0C0C0C0C0C0C000
      0080000080000080000080000080C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0000080
      000080C0C0C0C0C0C0C0C0C0C0C0C0000080000080000080000080000080C0C0
      C0C0C0C0C0C0C0C0C0C0C0C0C0000080000080C0C0C0C0C0C0C0C0C0C0C0C0C0
      C0C0C0C0C0C0C0C0000080000080C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0000080
      000080000080000080C0C0C0C0C0C0000080000080000080000080000080C0C0
      C0C0C0C0C0C0C0C0C0C0C0C0C0000080000080000080000080C0C0C0C0C0C000
      0080000080000080000080000080C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0000080
      000080C0C0C0C0C0C0C0C0C0C0C0C0000080000080C0C0C0000080000080C0C0
      C0C0C0C0C0C0C0C0C0C0C0C0C0000080000080000080000080000080C0C0C000
      0080000080000080000080000080C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0000080
      000080000080000080000080C0C0C0000080000080000080000080000080C0C0
      C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
      C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0}
    Transparent = True
    BitmapHAlign = haNone
    BitmapVAlign = vaNone
    UserRGNAUTO = True
    RotationPointX = 0
    RotationPointY = 0
    Rotated = False
    CaptionFixed = False
    GradientFixed = False
    GradientBitmapLine = 0
    Caption3dKind = ckPressed
    RadiusRatio = 0.5
    ArcAngle = 2.0943951023932
  end
  object btnCancel: TIAeverButton
    Left = 352
    Top = 352
    Width = 90
    Height = 33
    Cancel = True
    Caption = 'Cancel'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial Narrow'
    Font.Style = [fsBold]
    ModalResult = 2
    ParentFont = False
    TabOrder = 12
    ButtonAngle = 1800
    ButtonWidth = 90
    ButtonHeight = 33
    CaptionAngle = 0
    ButtonKind = bkRoundRect
    ButtonDepth = 4
    MainBitmap.Data = {
      36030000424D3603000000000000360000002800000010000000100000000100
      1800000000000003000000000000000000000000000000000000C0C0C0C0C0C0
      C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
      C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
      C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
      C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
      C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
      C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
      C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
      C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
      C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
      C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
      C0C0C0C0C0C0C0C0C0C0C0C0C0000080000080000080000080C0C0C000008000
      0080000080000080C0C0C0000080000080000080000080C0C0C0C0C0C0000080
      000080000080000080C0C0C0000080000080000080000080C0C0C00000800000
      80000080000080C0C0C0C0C0C0000080000080C0C0C0C0C0C0C0C0C0C0C0C0C0
      C0C0000080000080C0C0C0000080000080C0C0C0C0C0C0C0C0C0C0C0C0000080
      000080000080000080C0C0C0000080000080000080000080C0C0C00000800000
      80C0C0C0C0C0C0C0C0C0C0C0C0000080000080000080000080C0C0C000008000
      0080000080000080C0C0C0000080000080C0C0C0C0C0C0C0C0C0C0C0C0000080
      000080C0C0C0C0C0C0C0C0C0000080000080C0C0C0C0C0C0C0C0C00000800000
      80C0C0C0C0C0C0C0C0C0C0C0C0000080000080000080000080C0C0C000008000
      0080000080000080C0C0C0000080000080000080000080C0C0C0C0C0C0000080
      000080000080000080C0C0C0000080000080000080000080C0C0C00000800000
      80000080000080C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
      C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0}
    Transparent = True
    BitmapHAlign = haNone
    BitmapVAlign = vaNone
    UserRGNAUTO = True
    RotationPointX = 0
    RotationPointY = 0
    Rotated = False
    CaptionFixed = False
    GradientFixed = False
    GradientBitmapLine = 0
    Caption3dKind = ckPressed
    RadiusRatio = 0.5
    ArcAngle = 2.0943951023932
  end
  object btnDiscount: TIAeverButton
    Left = 352
    Top = 168
    Width = 90
    Height = 33
    Caption = 'Discount'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial Narrow'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 13
    OnClick = btnDiscountClick
    ButtonAngle = 1800
    ButtonWidth = 90
    ButtonHeight = 33
    CaptionAngle = 0
    ButtonKind = bkRoundRect
    ButtonDepth = 4
    MainBitmap.Data = {
      36030000424D3603000000000000360000002800000010000000100000000100
      1800000000000003000000000000000000000000000000000000C0C0C0C0C0C0
      C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
      C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
      C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
      C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
      C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
      C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
      C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
      C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
      C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
      C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
      C0C0C0C0C0C0C0C0C0C0C0C0C0000080000080C0C0C0C0C0C0C0C0C0C0C0C0C0
      C0C0C0C0C0C0C0C0000080000080C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0000080
      000080C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0000080000080C0C0
      C0C0C0C0C0C0C0C0C0C0C0C0C0000080000080C0C0C0C0C0C0C0C0C0C0C0C0C0
      C0C0C0C0C0C0C0C0000080000080C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0000080
      000080000080000080C0C0C0C0C0C0000080000080000080000080000080C0C0
      C0C0C0C0C0C0C0C0C0C0C0C0C0000080000080000080000080C0C0C0C0C0C000
      0080000080000080000080000080C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0000080
      000080C0C0C0C0C0C0C0C0C0C0C0C0000080000080C0C0C0000080000080C0C0
      C0C0C0C0C0C0C0C0C0C0C0C0C0000080000080000080000080000080C0C0C000
      0080000080C0C0C0000080000080C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0000080
      000080000080000080000080C0C0C0000080000080C0C0C0000080000080C0C0
      C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
      C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0}
    Transparent = True
    BitmapHAlign = haNone
    BitmapVAlign = vaNone
    UserRGNAUTO = True
    RotationPointX = 0
    RotationPointY = 0
    Rotated = False
    CaptionFixed = False
    GradientFixed = False
    GradientBitmapLine = 0
    Caption3dKind = ckPressed
    RadiusRatio = 0.5
    ArcAngle = 2.0943951023932
  end
  object edQuantity: TCurrencyEdit
    Left = 88
    Top = 232
    Width = 129
    Height = 25
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial Narrow'
    Font.Style = []
    Lines.Strings = (
      '0.00 ')
    ParentFont = False
    TabOrder = 9
    WantReturns = False
    WordWrap = False
    OnChange = JustRecalc
    OnEnter = HOOK_NonStockEnterQuantity
    AutoSize = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
    ShowCurrency = False
    TextId = 0
    Value = 1E-10
  end
  object Panel1: TPanel
    Left = 8
    Top = 272
    Width = 433
    Height = 65
    Color = clGray
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial Narrow'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 10
    object lNetPrice: TLabel
      Left = 16
      Top = 40
      Width = 30
      Height = 16
      Caption = #163' 0.00'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Arial Narrow'
      Font.Style = []
      ParentFont = False
    end
    object Label6: TLabel
      Left = 16
      Top = 8
      Width = 47
      Height = 16
      Caption = 'Net Price'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Arial Narrow'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Shape2: TShape
      Left = 8
      Top = 32
      Width = 417
      Height = 3
      Pen.Style = psClear
    end
    object lVATAmountTit: TLabel
      Left = 96
      Top = 8
      Width = 61
      Height = 16
      Caption = 'Vat Amount'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Arial Narrow'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lPriceIncVAT: TLabel
      Left = 168
      Top = 8
      Width = 76
      Height = 16
      Caption = 'Price (inc.VAT)'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Arial Narrow'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lVATAmount: TLabel
      Left = 96
      Top = 40
      Width = 30
      Height = 16
      Caption = #163' 0.00'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Arial Narrow'
      Font.Style = []
      ParentFont = False
    end
    object lPrice: TLabel
      Left = 168
      Top = 40
      Width = 30
      Height = 16
      Caption = #163' 0.00'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Arial Narrow'
      Font.Style = []
      ParentFont = False
    end
    object Label11: TLabel
      Left = 256
      Top = 8
      Width = 45
      Height = 16
      Caption = 'Quantity'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Arial Narrow'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lQuantity: TLabel
      Left = 256
      Top = 40
      Width = 21
      Height = 16
      Caption = '1.00'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Arial Narrow'
      Font.Style = []
      ParentFont = False
    end
    object lTotalPriceincVAT: TLabel
      Left = 312
      Top = 8
      Width = 108
      Height = 16
      Caption = 'Total Price (inc. VAT)'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Arial Narrow'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lTotalPrice: TLabel
      Left = 312
      Top = 40
      Width = 30
      Height = 16
      Caption = #163' 0.00'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Arial Narrow'
      Font.Style = []
      ParentFont = False
    end
  end
  object edDescription1: TEdit
    Left = 88
    Top = 16
    Width = 241
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial Narrow'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnChange = edDescription1Change
    OnExit = DescriptionLineExit
  end
  object edDescription2: TEdit
    Left = 88
    Top = 39
    Width = 241
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial Narrow'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnExit = DescriptionLineExit
  end
  object edDescription3: TEdit
    Left = 88
    Top = 62
    Width = 241
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial Narrow'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    OnExit = DescriptionLineExit
  end
  object edDescription4: TEdit
    Left = 88
    Top = 85
    Width = 241
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial Narrow'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    OnExit = DescriptionLineExit
  end
  object edDescription5: TEdit
    Left = 88
    Top = 108
    Width = 241
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial Narrow'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    OnExit = DescriptionLineExit
  end
  object edDescription6: TEdit
    Left = 88
    Top = 131
    Width = 241
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial Narrow'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    OnExit = DescriptionLineExit
  end
  object edPrice: TCurrencyEdit
    Left = 88
    Top = 168
    Width = 129
    Height = 25
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial Narrow'
    Font.Style = []
    Lines.Strings = (
      '0.00 ')
    ParentFont = False
    TabOrder = 6
    WantReturns = False
    WordWrap = False
    OnChange = JustRecalc
    AutoSize = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
    ShowCurrency = False
    TextId = 0
    Value = 1E-10
  end
  object cmbVatRate: TComboBox
    Left = 88
    Top = 200
    Width = 129
    Height = 24
    Style = csDropDownList
    ItemHeight = 16
    TabOrder = 8
    OnChange = JustRecalc
  end
  object cbInclusive: TCheckBox
    Left = 232
    Top = 174
    Width = 13
    Height = 13
    Caption = 'VAT Inclusive'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -13
    Font.Name = 'Arial Narrow'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 7
    OnClick = JustRecalc
  end
  object btnCustom2: TIAeverButton
    Tag = 2
    Left = 118
    Top = 352
    Width = 107
    Height = 33
    Anchors = [akLeft, akBottom]
    Caption = 'Custom2'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial Narrow'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 14
    Visible = False
    OnClick = HOOK_NonStockCustomButtonClick
    ButtonAngle = 1800
    ButtonWidth = 107
    ButtonHeight = 33
    CaptionAngle = 0
    ButtonKind = bkRoundRect
    ButtonDepth = 4
    Transparent = True
    BitmapHAlign = haNone
    BitmapVAlign = vaNone
    UserRGNAUTO = True
    RotationPointX = 0
    RotationPointY = 0
    Rotated = False
    CaptionFixed = False
    GradientFixed = False
    GradientBitmapLine = 0
    Caption3dKind = ckPressed
    RadiusRatio = 0.5
    ArcAngle = 2.0943951023932
  end
  object btnCustom1: TIAeverButton
    Tag = 1
    Left = 6
    Top = 352
    Width = 107
    Height = 33
    Anchors = [akLeft, akBottom]
    Caption = 'Custom1'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial Narrow'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 15
    Visible = False
    OnClick = HOOK_NonStockCustomButtonClick
    ButtonAngle = 1800
    ButtonWidth = 107
    ButtonHeight = 33
    CaptionAngle = 0
    ButtonKind = bkRoundRect
    ButtonDepth = 4
    Transparent = True
    BitmapHAlign = haNone
    BitmapVAlign = vaNone
    UserRGNAUTO = True
    RotationPointX = 0
    RotationPointY = 0
    Rotated = False
    CaptionFixed = False
    GradientFixed = False
    GradientBitmapLine = 0
    Caption3dKind = ckPressed
    RadiusRatio = 0.5
    ArcAngle = 2.0943951023932
  end
end
