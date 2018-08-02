inherited frmFindDlg: TfrmFindDlg
  HelpContext = 45
  Caption = 'frmFindDlg'
  PixelsPerInch = 96
  TextHeight = 13
  inherited TitleLbl: TLabel
    Caption = 'Find Accounts Directory'
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
    TabOrder = 4
    Visible = False
  end
  inherited ExitBtn: TButton
    TabOrder = 5
    Visible = False
  end
  inherited BackBtn: TButton
    Caption = '&Cancel'
    TabOrder = 6
  end
  inherited NextBtn: TButton
    Caption = '&Select'
    TabOrder = 7
  end
  object lstDirs: TListBox
    Left = 179
    Top = 128
    Width = 272
    Height = 91
    ItemHeight = 13
    TabOrder = 3
    OnDblClick = lstDirsDblClick
  end
  object btnSearch: TButton
    Left = 372
    Top = 103
    Width = 79
    Height = 23
    Caption = '&Find'
    TabOrder = 2
    OnClick = btnSearchClick
  end
  object DriveComboBox1: TDrive95ComboBox
    Left = 179
    Top = 103
    Width = 188
    Height = 22
    TabOrder = 1
  end
end
