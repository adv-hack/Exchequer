object Form1: TForm1
  Left = 211
  Top = 191
  BorderStyle = bsDialog
  Caption = 'Create Records'
  ClientHeight = 222
  ClientWidth = 450
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 345
    Height = 145
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    object Label1: TLabel
      Left = 143
      Top = 48
      Width = 97
      Height = 13
      Alignment = taRightJustify
      Caption = 'Customers/Suppliers'
    end
    object Label2: TLabel
      Left = 212
      Top = 80
      Width = 28
      Height = 13
      Alignment = taRightJustify
      Caption = 'Stock'
    end
    object Label3: TLabel
      Left = 134
      Top = 112
      Width = 106
      Height = 13
      Alignment = taRightJustify
      Caption = 'Transactions (monthly)'
    end
    object Label4: TLabel
      Left = 173
      Top = 16
      Width = 67
      Height = 13
      Alignment = taRightJustify
      Caption = 'Database size'
    end
    object Label5: TLabel
      Left = 28
      Top = 16
      Width = 44
      Height = 13
      Alignment = taRightJustify
      Caption = 'Company'
    end
    object ceCustSupp: TCurrencyEdit
      Left = 248
      Top = 44
      Width = 80
      Height = 21
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'ARIAL'
      Font.Style = []
      Lines.Strings = (
        '0 ')
      ParentFont = False
      TabOrder = 0
      WantReturns = False
      WordWrap = False
      AutoSize = False
      BlankOnZero = False
      DisplayFormat = '###,###,##0 ;###,###,##0'
      ShowCurrency = False
      TextId = 0
      Value = 1E-10
    end
    object ceStock: TCurrencyEdit
      Left = 248
      Top = 76
      Width = 80
      Height = 21
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'ARIAL'
      Font.Style = []
      Lines.Strings = (
        '0 ')
      ParentFont = False
      TabOrder = 1
      WantReturns = False
      WordWrap = False
      AutoSize = False
      BlankOnZero = False
      DisplayFormat = '###,###,##0 ;###,###,##0'
      ShowCurrency = False
      TextId = 0
      Value = 1E-10
    end
    object ceTrans: TCurrencyEdit
      Left = 248
      Top = 108
      Width = 80
      Height = 21
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'ARIAL'
      Font.Style = []
      Lines.Strings = (
        '0 ')
      ParentFont = False
      TabOrder = 2
      WantReturns = False
      WordWrap = False
      AutoSize = False
      BlankOnZero = False
      DisplayFormat = '###,###,##0 ;###,###,##0'
      ShowCurrency = False
      TextId = 0
      Value = 1E-10
    end
    object cbSize: TSBSComboBox
      Left = 248
      Top = 12
      Width = 81
      Height = 22
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ItemHeight = 14
      ItemIndex = 0
      ParentFont = False
      TabOrder = 3
      Text = 'Small'
      OnChange = cbSizeChange
      Items.Strings = (
        'Small'
        'Medium'
        'Large')
      MaxListWidth = 0
    end
    object cbCompany: TSBSComboBox
      Left = 80
      Top = 10
      Width = 81
      Height = 22
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ItemHeight = 14
      ParentFont = False
      TabOrder = 4
      MaxListWidth = 0
    end
  end
  object Panel2: TPanel
    Left = 8
    Top = 160
    Width = 345
    Height = 57
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 1
    object lblRecType: Label8
      Left = 8
      Top = 8
      Width = 321
      Height = 17
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object lblRecProgress: Label8
      Left = 8
      Top = 32
      Width = 321
      Height = 17
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
  end
  object btnGo: TSBSButton
    Left = 360
    Top = 8
    Width = 80
    Height = 21
    Caption = '&Go'
    TabOrder = 2
    OnClick = btnGoClick
    TextId = 0
  end
  object btnClose: TSBSButton
    Left = 360
    Top = 56
    Width = 80
    Height = 21
    Caption = '&Close'
    TabOrder = 3
    OnClick = btnCloseClick
    TextId = 0
  end
  object btnGLs: TSBSButton
    Left = 360
    Top = 32
    Width = 80
    Height = 21
    Caption = 'GLs'
    TabOrder = 4
    OnClick = btnGLsClick
    TextId = 0
  end
end
