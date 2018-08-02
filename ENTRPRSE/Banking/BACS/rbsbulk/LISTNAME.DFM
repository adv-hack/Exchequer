object frmListName: TfrmListName
  Left = 365
  Top = 332
  BorderStyle = bsDialog
  Caption = 'Bulk List Name'
  ClientHeight = 103
  ClientWidth = 277
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
    Left = 16
    Top = 16
    Width = 249
    Height = 17
    AutoSize = False
    Caption = 'Please enter the Bulk List name for this BACS run.'
    WordWrap = True
  end
  object Button1: TButton
    Left = 50
    Top = 72
    Width = 80
    Height = 21
    Caption = '&OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object edtName: TEdit
    Left = 16
    Top = 40
    Width = 241
    Height = 21
    MaxLength = 35
    TabOrder = 1
  end
  object Button2: TButton
    Left = 152
    Top = 72
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
