object frmOrderPaymentsPasswordRequired: TfrmOrderPaymentsPasswordRequired
  Left = 504
  Top = 284
  HelpContext = 9002
  ActiveControl = edtPassword
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Password Required To Continue'
  ClientHeight = 250
  ClientWidth = 472
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object Label86: Label8
    Left = 11
    Top = 10
    Width = 453
    Height = 24
    Alignment = taCenter
    AutoSize = False
    Caption = 'WARNING'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -19
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TextId = 0
  end
  object CLMsgL: Label8
    Left = 10
    Top = 39
    Width = 453
    Height = 21
    Alignment = taCenter
    AutoSize = False
    Caption = 'Order Payments Transaction'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TextId = 0
  end
  object Image1: TImage
    Left = 10
    Top = 6
    Width = 53
    Height = 58
  end
  object Label1: TLabel
    Left = 144
    Top = 193
    Width = 50
    Height = 14
    Caption = 'Password'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object lblWarning: TLabel
    Left = 11
    Top = 71
    Width = 453
    Height = 31
    AutoSize = False
    Caption = 
      'You are trying to manually  <Allocate> a <Payment> created using' +
      ' the  Order Payments sub-system.'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
  end
  object Label3: TLabel
    Left = 11
    Top = 154
    Width = 453
    Height = 31
    AutoSize = False
    Caption = 
      'If you are certain that you need to make this change then you mu' +
      'st enter the Daily Password to continue.'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
  end
  object Label2: TLabel
    Left = 11
    Top = 106
    Width = 453
    Height = 43
    AutoSize = False
    Caption = 
      'The allocation of this transaction is managed by the Order Payme' +
      'nts sub-system and manual changes to its allocation could cause ' +
      'the VAT Return to contain inaccurate figures.'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
  end
  object btnOK: TButton
    Left = 105
    Top = 223
    Width = 80
    Height = 21
    Caption = '&OK'
    Default = True
    TabOrder = 1
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 197
    Top = 223
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    TabOrder = 2
    OnClick = btnCancelClick
  end
  object btnHelp: TButton
    Left = 287
    Top = 223
    Width = 80
    Height = 21
    HelpContext = 9002
    Caption = '&Help'
    TabOrder = 3
    OnClick = btnHelpClick
  end
  object edtPassword: Text8Pt
    Left = 207
    Top = 189
    Width = 121
    Height = 22
    CharCase = ecUpperCase
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 8
    ParentFont = False
    ParentShowHint = False
    PasswordChar = '*'
    ShowHint = True
    TabOrder = 0
    TextId = 0
    ViaSBtn = False
  end
end
