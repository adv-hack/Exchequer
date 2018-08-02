object FSTKDisplay: TFSTKDisplay
  Left = 1003
  Top = 111
  BorderIcons = []
  BorderStyle = bsNone
  Caption = 'Misc'
  ClientHeight = 304
  ClientWidth = 332
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  OnActivate = FormActivate
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Clsdb1Btn: TButton
    Left = 64
    Top = 245
    Width = 80
    Height = 21
    Cancel = True
    Caption = 'C&lose'
    ModalResult = 2
    TabOrder = 0
  end
  object PopupMenu2: TPopupMenu
    Left = 22
    Top = 72
    object AsQuotation1: TMenuItem
      Tag = 10
      Caption = 'Print as &Quotation'
      Hint = 'Print as Quotation '
      OnClick = Acc1Click
    end
    object Order1: TMenuItem
      Tag = 11
      Caption = '&Order'
      Hint = 'Print Quotation as Order'
      OnClick = Acc1Click
    end
    object Proforma1: TMenuItem
      Tag = 12
      Caption = '&Proforma'
      Hint = 'Print Quotation as Proforma Invoice'
      OnClick = Acc1Click
    end
    object DeliveryNote1: TMenuItem
      Tag = 13
      Caption = '&Delivery Note'
      Hint = 'Print Quotation as Delivery Note'
      OnClick = Acc1Click
    end
    object PStkL: TMenuItem
      Tag = 255
      Caption = 'Print &Stock Labels for this Document'
      Hint = 'Print Stock Labels for all stock items on this transaction.'
      OnClick = Acc1Click
    end
    object Cancel1: TMenuItem
      Caption = '&Cancel'
      Hint = '&Cancel Quotation Print'
      OnClick = Cancel1Click
    end
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 100
    OnTimer = Timer1Timer
    Left = 185
    Top = 243
  end
  object PopupMenu1: TPopupMenu
    Left = 21
    Top = 19
    object MenuItem1: TMenuItem
      Tag = 8
      Caption = '&Account Details'
      Hint = 'Print Account Details'
      OnClick = Acc1Click
    end
    object MenuItem2: TMenuItem
      Tag = 3
      Caption = '&Statement'
      Hint = 'Print Account Statement'
      OnClick = Acc1Click
    end
    object MenuItem3: TMenuItem
      Tag = 5
      Caption = '&Trading Ledger'
      Hint = 'Print Account Trading Ledger'
      OnClick = Acc1Click
    end
    object MenuItem4: TMenuItem
      Caption = '&Cancel'
      Hint = 'Cancel Print Account Details'
      OnClick = Cancel1Click
    end
  end
  object PopupMenu3: TPopupMenu
    Left = 22
    Top = 129
    object MenuItem5: TMenuItem
      Tag = 18
      Caption = 'Print as &Picking List'
      HelpContext = 495
      Hint = 'Print Order as Picking List'
      OnClick = Acc1Click
    end
    object MenuItem6: TMenuItem
      Tag = 11
      Caption = '&Sales Order'
      HelpContext = 495
      Hint = 'Print as Order'
      OnClick = Acc1Click
    end
    object MenuItem7: TMenuItem
      Tag = 12
      Caption = 'Pro-&Forma'
      HelpContext = 495
      Hint = 'Print Order as Proforma Invoice'
      OnClick = Acc1Click
    end
    object PStkL2: TMenuItem
      Tag = 255
      Caption = 'Print &Stock Labels for this Document'
      Hint = 'Print Stock Labels for all stock items on this transaction.'
      OnClick = Acc1Click
    end
    object MenuItem9: TMenuItem
      Caption = '&Cancel'
      HelpContext = 495
      Hint = '&Cancel Print'
      OnClick = Cancel1Click
    end
  end
  object PopupMenu4: TPopupMenu
    Left = 21
    Top = 180
    object MenuItem8: TMenuItem
      Tag = 13
      Caption = 'Print as &Delivery Note'
      HelpContext = 492
      Hint = 'Print as Delivery Note'
      OnClick = Acc1Click
    end
    object MenuItem10: TMenuItem
      Tag = 19
      Caption = '&Consignment Note'
      HelpContext = 492
      Hint = 'Print Delivery Note as Consingment Note'
      OnClick = Acc1Click
    end
    object MenuItem11: TMenuItem
      Tag = 20
      Caption = 'Delivery &Label'
      HelpContext = 492
      Hint = 'Print Delivery Note as Delivery Label'
      OnClick = Acc1Click
    end
    object PStkL3: TMenuItem
      Tag = 255
      Caption = 'Print &Stock Labels for this Document'
      Hint = 'Print Stock Labels for all stock items on this transaction.'
      OnClick = Acc1Click
    end
    object MenuItem12: TMenuItem
      Caption = '&Cancel'
      HelpContext = 492
      Hint = '&Cancel Print'
      OnClick = Cancel1Click
    end
  end
  object PopupMenu5: TPopupMenu
    Left = 101
    Top = 21
    object MenuItem13: TMenuItem
      Tag = 11
      Caption = '&Stock Record'
      Hint = 'Print  Stock Record with Bill of Material Records'
      OnClick = Acc1Click
    end
    object MenuItem14: TMenuItem
      Tag = 17
      Caption = 'Stock &Notes'
      Hint = 'Print Stock Record with Notes'
      OnClick = Acc1Click
    end
    object MenuItem16: TMenuItem
      Caption = '&Cancel'
      Hint = '&Cancel Print'
      OnClick = Cancel1Click
    end
  end
  object PopupMenu6: TPopupMenu
    Left = 105
    Top = 75
    object MenuItem15: TMenuItem
      Tag = 1
      Caption = '&Print this Document'
      HelpContext = 495
      Hint = 'Print Transaction'
      OnClick = Acc1Click
    end
    object MenuItem17: TMenuItem
      Tag = 255
      Caption = 'Print &Stock Labels for this Document'
      HelpContext = 495
      Hint = 'Print Stock Labels for all stock items on this transaction.'
      OnClick = Acc1Click
    end
    object BinAvail1: TMenuItem
      Tag = 254
      Caption = 'Print &Bin Availability for this Document'
      Hint = 'Show Existing Bins with the same stock as this Document'
      OnClick = Acc1Click
    end
    object MenuItem19: TMenuItem
      Caption = '&Cancel'
      HelpContext = 495
      Hint = '&Cancel Print'
      OnClick = Cancel1Click
    end
  end
  object PopupMenu7: TPopupMenu
    Left = 103
    Top = 131
    object MenuItem18: TMenuItem
      Tag = 5
      Caption = 'Print as &Remittance Advice'
      Hint = 'Print as Remittance Advice'
      OnClick = Acc1Click
    end
    object MenuItem20: TMenuItem
      Tag = 46
      Caption = '&Debit Note'
      Hint = 'Print PPY as Debit Note'
      OnClick = Acc1Click
    end
    object MenuItem24: TMenuItem
      Caption = '&Cancel'
      Hint = '&Cancel Print'
      OnClick = Cancel1Click
    end
  end
  object PopupMenu8: TPopupMenu
    Left = 103
    Top = 181
    object MenuItem21: TMenuItem
      Tag = 62
      Caption = 'Print as &Sales Return'
      Hint = 'Print as Sales Return'
      OnClick = Acc1Click
    end
    object MenuItem22: TMenuItem
      Tag = 63
      Caption = 'Sales &Repair Quotation'
      Hint = 'Print SRN as Sales Repair Quotation'
      OnClick = Acc1Click
    end
    object MenuItem23: TMenuItem
      Caption = '&Cancel'
      Hint = '&Cancel Print'
      OnClick = Cancel1Click
    end
  end
  object popOrderPaymentsSRC: TPopupMenu
    Left = 208
    Top = 20
    object MenuItem25: TMenuItem
      Tag = 14
      Caption = 'Print as Receipt'
      Hint = 'Print as Receipt'
      OnClick = Acc1Click
    end
    object MenuItem26: TMenuItem
      Tag = 65
      Caption = 'Print as VAT Receipt'
      Hint = 'Print as VAT Receipt'
      OnClick = Acc1Click
    end
  end
end
