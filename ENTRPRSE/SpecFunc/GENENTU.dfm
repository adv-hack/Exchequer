inherited TestCust: TTestCust
  Caption = 'TestCust'
  ClientHeight = 224
  ClientWidth = 424
  PixelsPerInch = 96
  TextHeight = 14
  inherited PageControl1: TPageControl
    Width = 424
    Height = 224
    inherited TabSheet1: TTabSheet
      Caption = ''
      inherited SBSPanel4: TSBSBackGroup
        Width = 390
        Height = 157
      end
      object StartBtn: TButton
        Tag = 1
        Left = 82
        Top = 172
        Width = 80
        Height = 21
        Caption = '&Start Test'
        TabOrder = 0
      end
    end
    inherited TabSheet2: TTabSheet
      TabVisible = False
    end
    inherited TabSheet3: TTabSheet
      TabVisible = False
    end
  end
  inherited OkCP1Btn: TButton
    Left = 232
    Top = 196
  end
  inherited ClsCP1Btn: TButton
    Left = 318
    Top = 196
  end
end
