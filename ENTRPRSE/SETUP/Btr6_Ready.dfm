inherited frmBtr6Ready: TfrmBtr6Ready
  Left = 296
  Top = 148
  HelpContext = 503
  Caption = 'frmBtr6Ready'
  PixelsPerInch = 96
  TextHeight = 13
  inherited TitleLbl: TLabel
    Caption = 'Ready To Install'
  end
  inherited InstrLbl: TLabel
    Height = 18
    Caption = 'Setup Summary:'
  end
  object lblInstallTo: TLabel [4]
    Left = 175
    Top = 68
    Width = 277
    Height = 18
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'Install To:'
    WordWrap = True
  end
  inherited NextBtn: TButton
    Caption = '&Install'
  end
end
