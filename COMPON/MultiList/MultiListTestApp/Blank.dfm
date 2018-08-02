object frmBlank: TfrmBlank
  Left = 434
  Top = 316
  Width = 143
  Height = 127
  Caption = 'frmBlank'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Position = poDefault
  Visible = True
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 48
    Top = 56
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Close'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 8
    Top = 8
    Width = 121
    Height = 21
    TabOrder = 0
    Text = 'Edit1'
  end
  object Edit2: TEdit
    Left = 8
    Top = 32
    Width = 121
    Height = 21
    TabOrder = 1
    Text = 'Edit2'
  end
end
