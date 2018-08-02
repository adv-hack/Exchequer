object frmMain: TfrmMain
  Left = 504
  Top = 422
  BorderStyle = bsDialog
  Caption = 'Extended Contacts Importer - v6.00.002'
  ClientHeight = 126
  ClientWidth = 433
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object Bevel1: TBevel
    Left = 8
    Top = 8
    Width = 417
    Height = 81
    Shape = bsFrame
  end
  object Label1: TLabel
    Left = 16
    Top = 20
    Width = 48
    Height = 14
    Caption = 'Filename :'
  end
  object edFilename: TEdit
    Left = 16
    Top = 40
    Width = 377
    Height = 22
    TabOrder = 0
  end
  object Button1: TButton
    Left = 393
    Top = 39
    Width = 25
    Height = 24
    Caption = '...'
    TabOrder = 1
    OnClick = Button1Click
  end
  object btnImport: TButton
    Left = 256
    Top = 96
    Width = 80
    Height = 21
    Caption = 'Run Import'
    TabOrder = 2
    OnClick = btnImportClick
  end
  object btnCancel: TButton
    Left = 344
    Top = 96
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    TabOrder = 3
    OnClick = btnCancelClick
  end
  object OpenDialog1: TOpenDialog
    Left = 8
    Top = 88
  end
end
