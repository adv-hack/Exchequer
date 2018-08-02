object FrmStatus: TFrmStatus
  Left = 227
  Top = 238
  BorderIcons = [biMinimize, biMaximize]
  BorderStyle = bsSingle
  Caption = 'Exporting Files....'
  ClientHeight = 73
  ClientWidth = 312
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  Visible = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Animate1: TAnimate
    Left = 24
    Top = 8
    Width = 272
    Height = 60
    Active = False
    CommonAVI = aviCopyFiles
    StopFrame = 34
  end
end
