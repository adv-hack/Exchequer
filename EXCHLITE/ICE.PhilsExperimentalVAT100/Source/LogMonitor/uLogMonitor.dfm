object frmIceLogMonitor: TfrmIceLogMonitor
  Left = 264
  Top = 244
  Width = 916
  Height = 636
  Caption = 'Ice - Log Monitor'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object mmLog: TMemo
    Left = 0
    Top = 0
    Width = 908
    Height = 582
    Align = alClient
    Color = clBlack
    Font.Charset = ANSI_CHARSET
    Font.Color = clTeal
    Font.Height = -11
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
    ParentFont = False
    PopupMenu = ppmRefresh
    ReadOnly = True
    TabOrder = 0
    WordWrap = False
  end
  object scnLog: TShellChangeNotifier
    NotifyFilters = [nfSizeChange, nfWriteChange]
    Root = 'C:\'
    WatchSubTree = False
    OnChange = scnLogChange
    Left = 322
    Top = 112
  end
  object ppmRefresh: TPopupMenu
    Left = 232
    Top = 66
    object Refresh1: TMenuItem
      Caption = 'Refresh'
      OnClick = Refresh1Click
    end
  end
  object MainMenu1: TMainMenu
    Left = 426
    Top = 86
    object Log1: TMenuItem
      Caption = 'Log'
      object mnuDSR: TMenuItem
        AutoCheck = True
        Caption = 'DSR and Dashboard'
        OnClick = mnuDSRClick
      end
      object mnuPlugins: TMenuItem
        AutoCheck = True
        Caption = 'Plug-ins'
        OnClick = mnuPluginsClick
      end
    end
  end
end
