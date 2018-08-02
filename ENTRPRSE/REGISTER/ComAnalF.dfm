object frmCOMRegAnal: TfrmCOMRegAnal
  Left = 330
  Top = 38
  Width = 398
  Height = 743
  Caption = 'frmCOMRegAnal'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PopupMenu = PopupMenu1
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object reResults: TRichEdit
    Left = 12
    Top = 11
    Width = 314
    Height = 240
    BevelInner = bvLowered
    BevelOuter = bvNone
    Color = clBtnFace
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object PopupMenu1: TPopupMenu
    Left = 41
    Top = 269
    object Refresh1: TMenuItem
      Caption = '&Refresh'
      ShortCut = 16466
      OnClick = Refresh1Click
    end
  end
end
