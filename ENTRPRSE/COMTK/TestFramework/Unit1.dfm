object Form1: TForm1
  Left = 279
  Top = 191
  Width = 506
  Height = 640
  Caption = 'Form1'
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
    Left = 46
    Top = 44
    Width = 58
    Height = 13
    Alignment = taRightJustify
    Caption = 'Test System'
  end
  object Label2: TLabel
    Left = 17
    Top = 71
    Width = 87
    Height = 13
    Alignment = taRightJustify
    Caption = 'Reference System'
  end
  object Label3: TLabel
    Left = 112
    Top = 24
    Width = 46
    Height = 13
    Caption = 'Database'
  end
  object Label4: TLabel
    Left = 264
    Top = 24
    Width = 44
    Height = 13
    Caption = 'Company'
  end
  object Label5: TLabel
    Left = 28
    Top = 100
    Width = 77
    Height = 13
    Alignment = taRightJustify
    Caption = 'Folder for results'
  end
  object lblProgress: TLabel
    Left = 112
    Top = 576
    Width = 51
    Height = 13
    Caption = 'lblProgress'
  end
  object Button2: TButton
    Left = 416
    Top = 128
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 0
    OnClick = Button2Click
  end
  object cbTestDb: TComboBox
    Left = 112
    Top = 40
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 1
    OnChange = cbTestDbChange
  end
  object cbTestCo: TComboBox
    Left = 264
    Top = 40
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 2
  end
  object cbRefDb: TComboBox
    Left = 112
    Top = 69
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 3
    OnChange = cbRefDbChange
  end
  object cbRefCo: TComboBox
    Left = 264
    Top = 69
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 4
  end
  object ListBox1: TListBox
    Left = 112
    Top = 128
    Width = 297
    Height = 433
    ItemHeight = 13
    TabOrder = 5
  end
  object Button1: TButton
    Left = 416
    Top = 160
    Width = 75
    Height = 25
    Caption = 'Go'
    TabOrder = 6
    OnClick = Button1Click
  end
  object edtResultsFolder: TEdit
    Left = 112
    Top = 98
    Width = 121
    Height = 21
    TabOrder = 7
    Text = 'C:\TestResults\'
  end
end
