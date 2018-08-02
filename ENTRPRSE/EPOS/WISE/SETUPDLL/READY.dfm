inherited FrmReadyToInstall: TFrmReadyToInstall
  Left = 256
  Top = 190
  HelpContext = 45
  ActiveControl = nil
  Caption = 'Exchequer Trade Counter Module Installation'
  PixelsPerInch = 96
  TextHeight = 13
  inherited TitleLbl: TLabel
    Caption = 'Ready to Install'
  end
  inherited InstrLbl: TLabel
    Height = 48
    Caption = 
      'Setup is now ready to install the required files onto your syste' +
      'm. Please click on "Begin" to start copying the files.'
  end
  object lBackup: Label8 [4]
    Left = 184
    Top = 118
    Width = 271
    Height = 55
    AutoSize = False
    Caption = 
      'If you select this to be a Demo copy of the Trade Counter System' +
      ', the receipts / invoices will be printed to the screen, as oppo' +
      'sed to being sent to the printer.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    WordWrap = True
    TextId = 0
  end
  object lUsers: Label8 [5]
    Left = 184
    Top = 206
    Width = 273
    Height = 35
    AutoSize = False
    Caption = 
      'If other users are running Exchequer this may cause the Setup to' +
      ' fail partially or totally.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    WordWrap = True
    TextId = 0
  end
  inherited NextBtn: TButton
    Caption = 'Install'
    Enabled = False
  end
  object chkDemo: TCheckBox
    Left = 168
    Top = 96
    Width = 260
    Height = 20
    Caption = 'Demonstration Copy'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentColor = False
    ParentFont = False
    TabOrder = 5
    OnClick = CheckClick
  end
  object chkUsers: TCheckBox
    Left = 168
    Top = 184
    Width = 260
    Height = 20
    Caption = 'No users are currently running Exchequer'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentColor = False
    ParentFont = False
    TabOrder = 6
    OnClick = CheckClick
  end
end
