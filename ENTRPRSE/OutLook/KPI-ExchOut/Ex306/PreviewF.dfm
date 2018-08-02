object frmPreview: TfrmPreview
  Left = 150
  Top = 154
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Print Preview'
  ClientHeight = 355
  ClientWidth = 659
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object btnZoomIn: TButton
    Left = 579
    Top = 9
    Width = 75
    Height = 21
    Caption = 'Zoom In'
    TabOrder = 0
    OnClick = btnZoomInClick
  end
  object btnZoomOut: TButton
    Left = 579
    Top = 31
    Width = 75
    Height = 21
    Caption = 'Zoom Out'
    TabOrder = 1
    OnClick = btnZoomOutClick
  end
  object btnZoomPage: TButton
    Left = 579
    Top = 53
    Width = 75
    Height = 21
    Caption = 'Zoom Page'
    TabOrder = 2
    OnClick = btnZoomPageClick
  end
  object btnPreviousPage: TButton
    Left = 579
    Top = 80
    Width = 75
    Height = 21
    Caption = 'PrevPage'
    TabOrder = 3
    OnClick = btnPreviousPageClick
  end
  object btnNextPage: TButton
    Left = 580
    Top = 102
    Width = 75
    Height = 21
    Caption = 'Next Page'
    TabOrder = 4
    OnClick = btnNextPageClick
  end
  object btnClose: TButton
    Left = 580
    Top = 128
    Width = 75
    Height = 21
    Cancel = True
    Caption = 'Close'
    TabOrder = 5
    OnClick = btnCloseClick
  end
  object entPreviewX1: TentPreviewX
    Left = 5
    Top = 5
    Width = 570
    Height = 345
    TabOrder = 6
    ControlData = {
      545046300C54526176655072657669657700044C656674020503546F70020505
      5769647468033A020648656967687403590106416374697665080B4375727265
      6E74506167650200045A6F6F6D0500000000000000E60540075A6F6F6D496E63
      02190000}
  end
end
