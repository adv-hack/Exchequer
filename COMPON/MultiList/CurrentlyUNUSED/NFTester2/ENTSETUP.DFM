object frmEnterpriseSetup: TfrmEnterpriseSetup
  Left = 238
  Top = 151
  BorderStyle = bsSingle
  Caption = 'Enterprise Setup (additional)'
  ClientHeight = 343
  ClientWidth = 447
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object Bevel2: TBevel
    Left = 8
    Top = 16
    Width = 433
    Height = 193
    Shape = bsFrame
  end
  object Label4: TLabel
    Left = 16
    Top = 36
    Width = 114
    Height = 14
    Caption = 'Members Card Account'
  end
  object lCardNomDesc: TLabel
    Left = 216
    Top = 36
    Width = 216
    Height = 14
    Caption = 
      '                                                                ' +
      '        '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label1: TLabel
    Left = 16
    Top = 8
    Width = 54
    Height = 14
    Caption = 'GL Codes'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Bevel1: TBevel
    Left = 8
    Top = 224
    Width = 433
    Height = 81
    Shape = bsFrame
  end
  object Label2: TLabel
    Left = 16
    Top = 60
    Width = 70
    Height = 14
    Caption = 'Cash Receipts'
  end
  object lCashNomDesc: TLabel
    Left = 216
    Top = 60
    Width = 216
    Height = 14
    Caption = 
      '                                                                ' +
      '        '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label5: TLabel
    Left = 16
    Top = 84
    Width = 118
    Height = 14
    Caption = 'Card Balance Correction'
  end
  object lCorrectionNomDesc: TLabel
    Left = 216
    Top = 84
    Width = 216
    Height = 14
    Caption = 
      '                                                                ' +
      '        '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label7: TLabel
    Left = 16
    Top = 108
    Width = 105
    Height = 14
    Caption = 'Forfeit Card Balances'
  end
  object lForfeitNomDesc: TLabel
    Left = 216
    Top = 108
    Width = 216
    Height = 14
    Caption = 
      '                                                                ' +
      '        '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label9: TLabel
    Left = 16
    Top = 132
    Width = 86
    Height = 14
    Caption = 'Discount Account'
  end
  object lDiscountNomDesc: TLabel
    Left = 216
    Top = 132
    Width = 216
    Height = 14
    Caption = 
      '                                                                ' +
      '        '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label11: TLabel
    Left = 16
    Top = 156
    Width = 95
    Height = 14
    Caption = 'Till Deposit Account'
  end
  object lTillDepositNomDesc: TLabel
    Left = 216
    Top = 156
    Width = 216
    Height = 14
    Caption = 
      '                                                                ' +
      '        '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lCCDept: TLabel
    Left = 16
    Top = 216
    Width = 50
    Height = 14
    Caption = 'CC / Dept'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lCostCentre: TLabel
    Left = 16
    Top = 243
    Width = 57
    Height = 14
    Caption = 'Cost C&entre'
    FocusControl = edCostCentre
    Transparent = True
  end
  object lDepartment: TLabel
    Left = 16
    Top = 275
    Width = 55
    Height = 14
    Caption = '&Department'
    FocusControl = edDepartment
    Transparent = True
  end
  object Label3: TLabel
    Left = 16
    Top = 180
    Width = 121
    Height = 14
    Caption = 'Sales / Function Account'
  end
  object lSalesNomDesc: TLabel
    Left = 216
    Top = 180
    Width = 216
    Height = 14
    Caption = 
      '                                                                ' +
      '        '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lCC: TLabel
    Left = 152
    Top = 242
    Width = 279
    Height = 14
    Caption = 
      '                                                                ' +
      '                             '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lDept: TLabel
    Left = 152
    Top = 274
    Width = 279
    Height = 14
    Caption = 
      '                                                                ' +
      '                             '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object edCardNom: TEdit
    Tag = 5
    Left = 144
    Top = 32
    Width = 65
    Height = 22
    MaxLength = 10
    TabOrder = 0
    OnExit = NominalExit
  end
  object edCashNom: TEdit
    Tag = 1
    Left = 144
    Top = 56
    Width = 65
    Height = 22
    MaxLength = 10
    TabOrder = 1
    OnExit = NominalExit
  end
  object edCorrectionNom: TEdit
    Tag = 3
    Left = 144
    Top = 80
    Width = 65
    Height = 22
    MaxLength = 10
    TabOrder = 2
    OnExit = NominalExit
  end
  object edForfeitNom: TEdit
    Tag = 4
    Left = 144
    Top = 104
    Width = 65
    Height = 22
    MaxLength = 10
    TabOrder = 3
    OnExit = NominalExit
  end
  object edDiscountNom: TEdit
    Tag = 6
    Left = 144
    Top = 128
    Width = 65
    Height = 22
    MaxLength = 10
    TabOrder = 4
    OnExit = NominalExit
  end
  object edTillDepositNom: TEdit
    Tag = 7
    Left = 144
    Top = 152
    Width = 65
    Height = 22
    MaxLength = 10
    TabOrder = 5
    OnExit = NominalExit
  end
  object edCostCentre: TEdit
    Tag = 1
    Left = 80
    Top = 238
    Width = 65
    Height = 22
    CharCase = ecUpperCase
    MaxLength = 3
    TabOrder = 7
    OnExit = CCDeptExit
  end
  object edDepartment: TEdit
    Tag = 2
    Left = 80
    Top = 270
    Width = 65
    Height = 22
    CharCase = ecUpperCase
    MaxLength = 3
    TabOrder = 8
    OnExit = CCDeptExit
  end
  object btnOK: TButton
    Left = 376
    Top = 312
    Width = 65
    Height = 25
    Cancel = True
    Caption = '&OK'
    TabOrder = 9
    OnClick = btnOKClick
  end
  object edSalesNom: TEdit
    Tag = 8
    Left = 144
    Top = 176
    Width = 65
    Height = 22
    MaxLength = 10
    TabOrder = 6
    OnExit = NominalExit
  end
end
