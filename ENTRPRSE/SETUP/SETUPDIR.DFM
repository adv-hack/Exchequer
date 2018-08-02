inherited DirectoryDialog: TDirectoryDialog
  Left = 596
  Top = 150
  ActiveControl = DriveComboBox1
  Caption = 'Exchequer Enterprise Accounting System Installation'
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
    TabOrder = 4
  end
  inherited ExitBtn: TButton
    TabOrder = 5
  end
  inherited BackBtn: TButton
    TabOrder = 6
  end
  inherited NextBtn: TButton
    Left = 373
    TabOrder = 7
  end
  object DriveComboBox1: TDriveComboBox
    Left = 179
    Top = 90
    Width = 270
    Height = 19
    DirList = DirectoryListBox1
    TabOrder = 1
  end
  object DirectoryListBox1: TDirectoryListBox
    Left = 179
    Top = 109
    Width = 270
    Height = 107
    ItemHeight = 16
    TabOrder = 2
    OnChange = DirectoryListBox1Change
  end
  object Path: TComboBox
    Left = 179
    Top = 218
    Width = 270
    Height = 21
    Style = csSimple
    ItemHeight = 13
    Sorted = True
    TabOrder = 3
    OnClick = PathClick
  end
  object btnFindEnt: TButton
    Left = 185
    Top = 257
    Width = 79
    Height = 23
    Caption = '&Find'
    TabOrder = 8
    OnClick = btnFindEntClick
  end
end
