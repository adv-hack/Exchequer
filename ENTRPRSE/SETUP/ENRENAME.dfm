inherited frmRenameError: TfrmRenameError
  Left = 158
  Top = 117
  HelpContext = 49
  ActiveControl = btnRecheck
  Caption = 'frmRenameError'
  ClientHeight = 370
  ClientWidth = 579
  PixelsPerInch = 96
  TextHeight = 13
  inherited Bevel1: TBevel
    Top = 325
    Width = 556
  end
  inherited TitleLbl: TLabel
    Width = 404
    Caption = 'Components In Use'
  end
  inherited InstrLbl: TLabel
    Width = 401
    Caption = 
      'Checks on the following components found that they were in use, ' +
      'this will prevent those components from being upgraded by this s' +
      'etup program.'
  end
  object Label1: TLabel [4]
    Left = 167
    Top = 289
    Width = 400
    Height = 33
    Anchors = [akLeft, akRight, akBottom]
    AutoSize = False
    Caption = 
      'Use the '#39'Re-Check'#39' button to redo the checks, and when finished ' +
      'use the '#39'Next'#39' button to continue.'
    WordWrap = True
  end
  inherited HelpBtn: TButton
    Top = 342
    TabOrder = 3
  end
  inherited Panel1: TPanel
    Height = 308
    inherited Image1: TImage
      Height = 306
    end
  end
  inherited ExitBtn: TButton
    Top = 342
    TabOrder = 4
  end
  inherited BackBtn: TButton
    Left = 402
    Top = 342
    TabOrder = 5
  end
  inherited NextBtn: TButton
    Left = 488
    Top = 342
    TabOrder = 6
  end
  object btnRecheck: TButton
    Left = 487
    Top = 261
    Width = 79
    Height = 23
    Anchors = [akRight, akBottom]
    Caption = 'Re-Check'
    TabOrder = 2
    OnClick = btnRecheckClick
  end
  object reResults: TRichEdit
    Left = 177
    Top = 80
    Width = 389
    Height = 179
    Anchors = [akLeft, akTop, akRight, akBottom]
    HideScrollBars = False
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 1
  end
end
