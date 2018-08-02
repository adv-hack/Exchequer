inherited frmPaperWS: TfrmPaperWS
  Left = 352
  Top = 133
  HelpContext = 55
  Caption = 'frmPaperWS'
  PixelsPerInch = 96
  TextHeight = 13
  inherited TitleLbl: TLabel
    Caption = 'Paperless Module Icons'
  end
  inherited InstrLbl: TLabel
    Height = 18
    Caption = 'Icons will be added depending on the computers role:-'
  end
  object Label81: Label8 [4]
    Left = 198
    Top = 172
    Width = 247
    Height = 47
    AutoSize = False
    Caption = 
      'Runs the Fax Sender component of the Paperless Module which send' +
      's the queued faxes to their recipients using a Fax Modem.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    WordWrap = True
    OnClick = Label81Click
    TextId = 0
  end
  object Label82: Label8 [5]
    Left = 198
    Top = 116
    Width = 247
    Height = 30
    AutoSize = False
    Caption = 
      'Runs the Fax Client component to allow Faxes to be queued for se' +
      'nding by the Fax Server.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    WordWrap = True
    OnClick = Label82Click
    TextId = 0
  end
  inherited HelpBtn: TButton
    TabOrder = 5
  end
  inherited ExitBtn: TButton
    TabOrder = 6
  end
  inherited BackBtn: TButton
    TabOrder = 7
  end
  inherited NextBtn: TButton
    TabOrder = 8
  end
  object radWorkstation: TBorRadio
    Left = 179
    Top = 95
    Width = 259
    Height = 20
    Align = alRight
    Caption = 'Workstation'
    TabOrder = 2
    TextId = 0
    OnClick = radWorkstationClick
  end
  object radFaxServer: TBorRadio
    Left = 179
    Top = 151
    Width = 259
    Height = 20
    Align = alRight
    Caption = 'Fax Server'
    Checked = True
    TabOrder = 3
    TabStop = True
    TextId = 0
    OnClick = radFaxServerClick
  end
  object btnAdvanced: TButton
    Left = 368
    Top = 215
    Width = 79
    Height = 23
    Caption = '&Advanced'
    TabOrder = 4
    OnClick = btnAdvancedClick
  end
  object radNone: TBorRadio
    Left = 179
    Top = 70
    Width = 259
    Height = 20
    Align = alRight
    Caption = 'None'
    TabOrder = 1
    TextId = 0
    OnClick = radNoneClick
  end
end
