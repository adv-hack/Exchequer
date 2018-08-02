object FrmSelectFile: TFrmSelectFile
  Left = 407
  Top = 189
  BorderStyle = bsDialog
  Caption = 'Select a file'
  ClientHeight = 193
  ClientWidth = 224
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  Scaled = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 42
    Height = 14
    Caption = 'Filename'
  end
  object btnOK: TButton
    Left = 152
    Top = 24
    Width = 65
    Height = 25
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 0
  end
  object btnCancel: TButton
    Left = 152
    Top = 56
    Width = 65
    Height = 25
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object lbFiles: TListBox
    Left = 8
    Top = 24
    Width = 137
    Height = 161
    ItemHeight = 14
    TabOrder = 2
    OnDblClick = lbFilesDblClick
  end
end
