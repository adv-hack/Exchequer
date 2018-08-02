object FrmFTPLog: TFrmFTPLog
  Left = 219
  Top = 121
  Width = 584
  Height = 491
  Caption = 'FTP Log'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object memLog: TMemo
    Left = 8
    Top = 8
    Width = 561
    Height = 417
    Anchors = [akLeft, akTop, akRight, akBottom]
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object btnOK: TButton
    Left = 496
    Top = 432
    Width = 73
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = '&OK'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ModalResult = 1
    ParentFont = False
    TabOrder = 1
  end
end
