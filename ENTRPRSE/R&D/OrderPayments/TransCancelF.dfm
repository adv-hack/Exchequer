object TransCancelForm: TTransCancelForm
  Left = 253
  Top = 277
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Transaction Cancelled'
  ClientHeight = 375
  ClientWidth = 384
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object btnOK: TButton
    Left = 264
    Top = 344
    Width = 104
    Height = 21
    Caption = 'Cancel Transaction'
    ModalResult = 1
    TabOrder = 1
    OnClick = btnOKClick
  end
  object richMsg: TRichEdit
    Left = 0
    Top = 0
    Width = 384
    Height = 329
    Align = alTop
    Anchors = [akLeft, akTop, akRight, akBottom]
    BorderStyle = bsNone
    TabOrder = 2
  end
  object btnCancel: TButton
    Left = 152
    Top = 344
    Width = 104
    Height = 21
    Caption = 'Continue waiting'
    ModalResult = 2
    TabOrder = 0
    OnClick = btnCancelClick
  end
end
