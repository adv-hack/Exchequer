object frmPeriodSet: TfrmPeriodSet
  Left = 489
  Top = 200
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Edit Period Details'
  ClientHeight = 281
  ClientWidth = 206
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object pnlFields: TPanel
    Left = 8
    Top = 8
    Width = 193
    Height = 57
    BevelOuter = bvNone
    TabOrder = 0
    object Label1: TLabel
      Left = 40
      Top = 4
      Width = 52
      Height = 14
      Alignment = taRightJustify
      Caption = 'Period No :'
    end
    object Label2: TLabel
      Left = 17
      Top = 31
      Width = 75
      Height = 14
      Alignment = taRightJustify
      Caption = 'Financial Year :'
    end
    object edtPeriod: TMaskEdit
      Left = 96
      Top = 0
      Width = 41
      Height = 22
      EditMask = '09;0; '
      MaxLength = 2
      TabOrder = 0
      Text = '1'
      OnExit = edtPeriodExit
    end
    object updPeriod: TUpDown
      Left = 137
      Top = 0
      Width = 15
      Height = 22
      Associate = edtPeriod
      Min = 1
      Max = 99
      Position = 1
      TabOrder = 1
      Wrap = False
    end
    object updYear: TUpDown
      Left = 137
      Top = 27
      Width = 15
      Height = 22
      Associate = edtYear
      Min = 1980
      Max = 2100
      Position = 1980
      TabOrder = 2
      Thousands = False
      Wrap = False
    end
    object edtYear: TMaskEdit
      Left = 96
      Top = 27
      Width = 41
      Height = 22
      EditMask = '!9999;0; '
      MaxLength = 4
      TabOrder = 3
      Text = '1980'
      OnExit = edtYearExit
    end
  end
  object panDate: TPanel
    Left = 7
    Top = 72
    Width = 194
    Height = 169
    BevelOuter = bvNone
    TabOrder = 1
    object lblCalendar: TLabel
      Left = 0
      Top = 0
      Width = 85
      Height = 14
      Caption = 'Period start date :'
    end
    object calPeriodDate: TMonthCalendar
      Left = 0
      Top = 16
      Width = 190
      Height = 145
      AutoSize = True
      Date = 36587
      MaxDate = 73415
      MinDate = 29221
      ShowToday = False
      ShowTodayCircle = False
      TabOrder = 0
    end
  end
  object panButtons: TPanel
    Left = 8
    Top = 240
    Width = 193
    Height = 41
    BevelOuter = bvNone
    TabOrder = 2
    object btnOK: TButton
      Left = 36
      Top = 8
      Width = 73
      Height = 25
      Caption = '&OK'
      ModalResult = 1
      TabOrder = 0
      OnClick = btnOKClick
    end
    object btnCancel: TButton
      Left = 116
      Top = 8
      Width = 73
      Height = 25
      Cancel = True
      Caption = '&Cancel'
      ModalResult = 2
      TabOrder = 1
    end
  end
end
