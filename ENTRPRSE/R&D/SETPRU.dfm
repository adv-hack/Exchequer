object SetPerRec: TSetPerRec
  Left = 641
  Top = 259
  HelpContext = 253
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Set Current Financial Period'
  ClientHeight = 206
  ClientWidth = 276
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  FormStyle = fsMDIChild
  KeyPreview = True
  OldCreateOrder = True
  Position = poDefault
  Scaled = False
  Visible = True
  OnActivate = FormActivate
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 14
  object Panel1: TSBSBackGroup
    Left = 3
    Top = 7
    Width = 270
    Height = 166
    TextId = 0
  end
  object Label82: Label8
    Left = 45
    Top = 51
    Width = 108
    Height = 14
    Caption = '&Current Period number'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label83: Label8
    Left = 59
    Top = 82
    Width = 93
    Height = 14
    Caption = 'Financial &Year start'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label81: Label8
    Left = 37
    Top = 113
    Width = 116
    Height = 14
    Caption = 'Equivalent Date (mm/yy)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label84: Label8
    Left = 180
    Top = 144
    Width = 83
    Height = 14
    Caption = '(not as numbers)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object EqF: Text8Pt
    Left = 161
    Top = 109
    Width = 73
    Height = 22
    TabStop = False
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ReadOnly = True
    ShowHint = True
    TabOrder = 4
    Text = 'Oct/1996'
    TextId = 0
    ViaSBtn = False
  end
  object OkCP1Btn: TButton
    Tag = 1
    Left = 58
    Top = 180
    Width = 80
    Height = 21
    Caption = '&OK'
    Enabled = False
    ModalResult = 1
    TabOrder = 6
    OnClick = OkCP1BtnClick
  end
  object CanCP1Btn: TButton
    Tag = 1
    Left = 143
    Top = 180
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 7
    OnClick = CanCP1BtnClick
  end
  object SPrmF: TBorCheck
    Tag = 1
    Left = 18
    Top = 141
    Width = 156
    Height = 20
    Caption = '&Show periods as months'
    CheckColor = clWindowText
    Color = clBtnFace
    Enabled = False
    ParentColor = False
    TabOrder = 5
    TabStop = True
    TextId = 0
  end
  object CPrF: TSBSComboBox
    Tag = 1
    Left = 161
    Top = 48
    Width = 73
    Height = 22
    Style = csDropDownList
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 14
    ParentFont = False
    TabOrder = 2
    OnExit = CPrFExit
    AllowChangeInExit = True
    MaxListWidth = 0
    ReadOnly = True
    Validate = True
  end
  object CYrF: TSBSComboBox
    Tag = 1
    Left = 161
    Top = 79
    Width = 73
    Height = 22
    Style = csDropDownList
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 14
    ParentFont = False
    TabOrder = 3
    OnExit = CPrFExit
    AllowChangeInExit = True
    MaxListWidth = 0
    ReadOnly = True
    Validate = True
  end
  object BRGlobal: TBorRadio
    Left = 53
    Top = 20
    Width = 84
    Height = 20
    Caption = 'Set &Globally'
    CheckColor = clWindowText
    GroupIndex = 1
    TabOrder = 0
    TextId = 0
    OnClick = BRGlobalClick
  end
  object BRLocal: TBorRadio
    Left = 146
    Top = 20
    Width = 77
    Height = 20
    Caption = 'Set &Locally'
    CheckColor = clWindowText
    Checked = True
    GroupIndex = 1
    TabOrder = 1
    TabStop = True
    TextId = 0
  end
end
