object Form1: TForm1
  Left = 358
  Top = 178
  Width = 542
  Height = 311
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object edtText: TEdit
    Left = 200
    Top = 96
    Width = 121
    Height = 21
    TabOrder = 0
  end
  object btnSpeak: TButton
    Left = 208
    Top = 128
    Width = 75
    Height = 25
    Caption = 'Speak'
    TabOrder = 1
    OnClick = btnSpeakClick
  end
  object edtOutput: TEdit
    Left = 72
    Top = 200
    Width = 441
    Height = 21
    TabOrder = 2
  end
  object SpVoice1: TSpVoice
    AutoConnect = False
    ConnectKind = ckRunningOrNew
    Left = 280
    Top = 128
  end
  object SpSharedRecoContext1: TSpSharedRecoContext
    AutoConnect = True
    ConnectKind = ckRunningOrNew
    OnRecognition = SpSharedRecoContext1Recognition
    Left = 384
    Top = 72
  end
end
