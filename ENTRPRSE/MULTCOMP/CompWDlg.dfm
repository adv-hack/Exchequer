object frmCompCountWarning: TfrmCompCountWarning
  Left = 349
  Top = 165
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Licence Violation'
  ClientHeight = 162
  ClientWidth = 414
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object IconImage: TImage
    Left = 8
    Top = 27
    Width = 32
    Height = 32
    OnDblClick = IconImageDblClick
  end
  object Label1: TLabel
    Left = 54
    Top = 10
    Width = 161
    Height = 13
    Caption = 'Company Licence Exceeded'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 54
    Top = 27
    Width = 348
    Height = 29
    AutoSize = False
    Caption = 
      'The number of companies currently in the Multi-Company Manager m' +
      'atches or exceeds the number that you are licenced for:-'
    WordWrap = True
  end
  object Label3: TLabel
    Left = 66
    Top = 57
    Width = 117
    Height = 16
    AutoSize = False
    Caption = 'Current Companies'
    WordWrap = True
  end
  object lblCurrComps: TLabel
    Left = 187
    Top = 57
    Width = 102
    Height = 16
    AutoSize = False
    WordWrap = True
  end
  object Label5: TLabel
    Left = 66
    Top = 74
    Width = 117
    Height = 16
    AutoSize = False
    Caption = 'Licenced Companies'
    WordWrap = True
  end
  object lblLicComps: TLabel
    Left = 187
    Top = 74
    Width = 102
    Height = 16
    AutoSize = False
    WordWrap = True
  end
  object Label4: TLabel
    Left = 54
    Top = 93
    Width = 348
    Height = 29
    AutoSize = False
    Caption = 
      'Please contact your dealer or distributor to get details on incr' +
      'easing your Licenced Company Count.'
    WordWrap = True
  end
  object btnOK: TButton
    Left = 167
    Top = 132
    Width = 80
    Height = 21
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 0
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 500
    OnTimer = Timer1Timer
    Left = 13
    Top = 78
  end
end
