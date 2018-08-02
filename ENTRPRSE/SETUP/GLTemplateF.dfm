inherited frmSelectGLTemplate: TfrmSelectGLTemplate
  Left = 318
  Top = 125
  HelpContext = 66
  Caption = 'frmSelectGLTemplate'
  ClientHeight = 413
  ClientWidth = 508
  PixelsPerInch = 96
  TextHeight = 13
  inherited Bevel1: TBevel
    Top = 368
    Width = 485
  end
  inherited TitleLbl: TLabel
    Width = 333
    Caption = 'General Ledger Template'
  end
  inherited InstrLbl: TLabel
    Width = 330
    Caption = 
      'Please select a General Ledger Template from the list below to b' +
      'e used with the dataset being installed:-'
  end
  inherited imgSide: TImage
    Height = 257
  end
  inherited HelpBtn: TButton
    Top = 385
    TabOrder = 2
  end
  inherited Panel1: TPanel
    Height = 351
    TabOrder = 1
    inherited Image1: TImage
      Height = 349
    end
  end
  inherited ExitBtn: TButton
    Top = 385
    TabOrder = 3
  end
  inherited BackBtn: TButton
    Left = 331
    Top = 385
    TabOrder = 4
  end
  inherited NextBtn: TButton
    Left = 417
    Top = 385
    TabOrder = 5
  end
  object lstGLTemplates: TListBox
    Left = 178
    Top = 88
    Width = 303
    Height = 272
    ItemHeight = 13
    Sorted = True
    TabOrder = 0
  end
end
