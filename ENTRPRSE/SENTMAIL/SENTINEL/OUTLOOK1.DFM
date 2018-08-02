object FrmOutlook: TFrmOutlook
  Left = 122
  Top = 144
  Width = 536
  Height = 373
  Caption = 'Outlook '
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
    Left = 13
    Top = 7
    Width = 82
    Height = 13
    Caption = 'Outlook Contacts'
  end
  object LVContacts: TListView
    Left = 8
    Top = 24
    Width = 409
    Height = 313
    Color = clWhite
    Columns = <>
    MultiSelect = True
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
  end
  object Button1: TButton
    Left = 424
    Top = 24
    Width = 89
    Height = 25
    Caption = 'Edit Contact(s)'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 424
    Top = 89
    Width = 89
    Height = 25
    Caption = 'Print Contact(s)'
    TabOrder = 2
  end
  object Button3: TButton
    Left = 424
    Top = 56
    Width = 89
    Height = 25
    Caption = 'Delete Contact(s)'
    TabOrder = 3
  end
  object Outlook: TOutlookApplication
    AutoConnect = False
    ConnectKind = ckRunningOrNew
    AutoQuit = False
    Left = 424
    Top = 304
  end
end
