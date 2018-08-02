object frmDoExport: TfrmDoExport
  Left = 447
  Top = 311
  BorderStyle = bsToolWindow
  Caption = 'Export'
  ClientHeight = 108
  ClientWidth = 184
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 14
  object Shape3: TShape
    Left = 8
    Top = 8
    Width = 169
    Height = 65
    Brush.Color = clGray
    Pen.Color = clWhite
    Shape = stRoundRect
  end
  object Label1: TLabel
    Left = 24
    Top = 24
    Width = 110
    Height = 13
    Caption = 'Exporting Timesheets...'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object Progress: TProgressBar
    Left = 8
    Top = 80
    Width = 113
    Height = 21
    Min = 0
    Max = 100
    Smooth = True
    TabOrder = 0
  end
  object btnCancel: TButton
    Left = 128
    Top = 80
    Width = 49
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    TabOrder = 1
    OnClick = btnCancelClick
  end
end
