inherited SetupTemplate1: TSetupTemplate1
  Left = 204
  Top = 183
  Caption = 'SetupTemplate1'
  PixelsPerInch = 96
  TextHeight = 13
  inherited imgSide: TImage
    Left = 163
    Top = 13
  end
  object SpeedButton1: TSpeedButton [4]
    Left = 174
    Top = 220
    Width = 25
    Height = 25
    OnClick = SpeedButton1Click
  end
  object Button1: TButton
    Left = 171
    Top = 157
    Width = 274
    Height = 25
    Caption = 'Max Height, Max Width'
    TabOrder = 5
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 173
    Top = 189
    Width = 274
    Height = 25
    Caption = 'Subtle Height, Normal Width'
    TabOrder = 6
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 171
    Top = 89
    Width = 280
    Height = 50
    Caption = 'Reset'
    Font.Color = clBlack
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 7
    OnClick = Button3Click
  end
end
