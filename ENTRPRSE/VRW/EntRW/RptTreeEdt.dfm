object frmHeaderEdit: TfrmHeaderEdit
  Left = 339
  Top = 226
  HelpContext = 162
  BorderIcons = [biSystemMenu, biHelp]
  BorderStyle = bsDialog
  Caption = 'Edit Report Group'
  ClientHeight = 94
  ClientWidth = 385
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
  object memNodeDescription: TLabeledEdit
    Left = 74
    Top = 37
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
  object lbledtHeading: TLabeledEdit
    Left = 74
    Top = 7
    Width = 121
    Height = 22
    TabStop = False
    Color = clBtnFace
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
    ReadOnly = True
    TabOrder = 0
  end
  object Button1: TButton
    Left = 108
    Top = 68
    Width = 80
    Height = 21
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 2
  end
  object Button2: TButton
    Left = 198
    Top = 68
    Width = 80
    Height = 21
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object EnterToTab1: TEnterToTab
    ConvertEnters = True
    OverrideFont = False
    Version = 'TEnterToTab v1.02 for Delphi 6.01'
    Left = 333
    Top = 1
  end
end
