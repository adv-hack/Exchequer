object frmFunctionWizard: TfrmFunctionWizard
  Left = 136
  Top = 133
  BorderIcons = [biSystemMenu, biHelp]
  BorderStyle = bsDialog
  Caption = 'Function Wizard (1 of 2)'
  ClientHeight = 233
  ClientWidth = 495
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  Position = poScreenCenter
  Scaled = False
  ShowHint = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label81: Label8
    Left = 9
    Top = 6
    Width = 283
    Height = 14
    Caption = 'Choose a function and press NEXT to fill out its arguments:'
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label82: Label8
    Left = 11
    Top = 28
    Width = 91
    Height = 14
    Caption = 'Function Category:'
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label83: Label8
    Left = 160
    Top = 27
    Width = 80
    Height = 14
    Caption = 'Function Names:'
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object lstCategories: TListBox
    Left = 6
    Top = 43
    Width = 144
    Height = 136
    ItemHeight = 13
    TabOrder = 0
    TabWidth = 20
  end
  object ListBox2: TListBox
    Left = 155
    Top = 43
    Width = 332
    Height = 136
    ItemHeight = 13
    Items.Strings = (
      'EntCustBalance'#9'Gets the customers balance'
      'EntCustBudget'#9'gets the customers budget'
      'EntCustCosts'
      'EntCustCredit'
      'EntCustDebit'
      'EntCustMargin'
      'EntCustName'
      'EntCustNetSales'
      'EntCustSaveBudget')
    TabOrder = 1
    TabWidth = 80
  end
  object Button1: TButton
    Left = 56
    Top = 191
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 2
    OnClick = Button1Click
  end
end
