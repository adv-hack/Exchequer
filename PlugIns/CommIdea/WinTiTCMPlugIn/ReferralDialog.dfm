object frmReferralDialog: TfrmReferralDialog
  Left = 340
  Top = 132
  BorderStyle = bsDialog
  Caption = 'Referral'
  ClientHeight = 283
  ClientWidth = 273
  Color = clNavy
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWhite
  Font.Height = -13
  Font.Name = 'Arial Narrow'
  Font.Style = [fsBold]
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 241
    Height = 65
    AutoSize = False
    Caption = 
      'Please call the following phone number and enter the authorisati' +
      'on code given to you by the operator.'
    Transparent = True
    WordWrap = True
  end
  object Label2: TLabel
    Left = 16
    Top = 204
    Width = 98
    Height = 16
    Caption = 'Authorisation Code : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -13
    Font.Name = 'Arial Narrow'
    Font.Style = []
    ParentFont = False
    Transparent = True
    WordWrap = True
  end
  object Label3: TLabel
    Left = 16
    Top = 72
    Width = 97
    Height = 17
    AutoSize = False
    Caption = 'Phone No : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -13
    Font.Name = 'Arial Narrow'
    Font.Style = []
    ParentFont = False
    Transparent = True
    WordWrap = True
  end
  object lPhoneNo: TLabel
    Left = 120
    Top = 72
    Width = 52
    Height = 16
    Caption = 'lPhoneNo'
    Transparent = True
  end
  object Label4: TLabel
    Left = 16
    Top = 96
    Width = 97
    Height = 17
    AutoSize = False
    Caption = 'Merchant ID : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -13
    Font.Name = 'Arial Narrow'
    Font.Style = []
    ParentFont = False
    Transparent = True
    WordWrap = True
  end
  object lMID: TLabel
    Left = 120
    Top = 96
    Width = 52
    Height = 16
    Caption = 'lPhoneNo'
    Transparent = True
  end
  object Label6: TLabel
    Left = 16
    Top = 120
    Width = 97
    Height = 17
    AutoSize = False
    Caption = 'Card No :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -13
    Font.Name = 'Arial Narrow'
    Font.Style = []
    ParentFont = False
    Transparent = True
    WordWrap = True
  end
  object lCardNo: TLabel
    Left = 120
    Top = 120
    Width = 52
    Height = 16
    Caption = 'lPhoneNo'
    Transparent = True
  end
  object Label8: TLabel
    Left = 16
    Top = 136
    Width = 97
    Height = 17
    AutoSize = False
    Caption = 'Start Date : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -13
    Font.Name = 'Arial Narrow'
    Font.Style = []
    ParentFont = False
    Transparent = True
    WordWrap = True
  end
  object lStartDate: TLabel
    Left = 120
    Top = 136
    Width = 52
    Height = 16
    Caption = 'lPhoneNo'
    Transparent = True
  end
  object Label10: TLabel
    Left = 16
    Top = 152
    Width = 97
    Height = 17
    AutoSize = False
    Caption = 'Expiry Date :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -13
    Font.Name = 'Arial Narrow'
    Font.Style = []
    ParentFont = False
    Transparent = True
    WordWrap = True
  end
  object lExpiryDate: TLabel
    Left = 120
    Top = 152
    Width = 52
    Height = 16
    Caption = 'lPhoneNo'
    Transparent = True
  end
  object Label12: TLabel
    Left = 16
    Top = 168
    Width = 97
    Height = 17
    AutoSize = False
    Caption = 'Issue No : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -13
    Font.Name = 'Arial Narrow'
    Font.Style = []
    ParentFont = False
    Transparent = True
    WordWrap = True
  end
  object lIssueNo: TLabel
    Left = 120
    Top = 168
    Width = 52
    Height = 16
    Caption = 'lPhoneNo'
    Transparent = True
  end
  object btnOK: TIAeverButton
    Left = 88
    Top = 240
    Width = 82
    Height = 33
    Caption = '&OK'
    Default = True
    Enabled = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial Narrow'
    Font.Style = [fsBold]
    ModalResult = 1
    ParentFont = False
    TabOrder = 1
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
    Left = 176
    Top = 240
    Width = 82
    Height = 33
    Caption = '&Cancel'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial Narrow'
    Font.Style = [fsBold]
    ModalResult = 2
    ParentFont = False
    TabOrder = 2
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
  object edCode: TEdit
    Left = 120
    Top = 200
    Width = 137
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Arial Narrow'
    Font.Style = []
    MaxLength = 20
    ParentFont = False
    TabOrder = 0
    OnChange = edCodeChange
  end
end
