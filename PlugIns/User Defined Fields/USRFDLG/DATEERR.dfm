object FrmDateError: TFrmDateError
  Left = 309
  Top = 232
  BorderStyle = bsDialog
  Caption = 'Date Input'
  ClientHeight = 143
  ClientWidth = 239
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnCloseQuery = FormCloseQuery
  PixelsPerInch = 96
  TextHeight = 14
  object Bevel1: TBevel
    Left = 8
    Top = 56
    Width = 225
    Height = 50
    Shape = bsFrame
  end
  object lLabel: TLabel
    Left = 16
    Top = 76
    Width = 28
    Height = 14
    Caption = 'lLabel'
  end
  object lTitle: TLabel
    Left = 8
    Top = 4
    Width = 222
    Height = 28
    Caption = 
      'The date you have entered does not conform with the date format ' +
      'specified :'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
  end
  object lFormat: TLabel
    Left = 24
    Top = 36
    Width = 75
    Height = 14
    Caption = 'Date Format : '
    Font.Charset = ANSI_CHARSET
    Font.Color = clMaroon
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object btnOK: TButton
    Left = 96
    Top = 112
    Width = 65
    Height = 25
    Caption = '&OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object edDate: TDateTimePicker
    Left = 96
    Top = 72
    Width = 121
    Height = 22
    CalAlignment = dtaLeft
    Date = 37838.4129771181
    Time = 37838.4129771181
    DateFormat = dfShort
    DateMode = dmComboBox
    Kind = dtkDate
    ParseInput = False
    TabOrder = 1
  end
  object btnCancel: TButton
    Left = 168
    Top = 112
    Width = 65
    Height = 25
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
