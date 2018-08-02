object frmObjectNorbert: TfrmObjectNorbert
  Left = 815
  Top = 197
  HelpContext = 2213
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Order Payments Tracker'
  ClientHeight = 322
  ClientWidth = 569
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Position = poDefault
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 14
  object panHeader: TPanel
    Left = 0
    Top = 0
    Width = 569
    Height = 37
    Align = alTop
    BevelOuter = bvNone
    Caption = '*** Display Warning / Notification Here ***'
    Color = clWhite
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
  end
  object panBody: TPanel
    Left = 0
    Top = 37
    Width = 569
    Height = 165
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      569
      165)
    object lblUnpaidTotal: TLabel
      Left = 406
      Top = 8
      Width = 58
      Height = 14
      Caption = 'Unpaid Total'
    end
    object lblTotalPaid: TLabel
      Left = 232
      Top = 8
      Width = 45
      Height = 14
      Caption = 'Total Paid'
    end
    object lblGrossTotal: TLabel
      Left = 16
      Top = 8
      Width = 86
      Height = 14
      Alignment = taRightJustify
      Caption = 'Order Gross Total'
    end
    object Bevel1: TBevel
      Left = 5
      Top = 31
      Width = 559
      Height = 5
      Shape = bsTopLine
    end
    object lvTransactionLines: TListView
      Left = 5
      Top = 37
      Width = 559
      Height = 128
      Anchors = [akLeft, akTop, akRight, akBottom]
      BorderStyle = bsNone
      Columns = <
        item
          Caption = 'Stock Code'
          Width = 110
        end
        item
          Alignment = taRightJustify
          Caption = 'Qty'
        end
        item
          Caption = 'Description'
          Width = 150
        end
        item
          Alignment = taRightJustify
          Caption = 'Gross Total'
          Width = 110
        end
        item
          Alignment = taRightJustify
          Caption = 'Payment Value'
          Width = 110
        end>
      HideSelection = False
      ReadOnly = True
      RowSelect = True
      TabOrder = 3
      ViewStyle = vsReport
      OnSelectItem = lvTransactionLinesSelectItem
    end
    object ccyUnpaidTotal: TCurrencyEdit
      Left = 467
      Top = 5
      Width = 97
      Height = 22
      TabStop = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        #163'1,122.78 ')
      ParentFont = False
      ReadOnly = True
      TabOrder = 2
      WantReturns = False
      WordWrap = False
      AutoSize = False
      BlockNegative = False
      BlankOnZero = False
      CurrencySymb = #163
      DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
      ShowCurrency = True
      TextId = 0
      Value = 1122.78
    end
    object ccyTotalPaid: TCurrencyEdit
      Left = 280
      Top = 5
      Width = 97
      Height = 22
      TabStop = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        #163'600.00 ')
      ParentFont = False
      ReadOnly = True
      TabOrder = 1
      WantReturns = False
      WordWrap = False
      AutoSize = False
      BlockNegative = False
      BlankOnZero = False
      CurrencySymb = #163
      DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
      ShowCurrency = True
      TextId = 0
      Value = 600
    end
    object ccyGrossTotal: TCurrencyEdit
      Left = 105
      Top = 5
      Width = 97
      Height = 22
      TabStop = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        #163'1,722.78 ')
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
      WantReturns = False
      WordWrap = False
      AutoSize = False
      BlockNegative = False
      BlankOnZero = False
      CurrencySymb = #163
      DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
      ShowCurrency = True
      TextId = 0
      Value = 1722.78
    end
  end
  object panFooter: TPanel
    Left = 0
    Top = 202
    Width = 569
    Height = 120
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    DesignSize = (
      569
      120)
    object lblOrdered: Label8
      Left = 23
      Top = 23
      Width = 40
      Height = 14
      Caption = 'Ordered'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Label81: Label8
      Left = 117
      Top = 4
      Width = 17
      Height = 14
      Caption = 'Qty'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object lblDelivered: Label8
      Left = 18
      Top = 71
      Width = 45
      Height = 14
      Caption = 'Delivered'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object lblWrittenOff: Label8
      Left = 10
      Top = 47
      Width = 53
      Height = 14
      Caption = 'Written Off'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object lblOutstanding: Label8
      Left = 5
      Top = 95
      Width = 58
      Height = 14
      Caption = 'Outstanding'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Label85: Label8
      Left = 262
      Top = 4
      Width = 41
      Height = 14
      Caption = 'Payment'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Label86: Label8
      Left = 322
      Top = 4
      Width = 61
      Height = 14
      Caption = 'Payment Qty'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Label87: Label8
      Left = 160
      Top = 4
      Width = 55
      Height = 14
      Caption = 'Gross Total'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object ccyOrderedQty: TCurrencyEdit
      Tag = 1
      Left = 67
      Top = 20
      Width = 76
      Height = 22
      HelpContext = 247
      TabStop = False
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        '15.00 ')
      MaxLength = 13
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
      WantReturns = False
      WordWrap = False
      AutoSize = False
      BlockNegative = False
      BlankOnZero = False
      DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
      ShowCurrency = False
      TextId = 0
      Value = 15
    end
    object ccyDeliveredQty: TCurrencyEdit
      Tag = 1
      Left = 67
      Top = 68
      Width = 76
      Height = 22
      HelpContext = 247
      TabStop = False
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        '2.00 ')
      MaxLength = 13
      ParentFont = False
      ReadOnly = True
      TabOrder = 6
      WantReturns = False
      WordWrap = False
      AutoSize = False
      BlockNegative = False
      BlankOnZero = False
      DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
      ShowCurrency = False
      TextId = 0
      Value = 2
    end
    object ccyWrittenOffQty: TCurrencyEdit
      Tag = 1
      Left = 67
      Top = 44
      Width = 76
      Height = 22
      HelpContext = 247
      TabStop = False
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        '1.00 ')
      MaxLength = 13
      ParentFont = False
      ReadOnly = True
      TabOrder = 4
      WantReturns = False
      WordWrap = False
      AutoSize = False
      BlockNegative = False
      BlankOnZero = False
      DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
      ShowCurrency = False
      TextId = 0
      Value = 1
    end
    object ccyOutstandingQty: TCurrencyEdit
      Tag = 1
      Left = 67
      Top = 92
      Width = 76
      Height = 22
      HelpContext = 247
      TabStop = False
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        '12.00 ')
      MaxLength = 13
      ParentFont = False
      ReadOnly = True
      TabOrder = 10
      WantReturns = False
      WordWrap = False
      AutoSize = False
      BlockNegative = False
      BlankOnZero = False
      DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
      ShowCurrency = False
      TextId = 0
      Value = 12
    end
    object ccyOrderedPaymentTotal: TCurrencyEdit
      Tag = 1
      Left = 236
      Top = 20
      Width = 76
      Height = 22
      HelpContext = 247
      TabStop = False
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        #163'532.86 ')
      MaxLength = 13
      ParentFont = False
      ReadOnly = True
      TabOrder = 2
      WantReturns = False
      WordWrap = False
      AutoSize = False
      BlockNegative = False
      BlankOnZero = False
      CurrencySymb = #163
      DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
      ShowCurrency = True
      TextId = 0
      Value = 532.86
    end
    object ccyDeliveredPaymentTotal: TCurrencyEdit
      Tag = 1
      Left = 236
      Top = 68
      Width = 76
      Height = 22
      HelpContext = 247
      TabStop = False
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        #163'204.00 ')
      MaxLength = 13
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
      Value = 204
    end
    object ccyOutstandingPaymentTotal: TCurrencyEdit
      Tag = 1
      Left = 236
      Top = 92
      Width = 76
      Height = 22
      HelpContext = 247
      TabStop = False
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        #163'328.86 ')
      MaxLength = 13
      ParentFont = False
      ReadOnly = True
      TabOrder = 12
      WantReturns = False
      WordWrap = False
      AutoSize = False
      BlockNegative = False
      BlankOnZero = False
      CurrencySymb = #163
      DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
      ShowCurrency = True
      TextId = 0
      Value = 328.86
    end
    object ccyOrderedPaymentQty: TCurrencyEdit
      Tag = 1
      Left = 316
      Top = 20
      Width = 76
      Height = 22
      HelpContext = 247
      TabStop = False
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        '5.22 ')
      MaxLength = 13
      ParentFont = False
      ReadOnly = True
      TabOrder = 3
      WantReturns = False
      WordWrap = False
      AutoSize = False
      BlockNegative = False
      BlankOnZero = False
      DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
      ShowCurrency = False
      TextId = 0
      Value = 5.22
    end
    object ccyDeliveredPaymentQty: TCurrencyEdit
      Tag = 1
      Left = 316
      Top = 68
      Width = 76
      Height = 22
      HelpContext = 247
      TabStop = False
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        '2.00 ')
      MaxLength = 13
      ParentFont = False
      ReadOnly = True
      TabOrder = 9
      WantReturns = False
      WordWrap = False
      AutoSize = False
      BlockNegative = False
      BlankOnZero = False
      DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
      ShowCurrency = False
      TextId = 0
      Value = 2
    end
    object ccyOutstandingPaymentQty: TCurrencyEdit
      Tag = 1
      Left = 316
      Top = 92
      Width = 76
      Height = 22
      HelpContext = 247
      TabStop = False
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        '3.22 ')
      MaxLength = 13
      ParentFont = False
      ReadOnly = True
      TabOrder = 13
      WantReturns = False
      WordWrap = False
      AutoSize = False
      BlockNegative = False
      BlankOnZero = False
      DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
      ShowCurrency = False
      TextId = 0
      Value = 3.22
    end
    object ccyOrderedGrossTotal: TCurrencyEdit
      Tag = 1
      Left = 148
      Top = 20
      Width = 76
      Height = 22
      HelpContext = 247
      TabStop = False
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        #163'1,530.00 ')
      MaxLength = 13
      ParentFont = False
      ReadOnly = True
      TabOrder = 1
      WantReturns = False
      WordWrap = False
      AutoSize = False
      BlockNegative = False
      BlankOnZero = False
      CurrencySymb = #163
      DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
      ShowCurrency = True
      TextId = 0
      Value = 1530
    end
    object ccyDeliveredGrossTotal: TCurrencyEdit
      Tag = 1
      Left = 148
      Top = 68
      Width = 76
      Height = 22
      HelpContext = 247
      TabStop = False
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        #163'204.00 ')
      MaxLength = 13
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
      Value = 204
    end
    object ccyOutstandingGrossTotal: TCurrencyEdit
      Tag = 1
      Left = 148
      Top = 92
      Width = 76
      Height = 22
      HelpContext = 247
      TabStop = False
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        #163'1,224.00 ')
      MaxLength = 13
      ParentFont = False
      ReadOnly = True
      TabOrder = 11
      WantReturns = False
      WordWrap = False
      AutoSize = False
      BlockNegative = False
      BlankOnZero = False
      CurrencySymb = #163
      DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
      ShowCurrency = True
      TextId = 0
      Value = 1224
    end
    object ccyWrittenOffGrossTotal: TCurrencyEdit
      Tag = 1
      Left = 148
      Top = 44
      Width = 76
      Height = 22
      HelpContext = 247
      TabStop = False
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        #163'102.00 ')
      MaxLength = 13
      ParentFont = False
      ReadOnly = True
      TabOrder = 5
      WantReturns = False
      WordWrap = False
      AutoSize = False
      BlockNegative = False
      BlankOnZero = False
      CurrencySymb = #163
      DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
      ShowCurrency = True
      TextId = 0
      Value = 102
    end
    object btnClose: TButton
      Left = 483
      Top = 94
      Width = 80
      Height = 21
      Anchors = [akRight, akBottom]
      Caption = '&Close'
      TabOrder = 14
      OnClick = btnCloseClick
    end
  end
end
