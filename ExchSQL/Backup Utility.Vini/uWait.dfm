object frmWait: TfrmWait
  Left = 380
  Top = 676
  BorderIcons = []
  BorderStyle = bsNone
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
  object pnlInfo: TAdvPanel
    Left = 0
    Top = 0
    Width = 254
    Height = 38
    Align = alClient
    BevelInner = bvLowered
    Color = clWhite
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    UseDockManager = True
    Version = '1.7.7.2'
    Caption.Color = clHighlight
    Caption.ColorTo = clNone
    Caption.Font.Charset = DEFAULT_CHARSET
    Caption.Font.Color = clHighlightText
    Caption.Font.Height = -11
    Caption.Font.Name = 'MS Sans Serif'
    Caption.Font.Style = []
    StatusBar.Font.Charset = DEFAULT_CHARSET
    StatusBar.Font.Color = clWindowText
    StatusBar.Font.Height = -11
    StatusBar.Font.Name = 'Tahoma'
    StatusBar.Font.Style = []
    TextVAlign = tvaCenter
    FullHeight = 38
    object Progress: TAdvCircularProgress
      Left = 213
      Top = 2
      Width = 39
      Height = 34
      Align = alRight
      Visible = False
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