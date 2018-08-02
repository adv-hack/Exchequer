object Form1: TForm1
  Left = 343
  Top = 153
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Toolkit Security Test App'
  ClientHeight = 45
  ClientWidth = 276
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object btnLogout: TButton
    Left = 17
    Top = 13
    Width = 119
    Height = 25
    Caption = 'Shutdown Normally'
    TabOrder = 0
    OnClick = btnLogoutClick
  end
  object btnCrashOut: TButton
    Left = 145
    Top = 13
    Width = 120
    Height = 25
    Caption = 'Close without Logout'
    TabOrder = 1
    OnClick = btnCrashOutClick
  end
end
