object Form1: TForm1
  Left = 192
  Top = 116
  BorderStyle = bsDialog
  Caption = 'Compare Tables'
  ClientHeight = 765
  ClientWidth = 528
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label3: TLabel
    Left = 107
    Top = 8
    Width = 46
    Height = 13
    Caption = 'Database'
  end
  object Label4: TLabel
    Left = 259
    Top = 8
    Width = 44
    Height = 13
    Caption = 'Company'
  end
  object Label1: TLabel
    Left = 43
    Top = 28
    Width = 55
    Height = 13
    Alignment = taRightJustify
    Caption = 'Database 1'
  end
  object Label2: TLabel
    Left = 43
    Top = 56
    Width = 55
    Height = 13
    Alignment = taRightJustify
    Caption = 'Database 2'
  end
  object Label5: TLabel
    Left = 40
    Top = 616
    Width = 67
    Height = 13
    Caption = 'Results Folder'
  end
  object lblProgress: TLabel
    Left = 40
    Top = 672
    Width = 3
    Height = 13
  end
  object cbTestCo: TComboBox
    Left = 259
    Top = 24
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    Sorted = True
    TabOrder = 0
    OnChange = cbTestCoChange
  end
  object cbTestDb: TComboBox
    Left = 107
    Top = 24
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    Sorted = True
    TabOrder = 1
    OnChange = cbTestDbChange
  end
  object cbRefDb: TComboBox
    Left = 107
    Top = 53
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    Sorted = True
    TabOrder = 2
    OnChange = cbRefDbChange
  end
  object cbRefCo: TComboBox
    Left = 259
    Top = 53
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    Sorted = True
    TabOrder = 3
    Visible = False
  end
  object lbTables: TCheckListBox
    Left = 40
    Top = 80
    Width = 361
    Height = 529
    OnClickCheck = lbTablesClickCheck
    ItemHeight = 13
    TabOrder = 4
  end
  object Button1: TButton
    Left = 416
    Top = 88
    Width = 75
    Height = 25
    Caption = 'Go'
    TabOrder = 5
    OnClick = Button1Click
  end
  object edtResultsFolder: TEdit
    Left = 40
    Top = 632
    Width = 361
    Height = 21
    TabOrder = 6
    Text = 'C:\aaa\Results\'
  end
end
