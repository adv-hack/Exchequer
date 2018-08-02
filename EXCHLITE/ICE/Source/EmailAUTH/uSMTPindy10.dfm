object Form1: TForm1
  Left = 329
  Top = 146
  Width = 770
  Height = 796
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
  object Label3: TLabel
    Left = 18
    Top = 37
    Width = 22
    Height = 13
    Caption = 'User'
  end
  object Label4: TLabel
    Left = 148
    Top = 37
    Width = 46
    Height = 13
    Caption = 'Password'
  end
  object Label5: TLabel
    Left = 280
    Top = 37
    Width = 47
    Height = 13
    Caption = 'POP Host'
  end
  object Label6: TLabel
    Left = 554
    Top = 37
    Width = 55
    Height = 13
    Caption = 'SMTP Port '
  end
  object Label7: TLabel
    Left = 646
    Top = 37
    Width = 47
    Height = 13
    Caption = 'POP Port '
  end
  object Label8: TLabel
    Left = 408
    Top = 131
    Width = 36
    Height = 13
    Caption = 'Subject'
  end
  object Label9: TLabel
    Left = 408
    Top = 183
    Width = 43
    Height = 13
    Caption = 'Message'
  end
  object Label10: TLabel
    Left = 408
    Top = 231
    Width = 9
    Height = 13
    Caption = 'to'
  end
  object Label1: TLabel
    Left = 410
    Top = 37
    Width = 55
    Height = 13
    Caption = 'SMTP Host'
  end
  object Label2: TLabel
    Left = 408
    Top = 86
    Width = 23
    Height = 13
    Caption = 'From'
  end
  object Memo1: TMemo
    Left = 6
    Top = 222
    Width = 327
    Height = 169
    TabOrder = 10
  end
  object edtUser: TEdit
    Left = 18
    Top = 53
    Width = 121
    Height = 21
    TabOrder = 0
    Text = 'vhmoura'
  end
  object edtPassword: TEdit
    Left = 148
    Top = 53
    Width = 121
    Height = 21
    PasswordChar = '*'
    TabOrder = 1
  end
  object edtPOPHost: TEdit
    Left = 278
    Top = 53
    Width = 121
    Height = 21
    TabOrder = 2
    Text = 'pop.mail.yahoo.com'
  end
  object seSMTP: TSpinEdit
    Left = 554
    Top = 52
    Width = 75
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 4
    Value = 465
  end
  object sePOP: TSpinEdit
    Left = 646
    Top = 52
    Width = 75
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 5
    Value = 995
  end
  object edtSubject: TEdit
    Left = 408
    Top = 151
    Width = 121
    Height = 21
    TabOrder = 7
    Text = 'test auth'
  end
  object edtMessage: TEdit
    Left = 408
    Top = 201
    Width = 121
    Height = 21
    TabOrder = 8
    Text = 'test auth'
  end
  object edtTo: TEdit
    Left = 408
    Top = 245
    Width = 121
    Height = 21
    TabOrder = 9
    Text = 'vinicios.demoura@iris.co.uk'
  end
  object edtSMTPHost: TEdit
    Left = 408
    Top = 53
    Width = 121
    Height = 21
    TabOrder = 3
    Text = 'smtp.mail.yahoo.com'
  end
  object ckbAuthentication: TCheckBox
    Left = 176
    Top = 92
    Width = 97
    Height = 17
    Caption = 'Authentication'
    TabOrder = 11
  end
  object edtFrom: TEdit
    Left = 408
    Top = 106
    Width = 121
    Height = 21
    TabOrder = 6
  end
  object rbtls: TRadioGroup
    Left = 412
    Top = 284
    Width = 107
    Height = 105
    Caption = 'use tls'
    ItemIndex = 0
    Items.Strings = (
      'no tls support'
      'useexplicit'
      'useimplicit'
      'use required')
    TabOrder = 12
  end
  object rbAuth: TRadioGroup
    Left = 524
    Top = 286
    Width = 107
    Height = 105
    Caption = 'Auth'
    ItemIndex = 0
    Items.Strings = (
      'none'
      'use default'
      'SASL')
    TabOrder = 13
  end
  object ckbSASL: TCheckBox
    Left = 648
    Top = 288
    Width = 97
    Height = 17
    Caption = 'Use Indy SASL'
    TabOrder = 14
  end
  object ckbPassTh: TCheckBox
    Left = 646
    Top = 314
    Width = 97
    Height = 17
    Caption = 'Pass through'
    TabOrder = 15
  end
  object rbSSLVersion: TRadioGroup
    Left = 550
    Top = 174
    Width = 107
    Height = 105
    Caption = 'SSL Version'
    ItemIndex = 0
    Items.Strings = (
      '1'
      '2'
      '23'
      '3')
    TabOrder = 16
  end
  object Button1: TButton
    Left = 10
    Top = 112
    Width = 75
    Height = 25
    Caption = 'POP3'
    TabOrder = 17
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 88
    Top = 112
    Width = 75
    Height = 25
    Caption = 'SMTP'
    TabOrder = 18
    OnClick = Button2Click
  end
  object Memo2: TMemo
    Left = 6
    Top = 398
    Width = 743
    Height = 355
    TabOrder = 19
  end
  object Button3: TButton
    Left = 10
    Top = 152
    Width = 75
    Height = 25
    Caption = 'IMAP POP'
    TabOrder = 20
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 8
    Top = 188
    Width = 75
    Height = 25
    Caption = 'MAPI Send'
    TabOrder = 21
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 88
    Top = 188
    Width = 75
    Height = 25
    Caption = 'MAPI Receive'
    TabOrder = 22
    OnClick = Button5Click
  end
end
