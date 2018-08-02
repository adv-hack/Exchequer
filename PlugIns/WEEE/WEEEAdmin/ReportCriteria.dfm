object frmReportCriteria: TfrmReportCriteria
  Left = 506
  Top = 331
  BorderStyle = bsDialog
  Caption = 'Report Criteria'
  ClientHeight = 222
  ClientWidth = 217
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object Bevel1: TBevel
    Left = 8
    Top = 16
    Width = 201
    Height = 89
    Shape = bsFrame
  end
  object Label1: TLabel
    Left = 16
    Top = 8
    Width = 91
    Height = 14
    Caption = 'Period/Year Range'
  end
  object Label2: TLabel
    Left = 24
    Top = 36
    Width = 30
    Height = 14
    Caption = 'From :'
  end
  object Label3: TLabel
    Left = 24
    Top = 68
    Width = 18
    Height = 14
    Caption = 'To :'
  end
  object Bevel2: TBevel
    Left = 8
    Top = 120
    Width = 201
    Height = 65
    Shape = bsFrame
  end
  object lAccountType: TLabel
    Left = 16
    Top = 148
    Width = 74
    Height = 14
    Caption = 'Account Type :'
  end
  object btnCancel: TButton
    Left = 128
    Top = 192
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    OnClick = btnCancelClick
  end
  object btnRunReport: TButton
    Left = 40
    Top = 192
    Width = 80
    Height = 21
    Caption = '&Run Report'
    TabOrder = 4
    OnClick = btnRunReportClick
  end
  object cbFilterByAccType: TCheckBox
    Left = 16
    Top = 112
    Width = 185
    Height = 17
    Caption = 'Filter by Customer Account Type'
    TabOrder = 2
    OnClick = cbFilterByAccTypeClick
  end
  object edAccountType: TEdit
    Left = 96
    Top = 144
    Width = 97
    Height = 22
    MaxLength = 4
    TabOrder = 3
  end
  object edStartPY: TMaskEdit
    Left = 64
    Top = 32
    Width = 127
    Height = 22
    AutoSelect = False
    EditMask = '00/0000;0;'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 7
    ParentFont = False
    TabOrder = 0
    Text = '011996'
    OnExit = PYEdit
  end
  object edEndPY: TMaskEdit
    Left = 64
    Top = 64
    Width = 129
    Height = 22
    AutoSelect = False
    EditMask = '00/0000;0;'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 7
    ParentFont = False
    TabOrder = 1
    Text = '011996'
    OnExit = PYEdit
  end
  object EnterToTab1: TEnterToTab
    ConvertEnters = True
    OverrideFont = True
    Version = 'TEnterToTab v1.02 for Delphi 6.01'
    Left = 8
    Top = 192
  end
end
