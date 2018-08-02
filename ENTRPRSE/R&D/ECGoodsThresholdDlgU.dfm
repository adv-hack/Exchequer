object ECGoodsThresholdDlg: TECGoodsThresholdDlg
  Left = 348
  Top = 114
  HelpContext = 8055
  BorderStyle = bsDialog
  Caption = 'Goods Threshold Confirmation'
  ClientHeight = 389
  ClientWidth = 410
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 14
  object Bevel1: TBevel
    Left = 6
    Top = 4
    Width = 399
    Height = 349
    Shape = bsFrame
  end
  object CurrentThresholdLbl: TLabel
    Left = 56
    Top = 94
    Width = 87
    Height = 14
    Caption = 'Current Threshold'
  end
  object QtrNowLbl: TLabel
    Left = 96
    Top = 185
    Width = 50
    Height = 14
    AutoSize = False
  end
  object Qtr1Lbl: TLabel
    Left = 96
    Top = 213
    Width = 50
    Height = 14
    AutoSize = False
  end
  object Qtr2Lbl: TLabel
    Left = 96
    Top = 241
    Width = 50
    Height = 14
    AutoSize = False
  end
  object Qtr3Lbl: TLabel
    Left = 96
    Top = 269
    Width = 50
    Height = 14
    AutoSize = False
  end
  object Qtr4Lbl: TLabel
    Left = 96
    Top = 297
    Width = 50
    Height = 14
    AutoSize = False
  end
  object Label9: TLabel
    Left = 12
    Top = 160
    Width = 282
    Height = 14
    Caption = 'The EC Sales Goods values for the following quarters are:'
  end
  object InformationLbl: TLabel
    Left = 80
    Top = 328
    Width = 254
    Height = 14
    Caption = 'This information is provided for guidance only'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label1: TLabel
    Left = 12
    Top = 16
    Width = 385
    Height = 45
    AutoSize = False
    Caption = 
      #8216'Check Goods'#8217' calculates the EC Sales Goods value for this quart' +
      'er and for the previous four quarters. If the value returned for' +
      ' any one quarter exceeds the '#8216'Current Threshold'#8217', the HMRC will ' +
      'require you to submit monthly returns.'
    WordWrap = True
  end
  object Label2: TLabel
    Left = 12
    Top = 68
    Width = 385
    Height = 17
    AutoSize = False
    Caption = 'The EC Sales Threshold is set as:'
    WordWrap = True
  end
  object Label3: TLabel
    Left = 12
    Top = 120
    Width = 385
    Height = 29
    AutoSize = False
    Caption = 
      'Please check that this is the correct current HMRC Threshold. If' +
      ' the Threshold is incorrect, the value can be changed in Exchequ' +
      'er within System Settings.'
    WordWrap = True
  end
  object QtrNowStatusLbl: TStaticText
    Left = 228
    Top = 185
    Width = 87
    Height = 18
    Caption = 'Over threshold'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 7
    Visible = False
  end
  object OkBtn: TButton
    Left = 160
    Top = 360
    Width = 80
    Height = 21
    Cancel = True
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object CurrentThresholdTxt: TCurrencyEdit
    Left = 152
    Top = 90
    Width = 73
    Height = 22
    Color = clBtnFace
    Ctl3D = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'ARIAL'
    Font.Style = []
    Lines.Strings = (
      '0 ')
    ParentCtl3D = False
    ParentFont = False
    ReadOnly = True
    TabOrder = 1
    WantReturns = False
    WordWrap = False
    AutoSize = False
    BlockNegative = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0 ;###,###,##0-'
    DecPlaces = 0
    ShowCurrency = False
    TextId = 0
    Value = 1E-10
  end
  object QtrNowEdt: TCurrencyEdit
    Left = 152
    Top = 183
    Width = 73
    Height = 22
    Color = clBtnFace
    Ctl3D = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'ARIAL'
    Font.Style = []
    Lines.Strings = (
      '0 ')
    ParentCtl3D = False
    ParentFont = False
    ReadOnly = True
    TabOrder = 2
    WantReturns = False
    WordWrap = False
    AutoSize = False
    BlockNegative = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0 ;###,###,##0-'
    DecPlaces = 0
    ShowCurrency = False
    TextId = 0
    Value = 1E-10
  end
  object Qtr1Edt: TCurrencyEdit
    Left = 152
    Top = 211
    Width = 73
    Height = 22
    Color = clBtnFace
    Ctl3D = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'ARIAL'
    Font.Style = []
    Lines.Strings = (
      '0 ')
    ParentCtl3D = False
    ParentFont = False
    ReadOnly = True
    TabOrder = 3
    WantReturns = False
    WordWrap = False
    AutoSize = False
    BlockNegative = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0 ;###,###,##0-'
    DecPlaces = 0
    ShowCurrency = False
    TextId = 0
    Value = 1E-10
  end
  object Qtr2Edt: TCurrencyEdit
    Left = 152
    Top = 239
    Width = 73
    Height = 22
    Color = clBtnFace
    Ctl3D = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'ARIAL'
    Font.Style = []
    Lines.Strings = (
      '0 ')
    ParentCtl3D = False
    ParentFont = False
    ReadOnly = True
    TabOrder = 4
    WantReturns = False
    WordWrap = False
    AutoSize = False
    BlockNegative = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0 ;###,###,##0-'
    DecPlaces = 0
    ShowCurrency = False
    TextId = 0
    Value = 1E-10
  end
  object Qtr3Edt: TCurrencyEdit
    Left = 152
    Top = 267
    Width = 73
    Height = 22
    Color = clBtnFace
    Ctl3D = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'ARIAL'
    Font.Style = []
    Lines.Strings = (
      '0 ')
    ParentCtl3D = False
    ParentFont = False
    ReadOnly = True
    TabOrder = 5
    WantReturns = False
    WordWrap = False
    AutoSize = False
    BlockNegative = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0 ;###,###,##0-'
    DecPlaces = 0
    ShowCurrency = False
    TextId = 0
    Value = 1E-10
  end
  object Qtr4Edt: TCurrencyEdit
    Left = 152
    Top = 295
    Width = 73
    Height = 22
    Color = clBtnFace
    Ctl3D = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'ARIAL'
    Font.Style = []
    Lines.Strings = (
      '0 ')
    ParentCtl3D = False
    ParentFont = False
    ReadOnly = True
    TabOrder = 6
    WantReturns = False
    WordWrap = False
    AutoSize = False
    BlockNegative = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0 ;###,###,##0-'
    DecPlaces = 0
    ShowCurrency = False
    TextId = 0
    Value = 1E-10
  end
  object Qtr1StatusLbl: TStaticText
    Left = 228
    Top = 213
    Width = 87
    Height = 18
    Caption = 'Over threshold'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 8
    Visible = False
  end
  object Qtr2StatusLbl: TStaticText
    Left = 228
    Top = 241
    Width = 87
    Height = 18
    Caption = 'Over threshold'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 9
    Visible = False
  end
  object Qtr3StatusLbl: TStaticText
    Left = 228
    Top = 269
    Width = 87
    Height = 18
    Caption = 'Over threshold'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 10
    Visible = False
  end
  object Qtr4StatusLbl: TStaticText
    Left = 228
    Top = 297
    Width = 87
    Height = 18
    Caption = 'Over threshold'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 11
    Visible = False
  end
  object Timer: TTimer
    Enabled = False
    Interval = 250
    OnTimer = TimerTimer
    Left = 20
    Top = 276
  end
end
