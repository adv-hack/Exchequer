object frmForgottenPasswordRequest: TfrmForgottenPasswordRequest
  Left = 646
  Top = 300
  BorderStyle = bsDialog
  Caption = 'Forgotten Password Request'
  ClientHeight = 125
  ClientWidth = 472
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poOwnerFormCenter
  Scaled = False
  OnClose = FormClose
  DesignSize = (
    472
    125)
  PixelsPerInch = 96
  TextHeight = 14
  object lblSecQuestion: TLabel
    Left = 16
    Top = 47
    Width = 109
    Height = 14
    Alignment = taRightJustify
    Caption = 'Your security question'
  end
  object lblAnswer: TLabel
    Left = 61
    Top = 68
    Width = 64
    Height = 14
    Alignment = taRightJustify
    Caption = 'Your answer'
  end
  object lblInstructions: TLabel
    Left = 8
    Top = 8
    Width = 459
    Height = 29
    AutoSize = False
    Caption = 
      'Please answer your Security Question below in order to reset you' +
      'r Exchequer password and receive a temporary password via email.'
    WordWrap = True
  end
  object lblQuestion: TLabel
    Left = 137
    Top = 47
    Width = 320
    Height = 14
    AutoSize = False
    Caption = 'How many legs did your first pet have?'
  end
  object edtAnswer: TEdit
    Left = 134
    Top = 66
    Width = 326
    Height = 22
    TabOrder = 0
  end
  object btnResetPassword: TButton
    Left = 136
    Top = 96
    Width = 96
    Height = 21
    Anchors = [akLeft, akBottom]
    Caption = '&Reset Password'
    TabOrder = 1
    OnClick = btnResetPasswordClick
  end
  object btnCancel: TButton
    Left = 241
    Top = 96
    Width = 96
    Height = 21
    Anchors = [akLeft, akBottom]
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object EnterToTab1: TEnterToTab
    ConvertEnters = True
    OverrideFont = False
    Version = 'TEnterToTab v1.02 for Delphi 6.01'
    Left = 424
    Top = 96
  end
end
