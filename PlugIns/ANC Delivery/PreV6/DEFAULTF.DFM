object frmDefaultDetail: TfrmDefaultDetail
  Left = 238
  Top = 256
  BorderStyle = bsDialog
  Caption = 'frmDefaultDetail'
  ClientHeight = 64
  ClientWidth = 285
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
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 11
    Top = 38
    Width = 89
    Height = 13
    Alignment = taRightJustify
    Caption = 'ANC Service Code'
  end
  object Label2: TLabel
    Left = 38
    Top = 11
    Width = 62
    Height = 13
    Alignment = taRightJustify
    Caption = 'Default Code'
  end
  object edtDefaultCode: TEdit
    Left = 104
    Top = 7
    Width = 45
    Height = 21
    CharCase = ecUpperCase
    MaxLength = 2
    TabOrder = 0
  end
  object btnOK: TButton
    Left = 191
    Top = 8
    Width = 80
    Height = 21
    Caption = '&OK'
    TabOrder = 2
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 191
    Top = 35
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object lstServiceCode: TComboBox
    Left = 104
    Top = 34
    Width = 67
    Height = 21
    Style = csDropDownList
    CharCase = ecUpperCase
    ItemHeight = 13
    MaxLength = 3
    TabOrder = 1
  end
end
