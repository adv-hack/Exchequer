object FrmDebugInfo: TFrmDebugInfo
  Left = 220
  Top = 177
  Width = 320
  Height = 290
  HelpContext = 1
  BorderStyle = bsSizeToolWin
  Caption = 'Debug Info'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Position = poDefault
  Scaled = False
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object memDebug: TMemo
    Left = 0
    Top = 0
    Width = 312
    Height = 225
    Align = alTop
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Fixedsys'
    Font.Style = []
    Lines.Strings = (
      'Memo1  2'
      'abcd1  2 ')
    ParentFont = False
    ReadOnly = True
    TabOrder = 0
  end
  object btnClose: TButton
    Left = 232
    Top = 232
    Width = 73
    Height = 25
    Caption = '&Close'
    TabOrder = 1
    OnClick = btnCloseClick
  end
  object btnCopy: TButton
    Left = 120
    Top = 232
    Width = 105
    Height = 25
    Caption = '&Copy To Clipboard'
    TabOrder = 2
    OnClick = btnCopyClick
  end
end
