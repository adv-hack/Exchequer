object frmNomDefaults: TfrmNomDefaults
  Left = 240
  Top = 201
  BorderStyle = bsDialog
  Caption = 'Journal Defaults'
  ClientHeight = 174
  ClientWidth = 420
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 321
    Height = 161
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    object Label1: TLabel
      Left = 42
      Top = 44
      Width = 70
      Height = 14
      Alignment = taRightJustify
      Caption = 'GL Code/Desc'
    end
    object Label2: TLabel
      Left = 76
      Top = 72
      Width = 36
      Height = 14
      Alignment = taRightJustify
      Caption = 'CC/Dep'
    end
    object Label3: TLabel
      Left = 24
      Top = 100
      Width = 88
      Height = 14
      Alignment = taRightJustify
      Caption = 'VAT Code/Amount'
    end
    object Label4: TLabel
      Left = 58
      Top = 128
      Width = 54
      Height = 14
      Alignment = taRightJustify
      Caption = 'Description'
    end
    object Label5: TLabel
      Left = 8
      Top = 8
      Width = 289
      Height = 25
      AutoSize = False
      Caption = 'Please enter the required values for the journal line defaults'
    end
    object edtCC: Text8Pt
      Left = 120
      Top = 68
      Width = 49
      Height = 22
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnExit = edtCCExit
      TextId = 0
      ViaSBtn = False
    end
    object edtDep: Text8Pt
      Left = 172
      Top = 68
      Width = 49
      Height = 22
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      OnExit = edtCCExit
      TextId = 0
      ViaSBtn = False
    end
    object cbVatCode: TSBSComboBox
      Left = 120
      Top = 96
      Width = 49
      Height = 22
      Style = csDropDownList
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ItemHeight = 14
      MaxLength = 1
      ParentFont = False
      TabOrder = 4
      OnChange = cbVatCodeChange
      OnExit = cbVatCodeExit
      ExtendedList = True
      MaxListWidth = 90
    end
    object ceVatAmount: TCurrencyEdit
      Left = 172
      Top = 96
      Width = 80
      Height = 22
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'ARIAL'
      Font.Style = []
      Lines.Strings = (
        '0.00 ')
      ParentFont = False
      TabOrder = 5
      WantReturns = False
      WordWrap = False
      AutoSize = False
      BlockNegative = False
      BlankOnZero = False
      DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
      ShowCurrency = False
      TextId = 0
      Value = 1E-10
    end
    object edtDescription: Text8Pt
      Left = 120
      Top = 124
      Width = 185
      Height = 22
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 6
      TextId = 0
      ViaSBtn = False
    end
    object edtGLDesc: Text8Pt
      Left = 172
      Top = 40
      Width = 131
      Height = 22
      TabStop = False
      Color = clBtnFace
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ReadOnly = True
      ShowHint = True
      TabOrder = 1
      TextId = 0
      ViaSBtn = False
    end
    object edtGLCode: Text8Pt
      Left = 120
      Top = 40
      Width = 49
      Height = 22
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnExit = edtGLCodeExit
      TextId = 0
      ViaSBtn = False
    end
  end
  object SBSButton1: TSBSButton
    Left = 336
    Top = 8
    Width = 80
    Height = 21
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 1
    TextId = 0
  end
  object btnCancel: TSBSButton
    Left = 336
    Top = 32
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 2
    TextId = 0
  end
  object EnterToTab1: TEnterToTab
    ConvertEnters = True
    OverrideFont = True
    Version = 'TEnterToTab v1.02 for Delphi 6.01'
    Left = 384
    Top = 128
  end
end
