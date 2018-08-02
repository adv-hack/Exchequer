object frmLocationDetail: TfrmLocationDetail
  Left = 342
  Top = 116
  BorderStyle = bsDialog
  Caption = 'frmLocationDetail'
  ClientHeight = 304
  ClientWidth = 660
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
  object GroupBox1: TGroupBox
    Left = 6
    Top = 6
    Width = 564
    Height = 158
    TabOrder = 0
    object Label1: TLabel
      Left = 5
      Top = 16
      Width = 60
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Locn Code'
    end
    object Label2: TLabel
      Left = 124
      Top = 16
      Width = 37
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Name'
    end
    object Label3: TLabel
      Left = 5
      Top = 41
      Width = 60
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Address'
    end
    object Label4: TLabel
      Left = 304
      Top = 40
      Width = 55
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Contact'
    end
    object Label5: TLabel
      Left = 304
      Top = 63
      Width = 55
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Telephone'
    end
    object Label6: TLabel
      Left = 305
      Top = 86
      Width = 54
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Fax'
    end
    object Label7: TLabel
      Left = 304
      Top = 109
      Width = 55
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Modem'
    end
    object Label8: TLabel
      Left = 304
      Top = 132
      Width = 55
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Email'
    end
    object edtLocCode: TEdit
      Left = 70
      Top = 13
      Width = 49
      Height = 21
      CharCase = ecUpperCase
      MaxLength = 3
      TabOrder = 0
    end
    object edtName: TEdit
      Left = 164
      Top = 13
      Width = 392
      Height = 21
      MaxLength = 50
      TabOrder = 1
    end
    object edtAddr1: TEdit
      Left = 70
      Top = 37
      Width = 233
      Height = 21
      MaxLength = 30
      TabOrder = 2
    end
    object edtAddr2: TEdit
      Left = 70
      Top = 60
      Width = 233
      Height = 21
      MaxLength = 30
      TabOrder = 3
    end
    object edtAddr3: TEdit
      Left = 70
      Top = 83
      Width = 233
      Height = 21
      MaxLength = 30
      TabOrder = 4
    end
    object edtAddr4: TEdit
      Left = 70
      Top = 106
      Width = 233
      Height = 21
      MaxLength = 30
      TabOrder = 5
    end
    object edtAddr5: TEdit
      Left = 70
      Top = 129
      Width = 233
      Height = 21
      MaxLength = 30
      TabOrder = 6
    end
    object edtContact: TEdit
      Left = 362
      Top = 37
      Width = 194
      Height = 21
      MaxLength = 50
      TabOrder = 7
    end
    object edtPhone: TEdit
      Left = 362
      Top = 60
      Width = 194
      Height = 21
      MaxLength = 50
      TabOrder = 8
    end
    object edtFax: TEdit
      Left = 362
      Top = 83
      Width = 194
      Height = 21
      MaxLength = 50
      TabOrder = 9
    end
    object edtModem: TEdit
      Left = 362
      Top = 106
      Width = 194
      Height = 21
      MaxLength = 50
      TabOrder = 10
    end
    object edtEmail: TEdit
      Left = 362
      Top = 129
      Width = 194
      Height = 21
      MaxLength = 50
      TabOrder = 11
    end
  end
  object btnSave: TButton
    Left = 574
    Top = 20
    Width = 80
    Height = 21
    Caption = '&Save'
    TabOrder = 1
    OnClick = btnSaveClick
  end
  object btnCancel: TButton
    Left = 574
    Top = 46
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    TabOrder = 2
    OnClick = btnCancelClick
  end
  object GroupBox2: TGroupBox
    Left = 6
    Top = 166
    Width = 564
    Height = 134
    TabOrder = 3
    object Label9: TLabel
      Left = 400
      Top = 16
      Width = 59
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Sales G/L'
    end
    object Label10: TLabel
      Left = 370
      Top = 39
      Width = 89
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Cost of Sales G/L'
    end
    object Label11: TLabel
      Left = 320
      Top = 62
      Width = 139
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Closing Stk/Write Offs G/L'
    end
    object Label12: TLabel
      Left = 361
      Top = 85
      Width = 98
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Stock Value G/L'
    end
    object Label13: TLabel
      Left = 328
      Top = 108
      Width = 131
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'BOM/Finished Goods G/L'
    end
    object Label14: TLabel
      Left = 12
      Top = 62
      Width = 106
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Default CC/Dept'
    end
    object edtSalesGL: TEdit
      Left = 462
      Top = 13
      Width = 94
      Height = 21
      CharCase = ecUpperCase
      MaxLength = 50
      TabOrder = 6
    end
    object edtCOSGL: TEdit
      Left = 462
      Top = 36
      Width = 94
      Height = 21
      CharCase = ecUpperCase
      MaxLength = 50
      TabOrder = 7
    end
    object edtWOGL: TEdit
      Left = 462
      Top = 59
      Width = 94
      Height = 21
      CharCase = ecUpperCase
      MaxLength = 50
      TabOrder = 8
    end
    object edtStkValGL: TEdit
      Left = 462
      Top = 82
      Width = 94
      Height = 21
      CharCase = ecUpperCase
      MaxLength = 50
      TabOrder = 9
    end
    object edtWIPGL: TEdit
      Left = 462
      Top = 105
      Width = 94
      Height = 21
      CharCase = ecUpperCase
      MaxLength = 50
      TabOrder = 10
    end
    object chkSalesPrice: TCheckBox
      Left = 16
      Top = 16
      Width = 120
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Override Sales Prices'
      TabOrder = 0
    end
    object chkCCDept: TCheckBox
      Left = 32
      Top = 39
      Width = 104
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Override CC/Dept'
      TabOrder = 1
    end
    object edtCC: TEdit
      Left = 123
      Top = 59
      Width = 38
      Height = 21
      CharCase = ecUpperCase
      MaxLength = 3
      TabOrder = 2
    end
    object chkSupplier: TCheckBox
      Left = 35
      Top = 85
      Width = 100
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Override Supplier'
      TabOrder = 4
    end
    object chkGLCodes: TCheckBox
      Left = 12
      Top = 108
      Width = 123
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Override GL Accounts'
      TabOrder = 5
    end
    object edtDept: TEdit
      Left = 163
      Top = 59
      Width = 38
      Height = 21
      CharCase = ecUpperCase
      MaxLength = 3
      TabOrder = 3
    end
  end
end
