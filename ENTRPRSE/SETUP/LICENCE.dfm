inherited frmLicence: TfrmLicence
  Left = 340
  Top = 158
  HelpContext = 4
  ActiveControl = nil
  Caption = 'Exchequer Setup Program'
  Font.Charset = ANSI_CHARSET
  Font.Name = 'Arial'
  PixelsPerInch = 96
  TextHeight = 14
  inherited Bevel1: TBevel
    Top = 245
    Height = 6
  end
  inherited TitleLbl: TLabel
    Caption = 'Licence Agreement'
  end
  inherited InstrLbl: TLabel
    Height = 32
    Caption = 
      'Please read the following Licence Agreement. You must accept the' +
      ' Agreement to continue the Setup.'
  end
  inherited ExitBtn: TButton
    Visible = False
  end
  inherited BackBtn: TButton
    Caption = '&Decline'
  end
  inherited NextBtn: TButton
    Caption = '&Accept >>'
  end
  object rtfLicence: TRichEdit
    Left = 168
    Top = 87
    Width = 283
    Height = 150
    Lines.Strings = (
      'The End User Licence Agreement for Exchequer '
      'is missing, please contact your Dealer '
      'or Distributor and request a replacement CD.'
      'Please do not use this CD to Install or Upgrade'
      'Exchequer as other items may also be missing or '
      'damaged.')
    ScrollBars = ssVertical
    TabOrder = 5
  end
  object btnPrint: TButton
    Left = 199
    Top = 257
    Width = 79
    Height = 23
    Caption = '&Print Licence'
    TabOrder = 6
    OnClick = btnPrintClick
  end
end
