object frmQtyBreak: TfrmQtyBreak
  Left = 295
  Top = 246
  BorderStyle = bsDialog
  Caption = 'Quantity Break Detail'
  ClientHeight = 162
  ClientWidth = 510
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object btnSave: TButton
    Left = 426
    Top = 7
    Width = 80
    Height = 21
    Caption = '&Save'
    TabOrder = 0
    OnClick = btnSaveClick
  end
  object btnCancel: TButton
    Left = 426
    Top = 33
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    TabOrder = 1
    OnClick = btnCancelClick
  end
  object GroupBox1: TGroupBox
    Left = 4
    Top = 45
    Width = 417
    Height = 113
    TabOrder = 2
    object Label3: TLabel
      Left = 5
      Top = 16
      Width = 60
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Type'
    end
    object Label7: TLabel
      Left = 10
      Top = 41
      Width = 55
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Unit Price'
    end
    object Label8: TLabel
      Left = 10
      Top = 63
      Width = 55
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Discount %'
    end
    object Label2: TLabel
      Left = 248
      Top = 16
      Width = 91
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Sales Price Band'
    end
    object Label4: TLabel
      Left = 237
      Top = 63
      Width = 37
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Value'
    end
    object Label5: TLabel
      Left = 10
      Top = 87
      Width = 55
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Mkup/Mgn'
    end
    object edtUnitPrice: TEdit
      Left = 141
      Top = 37
      Width = 110
      Height = 21
      MaxLength = 50
      TabOrder = 0
    end
    object edtDiscPerc: TEdit
      Left = 70
      Top = 61
      Width = 129
      Height = 21
      MaxLength = 50
      TabOrder = 1
    end
    object lstDiscType: TComboBox
      Left = 70
      Top = 13
      Width = 132
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 2
      Items.Strings = (
        'Special Price'
        'Band Price'
        'Margin'
        'Markup')
    end
    object lstBands: TComboBox
      Left = 346
      Top = 13
      Width = 63
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 3
      Items.Strings = (
        'A'
        'B'
        'C'
        'D'
        'E'
        'F'
        'G'
        'H')
    end
    object lstCcy: TComboBox
      Left = 70
      Top = 37
      Width = 68
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 4
    end
    object edtDiscVal: TEdit
      Left = 279
      Top = 61
      Width = 130
      Height = 21
      MaxLength = 50
      TabOrder = 5
    end
    object edtMarkUp: TEdit
      Left = 70
      Top = 85
      Width = 129
      Height = 21
      MaxLength = 50
      TabOrder = 6
    end
  end
  object GroupBox2: TGroupBox
    Left = 4
    Top = 2
    Width = 417
    Height = 41
    TabOrder = 3
    object Label9: TLabel
      Left = 10
      Top = 15
      Width = 55
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Qty From'
    end
    object Label11: TLabel
      Left = 156
      Top = 15
      Width = 22
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'To'
    end
    object edtQtyFrom: TEdit
      Left = 70
      Top = 13
      Width = 84
      Height = 21
      MaxLength = 50
      TabOrder = 0
    end
    object edtQtyTo: TEdit
      Left = 183
      Top = 13
      Width = 84
      Height = 21
      MaxLength = 50
      TabOrder = 1
    end
  end
end
