object frmEditSMS: TfrmEditSMS
  Left = 328
  Top = 240
  BorderStyle = bsDialog
  Caption = 'SMS Recipient Details'
  ClientHeight = 167
  ClientWidth = 264
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 14
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 249
    Height = 121
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    object Label48: TLabel
      Left = 24
      Top = 64
      Width = 40
      Height = 14
      Caption = 'Number:'
    end
    object Label49: TLabel
      Left = 24
      Top = 16
      Width = 78
      Height = 14
      Caption = 'Name (optional):'
    end
    object edtSMSNumber: TEdit
      Left = 24
      Top = 80
      Width = 201
      Height = 22
      TabOrder = 1
      OnEnter = edtSMSNumberEnter
      OnExit = edtSMSNumberExit
    end
    object edtSMSName: TEdit
      Left = 24
      Top = 32
      Width = 201
      Height = 22
      TabOrder = 0
    end
  end
  object btnOK: TButton
    Left = 120
    Top = 136
    Width = 65
    Height = 25
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 1
  end
  object Button2: TButton
    Left = 192
    Top = 136
    Width = 65
    Height = 25
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object btnDbField: TButton
    Left = 8
    Top = 134
    Width = 65
    Height = 25
    Caption = '&DB Field'
    TabOrder = 3
    OnClick = btnDbFieldClick
  end
end
