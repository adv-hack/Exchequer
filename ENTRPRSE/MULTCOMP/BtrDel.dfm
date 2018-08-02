inherited frmDeleteBetrieve: TfrmDeleteBetrieve
  Left = 513
  Top = 342
  ActiveControl = nil
  Caption = 'Checking B-Trieve Files'
  FormStyle = fsStayOnTop
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  inherited TitleLbl: TLabel
    Caption = 'Checking Files...'
  end
  inherited InstrLbl: TLabel
    Visible = False
  end
  inherited HelpBtn: TButton
    Visible = False
  end
  inherited ExitBtn: TButton
    Visible = False
  end
  inherited BackBtn: TButton
    Visible = False
  end
  inherited NextBtn: TButton
    Visible = False
  end
  object Progress: TProgressBar
    Left = 167
    Top = 174
    Width = 270
    Height = 17
    Min = 0
    Max = 100
    Step = 1
    TabOrder = 5
  end
  object Animate: TAnimate
    Left = 167
    Top = 94
    Width = 272
    Height = 60
    Active = False
    CommonAVI = aviRecycleFile
    StopFrame = 23
  end
end
