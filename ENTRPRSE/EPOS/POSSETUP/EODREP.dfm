object frmEODReport: TfrmEODReport
  Left = 391
  Top = 237
  HelpContext = 4
  BorderStyle = bsDialog
  Caption = 'End Of Day Report Parameters'
  ClientHeight = 292
  ClientWidth = 335
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 14
  object Bevel4: TBevel
    Left = 8
    Top = 120
    Width = 153
    Height = 129
    Shape = bsFrame
  end
  object Bevel2: TBevel
    Left = 8
    Top = 16
    Width = 321
    Height = 89
    Shape = bsFrame
  end
  object Label1: TLabel
    Left = 30
    Top = 39
    Width = 29
    Height = 14
    Alignment = taRightJustify
    Caption = 'Start :'
  end
  object Label2: TLabel
    Left = 35
    Top = 71
    Width = 24
    Height = 14
    Alignment = taRightJustify
    Caption = 'End :'
  end
  object Label5: TLabel
    Left = 16
    Top = 8
    Width = 104
    Height = 14
    Caption = ' Date / Time Range '
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Bevel5: TBevel
    Left = 168
    Top = 120
    Width = 161
    Height = 129
    Shape = bsFrame
  end
  object Label6: TLabel
    Left = 176
    Top = 112
    Width = 107
    Height = 14
    Caption = ' Additional Options '
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 16
    Top = 112
    Width = 98
    Height = 14
    Caption = ' Tills to report on '
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lstTills: TCheckListBox
    Left = 16
    Top = 128
    Width = 137
    Height = 93
    ItemHeight = 14
    TabOrder = 4
  end
  object btnAll: TButton
    Left = 16
    Top = 220
    Width = 137
    Height = 21
    Caption = '&Select All'
    TabOrder = 5
    OnClick = btnAllClick
  end
  object edStartDate: TDateTimePicker
    Left = 72
    Top = 35
    Width = 105
    Height = 22
    CalAlignment = dtaLeft
    Date = 36922.690187037
    Time = 36922.690187037
    DateFormat = dfShort
    DateMode = dmComboBox
    Kind = dtkDate
    ParseInput = False
    TabOrder = 0
  end
  object edEndDate: TDateTimePicker
    Left = 72
    Top = 67
    Width = 105
    Height = 22
    CalAlignment = dtaLeft
    Date = 36922.690187037
    Time = 36922.690187037
    DateFormat = dfShort
    DateMode = dmComboBox
    Kind = dtkDate
    ParseInput = False
    TabOrder = 2
  end
  object btnOK: TButton
    Left = 160
    Top = 264
    Width = 80
    Height = 21
    Caption = '&OK'
    TabOrder = 9
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 248
    Top = 264
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 10
  end
  object cbShowMargin: TCheckBox
    Left = 184
    Top = 144
    Width = 137
    Height = 17
    Caption = 'Show Margins'
    Checked = True
    State = cbChecked
    TabOrder = 6
  end
  object cbSummary: TCheckBox
    Left = 184
    Top = 176
    Width = 137
    Height = 17
    Caption = 'Summary Report'
    TabOrder = 7
    OnClick = cbSummaryClick
  end
  object cbConsolidate: TCheckBox
    Left = 184
    Top = 208
    Width = 137
    Height = 17
    Caption = 'Consolidate Stock Lines'
    Checked = True
    State = cbChecked
    TabOrder = 8
  end
  object edStartTime: TDateTimePicker
    Left = 200
    Top = 35
    Width = 105
    Height = 22
    CalAlignment = dtaLeft
    Date = 36922.3333333333
    Time = 36922.3333333333
    DateFormat = dfShort
    DateMode = dmComboBox
    Kind = dtkTime
    ParseInput = False
    TabOrder = 1
  end
  object edEndTime: TDateTimePicker
    Left = 200
    Top = 67
    Width = 105
    Height = 22
    CalAlignment = dtaLeft
    Date = 36922.75
    Time = 36922.75
    DateFormat = dfShort
    DateMode = dmComboBox
    Kind = dtkTime
    ParseInput = False
    TabOrder = 3
  end
  object TheReport: TReportFiler
    StatusFormat = 'Printing page %p'
    Units = unMM
    UnitsFactor = 25.4
    Title = 'EOD Report'
    Orientation = poPortrait
    ScaleX = 100
    ScaleY = 100
    OnPrint = TheReportPrint
    OnBeforePrint = TheReportBeforePrint
    OnNewPage = TheReportNewPage
    Left = 24
    Top = 136
  end
end
