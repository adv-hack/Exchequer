object frmPeriodHook: TfrmPeriodHook
  Left = 413
  Top = 128
  Width = 112
  Height = 75
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object EntCustom1: TEntCustom
    AboutText.Strings = (
      'User-defined Period Hook - COM'
      'Version 1.00'
      'Copyright © IRIS Enterprise Software 2005')
    OnClose = EntCustom1Close
    OnConnect = EntCustom1Connect
    OnHook = EntCustom1Hook
    Left = 9
    Top = 7
  end
end
