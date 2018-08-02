object Form_MDIMain: TForm_MDIMain
  Left = 44
  Top = 34
  Width = 664
  Height = 501
  Caption = 'SBSForm.DLL Testing Utility'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIForm
  Menu = MainMenu1
  OldCreateOrder = True
  WindowMenu = Window1
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 0
    Top = 435
    Width = 656
    Height = 1
    Align = alBottom
    Shape = bsBottomLine
  end
  object Bevel2: TBevel
    Left = 0
    Top = 33
    Width = 656
    Height = 1
    Align = alTop
    Shape = bsTopLine
  end
  object Bevel3: TBevel
    Left = 0
    Top = 34
    Width = 1
    Height = 401
    Align = alLeft
    Shape = bsLeftLine
  end
  object Bevel4: TBevel
    Left = 655
    Top = 34
    Width = 1
    Height = 401
    Align = alRight
    Shape = bsRightLine
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 656
    Height = 33
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object SpeedButton1: TSpeedButton
      Left = 6
      Top = 5
      Width = 25
      Height = 25
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        0400000000000001000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
        5555555FFFFFFFFFFF5555000000000005555588888888888F55507777777770
        705558FFFFFFFFF8F8F500000000000007058888888888888F8F0777777BBB77
        00058F5555555555888F07777778887707058FFFFFFFFFFF8F8F000000000000
        07708888888888888F5807777777777070708FFFFFFFFFF8F8F8500000000007
        070058888888888F8F88550FFFFFFFF07070558F55FFFFF8F8F85550F00000F0
        00055558F888885888855550FFFFFFFF05555558F55FFFFF8F5555550F00000F
        055555558F8888858F5555550FFFFFFFF05555558FFFFFFFF855555550000000
        0055555558888888885555555555555555555555555555555555}
      NumGlyphs = 2
    end
    object Bevel5: TBevel
      Left = 0
      Top = 0
      Width = 656
      Height = 2
      Align = alTop
      Shape = bsTopLine
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 436
    Width = 656
    Height = 19
    Panels = <>
    SimplePanel = False
  end
  object MainMenu1: TMainMenu
    Left = 511
    Top = 5
    object File1: TMenuItem
      Caption = '&File'
      object Exit1: TMenuItem
        Caption = 'E&xit'
        OnClick = Exit1Click
      end
    end
    object Print1: TMenuItem
      Caption = '&Print'
      object PrintPCC: TMenuItem
        Caption = 'PCC Form'
        OnClick = PrintPCCClick
      end
    end
    object Window1: TMenuItem
      Caption = '&Window'
      object N1: TMenuItem
        Caption = '&Cascade'
        OnClick = N1Click
      end
      object Tile1: TMenuItem
        Caption = '&Tile'
        OnClick = Tile1Click
      end
      object ArrangeIcons1: TMenuItem
        Caption = '&Arrange Icons'
        OnClick = ArrangeIcons1Click
      end
      object MinimizeAll1: TMenuItem
        Caption = '&Minimize All'
        OnClick = MinimizeAll1Click
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
