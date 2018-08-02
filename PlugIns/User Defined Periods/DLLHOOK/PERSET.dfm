object frmPeriodSet: TfrmPeriodSet
  Left = 259
  Top = 181
  HelpContext = 10116
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Edit Period Details'
  ClientHeight = 283
  ClientWidth = 230
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  Scaled = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object bvDate: TBevel
    Left = 8
    Top = 72
    Width = 217
    Height = 178
    Shape = bsFrame
  end
  object bvFields: TBevel
    Left = 8
    Top = 8
    Width = 217
    Height = 66
    Shape = bsFrame
  end
  object pnlFields: TPanel
    Left = 16
    Top = 16
    Width = 169
    Height = 49
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
    object updPeriod: TUpDown
      Left = 137
      Top = 0
      Width = 16
      Height = 22
      HelpContext = 10111
      Associate = edtPeriod
      Min = 1
      Max = 99
      Position = 1
      TabOrder = 0
      Wrap = False
    end
    object updYear: TUpDown
      Left = 137
      Top = 27
      Width = 15
      Height = 22
      HelpContext = 10112
      Associate = edtYear
      Min = 1980
      Max = 2100
      Position = 1980
      TabOrder = 1
      Thousands = False
      Wrap = False
    end
    object edtYear: TMaskEdit
      Left = 96
      Top = 27
      Width = 41
      Height = 22
      HelpContext = 10112
      EditMask = '!9999;0; '
      MaxLength = 4
      TabOrder = 2
      Text = '1980'
      OnExit = edtYearExit
    end
    object edtPeriod: TEdit
      Left = 96
      Top = 0
      Width = 41
      Height = 22
      HelpContext = 10111
      MaxLength = 2
      TabOrder = 3
      Text = '1'
      OnExit = edtPeriodExit
    end
  end
  object panDate: TPanel
    Left = 10
    Top = 80
    Width = 213
    Height = 161
    BevelOuter = bvNone
    TabOrder = 1
    object lblCalendar: TLabel
      Left = 8
      Top = 0
      Width = 85
      Height = 14
      Caption = 'Period start date :'
    end
    object calPeriodDate: TMonthCalendar
      Left = 0
      Top = 16
      Width = 209
      Height = 145
      HelpContext = 10113
      Date = 36587.6295125347
      MaxDate = 73415
      MinDate = 29221
      ShowToday = False
      ShowTodayCircle = False
      TabOrder = 0
    end
  end
  object panButtons: TPanel
    Left = 40
    Top = 256
    Width = 185
    Height = 25
    BevelOuter = bvNone
    TabOrder = 2
    object btnOK: TButton
      Left = 16
      Top = 0
      Width = 80
      Height = 21
      HelpContext = 10114
      Caption = '&OK'
      ModalResult = 1
      TabOrder = 0
      OnClick = btnOKClick
    end
    object btnCancel: TButton
      Left = 104
      Top = 0
      Width = 80
      Height = 21
      HelpContext = 10115
      Cancel = True
      Caption = '&Cancel'
      ModalResult = 2
      TabOrder = 1
    end
  end
end
