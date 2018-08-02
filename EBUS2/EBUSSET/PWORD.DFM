object frmAdminPassword: TfrmAdminPassword
  Left = 192
  Top = 107
  BorderStyle = bsDialog
  Caption = 'Ebusiness System Setup'
  ClientHeight = 131
  ClientWidth = 314
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 297
    Height = 81
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    object Label1: TLabel
      Left = 17
      Top = 16
      Width = 263
      Height = 13
      Caption = 'Please enter the password for the System Setup module'
    end
    object edtPassword: TEdit
      Left = 88
      Top = 40
      Width = 121
      Height = 21
      CharCase = ecUpperCase
      PasswordChar = '*'
      TabOrder = 0
    end
  end
  object BitBtn2: TBitBtn
    Left = 168
    Top = 104
    Width = 80
    Height = 21
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object BitBtn1: TBitBtn
    Left = 64
    Top = 104
    Width = 80
    Height = 21
    Caption = '&OK'
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
end
