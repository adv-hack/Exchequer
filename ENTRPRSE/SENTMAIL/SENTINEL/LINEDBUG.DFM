object frmLineDebug: TfrmLineDebug
  Left = 203
  Top = 230
  BorderStyle = bsDialog
  Caption = 'Records'
  ClientHeight = 355
  ClientWidth = 663
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
  object Memo1: TMemo
    Left = 8
    Top = 8
    Width = 553
    Height = 329
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Courier'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 0
    WordWrap = False
  end
  object Button1: TButton
    Left = 576
    Top = 8
    Width = 75
    Height = 25
    Caption = '&Close'
    ModalResult = 2
    TabOrder = 1
  end
  object Button2: TButton
    Left = 576
    Top = 40
    Width = 75
    Height = 25
    Caption = '&Export'
    TabOrder = 2
    OnClick = Button2Click
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'txt'
    Filter = 'Text files|*.txt'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 632
    Top = 320
  end
end
