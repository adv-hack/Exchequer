object frmCopyReport: TfrmCopyReport
  Left = 409
  Top = 251
  HelpContext = 136
  BorderIcons = [biSystemMenu, biHelp]
  BorderStyle = bsDialog
  Caption = 'Copy Report'
  ClientHeight = 122
  ClientWidth = 416
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poOwnerFormCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object Label81: Label8
    Left = 7
    Top = 5
    Width = 402
    Height = 20
    AutoSize = False
    Caption = 
      'Enter the Report Name and Description to be used for the copy of' +
      ' the report'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    WordWrap = True
    TextId = 0
  end
  object btnOK: TButton
    Left = 123
    Top = 94
    Width = 80
    Height = 21
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 2
  end
  object btnCancel: TButton
    Left = 213
    Top = 94
    Width = 80
    Height = 21
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object lbledtReportDesc: TLabeledEdit
    Left = 85
    Top = 63
    Width = 300
    Height = 22
    EditLabel.Width = 54
    EditLabel.Height = 14
    EditLabel.Caption = 'Description'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    LabelPosition = lpLeft
    LabelSpacing = 10
    MaxLength = 255
    ParentFont = False
    TabOrder = 1
  end
  object lbledtReportName: TLabeledEdit
    Left = 85
    Top = 33
    Width = 121
    Height = 22
    CharCase = ecUpperCase
    EditLabel.Width = 27
    EditLabel.Height = 14
    EditLabel.Caption = 'Name'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    LabelPosition = lpLeft
    LabelSpacing = 10
    MaxLength = 255
    ParentFont = False
    TabOrder = 0
    OnKeyPress = lbledtReportNameKeyPress
  end
  object EnterToTab1: TEnterToTab
    ConvertEnters = True
    OverrideFont = False
    Version = 'TEnterToTab v1.02 for Delphi 6.01'
    Left = 321
    Top = 30
  end
end
