object TransactionOriginatorDlg: TTransactionOriginatorDlg
  Left = 355
  Top = 124
  BorderStyle = bsDialog
  Caption = 'Select Transaction Originator'
  ClientHeight = 65
  ClientWidth = 283
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 14
  object UserLbl: TLabel
    Left = 12
    Top = 12
    Width = 23
    Height = 14
    Caption = 'User'
  end
  object UserList: TComboBox
    Left = 44
    Top = 8
    Width = 145
    Height = 22
    Style = csDropDownList
    ItemHeight = 14
    TabOrder = 0
  end
  object OkBtn: TButton
    Left = 200
    Top = 8
    Width = 75
    Height = 21
    Caption = 'Ok'
    ModalResult = 1
    TabOrder = 1
  end
  object CancelBtn: TButton
    Left = 200
    Top = 36
    Width = 75
    Height = 21
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
