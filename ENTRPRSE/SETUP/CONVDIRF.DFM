inherited frmConvertDir: TfrmConvertDir
  Left = 141
  Top = 448
  Caption = 'frmConvertDir'
  PixelsPerInch = 96
  TextHeight = 13
  inherited TitleLbl: TLabel
    Caption = 'Select Enterprise Directory'
  end
  inherited InstrLbl: TLabel
    Height = 46
    Caption = 
      'Please specify the directory containing your Exchequer Enterpris' +
      'e system files or click the &Find button to search your computer' +
      ' for the directory:'
  end
  object btnFindEnt: TButton
    Left = 185
    Top = 257
    Width = 79
    Height = 23
    Caption = '&Find'
    TabOrder = 5
    OnClick = btnFindEntClick
  end
  object DriveComboBox1: TDriveComboBox
    Left = 179
    Top = 98
    Width = 270
    Height = 19
    DirList = DirectoryListBox1
    TabOrder = 6
  end
  object DirectoryListBox1: TDirectoryListBox
    Left = 179
    Top = 117
    Width = 270
    Height = 121
    ItemHeight = 16
    TabOrder = 7
  end
end
