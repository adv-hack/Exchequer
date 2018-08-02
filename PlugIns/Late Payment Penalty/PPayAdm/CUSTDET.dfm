object frmCustDetails: TfrmCustDetails
  Left = 260
  Top = 172
  BorderStyle = bsDialog
  Caption = 'Customer Details'
  ClientHeight = 418
  ClientWidth = 512
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
  DesignSize = (
    512
    418)
  PixelsPerInch = 96
  TextHeight = 14
  object btnCancel: TButton
    Left = 424
    Top = 392
    Width = 80
    Height = 21
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = '&Cancel'
    TabOrder = 4
    OnClick = btnCancelClick
  end
  object btnOK: TButton
    Left = 336
    Top = 392
    Width = 80
    Height = 21
    Anchors = [akRight, akBottom]
    Caption = '&OK'
    TabOrder = 3
    OnClick = btnOKClick
  end
  object panCustomer: TPanel
    Left = 8
    Top = 8
    Width = 497
    Height = 66
    BevelOuter = bvNone
    TabOrder = 0
    object Bevel3: TBevel
      Left = 0
      Top = 0
      Width = 497
      Height = 65
      Shape = bsFrame
    end
    object lCustName: TLabel
      Left = 272
      Top = 12
      Width = 213
      Height = 14
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lCustCode: TLabel
      Left = 8
      Top = 12
      Width = 80
      Height = 14
      Caption = 'Customer Code :'
    end
    object cbInclude: TCheckBox
      Left = 120
      Top = 40
      Width = 145
      Height = 17
      Caption = 'Include in Scheme'
      TabOrder = 2
    end
    object edCustCode: TEdit
      Left = 120
      Top = 8
      Width = 121
      Height = 22
      MaxLength = 6
      TabOrder = 0
      OnChange = edCustCodeChange
      OnExit = edCustCodeExit
    end
    object btnFindCust: TButton
      Left = 240
      Top = 8
      Width = 23
      Height = 21
      Caption = '...'
      TabOrder = 1
      OnClick = btnFindCustClick
    end
  end
  object panDebt: TPanel
    Left = 8
    Top = 286
    Width = 497
    Height = 99
    BevelOuter = bvNone
    TabOrder = 2
    object Bevel2: TBevel
      Left = 0
      Top = 0
      Width = 497
      Height = 99
      Align = alClient
      Shape = bsFrame
    end
    object lDebtGLCode: TLabel
      Left = 8
      Top = 68
      Width = 111
      Height = 14
      Caption = 'Debt Charge GL Code :'
      Enabled = False
    end
    object lDebtGLName: TLabel
      Left = 272
      Top = 67
      Width = 213
      Height = 14
      AutoSize = False
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lDebtColl: TLabel
      Left = 8
      Top = 12
      Width = 107
      Height = 14
      Caption = 'Debt Collection Basis :'
    end
    object edDebtGLCode: TEdit
      Left = 120
      Top = 64
      Width = 121
      Height = 22
      Enabled = False
      TabOrder = 2
      OnChange = edDebtGLCodeChange
    end
    object btnFindDebtGLCode: TButton
      Left = 240
      Top = 64
      Width = 23
      Height = 21
      Caption = '...'
      Enabled = False
      TabOrder = 3
      OnClick = btnFindDebtGLCodeClick
    end
    object cmbDebtBasis: TComboBox
      Left = 120
      Top = 8
      Width = 145
      Height = 22
      Style = csDropDownList
      ItemHeight = 14
      ItemIndex = 0
      TabOrder = 0
      Text = 'not applicable'
      OnChange = cmbDebtBasisChange
      Items.Strings = (
        'not applicable'
        'per transaction'
        'per process')
    end
    object cbSyncGLs: TCheckBox
      Left = 120
      Top = 40
      Width = 161
      Height = 17
      Caption = 'Sync with Interest GL Code'
      Enabled = False
      TabOrder = 1
      OnClick = cbSyncGLsClick
    end
  end
  object panOther: TPanel
    Left = 8
    Top = 71
    Width = 497
    Height = 217
    BevelOuter = bvNone
    TabOrder = 1
    object Bevel4: TBevel
      Left = 0
      Top = 0
      Width = 497
      Height = 217
      Align = alClient
      Shape = bsFrame
    end
    object Bevel1: TBevel
      Left = 0
      Top = 151
      Width = 497
      Height = 66
      Shape = bsFrame
    end
    object lIntGLCode: TLabel
      Left = 8
      Top = 124
      Width = 87
      Height = 14
      Caption = 'Interest GL Code :'
    end
    object lIntGLName: TLabel
      Left = 272
      Top = 124
      Width = 213
      Height = 14
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lCC: TLabel
      Left = 8
      Top = 164
      Width = 63
      Height = 14
      Caption = 'Cost Centre :'
    end
    object lCCName: TLabel
      Left = 272
      Top = 164
      Width = 213
      Height = 14
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lDepartmentName: TLabel
      Left = 272
      Top = 188
      Width = 213
      Height = 14
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lDept: TLabel
      Left = 8
      Top = 188
      Width = 61
      Height = 14
      Caption = 'Department :'
    end
    object Label2: TLabel
      Left = 8
      Top = 68
      Width = 104
      Height = 14
      Caption = 'Default Interest Rate :'
    end
    object Label3: TLabel
      Left = 8
      Top = 12
      Width = 93
      Height = 14
      Caption = 'Min. Invoice Value :'
    end
    object lVariance: TLabel
      Left = 8
      Top = 92
      Width = 114
      Height = 14
      Caption = 'Interest Rate Variance :'
    end
    object Label5: TLabel
      Left = 192
      Top = 68
      Width = 10
      Height = 14
      Caption = '%'
    end
    object lPercent: TLabel
      Left = 240
      Top = 93
      Width = 10
      Height = 14
      Caption = '%'
    end
    object lEffective: TLabel
      Left = 272
      Top = 92
      Width = 113
      Height = 14
      Caption = 'Effective Interest Rate :'
    end
    object lEffectiveInterest: TLabel
      Left = 392
      Top = 92
      Width = 97
      Height = 14
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label1: TLabel
      Left = 8
      Top = 36
      Width = 96
      Height = 14
      Caption = 'Credit Days Offset :'
    end
    object edDefInterestRate: TCurrencyEdit
      Left = 120
      Top = 64
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
      TabOrder = 2
      WantReturns = False
      WordWrap = False
      AutoSize = False
      BlankOnZero = False
      DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
      ShowCurrency = False
      TextId = 0
      Value = 1E-10
    end
    object edMinValue: TCurrencyEdit
      Left = 120
      Top = 8
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
      TabOrder = 0
      WantReturns = False
      WordWrap = False
      AutoSize = False
      BlankOnZero = False
      DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
      ShowCurrency = False
      TextId = 0
      Value = 1E-10
    end
    object edIntGLCode: TEdit
      Left = 120
      Top = 120
      Width = 121
      Height = 22
      TabOrder = 5
      OnChange = edIntGLCodeChange
      OnExit = edIntGLCodeExit
    end
    object btnFindIntGLCode: TButton
      Left = 240
      Top = 120
      Width = 23
      Height = 21
      Caption = '...'
      TabOrder = 6
      OnClick = btnFindIntGLCodeClick
    end
    object edCC: TEdit
      Left = 120
      Top = 160
      Width = 121
      Height = 22
      MaxLength = 3
      TabOrder = 7
      OnChange = edCCChange
      OnExit = edCCExit
    end
    object btnFindCC: TButton
      Left = 240
      Top = 160
      Width = 23
      Height = 21
      Caption = '...'
      TabOrder = 8
      OnClick = btnFindCCClick
    end
    object btnFindDept: TButton
      Left = 240
      Top = 184
      Width = 23
      Height = 21
      Caption = '...'
      TabOrder = 10
      OnClick = btnFindDeptClick
    end
    object edDept: TEdit
      Left = 120
      Top = 184
      Width = 121
      Height = 22
      MaxLength = 3
      TabOrder = 9
      OnChange = edDeptChange
      OnExit = edDeptExit
    end
    object cmbSign: TComboBox
      Left = 120
      Top = 88
      Width = 41
      Height = 24
      Style = csDropDownList
      Ctl3D = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ItemHeight = 16
      ItemIndex = 0
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 3
      Text = '+'
      OnChange = edInterestVarianceChange
      Items.Strings = (
        '+'
        ' -')
    end
    object edInterestVariance: TCurrencyEdit
      Left = 168
      Top = 89
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
      TabOrder = 4
      WantReturns = False
      WordWrap = False
      OnChange = edInterestVarianceChange
      AutoSize = False
      BlankOnZero = False
      DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
      ShowCurrency = False
      TextId = 0
      Value = 1E-10
    end
    object edCreditDays: TCurrencyEdit
      Left = 120
      Top = 32
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
      TabOrder = 1
      WantReturns = False
      WordWrap = False
      AutoSize = False
      BlankOnZero = False
      DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
      ShowCurrency = False
      TextId = 0
      Value = 1E-10
    end
  end
  object pmMain: TPopupMenu
    Left = 8
    Top = 392
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
