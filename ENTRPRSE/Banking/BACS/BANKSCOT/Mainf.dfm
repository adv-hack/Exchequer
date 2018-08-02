object Form1: TForm1
  Left = 253
  Top = 197
  BorderStyle = bsDialog
  Caption = 'Reformat Bank of Scotland Statement v5.71.002'
  ClientHeight = 91
  ClientWidth = 487
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 14
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 385
    Height = 73
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    object lblPleaseWait: TLabel
      Left = 24
      Top = 16
      Width = 119
      Height = 14
      Caption = 'Please wait...processing'
      Visible = False
    end
    object lblProgress: TLabel
      Left = 24
      Top = 40
      Width = 353
      Height = 14
      AutoSize = False
    end
  end
  object btnStart: TSBSButton
    Left = 400
    Top = 8
    Width = 80
    Height = 21
    Caption = '&Start'
    TabOrder = 1
    OnClick = btnStartClick
    TextId = 0
  end
  object btnClose: TSBSButton
    Left = 400
    Top = 32
    Width = 80
    Height = 21
    Caption = '&Close'
    TabOrder = 2
    OnClick = btnCloseClick
    TextId = 0
  end
  object OpenDialog1: TOpenDialog
    Filter = 'Statement Files (*.csv; *.trn)|*.csv;*.trn|All files (*.*)|*.*'
    Left = 424
    Top = 56
  end
  object fpCSV: TCsvFileParser
    Separator = ','
    Delimiter = '"'
    StartLine = 0
    OnReadLine = fpCSVReadLine
    Left = 456
    Top = 56
  end
end
