object frmGuiTest: TfrmGuiTest
  Left = 27
  Top = 147
  Width = 762
  Height = 480
  Caption = 'frmGuiTest'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 392
    Width = 633
    Height = 25
    Alignment = taCenter
    AutoSize = False
    Caption = 'Label1'
  end
  object Button1: TButton
    Left = 664
    Top = 16
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 0
    OnClick = Button1Click
  end
  object ListBox1: TListBox
    Left = 8
    Top = 16
    Width = 641
    Height = 361
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier'
    Font.Style = []
    ItemHeight = 13
    ParentFont = False
    TabOrder = 1
  end
end
