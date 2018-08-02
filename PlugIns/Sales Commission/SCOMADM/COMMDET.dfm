object FrmCommissionDetails: TFrmCommissionDetails
  Left = 185
  Top = 185
  BorderStyle = bsDialog
  Caption = 'Commission'
  ClientHeight = 308
  ClientWidth = 648
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  PopupMenu = pmMain
  Position = poScreenCenter
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object Bevel2: TBevel
    Left = 7
    Top = 16
    Width = 298
    Height = 177
    Shape = bsFrame
  end
  object Bevel6: TBevel
    Left = 8
    Top = 208
    Width = 306
    Height = 65
    Shape = bsFrame
  end
  object Bevel5: TBevel
    Left = 320
    Top = 16
    Width = 321
    Height = 49
    Shape = bsFrame
  end
  object Bevel4: TBevel
    Left = 8
    Top = 208
    Width = 633
    Height = 65
    Shape = bsFrame
  end
  object Bevel3: TBevel
    Left = 319
    Top = 144
    Width = 322
    Height = 49
    Shape = bsFrame
  end
  object Bevel1: TBevel
    Left = 319
    Top = 79
    Width = 322
    Height = 50
    Shape = bsFrame
  end
  object lProductGroup: TLabel
    Left = 32
    Top = 143
    Width = 82
    Height = 14
    Caption = 'Product / Group :'
    Enabled = False
  end
  object lQtyFrom: TLabel
    Left = 343
    Top = 99
    Width = 24
    Height = 14
    Caption = 'From'
    Enabled = False
  end
  object lQtyTo: TLabel
    Left = 471
    Top = 99
    Width = 18
    Height = 14
    Caption = 'To :'
    Enabled = False
  end
  object lCurrency: TLabel
    Left = 344
    Top = 36
    Width = 51
    Height = 14
    Caption = 'Currency :'
    Enabled = False
  end
  object lStartDate: TLabel
    Left = 328
    Top = 162
    Width = 54
    Height = 14
    Caption = 'Start Date :'
    Enabled = False
  end
  object lEndDate: TLabel
    Left = 480
    Top = 162
    Width = 49
    Height = 14
    Caption = 'End Date :'
    Enabled = False
  end
  object Label3: TLabel
    Left = 16
    Top = 33
    Width = 111
    Height = 14
    Caption = 'Commission based on :'
  end
  object lCustCode: TLabel
    Left = 33
    Top = 78
    Width = 80
    Height = 14
    Caption = 'Customer Code :'
  end
  object lCustName: TLabel
    Left = 40
    Top = 102
    Width = 257
    Height = 14
    AutoSize = False
    Caption = 'lCustName'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lProductGroupName: TLabel
    Left = 40
    Top = 167
    Width = 257
    Height = 14
    AutoSize = False
    Caption = 'lProductGroupName'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label5: TLabel
    Left = 32
    Top = 224
    Width = 93
    Height = 14
    Caption = 'Commission Basis :'
  end
  object Label6: TLabel
    Left = 352
    Top = 235
    Width = 63
    Height = 14
    Caption = 'Commission :'
  end
  object Label4: TLabel
    Left = 16
    Top = 200
    Width = 71
    Height = 14
    Caption = 'Commission'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label1: TLabel
    Left = 16
    Top = 8
    Width = 37
    Height = 14
    Caption = 'Details'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Bevel8: TBevel
    Left = 32
    Top = 64
    Width = 257
    Height = 2
    Shape = bsFrame
  end
  object Bevel7: TBevel
    Left = 32
    Top = 128
    Width = 257
    Height = 2
    Shape = bsFrame
  end
  object shCustCodeLeft: TShape
    Left = 23
    Top = 48
    Width = 1
    Height = 37
    Pen.Style = psDot
  end
  object shProdLeft: TShape
    Left = 23
    Top = 48
    Width = 1
    Height = 103
    Pen.Style = psDot
  end
  object shProdBottom: TShape
    Left = 23
    Top = 151
    Width = 6
    Height = 1
  end
  object shCustCodeBottom: TShape
    Left = 24
    Top = 85
    Width = 6
    Height = 1
  end
  object edProductGroup: TEdit
    Left = 136
    Top = 139
    Width = 129
    Height = 22
    Enabled = False
    MaxLength = 16
    TabOrder = 3
    OnChange = edProductGroupChange
    OnExit = edProductGroupExit
  end
  object btnCancel: TButton
    Left = 560
    Top = 282
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    TabOrder = 18
    OnClick = btnCancelClick
  end
  object btnOK: TButton
    Left = 472
    Top = 282
    Width = 80
    Height = 21
    Caption = '&OK'
    TabOrder = 17
    OnClick = btnOKClick
  end
  object edCustCode: TEdit
    Left = 136
    Top = 74
    Width = 129
    Height = 22
    MaxLength = 6
    TabOrder = 1
    OnChange = edCustCodeChange
    OnExit = edCustCodeExit
  end
  object cmbBasedOn: TComboBox
    Left = 136
    Top = 29
    Width = 153
    Height = 22
    Style = csDropDownList
    ItemHeight = 14
    ItemIndex = 0
    TabOrder = 0
    Text = 'Customer '
    OnChange = cmbBasedOnChange
    Items.Strings = (
      'Customer '
      'Customer + Product '
      'Customer + Product Group'
      'Product '
      'Product Group')
  end
  object btnFindCustomer: TButton
    Left = 264
    Top = 74
    Width = 23
    Height = 21
    Caption = '...'
    TabOrder = 2
    OnClick = btnFindCustomerClick
  end
  object btnFindProductGroup: TButton
    Left = 264
    Top = 139
    Width = 23
    Height = 21
    Caption = '...'
    Enabled = False
    TabOrder = 4
    OnClick = btnFindProductGroupClick
  end
  object edStartDate: TDateTimePicker
    Left = 384
    Top = 158
    Width = 89
    Height = 22
    CalAlignment = dtaLeft
    Date = 37853.4588144792
    Time = 37853.4588144792
    DateFormat = dfShort
    DateMode = dmComboBox
    Enabled = False
    Kind = dtkDate
    ParseInput = False
    TabOrder = 11
  end
  object edEndDate: TDateTimePicker
    Left = 536
    Top = 158
    Width = 89
    Height = 22
    CalAlignment = dtaLeft
    Date = 37853.4588144792
    Time = 37853.4588144792
    DateFormat = dfShort
    DateMode = dmComboBox
    Enabled = False
    Kind = dtkDate
    ParseInput = False
    TabOrder = 12
  end
  object cmbCurrency: TComboBox
    Left = 400
    Top = 32
    Width = 177
    Height = 22
    Style = csDropDownList
    Enabled = False
    ItemHeight = 14
    TabOrder = 6
  end
  object edQtyFrom: TCurrencyEdit
    Left = 375
    Top = 95
    Width = 66
    Height = 21
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'ARIAL'
    Font.Style = []
    Lines.Strings = (
      '0.00 ')
    ParentFont = False
    TabOrder = 8
    WantReturns = False
    WordWrap = False
    AutoSize = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
    ShowCurrency = False
    TextId = 0
    Value = 1E-10
  end
  object edQtyTo: TCurrencyEdit
    Left = 495
    Top = 95
    Width = 66
    Height = 21
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'ARIAL'
    Font.Style = []
    Lines.Strings = (
      '0.00 ')
    ParentFont = False
    TabOrder = 9
    WantReturns = False
    WordWrap = False
    AutoSize = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
    ShowCurrency = False
    TextId = 0
    Value = 1E-10
  end
  object rbMargin: TRadioButton
    Left = 136
    Top = 244
    Width = 81
    Height = 17
    Caption = 'Margin'
    TabOrder = 14
  end
  object rbValue: TRadioButton
    Left = 136
    Top = 224
    Width = 81
    Height = 17
    Caption = 'Total Value'
    TabOrder = 13
  end
  object edCommission: TCurrencyEdit
    Left = 424
    Top = 232
    Width = 65
    Height = 21
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'ARIAL'
    Font.Style = []
    Lines.Strings = (
      '0.00 ')
    ParentFont = False
    TabOrder = 15
    WantReturns = False
    WordWrap = False
    AutoSize = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
    ShowCurrency = False
    TextId = 0
    Value = 1E-10
  end
  object cmbCommissionType: TComboBox
    Left = 496
    Top = 232
    Width = 105
    Height = 22
    Style = csDropDownList
    ItemHeight = 14
    TabOrder = 16
    Items.Strings = (
      'percentage'
      'amount')
  end
  object cbQuantityBased: TCheckBox
    Left = 327
    Top = 71
    Width = 122
    Height = 17
    Caption = 'Quantity Range ?'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 7
    OnClick = cbQuantityBasedClick
  end
  object cbByDate: TCheckBox
    Left = 328
    Top = 136
    Width = 97
    Height = 17
    Caption = 'Date Range ?'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 10
    OnClick = cbByDateClick
  end
  object cbCurrencyBased: TCheckBox
    Left = 328
    Top = 8
    Width = 137
    Height = 17
    Caption = 'Currency Specific ?'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 5
    OnClick = cbCurrencyBasedClick
  end
  object pmMain: TPopupMenu
    Left = 8
    Top = 280
    object Properties1: TMenuItem
      Caption = 'Properties'
      OnClick = Properties1Click
    end
    object SaveCoordinates1: TMenuItem
      AutoCheck = True
      Caption = 'Save Coordinates'
    end
  end
end
