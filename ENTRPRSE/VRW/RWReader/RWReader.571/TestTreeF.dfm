object Form1: TForm1
  Left = 361
  Top = 173
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'RWReader.Dll Test App'
  ClientHeight = 481
  ClientWidth = 381
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
    Left = 10
    Top = 13
    Width = 95
    Height = 13
    Caption = 'Company Data Path'
  end
  object Bevel1: TBevel
    Left = 7
    Top = 65
    Width = 367
    Height = 2
  end
  object SBSOutlineC1: TSBSOutlineC
    Left = 7
    Top = 73
    Width = 367
    Height = 377
    ItemHeight = 13
    ItemSpace = 0
    BarColor = clHighlight
    BarTextColor = clHighlightText
    HLBarColor = clBlack
    HLBarTextColor = clWhite
    TabOrder = 0
    OnDblClick = btnViewReportClick
    ItemSeparator = '\'
    ShowValCol = 0
    TreeColor = clGray
  end
  object edtDataSetPath: TEdit
    Left = 111
    Top = 9
    Width = 259
    Height = 21
    TabOrder = 1
    Text = 'C:\Develop\Dev500\'
  end
  object btnInit: TButton
    Left = 105
    Top = 39
    Width = 80
    Height = 21
    Caption = 'rwrInit'
    TabOrder = 2
    OnClick = btnInitClick
  end
  object btnDeInit: TButton
    Left = 193
    Top = 39
    Width = 80
    Height = 21
    Caption = 'rwrDeInit'
    TabOrder = 3
    OnClick = btnDeInitClick
  end
  object btnViewReport: TButton
    Left = 151
    Top = 456
    Width = 80
    Height = 21
    Caption = 'View Report'
    TabOrder = 4
    OnClick = btnViewReportClick
  end
end
