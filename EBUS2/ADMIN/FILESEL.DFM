object frmFileSelect: TfrmFileSelect
  Left = 312
  Top = 162
  HelpContext = 99
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  BorderStyle = bsSingle
  Caption = 'Delete log files ...'
  ClientHeight = 179
  ClientWidth = 344
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = True
  Position = poDefaultPosOnly
  Scaled = False
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object btnCancel: TButton
    Left = 178
    Top = 150
    Width = 80
    Height = 21
    Caption = '&Cancel'
    TabOrder = 1
    OnClick = btnCancelClick
  end
  object btnOK: TButton
    Left = 90
    Top = 150
    Width = 80
    Height = 21
    Caption = '&OK'
    TabOrder = 0
    OnClick = btnOKClick
  end
  object grpSelection: TSBSGroup
    Left = 8
    Top = 8
    Width = 329
    Height = 49
    Caption = 'Selection criterion'
    TabOrder = 2
    AllowReSize = False
    IsGroupBox = True
    TextId = 0
    object radDateRange: TBorRadio
      Left = 24
      Top = 19
      Width = 89
      Height = 20
      Caption = 'Date Range'
      TabOrder = 0
      TextId = 0
      OnClick = radButtonClick
    end
    object radLogNumbers: TBorRadio
      Left = 238
      Top = 19
      Width = 57
      Height = 20
      Caption = 'Logs'
      TabOrder = 1
      TextId = 0
      OnClick = radButtonClick
    end
    object radAll: TBorRadio
      Left = 144
      Top = 19
      Width = 42
      Height = 20
      Caption = 'All'
      TabOrder = 2
      TextId = 0
      OnClick = radButtonClick
    end
  end
  object grpDateRange: TSBSGroup
    Left = 8
    Top = 64
    Width = 137
    Height = 73
    TabOrder = 3
    AllowReSize = False
    IsGroupBox = True
    TextId = 0
    object Label5: TLabel
      Left = 15
      Top = 16
      Width = 23
      Height = 13
      Caption = 'From'
    end
    object Label6: TLabel
      Left = 24
      Top = 48
      Width = 13
      Height = 13
      Caption = 'To'
    end
    object edtToDate: TEditDate
      Left = 49
      Top = 44
      Width = 75
      Height = 21
      AutoSelect = False
      Color = clGreen
      EditMask = '00/00/0000;0; '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      MaxLength = 10
      ParentFont = False
      TabOrder = 0
      Placement = cpAbove
    end
    object edtFromDate: TEditDate
      Left = 49
      Top = 12
      Width = 75
      Height = 21
      AutoSelect = False
      Color = clGreen
      EditMask = '00/00/0000;0; '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      MaxLength = 10
      ParentFont = False
      TabOrder = 1
      Placement = cpAbove
    end
  end
  object grpLogNumbers: TSBSGroup
    Left = 192
    Top = 64
    Width = 145
    Height = 73
    TabOrder = 4
    AllowReSize = False
    IsGroupBox = True
    TextId = 0
    object Label4: TLabel
      Left = 28
      Top = 44
      Width = 13
      Height = 13
      Caption = 'To'
    end
    object Label3: TLabel
      Left = 18
      Top = 16
      Width = 23
      Height = 13
      Caption = 'From'
    end
    object edtFromNumber: Text8Pt
      Left = 54
      Top = 13
      Width = 71
      Height = 22
      Color = clGreen
      EditMask = '!999999;0; '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      MaxLength = 6
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      TextId = 0
      ViaSBtn = False
    end
  end
  object edtToNumber: Text8Pt
    Left = 246
    Top = 104
    Width = 71
    Height = 22
    Color = clGreen
    EditMask = '!999999;0; '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 6
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 5
    TextId = 0
    ViaSBtn = False
  end
end
