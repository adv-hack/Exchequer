object FrmAutoEOD: TFrmAutoEOD
  Left = 392
  Top = 230
  HelpContext = 23
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Exchequer Loyalty - Auto End of Day'
  ClientHeight = 240
  ClientWidth = 288
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnActivate = FormActivate
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 14
  object Bevel1: TBevel
    Left = 128
    Top = 136
    Width = 153
    Height = 65
    Shape = bsFrame
  end
  object Bevel2: TBevel
    Left = 8
    Top = 136
    Width = 113
    Height = 97
    Shape = bsFrame
  end
  object Label3: TLabel
    Left = 136
    Top = 150
    Width = 67
    Height = 14
    Caption = 'Current Time :'
  end
  object lTime: TLabel
    Left = 208
    Top = 150
    Width = 31
    Height = 14
    Caption = 'lTime'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label4: TLabel
    Left = 136
    Top = 174
    Width = 67
    Height = 14
    Caption = 'Current Date :'
  end
  object lDate: TLabel
    Left = 208
    Top = 174
    Width = 27
    Height = 14
    Caption = 'lDate'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label1: TLabel
    Left = 16
    Top = 128
    Width = 68
    Height = 14
    Caption = ' Dates Done '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 273
    Height = 89
    Color = clGray
    TabOrder = 1
    object lAEODTime: TLabel
      Left = 8
      Top = 8
      Width = 189
      Height = 14
      Caption = 'An End of Day will be executed daily at'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 8
      Top = 24
      Width = 252
      Height = 14
      Caption = 'until the Automatic End of Day is manually cancelled.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label5: TLabel
      Left = 24
      Top = 48
      Width = 40
      Height = 14
      Caption = 'Status : '
      Color = clGray
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    object lStatus: TLabel
      Left = 64
      Top = 48
      Width = 44
      Height = 14
      Caption = 'Waiting...'
      Color = clGray
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    object Label6: TLabel
      Left = 24
      Top = 64
      Width = 36
      Height = 14
      Caption = 'Name : '
      Color = clGray
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    object lName: TLabel
      Left = 64
      Top = 64
      Width = 32
      Height = 14
      Caption = '(none)'
      Color = clGray
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
  end
  object btnCancel: TButton
    Left = 128
    Top = 208
    Width = 153
    Height = 25
    Caption = '&Cancel Auto EOD'
    TabOrder = 0
    OnClick = btnCancelClick
  end
  object lbDatesDone: TListBox
    Left = 16
    Top = 144
    Width = 97
    Height = 81
    ItemHeight = 14
    TabOrder = 2
  end
  object ProgressBar1: TProgressBar
    Left = 8
    Top = 104
    Width = 273
    Height = 17
    Min = 0
    Max = 100
    TabOrder = 3
  end
  object timEOD: TTimer
    Enabled = False
    OnTimer = timEODTimer
    Left = 24
    Top = 152
  end
end
