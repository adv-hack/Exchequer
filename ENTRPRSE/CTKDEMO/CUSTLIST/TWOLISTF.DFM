object Form1: TForm1
  Left = 201
  Top = 138
  Width = 614
  Height = 402
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lstCust: TListBox
    Left = 10
    Top = 7
    Width = 202
    Height = 359
    ItemHeight = 13
    TabOrder = 0
    OnDblClick = lstSuppDblClick
  end
  object btnGetFirstCust: TButton
    Left = 219
    Top = 16
    Width = 80
    Height = 21
    Caption = 'First Cust'
    TabOrder = 1
    OnClick = btnGetFirstCustClick
  end
  object btnGetPrevCust: TButton
    Left = 219
    Top = 41
    Width = 80
    Height = 21
    Caption = 'Prev Cust'
    TabOrder = 2
    OnClick = btnGetPrevCustClick
  end
  object btnGetNextCust: TButton
    Left = 219
    Top = 66
    Width = 80
    Height = 21
    Caption = 'Next Cust'
    TabOrder = 3
    OnClick = btnGetNextCustClick
  end
  object btnGetLastCust: TButton
    Left = 219
    Top = 91
    Width = 80
    Height = 21
    Caption = 'Last Cust'
    TabOrder = 4
    OnClick = btnGetLastCustClick
  end
  object lstSupp: TListBox
    Left = 308
    Top = 7
    Width = 202
    Height = 359
    ItemHeight = 13
    TabOrder = 5
    OnDblClick = lstSuppDblClick
  end
  object btnGetFirstSupp: TButton
    Left = 517
    Top = 16
    Width = 80
    Height = 21
    Caption = 'First Supp'
    TabOrder = 6
    OnClick = btnGetFirstSuppClick
  end
  object btnGetPrevSupp: TButton
    Left = 517
    Top = 41
    Width = 80
    Height = 21
    Caption = 'Prev Supp'
    TabOrder = 7
    OnClick = btnGetPrevSuppClick
  end
  object btnGetNextSupp: TButton
    Left = 517
    Top = 66
    Width = 80
    Height = 21
    Caption = 'Next Supp'
    TabOrder = 8
    OnClick = btnGetNextSuppClick
  end
  object btnGetLastSupp: TButton
    Left = 517
    Top = 91
    Width = 80
    Height = 21
    Caption = 'Last Supp'
    TabOrder = 9
    OnClick = btnGetLastSuppClick
  end
end
