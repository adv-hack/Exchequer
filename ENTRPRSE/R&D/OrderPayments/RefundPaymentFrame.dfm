object framePaymentDetails: TframePaymentDetails
  Left = 0
  Top = 0
  Width = 938
  Height = 133
  Font.Charset = ANSI_CHARSET
  Font.Color = clNavy
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  ParentFont = False
  TabOrder = 0
  DesignSize = (
    938
    133)
  object lblUserName: TLabel
    Left = 104
    Top = 5
    Width = 104
    Height = 14
    AutoSize = False
    Caption = 'WWWWWWWWWW'
    Font.Charset = ANSI_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblDateTime: TLabel
    Left = 215
    Top = 5
    Width = 102
    Height = 14
    AutoSize = False
    Caption = '22/03/2014  15:16'
    Font.Charset = ANSI_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblCreditCardDetails: TLabel
    Left = 324
    Top = 5
    Width = 137
    Height = 14
    AutoSize = False
    Caption = 'VISA 1234 Exp 12/2016'
    Font.Charset = ANSI_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblOriginalPaymentValue: TLabel
    Left = 468
    Top = 5
    Width = 100
    Height = 14
    Alignment = taRightJustify
    AutoSize = False
    Caption = #163'795.00'
    Font.Charset = ANSI_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblPaymentOurRef: TLabel
    Left = 23
    Top = 5
    Width = 74
    Height = 14
    AutoSize = False
    Caption = 'SRC000001'
    Font.Charset = ANSI_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    OnClick = lblPaymentOurRefClick
  end
  object lblTotalRefundValue: TLabel
    Left = 575
    Top = 5
    Width = 100
    Height = 14
    Alignment = taRightJustify
    AutoSize = False
    Caption = #163'795.00'
    Font.Charset = ANSI_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblNetPaymentValue: TLabel
    Left = 682
    Top = 5
    Width = 100
    Height = 14
    Alignment = taRightJustify
    AutoSize = False
    Caption = #163'795.00'
    Font.Charset = ANSI_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object chkPayRef: TCheckBox
    Left = 5
    Top = 3
    Width = 19
    Height = 17
    Font.Charset = ANSI_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    OnClick = chkPayRefClick
  end
  object lvPaymentLines: TListView
    Left = 25
    Top = 23
    Width = 821
    Height = 31
    BorderStyle = bsNone
    Checkboxes = True
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
      end
      item
        Alignment = taRightJustify
        Caption = 'Refund Value'
        Width = 110
      end>
    ReadOnly = True
    RowSelect = True
    TabOrder = 1
    ViewStyle = vsReport
    OnDblClick = btnEditRefundClick
  end
  object btnEditRefund: TButton
    Left = 853
    Top = 44
    Width = 80
    Height = 21
    Anchors = [akTop, akRight]
    Caption = 'Edit Refund'
    Font.Charset = ANSI_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    OnClick = btnEditRefundClick
  end
end
