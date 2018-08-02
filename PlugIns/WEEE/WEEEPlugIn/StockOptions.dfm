object frmStockOptions: TfrmStockOptions
  Left = 453
  Top = 268
  BorderStyle = bsDialog
  Caption = 'WEEE Stock Options'
  ClientHeight = 349
  ClientWidth = 365
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object lStockCode: TLabel
    Left = 8
    Top = 8
    Width = 68
    Height = 14
    Caption = 'STK-ITEM-123'
  end
  object lDesc1: TLabel
    Left = 24
    Top = 24
    Width = 143
    Height = 14
    Caption = 'Description oif yje stocvk item'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object lDesc2: TLabel
    Left = 24
    Top = 40
    Width = 143
    Height = 14
    Caption = 'Description oif yje stocvk item'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object lDesc3: TLabel
    Left = 24
    Top = 56
    Width = 143
    Height = 14
    Caption = 'Description oif yje stocvk item'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object lDesc4: TLabel
    Left = 24
    Top = 72
    Width = 143
    Height = 14
    Caption = 'Description oif yje stocvk item'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object lDesc5: TLabel
    Left = 24
    Top = 88
    Width = 143
    Height = 14
    Caption = 'Description oif yje stocvk item'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object lDesc6: TLabel
    Left = 24
    Top = 104
    Width = 143
    Height = 14
    Caption = 'Description oif yje stocvk item'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object panWEEEDetails: TPanel
    Left = 0
    Top = 120
    Width = 361
    Height = 233
    BevelOuter = bvNone
    TabOrder = 0
    object Bevel4: TBevel
      Left = 8
      Top = 167
      Width = 345
      Height = 26
      Shape = bsFrame
    end
    object Bevel3: TBevel
      Left = 8
      Top = 7
      Width = 345
      Height = 74
      Shape = bsFrame
    end
    object Bevel2: TBevel
      Left = 8
      Top = 95
      Width = 153
      Height = 74
      Shape = bsFrame
    end
    object Label3: TLabel
      Left = 112
      Top = 172
      Width = 148
      Height = 14
      Caption = ' WEEE Charge per stock item : '
    end
    object Bevel1: TBevel
      Left = 159
      Top = 95
      Width = 194
      Height = 74
      Shape = bsFrame
    end
    object lchargeperkg: TLabel
      Left = 170
      Top = 113
      Width = 76
      Height = 14
      Caption = 'Charge per Kg :'
    end
    object lNoOfKgs: TLabel
      Left = 171
      Top = 137
      Width = 54
      Height = 14
      Caption = 'No of Kgs :'
    end
    object lSetCharge: TLabel
      Left = 18
      Top = 125
      Width = 41
      Height = 14
      Caption = 'Charge :'
    end
    object lCharge: TLabel
      Left = 312
      Top = 172
      Width = 21
      Height = 14
      Alignment = taRightJustify
      Caption = '0.00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 10485760
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label8: TLabel
      Left = 16
      Top = 20
      Width = 85
      Height = 14
      Caption = 'Report Category :'
    end
    object Label1: TLabel
      Left = 16
      Top = 52
      Width = 107
      Height = 14
      Caption = 'Report Sub Category :'
    end
    object edSetValue: TCurrencyEdit
      Left = 64
      Top = 120
      Width = 80
      Height = 25
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
      OnChange = ChargeChange
      AutoSize = False
      BlankOnZero = False
      DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
      ShowCurrency = False
      TextId = 0
      Value = 1E-10
    end
    object edChargePerKg: TCurrencyEdit
      Left = 256
      Top = 108
      Width = 80
      Height = 25
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
      OnChange = ChargeChange
      AutoSize = False
      BlankOnZero = False
      DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
      ShowCurrency = False
      TextId = 0
      Value = 1E-10
    end
    object edNoOfKg: TCurrencyEdit
      Left = 256
      Top = 132
      Width = 80
      Height = 25
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'ARIAL'
      Font.Style = []
      Lines.Strings = (
        '0.00 ')
      ParentFont = False
      TabOrder = 5
      WantReturns = False
      WordWrap = False
      OnChange = ChargeChange
      AutoSize = False
      BlankOnZero = False
      DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
      ShowCurrency = False
      TextId = 0
      Value = 1E-10
    end
    object rbSetValue: TRadioButton
      Left = 16
      Top = 88
      Width = 73
      Height = 17
      Caption = 'Set Value'
      Checked = True
      TabOrder = 1
      TabStop = True
      OnClick = ChangeValueMethod
    end
    object rbCalcValue: TRadioButton
      Left = 168
      Top = 88
      Width = 105
      Height = 17
      Caption = 'Calculated Value'
      TabOrder = 3
      OnClick = ChangeValueMethod
    end
    object cmbReportCat: TComboBox
      Left = 128
      Top = 16
      Width = 209
      Height = 22
      Style = csDropDownList
      ItemHeight = 14
      TabOrder = 0
      OnChange = cmbReportCatChange
    end
    object btnOK: TButton
      Left = 184
      Top = 200
      Width = 80
      Height = 21
      Caption = '&OK'
      TabOrder = 6
      OnClick = btnOKClick
    end
    object btnCancel: TButton
      Left = 272
      Top = 200
      Width = 80
      Height = 21
      Cancel = True
      Caption = '&Cancel'
      TabOrder = 7
      OnClick = btnCancelClick
    end
    object cmbReportSubCat: TComboBox
      Left = 128
      Top = 48
      Width = 209
      Height = 22
      Style = csDropDownList
      ItemHeight = 14
      TabOrder = 8
    end
  end
  object EnterToTab1: TEnterToTab
    ConvertEnters = True
    OverrideFont = True
    Version = 'TEnterToTab v1.02 for Delphi 6.01'
    Left = 328
    Top = 8
  end
end
