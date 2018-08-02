object frmLogView: TfrmLogView
  Left = 192
  Top = 107
  Width = 560
  Height = 431
  Caption = 'frmLogView'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  DesignSize = (
    552
    404)
  PixelsPerInch = 96
  TextHeight = 13
  object memLog: TMemo
    Left = 8
    Top = 8
    Width = 449
    Height = 393
    Anchors = [akLeft, akTop, akRight, akBottom]
    Lines.Strings = (
      '')
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object SBSButton1: TSBSButton
    Left = 464
    Top = 8
    Width = 80
    Height = 21
    Anchors = [akTop, akRight]
    Caption = '&Close'
    ModalResult = 2
    TabOrder = 1
    TextId = 0
  end
end
