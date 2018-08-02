object frmDBMDemo: TfrmDBMDemo
  Left = 288
  Top = 153
  Width = 783
  Height = 577
  Caption = 'DBMultilist Navigational Demo'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIForm
  Menu = menuMain
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pnlMDI: TPanel
    Left = 0
    Top = 0
    Width = 775
    Height = 57
    Align = alTop
    TabOrder = 0
    object lblDatabase: TLabel
      Left = 24
      Top = 22
      Width = 46
      Height = 13
      Caption = 'Database'
    end
    object sbNewSession: TSpeedButton
      Left = 230
      Top = 18
      Width = 22
      Height = 21
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
        555555555555555555555555555555555555555555FF55555555555559055555
        55555555577FF5555555555599905555555555557777F5555555555599905555
        555555557777FF5555555559999905555555555777777F555555559999990555
        5555557777777FF5555557990599905555555777757777F55555790555599055
        55557775555777FF5555555555599905555555555557777F5555555555559905
        555555555555777FF5555555555559905555555555555777FF55555555555579
        05555555555555777FF5555555555557905555555555555777FF555555555555
        5990555555555555577755555555555555555555555555555555}
      NumGlyphs = 2
      OnClick = sbNewSessionClick
    end
    object cbFiletype: TComboBox
      Left = 80
      Top = 18
      Width = 145
      Height = 21
      AutoDropDown = True
      Style = csDropDownList
      ItemHeight = 13
      Sorted = True
      TabOrder = 0
      Items.Strings = (
        'Customers'
        'Details'
        'Jobs'
        'Misc'
        'Suppliers')
    end
  end
  object menuMain: TMainMenu
    Left = 8
    Top = 64
    object File1: TMenuItem
      Caption = '&File'
      GroupIndex = 1
      object New1: TMenuItem
        Caption = '&New'
        OnClick = sbNewSessionClick
      end
      object Paths1: TMenuItem
        Caption = '&Settings'
        OnClick = Paths1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Exit1: TMenuItem
        Caption = 'E&xit'
        OnClick = Exit1Click
      end
    end
    object Window1: TMenuItem
      Caption = '&Window'
      GroupIndex = 100
      object Cascade1: TMenuItem
        Caption = '&Cascade'
        OnClick = Cascade1Click
      end
      object ileHorizontal1: TMenuItem
        Caption = 'Tile &Horizontal'
        OnClick = ileHorizontal1Click
      end
      object ileVertical1: TMenuItem
        Caption = 'Tile &Vertical'
        OnClick = ileVertical1Click
      end
    end
    object Help1: TMenuItem
      Caption = '&Help'
      GroupIndex = 100
    end
  end
end
