object Form1: TForm1
  Left = 303
  Top = 311
  Width = 639
  Height = 354
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  DesignSize = (
    631
    327)
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 4
    Top = 6
    Width = 623
    Height = 131
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 308
    Width = 631
    Height = 19
    Panels = <>
    SimplePanel = False
  end
  object lvPlugIns: TListView
    Left = 4
    Top = 144
    Width = 623
    Height = 160
    Anchors = [akLeft, akTop, akRight, akBottom]
    Columns = <
      item
        Caption = 'Code'
        Width = 140
      end
      item
        Caption = 'Name'
        Width = 200
      end
      item
        Caption = 'Expires'
        Width = 90
      end
      item
        Caption = 'Stats'
        Width = 300
      end>
    TabOrder = 2
    ViewStyle = vsReport
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'PIL'
    Filter = 'Plug-In Licence Files|*.PIL|All Files|*.*'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 3
    Top = 27
  end
end
