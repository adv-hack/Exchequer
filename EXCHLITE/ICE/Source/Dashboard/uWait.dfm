object frmWait: TfrmWait
  Left = 294
  Top = 247
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Dashboard'
  ClientHeight = 38
  ClientWidth = 254
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDeactivate = FormDeactivate
  OnHide = FormDeactivate
  PixelsPerInch = 96
  TextHeight = 14
  object pnlInfo: TPanel
    Left = 0
    Top = 0
    Width = 254
    Height = 38
    Align = alClient
    Alignment = taLeftJustify
    BevelInner = bvLowered
    Color = clWhite
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    object Progress: TAdvCircularProgress
      Left = 218
      Top = 2
      Width = 34
      Height = 34
      Align = alRight
      Appearance.BackGroundColor = clNone
      Appearance.BorderColor = clNone
      Appearance.ActiveSegmentColor = 16752543
      Appearance.InActiveSegmentColor = clSilver
      Appearance.TransitionSegmentColor = 10485760
      Appearance.ProgressSegmentColor = 4194432
      Interval = 100
    end
  end
  object tmClose: TTimer
    Enabled = False
    Interval = 12000
    OnTimer = tmCloseTimer
    Left = 106
    Top = 4
  end
end