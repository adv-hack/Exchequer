inherited frmPlugInAbout: TfrmPlugInAbout
  Caption = 'frmPlugInAbout'
  ClientHeight = 288
  ClientWidth = 513
  Position = poOwnerFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  inherited Bevel1: TBevel
    Top = 243
    Width = 490
    Anchors = [akLeft, akRight, akBottom]
  end
  inherited TitleLbl: TLabel
    Left = 70
    Top = 26
    Width = 58
    Visible = False
  end
  inherited InstrLbl: TLabel
    Left = 36
    Top = 57
    Width = 82
    Visible = False
  end
  inherited imgSide: TImage
    Top = 164
  end
  object lblVersion: TLabel [4]
    Left = 293
    Top = 4
    Width = 208
    Height = 13
    Alignment = taRightJustify
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'Version: '
  end
  inherited HelpBtn: TButton
    Top = 260
    Anchors = [akLeft, akBottom]
    Visible = False
  end
  inherited Panel1: TPanel
    Top = 18
  end
  inherited ExitBtn: TButton
    Top = 260
    Anchors = [akLeft, akBottom]
    Visible = False
  end
  inherited BackBtn: TButton
    Left = 336
    Top = 260
    Anchors = [akRight, akBottom]
    Visible = False
  end
  inherited NextBtn: TButton
    Left = 422
    Top = 260
    Anchors = [akRight, akBottom]
    Caption = '&OK'
    Default = True
  end
  object memReport: TMemo
    Left = 168
    Top = 17
    Width = 333
    Height = 224
    Anchors = [akLeft, akTop, akRight, akBottom]
    ScrollBars = ssVertical
    TabOrder = 5
  end
end
