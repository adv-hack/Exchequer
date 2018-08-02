object frmAbout: TfrmAbout
  Left = 328
  Top = 147
  BorderStyle = bsSingle
  Caption = 'About...'
  ClientHeight = 456
  ClientWidth = 384
  Color = clNavy
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  DesignSize = (
    384
    456)
  PixelsPerInch = 96
  TextHeight = 13
  object InstrLbl: TLabel
    Left = 15
    Top = 137
    Width = 354
    Height = 21
    AutoSize = False
    Caption = 
      'The following Plug-Ins are currently installed in your Trade Cou' +
      'nter Module'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -13
    Font.Name = 'Arial Narrow'
    Font.Style = []
    ParentFont = False
    Transparent = True
    WordWrap = True
  end
  object lVersion: TLabel
    Left = 16
    Top = 40
    Width = 39
    Height = 16
    Caption = 'Version '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -13
    Font.Name = 'Arial Narrow'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object lTKVersion: TLabel
    Left = 16
    Top = 64
    Width = 74
    Height = 16
    Caption = 'Toolkit version :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -13
    Font.Name = 'Arial Narrow'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object lCopyright: TLabel
    Left = 16
    Top = 88
    Width = 247
    Height = 16
    Caption = 'Copyright '#169' Advanced Enterprise Software Ltd 2013'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -13
    Font.Name = 'Arial Narrow'
    Font.Style = []
    ParentFont = False
    ShowAccelChar = False
    Transparent = True
  end
  object Label4: TLabel
    Left = 16
    Top = 104
    Width = 88
    Height = 16
    Caption = 'All rights reserved.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -13
    Font.Name = 'Arial Narrow'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object Label1: TLabel
    Left = 16
    Top = 11
    Width = 163
    Height = 16
    Caption = 'Exchequer Trade Counter Module'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -13
    Font.Name = 'Arial Narrow'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object scrlPlugIns: TScrollBox
    Left = 16
    Top = 160
    Width = 353
    Height = 249
    HorzScrollBar.Visible = False
    BorderStyle = bsNone
    Color = clWhite
    ParentColor = False
    TabOrder = 0
  end
  object btnClose: TIAeverButton
    Left = 280
    Top = 416
    Width = 89
    Height = 33
    Anchors = [akLeft, akBottom]
    Cancel = True
    Caption = 'Close'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial Narrow'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    OnClick = btnCloseClick
    ButtonAngle = 0
    ButtonWidth = 89
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
end
