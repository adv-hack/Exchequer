object frmOrderPaymentRefundLineQty: TfrmOrderPaymentRefundLineQty
  Left = 476
  Top = 347
  HelpContext = 2209
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Edit Refund Value'
  ClientHeight = 281
  ClientWidth = 730
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poOwnerFormCenter
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 14
  object panRefund: TPanel
    Left = 0
    Top = 37
    Width = 730
    Height = 204
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object Label3: TLabel
      Left = 11
      Top = 71
      Width = 355
      Height = 14
      AutoSize = False
      Caption = 'How do you want to apply a Refund to this line:-'
    end
    object lblOutstanding: TLabel
      Left = 199
      Top = 150
      Width = 123
      Height = 14
      Caption = 'Remaining Payment Value'
    end
    object Label4: TLabel
      Left = 45
      Top = 150
      Width = 65
      Height = 14
      Caption = 'Refund Value'
    end
    object radNoRefund: TRadioButton
      Left = 26
      Top = 89
      Width = 105
      Height = 17
      Caption = 'No Refund'
      TabOrder = 0
      OnClick = DoCheckyChecky
    end
    object radFullRefund: TRadioButton
      Left = 26
      Top = 107
      Width = 280
      Height = 17
      Caption = 'Full Refund of Existing Payment'
      TabOrder = 1
      OnClick = DoCheckyChecky
    end
    object radPartRefundByValue: TRadioButton
      Left = 26
      Top = 126
      Width = 184
      Height = 17
      Caption = 'Part Refund by Value'
      TabOrder = 2
      OnClick = DoCheckyChecky
    end
    object btnOK: TButton
      Left = 270
      Top = 177
      Width = 80
      Height = 21
      Caption = '&OK'
      TabOrder = 5
      OnClick = btnOKClick
    end
    object btnCancel: TButton
      Left = 356
      Top = 177
      Width = 80
      Height = 21
      Cancel = True
      Caption = '&Cancel'
      ModalResult = 2
      TabOrder = 6
    end
    object lvPaymentLines: TListView
      Left = 6
      Top = 9
      Width = 718
      Height = 59
      BorderStyle = bsNone
      Columns = <
        item
          Caption = 'Stock Code'
          Width = 120
        end
        item
          Alignment = taRightJustify
          Caption = 'Qty'
        end
        item
          Caption = 'Description'
          Width = 200
        end
        item
          Alignment = taRightJustify
          Caption = 'Unit Price'
          Width = 90
        end
        item
          Alignment = taRightJustify
          Caption = 'Gross Line Total'
          Width = 110
        end
        item
          Alignment = taRightJustify
          Caption = 'Payment Value'
          Width = 110
        end>
      ReadOnly = True
      RowSelect = True
      TabOrder = 7
      ViewStyle = vsReport
    end
    object ccyPartRefundValue: TCurrencyEdit
      Left = 114
      Top = 147
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
      TabOrder = 3
      WantReturns = False
      WordWrap = False
      OnChange = ccyPartRefundValueChange
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
      Left = 327
      Top = 147
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
      TabOrder = 4
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
  end
  object panManualVATWarning: TPanel
    Left = 0
    Top = 0
    Width = 730
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
    Left = 561
    Top = 83
  end
end
