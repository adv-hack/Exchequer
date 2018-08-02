inherited StockBinInp: TStockBinInp
  HelpContext = 40119
  Caption = 'Create Bin Records'
  PixelsPerInch = 96
  TextHeight = 14
  inherited OkCP1Btn: TButton
    TabOrder = 2
  end
  inherited ClsCP1Btn: TButton
    TabOrder = 3
  end
  inherited SBSPanel1: TSBSPanel
    TabOrder = 4
  end
  object BorRadio1: TBorRadio
    Left = 27
    Top = 28
    Width = 218
    Height = 20
    Align = alRight
    Caption = 'Use Serial/Batch No. as Bin code'
    Checked = True
    GroupIndex = 1
    TabOrder = 0
    TabStop = True
    TextId = 0
  end
  object BorRadio2: TBorRadio
    Left = 27
    Top = 56
    Width = 191
    Height = 20
    Align = alRight
    Caption = 'Use Bin Code from Serial/Batch Rec'
    GroupIndex = 1
    TabOrder = 1
    TextId = 0
  end
end
