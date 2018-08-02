object FrmSCTDetails: TFrmSCTDetails
  Left = 346
  Top = 346
  BorderStyle = bsDialog
  Caption = 'Sales Code Type'
  ClientHeight = 112
  ClientWidth = 264
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object Bevel1: TBevel
    Left = 8
    Top = 15
    Width = 249
    Height = 58
    Shape = bsFrame
  end
  object Label1: TLabel
    Left = 16
    Top = 8
    Width = 92
    Height = 14
    Caption = 'Sales Code Type'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object edSCT: TEdit
    Left = 24
    Top = 32
    Width = 217
    Height = 22
    MaxLength = 10
    TabOrder = 0
  end
  object btnOK: TButton
    Left = 120
    Top = 80
    Width = 65
    Height = 25
    Caption = '&OK'
    Default = True
    TabOrder = 1
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 192
    Top = 80
    Width = 65
    Height = 25
    Cancel = True
    Caption = '&Cancel'
    TabOrder = 2
    OnClick = btnCancelClick
  end
end
