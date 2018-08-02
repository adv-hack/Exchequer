object PageSetupDlg: TPageSetupDlg
  Left = 335
  Top = 198
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Print'
  ClientHeight = 159
  ClientWidth = 392
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object SBSBackGroup1: TSBSBackGroup
    Left = 5
    Top = 6
    Width = 294
    Height = 97
    Caption = 'Page Range'
    TextId = 0
  end
  object Label81: Label8
    Left = 166
    Top = 74
    Width = 12
    Height = 14
    Caption = 'To'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object SBSBackGroup2: TSBSBackGroup
    Left = 5
    Top = 106
    Width = 294
    Height = 49
    Caption = 'Copies'
    TextId = 0
  end
  object Label82: Label8
    Left = 17
    Top = 125
    Width = 86
    Height = 14
    Caption = 'Number of Copies'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Btn_Print: TButton
    Left = 306
    Top = 7
    Width = 80
    Height = 21
    Caption = '&Print'
    Default = True
    TabOrder = 6
    OnClick = Btn_PrintClick
  end
  object Btn_Cancel: TButton
    Left = 306
    Top = 33
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    TabOrder = 7
    OnClick = Btn_CancelClick
  end
  object BorRadio1: TBorRadio
    Left = 14
    Top = 27
    Width = 98
    Height = 20
    Align = alRight
    Caption = 'All Pages'
    Checked = True
    TabOrder = 0
    TabStop = True
    TextId = 0
    OnClick = BorRadio1Click
  end
  object BorRadio2: TBorRadio
    Left = 14
    Top = 70
    Width = 96
    Height = 20
    Align = alRight
    Caption = 'Page Range'
    TabOrder = 1
    TextId = 0
    OnClick = BorRadio2Click
  end
  object BorRadio3: TBorRadio
    Left = 14
    Top = 49
    Width = 98
    Height = 20
    Align = alRight
    Caption = 'Current Page'
    TabOrder = 2
    TextId = 0
    OnClick = BorRadio3Click
  end
  object Ccy_FPage: TCurrencyEdit
    Left = 111
    Top = 70
    Width = 51
    Height = 25
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'ARIAL'
    Font.Style = []
    Lines.Strings = (
      '0 ')
    MaxLength = 6
    ParentFont = False
    TabOrder = 3
    WantReturns = False
    WordWrap = False
    AutoSize = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0 ;###,###,##0-'
    DecPlaces = 0
    ShowCurrency = False
    TextId = 0
    Value = 1E-10
  end
  object Ccy_LPage: TCurrencyEdit
    Left = 187
    Top = 71
    Width = 51
    Height = 25
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'ARIAL'
    Font.Style = []
    Lines.Strings = (
      '0 ')
    MaxLength = 6
    ParentFont = False
    TabOrder = 4
    WantReturns = False
    WordWrap = False
    AutoSize = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0 ;###,###,##0-'
    DecPlaces = 0
    ShowCurrency = False
    TextId = 0
    Value = 1E-10
  end
  object Ccy_Copies: TCurrencyEdit
    Left = 111
    Top = 121
    Width = 42
    Height = 25
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'ARIAL'
    Font.Style = []
    Lines.Strings = (
      '1 ')
    MaxLength = 4
    ParentFont = False
    TabOrder = 5
    WantReturns = False
    WordWrap = False
    AutoSize = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0 ;###,###,##0-'
    DecPlaces = 0
    ShowCurrency = False
    TextId = 0
    Value = 1
  end
end
