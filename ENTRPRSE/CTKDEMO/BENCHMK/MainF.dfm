object Form3: TForm3
  Left = 260
  Top = 185
  Width = 585
  Height = 340
  Caption = 'COM Toolkit vs 32-Bit Toolkit Benchmark Utility'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    577
    306)
  PixelsPerInch = 96
  TextHeight = 13
  object lblProgress: TLabel
    Left = 12
    Top = 296
    Width = 414
    Height = 13
    Anchors = [akLeft, akBottom]
    AutoSize = False
  end
  object Label1: TLabel
    Left = 11
    Top = 1
    Width = 408
    Height = 13
    AutoSize = False
    Caption = 'Times in Milliseconds:-'
  end
  object ListView1: TListView
    Left = 8
    Top = 17
    Width = 422
    Height = 275
    Anchors = [akLeft, akTop, akBottom]
    Columns = <
      item
        Caption = 'Test Performed'
        Width = 150
      end
      item
        Alignment = taRightJustify
        Caption = 'Toolkit'
        Width = 75
      end
      item
        Alignment = taRightJustify
        Caption = 'OLE '
        Width = 75
      end
      item
        Alignment = taRightJustify
        Caption = 'COM'
        Width = 75
      end>
    TabOrder = 0
    ViewStyle = vsReport
  end
  object Button1: TButton
    Left = 435
    Top = 35
    Width = 136
    Height = 28
    Caption = 'Customer List'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 435
    Top = 68
    Width = 136
    Height = 28
    Caption = 'All SIN - TH + TL'
    TabOrder = 2
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 435
    Top = 100
    Width = 136
    Height = 28
    Caption = 'All SIN - TH Only'
    TabOrder = 3
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 435
    Top = 161
    Width = 136
    Height = 28
    Caption = 'Single SIN - TH + TL x 25'
    TabOrder = 4
    OnClick = Button4Click
  end
end
