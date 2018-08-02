object ECSalesCriteriaDlg: TECSalesCriteriaDlg
  Left = 442
  Top = 183
  ActiveControl = ReportByQuarterChk
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = ' - EC Sales List Export'
  ClientHeight = 315
  ClientWidth = 397
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Position = poDefault
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object SBSBackGroup1: TSBSBackGroup
    Left = 5
    Top = 4
    Width = 386
    Height = 125
    HelpContext = 8053
    Caption = 'Reporting Period'
    TextId = 0
  end
  object ReportContentGrp: TSBSBackGroup
    Left = 5
    Top = 134
    Width = 386
    Height = 89
    HelpContext = 8054
    Caption = 'Report Content'
    TextId = 0
  end
  object ExportGrp: TSBSBackGroup
    Left = 5
    Top = 227
    Width = 386
    Height = 54
    HelpContext = 8057
    Caption = 'Export File'
    TextId = 0
  end
  object Label81: Label8
    Left = 276
    Top = 102
    Width = 9
    Height = 14
    Caption = 'to'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object ReportContentLbl: TLabel
    Left = 16
    Top = 153
    Width = 228
    Height = 14
    Caption = 'Please specify the data you want to report on:-'
  end
  object Label2: TLabel
    Left = 16
    Top = 23
    Width = 237
    Height = 14
    Caption = 'Please specify the period you want to report by:-'
    OnDblClick = Label2DblClick
  end
  object ExportLbl: TLabel
    Left = 16
    Top = 252
    Width = 54
    Height = 14
    Caption = 'Save file to'
  end
  object ReportByMonthChk: TRadioButton
    Left = 34
    Top = 47
    Width = 113
    Height = 17
    HelpContext = 8053
    Caption = 'Report by Month'
    TabOrder = 0
    OnClick = EnableControls
  end
  object ReportByQuarterChk: TRadioButton
    Left = 34
    Top = 75
    Width = 159
    Height = 17
    HelpContext = 8053
    Caption = 'Report by Calendar Quarter'
    Checked = True
    TabOrder = 4
    TabStop = True
    OnClick = EnableControls
  end
  object ReportByRangeChk: TRadioButton
    Left = 34
    Top = 101
    Width = 135
    Height = 17
    HelpContext = 8053
    Caption = 'Report by Date Range'
    TabOrder = 8
    OnClick = EnableControls
  end
  object StartDateEdt: TEditDate
    Left = 197
    Top = 99
    Width = 73
    Height = 22
    HelpContext = 8053
    AutoSelect = False
    Color = clBtnFace
    EditMask = '00/00/0000;0;'
    Font.Charset = ANSI_CHARSET
    Font.Color = clGrayText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 10
    ParentFont = False
    TabOrder = 9
    Text = '01012009'
    Placement = cpAbove
  end
  object EndDateEdt: TEditDate
    Left = 291
    Top = 99
    Width = 72
    Height = 22
    HelpContext = 8053
    AutoSelect = False
    Color = clBtnFace
    EditMask = '00/00/0000;0;'
    Font.Charset = ANSI_CHARSET
    Font.Color = clGrayText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 10
    ParentFont = False
    TabOrder = 10
    Text = '31032009'
    Placement = cpAbove
  end
  object MonthCmb: TComboBox
    Left = 197
    Top = 44
    Width = 85
    Height = 22
    HelpContext = 8053
    Style = csDropDownList
    Color = clBtnFace
    Font.Charset = ANSI_CHARSET
    Font.Color = clGrayText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 14
    ItemIndex = 0
    ParentFont = False
    TabOrder = 1
    Text = 'January'
    OnExit = MonthCmbExit
    Items.Strings = (
      'January'
      'February'
      'March'
      'April'
      'May'
      'June'
      'July'
      'August'
      'September'
      'October'
      'November'
      'December')
  end
  object MonthYearEdt: TEdit
    Left = 284
    Top = 44
    Width = 34
    Height = 22
    HelpContext = 8053
    Color = clBtnFace
    Font.Charset = ANSI_CHARSET
    Font.Color = clGrayText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    Text = '2009'
    OnExit = MonthYearEdtExit
  end
  object MonthYearSpin: TUpDown
    Left = 318
    Top = 44
    Width = 17
    Height = 22
    HelpContext = 8053
    Associate = MonthYearEdt
    Min = 1990
    Max = 2200
    Position = 2009
    TabOrder = 3
    Thousands = False
    Wrap = False
  end
  object QuarterCmb: TComboBox
    Left = 197
    Top = 72
    Width = 133
    Height = 22
    HelpContext = 8053
    Style = csDropDownList
    Color = clWhite
    Font.Charset = ANSI_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 14
    ItemIndex = 0
    ParentFont = False
    TabOrder = 5
    Text = 'Quarter 1 (Jan-Mar)'
    OnExit = QuarterCmbExit
    Items.Strings = (
      'Quarter 1 (Jan-Mar)'
      'Quarter 2 (Apr-Jun)'
      'Quarter 3 (Jul-Sep)'
      'Quarter 4 (Oct-Dec)')
  end
  object QuarterYearEdt: TEdit
    Left = 332
    Top = 72
    Width = 34
    Height = 22
    HelpContext = 8053
    Color = clWhite
    Font.Charset = ANSI_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 6
    Text = '2009'
    OnExit = QuarterYearEdtExit
  end
  object QuarterYearSpin: TUpDown
    Left = 366
    Top = 72
    Width = 17
    Height = 22
    HelpContext = 8053
    Associate = QuarterYearEdt
    Min = 1990
    Max = 2200
    Position = 2009
    TabOrder = 7
    Thousands = False
    Wrap = False
  end
  object ReportOnGoodsChk: TCheckBox
    Left = 34
    Top = 175
    Width = 97
    Height = 17
    HelpContext = 8054
    Caption = 'Goods'
    TabOrder = 11
    OnClick = EnableControls
  end
  object ReportOnServicesChk: TCheckBox
    Left = 34
    Top = 198
    Width = 97
    Height = 17
    HelpContext = 8054
    Caption = 'Services'
    TabOrder = 12
    OnClick = EnableControls
  end
  object CheckGoodsBtn: TButton
    Left = 8
    Top = 289
    Width = 80
    Height = 21
    HelpContext = 8055
    Caption = 'Check Goods'
    TabOrder = 15
    OnClick = CheckGoodsBtnClick
  end
  object CancelBtn: TButton
    Left = 310
    Top = 289
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    TabOrder = 17
    OnClick = CancelBtnClick
  end
  object OkBtn: TButton
    Left = 220
    Top = 289
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&OK'
    TabOrder = 16
    OnClick = OkBtnClick
  end
  object FilenameEdt: TEdit
    Left = 75
    Top = 249
    Width = 283
    Height = 22
    HelpContext = 8057
    Color = clWhite
    Font.Charset = ANSI_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 13
    Text = 'X:\Exchqr\ECSales\Q12009.csv'
    OnChange = EnableControls
    OnExit = FilenameEdtExit
  end
  object SelectFilenameBtn: TButton
    Left = 360
    Top = 249
    Width = 21
    Height = 21
    HelpContext = 8057
    Caption = '...'
    TabOrder = 14
    OnClick = SelectFilenameBtnClick
  end
  object SaveDialog: TSaveDialog
    DefaultExt = 'csv'
    Filter = 'CSV files|*.csv|All files|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 96
    Top = 284
  end
end
