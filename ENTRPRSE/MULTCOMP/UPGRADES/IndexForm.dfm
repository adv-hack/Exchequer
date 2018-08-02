object Form1: TForm1
  Left = 344
  Top = 403
  BorderStyle = bsDialog
  Caption = 'Index Utility v1.0.001'
  ClientHeight = 316
  ClientWidth = 601
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel
    Left = 8
    Top = 16
    Width = 53
    Height = 14
    Caption = 'Companies'
  end
  object Label2: TLabel
    Left = 367
    Top = 10
    Width = 73
    Height = 14
    Alignment = taRightJustify
    Caption = 'Index to delete:'
  end
  object lbCompanies: TListBox
    Left = 8
    Top = 32
    Width = 489
    Height = 265
    ItemHeight = 14
    MultiSelect = True
    TabOrder = 0
  end
  object btnDeleteIndex: TButton
    Left = 512
    Top = 32
    Width = 75
    Height = 25
    Caption = '&Delete Index'
    TabOrder = 1
    OnClick = btnDeleteIndexClick
  end
  object btnAddIndex: TButton
    Left = 512
    Top = 64
    Width = 75
    Height = 25
    Caption = '&Add Index'
    TabOrder = 2
    OnClick = btnAddIndexClick
  end
  object btnClose: TButton
    Left = 512
    Top = 96
    Width = 75
    Height = 25
    Caption = '&Close'
    TabOrder = 3
    OnClick = btnCloseClick
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 297
    Width = 601
    Height = 19
    Panels = <>
    ParentColor = True
    ParentFont = True
    SimplePanel = True
    UseSystemFont = False
  end
  object Edit1: TEdit
    Left = 446
    Top = 8
    Width = 33
    Height = 22
    TabOrder = 5
    Text = '10'
  end
  object udIndex: TUpDown
    Left = 479
    Top = 8
    Width = 16
    Height = 22
    Associate = Edit1
    Min = 0
    Position = 10
    TabOrder = 6
    Wrap = False
  end
  object btnSelect: TButton
    Left = 512
    Top = 240
    Width = 75
    Height = 25
    Caption = '&Select All'
    TabOrder = 7
    OnClick = btnSelectClick
  end
  object btnUnselect: TButton
    Left = 512
    Top = 272
    Width = 75
    Height = 25
    Caption = '&Unselect All'
    TabOrder = 8
    OnClick = btnUnselectClick
  end
end
