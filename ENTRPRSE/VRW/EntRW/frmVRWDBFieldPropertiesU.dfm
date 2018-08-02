object frmVRWDBFieldProperties: TfrmVRWDBFieldProperties
  Left = 344
  Top = 103
  HelpContext = 11
  BorderIcons = [biSystemMenu, biMinimize, biMaximize, biHelp]
  BorderStyle = bsDialog
  Caption = 'Field Properties'
  ClientHeight = 108
  ClientWidth = 218
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
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
    Left = 20
    Top = 16
    Width = 54
    Height = 14
    Caption = 'Column title'
  end
  object edtTitle: TEdit
    Left = 80
    Top = 12
    Width = 121
    Height = 22
    TabOrder = 0
  end
  object chkSubtotals: TCheckBox
    Left = 20
    Top = 44
    Width = 181
    Height = 17
    Caption = 'Include sub-totals for this field'
    TabOrder = 1
  end
  object OkBtn: TButton
    Left = 24
    Top = 80
    Width = 80
    Height = 21
    Caption = 'Ok'
    ModalResult = 1
    TabOrder = 2
  end
  object CancelBtn: TButton
    Left = 108
    Top = 80
    Width = 80
    Height = 21
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
end
