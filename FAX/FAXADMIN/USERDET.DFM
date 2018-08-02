object frmUserDetails: TfrmUserDetails
  Left = 260
  Top = 215
  HelpContext = 19
  BorderStyle = bsDialog
  Caption = 'User Details'
  ClientHeight = 137
  ClientWidth = 305
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel
    Left = 21
    Top = 12
    Width = 62
    Height = 14
    Alignment = taRightJustify
    Caption = 'Login Name :'
  end
  object Label2: TLabel
    Left = 12
    Top = 44
    Width = 71
    Height = 14
    Alignment = taRightJustify
    Caption = 'Display Name :'
  end
  object Label3: TLabel
    Left = 8
    Top = 76
    Width = 75
    Height = 14
    Alignment = taRightJustify
    Caption = 'Email Address :'
  end
  object edUserName: TEdit
    Left = 88
    Top = 8
    Width = 209
    Height = 22
    TabOrder = 0
  end
  object edSenderName: TEdit
    Left = 88
    Top = 40
    Width = 209
    Height = 22
    TabOrder = 1
  end
  object edEmailAddress: TEdit
    Left = 88
    Top = 72
    Width = 209
    Height = 22
    TabOrder = 2
  end
  object btnCancel: TButton
    Left = 232
    Top = 104
    Width = 65
    Height = 25
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 4
  end
  object btnOK: TButton
    Left = 160
    Top = 104
    Width = 65
    Height = 25
    Caption = '&OK'
    Default = True
    ModalResult = 1
    TabOrder = 3
    OnClick = btnOKClick
  end
end
