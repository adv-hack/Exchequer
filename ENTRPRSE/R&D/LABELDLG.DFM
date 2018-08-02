inherited BaseLabelDialog1: TBaseLabelDialog1
  Left = 161
  Top = 99
  HelpContext = 676
  Caption = 'Label Setup'
  ClientHeight = 270
  ClientWidth = 348
  PixelsPerInch = 96
  TextHeight = 13
  object SBSBackGroup1: TSBSBackGroup [0]
    Left = 5
    Top = 3
    Width = 249
    Height = 260
    Caption = 'Select the first label to print: '
    TextId = 0
  end
  inherited Image_Labels: TImage
    Top = 19
    Width = 240
    Height = 240
  end
  object btnOK: TButton
    Left = 262
    Top = 8
    Width = 80
    Height = 21
    Caption = '&OK'
    Default = True
    TabOrder = 0
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 262
    Top = 34
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    TabOrder = 1
    OnClick = btnCancelClick
  end
end
