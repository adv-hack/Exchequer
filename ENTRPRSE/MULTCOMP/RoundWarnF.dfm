object frmRoundingWarning: TfrmRoundingWarning
  Left = 349
  Top = 165
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Exchequer SQL Rounding Function Error'
  ClientHeight = 114
  ClientWidth = 414
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
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
    Width = 188
    Height = 13
    Caption = 'Rounding Function Not Available'
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
      'A test of the Exchequer SQL Rounding Function has failed, this f' +
      'unction is critical to the accuracy of Exchequer SQL.'
    WordWrap = True
  end
  object Label4: TLabel
    Left = 54
    Top = 60
    Width = 348
    Height = 19
    AutoSize = False
    Caption = 'Please contact your technical support immediately.'
    WordWrap = True
  end
  object btnOK: TButton
    Left = 167
    Top = 86
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
    Top = 67
  end
end
