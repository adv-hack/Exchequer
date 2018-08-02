object Form2: TForm2
  Left = 122
  Top = 37
  Width = 624
  Height = 547
  Caption = 'EntComp.Dll - Development Tool '
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIForm
  Menu = MainMenu1
  Position = poScreenCenter
  WindowMenu = Window
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel3: TBevel
    Left = 0
    Top = 500
    Width = 616
    Height = 1
    Align = alBottom
    Shape = bsBottomLine
  end
  object Bevel4: TBevel
    Left = 0
    Top = 36
    Width = 1
    Height = 464
    Align = alLeft
    Shape = bsLeftLine
  end
  object Bevel5: TBevel
    Left = 615
    Top = 36
    Width = 1
    Height = 464
    Align = alRight
    Shape = bsRightLine
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 616
    Height = 36
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object Bevel1: TBevel
      Left = 0
      Top = 35
      Width = 616
      Height = 1
      Align = alBottom
      Shape = bsTopLine
    end
    object Bevel2: TBevel
      Left = 0
      Top = 0
      Width = 616
      Height = 2
      Align = alTop
      Shape = bsBottomLine
    end
    object ExitBtn: TSpeedButton
      Left = 6
      Top = 4
      Width = 28
      Height = 28
      Hint = 'Exit|'
      Glyph.Data = {
        06020000424D0602000000000000760000002800000028000000140000000100
        0400000000009001000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00377777777777
        777777773FFFFFFFFFFFF333333F888888888888F7F7F7888888888888883333
        33888888888888877F7F788888888888888F333FF88844444400888FFF444444
        88888888888333888883333334D5007FFF433333333338F888F3338F33333333
        345D50FFFF4333333333388788F3338F3333333334D5D0FFFF433333333338F8
        78F3338F33333333345D50FEFE4333333333388788F3338F3333333334D5D0FF
        FF433333333338F878F3338F33333333345D50FEFE4333333333388788F3338F
        3333333334D5D0FFFF433333333338F878F3338F33333333345D50FEFE433333
        3333388788F3338F3333333334D5D0EFEF433333333338F878F3338F33333333
        345D50FEFE4333333333388788F3338F3333333334D5D0EFEF433333333338F8
        F8FFFF8F33333333344444444443333333333888888888833333333333333333
        3333333333333333FFFFFF333333333333300000033333333333333888888F33
        333333333330AAAA0333333333333338FFFF8F33333333333330000003333333
        33333338888883333333}
      NumGlyphs = 2
      OnClick = Exit1Click
    end
    object SpeedButton1: TSpeedButton
      Left = 49
      Top = 4
      Width = 25
      Height = 25
    end
  end
  object MainMenu1: TMainMenu
    Left = 4
    Top = 39
    object File1: TMenuItem
      Caption = '&File'
      ShortCut = 0
      object DirChecks1: TMenuItem
        Caption = 'Dir Checks'
        ShortCut = 0
        OnClick = DirChecks1Click
      end
      object N1: TMenuItem
        Caption = '-'
        ShortCut = 0
      end
      object Exit1: TMenuItem
        Caption = 'E&xit'
        ShortCut = 0
        OnClick = Exit1Click
      end
    end
    object MultiCompanyManager1: TMenuItem
      Caption = '&Multi-Company Manager'
      ShortCut = 0
      object AsDialog1: TMenuItem
        Caption = 'As Dialog'
        ShortCut = 0
        OnClick = AsDialog1Click
      end
      object AsMDIChild1: TMenuItem
        Caption = 'As MDI &Child'
        ShortCut = 0
        OnClick = AsMDIChild1Click
      end
    end
    object Window: TMenuItem
      Caption = 'Window'
      ShortCut = 0
      object Tile1: TMenuItem
        Caption = 'Tile'
        ShortCut = 0
        OnClick = Tile1Click
      end
    end
    object Help1: TMenuItem
      Caption = '&Help'
      ShortCut = 0
      OnClick = Help1Click
    end
  end
end
