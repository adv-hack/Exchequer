object frmAdmin: TfrmAdmin
  Left = 316
  Top = 201
  HorzScrollBar.Visible = False
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Administration'
  ClientHeight = 349
  ClientWidth = 675
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnActivate = FormActivate
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 14
  object Bevel5: TBevel
    Left = 8
    Top = 8
    Width = 657
    Height = 42
    Shape = bsFrame
  end
  object Bevel4: TBevel
    Left = 304
    Top = 48
    Width = 361
    Height = 130
    Shape = bsFrame
  end
  object Bevel2: TBevel
    Left = 8
    Top = 176
    Width = 346
    Height = 137
    Shape = bsFrame
  end
  object Bevel1: TBevel
    Left = 8
    Top = 48
    Width = 298
    Height = 130
    Shape = bsFrame
  end
  object Label1: TLabel
    Left = 24
    Top = 20
    Width = 51
    Height = 14
    Caption = 'Company :'
  end
  object Label26: TLabel
    Left = 24
    Top = 65
    Width = 90
    Height = 14
    Caption = 'De Minimus Value :'
  end
  object Label36: TLabel
    Left = 320
    Top = 65
    Width = 63
    Height = 14
    Caption = 'Cost Centre :'
  end
  object Label34: TLabel
    Tag = 2
    Left = 320
    Top = 89
    Width = 61
    Height = 14
    Caption = 'Department :'
  end
  object lDeptName: TLabel
    Left = 480
    Top = 88
    Width = 177
    Height = 14
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lCC: TLabel
    Left = 480
    Top = 64
    Width = 177
    Height = 14
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 24
    Top = 192
    Width = 230
    Height = 14
    Caption = 'Reverse Charge VAT Product is determined by :'
  end
  object Label3: TLabel
    Left = 104
    Top = 276
    Width = 44
    Height = 14
    Caption = 'is set to :'
  end
  object Label4: TLabel
    Left = 24
    Top = 105
    Width = 111
    Height = 14
    Caption = 'RCSL Field on Header :'
  end
  object Label7: TLabel
    Tag = 2
    Left = 320
    Top = 121
    Width = 52
    Height = 14
    Caption = 'Customer :'
  end
  object lCustomerName: TLabel
    Left = 480
    Top = 121
    Width = 177
    Height = 14
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label9: TLabel
    Left = 24
    Top = 145
    Width = 115
    Height = 14
    Caption = 'VAT Return VAT Code : '
  end
  object lGLCode: TLabel
    Left = 152
    Top = 324
    Width = 67
    Height = 14
    Caption = 'SRI GL Code :'
    Visible = False
  end
  object lGLName: TLabel
    Left = 344
    Top = 324
    Width = 145
    Height = 14
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    Visible = False
  end
  object Label8: TLabel
    Tag = 2
    Left = 320
    Top = 145
    Width = 45
    Height = 14
    Caption = 'Supplier :'
  end
  object lSupplierName: TLabel
    Left = 480
    Top = 145
    Width = 177
    Height = 14
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object btnClose: TButton
    Left = 584
    Top = 320
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Close'
    TabOrder = 17
    OnClick = btnCloseClick
  end
  object cmbCompany: TComboBox
    Left = 80
    Top = 16
    Width = 569
    Height = 22
    Style = csDropDownList
    ItemHeight = 14
    TabOrder = 0
    OnChange = cmbCompanyChange
  end
  object btnSave: TButton
    Left = 496
    Top = 320
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Save'
    TabOrder = 16
    OnClick = btnSaveClick
  end
  object edValue: TCurrencyEdit
    Left = 144
    Top = 61
    Width = 88
    Height = 25
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'ARIAL'
    Font.Style = []
    Lines.Strings = (
      '0.00 ')
    MaxLength = 5
    ParentFont = False
    TabOrder = 1
    WantReturns = False
    WordWrap = False
    OnChange = SomethingsChanged
    AutoSize = False
    BlockNegative = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
    ShowCurrency = False
    TextId = 0
    Value = 1E-10
  end
  object btnFindDept: TButton
    Tag = 2
    Left = 448
    Top = 85
    Width = 23
    Height = 21
    Caption = '...'
    TabOrder = 7
    TabStop = False
    OnClick = btnFindDeptClick
  end
  object btnFindCC: TButton
    Left = 448
    Top = 61
    Width = 23
    Height = 21
    Caption = '...'
    TabOrder = 5
    TabStop = False
    OnClick = btnFindCCClick
  end
  object rbProdVATCode: TRadioButton
    Left = 40
    Top = 219
    Width = 169
    Height = 17
    Caption = 'Product Default VAT Code :'
    Checked = True
    TabOrder = 10
    TabStop = True
    OnClick = SomethingsChanged
  end
  object cmbProdVATCode: TComboBox
    Left = 192
    Top = 216
    Width = 145
    Height = 22
    Style = csDropDownList
    ItemHeight = 14
    TabOrder = 11
    OnChange = SomethingsChanged
  end
  object rbProdUDF: TRadioButton
    Left = 40
    Top = 251
    Width = 169
    Height = 17
    Caption = 'User Defined Field :'
    TabOrder = 12
    OnClick = SomethingsChanged
  end
  object edProdUDF: TEdit
    Left = 160
    Top = 272
    Width = 145
    Height = 22
    MaxLength = 30
    TabOrder = 14
    OnChange = SomethingsChanged
  end
  object cmbRCSLUDF: TComboBox
    Left = 144
    Top = 101
    Width = 145
    Height = 22
    Style = csDropDownList
    ItemHeight = 14
    ItemIndex = 0
    TabOrder = 2
    Text = 'User Defined Field #1'
    OnChange = SomethingsChanged
    Items.Strings = (
      'User Defined Field #1'
      'User Defined Field #2'
      'User Defined Field #3'
      'User Defined Field #4')
  end
  object edCustomer: TEdit
    Tag = 2
    Left = 384
    Top = 117
    Width = 65
    Height = 22
    CharCase = ecUpperCase
    MaxLength = 6
    TabOrder = 8
    OnChange = edCustomerChange
  end
  object btnFindCustomer: TButton
    Tag = 2
    Left = 448
    Top = 117
    Width = 23
    Height = 21
    Caption = '...'
    TabOrder = 9
    TabStop = False
    OnClick = btnFindCustomerClick
  end
  object cmbVATReturn: TComboBox
    Left = 144
    Top = 141
    Width = 145
    Height = 22
    Style = csDropDownList
    ItemHeight = 14
    TabOrder = 3
    OnChange = SomethingsChanged
  end
  object edCC: TEdit
    Left = 384
    Top = 61
    Width = 65
    Height = 22
    CharCase = ecUpperCase
    MaxLength = 3
    TabOrder = 4
    OnChange = edCCChange
  end
  object edDept: TEdit
    Tag = 2
    Left = 384
    Top = 85
    Width = 65
    Height = 22
    CharCase = ecUpperCase
    MaxLength = 3
    TabOrder = 6
    OnChange = edDeptChange
  end
  object cmbProdUDF: TComboBox
    Left = 160
    Top = 248
    Width = 145
    Height = 22
    Style = csDropDownList
    ItemHeight = 14
    ItemIndex = 0
    TabOrder = 13
    Text = 'User Defined Field #1'
    OnChange = SomethingsChanged
    Items.Strings = (
      'User Defined Field #1'
      'User Defined Field #2'
      'User Defined Field #3'
      'User Defined Field #4')
  end
  object panConsumerRetailer: TPanel
    Left = 352
    Top = 176
    Width = 313
    Height = 137
    BevelOuter = bvNone
    TabOrder = 15
    object Label5: TLabel
      Left = 16
      Top = 16
      Width = 215
      Height = 14
      Caption = 'Consumer/Retail Customer is determined by :'
    end
    object Label6: TLabel
      Left = 96
      Top = 100
      Width = 44
      Height = 14
      Caption = 'is set to :'
    end
    object Bevel3: TBevel
      Left = 0
      Top = 0
      Width = 313
      Height = 137
      Shape = bsFrame
    end
    object rbCustAccType: TRadioButton
      Left = 32
      Top = 43
      Width = 137
      Height = 17
      Caption = 'Account Type Field = '
      Checked = True
      TabOrder = 0
      TabStop = True
      OnClick = SomethingsChanged
    end
    object edAccType: TEdit
      Left = 160
      Top = 40
      Width = 137
      Height = 22
      MaxLength = 4
      TabOrder = 1
      OnChange = SomethingsChanged
    end
    object rbCustUDF: TRadioButton
      Left = 32
      Top = 75
      Width = 169
      Height = 17
      Caption = 'User Defined Field :'
      TabOrder = 2
      OnClick = SomethingsChanged
    end
    object edCustUDF: TEdit
      Left = 160
      Top = 96
      Width = 137
      Height = 22
      MaxLength = 30
      TabOrder = 4
      OnChange = SomethingsChanged
    end
    object cmbCustUDF: TComboBox
      Left = 160
      Top = 72
      Width = 137
      Height = 22
      Style = csDropDownList
      ItemHeight = 14
      ItemIndex = 0
      TabOrder = 3
      Text = 'User Defined Field #1'
      OnChange = SomethingsChanged
      Items.Strings = (
        'User Defined Field #1'
        'User Defined Field #2'
        'User Defined Field #3'
        'User Defined Field #4')
    end
  end
  object edGLCode: TEdit
    Left = 248
    Top = 320
    Width = 65
    Height = 22
    TabOrder = 18
    Visible = False
    OnChange = edGLCodeChange
  end
  object btnFindGLCode: TButton
    Left = 312
    Top = 320
    Width = 23
    Height = 21
    Caption = '...'
    TabOrder = 19
    Visible = False
    OnClick = btnFindGLCodeClick
  end
  object edSupplier: TEdit
    Tag = 2
    Left = 384
    Top = 141
    Width = 65
    Height = 22
    CharCase = ecUpperCase
    MaxLength = 6
    TabOrder = 20
    OnChange = edSupplierChange
  end
  object btnFindSupplier: TButton
    Tag = 2
    Left = 448
    Top = 141
    Width = 23
    Height = 21
    Caption = '...'
    TabOrder = 21
    TabStop = False
    OnClick = btnFindSupplierClick
  end
  object MainMenu1: TMainMenu
    Left = 8
    Top = 320
    object File1: TMenuItem
      Caption = 'File'
      object Exit1: TMenuItem
        Caption = 'Exit'
        OnClick = Exit1Click
      end
    end
    object Help1: TMenuItem
      Caption = 'Help'
      object About1: TMenuItem
        Caption = 'About'
        OnClick = About1Click
      end
    end
  end
  object EnterToTab1: TEnterToTab
    ConvertEnters = True
    OverrideFont = True
    Version = 'TEnterToTab v1.02 for Delphi 6.01'
    Left = 72
    Top = 320
  end
end
