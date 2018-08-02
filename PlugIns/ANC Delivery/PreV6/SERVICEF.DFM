object frmServiceDetail: TfrmServiceDetail
  Left = 238
  Top = 256
  BorderStyle = bsDialog
  Caption = 'frmServiceDetail'
  ClientHeight = 94
  ClientWidth = 402
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poOwnerFormCenter
  Scaled = False
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 11
    Top = 11
    Width = 89
    Height = 13
    Alignment = taRightJustify
    Caption = 'ANC Service Code'
  end
  object Label2: TLabel
    Left = 47
    Top = 38
    Width = 53
    Height = 13
    Alignment = taRightJustify
    Caption = 'Description'
  end
  object edtServiceCode: TEdit
    Left = 104
    Top = 7
    Width = 65
    Height = 21
    CharCase = ecUpperCase
    MaxLength = 3
    TabOrder = 0
  end
  object edtServiceDesc: TEdit
    Left = 104
    Top = 34
    Width = 290
    Height = 21
    MaxLength = 50
    TabOrder = 1
  end
  object btnOK: TButton
    Left = 115
    Top = 67
    Width = 80
    Height = 21
    Caption = '&OK'
    TabOrder = 2
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 206
    Top = 67
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 3
  end
end
