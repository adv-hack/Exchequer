object frmPassWord: TfrmPassWord
  Left = 192
  Top = 107
  BorderStyle = bsDialog
  Caption = 'Change Password'
  ClientHeight = 141
  ClientWidth = 312
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  PixelsPerInch = 96
  TextHeight = 14
  object btnOK: TSBSButton
    Left = 224
    Top = 8
    Width = 80
    Height = 21
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 1
    TextId = 0
  end
  object btnCancel: TSBSButton
    Left = 224
    Top = 32
    Width = 80
    Height = 21
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 2
    TextId = 0
  end
  object Panel1: TPanel
    Left = 16
    Top = 8
    Width = 201
    Height = 121
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    object Label1: TLabel
      Left = 24
      Top = 16
      Width = 79
      Height = 14
      Caption = 'New Password:'
    end
    object Label2: TLabel
      Left = 24
      Top = 64
      Width = 119
      Height = 14
      Caption = 'Confirm New Password:'
    end
    object edtPass: TEdit
      Left = 24
      Top = 32
      Width = 121
      Height = 22
      CharCase = ecUpperCase
      PasswordChar = '*'
      TabOrder = 0
    end
    object edtConfirm: TEdit
      Left = 24
      Top = 80
      Width = 121
      Height = 22
      CharCase = ecUpperCase
      PasswordChar = '*'
      TabOrder = 1
    end
  end
end
