inherited frmBtr6Directory: TfrmBtr6Directory
  HelpContext = 502
  Caption = 'frmBtr6Directory'
  PixelsPerInch = 96
  TextHeight = 13
  inherited TitleLbl: TLabel
    Caption = 'Installation Directory'
  end
  inherited InstrLbl: TLabel
    Height = 40
    Caption = 
      'Please specify the directory you want to install the Btrieve v6.' +
      '15 files into, this should be the directory that you will instal' +
      'l <APPTITLE> into.'
  end
  object Path: TComboBox
    Left = 178
    Top = 218
    Width = 271
    Height = 21
    Style = csSimple
    ItemHeight = 13
    Sorted = True
    TabOrder = 5
    OnChange = PathChange
  end
  object DriveComboBox1: TDrive95ComboBox
    Left = 179
    Top = 91
    Width = 270
    Height = 22
    DirList = DirectoryListBox1
    TabOrder = 6
  end
  object DirectoryListBox1: TDirectory95ListBox
    Left = 179
    Top = 114
    Width = 270
    Height = 103
    ItemHeight = 17
    TabOrder = 7
    OnChange = DirectoryListBox1Change
  end
end
