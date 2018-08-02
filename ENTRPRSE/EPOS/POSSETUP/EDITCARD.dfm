object FrmCardDetails: TFrmCardDetails
  Left = 330
  Top = 312
  BorderStyle = bsSingle
  Caption = 'Card Details'
  ClientHeight = 119
  ClientWidth = 258
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poOwnerFormCenter
  Scaled = False
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel
    Left = 8
    Top = 20
    Width = 86
    Height = 14
    Caption = 'Card Description :'
  end
  object Label2: TLabel
    Left = 8
    Top = 52
    Width = 48
    Height = 14
    Caption = 'GL Code :'
  end
  object edDescription: TEdit
    Left = 96
    Top = 16
    Width = 153
    Height = 22
    MaxLength = 20
    TabOrder = 0
    OnChange = edDescriptionChange
  end
  object edGLCode: TEdit
    Left = 96
    Top = 48
    Width = 153
    Height = 22
    MaxLength = 20
    TabOrder = 1
    OnChange = edDescriptionChange
    OnExit = edGLCodeExit
  end
  object btnCancel: TButton
    Left = 168
    Top = 88
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object btnOK: TButton
    Left = 80
    Top = 88
    Width = 80
    Height = 21
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 2
  end
end
