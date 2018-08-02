inherited frmSelectProgramGroup: TfrmSelectProgramGroup
  Left = 475
  Top = 236
  HelpContext = 15
  ActiveControl = edtGroup
  Caption = 'frmSelectProgramGroup'
  Font.Charset = ANSI_CHARSET
  Font.Name = 'Arial'
  PixelsPerInch = 96
  TextHeight = 14
  inherited TitleLbl: TLabel
    Caption = 'Program Group'
  end
  inherited InstrLbl: TLabel
    Height = 17
    Caption = 'Please select the group you want the icons to appear in:'
  end
  inherited HelpBtn: TButton
    TabOrder = 3
  end
  inherited ExitBtn: TButton
    TabOrder = 4
  end
  inherited BackBtn: TButton
    TabOrder = 5
  end
  inherited NextBtn: TButton
    TabOrder = 6
  end
  object edtGroup: TEdit
    Left = 181
    Top = 71
    Width = 250
    Height = 22
    TabOrder = 1
  end
  object lstExistingGroups: TListBox
    Left = 181
    Top = 93
    Width = 250
    Height = 144
    ItemHeight = 14
    TabOrder = 2
    OnClick = lstExistingGroupsClick
  end
end
