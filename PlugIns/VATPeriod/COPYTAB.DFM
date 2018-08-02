object frmCopyTable: TfrmCopyTable
  Left = 277
  Top = 271
  BorderStyle = bsDialog
  Caption = 'Copy Table to Another Company'
  ClientHeight = 82
  ClientWidth = 312
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object btnOK: TButton
    Left = 232
    Top = 14
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 0
    OnClick = btnOKClick
  end
  object Button2: TButton
    Left = 232
    Top = 46
    Width = 75
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 217
    Height = 65
    Caption = 'Copy table to..'
    TabOrder = 2
    object cbCompany: TComboBox
      Left = 16
      Top = 24
      Width = 185
      Height = 21
      Hint = 'Use this to select the company to copy the table to'
      ItemHeight = 13
      TabOrder = 0
      Text = 'cbCompany'
    end
  end
end
