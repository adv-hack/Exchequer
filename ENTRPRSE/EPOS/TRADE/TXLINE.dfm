object FrmTXLine: TFrmTXLine
  Left = 414
  Top = 180
  HelpContext = 27
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Transaction Line'
  ClientHeight = 556
  ClientWidth = 490
  Color = clNavy
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Arial Narrow'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poOwnerFormCenter
  Scaled = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel
    Left = 8
    Top = 20
    Width = 62
    Height = 16
    Caption = 'Stock Code'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -13
    Font.Name = 'Arial Narrow'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object Label2: TLabel
    Left = 8
    Top = 52
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
  object shBar: TShape
    Left = 94
    Top = 16
    Width = 3
    Height = 202
    Pen.Style = psClear
  end
  object Label5: TLabel
    Left = 8
    Top = 84
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
  object lDesc1: TLabel
    Left = 104
    Top = 84
    Width = 102
    Height = 16
    Caption = '                                  '
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -13
    Font.Name = 'Arial Narrow'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object lDesc2: TLabel
    Left = 104
    Top = 100
    Width = 99
    Height = 16
    Caption = '                                 '
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -13
    Font.Name = 'Arial Narrow'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object lDesc3: TLabel
    Left = 104
    Top = 116
    Width = 99
    Height = 16
    Caption = '                                 '
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -13
    Font.Name = 'Arial Narrow'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object lDesc4: TLabel
    Left = 104
    Top = 132
    Width = 102
    Height = 16
    Caption = '                                  '
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -13
    Font.Name = 'Arial Narrow'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object lDesc5: TLabel
    Left = 104
    Top = 148
    Width = 102
    Height = 16
    Caption = '                                  '
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -13
    Font.Name = 'Arial Narrow'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object lDesc6: TLabel
    Left = 104
    Top = 164
    Width = 102
    Height = 16
    Caption = '                                  '
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
    Top = 196
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
    Left = 267
    Top = 196
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
  object edStockCode: TEdit
    Left = 104
    Top = 16
    Width = 129
    Height = 24
    CharCase = ecUpperCase
    TabOrder = 0
    OnExit = edStockCodeExit
  end
  object btnFind: TIAeverButton
    Left = 384
    Top = 8
    Width = 98
    Height = 32
    Caption = 'Find'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial Narrow'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 6
    OnClick = btnFindClick
    ButtonAngle = 1800
    ButtonWidth = 98
    ButtonHeight = 32
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
      0080000080C0C0C0000080000080000080000080000080C0C0C0C0C0C0000080
      000080C0C0C0C0C0C0C0C0C0C0C0C0000080000080C0C0C00000800000800000
      80000080000080C0C0C0C0C0C0000080000080C0C0C0C0C0C0C0C0C0C0C0C000
      0080000080C0C0C0000080000080C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0000080
      000080000080000080C0C0C0C0C0C0000080000080C0C0C00000800000800000
      80000080000080C0C0C0C0C0C0000080000080000080000080C0C0C0C0C0C000
      0080000080C0C0C0000080000080000080000080000080C0C0C0C0C0C0000080
      000080C0C0C0C0C0C0C0C0C0C0C0C0000080000080C0C0C0C0C0C0C0C0C0C0C0
      C0000080000080C0C0C0C0C0C0000080000080000080000080000080C0C0C000
      0080000080C0C0C0000080000080000080000080000080C0C0C0C0C0C0000080
      000080000080000080000080C0C0C0000080000080C0C0C00000800000800000
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
  object btnOK: TIAeverButton
    Left = 296
    Top = 515
    Width = 90
    Height = 33
    Caption = 'OK'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial Narrow'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 4
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
    Left = 392
    Top = 515
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
    TabOrder = 5
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
    Left = 384
    Top = 48
    Width = 98
    Height = 33
    Caption = 'Discount'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial Narrow'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 7
    OnClick = btnDiscountClick
    ButtonAngle = 1800
    ButtonWidth = 98
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
    Left = 104
    Top = 48
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
    TabOrder = 1
    WantReturns = False
    WordWrap = False
    OnChange = edQuantityChange
    OnEnter = HOOK_TXLineEnterQuantity
    OnExit = edQuantityExit
    AutoSize = False
    BlockNegative = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
    ShowCurrency = False
    TextId = 0
    Value = 1E-10
  end
  object panPrice: TPanel
    Left = 32
    Top = 248
    Width = 449
    Height = 65
    Color = clGray
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial Narrow'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 16
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
      Width = 434
      Height = 3
      Pen.Style = psClear
    end
    object lVATAmountTit: TLabel
      Left = 104
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
      Left = 176
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
      Left = 104
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
      Left = 176
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
      Left = 272
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
      Left = 272
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
      Left = 328
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
      Left = 328
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
  object btnStock: TIAeverButton
    Left = 8
    Top = 515
    Width = 90
    Height = 33
    Caption = 'Stock'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial Narrow'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 12
    OnClick = btnStockClick
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
      000080C0C0C0C0C0C0C0C0C0C0C0C0000080000080C0C0C0C0C0C0C0C0C0C0C0
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
  object panStock: TPanel
    Left = 32
    Top = 416
    Width = 449
    Height = 89
    Color = clGray
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial Narrow'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 20
    DesignSize = (
      449
      89)
    object Label4: TLabel
      Left = 80
      Top = 8
      Width = 45
      Height = 16
      Caption = 'In Stock'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Arial Narrow'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Shape3: TShape
      Left = 8
      Top = 32
      Width = 433
      Height = 3
      Pen.Style = psClear
    end
    object Label8: TLabel
      Left = 152
      Top = 8
      Width = 49
      Height = 16
      Caption = 'Allocated'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Arial Narrow'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label9: TLabel
      Left = 224
      Top = 8
      Width = 35
      Height = 16
      Caption = 'Picked'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Arial Narrow'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label13: TLabel
      Left = 296
      Top = 8
      Width = 57
      Height = 16
      Caption = 'Free Stock'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Arial Narrow'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label16: TLabel
      Left = 368
      Top = 8
      Width = 47
      Height = 16
      Caption = 'On Order'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Arial Narrow'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label19: TLabel
      Left = 8
      Top = 64
      Width = 26
      Height = 16
      Anchors = [akLeft, akBottom]
      Caption = 'Total'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Arial Narrow'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lTotInStock: TLabel
      Left = 80
      Top = 64
      Width = 6
      Height = 16
      Anchors = [akLeft, akBottom]
      Caption = '0'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Arial Narrow'
      Font.Style = []
      ParentFont = False
    end
    object lTotAllocated: TLabel
      Left = 152
      Top = 64
      Width = 6
      Height = 16
      Anchors = [akLeft, akBottom]
      Caption = '0'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Arial Narrow'
      Font.Style = []
      ParentFont = False
    end
    object lTotPicked: TLabel
      Left = 224
      Top = 64
      Width = 6
      Height = 16
      Anchors = [akLeft, akBottom]
      Caption = '0'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Arial Narrow'
      Font.Style = []
      ParentFont = False
    end
    object lTotFreeStock: TLabel
      Left = 296
      Top = 64
      Width = 6
      Height = 16
      Anchors = [akLeft, akBottom]
      Caption = '0'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Arial Narrow'
      Font.Style = []
      ParentFont = False
    end
    object lTotOnOrder: TLabel
      Left = 368
      Top = 64
      Width = 6
      Height = 16
      Anchors = [akLeft, akBottom]
      Caption = '0'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Arial Narrow'
      Font.Style = []
      ParentFont = False
    end
    object PanStockLoc: TPanel
      Left = 1
      Top = 34
      Width = 447
      Height = 30
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 0
      object Label18: TLabel
        Left = 7
        Top = 7
        Width = 47
        Height = 16
        Caption = 'Location'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWhite
        Font.Height = -13
        Font.Name = 'Arial Narrow'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lLocInStock: TLabel
        Left = 79
        Top = 7
        Width = 6
        Height = 16
        Caption = '0'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWhite
        Font.Height = -13
        Font.Name = 'Arial Narrow'
        Font.Style = []
        ParentFont = False
      end
      object lLocAllocated: TLabel
        Left = 151
        Top = 7
        Width = 6
        Height = 16
        Caption = '0'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWhite
        Font.Height = -13
        Font.Name = 'Arial Narrow'
        Font.Style = []
        ParentFont = False
      end
      object lLocPicked: TLabel
        Left = 223
        Top = 7
        Width = 6
        Height = 16
        Caption = '0'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWhite
        Font.Height = -13
        Font.Name = 'Arial Narrow'
        Font.Style = []
        ParentFont = False
      end
      object lLocFreeStock: TLabel
        Left = 295
        Top = 7
        Width = 6
        Height = 16
        Caption = '0'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWhite
        Font.Height = -13
        Font.Name = 'Arial Narrow'
        Font.Style = []
        ParentFont = False
      end
      object lLocOnOrder: TLabel
        Left = 367
        Top = 7
        Width = 6
        Height = 16
        Caption = '0'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWhite
        Font.Height = -13
        Font.Name = 'Arial Narrow'
        Font.Style = []
        ParentFont = False
      end
    end
  end
  object HedStock: TIAeverButton
    Left = 8
    Top = 415
    Width = 24
    Height = 90
    Caption = 'Stock'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 19
    TabStop = False
    ButtonAngle = 1800
    ButtonWidth = 24
    ButtonHeight = 90
    CaptionAngle = 900
    ButtonColor = clSilver
    Transparent = True
    BitmapHAlign = haNone
    BitmapVAlign = vaNone
    UserRGNAUTO = True
    RotationPointX = 0
    RotationPointY = 0
    Rotated = False
    CaptionFixed = False
    ButtonColor1 = clSilver
    GradientFixed = False
    GradientBitmapLine = 0
    Caption3dKind = ckSimple
    RadiusRatio = 0.5
    ArcAngle = 1
    ShowFocusRGN = False
  end
  object HedPrice: TIAeverButton
    Left = 8
    Top = 248
    Width = 24
    Height = 66
    Caption = 'Price'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 15
    TabStop = False
    ButtonAngle = 1800
    ButtonWidth = 24
    ButtonHeight = 66
    CaptionAngle = 900
    ButtonColor = clSilver
    Transparent = True
    BitmapHAlign = haNone
    BitmapVAlign = vaNone
    UserRGNAUTO = True
    RotationPointX = 0
    RotationPointY = 0
    Rotated = False
    CaptionFixed = False
    ButtonColor1 = clSilver
    GradientFixed = False
    GradientBitmapLine = 0
    Caption3dKind = ckSimple
    RadiusRatio = 0.5
    ArcAngle = 1
    ShowFocusRGN = False
  end
  object btnSerial: TIAeverButton
    Left = 384
    Top = 88
    Width = 98
    Height = 33
    Caption = 'Serial Nos.'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial Narrow'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 8
    OnClick = btnSerialClick
    ButtonAngle = 1800
    ButtonWidth = 98
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
      000080000080000080C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0000080000080C0C0
      C0C0C0C0C0C0C0C0C0C0C0C0C0000080000080000080000080C0C0C0C0C0C0C0
      C0C0C0C0C0C0C0C0000080000080C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0000080
      000080C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0000080000080C0C0
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
  object cmbVatRate: TComboBox
    Left = 104
    Top = 192
    Width = 129
    Height = 24
    Style = csDropDownList
    ItemHeight = 16
    TabOrder = 2
    OnChange = VATChange
  end
  object cbInclusive: TCheckBox
    Left = 248
    Top = 198
    Width = 13
    Height = 13
    Caption = 'VAT Inclusive'
    Color = clNavy
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -13
    Font.Name = 'Arial Narrow'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    TabOrder = 3
    OnClick = VATChange
  end
  object btnCustom1: TIAeverButton
    Tag = 1
    Left = 104
    Top = 515
    Width = 90
    Height = 33
    Caption = 'Custom1'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial Narrow'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 13
    Visible = False
    OnClick = HOOK_TXLineCustomButtonClick
    ButtonAngle = 1800
    ButtonWidth = 90
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
  object btnCustom2: TIAeverButton
    Tag = 2
    Left = 200
    Top = 515
    Width = 90
    Height = 33
    Caption = 'Custom2'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial Narrow'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 14
    Visible = False
    OnClick = HOOK_TXLineCustomButtonClick
    ButtonAngle = 1800
    ButtonWidth = 90
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
  object btnBins: TIAeverButton
    Left = 384
    Top = 128
    Width = 98
    Height = 33
    Caption = 'Multi Bins'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial Narrow'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 9
    OnClick = btnBinsClick
    ButtonAngle = 1800
    ButtonWidth = 98
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
      C0C0C0C0C0C0C0C0C0C0C0C0C0000080000080C0C0C0C0C0C0C0C0C0C0C0C000
      0080000080C0C0C0000080000080C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0000080
      000080000080000080C0C0C0C0C0C0000080000080000080000080000080C0C0
      C0C0C0C0C0C0C0C0C0C0C0C0C0000080000080000080000080C0C0C0C0C0C000
      0080000080000080000080000080C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0000080
      000080C0C0C0C0C0C0C0C0C0C0C0C0000080000080C0C0C0C0C0C0C0C0C0C0C0
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
  object panMBD: TPanel
    Left = 32
    Top = 320
    Width = 449
    Height = 89
    Color = clGray
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial Narrow'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 18
    object sbMBD: TScrollBox
      Left = 1
      Top = 5
      Width = 447
      Height = 79
      BevelInner = bvNone
      BevelOuter = bvNone
      BorderStyle = bsNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Arial Narrow'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
    end
  end
  object btnNonStock: TIAeverButton
    Left = 384
    Top = 168
    Width = 98
    Height = 33
    Caption = 'Non-Stock'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial Narrow'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 10
    OnClick = btnNonStockClick
    ButtonAngle = 1800
    ButtonWidth = 98
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
      C0C0C0C0C0C0C0C0C0C0C0C0C0000080000080C0C0C0C0C0C0C0C0C0C0C0C000
      0080000080C0C0C0000080000080C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0000080
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
  object btnMultiBuy: TIAeverButton
    Left = 384
    Top = 208
    Width = 98
    Height = 33
    Caption = 'Multi-Buy'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial Narrow'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 11
    OnClick = btnMultiBuyClick
    ButtonAngle = 1800
    ButtonWidth = 98
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
      0080000080C0C0C0000080000080000080000080000080C0C0C0C0C0C0000080
      000080C0C0C0C0C0C0C0C0C0C0C0C0000080000080C0C0C00000800000800000
      80000080000080C0C0C0C0C0C0000080000080C0C0C0C0C0C0C0C0C0C0C0C000
      0080000080C0C0C0000080000080C0C0C0000080000080C0C0C0C0C0C0000080
      000080000080000080C0C0C0C0C0C0000080000080C0C0C0000080000080C0C0
      C0000080000080C0C0C0C0C0C0000080000080000080000080C0C0C0C0C0C000
      0080000080C0C0C0000080000080C0C0C0000080000080C0C0C0C0C0C0000080
      000080C0C0C0C0C0C0C0C0C0C0C0C0000080000080C0C0C0000080000080C0C0
      C0000080000080C0C0C0C0C0C0000080000080000080000080000080C0C0C000
      0080000080C0C0C0000080000080000080000080000080C0C0C0C0C0C0000080
      000080000080000080000080C0C0C0000080000080C0C0C00000800000800000
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
  object hedMBD: TIAeverButton
    Left = 8
    Top = 319
    Width = 24
    Height = 90
    Caption = 'Multi-Buy'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 17
    TabStop = False
    ButtonAngle = 1800
    ButtonWidth = 24
    ButtonHeight = 90
    CaptionAngle = 900
    ButtonColor = clSilver
    Transparent = True
    BitmapHAlign = haNone
    BitmapVAlign = vaNone
    UserRGNAUTO = True
    RotationPointX = 0
    RotationPointY = 0
    Rotated = False
    CaptionFixed = False
    ButtonColor1 = clSilver
    GradientFixed = False
    GradientBitmapLine = 0
    Caption3dKind = ckSimple
    RadiusRatio = 0.5
    ArcAngle = 1
    ShowFocusRGN = False
  end
end
