inherited frmSendSurvey: TfrmSendSurvey
  Left = 405
  Top = 154
  Caption = 'frmSendSurvey'
  ClientHeight = 325
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  inherited Bevel1: TBevel
    Top = 274
    Anchors = [akLeft, akRight]
  end
  inherited TitleLbl: TLabel
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Send Survey'
  end
  inherited InstrLbl: TLabel
    Anchors = [akLeft, akTop, akRight]
    Caption = 'The Survey Results can be submitted using the following methods.'
  end
  inherited HelpBtn: TButton
    Top = 297
    Anchors = [akLeft, akBottom]
    Visible = False
  end
  inherited Panel1: TPanel
    Height = 263
    Anchors = [akLeft, akTop, akBottom]
    inherited Image1: TImage
      Height = 261
      Anchors = [akLeft, akTop, akBottom]
    end
  end
  inherited ExitBtn: TButton
    Top = 297
    Anchors = [akLeft, akBottom]
    Visible = False
  end
  inherited BackBtn: TButton
    Top = 297
    Anchors = [akRight, akBottom]
    Visible = False
  end
  inherited NextBtn: TButton
    Top = 297
    Anchors = [akRight, akBottom]
    Caption = '&Close'
  end
end
