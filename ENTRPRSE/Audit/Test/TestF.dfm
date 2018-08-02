object Form1: TForm1
  Left = 301
  Top = 258
  Width = 1137
  Height = 455
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel
    Left = 17
    Top = 22
    Width = 92
    Height = 14
    Caption = 'Company Directory'
  end
  object btnWriteAudit: TButton
    Left = 1038
    Top = 86
    Width = 75
    Height = 25
    Caption = 'Write Audit'
    TabOrder = 0
    OnClick = btnWriteAuditClick
  end
  object btnReadAudit: TButton
    Left = 1038
    Top = 56
    Width = 75
    Height = 25
    Caption = 'Read Audit'
    TabOrder = 1
    OnClick = btnReadAuditClick
  end
  object btnClear: TButton
    Left = 1034
    Top = 135
    Width = 75
    Height = 25
    Caption = 'Clear'
    TabOrder = 2
    OnClick = btnClearClick
  end
  object cmbCompanyDir: TComboBox
    Left = 117
    Top = 17
    Width = 906
    Height = 22
    ItemHeight = 14
    ItemIndex = 1
    TabOrder = 3
    Text = 'C:\Exchequer\Exch66.SQL\'
    Items.Strings = (
      'C:\Exchequer\Exch67.SQL\'
      'C:\Exchequer\Exch66.SQL\'
      'C:\Exchequer\Exch66.SQL\Companies\DEMO01\'
      'C:\Exchequer\Exch66.SQL\Companies\NANO01\'
      'C:\Exchequer\Exch66.SQL\Companies\NEWB01\'
      'C:\Exchequer\Exch66.SQL\Companies\NICK01\')
  end
  object btnFind: TButton
    Left = 1005
    Top = 244
    Width = 75
    Height = 25
    Caption = 'Find'
    TabOrder = 4
    OnClick = btnFindClick
  end
  object btnFindNext: TButton
    Left = 1007
    Top = 282
    Width = 75
    Height = 25
    Caption = 'Find Next'
    TabOrder = 5
    OnClick = btnFindNextClick
  end
  object Memo1: TMemo
    Left = 18
    Top = 51
    Width = 975
    Height = 351
    Lines.Strings = (
      'Memo1')
    ScrollBars = ssBoth
    TabOrder = 6
  end
  object FindDialog1: TFindDialog
    Options = [frDown, frHideMatchCase, frHideWholeWord, frHideUpDown, frMatchCase]
    OnFind = FindDialog1Find
    Left = 1031
    Top = 192
  end
end
