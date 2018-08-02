object frmSchedulerSettings: TfrmSchedulerSettings
  Left = 319
  Top = 163
  HelpContext = 8
  BorderStyle = bsDialog
  Caption = 'Scheduler Settings'
  ClientHeight = 191
  ClientWidth = 253
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
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
  object btnOK: TSBSButton
    Left = 40
    Top = 160
    Width = 80
    Height = 21
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 0
    TextId = 0
  end
  object btnCancel: TSBSButton
    Left = 128
    Top = 160
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 1
    TextId = 0
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 233
    Height = 73
    HelpContext = 8
    Caption = 'Off-line period'
    TabOrder = 2
    object Label1: TLabel
      Left = 16
      Top = 16
      Width = 23
      Height = 14
      HelpContext = 8
      Caption = 'Start'
    end
    object Label2: TLabel
      Left = 136
      Top = 16
      Width = 18
      Height = 14
      HelpContext = 8
      Caption = 'End'
    end
    object dtStart: TDateTimePicker
      Left = 16
      Top = 32
      Width = 81
      Height = 22
      CalAlignment = dtaLeft
      Date = 39098.6388489815
      Format = 'HH:mm'
      Time = 39098.6388489815
      DateFormat = dfShort
      DateMode = dmComboBox
      Kind = dtkTime
      ParseInput = False
      TabOrder = 0
    end
    object dtEnd: TDateTimePicker
      Left = 136
      Top = 32
      Width = 81
      Height = 22
      CalAlignment = dtaLeft
      Date = 39098.6389079977
      Format = 'HH:mm'
      Time = 39098.6389079977
      DateFormat = dfShort
      DateMode = dmComboBox
      Kind = dtkTime
      ParseInput = False
      TabOrder = 1
    end
  end
  object gbEmailAddress: TGroupBox
    Left = 8
    Top = 88
    Width = 233
    Height = 65
    HelpContext = 8
    Caption = 'Default Email Address'
    TabOrder = 3
    object edtEmail: TEdit
      Left = 16
      Top = 24
      Width = 201
      Height = 22
      HelpContext = 8
      MaxLength = 100
      TabOrder = 0
    end
  end
  object EnterToTab1: TEnterToTab
    ConvertEnters = True
    OverrideFont = True
    Version = 'TEnterToTab v1.02 for Delphi 6.01'
    Left = 216
    Top = 160
  end
end
