inherited frmWarnings: TfrmWarnings
  Caption = 'frmWarnings'
  ClientWidth = 462
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  inherited Bevel1: TBevel
    Width = 439
    Anchors = [akLeft, akRight, akBottom]
  end
  inherited TitleLbl: TLabel
    Width = 287
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Pre-Upgrade Warnings'
  end
  inherited InstrLbl: TLabel
    Width = 284
    Anchors = [akLeft, akTop, akRight]
    Caption = 
      'The following warnings were generated after scanning your Excheq' +
      'uer System:-'
  end
  inherited HelpBtn: TButton
    Anchors = [akLeft, akBottom]
    Visible = False
  end
  inherited Panel1: TPanel
    Anchors = [akLeft, akTop, akBottom]
    inherited Image1: TImage
      Anchors = [akLeft, akTop, akBottom]
    end
  end
  inherited ExitBtn: TButton
    Anchors = [akLeft, akBottom]
    Visible = False
  end
  inherited BackBtn: TButton
    Left = 285
    Anchors = [akRight, akBottom]
    Visible = False
  end
  inherited NextBtn: TButton
    Left = 371
    Anchors = [akRight, akBottom]
    Caption = '&Continue'
  end
  object Memo1: TMemo
    Left = 168
    Top = 85
    Width = 283
    Height = 127
    Lines.Strings = (
      'Memo1')
    ScrollBars = ssBoth
    TabOrder = 5
  end
end
