object FrmCheckSig: TFrmCheckSig
  Left = 337
  Top = 254
  BorderStyle = bsDialog
  Caption = 'Check Signature'
  ClientHeight = 147
  ClientWidth = 218
  Color = clNavy
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWhite
  Font.Height = -13
  Font.Name = 'Arial Narrow'
  Font.Style = [fsBold]
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 191
    Height = 32
    AutoSize = False
    Caption = 'Please check the signature matches the signature on the card.'
    Transparent = True
    WordWrap = True
  end
  object Label2: TLabel
    Left = 16
    Top = 64
    Width = 185
    Height = 25
    AutoSize = False
    Caption = 'Does the signature match ?'
    Transparent = True
    WordWrap = True
  end
  object btnOK: TIAeverButton
    Left = 16
    Top = 104
    Width = 82
    Height = 33
    Caption = '&Yes'
    Default = True
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial Narrow'
    Font.Style = [fsBold]
    ModalResult = 6
    ParentFont = False
    TabOrder = 0
    ButtonAngle = 1800
    ButtonWidth = 82
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
  object IAeverButton1: TIAeverButton
    Left = 120
    Top = 104
    Width = 82
    Height = 33
    Caption = '&No'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial Narrow'
    Font.Style = [fsBold]
    ModalResult = 7
    ParentFont = False
    TabOrder = 1
    ButtonAngle = 1800
    ButtonWidth = 82
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
