object frmCCDept: TfrmCCDept
  Left = 213
  Top = 121
  BorderStyle = bsSingle
  Caption = 'Enterprise COM Toolkit - Cost Centre & Department Demo'
  ClientHeight = 187
  ClientWidth = 541
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 6
    Top = 5
    Width = 62
    Height = 13
    Caption = 'Cost Centre'#39's'
  end
  object Label2: TLabel
    Left = 274
    Top = 5
    Width = 62
    Height = 13
    Caption = 'Department'#39's'
  end
  object lstCC: TListBox
    Left = 5
    Top = 19
    Width = 261
    Height = 163
    ItemHeight = 13
    TabOrder = 0
    TabWidth = 40
  end
  object lstDept: TListBox
    Left = 273
    Top = 19
    Width = 261
    Height = 163
    ItemHeight = 13
    TabOrder = 1
    TabWidth = 40
  end
end
