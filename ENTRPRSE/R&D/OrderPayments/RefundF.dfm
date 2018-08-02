object frmOrderPaymentRefund: TfrmOrderPaymentRefund
  Left = 397
  Top = 156
  Width = 1011
  Height = 551
  HelpContext = 2209
  BorderIcons = [biSystemMenu]
  Caption = 'Give Refund'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  FormStyle = fsMDIChild
  KeyPreview = True
  OldCreateOrder = False
  Position = poDefaultPosOnly
  Scaled = False
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnMouseWheelDown = FormMouseWheelDown
  OnMouseWheelUp = FormMouseWheelUp
  PixelsPerInch = 96
  TextHeight = 14
  object panRefund: TPanel
    Left = 0
    Top = 37
    Width = 995
    Height = 475
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      995
      475)
    object Label2: TLabel
      Left = 7
      Top = 7
      Width = 320
      Height = 14
      Caption = 
        'The following payments against this transaction can be refunded:' +
        '-'
    end
    object Label3: TLabel
      Left = 48
      Top = 35
      Width = 61
      Height = 14
      Caption = 'Payment Ref'
    end
    object Label4: TLabel
      Left = 128
      Top = 35
      Width = 23
      Height = 14
      Caption = 'User'
    end
    object Label5: TLabel
      Left = 239
      Top = 35
      Width = 47
      Height = 14
      Caption = 'Date/Time'
    end
    object Label6: TLabel
      Left = 348
      Top = 35
      Width = 102
      Height = 14
      Caption = 'Payment Card Details'
    end
    object Label7: TLabel
      Left = 512
      Top = 35
      Width = 80
      Height = 14
      Caption = 'Original Payment'
    end
    object Label12: TLabel
      Left = 619
      Top = 35
      Width = 80
      Height = 14
      Caption = 'Refunds To Date'
    end
    object Label14: TLabel
      Left = 735
      Top = 35
      Width = 71
      Height = 14
      Caption = 'Payment Value'
    end
    object lblCreditCardPayment: TLabel
      Left = 5
      Top = 355
      Width = 98
      Height = 14
      Anchors = [akLeft, akBottom]
      Caption = 'Credit Card Payment'
    end
    object Label28: TLabel
      Left = 29
      Top = 407
      Width = 75
      Height = 14
      Anchors = [akLeft, akBottom]
      Caption = 'Refund Reason'
    end
    object Label1: TLabel
      Left = 679
      Top = 324
      Width = 60
      Height = 14
      Anchors = [akLeft, akBottom]
      Caption = 'Refund Total'
    end
    object Label29: TLabel
      Left = 470
      Top = 324
      Width = 98
      Height = 14
      Anchors = [akLeft, akBottom]
      Caption = 'Refund VAT Content'
    end
    object Label30: TLabel
      Left = 277
      Top = 323
      Width = 79
      Height = 14
      Anchors = [akLeft, akBottom]
      Caption = 'Refund Net Total'
    end
    object Label8: TLabel
      Left = 44
      Top = 379
      Width = 60
      Height = 14
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      Caption = 'Refund Date'
    end
    object btnRefund: TButton
      Left = 128
      Top = 450
      Width = 80
      Height = 21
      Anchors = [akLeft, akBottom]
      Caption = '&Refund'
      TabOrder = 0
      OnClick = btnRefundClick
    end
    object btnCancel: TButton
      Left = 217
      Top = 450
      Width = 80
      Height = 21
      Anchors = [akLeft, akBottom]
      Cancel = True
      Caption = '&Cancel'
      TabOrder = 1
      OnClick = btnCancelClick
    end
    object chkPrintVATReceipt: TCheckBox
      Left = 19
      Top = 429
      Width = 103
      Height = 17
      Alignment = taLeftJustify
      Anchors = [akLeft, akBottom]
      Caption = 'Print VAT Receipt'
      TabOrder = 2
    end
    object scrollPayments: TScrollBox
      Left = 21
      Top = 52
      Width = 968
      Height = 264
      Anchors = [akLeft, akTop, akBottom]
      Color = clWindow
      ParentColor = False
      TabOrder = 3
    end
    object lstCreditCardPayment: TComboBox
      Left = 109
      Top = 351
      Width = 217
      Height = 22
      Style = csDropDownList
      Anchors = [akLeft, akBottom]
      Font.Charset = ANSI_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ItemHeight = 14
      ParentFont = False
      TabOrder = 4
      Items.Strings = (
        'Credit Account only'
        'Request Credit Card Refund')
    end
    object edtRefundReason: TEdit
      Left = 109
      Top = 403
      Width = 217
      Height = 22
      Anchors = [akLeft, akBottom]
      Font.Charset = ANSI_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 6
    end
    object ccyTotalRefund: TCurrencyEdit
      Left = 745
      Top = 321
      Width = 97
      Height = 22
      TabStop = False
      Anchors = [akLeft, akBottom]
      Font.Charset = ANSI_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        #163'0.00 ')
      ParentFont = False
      ReadOnly = True
      TabOrder = 7
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
    object ccyTotalVATRefund: TCurrencyEdit
      Left = 573
      Top = 321
      Width = 97
      Height = 22
      TabStop = False
      Anchors = [akLeft, akBottom]
      Font.Charset = ANSI_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        #163'0.00 ')
      ParentFont = False
      ReadOnly = True
      TabOrder = 8
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
    object ccyTotalGoodsREfund: TCurrencyEdit
      Left = 361
      Top = 321
      Width = 97
      Height = 22
      TabStop = False
      Anchors = [akLeft, akBottom]
      Font.Charset = ANSI_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        #163'0.00 ')
      ParentFont = False
      ReadOnly = True
      TabOrder = 9
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
    object edtRefundDate: TEditDate
      Tag = 1
      Left = 109
      Top = 377
      Width = 80
      Height = 22
      HelpContext = 143
      Anchors = [akLeft, akBottom]
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
      TabOrder = 5
      Placement = cpAbove
    end
  end
  object panManualVATWarning: TPanel
    Left = 0
    Top = 0
    Width = 995
    Height = 37
    Align = alTop
    BevelOuter = bvNone
    Caption = 
      'WARNING: This Transaction has VAT Content Amended set, please ch' +
      'eck figures'
    Color = clWhite
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
  end
  object EnterToTab1: TEnterToTab
    ConvertEnters = True
    OverrideFont = False
    Version = 'TEnterToTab v1.02 for Delphi 6.01'
    Left = 789
    Top = 387
  end
  object mnuPopup: TPopupMenu
    Left = 722
    Top = 390
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
