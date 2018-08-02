object Form1: TForm1
  Left = 439
  Top = 205
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Form1'
  ClientHeight = 72
  ClientWidth = 377
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 14
  object lblInfo: TLabel
    Left = 6
    Top = 5
    Width = 365
    Height = 34
    AutoSize = False
    Caption = 'lblInfo'
    WordWrap = True
  end
  object btnFixPATH: TButton
    Left = 105
    Top = 45
    Width = 80
    Height = 21
    Caption = 'Fix PATH'
    TabOrder = 0
    OnClick = btnFixPATHClick
  end
  object btnClose: TButton
    Left = 193
    Top = 45
    Width = 80
    Height = 21
    Caption = 'Close'
    TabOrder = 1
    OnClick = btnCloseClick
  end
end
