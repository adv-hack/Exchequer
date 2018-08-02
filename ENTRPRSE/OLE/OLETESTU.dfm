object Form1: TForm1
  Left = 53
  Top = 138
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Exchequer Setup Test Utility'
  ClientHeight = 175
  ClientWidth = 395
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnActivate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object TitleLbl: TLabel
    Left = 11
    Top = 9
    Width = 375
    Height = 28
    AutoSize = False
    Caption = 'Exchequer OLE Server'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -24
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
  end
  object Label1: TLabel
    Left = 10
    Top = 103
    Width = 375
    Height = 28
    AutoSize = False
    Caption = 'Pervasive Software ODBC Driver'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -24
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
  end
  object OLELbl: TLabel
    Left = 11
    Top = 48
    Width = 376
    Height = 13
    AutoSize = False
    Caption = 'Loading OLE Server, Please Wait...'
  end
  object ErrLbl: TLabel
    Left = 11
    Top = 71
    Width = 376
    Height = 13
    Alignment = taCenter
    AutoSize = False
  end
  object OdbcLbl: TLabel
    Left = 11
    Top = 142
    Width = 376
    Height = 13
    AutoSize = False
  end
end
