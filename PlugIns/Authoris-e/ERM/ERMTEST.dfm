object frmPollTest: TfrmPollTest
  Left = 412
  Top = 241
  BorderStyle = bsDialog
  Caption = 'Poll Test'
  ClientHeight = 311
  ClientWidth = 242
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 232
    Width = 3
    Height = 13
  end
  object Label2: TLabel
    Left = 24
    Top = 208
    Width = 3
    Height = 13
  end
  object Label3: TLabel
    Left = 24
    Top = 8
    Width = 31
    Height = 13
    Caption = 'Server'
  end
  object Label4: TLabel
    Left = 24
    Top = 56
    Width = 22
    Height = 13
    Caption = 'User'
  end
  object Label5: TLabel
    Left = 24
    Top = 104
    Width = 46
    Height = 13
    Caption = 'Password'
  end
  object Label6: TLabel
    Left = 24
    Top = 152
    Width = 83
    Height = 13
    Caption = 'Frequency (Secs)'
  end
  object Start: TButton
    Left = 16
    Top = 272
    Width = 75
    Height = 25
    Caption = 'Start'
    TabOrder = 0
    OnClick = StartClick
  end
  object Stop: TButton
    Left = 136
    Top = 272
    Width = 75
    Height = 25
    Caption = 'Stop'
    TabOrder = 1
    OnClick = StopClick
  end
  object edtServer: TEdit
    Left = 24
    Top = 24
    Width = 121
    Height = 21
    TabOrder = 2
  end
  object edtUser: TEdit
    Left = 24
    Top = 72
    Width = 121
    Height = 21
    TabOrder = 3
  end
  object edtPassword: TEdit
    Left = 24
    Top = 120
    Width = 121
    Height = 21
    TabOrder = 4
  end
  object edtFreq: TEdit
    Left = 24
    Top = 168
    Width = 41
    Height = 21
    TabOrder = 5
    Text = '10'
  end
  object UpDown1: TUpDown
    Left = 65
    Top = 168
    Width = 16
    Height = 21
    Associate = edtFreq
    Min = 10
    Position = 10
    TabOrder = 6
    Wrap = False
  end
end
