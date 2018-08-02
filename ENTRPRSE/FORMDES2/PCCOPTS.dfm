object Form_PCCOpts: TForm_PCCOpts
  Left = 244
  Top = 187
  BorderStyle = bsSingle
  Caption = 'Print PCC Form'
  ClientHeight = 247
  ClientWidth = 210
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = True
  Position = poDefault
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 11
    Top = 59
    Width = 54
    Height = 13
    Caption = 'Form Name'
  end
  object Label2: TLabel
    Left = 33
    Top = 87
    Width = 32
    Height = 13
    Caption = 'Copies'
  end
  object Label3: TLabel
    Left = 25
    Top = 111
    Width = 40
    Height = 13
    Caption = 'Invoices'
  end
  object Label4: TLabel
    Left = 44
    Top = 8
    Width = 20
    Height = 13
    Caption = 'Title'
  end
  object Label5: TLabel
    Left = 10
    Top = 34
    Width = 50
    Height = 13
    Caption = 'Form Type'
  end
  object Label6: TLabel
    Left = 25
    Top = 136
    Width = 32
    Height = 13
    Caption = 'Label1'
  end
  object Button1: TButton
    Left = 125
    Top = 192
    Width = 80
    Height = 21
    Caption = '&Print'
    TabOrder = 9
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 125
    Top = 217
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    TabOrder = 10
    OnClick = Button2Click
  end
  object Edit2: TEdit
    Left = 67
    Top = 83
    Width = 32
    Height = 21
    TabOrder = 2
    Text = '1'
  end
  object UpDown1: TUpDown
    Left = 99
    Top = 83
    Width = 12
    Height = 21
    Associate = Edit2
    Min = 1
    Position = 1
    TabOrder = 3
    Wrap = False
  end
  object Edit3: TEdit
    Left = 67
    Top = 110
    Width = 32
    Height = 21
    TabOrder = 4
    Text = '1'
  end
  object UpDown2: TUpDown
    Left = 99
    Top = 110
    Width = 12
    Height = 21
    Associate = Edit3
    Min = 1
    Position = 1
    TabOrder = 5
    Wrap = False
  end
  object CheckBox1: TCheckBox
    Left = 24
    Top = 164
    Width = 56
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Preview'
    Checked = True
    State = cbChecked
    TabOrder = 6
  end
  object CheckBox2: TCheckBox
    Left = 11
    Top = 184
    Width = 69
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Test Mode'
    TabOrder = 7
  end
  object Edit4: TEdit
    Left = 66
    Top = 5
    Width = 138
    Height = 21
    TabOrder = 0
    Text = 'PCC Test Form'
  end
  object CheckBox3: TCheckBox
    Left = 30
    Top = 205
    Width = 50
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Labels'
    TabOrder = 8
  end
  object Edit1: TComboBox
    Left = 67
    Top = 55
    Width = 138
    Height = 21
    ItemHeight = 13
    TabOrder = 1
    Text = 'INVOICE'
    Items.Strings = (
      'ACCLABL'
      'CHEQUE'
      'INVOICE'
      'SIN_SBS'
      'SIN_SER'
      'STAT_SBS'
      'STOCKADJ'
      'XTRADHST'
      'DELB_SBS'
      'XCOLLECT')
  end
  object ComboBox1: TComboBox
    Left = 66
    Top = 31
    Width = 138
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 11
    Items.Strings = (
      'Customer Statement'
      'Customer Trading History'
      'Invoice'
      'Stock Adjustment'
      'Job Backing Sheet + SIN'
      'Delivery Labels'
      'Sales Order')
  end
  object CheckBox4: TCheckBox
    Left = 20
    Top = 223
    Width = 60
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Cheques'
    TabOrder = 12
  end
  object Edit5: TEdit
    Left = 67
    Top = 135
    Width = 32
    Height = 21
    TabOrder = 13
    Text = '1'
  end
  object UpDown3: TUpDown
    Left = 99
    Top = 135
    Width = 12
    Height = 21
    Associate = Edit5
    Min = 1
    Position = 1
    TabOrder = 14
    Wrap = False
  end
end
