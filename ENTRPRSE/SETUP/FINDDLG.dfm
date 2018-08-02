inherited frmFindDlg: TfrmFindDlg
  Caption = 'frmFindDlg'
  PixelsPerInch = 96
  TextHeight = 13
  inherited TitleLbl: TLabel
    Caption = 'Find Exchequer Directory'
  end
  inherited InstrLbl: TLabel
    Height = 50
    Caption = 
      'Please select the drive you wish to search and then click the &F' +
      'ind button. When completed select the directory in the list you ' +
      'want to use and click the &Select button.'
  end
  object Label2: TLabel [3]
    Left = 178
    Top = 222
    Width = 56
    Height = 18
    AutoSize = False
    WordWrap = True
  end
  object lblSearch: TLabel [4]
    Left = 233
    Top = 222
    Width = 218
    Height = 18
    AutoSize = False
    WordWrap = True
  end
  inherited HelpBtn: TButton
    Visible = False
  end
  inherited ExitBtn: TButton
    Visible = False
  end
  inherited BackBtn: TButton
    Caption = '&Cancel'
  end
  inherited NextBtn: TButton
    Caption = '&Select'
  end
  object lstDirs: TListBox
    Left = 179
    Top = 128
    Width = 272
    Height = 91
    ItemHeight = 13
    TabOrder = 5
    OnDblClick = lstDirsDblClick
  end
  object DriveComboBox1: TDriveComboBox
    Left = 179
    Top = 104
    Width = 189
    Height = 19
    TabOrder = 6
  end
  object btnSearch: TButton
    Left = 372
    Top = 102
    Width = 79
    Height = 23
    Caption = '&Find'
    TabOrder = 7
    OnClick = btnSearchClick
  end
end
