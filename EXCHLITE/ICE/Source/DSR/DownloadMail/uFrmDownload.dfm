object frmDSRDownload: TfrmDSRDownload
  Left = 553
  Top = 282
  Width = 123
  Height = 66
  BorderIcons = [biSystemMenu]
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object AppEvents: TApplicationEvents
    OnException = AppEventsException
    Left = 2
    Top = 4
  end
  object tmClose: TTimer
    Enabled = False
    Interval = 1800000
    OnTimer = tmCloseTimer
    Left = 34
    Top = 4
  end
end
