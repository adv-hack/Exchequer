object FrmUtilities: TFrmUtilities
  Left = 326
  Top = 223
  Width = 336
  Height = 260
  HelpContext = 1
  Caption = 'Utilities'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 14
  object Bevel2: TBevel
    Left = 16
    Top = 48
    Width = 161
    Height = 105
  end
  object Label1: TLabel
    Left = 24
    Top = 61
    Width = 49
    Height = 14
    Caption = 'Track No :'
  end
  object Label2: TLabel
    Left = 16
    Top = 21
    Width = 34
    Height = 14
    Caption = 'Till No :'
  end
  object Bevel4: TBevel
    Left = 8
    Top = 8
    Width = 177
    Height = 217
    Shape = bsFrame
  end
  object btnDelete: TSBSButton
    Left = 192
    Top = 40
    Width = 129
    Height = 25
    Caption = '&Duplicate CUST.DAT'
    TabOrder = 0
    OnClick = btnDeleteClick
    TextId = 0
  end
  object btnClose: TButton
    Left = 192
    Top = 200
    Width = 129
    Height = 25
    Caption = '&Close'
    TabOrder = 1
    OnClick = btnCloseClick
  end
  object Button1: TButton
    Left = 192
    Top = 8
    Width = 129
    Height = 25
    Caption = '&Fake Comms Active'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 16
    Top = 160
    Width = 161
    Height = 25
    Caption = 'Get Clerk Data'
    TabOrder = 3
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 16
    Top = 192
    Width = 161
    Height = 25
    Caption = 'Get Hourly Sales Data'
    TabOrder = 4
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 24
    Top = 88
    Width = 145
    Height = 25
    Caption = 'Reprogram track no'
    TabOrder = 5
    OnClick = Button4Click
  end
  object edTrackNo: TEdit
    Left = 80
    Top = 57
    Width = 89
    Height = 22
    TabOrder = 6
  end
  object Button5: TButton
    Left = 24
    Top = 120
    Width = 145
    Height = 25
    Caption = 'Read Track No.'
    TabOrder = 7
    OnClick = Button5Click
  end
  object SBSUpDown1: TSBSUpDown
    Left = 161
    Top = 16
    Width = 15
    Height = 22
    Associate = edTillNo
    Min = 1
    Max = 8
    Position = 1
    TabOrder = 8
    Wrap = False
  end
  object edTillNo: Text8Pt
    Left = 56
    Top = 16
    Width = 105
    Height = 22
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 1
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 9
    Text = '1'
    TextId = 0
    ViaSBtn = False
  end
  object Button6: TButton
    Left = 216
    Top = 80
    Width = 75
    Height = 25
    Caption = 'Button6'
    TabOrder = 10
    OnClick = Button6Click
  end
end
