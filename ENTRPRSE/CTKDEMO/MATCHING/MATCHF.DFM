object frmMatchDemo: TfrmMatchDemo
  Left = 260
  Top = 138
  BorderStyle = bsSingle
  Caption = 'COM Toolkit Demo - Matching SRC -> SIN'
  ClientHeight = 156
  ClientWidth = 611
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 7
    Top = 3
    Width = 85
    Height = 13
    Caption = 'Outstanding SIN'#39's'
  end
  object Label2: TLabel
    Left = 310
    Top = 3
    Width = 89
    Height = 13
    Caption = 'Outstanding SRC'#39's'
  end
  object lstSIN: TListBox
    Left = 5
    Top = 19
    Width = 298
    Height = 97
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ItemHeight = 14
    ParentFont = False
    TabOrder = 0
  end
  object btnLoad: TButton
    Left = 5
    Top = 126
    Width = 75
    Height = 25
    Caption = 'Load Lists'
    TabOrder = 1
    OnClick = btnLoadClick
  end
  object lstSRC: TListBox
    Left = 308
    Top = 19
    Width = 298
    Height = 97
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ItemHeight = 14
    ParentFont = False
    TabOrder = 2
  end
  object btnMatch: TButton
    Left = 87
    Top = 126
    Width = 103
    Height = 25
    Caption = 'Match SIN->SRC'
    TabOrder = 3
    OnClick = btnMatchClick
  end
end
