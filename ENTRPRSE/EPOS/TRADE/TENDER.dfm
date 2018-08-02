object FrmTender: TFrmTender
  Left = 351
  Top = 191
  HelpContext = 25
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Tender'
  ClientHeight = 561
  ClientWidth = 634
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
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object panPrint: TPanel
    Left = 8
    Top = 512
    Width = 97
    Height = 40
    Color = clGray
    TabOrder = 17
    object Label5: TLabel
      Left = 10
      Top = 13
      Width = 50
      Height = 16
      Caption = 'Print To...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Arial Narrow'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object panChange: TPanel
    Left = 384
    Top = 455
    Width = 241
    Height = 40
    Color = clWhite
    TabOrder = 16
    object lChange: TLabel
      Left = 8
      Top = 8
      Width = 136
      Height = 23
      Caption = '                                  '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -19
      Font.Name = 'Arial Narrow'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object panLeftOnAcc: TPanel
    Left = 384
    Top = 273
    Width = 241
    Height = 40
    Color = clGray
    TabOrder = 15
    object lOSDesc: TLabel
      Left = 10
      Top = 13
      Width = 85
      Height = 16
      Caption = 'Left on Account'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clYellow
      Font.Height = -13
      Font.Name = 'Arial Narrow'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Shape4: TShape
      Left = 124
      Top = 8
      Width = 3
      Height = 27
      Pen.Style = psClear
    end
    object lLeftOnAccount: TLabel
      Left = 138
      Top = 13
      Width = 90
      Height = 16
      Caption = '                              '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clYellow
      Font.Height = -13
      Font.Name = 'Arial Narrow'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object panCheque: TPanel
    Left = 480
    Top = 200
    Width = 145
    Height = 56
    Color = clGray
    TabOrder = 13
    object Label4: TLabel
      Left = 42
      Top = 9
      Width = 35
      Height = 16
      Caption = 'Amount'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Arial Narrow'
      Font.Style = []
      ParentFont = False
    end
    object Shape3: TShape
      Left = 28
      Top = 8
      Width = 3
      Height = 42
      Pen.Style = psClear
    end
    object edCheque: TCurrencyEdit
      Tag = 3
      Left = 40
      Top = 24
      Width = 89
      Height = 22
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial Narrow'
      Font.Style = []
      Lines.Strings = (
        '0.00 ')
      ParentFont = False
      TabOrder = 0
      WantReturns = False
      WordWrap = False
      OnChange = edChange
      OnExit = edExit
      AutoSize = False
      BlockNegative = False
      BlankOnZero = False
      DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
      ShowCurrency = False
      TextId = 0
      Value = 1E-10
    end
  end
  object panCard: TPanel
    Left = 480
    Top = 128
    Width = 145
    Height = 56
    Color = clGray
    TabOrder = 11
    object Label3: TLabel
      Left = 42
      Top = 9
      Width = 35
      Height = 16
      Caption = 'Amount'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Arial Narrow'
      Font.Style = []
      ParentFont = False
    end
    object Shape2: TShape
      Left = 28
      Top = 8
      Width = 3
      Height = 42
      Pen.Style = psClear
    end
    object edCard: TCurrencyEdit
      Tag = 2
      Left = 40
      Top = 24
      Width = 89
      Height = 22
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial Narrow'
      Font.Style = []
      Lines.Strings = (
        '0.00 ')
      ParentFont = False
      TabOrder = 0
      WantReturns = False
      WordWrap = False
      OnChange = edChange
      OnExit = edExit
      AutoSize = False
      BlockNegative = False
      BlankOnZero = False
      DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
      ShowCurrency = False
      TextId = 0
      Value = 1E-10
    end
  end
  object panCash: TPanel
    Left = 480
    Top = 56
    Width = 145
    Height = 56
    Color = clGray
    TabOrder = 9
    object Label2: TLabel
      Left = 42
      Top = 9
      Width = 35
      Height = 16
      Caption = 'Amount'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Arial Narrow'
      Font.Style = []
      ParentFont = False
    end
    object Shape1: TShape
      Left = 28
      Top = 8
      Width = 3
      Height = 42
      Pen.Style = psClear
    end
    object edCash: TCurrencyEdit
      Tag = 1
      Left = 40
      Top = 24
      Width = 89
      Height = 22
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial Narrow'
      Font.Style = []
      Lines.Strings = (
        '0.00 ')
      ParentFont = False
      TabOrder = 0
      WantReturns = False
      WordWrap = False
      OnChange = edChange
      OnExit = edExit
      AutoSize = False
      BlockNegative = False
      BlankOnZero = False
      DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
      ShowCurrency = False
      TextId = 0
      Value = 1E-10
    end
  end
  object btnCash: TIAeverButton
    Tag = 1
    Left = 384
    Top = 55
    Width = 113
    Height = 57
    Caption = 'Cash'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Arial Narrow'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 10
    OnClick = btnCashClick
    ButtonAngle = 0
    ButtonWidth = 113
    ButtonHeight = 57
    CaptionAngle = 0
    ButtonKind = bkRoundRect
    ButtonDepth = 5
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
      C0C0C0C0C0C0C0C0C0C0C0C0C0000080000080C0C0C0C0C0C0C0C0C0C0C0C000
      0080000080000080000080000080C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0000080
      000080C0C0C0C0C0C0C0C0C0C0C0C0000080000080000080000080000080C0C0
      C0C0C0C0C0C0C0C0C0C0C0C0C0000080000080C0C0C0C0C0C0C0C0C0C0C0C000
      0080000080C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0000080
      000080C0C0C0C0C0C0C0C0C0C0C0C0000080000080C0C0C0C0C0C0C0C0C0C0C0
      C0C0C0C0C0C0C0C0C0C0C0C0C0000080000080000080000080C0C0C0C0C0C000
      0080000080000080000080000080C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0000080
      000080000080000080C0C0C0C0C0C0000080000080000080000080000080C0C0
      C0C0C0C0C0C0C0C0C0C0C0C0C0000080000080C0C0C0C0C0C0C0C0C0C0C0C0C0
      C0C0C0C0C0C0C0C0000080000080C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0000080
      000080C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0000080000080C0C0
      C0C0C0C0C0C0C0C0C0C0C0C0C0000080000080000080000080000080C0C0C000
      0080000080000080000080000080C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0000080
      000080000080000080000080C0C0C0000080000080000080000080000080C0C0
      C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
      C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0}
    Transparent = True
    BitmapTop = 6
    BitmapLeft = 8
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
  object btnCard: TIAeverButton
    Tag = 1
    Left = 384
    Top = 127
    Width = 113
    Height = 57
    Caption = 'Card'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Arial Narrow'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 12
    OnClick = btnCardClick
    ButtonAngle = 0
    ButtonWidth = 113
    ButtonHeight = 57
    CaptionAngle = 0
    ButtonKind = bkRoundRect
    ButtonDepth = 5
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
      C0C0C0C0C0C0C0C0C0C0C0C0C0000080000080C0C0C0C0C0C0C0C0C0C0C0C000
      0080000080000080000080000080C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0000080
      000080C0C0C0C0C0C0C0C0C0C0C0C0000080000080000080000080000080C0C0
      C0C0C0C0C0C0C0C0C0C0C0C0C0000080000080C0C0C0C0C0C0C0C0C0C0C0C0C0
      C0C0C0C0C0C0C0C0000080000080C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0000080
      000080C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0000080000080C0C0
      C0C0C0C0C0C0C0C0C0C0C0C0C0000080000080000080000080C0C0C0C0C0C000
      0080000080000080000080000080C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0000080
      000080000080000080C0C0C0C0C0C0000080000080000080000080000080C0C0
      C0C0C0C0C0C0C0C0C0C0C0C0C0000080000080C0C0C0C0C0C0C0C0C0C0C0C0C0
      C0C0C0C0C0C0C0C0000080000080C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0000080
      000080C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0000080000080C0C0
      C0C0C0C0C0C0C0C0C0C0C0C0C0000080000080000080000080000080C0C0C000
      0080000080000080000080000080C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0000080
      000080000080000080000080C0C0C0000080000080000080000080000080C0C0
      C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
      C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0}
    Transparent = True
    BitmapTop = 6
    BitmapLeft = 8
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
  object btnCheque: TIAeverButton
    Tag = 1
    Left = 384
    Top = 199
    Width = 113
    Height = 57
    Caption = 'Cheque'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Arial Narrow'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 14
    OnClick = btnChequeClick
    ButtonAngle = 0
    ButtonWidth = 113
    ButtonHeight = 57
    CaptionAngle = 0
    ButtonKind = bkRoundRect
    ButtonDepth = 5
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
      C0C0C0C0C0C0C0C0C0C0C0C0C0000080000080C0C0C0C0C0C0C0C0C0C0C0C0C0
      C0C0C0C0C0C0C0C0000080000080C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0000080
      000080C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0000080000080C0C0
      C0C0C0C0C0C0C0C0C0C0C0C0C0000080000080C0C0C0C0C0C0C0C0C0C0C0C0C0
      C0C0C0C0C0C0C0C0000080000080C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0000080
      000080C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0000080000080C0C0
      C0C0C0C0C0C0C0C0C0C0C0C0C0000080000080000080000080C0C0C0C0C0C000
      0080000080000080000080000080C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0000080
      000080000080000080C0C0C0C0C0C0000080000080000080000080000080C0C0
      C0C0C0C0C0C0C0C0C0C0C0C0C0000080000080C0C0C0C0C0C0C0C0C0C0C0C000
      0080000080C0C0C0000080000080C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0000080
      000080C0C0C0C0C0C0C0C0C0C0C0C0000080000080C0C0C0000080000080C0C0
      C0C0C0C0C0C0C0C0C0C0C0C0C0000080000080000080000080000080C0C0C000
      0080000080C0C0C0000080000080C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0000080
      000080000080000080000080C0C0C0000080000080C0C0C0000080000080C0C0
      C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
      C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0}
    Transparent = True
    BitmapTop = 6
    BitmapLeft = 8
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
  object btnTender: TIAeverButton
    Left = 528
    Top = 512
    Width = 97
    Height = 41
    Caption = 'Tender'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial Narrow'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 21
    OnClick = btnTenderClick
    ButtonAngle = 0
    ButtonWidth = 97
    ButtonHeight = 41
    CaptionAngle = 0
    ButtonKind = bkRoundRect
    ButtonDepth = 5
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
      C0C0C0C0C0C0C0C0C0C0C0C0C0000080000080C0C0C0C0C0C0C0C0C0C0C0C000
      0080000080000080000080000080C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0000080
      000080C0C0C0C0C0C0C0C0C0C0C0C0000080000080000080000080000080C0C0
      C0C0C0C0C0C0C0C0C0C0C0C0C0000080000080C0C0C0C0C0C0C0C0C0C0C0C0C0
      C0C0C0C0C0C0C0C0000080000080C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0000080
      000080C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0000080000080C0C0
      C0C0C0C0C0C0C0C0C0C0C0C0C0000080000080000080000080C0C0C0C0C0C000
      0080000080000080000080000080C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0000080
      000080000080000080C0C0C0C0C0C0000080000080000080000080000080C0C0
      C0C0C0C0C0C0C0C0C0C0C0C0C0000080000080C0C0C0C0C0C0C0C0C0C0C0C000
      0080000080C0C0C0000080000080C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0000080
      000080C0C0C0C0C0C0C0C0C0C0C0C0000080000080C0C0C0000080000080C0C0
      C0C0C0C0C0C0C0C0C0C0C0C0C0000080000080000080000080000080C0C0C000
      0080000080000080000080000080C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0000080
      000080000080000080000080C0C0C0000080000080000080000080000080C0C0
      C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
      C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0}
    Transparent = True
    BitmapTop = 6
    BitmapLeft = 8
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
    Left = 423
    Top = 511
    Width = 98
    Height = 42
    Cancel = True
    Caption = 'Cancel'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial Narrow'
    Font.Style = [fsBold]
    ModalResult = 2
    ParentFont = False
    TabOrder = 20
    OnClick = btnCancelClick
    ButtonAngle = 0
    ButtonWidth = 98
    ButtonHeight = 42
    CaptionAngle = 0
    ButtonKind = bkRoundRect
    ButtonDepth = 5
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
      C0C0C0C0C0C0C0C0C0C0C0C0C0000080000080000080000080C0C0C000008000
      0080000080000080C0C0C0000080000080000080000080C0C0C0C0C0C0000080
      000080000080000080C0C0C0000080000080000080000080C0C0C00000800000
      80000080000080C0C0C0C0C0C0000080000080C0C0C0C0C0C0C0C0C0C0C0C0C0
      C0C0000080000080C0C0C0000080000080C0C0C0C0C0C0C0C0C0C0C0C0000080
      000080C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0000080000080C0C0C00000800000
      80C0C0C0C0C0C0C0C0C0C0C0C0000080000080000080000080C0C0C000008000
      0080000080000080C0C0C0000080000080C0C0C0C0C0C0C0C0C0C0C0C0000080
      000080000080000080C0C0C0000080000080000080000080C0C0C00000800000
      80C0C0C0C0C0C0C0C0C0C0C0C0000080000080C0C0C0C0C0C0C0C0C000008000
      0080C0C0C0C0C0C0C0C0C0000080000080C0C0C0C0C0C0C0C0C0C0C0C0000080
      000080C0C0C0C0C0C0C0C0C0000080000080C0C0C0C0C0C0C0C0C00000800000
      80C0C0C0C0C0C0C0C0C0C0C0C0000080000080000080000080C0C0C000008000
      0080000080000080C0C0C0000080000080000080000080C0C0C0C0C0C0000080
      000080000080000080C0C0C0000080000080000080000080C0C0C00000800000
      80000080000080C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
      C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0}
    Transparent = True
    BitmapTop = 6
    BitmapLeft = 8
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
  object btnPrinter: TIAeverButton
    Left = 80
    Top = 512
    Width = 145
    Height = 41
    Caption = 'Account Printer'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial Narrow'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 18
    OnClick = btnPrinterClick
    ButtonAngle = 0
    ButtonWidth = 145
    ButtonHeight = 41
    CaptionAngle = 0
    ButtonKind = bkRoundRect
    ButtonDepth = 5
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
      C0C0C0C0C0C0C0C0C0C0C0C0C0000080000080C0C0C0C0C0C0C0C0C0C0C0C000
      0080000080C0C0C0000080000080000080000080000080C0C0C0C0C0C0000080
      000080C0C0C0C0C0C0C0C0C0C0C0C0000080000080C0C0C00000800000800000
      80000080000080C0C0C0C0C0C0000080000080C0C0C0C0C0C0C0C0C0C0C0C000
      0080000080C0C0C0000080000080C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0000080
      000080C0C0C0C0C0C0C0C0C0C0C0C0000080000080C0C0C0000080000080C0C0
      C0C0C0C0C0C0C0C0C0C0C0C0C0000080000080000080000080C0C0C0C0C0C000
      0080000080C0C0C0000080000080000080000080000080C0C0C0C0C0C0000080
      000080000080000080C0C0C0C0C0C0000080000080C0C0C00000800000800000
      80000080000080C0C0C0C0C0C0000080000080C0C0C0C0C0C0C0C0C0C0C0C000
      0080000080C0C0C0C0C0C0C0C0C0C0C0C0000080000080C0C0C0C0C0C0000080
      000080C0C0C0C0C0C0C0C0C0C0C0C0000080000080C0C0C0C0C0C0C0C0C0C0C0
      C0000080000080C0C0C0C0C0C0000080000080000080000080000080C0C0C000
      0080000080C0C0C0000080000080000080000080000080C0C0C0C0C0C0000080
      000080000080000080000080C0C0C0000080000080C0C0C00000800000800000
      80000080000080C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
      C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0}
    Transparent = True
    BitmapTop = 6
    BitmapLeft = 8
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
  object btnReprint: TIAeverButton
    Left = 319
    Top = 511
    Width = 98
    Height = 42
    Cancel = True
    Caption = 'Reprint'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial Narrow'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 19
    Visible = False
    OnClick = btnReprintClick
    ButtonAngle = 0
    ButtonWidth = 98
    ButtonHeight = 42
    CaptionAngle = 0
    ButtonKind = bkRoundRect
    ButtonDepth = 5
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
      C0C0C0C0C0C0C0C0C0C0C0C0C0000080000080C0C0C0C0C0C0C0C0C0C0C0C000
      0080000080000080000080000080C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0000080
      000080C0C0C0C0C0C0C0C0C0C0C0C0000080000080000080000080000080C0C0
      C0C0C0C0C0C0C0C0C0C0C0C0C0000080000080C0C0C0C0C0C0C0C0C0C0C0C0C0
      C0C0C0C0C0C0C0C0000080000080C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0000080
      000080C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0000080000080C0C0
      C0C0C0C0C0C0C0C0C0C0C0C0C0000080000080000080000080C0C0C0C0C0C000
      0080000080000080000080000080C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0000080
      000080000080000080C0C0C0C0C0C0000080000080000080000080000080C0C0
      C0C0C0C0C0C0C0C0C0C0C0C0C0000080000080C0C0C0C0C0C0C0C0C0C0C0C000
      0080000080C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0000080
      000080C0C0C0C0C0C0C0C0C0C0C0C0000080000080C0C0C0C0C0C0C0C0C0C0C0
      C0C0C0C0C0C0C0C0C0C0C0C0C0000080000080000080000080000080C0C0C000
      0080000080000080000080000080C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0000080
      000080000080000080000080C0C0C0000080000080000080000080000080C0C0
      C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
      C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0}
    Transparent = True
    BitmapTop = 6
    BitmapLeft = 8
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
  object panOustanding: TPanel
    Left = 8
    Top = 454
    Width = 361
    Height = 40
    Color = clGray
    TabOrder = 7
    object lOutstanding: TLabel
      Left = 168
      Top = 9
      Width = 192
      Height = 23
      Caption = '                                                '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clYellow
      Font.Height = -19
      Font.Name = 'Arial Narrow'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
    object lOS: TLabel
      Left = 8
      Top = 9
      Width = 136
      Height = 23
      Caption = 'Total Outstanding'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clYellow
      Font.Height = -19
      Font.Name = 'Arial Narrow'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
  end
  object panDeposit: TPanel
    Left = 384
    Top = 6
    Width = 241
    Height = 40
    Color = clGray
    TabOrder = 8
    object lDep2: TLabel
      Left = 7
      Top = 12
      Width = 103
      Height = 16
      Caption = 'Deposit to be taken'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Arial Narrow'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
    object lToBeTaken: TLabel
      Left = 136
      Top = 12
      Width = 144
      Height = 16
      Caption = '                                                '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Arial Narrow'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
    object shDep: TShape
      Left = 124
      Top = 7
      Width = 3
      Height = 27
      Pen.Style = psClear
    end
  end
  object panDiscounts: TPanel
    Left = 8
    Top = 56
    Width = 361
    Height = 158
    Color = clGray
    TabOrder = 1
    object lTransDiscount: TLabel
      Left = 168
      Top = 16
      Width = 185
      Height = 23
      AutoSize = False
      Caption = #163' 0.00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -19
      Font.Name = 'Arial Narrow'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lValueDiscount: TLabel
      Left = 168
      Top = 66
      Width = 185
      Height = 23
      AutoSize = False
      Caption = #163' 0.00      '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -19
      Font.Name = 'Arial Narrow'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lVBDTit: TLabel
      Left = 8
      Top = 97
      Width = 345
      Height = 22
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -17
      Font.Name = 'Arial Narrow'
      Font.Style = []
      ParentFont = False
      Transparent = True
    end
    object lNextVBDTit: TLabel
      Left = 8
      Top = 129
      Width = 345
      Height = 22
      AutoSize = False
      Color = clGray
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -17
      Font.Name = 'Arial Narrow'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object Bevel1: TBevel
      Left = 8
      Top = 56
      Width = 345
      Height = 2
    end
    object lVBD: TLabel
      Left = 8
      Top = 65
      Width = 150
      Height = 23
      Caption = 'VBD Value Discount'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -19
      Font.Name = 'Arial Narrow'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
    object lTTDPercent: TLabel
      Left = 309
      Top = 17
      Width = 44
      Height = 22
      Alignment = taRightJustify
      Caption = '           '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -17
      Font.Name = 'Arial Narrow'
      Font.Style = []
      ParentFont = False
      Transparent = True
    end
  end
  object panAfterDiscount: TPanel
    Left = 8
    Top = 224
    Width = 361
    Height = 110
    Color = clGray
    TabOrder = 3
    object lVATAmountTit: TLabel
      Left = 8
      Top = 42
      Width = 95
      Height = 23
      Caption = 'VAT Amount'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -19
      Font.Name = 'Arial Narrow'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
    object lAmountTit: TLabel
      Left = 8
      Top = 74
      Width = 136
      Height = 23
      Caption = 'Amount (inc. VAT)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -19
      Font.Name = 'Arial Narrow'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
    object lVAT: TLabel
      Left = 168
      Top = 42
      Width = 185
      Height = 23
      AutoSize = False
      Caption = '                                                '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -19
      Font.Name = 'Arial Narrow'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
    object lAmount: TLabel
      Left = 168
      Top = 74
      Width = 185
      Height = 23
      AutoSize = False
      Caption = '                                                '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -19
      Font.Name = 'Arial Narrow'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
    object lNetAfterDisc: TLabel
      Left = 168
      Top = 10
      Width = 185
      Height = 23
      AutoSize = False
      Caption = '                                                '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -19
      Font.Name = 'Arial Narrow'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
    object Label8: TLabel
      Left = 8
      Top = 10
      Width = 89
      Height = 23
      Caption = 'Net Amount'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -19
      Font.Name = 'Arial Narrow'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
  end
  object btnTransDiscount: TIAeverButton
    Tag = 1
    Left = 16
    Top = 63
    Width = 145
    Height = 41
    Caption = 'Transaction Discount'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial Narrow'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    OnClick = btnTransDiscountClick
    ButtonAngle = 0
    ButtonWidth = 145
    ButtonHeight = 41
    CaptionAngle = 0
    ButtonKind = bkRoundRect
    ButtonDepth = 5
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
    BitmapTop = 6
    BitmapLeft = 8
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
  object panSettDiscount: TPanel
    Left = 8
    Top = 392
    Width = 361
    Height = 54
    Color = clGray
    TabOrder = 5
    object shSettDisc: TShape
      Left = 288
      Top = 15
      Width = 65
      Height = 27
      Brush.Style = bsClear
      Pen.Color = clWhite
    end
    object lSettAmount: TLabel
      Left = 168
      Top = 17
      Width = 113
      Height = 23
      AutoSize = False
      Caption = '                              '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -19
      Font.Name = 'Arial Narrow'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lSettDiscount: TLabel
      Left = 296
      Top = 20
      Width = 49
      Height = 16
      Alignment = taCenter
      AutoSize = False
      Caption = 'Not Taken'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Arial Narrow'
      Font.Style = []
      ParentFont = False
    end
  end
  object btnSettDiscount: TIAeverButton
    Tag = 1
    Left = 16
    Top = 399
    Width = 145
    Height = 41
    Caption = 'Settlement Discount'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial Narrow'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 6
    OnClick = btnSettDiscountClick
    ButtonAngle = 0
    ButtonWidth = 145
    ButtonHeight = 41
    CaptionAngle = 0
    ButtonKind = bkRoundRect
    ButtonDepth = 5
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
    BitmapTop = 6
    BitmapLeft = 8
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
  object panMoneyTaken: TPanel
    Left = 8
    Top = 342
    Width = 361
    Height = 40
    Color = clGray
    TabOrder = 4
    object Label6: TLabel
      Left = 8
      Top = 9
      Width = 102
      Height = 23
      Caption = 'Money Taken'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -19
      Font.Name = 'Arial Narrow'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
    object lDeposits: TLabel
      Left = 169
      Top = 9
      Width = 184
      Height = 23
      AutoSize = False
      Caption = '                                                '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -19
      Font.Name = 'Arial Narrow'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
  end
  object panOrigNetAmount: TPanel
    Left = 8
    Top = 6
    Width = 361
    Height = 40
    Color = clGray
    TabOrder = 0
    object lNet: TLabel
      Left = 168
      Top = 10
      Width = 185
      Height = 23
      AutoSize = False
      Caption = '                                                '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -19
      Font.Name = 'Arial Narrow'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
    object lOrigNetTit: TLabel
      Left = 8
      Top = 10
      Width = 129
      Height = 23
      Caption = 'Orig. Net Amount'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -19
      Font.Name = 'Arial Narrow'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
  end
end
