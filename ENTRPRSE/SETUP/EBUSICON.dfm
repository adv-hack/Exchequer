inherited frmEBusIcons: TfrmEBusIcons
  Left = 357
  Top = 223
  HelpContext = 82
  Caption = 'frmEBusIcons'
  Font.Charset = ANSI_CHARSET
  Font.Name = 'Arial'
  PixelsPerInch = 96
  TextHeight = 14
  inherited TitleLbl: TLabel
    Caption = 'eBusiness Module'
  end
  inherited InstrLbl: TLabel
    Caption = 
      'The following utilities are part of the eBusiness module and sho' +
      'uld be setup on the workstation that will be using them.'
    Font.Charset = ANSI_CHARSET
    Font.Name = 'Arial'
    ParentFont = False
  end
  object Label82: Label8 [4]
    Left = 198
    Top = 102
    Width = 247
    Height = 34
    AutoSize = False
    Caption = 
      'Processes XML Transactions sent to you by email and adds them in' +
      'to the eBusiness Daybook.'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    WordWrap = True
    TextId = 0
  end
  object Label81: Label8 [5]
    Left = 198
    Top = 158
    Width = 247
    Height = 34
    AutoSize = False
    Caption = 
      'Allows data exports from Exchequer to be done either automatical' +
      'ly or manually.'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    WordWrap = True
    TextId = 0
  end
  object Label1: TLabel [6]
    Left = 167
    Top = 193
    Width = 285
    Height = 49
    AutoSize = False
    Caption = 
      'NOTE: Each utility should only be setup on one computer, problem' +
      's may occur if you run them simultaneously on more than one comp' +
      'uter.'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  inherited HelpBtn: TButton
    TabOrder = 3
  end
  inherited Panel1: TPanel
    TabOrder = 2
  end
  inherited ExitBtn: TButton
    TabOrder = 4
  end
  inherited BackBtn: TButton
    TabOrder = 5
  end
  inherited NextBtn: TButton
    TabOrder = 6
  end
  object chkImport: TBorCheck
    Left = 179
    Top = 82
    Width = 247
    Height = 20
    Align = alRight
    Caption = 'eBusiness Import Module'
    Color = clBtnFace
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    TabOrder = 0
    TextId = 0
  end
  object chkExport: TBorCheck
    Left = 179
    Top = 138
    Width = 247
    Height = 20
    Align = alRight
    Caption = 'eBusiness Export Module'
    Color = clBtnFace
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    TabOrder = 1
    TextId = 0
  end
end
