object frmSerialDet: TfrmSerialDet
  Left = 164
  Top = 194
  Width = 556
  Height = 204
  Caption = 'frmSerialDet'
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
    Left = 4
    Top = 1
    Width = 455
    Height = 40
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
    object Label1: TLabel
      Left = 19
      Top = 15
      Width = 36
      Height = 13
      Caption = 'Ser No.'
    end
    object Label4: TLabel
      Left = 194
      Top = 15
      Width = 48
      Height = 13
      Caption = 'Batch No.'
    end
    object edtSerial: TEdit
      Left = 58
      Top = 12
      Width = 128
      Height = 21
      TabOrder = 0
    end
    object edtBatch: TEdit
      Left = 245
      Top = 12
      Width = 111
      Height = 21
      TabOrder = 1
    end
  end
  object GroupBox2: TGroupBox
    Left = 4
    Top = 43
    Width = 455
    Height = 131
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
    object Label2: TLabel
      Left = 19
      Top = 27
      Width = 35
      Height = 13
      Caption = 'In Doc.'
    end
    object Label3: TLabel
      Left = 11
      Top = 66
      Width = 43
      Height = 13
      Caption = 'Out Doc.'
    end
    object Label5: TLabel
      Left = 149
      Top = 10
      Width = 46
      Height = 13
      AutoSize = False
      Caption = 'In Loc'
    end
    object Label6: TLabel
      Left = 149
      Top = 49
      Width = 46
      Height = 13
      AutoSize = False
      Caption = 'Out Loc'
    end
    object Label7: TLabel
      Left = 196
      Top = 10
      Width = 63
      Height = 13
      AutoSize = False
      Caption = 'Currency'
    end
    object Label8: TLabel
      Left = 196
      Top = 49
      Width = 63
      Height = 13
      AutoSize = False
      Caption = 'Currency'
    end
    object Label9: TLabel
      Left = 263
      Top = 10
      Width = 89
      Height = 13
      AutoSize = False
      Caption = 'Unit Cost Price'
    end
    object Label10: TLabel
      Left = 263
      Top = 49
      Width = 89
      Height = 13
      AutoSize = False
      Caption = 'Unit Sales Price'
    end
    object Label11: TLabel
      Left = 360
      Top = 49
      Width = 85
      Height = 13
      AutoSize = False
      Caption = 'Out Date'
    end
    object Label12: TLabel
      Left = 360
      Top = 10
      Width = 85
      Height = 13
      AutoSize = False
      Caption = 'In Date'
    end
    object Label13: TLabel
      Left = 3
      Top = 107
      Width = 52
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Batch Qty.'
    end
    object Label14: TLabel
      Left = 360
      Top = 89
      Width = 85
      Height = 13
      AutoSize = False
      Caption = 'Use By Date'
    end
    object Label15: TLabel
      Left = 151
      Top = 89
      Width = 64
      Height = 13
      AutoSize = False
      Caption = 'Available'
    end
    object edtInDoc: TEdit
      Left = 58
      Top = 24
      Width = 88
      Height = 21
      ReadOnly = True
      TabOrder = 0
    end
    object edtOutDoc: TEdit
      Left = 58
      Top = 63
      Width = 88
      Height = 21
      ReadOnly = True
      TabOrder = 4
    end
    object edtInLoc: TEdit
      Left = 148
      Top = 24
      Width = 46
      Height = 21
      TabOrder = 1
    end
    object edtOutLoc: TEdit
      Left = 148
      Top = 63
      Width = 46
      Height = 21
      TabOrder = 5
    end
    object lstInCcy: TComboBox
      Left = 196
      Top = 24
      Width = 65
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 2
    end
    object lstOutCcy: TComboBox
      Left = 196
      Top = 63
      Width = 65
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 6
    end
    object edtUnitCost: TEdit
      Left = 263
      Top = 24
      Width = 92
      Height = 21
      TabOrder = 3
    end
    object edtUnitSales: TEdit
      Left = 263
      Top = 63
      Width = 92
      Height = 21
      TabOrder = 7
    end
    object edtOutDate: TEdit
      Left = 359
      Top = 63
      Width = 88
      Height = 21
      TabOrder = 8
    end
    object edtInDate: TEdit
      Left = 359
      Top = 24
      Width = 88
      Height = 21
      TabOrder = 9
    end
    object edtInQty: TEdit
      Left = 58
      Top = 103
      Width = 88
      Height = 21
      ReadOnly = True
      TabOrder = 10
    end
    object edtUseByDate: TEdit
      Left = 359
      Top = 103
      Width = 88
      Height = 21
      TabOrder = 11
    end
    object edtBatchSold: TEdit
      Left = 148
      Top = 103
      Width = 69
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 12
    end
  end
  object btnOK: TButton
    Left = 464
    Top = 6
    Width = 80
    Height = 21
    Anchors = [akTop, akRight]
    Caption = '&OK'
    TabOrder = 2
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 464
    Top = 32
    Width = 80
    Height = 21
    Anchors = [akTop, akRight]
    Cancel = True
    Caption = '&Cancel'
    TabOrder = 3
    OnClick = btnCancelClick
  end
end
