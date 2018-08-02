object frmOLEServerMapViewer: TfrmOLEServerMapViewer
  Left = 350
  Top = 205
  Width = 766
  Height = 234
  Caption = 'frmOLEServerMapViewer'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    750
    196)
  PixelsPerInch = 96
  TextHeight = 14
  object memData: TMemo
    Left = 5
    Top = 5
    Width = 740
    Height = 160
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
  end
  object btnRefresh: TButton
    Left = 5
    Top = 170
    Width = 80
    Height = 21
    Anchors = [akLeft, akBottom]
    Caption = 'Refresh'
    TabOrder = 1
    OnClick = btnRefreshClick
  end
end
