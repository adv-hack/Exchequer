object frmCSVMapStart: TfrmCSVMapStart
  Left = 386
  Top = 184
  HelpContext = 5
  BorderStyle = bsDialog
  Caption = 'CSV Mapping'
  ClientHeight = 199
  ClientWidth = 168
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
  object Bevel2: TBevel
    Left = 8
    Top = 16
    Width = 153
    Height = 145
    Shape = bsFrame
  end
  object Bevel1: TBevel
    Left = 8
    Top = 40
    Width = 153
    Height = 121
    Shape = bsFrame
  end
  object rbOpen: TRadioButton
    Left = 16
    Top = 8
    Width = 129
    Height = 17
    Caption = 'Open Existing Map File'
    Checked = True
    TabOrder = 0
    TabStop = True
    OnClick = RadioActionClick
  end
  object rbNew: TRadioButton
    Left = 16
    Top = 32
    Width = 121
    Height = 17
    Caption = 'Create New Map File'
    TabOrder = 1
    OnClick = RadioActionClick
  end
  object panType: TPanel
    Left = 24
    Top = 56
    Width = 121
    Height = 97
    BevelOuter = bvNone
    TabOrder = 2
    object rbCustomer: TRadioButton
      Left = 16
      Top = 0
      Width = 89
      Height = 17
      Caption = 'Customer'
      Checked = True
      TabOrder = 0
      TabStop = True
    end
    object rbStock: TRadioButton
      Left = 16
      Top = 24
      Width = 89
      Height = 17
      Caption = 'Stock'
      TabOrder = 1
    end
    object rbStockGroup: TRadioButton
      Left = 16
      Top = 48
      Width = 89
      Height = 17
      Caption = 'Stock Group'
      TabOrder = 2
    end
    object rbTransaction: TRadioButton
      Left = 16
      Top = 72
      Width = 89
      Height = 17
      Caption = 'Transaction'
      TabOrder = 3
    end
  end
  object btnOK: TButton
    Left = 8
    Top = 168
    Width = 73
    Height = 25
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 3
  end
  object btnCancel: TButton
    Left = 88
    Top = 168
    Width = 73
    Height = 25
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 4
  end
end
