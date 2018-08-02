object Form1: TForm1
  Left = 398
  Top = 329
  Width = 780
  Height = 423
  Caption = 'Form1'
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
  object Label1: TLabel
    Left = 42
    Top = 62
    Width = 22
    Height = 13
    Caption = 'Host'
  end
  object Label2: TLabel
    Left = 40
    Top = 114
    Width = 22
    Height = 13
    Caption = 'User'
  end
  object Label3: TLabel
    Left = 40
    Top = 166
    Width = 46
    Height = 13
    Caption = 'Password'
  end
  object Label4: TLabel
    Left = 220
    Top = 62
    Width = 13
    Height = 13
    Caption = 'To'
  end
  object Label5: TLabel
    Left = 222
    Top = 114
    Width = 43
    Height = 13
    Caption = 'Message'
  end
  object Label6: TLabel
    Left = 206
    Top = 180
    Width = 66
    Height = 13
    Caption = 'Auth Methods'
  end
  object btnSend: TButton
    Left = 40
    Top = 262
    Width = 75
    Height = 25
    Caption = 'Send'
    TabOrder = 0
    OnClick = btnSendClick
  end
  object edtHost: TEdit
    Left = 44
    Top = 82
    Width = 121
    Height = 21
    TabOrder = 1
    Text = 'smtp.gmail.com'
  end
  object edtUser: TEdit
    Left = 42
    Top = 134
    Width = 121
    Height = 21
    TabOrder = 2
    Text = 'thebarstool'
  end
  object edtPassword: TEdit
    Left = 42
    Top = 186
    Width = 121
    Height = 21
    PasswordChar = '*'
    TabOrder = 3
    Text = 'clientlink'
  end
  object edtTo: TEdit
    Left = 220
    Top = 82
    Width = 121
    Height = 21
    TabOrder = 4
    Text = 'vinicios.demoura@iris.co.uk'
  end
  object ckbAuth: TCheckBox
    Left = 38
    Top = 30
    Width = 97
    Height = 17
    Caption = 'Authentication'
    TabOrder = 5
  end
  object edtMessage: TEdit
    Left = 224
    Top = 132
    Width = 121
    Height = 21
    TabOrder = 6
    Text = 'hello world!'
  end
  object edtPort: TAdvSpinEdit
    Left = 42
    Top = 234
    Width = 81
    Height = 22
    Value = 465
    FloatValue = 465
    HexValue = 5
    Enabled = True
    IncrementFloat = 0.1
    IncrementFloatPage = 1
    LabelAlwaysEnabled = True
    LabelCaption = 'Port'
    LabelPosition = lpTopLeft
    LabelFont.Charset = DEFAULT_CHARSET
    LabelFont.Color = clWindowText
    LabelFont.Height = -11
    LabelFont.Name = 'MS Sans Serif'
    LabelFont.Style = []
    TabOrder = 7
    Visible = True
    Version = '1.4.1.0'
  end
  object ListBox1: TListBox
    Left = 212
    Top = 204
    Width = 171
    Height = 167
    ItemHeight = 13
    TabOrder = 8
  end
  object Button1: TButton
    Left = 436
    Top = 154
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 9
    OnClick = Button1Click
  end
  object SMTP: TIdSMTP
    Intercept = IdConnectionInterceptOpenSSL1
    InterceptEnabled = True
    Left = 76
    Top = 298
  end
  object IdConnectionInterceptOpenSSL1: TIdConnectionInterceptOpenSSL
    SSLOptions.CertFile = 'C:\temp\downloads\components\indy_openssl096g\ssleay32.dll'
    SSLOptions.Method = sslvSSLv2
    SSLOptions.Mode = sslmUnassigned
    SSLOptions.VerifyMode = []
    SSLOptions.VerifyDepth = 0
    Left = 106
    Top = 300
  end
  object IdMessage: TIdMessage
    BccList = <>
    CCList = <>
    Recipients = <>
    ReplyTo = <>
    Left = 156
    Top = 276
  end
  object SmtpCli1: TSmtpCli
    Tag = 0
    ShareMode = smtpShareDenyWrite
    LocalAddr = '0.0.0.0'
    Port = 'smtp'
    AuthType = smtpAuthLogin
    ConfirmReceipt = False
    HdrPriority = smtpPriorityNone
    CharSet = 'iso-8859-1'
    SendMode = smtpToSocket
    DefaultEncoding = smtpEnc7bit
    Allow8bitChars = True
    FoldHeaders = False
    WrapMessageText = False
    ContentType = smtpPlainText
    OwnHeaders = False
    Left = 432
    Top = 88
  end
end
