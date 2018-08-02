object frmLicWiz8: TfrmLicWiz8
  Left = 425
  Top = 132
  HelpContext = 1003
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'CD Licencing Wizard - Step 1 of 8'
  ClientHeight = 295
  ClientWidth = 341
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 8
    Top = 3
    Width = 288
    Height = 29
    AutoSize = False
    Caption = 'Customer Details'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -24
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 8
    Top = 34
    Width = 327
    Height = 18
    AutoSize = False
    Caption = 
      'Please enter the details of the company the CD is being issued t' +
      'o:'
    WordWrap = True
  end
  object Bevel2: TBevel
    Left = 7
    Top = 261
    Width = 328
    Height = 2
    Shape = bsBottomLine
  end
  object Label1: TLabel
    Left = 29
    Top = 84
    Width = 44
    Height = 13
    Alignment = taRightJustify
    Caption = 'Company'
    OnClick = Label1Click
  end
  object Label4: TLabel
    Left = 41
    Top = 166
    Width = 31
    Height = 13
    Alignment = taRightJustify
    Caption = 'ESN 1'
    OnClick = Label4Click
  end
  object Label5: TLabel
    Left = 9
    Top = 134
    Width = 287
    Height = 21
    AutoSize = False
    Caption = 'Please enter the Exchequer Site Number for this site:-'
    WordWrap = True
  end
  object Label6: TLabel
    Left = 42
    Top = 109
    Width = 31
    Height = 13
    Alignment = taRightJustify
    Caption = 'Dealer'
  end
  object Label7: TLabel
    Left = 42
    Top = 187
    Width = 31
    Height = 13
    Alignment = taRightJustify
    Caption = 'ESN 2'
  end
  object Label8: TLabel
    Left = 9
    Top = 212
    Width = 287
    Height = 21
    AutoSize = False
    Caption = 'Please specify the Auto-Upgrade Issue Number:-'
    WordWrap = True
  end
  object Label9: TLabel
    Left = 31
    Top = 237
    Width = 42
    Height = 13
    Alignment = taRightJustify
    Caption = 'Issue No'
  end
  object Label10: TLabel
    Left = 26
    Top = 59
    Width = 47
    Height = 13
    Alignment = taRightJustify
    Caption = 'A/C Code'
    OnClick = Label1Click
  end
  object btnNext: TButton
    Left = 257
    Top = 270
    Width = 79
    Height = 21
    Caption = '&Next >>'
    TabOrder = 7
    OnClick = btnNextClick
  end
  object edtCompany: TEdit
    Left = 77
    Top = 81
    Width = 251
    Height = 21
    MaxLength = 45
    TabOrder = 1
  end
  object btnPrevious: TButton
    Left = 170
    Top = 270
    Width = 79
    Height = 21
    Caption = '<< &Previous'
    TabOrder = 6
    OnClick = btnPreviousClick
  end
  object lstDealer: TComboBox
    Left = 77
    Top = 106
    Width = 251
    Height = 21
    ItemHeight = 13
    Sorted = True
    TabOrder = 2
  end
  object meESN1: TMaskEdit
    Left = 77
    Top = 160
    Width = 158
    Height = 21
    EditMask = '999-999-999-999-999-999;1;_'
    MaxLength = 23
    TabOrder = 3
    Text = '   -   -   -   -   -   '
    OnExit = meESN1Exit
  end
  object meESN2: TMaskEdit
    Left = 77
    Top = 183
    Width = 158
    Height = 21
    EditMask = '999-999-999-999-999-999;1;_'
    MaxLength = 23
    TabOrder = 4
    Text = '   -   -   -   -   -   '
    OnExit = meESN2Exit
  end
  object lstIssueNo: TComboBox
    Left = 77
    Top = 234
    Width = 251
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    Sorted = True
    TabOrder = 5
  end
  object edtCode: TEdit
    Left = 77
    Top = 56
    Width = 69
    Height = 21
    CharCase = ecUpperCase
    MaxLength = 6
    TabOrder = 0
  end
end
