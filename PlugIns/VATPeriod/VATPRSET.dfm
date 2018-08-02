object frmVatPerSet: TfrmVatPerSet
  Left = 331
  Top = 204
  BorderStyle = bsDialog
  Caption = 'Set VAT Period'
  ClientHeight = 156
  ClientWidth = 272
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 257
    Height = 113
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    object Label3: TLabel
      Left = 8
      Top = 56
      Width = 48
      Height = 13
      Caption = 'Start Date'
    end
    object Label1: TLabel
      Left = 8
      Top = 8
      Width = 30
      Height = 13
      Caption = 'Period'
    end
    object Label4: TLabel
      Left = 136
      Top = 8
      Width = 22
      Height = 13
      Caption = 'Year'
    end
    object Label2: TLabel
      Left = 136
      Top = 56
      Width = 45
      Height = 13
      Caption = 'End Date'
    end
    object cbPeriod: TComboBox
      Left = 8
      Top = 24
      Width = 81
      Height = 21
      Enabled = False
      ItemHeight = 13
      TabOrder = 0
    end
    object cbYear: TComboBox
      Left = 136
      Top = 24
      Width = 89
      Height = 21
      Enabled = False
      ItemHeight = 13
      TabOrder = 1
    end
    object dtpStartDate: TDateTimePicker
      Left = 8
      Top = 72
      Width = 105
      Height = 21
      CalAlignment = dtaLeft
      Date = 37792.5186206829
      Time = 37792.5186206829
      DateFormat = dfShort
      DateMode = dmComboBox
      Kind = dtkDate
      ParseInput = False
      TabOrder = 2
      OnDropDown = dtpStartDateDropDown
    end
    object dtpEndDate: TDateTimePicker
      Left = 136
      Top = 72
      Width = 105
      Height = 21
      CalAlignment = dtaLeft
      Date = 37792.519029375
      Time = 37792.519029375
      DateFormat = dfShort
      DateMode = dmComboBox
      Kind = dtkDate
      ParseInput = False
      TabOrder = 3
      OnDropDown = dtpStartDateDropDown
    end
  end
  object btnOK: TButton
    Left = 96
    Top = 128
    Width = 80
    Height = 21
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 1
    OnClick = btnOKClick
  end
  object Button2: TButton
    Left = 184
    Top = 128
    Width = 80
    Height = 21
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
    OnClick = Button2Click
  end
end
