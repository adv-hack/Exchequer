object vatSummaryForm: TvatSummaryForm
  Left = 259
  Top = 415
  HelpContext = 2225
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'VAT 100 Submission Status - VAT Period 2015-03'
  ClientHeight = 303
  ClientWidth = 615
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
  PixelsPerInch = 96
  TextHeight = 14
  object Label21: TLabel
    Left = 8
    Top = 24
    Width = 89
    Height = 14
    Caption = 'Submission Status'
  end
  object lblSubmissionStatus: TLabel
    Left = 120
    Top = 24
    Width = 36
    Height = 15
    Caption = 'STATUS'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial Narrow'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label23: TLabel
    Left = 8
    Top = 56
    Width = 96
    Height = 14
    Caption = 'HMRC Correlation ID'
  end
  object lblCorrelationID: TLabel
    Left = 120
    Top = 56
    Width = 200
    Height = 14
    Caption = '0123456789DEADBEEFCAFE9876543210'
  end
  object Label1: TLabel
    Left = 8
    Top = 40
    Width = 47
    Height = 14
    Caption = 'Submitted'
  end
  object lblSubmittedDate: TLabel
    Left = 120
    Top = 40
    Width = 121
    Height = 14
    Caption = 'DD/MM/YYYY HH:MM:SS'
  end
  object Label3: TLabel
    Left = 8
    Top = 8
    Width = 53
    Height = 14
    Caption = 'VAT Period'
  end
  object lblVatPeriod: TLabel
    Left = 120
    Top = 8
    Width = 51
    Height = 14
    Caption = 'YYYY-MM'
  end
  object btnClose: TButton
    Left = 520
    Top = 264
    Width = 80
    Height = 21
    Caption = 'Close'
    TabOrder = 0
    OnClick = btnCloseClick
  end
  object memoNarrative: TMemo
    Left = 8
    Top = 80
    Width = 489
    Height = 209
    TabStop = False
    BorderStyle = bsNone
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object btnViewReturn: TButton
    Left = 520
    Top = 32
    Width = 80
    Height = 21
    Caption = 'View Return'
    TabOrder = 2
    OnClick = btnViewReturnClick
  end
end
