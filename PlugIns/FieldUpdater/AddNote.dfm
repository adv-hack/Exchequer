object frmAddNote: TfrmAddNote
  Left = 438
  Top = 323
  BorderStyle = bsDialog
  Caption = 'Add Note'
  ClientHeight = 134
  ClientWidth = 482
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel
    Left = 8
    Top = 56
    Width = 29
    Height = 14
    Caption = 'Text : '
  end
  object lDate: TLabel
    Left = 8
    Top = 8
    Width = 25
    Height = 14
    Caption = 'Date:'
  end
  object edText: TEdit
    Left = 8
    Top = 72
    Width = 465
    Height = 22
    MaxLength = 65
    TabOrder = 1
  end
  object edDate: TDateTimePicker
    Left = 8
    Top = 24
    Width = 121
    Height = 22
    CalAlignment = dtaLeft
    Date = 40161.5555215857
    Time = 40161.5555215857
    DateFormat = dfShort
    DateMode = dmComboBox
    Kind = dtkDate
    ParseInput = False
    TabOrder = 0
  end
  object btnOK: TButton
    Left = 304
    Top = 104
    Width = 80
    Height = 21
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 2
  end
  object btnCancel: TButton
    Left = 392
    Top = 104
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object EnterToTab1: TEnterToTab
    ConvertEnters = True
    OverrideFont = True
    Version = 'TEnterToTab v1.02 for Delphi 6.01'
    Left = 8
    Top = 96
  end
end
