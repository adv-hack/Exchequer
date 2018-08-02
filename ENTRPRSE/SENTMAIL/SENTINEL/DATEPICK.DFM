object frmDatePick: TfrmDatePick
  Left = 192
  Top = 107
  Width = 286
  Height = 202
  Caption = 'Select a date'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 193
    Height = 161
    BevelOuter = bvNone
    Caption = 'Panel1'
    TabOrder = 0
    object Cal: TMonthCalendar
      Left = 1
      Top = 1
      Width = 190
      Height = 153
      AutoSize = True
      Date = 37202.5879794097
      TabOrder = 0
    end
  end
  object Button1: TButton
    Left = 208
    Top = 8
    Width = 65
    Height = 25
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 1
  end
  object Button2: TButton
    Left = 208
    Top = 40
    Width = 65
    Height = 25
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
