object frmManualEntry: TfrmManualEntry
  Left = 353
  Top = 258
  BorderStyle = bsDialog
  Caption = 'Card Details - Manual Entry'
  ClientHeight = 249
  ClientWidth = 304
  Color = clNavy
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 44
    Width = 69
    Height = 16
    Caption = 'Card Number'
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
    Top = 76
    Width = 60
    Height = 16
    Caption = 'Start Date *'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -13
    Font.Name = 'Arial Narrow'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object Label3: TLabel
    Left = 8
    Top = 108
    Width = 60
    Height = 16
    Caption = 'Expiry Date'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -13
    Font.Name = 'Arial Narrow'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object Shape1: TShape
    Left = 124
    Top = 35
    Width = 3
    Height = 162
    Pen.Style = psClear
  end
  object Label4: TLabel
    Left = 8
    Top = 140
    Width = 80
    Height = 16
    Caption = 'Issue Number *'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -13
    Font.Name = 'Arial Narrow'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object Label5: TLabel
    Left = 8
    Top = 212
    Width = 98
    Height = 16
    Caption = '* Only if applicable'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -13
    Font.Name = 'Arial Narrow'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object Label6: TLabel
    Left = 8
    Top = 8
    Width = 289
    Height = 25
    AutoSize = False
    Caption = 'Please enter the following details from the card :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -13
    Font.Name = 'Arial Narrow'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
    WordWrap = True
  end
  object Label7: TLabel
    Left = 8
    Top = 172
    Width = 92
    Height = 16
    Caption = 'Security Number*'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -13
    Font.Name = 'Arial Narrow'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object edExpiryDate: TEdit
    Left = 136
    Top = 104
    Width = 57
    Height = 21
    MaxLength = 5
    TabOrder = 2
  end
  object edStartDate: TEdit
    Left = 136
    Top = 72
    Width = 57
    Height = 21
    MaxLength = 5
    TabOrder = 1
  end
  object edCardNo: TEdit
    Left = 136
    Top = 40
    Width = 153
    Height = 21
    MaxLength = 20
    TabOrder = 0
  end
  object edIssueNumber: TEdit
    Left = 136
    Top = 136
    Width = 57
    Height = 21
    MaxLength = 2
    TabOrder = 3
  end
  object btnOK: TIAeverButton
    Left = 120
    Top = 208
    Width = 82
    Height = 33
    Caption = 'OK'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial Narrow'
    Font.Style = [fsBold]
    ModalResult = 1
    ParentFont = False
    TabOrder = 5
    ButtonAngle = 1800
    ButtonWidth = 82
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
    Left = 208
    Top = 208
    Width = 82
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
    TabOrder = 6
    ButtonAngle = 1800
    ButtonWidth = 82
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
  object Button1: TButton
    Left = 200
    Top = 72
    Width = 25
    Height = 25
    Caption = '1'
    TabOrder = 7
    Visible = False
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 224
    Top = 72
    Width = 25
    Height = 25
    Caption = '2'
    TabOrder = 8
    Visible = False
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 248
    Top = 72
    Width = 25
    Height = 25
    Caption = '3'
    TabOrder = 9
    Visible = False
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 272
    Top = 72
    Width = 25
    Height = 25
    Caption = '4'
    TabOrder = 10
    Visible = False
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 199
    Top = 96
    Width = 25
    Height = 25
    Caption = '5'
    TabOrder = 11
    Visible = False
    OnClick = Button5Click
  end
  object Button6: TButton
    Left = 223
    Top = 96
    Width = 26
    Height = 25
    Caption = '6'
    TabOrder = 12
    Visible = False
    OnClick = Button6Click
  end
  object Button7: TButton
    Left = 247
    Top = 96
    Width = 25
    Height = 25
    Caption = '7'
    TabOrder = 13
    Visible = False
    OnClick = Button7Click
  end
  object Button8: TButton
    Left = 271
    Top = 96
    Width = 25
    Height = 25
    Caption = '8'
    TabOrder = 14
    Visible = False
    OnClick = Button8Click
  end
  object Button9: TButton
    Left = 199
    Top = 120
    Width = 25
    Height = 25
    Caption = '9'
    TabOrder = 15
    Visible = False
    OnClick = Button9Click
  end
  object Button10: TButton
    Left = 223
    Top = 120
    Width = 25
    Height = 25
    Caption = '10'
    TabOrder = 16
    Visible = False
    OnClick = Button10Click
  end
  object Button11: TButton
    Left = 247
    Top = 120
    Width = 25
    Height = 25
    Caption = '11'
    TabOrder = 17
    Visible = False
    OnClick = Button11Click
  end
  object Button12: TButton
    Left = 271
    Top = 120
    Width = 25
    Height = 25
    Caption = '12'
    TabOrder = 18
    Visible = False
    OnClick = Button12Click
  end
  object Button13: TButton
    Left = 199
    Top = 144
    Width = 25
    Height = 25
    Caption = '13'
    TabOrder = 19
    Visible = False
    OnClick = Button13Click
  end
  object Button14: TButton
    Left = 223
    Top = 144
    Width = 25
    Height = 25
    Caption = '14'
    Enabled = False
    TabOrder = 20
    Visible = False
    OnClick = Button14Click
  end
  object Button15: TButton
    Left = 247
    Top = 144
    Width = 25
    Height = 25
    Caption = '15'
    Enabled = False
    TabOrder = 21
    Visible = False
    OnClick = Button15Click
  end
  object Button16: TButton
    Left = 271
    Top = 144
    Width = 25
    Height = 25
    Caption = '16'
    Enabled = False
    TabOrder = 22
    Visible = False
    OnClick = Button16Click
  end
  object edSecurityNumber: TEdit
    Left = 136
    Top = 168
    Width = 57
    Height = 21
    MaxLength = 2
    TabOrder = 4
  end
end
