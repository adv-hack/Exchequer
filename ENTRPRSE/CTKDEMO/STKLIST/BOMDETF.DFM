object frmBOMDetails: TfrmBOMDetails
  Left = 346
  Top = 179
  BorderStyle = bsDialog
  Caption = 'frmBOMDetails'
  ClientHeight = 71
  ClientWidth = 370
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 5
    Top = 1
    Width = 274
    Height = 65
    TabOrder = 0
    object Label8: TLabel
      Left = 3
      Top = 17
      Width = 79
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Stock Code'
    end
    object Label9: TLabel
      Left = 3
      Top = 40
      Width = 79
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Quantity Used'
    end
    object edtQtyUsed: TEdit
      Left = 86
      Top = 37
      Width = 62
      Height = 21
      TabOrder = 1
    end
    object edtStockCode: TEdit
      Left = 85
      Top = 13
      Width = 182
      Height = 21
      CharCase = ecUpperCase
      TabOrder = 0
      OnExit = edtStockCodeExit
    end
  end
  object btnOK: TButton
    Left = 285
    Top = 7
    Width = 80
    Height = 21
    Caption = '&OK'
    TabOrder = 1
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 285
    Top = 32
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    TabOrder = 2
    OnClick = btnCancelClick
  end
end
