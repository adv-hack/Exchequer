object frmPurgeOpts: TfrmPurgeOpts
  Left = 192
  Top = 107
  Width = 368
  Height = 205
  Caption = 'Purge'
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
  object Button1: TButton
    Left = 280
    Top = 16
    Width = 73
    Height = 25
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 0
  end
  object Button2: TButton
    Left = 280
    Top = 48
    Width = 73
    Height = 25
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 265
    Height = 153
    Caption = 'Select record types to purge..'
    TabOrder = 2
    object chkHistory: TCheckBox
      Left = 32
      Top = 32
      Width = 217
      Height = 17
      Caption = 'History of records that have been sent.'
      TabOrder = 0
    end
    object chkEvents: TCheckBox
      Left = 32
      Top = 72
      Width = 201
      Height = 17
      Caption = 'Outstanding events. '
      TabOrder = 1
    end
    object chkOutput: TCheckBox
      Left = 32
      Top = 112
      Width = 217
      Height = 17
      Caption = 'Output waiting to be sent.'
      TabOrder = 2
    end
  end
end
