object frmGuiTest: TfrmGuiTest
  Left = 172
  Top = 119
  Width = 789
  Height = 517
  Caption = 'frmGuiTest'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 392
    Width = 633
    Height = 25
    Alignment = taCenter
    AutoSize = False
    Caption = 'Label1'
  end
  object Label2: TLabel
    Left = 688
    Top = 80
    Width = 66
    Height = 13
    Caption = 'Sample Count'
  end
  object lblFP: TLabel
    Left = 664
    Top = 136
    Width = 23
    Height = 13
    Caption = 'lblFP'
  end
  object lblLP: TLabel
    Left = 664
    Top = 160
    Width = 23
    Height = 13
    Caption = 'lblLP'
  end
  object Label3: TLabel
    Left = 664
    Top = 272
    Width = 32
    Height = 13
    Caption = 'Label3'
  end
  object Button1: TButton
    Left = 664
    Top = 16
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 0
    OnClick = Button1Click
  end
  object ListBox1: TListBox
    Left = 8
    Top = 16
    Width = 641
    Height = 361
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier'
    Font.Style = []
    ItemHeight = 13
    ParentFont = False
    TabOrder = 1
  end
  object Edit1: TEdit
    Left = 8
    Top = 424
    Width = 641
    Height = 21
    TabOrder = 2
    Text = '(Blah[12] + Trunc(Eek[34])) * Woo[10]'
  end
  object Button2: TButton
    Left = 664
    Top = 416
    Width = 75
    Height = 25
    Caption = 'Button2'
    TabOrder = 3
    OnClick = Button2Click
  end
  object Edit2: TEdit
    Left = 8
    Top = 456
    Width = 641
    Height = 21
    TabOrder = 4
    Text = 'DateToNumber(DBF[SYSTODAY]) - DateToNumber(DBF[THDATE])'
  end
  object Button3: TButton
    Left = 664
    Top = 456
    Width = 75
    Height = 25
    Caption = 'Button3'
    TabOrder = 5
    OnClick = Button3Click
  end
  object edtSampleCount: TEdit
    Left = 688
    Top = 96
    Width = 57
    Height = 21
    TabOrder = 6
  end
  object chkTestMode: TCheckBox
    Left = 672
    Top = 48
    Width = 97
    Height = 17
    Caption = 'Test Mode'
    TabOrder = 7
  end
  object chkRefreshFirst: TCheckBox
    Left = 664
    Top = 184
    Width = 97
    Height = 17
    Caption = 'RefreshFirst'
    TabOrder = 8
  end
  object chkRefreshLast: TCheckBox
    Left = 664
    Top = 216
    Width = 97
    Height = 17
    Caption = 'RefreshLast'
    TabOrder = 9
  end
  object Button4: TButton
    Left = 672
    Top = 312
    Width = 75
    Height = 25
    Caption = 'Custom Parse'
    TabOrder = 10
    OnClick = Button4Click
  end
end
