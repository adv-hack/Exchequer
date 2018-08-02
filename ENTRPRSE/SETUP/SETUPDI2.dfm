inherited DirectoryDialog: TDirectoryDialog
  Left = 144
  Top = 185
  ActiveControl = nil
  Caption = 'Exchequer Accounting System Installation'
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  inherited TitleLbl: TLabel
    Left = 168
  end
  inherited InstrLbl: TLabel
    Left = 168
    Top = 46
    Width = 286
    Height = 41
  end
  inherited HelpBtn: TButton
    TabOrder = 2
  end
  inherited ExitBtn: TButton
    TabOrder = 3
  end
  inherited BackBtn: TButton
    TabOrder = 4
  end
  inherited NextBtn: TButton
    Left = 373
    TabOrder = 5
  end
  object Path: TComboBox
    Left = 179
    Top = 218
    Width = 270
    Height = 21
    Style = csSimple
    ItemHeight = 13
    Sorted = True
    TabOrder = 1
    OnClick = PathClick
  end
  object btnFindEnt: TButton
    Left = 185
    Top = 257
    Width = 79
    Height = 23
    Caption = '&Find'
    TabOrder = 6
    OnClick = btnFindEntClick
  end
  object DriveComboBox1: TDriveComboBox
    Left = 179
    Top = 90
    Width = 270
    Height = 19
    DirList = DirectoryListBox1
    TabOrder = 7
  end
  object DirectoryListBox1: TDirectoryListBox
    Left = 179
    Top = 109
    Width = 270
    Height = 107
    ItemHeight = 16
    TabOrder = 8
    OnChange = DirectoryListBox1Change
  end
end
