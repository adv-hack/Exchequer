object Form1: TForm1
  Left = 309
  Top = 201
  BorderStyle = bsDialog
  Caption = 'SMS Tester'
  ClientHeight = 360
  ClientWidth = 376
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel
    Left = 8
    Top = 72
    Width = 90
    Height = 14
    Caption = 'Message to Send :'
  end
  object Label2: TLabel
    Left = 8
    Top = 216
    Width = 59
    Height = 14
    Caption = 'Information :'
  end
  object Label3: TLabel
    Left = 8
    Top = 44
    Width = 79
    Height = 14
    Caption = 'Mobile Number : '
  end
  object lVersion: TLabel
    Left = 8
    Top = 12
    Width = 93
    Height = 14
    Caption = 'Mobile Number : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object btnSend: TButton
    Left = 296
    Top = 88
    Width = 73
    Height = 25
    Caption = 'Send'
    TabOrder = 3
    OnClick = btnSendClick
  end
  object btnSetup: TButton
    Left = 296
    Top = 152
    Width = 73
    Height = 25
    Caption = 'Setup'
    TabOrder = 5
    OnClick = btnSetupClick
  end
  object Button3: TButton
    Left = 296
    Top = 184
    Width = 73
    Height = 25
    Caption = 'Abort'
    TabOrder = 6
    OnClick = Button3Click
  end
  object memMessage: TMemo
    Left = 8
    Top = 88
    Width = 273
    Height = 121
    TabOrder = 1
  end
  object btnSendx3: TButton
    Left = 296
    Top = 120
    Width = 73
    Height = 25
    Caption = 'Send x 3'
    TabOrder = 4
    OnClick = btnSendx3Click
  end
  object edNo: TEdit
    Left = 96
    Top = 40
    Width = 185
    Height = 22
    TabOrder = 0
    Text = '07876365026'
  end
  object mErrors: TMemo
    Left = 8
    Top = 232
    Width = 273
    Height = 121
    ReadOnly = True
    TabOrder = 2
  end
  object Button5: TButton
    Left = 296
    Top = 328
    Width = 73
    Height = 25
    Caption = 'C&lose'
    TabOrder = 7
    OnClick = Button5Click
  end
  object Button1: TButton
    Left = 296
    Top = 232
    Width = 73
    Height = 25
    Caption = 'Check Account'
    TabOrder = 8
    OnClick = Button1Click
  end
end
