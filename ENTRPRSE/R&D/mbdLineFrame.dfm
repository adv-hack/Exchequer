object MultiBuyDiscountLineFrame: TMultiBuyDiscountLineFrame
  Left = 0
  Top = 0
  Width = 424
  Height = 24
  TabOrder = 0
  object lblMBDDesc: TLabel
    Left = 16
    Top = 3
    Width = 59
    Height = 13
    Caption = 'lblMBDDesc'
  end
  object Label2: TLabel
    Left = 267
    Top = 3
    Width = 75
    Height = 13
    Caption = 'Discount Value:'
  end
  object lblX: TLabel
    Left = 183
    Top = 3
    Width = 7
    Height = 13
    Alignment = taRightJustify
    Caption = 'X'
  end
  object lblMBDValue: TLabel
    Left = 346
    Top = 3
    Width = 61
    Height = 13
    Alignment = taRightJustify
    Caption = 'lblMBDValue'
  end
  object UpDown1: TUpDown
    Left = 244
    Top = 0
    Width = 16
    Height = 21
    Associate = edtMBDQty
    Min = 0
    Position = 0
    TabOrder = 0
    Wrap = False
    OnExit = edtMBDQtyExit
  end
  object edtMBDQty: TEdit
    Left = 195
    Top = 0
    Width = 49
    Height = 21
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    Text = '0'
    OnChange = edtMBDQtyChange
    OnExit = edtMBDQtyExit
  end
end
