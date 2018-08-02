object frmAutoFill: TfrmAutoFill
  Left = 289
  Top = 211
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Auto Fill'
  ClientHeight = 205
  ClientWidth = 280
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel
    Left = 69
    Top = 36
    Width = 54
    Height = 14
    Alignment = taRightJustify
    Caption = 'Start Date :'
  end
  object Label2: TLabel
    Left = 16
    Top = 92
    Width = 107
    Height = 14
    Alignment = taRightJustify
    Caption = 'Periods repeat every :'
  end
  object Label3: TLabel
    Left = 74
    Top = 60
    Width = 49
    Height = 14
    Alignment = taRightJustify
    Caption = 'End Date :'
  end
  object Label4: TLabel
    Left = 63
    Top = 116
    Width = 60
    Height = 14
    Alignment = taRightJustify
    Caption = 'First Period :'
  end
  object Label5: TLabel
    Left = 48
    Top = 139
    Width = 75
    Height = 14
    Alignment = taRightJustify
    Caption = 'Financial Year :'
  end
  object Bevel1: TBevel
    Left = 8
    Top = 16
    Width = 265
    Height = 153
    Shape = bsFrame
  end
  object Label6: TLabel
    Left = 16
    Top = 8
    Width = 112
    Height = 14
    Caption = 'Auto Fill Parameters'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object cbxStartDate: TDateTimePicker
    Left = 128
    Top = 32
    Width = 137
    Height = 22
    CalAlignment = dtaLeft
    Date = 36587.6322425926
    Time = 36587.6322425926
    DateFormat = dfShort
    DateMode = dmComboBox
    Kind = dtkDate
    ParseInput = False
    TabOrder = 0
  end
  object btnOK: TButton
    Left = 104
    Top = 176
    Width = 80
    Height = 21
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 9
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 192
    Top = 176
    Width = 80
    Height = 21
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 10
  end
  object cbxPeriodType: TComboBox
    Left = 192
    Top = 89
    Width = 73
    Height = 22
    ItemHeight = 14
    TabOrder = 4
    Items.Strings = (
      'days'
      'weeks'
      'months'
      'periods')
  end
  object updPeriodLength: TUpDown
    Left = 169
    Top = 89
    Width = 14
    Height = 22
    Associate = edtPeriodLength
    Min = 0
    Position = 1
    TabOrder = 3
    Wrap = False
  end
  object edtPeriodLength: TMaskEdit
    Left = 128
    Top = 89
    Width = 41
    Height = 22
    TabOrder = 2
    Text = '1'
  end
  object cbxEndDate: TDateTimePicker
    Left = 128
    Top = 56
    Width = 137
    Height = 22
    CalAlignment = dtaLeft
    Date = 36587.6322425926
    Time = 36587.6322425926
    DateFormat = dfShort
    DateMode = dmComboBox
    Kind = dtkDate
    ParseInput = False
    TabOrder = 1
  end
  object edtPeriodStart: TMaskEdit
    Left = 128
    Top = 113
    Width = 41
    Height = 22
    EditMask = '09;0; '
    MaxLength = 2
    TabOrder = 5
    Text = '1'
  end
  object updPeriod: TUpDown
    Left = 169
    Top = 113
    Width = 14
    Height = 22
    Associate = edtPeriodStart
    Min = 1
    Max = 99
    Position = 1
    TabOrder = 6
    Wrap = False
  end
  object edtYear: TMaskEdit
    Left = 128
    Top = 136
    Width = 41
    Height = 22
    EditMask = '!9999;0; '
    MaxLength = 4
    TabOrder = 7
    Text = '1999'
  end
  object updYear: TUpDown
    Left = 169
    Top = 136
    Width = 14
    Height = 22
    Associate = edtYear
    Min = 1980
    Max = 2100
    Position = 1999
    TabOrder = 8
    Thousands = False
    Wrap = False
  end
end
