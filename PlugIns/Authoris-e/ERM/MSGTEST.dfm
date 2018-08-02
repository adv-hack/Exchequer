object frmMsg: TfrmMsg
  Left = 286
  Top = 145
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Message'
  ClientHeight = 417
  ClientWidth = 465
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 16
    Width = 37
    Height = 13
    Caption = 'Sender:'
  end
  object Label2: TLabel
    Left = 24
    Top = 48
    Width = 39
    Height = 13
    Caption = 'Subject:'
  end
  object lblSender: TLabel
    Left = 72
    Top = 16
    Width = 44
    Height = 13
    Caption = 'lblSender'
  end
  object lblSubject: TLabel
    Left = 72
    Top = 48
    Width = 46
    Height = 13
    Caption = 'lblSubject'
  end
  object memMsg: TMemo
    Left = 24
    Top = 80
    Width = 417
    Height = 289
    TabOrder = 0
  end
  object Button1: TButton
    Left = 184
    Top = 384
    Width = 75
    Height = 25
    Cancel = True
    Caption = '&Close'
    ModalResult = 2
    TabOrder = 1
  end
end
