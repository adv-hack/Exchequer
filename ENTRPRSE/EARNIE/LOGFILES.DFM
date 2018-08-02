object FrmLogFiles: TFrmLogFiles
  Left = 380
  Top = 192
  BorderStyle = bsSingle
  Caption = 'Log Files'
  ClientHeight = 295
  ClientWidth = 289
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 89
    Height = 14
    Caption = 'Log Files Avaliable'
  end
  object BtnClose: TBitBtn
    Left = 200
    Top = 56
    Width = 81
    Height = 25
    Cancel = True
    Caption = '&Close'
    TabOrder = 0
    OnClick = BtnCloseClick
    NumGlyphs = 2
  end
  object ViewBtn: TBitBtn
    Left = 200
    Top = 24
    Width = 81
    Height = 25
    Caption = 'View Log File'
    TabOrder = 1
    OnClick = ViewBtnClick
    NumGlyphs = 2
  end
  object lbLogFile: TListBox
    Left = 8
    Top = 24
    Width = 185
    Height = 265
    ItemHeight = 14
    TabOrder = 2
    OnDblClick = lbLogFileClick
  end
end
