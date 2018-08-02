object frmAccGroup: TfrmAccGroup
  Left = 405
  Top = 245
  BorderStyle = bsDialog
  Caption = 'Add Account Group'
  ClientHeight = 92
  ClientWidth = 321
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
    Width = 217
    Height = 81
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    object Label1: TLabel
      Left = 24
      Top = 24
      Width = 106
      Height = 13
      Caption = 'Payroll Account Group'
    end
    object edtAccGroup: TEdit
      Left = 24
      Top = 40
      Width = 169
      Height = 21
      TabOrder = 0
    end
  end
  object SBSButton1: TSBSButton
    Left = 232
    Top = 8
    Width = 80
    Height = 21
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 1
    TextId = 0
  end
  object SBSButton2: TSBSButton
    Left = 232
    Top = 36
    Width = 80
    Height = 21
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 2
    TextId = 0
  end
end
