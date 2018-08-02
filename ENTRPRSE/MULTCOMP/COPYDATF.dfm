inherited CopyDataWiz1: TCopyDataWiz1
  Left = 172
  Top = 168
  HelpContext = 5
  ActiveControl = rad_Blank
  Caption = 'CopyDataWiz1'
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  inherited TitleLbl: TLabel
    Caption = 'Company Setup'
  end
  inherited InstrLbl: TLabel
    Height = 39
    Caption = 
      'When setting up an additional company you can copy data from ano' +
      'ther company which you already have setup, or you can install it' +
      ' as a blank system.'
  end
  inherited HelpBtn: TButton
    TabOrder = 4
  end
  inherited ExitBtn: TButton
    TabOrder = 5
  end
  inherited BackBtn: TButton
    TabOrder = 6
    Visible = False
  end
  inherited NextBtn: TButton
    TabOrder = 7
  end
  object CompList: TListBox
    Left = 183
    Top = 145
    Width = 269
    Height = 93
    ItemHeight = 13
    TabOrder = 3
    TabWidth = 40
  end
  object rad_Blank: TBorRadio
    Left = 168
    Top = 97
    Width = 267
    Height = 20
    Align = alRight
    Caption = 'Install new company as a blank system'
    Checked = True
    TabOrder = 1
    TabStop = True
    TextId = 0
    OnClick = rad_CopyClick
  end
  object rad_Copy: TBorRadio
    Left = 168
    Top = 119
    Width = 268
    Height = 20
    Align = alRight
    Caption = 'Copy selected data from company specified below'
    TabOrder = 2
    TextId = 0
    OnClick = rad_CopyClick
  end
end
