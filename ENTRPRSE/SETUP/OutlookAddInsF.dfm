inherited frmOutlookAddIns: TfrmOutlookAddIns
  Left = 357
  Top = 223
  HelpContext = 501
  Caption = 'frmOutlookAddIns'
  ClientHeight = 267
  Font.Charset = ANSI_CHARSET
  Font.Name = 'Arial'
  PixelsPerInch = 96
  TextHeight = 14
  inherited Bevel1: TBevel
    Top = 222
  end
  inherited TitleLbl: TLabel
    Caption = 'Dashboard Controls'
  end
  inherited InstrLbl: TLabel
    Height = 31
    Caption = 
      'In order to use the Outlook Dynamic Dashboard on this workstatio' +
      'n the Dashboard Controls must be registered.'
    Font.Charset = ANSI_CHARSET
    Font.Name = 'Arial'
    ParentFont = False
  end
  inherited HelpBtn: TButton
    Top = 239
    TabOrder = 2
  end
  inherited Panel1: TPanel
    Height = 205
    TabOrder = 1
    inherited Image1: TImage
      Height = 203
    end
  end
  inherited ExitBtn: TButton
    Top = 239
    TabOrder = 3
  end
  inherited BackBtn: TButton
    Top = 239
    TabOrder = 4
  end
  inherited NextBtn: TButton
    Top = 239
    TabOrder = 5
  end
  object chkInstallAddIns: TBorCheck
    Left = 185
    Top = 84
    Width = 247
    Height = 20
    Align = alRight
    Caption = 'Configure Dashboard Controls'
    Color = clBtnFace
    ParentColor = False
    TabOrder = 0
    TextId = 0
  end
end
