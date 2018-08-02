object FrmCopyExport: TFrmCopyExport
  Left = 392
  Top = 224
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Copy Export'
  ClientHeight = 135
  ClientWidth = 256
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 37
    Width = 75
    Height = 13
    Caption = 'New Company :'
  end
  object Label2: TLabel
    Left = 8
    Top = 68
    Width = 84
    Height = 13
    Caption = 'New Description :'
  end
  object Label3: TLabel
    Left = 8
    Top = 8
    Width = 59
    Height = 13
    Caption = 'Description :'
  end
  object lDescription: TLabel
    Left = 96
    Top = 8
    Width = 81
    Height = 13
    Caption = 'New Company'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object cmbCompany: TComboBox
    Left = 96
    Top = 33
    Width = 153
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
  end
  object edDescription: TEdit
    Left = 96
    Top = 64
    Width = 153
    Height = 21
    TabOrder = 1
  end
  object btnCancel: TButton
    Left = 176
    Top = 104
    Width = 73
    Height = 25
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object btnCopy: TButton
    Left = 96
    Top = 104
    Width = 73
    Height = 25
    Caption = 'C&opy'
    ModalResult = 1
    TabOrder = 2
  end
end
