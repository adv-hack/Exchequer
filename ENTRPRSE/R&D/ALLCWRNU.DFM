inherited GenWarnFrm1: TGenWarnFrm1
  Caption = 'GenWarnFrm1'
  ClientHeight = 290
  PixelsPerInch = 96
  TextHeight = 13
  inherited SBSPanel1: TSBSPanel
    Height = 249
  end
  inherited OkCP1Btn: TButton
    Top = 264
    TabOrder = 3
  end
  inherited CanCP1Btn: TButton
    Top = 264
    Caption = '&Leave O/S'
    TabOrder = 4
  end
  object cbVar: TBorRadio
    Left = 23
    Top = 234
    Width = 105
    Height = 20
    Caption = 'Take as Variance'
    Checked = True
    GroupIndex = 1
    TabOrder = 1
    TabStop = True
    TextId = 0
  end
  object cbSetD: TBorRadio
    Left = 137
    Top = 234
    Width = 112
    Height = 20
    Caption = 'Take as Settlement'
    GroupIndex = 1
    TabOrder = 2
    TextId = 0
  end
end
