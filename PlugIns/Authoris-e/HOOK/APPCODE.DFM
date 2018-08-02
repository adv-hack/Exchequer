object frmAppCode: TfrmAppCode
  Left = 192
  Top = 133
  BorderStyle = bsDialog
  Caption = 'Exchequer Authoris-e'
  ClientHeight = 123
  ClientWidth = 293
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
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 201
    Height = 105
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 12
      Width = 177
      Height = 33
      Alignment = taCenter
      AutoSize = False
      Caption = 'Please enter your authorisation code to approve this transaction'
      WordWrap = True
    end
    object edtAppCode: TEdit
      Left = 24
      Top = 64
      Width = 145
      Height = 21
      TabOrder = 0
    end
  end
  object Button1: TButton
    Left = 216
    Top = 8
    Width = 75
    Height = 21
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 1
  end
  object Button2: TButton
    Left = 216
    Top = 40
    Width = 75
    Height = 21
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
