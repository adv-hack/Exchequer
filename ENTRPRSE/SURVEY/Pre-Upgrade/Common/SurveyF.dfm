inherited frmCustSurvey: TfrmCustSurvey
  Left = 298
  Top = 108
  ActiveControl = nil
  Caption = 'frmCustSurvey'
  ClientHeight = 468
  ClientWidth = 596
  KeyPreview = True
  OnClose = FormClose
  DesignSize = (
    596
    468)
  PixelsPerInch = 96
  TextHeight = 14
  inherited Bevel1: TBevel
    Top = 423
    Width = 573
  end
  inherited TitleLbl: TLabel
    Width = 421
    Caption = 'Details Update'
  end
  inherited InstrLbl: TLabel
    Width = 418
    Height = 18
    Caption = 
      'Please supply the following information so that we can update ou' +
      'r internal records.'
  end
  inherited imgSide: TImage
    Height = 267
  end
  inherited HelpBtn: TButton
    Top = 440
    Visible = False
  end
  inherited Panel1: TPanel
    Height = 406
    DesignSize = (
      145
      406)
    inherited Image1: TImage
      Height = 404
    end
  end
  inherited ExitBtn: TButton
    Top = 440
    Visible = False
  end
  inherited BackBtn: TButton
    Left = 419
    Top = 440
  end
  inherited NextBtn: TButton
    Left = 505
    Top = 440
  end
  object EnterToTab1: TEnterToTab
    ConvertEnters = True
    OverrideFont = False
    Version = 'TEnterToTab v1.02 for Delphi 6.01'
    Left = 494
    Top = 12
  end
end
