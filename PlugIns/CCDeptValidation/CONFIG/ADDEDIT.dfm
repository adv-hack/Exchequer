object frmAddEdit: TfrmAddEdit
  Left = 405
  Top = 317
  BorderStyle = bsDialog
  Caption = 'frmAddEdit'
  ClientHeight = 153
  ClientWidth = 313
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object Shape1: TShape
    Left = 8
    Top = 8
    Width = 297
    Height = 105
    Pen.Color = clGray
  end
  object Label1: TLabel
    Left = 16
    Top = 20
    Width = 91
    Height = 14
    Caption = 'Cost Centre Code :'
    Transparent = True
  end
  object Label2: TLabel
    Left = 16
    Top = 52
    Width = 89
    Height = 14
    Caption = 'Department Code :'
    Transparent = True
  end
  object lVAT: TLabel
    Left = 16
    Top = 84
    Width = 56
    Height = 14
    Caption = 'VAT Code :'
    Transparent = True
  end
  object btnCCWC: TButton
    Left = 216
    Top = 19
    Width = 80
    Height = 21
    Caption = 'Wild Card'
    TabOrder = 1
    TabStop = False
    OnClick = btnCCWCClick
  end
  object btnDeptWC: TButton
    Left = 216
    Top = 51
    Width = 80
    Height = 21
    Caption = 'Wild Card'
    TabOrder = 3
    TabStop = False
    OnClick = btnDeptWCClick
  end
  object btnCancel: TButton
    Left = 224
    Top = 120
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 7
  end
  object btnOK: TButton
    Left = 136
    Top = 120
    Width = 80
    Height = 21
    Caption = '&OK'
    Default = True
    ModalResult = 1
    TabOrder = 6
    OnClick = btnOKClick
  end
  object edCC: TComboBox
    Left = 111
    Top = 18
    Width = 98
    Height = 22
    Style = csDropDownList
    ItemHeight = 14
    MaxLength = 3
    TabOrder = 0
    OnChange = OnChange
  end
  object edDept: TComboBox
    Left = 111
    Top = 50
    Width = 98
    Height = 22
    Style = csDropDownList
    ItemHeight = 14
    MaxLength = 3
    TabOrder = 2
    OnChange = OnChange
  end
  object cmbVAT: TComboBox
    Left = 111
    Top = 82
    Width = 98
    Height = 22
    Style = csDropDownList
    ItemHeight = 14
    TabOrder = 4
    OnChange = OnChange
  end
  object btnVATWC: TButton
    Left = 216
    Top = 83
    Width = 80
    Height = 21
    Caption = 'Wild Card'
    TabOrder = 5
    TabStop = False
    OnClick = btnVATWCClick
  end
end
