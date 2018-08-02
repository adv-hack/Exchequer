object frmPaperWSAdv: TfrmPaperWSAdv
  Left = 387
  Top = 163
  HelpContext = 54
  ActiveControl = chkEntWorkS
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'frmPaperWSAdv'
  ClientHeight = 186
  ClientWidth = 389
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object Label81: Label8
    Left = 10
    Top = 9
    Width = 371
    Height = 43
    AutoSize = False
    Caption = 
      'Select the individual icons you want installed on this workstati' +
      'on. Icons can be added into the Exchequer Group with the icons f' +
      'or Exchequer, and also into the Startup Group so Windows automat' +
      'ically runs them.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    WordWrap = True
    TextId = 0
  end
  object Label82: Label8
    Left = 10
    Top = 63
    Width = 26
    Height = 14
    Caption = 'Icons'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsUnderline]
    ParentFont = False
    TextId = 0
  end
  object Label83: Label8
    Left = 10
    Top = 82
    Width = 125
    Height = 14
    AutoSize = False
    Caption = 'Workstation Client'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label84: Label8
    Left = 10
    Top = 103
    Width = 125
    Height = 14
    AutoSize = False
    Caption = 'Fax Sender'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label85: Label8
    Left = 10
    Top = 125
    Width = 125
    Height = 14
    AutoSize = False
    Caption = 'Fax Administrator'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object chkEntWorkS: TBorCheck
    Left = 150
    Top = 78
    Width = 109
    Height = 20
    Align = alRight
    Caption = 'Exchequer Group'
    Color = clBtnFace
    ParentColor = False
    TabOrder = 0
    TextId = 0
  end
  object chkEntSender: TBorCheck
    Left = 150
    Top = 99
    Width = 109
    Height = 20
    Align = alRight
    Caption = 'Exchequer Group'
    Color = clBtnFace
    ParentColor = False
    TabOrder = 2
    TextId = 0
  end
  object chkStWorkS: TBorCheck
    Left = 272
    Top = 78
    Width = 109
    Height = 20
    Align = alRight
    Caption = 'Startup Group'
    Color = clBtnFace
    ParentColor = False
    TabOrder = 1
    TextId = 0
  end
  object chkEntAdmin: TBorCheck
    Left = 150
    Top = 121
    Width = 109
    Height = 20
    Align = alRight
    Caption = 'Exchequer Group'
    Color = clBtnFace
    ParentColor = False
    TabOrder = 4
    TextId = 0
  end
  object chkStSender: TBorCheck
    Left = 272
    Top = 100
    Width = 109
    Height = 20
    Align = alRight
    Caption = 'Startup Group'
    Color = clBtnFace
    ParentColor = False
    TabOrder = 3
    TextId = 0
  end
  object chkStAdmin: TBorCheck
    Left = 272
    Top = 122
    Width = 109
    Height = 20
    Align = alRight
    Caption = 'Startup Group'
    Color = clBtnFace
    ParentColor = False
    TabOrder = 5
    TextId = 0
  end
  object btnOK: TButton
    Left = 208
    Top = 157
    Width = 80
    Height = 21
    Caption = '&OK'
    TabOrder = 6
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 302
    Top = 157
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    TabOrder = 7
    OnClick = btnCancelClick
  end
end
