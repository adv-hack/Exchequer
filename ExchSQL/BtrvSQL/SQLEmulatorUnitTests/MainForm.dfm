object MainFrm: TMainFrm
  Left = 274
  Top = 114
  Width = 728
  Height = 768
  Caption = 'SQL Emulator Tests'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    720
    734)
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 4
    Top = 284
    Width = 712
    Height = 25
    Anchors = [akLeft, akTop, akRight]
  end
  object Shape1: TShape
    Left = 0
    Top = 0
    Width = 720
    Height = 281
    Align = alTop
    Pen.Style = psClear
  end
  object Label1: TLabel
    Left = 12
    Top = 88
    Width = 44
    Height = 13
    Caption = 'Company'
    Transparent = True
  end
  object Label2: TLabel
    Left = 12
    Top = 64
    Width = 31
    Height = 13
    Caption = 'Server'
    Transparent = True
  end
  object Label3: TLabel
    Left = 12
    Top = 160
    Width = 46
    Height = 13
    Caption = 'Database'
    Transparent = True
  end
  object Label4: TLabel
    Left = 192
    Top = 160
    Width = 28
    Height = 13
    Caption = 'Name'
    Transparent = True
  end
  object Label6: TLabel
    Left = 32
    Top = 208
    Width = 22
    Height = 13
    Caption = 'Path'
    Transparent = True
  end
  object Label7: TLabel
    Left = 12
    Top = 232
    Width = 97
    Height = 13
    Caption = 'Source data ZIP File'
    Transparent = True
  end
  object RunningLbl: TLabel
    Left = 28
    Top = 288
    Width = 128
    Height = 13
    Caption = 'Running tests. Please wait.'
    Visible = False
  end
  object Label8: TLabel
    Left = 4
    Top = 24
    Width = 625
    Height = 13
    AutoSize = False
    Caption = 
      'Parameters (these must be set correctly before running the tests' +
      ')'
    Color = 16768460
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
  end
  object Label9: TLabel
    Left = 12
    Top = 40
    Width = 101
    Height = 13
    Caption = 'Existing database'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object Label10: TLabel
    Left = 12
    Top = 136
    Width = 82
    Height = 13
    Caption = 'Test database'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object Label11: TLabel
    Left = 12
    Top = 184
    Width = 44
    Height = 13
    Caption = 'Company'
    Transparent = True
  end
  object Label12: TLabel
    Left = 32
    Top = 112
    Width = 22
    Height = 13
    Caption = 'Path'
    Transparent = True
  end
  object Label13: TLabel
    Left = 12
    Top = 256
    Width = 102
    Height = 13
    Caption = 'Export/import ZIP File'
    Transparent = True
  end
  object Label14: TLabel
    Left = 4
    Top = 4
    Width = 625
    Height = 13
    Alignment = taCenter
    AutoSize = False
    Caption = 
      'These tests are potentially destructive, and should never be run' +
      ' against live data.'
    Color = clRed
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
  end
  object Label15: TLabel
    Left = 196
    Top = 64
    Width = 46
    Height = 13
    Caption = 'Database'
    Transparent = True
  end
  object SelectPathBtn: TSpeedButton
    Left = 368
    Top = 108
    Width = 21
    Height = 20
    Hint = 'Select path'
    Caption = '...'
    Flat = True
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'System'
    Font.Style = [fsBold]
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    OnClick = SelectPathBtnClick
  end
  object SelectTestPath: TSpeedButton
    Left = 368
    Top = 204
    Width = 21
    Height = 20
    Hint = 'Select path'
    Caption = '...'
    Flat = True
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'System'
    Font.Style = [fsBold]
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    OnClick = SelectTestPathClick
  end
  object SelectDataZipBtn: TSpeedButton
    Left = 612
    Top = 228
    Width = 21
    Height = 20
    Hint = 'Select source data file'
    Caption = '...'
    Flat = True
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'System'
    Font.Style = [fsBold]
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    OnClick = SelectDataZipBtnClick
  end
  object SelectImportExportFileBtn: TSpeedButton
    Left = 612
    Top = 252
    Width = 21
    Height = 20
    Hint = 'Select import/export file'
    Caption = '...'
    Flat = True
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'System'
    Font.Style = [fsBold]
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    OnClick = SelectImportExportFileBtnClick
  end
  object CompanyCodeTxt: TEdit
    Left = 64
    Top = 84
    Width = 53
    Height = 21
    TabOrder = 1
    Text = 'ZZZZ01'
  end
  object ServerTxt: TEdit
    Left = 64
    Top = 60
    Width = 121
    Height = 21
    TabOrder = 0
    Text = 'CSDEV\IRISSQL'
  end
  object TestDatabaseTxt: TEdit
    Left = 64
    Top = 156
    Width = 121
    Height = 21
    TabOrder = 3
    Text = 'TestDatabase'
  end
  object TestCompanyNameTxt: TEdit
    Left = 224
    Top = 156
    Width = 121
    Height = 21
    TabOrder = 5
    Text = 'Test Company'
  end
  object TestCompanyPathTxt: TEdit
    Left = 64
    Top = 204
    Width = 305
    Height = 21
    TabOrder = 6
    Text = 'C:\EXCHEQR\TEST\'
  end
  object SourceZIPFileNameTxt: TEdit
    Left = 124
    Top = 228
    Width = 485
    Height = 21
    TabOrder = 7
    Text = 'C:\EXCHDATA\BaseMC.zip'
  end
  object RunBtn: TButton
    Left = 640
    Top = 4
    Width = 75
    Height = 25
    Caption = '&Run'
    Default = True
    TabOrder = 9
    OnClick = RunBtnClick
  end
  object CloseBtn: TButton
    Left = 640
    Top = 32
    Width = 75
    Height = 25
    Cancel = True
    Caption = '&Close'
    TabOrder = 10
    OnClick = CloseBtnClick
  end
  object TestList: TCheckListBox
    Left = 4
    Top = 312
    Width = 712
    Height = 377
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 16
    ParentFont = False
    Style = lbOwnerDrawFixed
    TabOrder = 11
    OnDrawItem = TestListDrawItem
  end
  object RunningAnim: TAnimate
    Left = 8
    Top = 288
    Width = 16
    Height = 16
    Active = False
    CommonAVI = aviFindComputer
    StopFrame = 8
    Visible = False
  end
  object TestCompany1CodeTxt: TEdit
    Left = 64
    Top = 180
    Width = 53
    Height = 21
    TabOrder = 4
    Text = 'ZZZZ01'
  end
  object CompanyPathTxt: TEdit
    Left = 64
    Top = 108
    Width = 305
    Height = 21
    TabOrder = 2
    Text = 'C:\EXCHEQR\'
  end
  object ImportExportZIPFileNameTxt: TEdit
    Left = 124
    Top = 252
    Width = 485
    Height = 21
    TabOrder = 8
    Text = 'C:\TEMP\TestData.zip'
  end
  object DatabaseTxt: TEdit
    Left = 248
    Top = 60
    Width = 121
    Height = 21
    TabOrder = 13
    Text = 'EXCHEQUER'
  end
  object TestCompany2CodeTxt: TEdit
    Left = 120
    Top = 180
    Width = 53
    Height = 21
    TabOrder = 14
    Text = 'ZZZZ02'
  end
  object Panel1: TPanel
    Left = 0
    Top = 693
    Width = 720
    Height = 41
    Align = alBottom
    BevelInner = bvLowered
    BorderWidth = 2
    TabOrder = 15
    object Label5: TLabel
      Left = 8
      Top = 14
      Width = 30
      Height = 13
      Caption = 'Select'
    end
    object SelectAllBtn: TButton
      Left = 48
      Top = 8
      Width = 75
      Height = 25
      Caption = '&All'
      TabOrder = 0
      OnClick = SelectAllBtnClick
    end
    object SelectNoneBtn: TButton
      Left = 128
      Top = 8
      Width = 75
      Height = 25
      Caption = '&None'
      TabOrder = 1
      OnClick = SelectNoneBtnClick
    end
  end
  object OpenDialog: TOpenDialog
    Left = 684
    Top = 244
  end
end
