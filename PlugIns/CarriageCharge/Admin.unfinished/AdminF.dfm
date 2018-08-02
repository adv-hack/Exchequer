object Form1: TForm1
  Left = 182
  Top = 157
  Width = 696
  Height = 480
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 0
    Top = 0
    Width = 688
    Height = 2
    Align = alTop
    Shape = bsTopLine
  end
  object MainMenu1: TMainMenu
    Left = 3
    Top = 9
    object File1: TMenuItem
      Caption = '&File'
      object Exit1: TMenuItem
        Caption = 'E&xit'
        ShortCut = 16472
        OnClick = Exit1Click
      end
    end
    object Help1: TMenuItem
      Caption = '&Help'
      object About1: TMenuItem
        Caption = '&About'
        OnClick = About1Click
      end
    end
  end
end
