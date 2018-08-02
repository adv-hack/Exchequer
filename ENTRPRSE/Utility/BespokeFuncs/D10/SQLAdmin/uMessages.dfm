object frmMessages: TfrmMessages
  Left = 413
  Top = 269
  Width = 506
  Height = 423
  BorderStyle = bsSizeToolWin
  Caption = 'Configuration'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 14
  object btnOK: TButton
    Left = 408
    Top = 360
    Width = 80
    Height = 21
    Cancel = True
    Caption = 'OK'
    Enabled = False
    TabOrder = 2
    OnClick = btnOKClick
  end
  object memMessages: TRichEdit
    Left = 8
    Top = 8
    Width = 481
    Height = 345
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 0
    WordWrap = False
  end
  object btnSave: TButton
    Left = 320
    Top = 360
    Width = 80
    Height = 21
    Caption = '&Save Log'
    Enabled = False
    TabOrder = 1
    OnClick = btnSaveClick
  end
  object SaveDialog1: TSaveDialog
    FileName = 'BespokeSQLConfig.RTF'
    Left = 288
    Top = 360
  end
end
