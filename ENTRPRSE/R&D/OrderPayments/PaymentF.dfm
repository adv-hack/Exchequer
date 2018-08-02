object frmOrderPayment: TfrmOrderPayment
  Left = 528
  Top = 249
  HelpContext = 2208
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Take Order Payment'
  ClientHeight = 418
  ClientWidth = 409
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  FormStyle = fsMDIChild
  KeyPreview = True
  OldCreateOrder = False
  PopupMenu = mnuPopup
  Position = poDefaultPosOnly
  Scaled = False
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object panManualVATWarning: TPanel
    Left = 0
    Top = 0
    Width = 409
    Height = 48
    Align = alTop
    BevelOuter = bvNone
    Color = clWhite
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    DesignSize = (
      409
      48)
    object labManualVATWarning: TLabel
      Left = 8
      Top = 8
      Width = 393
      Height = 32
      Alignment = taCenter
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Caption = 
        'WARNING: This Transaction has VAT Content Amended set, please ch' +
        'eck figures'
      WordWrap = True
    end
  end
  object panPayment: TPanel
    Left = 0
    Top = 48
    Width = 409
    Height = 339
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object Label1: TLabel
      Left = 26
      Top = 210
      Width = 81
      Height = 14
      Alignment = taRightJustify
      Caption = 'Receipt GL Code'
    end
    object lblGLDesc: TLabel
      Left = 216
      Top = 210
      Width = 248
      Height = 14
      AutoSize = False
      Caption = 'Bank - Dong'
    end
    object lblPaymentReference: TLabel
      Left = 57
      Top = 263
      Width = 50
      Height = 14
      Alignment = taRightJustify
      Caption = 'Pay-In Ref'
    end
    object lblCreditCrdPayment: TLabel
      Left = 28
      Top = 71
      Width = 79
      Height = 14
      Alignment = taRightJustify
      Caption = 'Payment Method'
    end
    object lblOutstanding: TLabel
      Left = 239
      Top = 32
      Width = 58
      Height = 14
      Caption = 'Outstanding'
    end
    object lblPaymentCCDept: TLabel
      Left = 29
      Top = 238
      Width = 78
      Height = 14
      Alignment = taRightJustify
      Caption = 'Receipt CC/Dept'
    end
    object Label3: TLabel
      Left = 46
      Top = 182
      Width = 61
      Height = 14
      Alignment = taRightJustify
      Caption = 'Receipt Date'
    end
    object radFullPayment: TRadioButton
      Left = 23
      Top = 7
      Width = 237
      Height = 17
      Caption = 'Full Payment - '#163'750.00'
      Checked = True
      TabOrder = 0
      TabStop = True
      OnClick = DoCheckyChecky
    end
    object radPartPayment: TRadioButton
      Left = 23
      Top = 31
      Width = 131
      Height = 17
      Caption = 'Part Payment / Deposit'
      TabOrder = 1
      OnClick = DoCheckyChecky
    end
    object edtPaymentReference: TEdit
      Left = 112
      Top = 260
      Width = 97
      Height = 22
      Font.Charset = ANSI_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      MaxLength = 10
      ParentFont = False
      TabOrder = 10
    end
    object btnTakePayment: TButton
      Left = 120
      Top = 312
      Width = 80
      Height = 21
      Caption = '&Take Payment'
      TabOrder = 12
      OnClick = btnTakePaymentClick
    end
    object btnCancel: TButton
      Left = 209
      Top = 312
      Width = 80
      Height = 21
      Cancel = True
      Caption = '&Cancel'
      TabOrder = 13
      OnClick = btnCancelClick
    end
    object lstCreditCardPayment: TComboBox
      Left = 112
      Top = 67
      Width = 284
      Height = 22
      Style = csDropDownList
      Font.Charset = ANSI_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ItemHeight = 14
      ParentFont = False
      TabOrder = 4
      OnChange = lstCreditCardPaymentChange
      Items.Strings = (
        'Non Card Payment'
        'Request Card Authentication'
        'Pay by Card'
        'Request Payment Authorisation')
    end
    object ccyPartPaymentAmount: TCurrencyEdit
      Left = 156
      Top = 29
      Width = 75
      Height = 22
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'ARIAL'
      Font.Style = []
      Lines.Strings = (
        #163'0.00 ')
      MaxLength = 12
      ParentFont = False
      TabOrder = 2
      WantReturns = False
      WordWrap = False
      OnChange = ccyPartPaymentAmountChange
      OnExit = ccyPartPaymentAmountExit
      AutoSize = False
      BlockNegative = False
      BlankOnZero = False
      CurrencySymb = #163
      DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
      ShowCurrency = True
      TextId = 0
      Value = 1E-10
    end
    object ccyPartPaymentOutstanding: TCurrencyEdit
      Left = 303
      Top = 29
      Width = 75
      Height = 22
      TabStop = False
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'ARIAL'
      Font.Style = []
      Lines.Strings = (
        #163'0.00 ')
      ParentFont = False
      ReadOnly = True
      TabOrder = 3
      WantReturns = False
      WordWrap = False
      AutoSize = False
      BlockNegative = False
      BlankOnZero = False
      CurrencySymb = #163
      DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
      ShowCurrency = True
      TextId = 0
      Value = 1E-10
    end
    object chkPrintVATReceipt: TCheckBox
      Left = 23
      Top = 288
      Width = 103
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Print VAT Receipt'
      TabOrder = 11
    end
    object edtPaymentGL: Text8Pt
      Left = 112
      Top = 207
      Width = 97
      Height = 22
      Font.Charset = ANSI_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 7
      OnExit = edtPaymentGLExit
      TextId = 0
      ViaSBtn = False
    end
    object edtPaymentCostCentre: Text8Pt
      Tag = 1
      Left = 112
      Top = 234
      Width = 39
      Height = 22
      HelpContext = 272
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      MaxLength = 3
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 8
      OnExit = edtPaymentCostCentreExit
      TextId = 0
      ViaSBtn = False
    end
    object edtPaymentDepartment: Text8Pt
      Tag = 1
      Left = 153
      Top = 234
      Width = 39
      Height = 22
      HelpContext = 272
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      MaxLength = 3
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 9
      OnExit = edtPaymentCostCentreExit
      TextId = 0
      ViaSBtn = False
    end
    object panContactDetails: TPanel
      Left = 4
      Top = 95
      Width = 584
      Height = 68
      BevelOuter = bvNone
      TabOrder = 5
      object lblContactDetails: TLabel
        Left = 26
        Top = 0
        Width = 79
        Height = 14
        Alignment = taRightJustify
        Caption = 'Contact Details:-'
      end
      object lstCreditCardContact: TComboBox
        Left = 108
        Top = 18
        Width = 284
        Height = 22
        Style = csDropDownList
        Enabled = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 14
        ParentFont = False
        TabOrder = 2
      end
      object radContactRole: TRadioButton
        Left = 19
        Top = 22
        Width = 86
        Height = 17
        Caption = 'Use Contact'
        TabOrder = 0
        OnClick = DoCheckyChecky2
      end
      object radManualContact: TRadioButton
        Left = 19
        Top = 48
        Width = 89
        Height = 17
        Caption = 'Contact Name'
        TabOrder = 1
        OnClick = DoCheckyChecky2
      end
      object edtContactName: Text8Pt
        Left = 108
        Top = 46
        Width = 284
        Height = 22
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 45
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 3
        TextId = 0
        ViaSBtn = False
      end
    end
    object edtReceiptDate: TEditDate
      Tag = 1
      Left = 112
      Top = 180
      Width = 80
      Height = 22
      HelpContext = 143
      AutoSelect = False
      Color = clWhite
      EditMask = '00/00/0000;0;'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      MaxLength = 10
      ParentFont = False
      TabOrder = 6
      Placement = cpAbove
    end
  end
  object EnterToTab1: TEnterToTab
    ConvertEnters = True
    OverrideFont = False
    Version = 'TEnterToTab v1.02 for Delphi 6.01'
    Left = 281
    Top = 297
  end
  object mnuPopup: TPopupMenu
    Left = 343
    Top = 297
    object PropFlg: TMenuItem
      Caption = '&Properties'
      HelpContext = 65
      Hint = 'Access Colour & Font settings'
      OnClick = PropFlgClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object optStoreCoordinates: TMenuItem
      AutoCheck = True
      Caption = '&Save Coordinates'
      HelpContext = 177
      Hint = 'Make the current window settings permanent'
    end
    object N3: TMenuItem
      Caption = '-'
      Enabled = False
      Visible = False
    end
  end
end
